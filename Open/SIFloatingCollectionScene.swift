//
//  SIFloatingCollectionScene.swift
//  SIFloatingCollectionExample_Swift
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import SpriteKit

public func distanceBetweenPoints(_ firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
    return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y)
}

@objc public protocol SIFloatingCollectionSceneDelegate {
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, shouldSelectFloatingNodeAtIndex index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, didSelectFloatingNodeAtIndex index: Int)
    
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, shouldDeselectFloatingNodeAtIndex index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, didDeselectFloatingNodeAtIndex index: Int)
    
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, startedRemovingOfFloatingNodeAtIndex index: Int)
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, canceledRemovingOfFloatingNodeAtIndex index: Int)
    
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, shouldRemoveFloatingNodeAtIndex index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SIFloatingCollectionScene, didRemoveFloatingNodeAtIndex index: Int)
}

public enum SIFloatingCollectionSceneMode {
    case normal
    case editing
    case moving
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let MenuNode  : UInt32 = 0x1 << 1       // 1
    static let BubbleNode : UInt32 = 0x2 << 2      // 2
}

public enum SceneState {
    case fullMenu
    case focusMenu
    case actionMenu
}

open class SIFloatingCollectionScene: SKScene {
    fileprivate(set) open var magneticField = SKFieldNode.radialGravityField()
    fileprivate(set) var mode: SIFloatingCollectionSceneMode = .normal {
        didSet {
            modeUpdated()
        }
    }
    
    fileprivate(set) open var floatingNodes: [SIFloatingNode] = []
    fileprivate(set) open var removedMenuNodes : [MenuNode] = []
    fileprivate(set) open var removedBubbleNodes : [BubbleNode] = []
    var currentMenu : [String] = []
    var currentBusinesses : [Business] = []
    
    fileprivate var touchPoint: CGPoint?
    fileprivate var touchStartedTime: TimeInterval?
    fileprivate var removingStartedTime: TimeInterval?
    
    open var timeToStartRemove: TimeInterval = 0.7
    open var timeToRemove: TimeInterval = 2
    open var allowEditing = false
    open var allowMultipleSelection = true
    open var restrictedToBounds = true
    open var pushStrength: CGFloat = 10000
    open weak var floatingDelegate: SIFloatingCollectionSceneDelegate?
    
