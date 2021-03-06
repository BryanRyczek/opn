//
//  MenuNode.swift
//  Open
//
//  Created by Bryan Ryczek on 1/2/17.
//  Copyright © 2017 Bryan Ryczek. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit
import Hue

open class MenuNode: SIFloatingNode {
    
    var labelNode = SKLabelNode(fontNamed: avenir55)
    var category : String?
    
    init(category: String, circleOfRadius: Float) {
        super.init()
        self.category = category
        let p = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -40, y: -40), size: CGSize(width: 80.0, height: 80.0)), transform: nil)
        self.path = p
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
    }
    
    class func instantiate(category: String) -> MenuNode! {
        let node = MenuNode(category: category, circleOfRadius: 80)
        configureNode(node)
        return node
    }
    
    class func configureNode(_ node: MenuNode!) {
        let boundingBox = node.path?.boundingBox
        let radius = (boundingBox?.size.width)! / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.physicsBody?.categoryBitMask = PhysicsCategory.MenuNode
        //let randomGradient = UIColor(gradientStyle: .radial, withFrame: boundingBox!, andColors: [FlatRed(),FlatRedDark()] )
        
        node.fillColor = .white
        node.strokeColor = UIColor.randomColor()
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "clear100x100"))
        let gradientColors = [opnRed, opnBlue]
        
        let blending : Float = 0.0
        
        let firstCenter = CGPoint(x: 0.0, y: 0.0)
        let firstRadius : Float = 0.1
        
        let secondCenter = CGPoint(x: 0.2, y: 0.2)
        let secondRadius : Float = 0.4
        
        if let path = node.path {
        
        let nodeSize = CGSize(width: path.boundingBox.width, height: path.boundingBox.height)
        
//        let spriteNode = BDGradientNode(radialGradientWithTexture: texture,
//                                        colors: gradientColors,
//                                        locations: nil,
//                                        firstCenter: firstCenter,
//                                        firstRadius: firstRadius,
//                                        secondCenter: secondCenter,
//                                        secondRadius: secondRadius,
//                                        blending: blending,
//                                        discardOutsideGradient: true,
//                                        keepTextureShape: false,
//                                        size: nodeSize)
//        
//        node.isUserInteractionEnabled = true
//        node.addChild(spriteNode)
//            
        }
        
        node.labelNode.text = node.category
        node.labelNode.position = CGPoint.zero
        node.labelNode.fontColor = node.strokeColor
        if (node.labelNode.text?.containsEmoji)! {
            node.labelNode.fontSize = 35
        } else {
            node.labelNode.fontSize = 12
        }
        
        node.labelNode.isUserInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .center
        node.labelNode.horizontalAlignmentMode = .center
        node.addChild(node.labelNode)
    }
    
    
    fileprivate func configureChildNode(_ node: SIFloatingNode!) {
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
    
    override open func selectingAnimation() -> SKAction? {
        removeAction(forKey: MenuNode.removingKey)
        return SKAction.scale(to: 1.3, duration: 0.2)
    }
    
    override open func normalizeAnimation() -> SKAction? {
        removeAction(forKey: MenuNode.removingKey)
        return SKAction.scale(to: 1, duration: 0.2)
    }
    
    override open func removeAnimation() -> SKAction? {
        removeAction(forKey: MenuNode.removingKey)
        return SKAction.fadeOut(withDuration: 0.2)
    }
    
    override open func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scale(to: xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scale(to: xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        return repeatPulse
    }

    
}
