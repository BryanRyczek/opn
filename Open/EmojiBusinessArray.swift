//
//  EmojiBusinessArray.swift
//  Open
//
//  Created by Bryan Ryczek on 1/9/17.
//  Copyright © 2017 Bryan Ryczek. All rights reserved.
//

import Foundation

struct EmojiBusinessArray {
    
    var emojiArray : [String]
    var businessArray : [Business]
    var gridArray: [[BusinessRow]]
    
    init(emojiArray: [String], businessArray : [Business]) {
    
    self.businessArray = businessArray
    self.emojiArray = emojiArray
    
    gridArray = [[BusinessRow]]()
        
        for emoji in emojiArray {
            
            var businessRow = BusinessRow(emojiID: emoji)
            
            for business in businessArray {
                
                if business.businessTags.contains(emoji) {
                    businessRow.array.append(business)
                }
                
            }
         gridArray.append([businessRow])
        }
    }
    
}

struct BusinessRow {
    var array: [Business]
    var emojiID: String
    
    init(emojiID: String) {
        self.emojiID = emojiID
        self.array = []
    }
}
