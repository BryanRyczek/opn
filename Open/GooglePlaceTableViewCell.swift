//
//  GooglePlaceTableViewCell.swift
//  
//
//  Created by Bryan Ryczek on 12/15/16.
//
//

import UIKit

// MARK: - GooglePlacesAutocompleteContainer
class GooglePlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var neighborhoodImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var neighborhoodLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    
//    var nameLabel = UILabel()
//    var addressLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.gray
        
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        addressLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        nameLabel.textColor = UIColor.black
//        nameLabel.backgroundColor = UIColor.white
//        nameLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
//        
//        addressLabel.textColor = UIColor(hue: 0.9972, saturation: 0, brightness: 0.54, alpha: 1.0)
//        addressLabel.backgroundColor = UIColor.white
//        addressLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
//        addressLabel.numberOfLines = 0
//        
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(addressLabel)
//        
//        let viewsDict = [
//            "name" : nameLabel,
//            "address" : addressLabel
//        ]
//        
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name]-[address]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[address]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
