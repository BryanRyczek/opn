//
//  OpnSearchBar.swift
//  Open
//
//  Created by Bryan Ryczek on 12/21/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class OpnSearchBar: UISearchBar {

    var preferredFont = UIFont(name: avenir85, size: 24.0)!
    var preferredTextColor = UIColor.green

    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300.0, height: 100.0)))
        
    }
    
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
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        
        for (i, subview) in searchBarView.subviews.enumerated() {
            if subview.isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0]).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(origin: CGPoint(x: 5.0, y: 5.0), size: CGSize(width: frame.size.width - 10.0, height: frame.size.height - 10.0))
            
            // Set the font and text color of the search field.
            searchField.font = UIFont(name: avenir85, size: 24.0)
            searchField.textColor = opnBlue
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = opnBlue.cgColor
        
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
        
        super.draw(rect)
        
    }
    

}
