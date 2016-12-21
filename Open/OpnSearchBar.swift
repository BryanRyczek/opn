//
//  OpnSearchBar.swift
//  Open
//
//  Created by Bryan Ryczek on 12/21/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class OpnSearchBar: UISearchBar {

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = .prominent
        isTranslucent = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func indexOfSearchFieldInSubviews() -> Int! {
//        var index: Int!
//        let searchBarView = subviews[0] as! UIView
//        
//        for (i, subview) in searchBarView.subviews.enumerated() {
//            if subview.isKind(of: UITextField.self) {
//                index = i
//                break
//            }
//        }
//        
//        return index
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
