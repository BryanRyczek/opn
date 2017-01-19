//
//  PhoneNode.swift
//  Open
//
//  Created by Bryan Ryczek on 1/17/17.
//  Copyright © 2017 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Hue

open class PhoneNode: SIFloatingNode {
    
    var labelNode = SKLabelNode(fontNamed: avenir55)
    var phoneNumber : String?
    
    init(phoneNumber: String, circleOfRadius: Float) {
        super.init()
        self.phoneNumber = phoneNumber
        let p = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -40, y: -40), size: CGSize(width: 80.0, height: 80.0)), transform: nil)
        self.path = p
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
    }
    
    class func instantiate(node: BubbleNode) -> PhoneNode! {
        guard let biz = node.business else { return nil }
        let node = PhoneNode(phoneNumber: biz.phoneNumber, circleOfRadius: 30)
        
        configureNode(node)
        return node
    }
    
    class func instantiate(name: String) -> PhoneNode! {
        let node = PhoneNode(phoneNumber: name, circleOfRadius: 30)
        configureNode(node)
        return node
    }
    
    class func configureNode(_ node: PhoneNode!) {
        let boundingBox = node.path?.boundingBox;
        let radius = (boundingBox?.size.width)! / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.physicsBody?.categoryBitMask = PhysicsCategory.BubbleNode
        node.strokeColor = .black
        
        node.labelNode.text = node.phoneNumber
        node.labelNode.position = CGPoint.zero
        node.labelNode.fontColor = SKColor.black
        node.labelNode.fontSize = 10
        node.labelNode.isUserInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .center
        node.labelNode.horizontalAlignmentMode = .center
        node.addChild(node.labelNode)
    }

    override open func selectingAnimation() -> SKAction? {
        removeAction(forKey: PhoneNode.removingKey)
        return SKAction.scale(to: 1.3, duration: 0.2)
    }
    
    override open func normalizeAnimation() -> SKAction? {
        removeAction(forKey: PhoneNode.removingKey)
        return SKAction.scale(to: 1, duration: 0.2)
    }
    
    override open func removeAnimation() -> SKAction? {
        removeAction(forKey: PhoneNode.removingKey)
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
