//
//  GooglePlaceTableViewCell.swift
//  
//
//  Created by Bryan Ryczek on 12/15/16.
//
//

import UIKit
import GooglePlaces
import FirebaseDatabase

// MARK: - GooglePlacesAutocompleteContainer
class GooglePlaceTableViewCell: UITableViewCell {
    
    lazy var ref = FIRDatabase.database().reference(withPath: "placeid")
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet weak var placeIcon: UIImageView!
    @IBOutlet weak var placeIconLabel: UILabel!
    
    @IBOutlet weak var isOpenLabel: UILabel!
    var placeID : String!
    
    var firebaseBusiness : Business?
    
    func updateWithBusiness(business : Business) {
        
        firebaseBusiness = business
        nameLabel.text = business.businessName
        //secondaryLabel.text =
        placeIconLabel.text = business.neighborhood
        if business.isOpen == true {
            self.isOpenLabel.text = "OPEN"
        } else {
            self.isOpenLabel.text = "Closed!"
        }

        
    }
    
    func updateBusiness(placeID: String, completion: @escaping (_ result: Business) -> Void) {
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: { (place, error) in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                jsonForGooglePlaceID(place: place, completionHandler: { (json, error) in
                    
                    let business = businessFromPlaceAndJSON(place: place, json: json)
                    
                    completion(business)
                    
                })
            }
            
        })
        
    }

    
    func update(placeID: String) {
        
//        ref.queryOrdered(byChild: placeID).observe(.value, with: { (snapshot) in
//            
//            for item in snapshot.children {
//                let business = Business(snapshot: item as! FIRDataSnapshot)
//                
//                if business.placeID == placeID {
//                    print("samesies")
//                    self.firebaseBusiness = business
//                    print(self.firebaseBusiness?.businessName)
//                }
//                
//                if let biz = self.firebaseBusiness {
//                    
//                    self.updateWithBusiness(business: biz)
//                    
//                    return
//                }
//             
//                
//                
//            }
//            
//        })
        
        
        GMSPlacesClient.shared().lookUpPlaceID(placeID, callback: { (place, error) in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                jsonForGooglePlaceID(place: place, completionHandler: { (json, error) in
                    
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
                            
                        }
                        
                    } else {
                        print("place \(place.name) is closed!")
                        DispatchQueue.main.async {
                        self.isOpenLabel.text = "Closed!"
                        }
                    }
    
                    let business = businessFromPlaceAndJSON(place: place, json: json)
                    self.firebaseBusiness = business
                    
                    if business.isOpen {
                        self.isOpenLabel.text = "OPEN!"
                    } else {
                        self.isOpenLabel.text = "CLOSED!"
                    }
                    
                    
                })
            }
            
        })
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
