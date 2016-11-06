//
//  HoursButton.swift
//  Open
//
//  Created by Bryan Ryczek on 10/27/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class HoursButton: UIButton {

    var ampm: Int = 0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func toggleState() {
       
        switch ampm {
            case 0: //AM
                ampm += 1
            case 1: //PM
                ampm -= 1
            default:
                break
            }
        
    }
    
}
