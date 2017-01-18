//
//  SpriteKitHelpers.swift
//  Open
//
//  Created by Bryan Ryczek on 1/7/17.
//  Copyright © 2017 Bryan Ryczek. All rights reserved.
//

import Foundation
import SpriteKit

//MARK: Action extension with completion handler
extension SKNode
{
    func run(action: SKAction!, withKey: String!, optionalCompletion:((Void) -> Void)?) {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run(compositeAction, withKey: withKey )
        }
        else
        {
            run( action, withKey: withKey )
        }
    }
    
    func actionForKeyIsRunning(key: String) -> Bool {
        return self.action(forKey: key) != nil ? true : false
    }
}


//MARK: SpriteKit Animations
let pulsedRed = SKAction.sequence([
    SKAction.colorize(with: opnRed, colorBlendFactor: 1.0, duration: 0.15),
    SKAction.wait(forDuration: 0.1),
    SKAction.colorize(withColorBlendFactor: 0.9, duration: 0.05),
    SKAction.wait(forDuration: 0.05),
    SKAction.colorize(withColorBlendFactor: 1.0, duration: 0.05)])