    override open func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
    }
    
    // MARK: -
    // MARK: Frame Updates
    //@todo refactoring
    override open func update(_ currentTime: TimeInterval) {
        let _ = floatingNodes.map { (node: SKNode) -> Void in
            let distanceFromCenter = distanceBetweenPoints(self.magneticField.position, secondPoint: node.position)
            node.physicsBody?.linearDamping = distanceFromCenter > 100 ? 2 : 2 + ((100 - distanceFromCenter) / 10)
        }
        
        if mode == .moving || !allowEditing {
            return
        }
        
        if let tStartTime = touchStartedTime, let tPoint = touchPoint {
            let dTime = currentTime - tStartTime
            if dTime >= timeToStartRemove {
                touchStartedTime = nil
                if let node = atPoint(tPoint) as? SIFloatingNode {
                    removingStartedTime = currentTime
                    startRemovingNode(node)
                }
            }
        } else if mode == .editing, let tRemovingTime = removingStartedTime, let tPoint = touchPoint {
            let dTime = currentTime - tRemovingTime
            if dTime >= timeToRemove {
                removingStartedTime = nil
                if let node = atPoint(tPoint) as? SIFloatingNode {
                    if let index = floatingNodes.index(of: node) {
                        removeFloatingNodeAtIndex(index)
                    }
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Touching Handlers
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            touchPoint = touch.location(in: self)
            touchStartedTime = touch.timestamp
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .editing {
            return
        }
        
        if let touch = touches.first as UITouch? {
            let plin = touch.previousLocation(in: self)
            let lin = touch.location(in: self)
            var dx = lin.x - plin.x
            var dy = lin.y - plin.y
            let b = sqrt(pow(lin.x, 2) + pow(lin.y, 2))
            dx = b == 0 ? 0 : (dx / b)
            dy = b == 0 ? 0 : (dy / b)
            
            if dx == 0 && dy == 0 {
                return
            } else if mode != .moving {
                mode = .moving
            }
            
            for node in floatingNodes {
                let w = node.frame.size.width / 2
                let h = node.frame.size.height / 2
                var direction = CGVector(
                    dx: CGFloat(self.pushStrength) * dx,
                    dy: CGFloat(self.pushStrength) * dy
                )
                
                if restrictedToBounds {
                    if !(-w...size.width + w ~= node.position.x) && (node.position.x * dx > 0) {
                        direction.dx = 0
                    }
                    
                    if !(-h...size.height + h ~= node.position.y) && (node.position.y * dy > 0) {
                        direction.dy = 0
                    }
                }
                node.physicsBody?.applyForce(direction)
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode != .moving, let touch = touchPoint {
            if let node = atPoint(touch) as? SIFloatingNode {
                updateNodeState(node)
            }
        }
        mode = .normal
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mode = .normal
    }
    
    // MARK: -
    // MARK: Nodes Manipulation
    fileprivate func cancelRemovingNode(_ node: SIFloatingNode!) {
        mode = .normal
        node.physicsBody?.isDynamic = true
        node.state = node.previousState
        if let index = floatingNodes.index(of: node) {
            floatingDelegate?.floatingScene?(self, canceledRemovingOfFloatingNodeAtIndex: index)
        }
    }
    
    open func floatingNodeAtIndex(_ index: Int) -> SIFloatingNode? {
        if index < floatingNodes.count && index >= 0 {
            return floatingNodes[index]
        }
        return nil
    }
    
    open func indexOfSelectedNode() -> Int? {
        var index: Int?
        
        for (idx, node) in floatingNodes.enumerated() {
            if node.state == .selected {
                index = idx
                break
            }
        }
        return index
    }
    
    open func indexOfSelectedNodeWithName(name: String) -> Int? {
        var index: Int?
        
        for (idx, node) in floatingNodes.enumerated() {
           
            if node.state == .selected && node.name == name {
                index = idx
                break
            }
        }
        return index
    }
    
    open func indexesOfSelectedNodes() -> [Int]! {
        var indexes: [Int] = []
        
        for (idx, node) in floatingNodes.enumerated() {
            if node.state == .selected {
                indexes.append(idx)
            }
        }
        return indexes
    }
    
    open func indexesOfNonSelectedNodes() -> [Int]! {
        
        var indexes: [Int] = []
        
        for (idx, node) in floatingNodes.enumerated() {
            indexes.append(idx)
            if node.state == .selected {
                indexes.removeLast()
            }
        }
        
        indexes.sort(by: >)
        return indexes
        
    }
    
    
    
    //MARK: Determine if there is a MenuNode w/ category present
    
    open func menuNodeWithCategoryExists (category: String) -> Bool {
        
        for node in floatingNodes {
            
            guard let n = node as? MenuNode else {
                break
            }
                if n.category == category {
                    return true
                } else {
                    return false
                }
            }
        
        return false
    }
    
    //MARK: find index of children nodes
    func indexesOfChildrenNodes(menuNode: MenuNode) -> [Int]! {
        
        var indexes: [Int] = []
        
        for node in floatingNodes {
            if node.name == menuNode.category {
                if let index = floatingNodes.index(of: node) {
                    indexes.append(index)
                }
            }
        }
        
        indexes.sort(by: >)
        return indexes
        
    }
    
    func indexesOfChildrenNodesWithName(name: String) -> [Int]! {
        
        var indexes: [Int] = []
        
        for node in floatingNodes {
            if node.name == name {
                if let index = floatingNodes.index(of: node) {
                    indexes.append(index)
                }
            }
        }
        
        indexes.sort(by: >)
        return indexes
        
    }
    
    override open func atPoint(_ p: CGPoint) -> SKNode {
        var currentNode = super.atPoint(p)
        
        while !(currentNode.parent is SKScene) && !(currentNode is SIFloatingNode)
            && (currentNode.parent != nil) && !currentNode.isUserInteractionEnabled {
                currentNode = currentNode.parent!
        }
        return currentNode
    }
    
    open func selectNode(_ node: SIFloatingNode) {
        updateNodeState(node)
    }
    
    open func removeFloatingNodeAtIndex(_ index: Int) {
        
        if shouldRemoveNodeAtIndex(index) { // check to see if node is elgible to be removed
            
            let node = floatingNodes[index]
            floatingNodes.remove(at: index)
            node.removeFromParent()
            
            //update model for keeping data for transitions
            if let menuNode = node as? MenuNode {
                let newMenu = currentMenu.filter{ $0 != menuNode.category }
                currentMenu = newMenu
            }
            if let bubNode = node as? BubbleNode {
                let newBusinesses = currentBusinesses.filter{ $0 != bubNode.business }
                currentBusinesses = newBusinesses
            }
            
            //call delegate method
            floatingDelegate?.floatingScene?(self, didRemoveFloatingNodeAtIndex: index)
        }
        
    }
    
    open func removeFloatingNodeAtIndexAddToArray(_ index: Int) {
        if shouldRemoveNodeAtIndex(index) {
            let node = floatingNodes[index]
            floatingNodes.remove(at: index)
            
            if let n = node as? MenuNode {
                removedMenuNodes.append(n)
            }
            if let n = node as? BubbleNode {
                removedBubbleNodes.append(n)
            }
            
            node.removeFromParent()
            floatingDelegate?.floatingScene?(self, didRemoveFloatingNodeAtIndex: index)
        }
    }
    
    open func addRemovedNodes(nodes: [SIFloatingNode]) {
        
        for node in nodes {
            self.reAddChild(node)
        }

        if nodes is [MenuNode] {
            removedMenuNodes.removeAll()
        }
        if nodes is [BubbleNode] {
            removedBubbleNodes.removeAll()
        }
        
    }
    
    open func hideFloatingNodeAtIndex(_ index: Int) {
        let node = floatingNodes[index]
        node.isHidden = true
    }
    
    open func removeNodesOfType(nodeType: SIFloatingNode.Type) {
        
        var indexes: [Int] = []
        
            for (i, node) in floatingNodes.enumerated() {
                let type: AnyClass = type(of: node)
                    if type == nodeType {
                        indexes.append(i)
                    }
            }
        
        indexes.sort(by: >) // we want to remove the nodes with the highest index first
        
        for index in indexes {
            removeFloatingNodeAtIndex(index)
        }
    }
    
    
    
    fileprivate func startRemovingNode(_ node: SIFloatingNode!) {
        mode = .editing
        node.physicsBody?.isDynamic = false
        node.state = .removing
        if let index = floatingNodes.index(of: node) {
            floatingDelegate?.floatingScene?(self, startedRemovingOfFloatingNodeAtIndex: index)
        }
    }
    
    open func hideNonSelectedNodes() {
        guard let nonSelectedNodeIndexes = indexesOfNonSelectedNodes() else {
            print("error returning non selected indexes")
            return
        }
        for index in nonSelectedNodeIndexes {
            hideFloatingNodeAtIndex(index)
        }
        
    }
    
    open func removeNonSelectedNodes() {
        guard let nonSelectedNodeIndexes = indexesOfNonSelectedNodes() else {
            fatalError("error returning non selected indexes")
        }
        for index in nonSelectedNodeIndexes {   
            removeFloatingNodeAtIndex(index)
        }
    }

    func menuNodeWithCategoryExists(node: MenuNode) -> Bool {
        guard let category = node.category else {
            return true
        }
        
            if currentMenu.contains(category) {
                return true
            } else {
                return false
            }
            
        }
    
    fileprivate func updateNodeState(_ node: SIFloatingNode!) {
        if let index = floatingNodes.index(of: node) {
            switch node.state {
            case .normal:
                if shouldSelectNodeAtIndex(index) {
                    
                    if let name = node.name {
                        if let selectedIndex = indexOfSelectedNodeWithName(name: name) {
                            updateNodeState(floatingNodes[selectedIndex])
                        }
                    }
                    
                    //if multiple selection isn't enabled, find the selected node and then update the state of that node
                    if !allowMultipleSelection, let selectedIndex = indexOfSelectedNode() {
                        updateNodeState(floatingNodes[selectedIndex])
                    }
                    node.state = .selected
                    floatingDelegate?.floatingScene?(self, didSelectFloatingNodeAtIndex: index)
                }
            case .selected:
                if shouldDeselectNodeAtIndex(index) {
                    node.state = .normal
                    floatingDelegate?.floatingScene?(self, didDeselectFloatingNodeAtIndex: index)
                }
            case .removing:
                cancelRemovingNode(node)
            }
        }
    }
    
    // MARK: -
    // MARK: Configuration
    override open func addChild(_ node: SKNode) {
        if let child = node as? SIFloatingNode {
            configureNode(child)
            floatingNodes.append(child)
        }
        //node.position = CGPoint(x: 100.0, y: 100.0)
        super.addChild(node)
    }
    
    private func reAddChild(_ node: SKNode) {
        if let child = node as? SIFloatingNode {
            floatingNodes.append(child)
        }
        //node.position = CGPoint(x: 100.0, y: 100.0)
        super.addChild(node)

    }
    
    func addNodeForMenuNode(_ menuNode: MenuNode, childNode: SKNode) {
        if let child = childNode as? SIFloatingNode {
            configureNode(child)
            floatingNodes.append(child)
            
        }
        childNode.position = menuNode.position
        super.addChild(childNode)
    }
    
    func removeChildrenFromMenuNode(_ menuNode: MenuNode) {
        
        guard let indexes = indexesOfChildrenNodes(menuNode: menuNode) else { return }
            for index in indexes {
                removeFloatingNodeAtIndex(index)
            }
    }
    
    fileprivate func configure() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        magneticField = SKFieldNode.radialGravityField()
        magneticField.region = SKRegion(radius: 10000)
        magneticField.minimumRadius = 10000
        magneticField.strength = 8000
        magneticField.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(magneticField)
    }
    
    fileprivate func configureNode(_ node: SIFloatingNode!) {
        if node.physicsBody == nil {
            var path: CGPath = CGMutablePath()
    
            if node.path != nil {
                path = node.path!
            }
            node.physicsBody = SKPhysicsBody(polygonFrom: path)
        }
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.mass = 0.3
        node.physicsBody?.friction = 0
        node.physicsBody?.linearDamping = 3
    }
    
    fileprivate func modeUpdated() {
        switch mode {
        case .normal, .moving:
            touchStartedTime = nil
            removingStartedTime = nil
            touchPoint = nil
        default: ()
        }
    }
    
    // MARK: -
    // MARK: Floating Delegate Helpers
    fileprivate func shouldRemoveNodeAtIndex(_ index: Int) -> Bool {
        if 0...floatingNodes.count - 1 ~= index { //is the index within the array count?
            if let shouldRemove = floatingDelegate?.floatingScene?(self, shouldRemoveFloatingNodeAtIndex: index) {
                return shouldRemove
            }
            return true
        }
        return false
    }
    
    fileprivate func shouldSelectNodeAtIndex(_ index: Int) -> Bool {
        if let shouldSelect = floatingDelegate?.floatingScene?(self, shouldSelectFloatingNodeAtIndex: index) {
            return shouldSelect
        }
        return true
    }
    
    fileprivate func shouldDeselectNodeAtIndex(_ index: Int) -> Bool {
        if let shouldDeselect = floatingDelegate?.floatingScene?(self, shouldDeselectFloatingNodeAtIndex: index) {
            return shouldDeselect
        }
        return true
    }
}
