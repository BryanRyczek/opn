//
//  OpnBusinessCell.swift
//  Open
//
//  Created by Bryan Ryczek on 11/7/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class OpnBusinessCell: MGSwipeTableCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
