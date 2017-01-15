//
//  BubblesScene.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import SpriteKit

extension CGFloat {
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

class BubblesScene: SIFloatingCollectionScene {
    var bottomOffset: CGFloat = 0
    var topOffset: CGFloat = 0
    
    
    var touchPoint: CGPoint? // point where the user touched. needed for touchesBegan, ended, moved etc. overrides
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
    }
    
    fileprivate func configure() {
        backgroundColor = SKColor.white
        scaleMode = .aspectFill
        allowMultipleSelection = true
        var bodyFrame = frame
        bodyFrame.size.width = CGFloat(magneticField.minimumRadius)
        bodyFrame.origin.x -= bodyFrame.size.width / 2
        bodyFrame.size.height = frame.size.height - bottomOffset
        bodyFrame.origin.y = frame.size.height - bodyFrame.size.height - topOffset
        physicsBody = SKPhysicsBody(edgeLoopFrom: bodyFrame)
        magneticField.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 + bottomOffset / 2 - topOffset)
    }
    
    override func addChild(_ node: SKNode) {
        if node is BubbleNode {
            var x = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let y = CGFloat.random(
                min: frame.size.height - bottomOffset - node.frame.size.height,
                max: frame.size.height - topOffset - node.frame.size.height
            )
            
            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                x = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }
            node.position = CGPoint(x: x, y: y)
        }
        super.addChild(node)
    }
    
    func performCommitSelectionAnimation() {
        physicsWorld.speed = 0
        let sortedNodes = sortedFloatingNodes()
        var actions: [SKAction] = []
        
        for node in sortedNodes! {
            node.physicsBody = nil
            let action = actionForFloatingNode(node)
            actions.append(action)
        }
        run(SKAction.sequence(actions))
    }
    
    func throwNode(_ node: SKNode, toPoint: CGPoint, completion block: (() -> Void)!) {
        node.removeAllActions()
        let movingXAction = SKAction.moveTo(x: toPoint.x, duration: 0.2)
        let movingYAction = SKAction.moveTo(y: toPoint.y, duration: 0.4)
        let resize = SKAction.scale(to: 0.3, duration: 0.4)
        let throwAction = SKAction.group([movingXAction, movingYAction, resize])
        node.run(throwAction)
    }
    
    func distanceToCenter(node: SKNode, scene: SKScene) -> CGPoint {
        
        let sceneCenter : CGPoint = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
        let nodeCenter = node.position
        let xDiff = sceneCenter.x - nodeCenter.x
        let yDiff = sceneCenter.y - nodeCenter.y
        let distanceToCenter : CGPoint = CGPoint(x: xDiff, y: yDiff)
        return distanceToCenter
    }
    
    func centerMenuNodeForBubbleNodeAction (parentNode: MenuNode, childNode: BubbleNode) -> SKAction {
        
        let movingXAction = SKAction.moveTo(x: size.width / 2, duration: 0.2)
        let movingYAction = SKAction.moveTo(y: size.height / 2 - parentNode.frame.size.height, duration: 0.4)
        let resize = SKAction.scale(to: 1.3, duration: 0.4)
        let centerAction = SKAction.group([movingXAction, movingYAction, resize])
        return centerAction
    }
    
    func centerNodeAction (node: SKNode) -> SKAction {
        
        let movingXAction = SKAction.moveTo(x: size.width / 2, duration: 0.2)
        let movingYAction = SKAction.moveTo(y: size.height / 2, duration: 0.4)
        let resize = SKAction.scale(to: 1.3, duration: 0.4)
        let centerAction = SKAction.group([movingXAction, movingYAction, resize])
        return centerAction
    }
    
    func centerChildNode (point: CGPoint) -> SKAction {
        
        let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
        let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
        let centerAction = SKAction.group([movingXAction, movingYAction])
        return centerAction
        
    }
    
    func sortedFloatingNodes() -> [SIFloatingNode]! {
        let sortedNodes = floatingNodes.sorted { (node: SIFloatingNode, nextNode: SIFloatingNode) -> Bool in
            let distance = distanceBetweenPoints(node.position, secondPoint: self.magneticField.position)
            let nextDistance = distanceBetweenPoints(nextNode.position, secondPoint: self.magneticField.position)
            return distance < nextDistance && node.state != .selected
        }
        return sortedNodes
    }
    
    func actionForFloatingNode(_ node: SIFloatingNode!) -> SKAction {
        let action = SKAction.run({ () -> Void in
            if let index = self.floatingNodes.index(of: node) {
                self.removeFloatingNodeAtIndex(index)
                if node.state == .selected {
                    self.throwNode(
                        node,
                        toPoint: CGPoint(x: self.size.width / 2, y: self.size.height + 40),
                        completion: {
                            node.removeFromParent()
                        }
                    )
                }
            }
        })
        return action
    }


}

