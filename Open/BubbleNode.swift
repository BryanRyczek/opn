//
//  BubbleNode.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit
import Hue

class BubbleNode: SIFloatingNode {
    var labelNode = SKLabelNode(fontNamed: avenir55)
    var business : Business?
    
    init(business: Business, circleOfRadius: Float) {
        super.init()
        self.business = business
        let p = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -40, y: -40), size: CGSize(width: 80.0, height: 80.0)), transform: nil)
        self.path = p
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
    }
    
    class func instantiate(business: Business) -> BubbleNode! {
        let node = BubbleNode(business: business, circleOfRadius: 80)
        configureNode(node)
        return node
    }
    
    class func configureNode(_ node: BubbleNode!) {
        let boundingBox = node.path?.boundingBox;
        let radius = (boundingBox?.size.width)! / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        //let randomGradient = UIColor(gradientStyle: .radial, withFrame: boundingBox!, andColors: [FlatRed(),FlatRedDark()] )
        node.fillColor = opnRed
            
            //SKColor.black
        node.strokeColor = node.fillColor
        
        node.labelNode.text = node.business?.businessName
        node.labelNode.position = CGPoint.zero
        node.labelNode.fontColor = SKColor.white
        node.labelNode.fontSize = 10
        node.labelNode.isUserInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .center
        node.labelNode.horizontalAlignmentMode = .center
        node.addChild(node.labelNode)
    }
    
    override func selectingAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.scale(to: 1.3, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.scale(to: 1, duration: 0.2)
    }
    
    override func removeAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.fadeOut(withDuration: 0.2)
    }
    
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scale(to: xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scale(to: xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        return repeatPulse
    }
}