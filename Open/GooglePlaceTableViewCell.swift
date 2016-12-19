//
//  GooglePlaceTableViewCell.swift
//  
//
//  Created by Bryan Ryczek on 12/15/16.
//
//

import UIKit
import GooglePlaces

// MARK: - GooglePlacesAutocompleteContainer
class GooglePlaceTableViewCell: UITableViewCell {
    
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var placeIcon: UIImageView!
    @IBOutlet weak var placeIconLabel: UILabel!
    
    @IBOutlet weak var isOpenLabel: UILabel!
    var placeID : String!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.gray
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(placeID: String) {
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: { (place, error) in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                
                jsonForGooglePlaceID(place: place, completionHandler: { (json, error) in
                    
                    //////////
                    let currentDay = Date().dayNumberOfWeek()
                    
                    var open : String = json["result"]["opening_hours"]["periods"][currentDay!]["open"]["time"].stringValue
                    var close : String = json["result"]["opening_hours"]["periods"][currentDay!]["close"]["time"].stringValue
                    open = addColonToGoogleTimeString(open)
                    close = addColonToGoogleTimeString(close)
                    var openDate : Date = firebaseTimeStringToDate(open)
                    var closeDate : Date = firebaseTimeStringToDate(close)
                    closeDate = openBeforeClose(openDate, close: closeDate)
                    if isDateWithinInverval(openDate, close: closeDate) {
                        print("place \(place.name) is Open!")
                        DispatchQueue.main.async {
                            self.isOpenLabel.text = "OPEN!"
                        }
                        
                    } else {
                        print("place \(place.name) is closed!")
                        DispatchQueue.main.async {
                        self.isOpenLabel.text = "Closed!"
                        }
                    }
    
                    print("")
                    
                    
                })
            }
            
        })
    }
}
