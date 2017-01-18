//
//  PlaceTableViewCell.swift
//  Open
//
//  Created by Bryan Ryczek on 12/10/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

struct CellBusiness: Equatable {
    var place: GMSPlace
//    var email: String
//    var dateOfBirth: NSDate
//    var pictureUrl: NSURL?
}

func ==(lhs: CellBusiness, rhs: CellBusiness) -> Bool {
    return lhs.place == rhs.place
}

import UIKit
import GooglePlaces
import Eureka

final class PlaceTableViewCell: Cell<CellBusiness>, CellType {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var label: UILabel!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
