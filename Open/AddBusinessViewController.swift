//
//  AddBusinessViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/17/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import Eureka
//import PostalAddressRow
import FirebaseDatabase
import GooglePlaces
import SwiftyJSON

class AddBusinessViewController: FormViewController {

    //MARK: URL Request
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    var phase = 0
    
    lazy var selectedPlace = GMSPlace()
    
    //Mark: Firebase components
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    var items : [Business] = []
    
    //MARK: vars for storing information to send to Firebase when all is complete :)
    lazy var businessName = String()
    lazy var contactName = String()
    lazy var password = String()
    lazy var businessTypeOne = String()
    lazy var businessTypeTwo = String()
    lazy var businessTypeThree = String()
    lazy var mondayOpen = String()
    lazy var mondayClose = String()
    lazy var tuesdayOpen = String()
    lazy var tuesdayClose = String()
    lazy var wednesdayOpen = String()
    lazy var wednesdayClose = String()
    lazy var thursdayOpen = String()
    lazy var thursdayClose = String()
    lazy var fridayOpen = String()
    lazy var fridayClose = String()
    lazy var saturdayOpen = String()
    lazy var saturdayClose = String()
    lazy var sundayOpen = String()
    lazy var sundayClose = String()
    lazy var streetAddressOne = String()
    lazy var streetAddressTwo = String()
    lazy var city = String()
    lazy var state = String()
    lazy var zipCode = String()
    lazy var phoneNumber = String()
    lazy var website = String()
    lazy var email = String()
    lazy var businessDescription = String()
    
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func jsonForGooglePlaceID (place: GMSPlace) {
        
       
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let placeID = place.placeID
    
        let appKey = "AIzaSyDZTCAf9pXnDcMGHu1Qan8cSk68sTVQPm4" //MARK: This is the webservice Google Key, NOT the iOS app key!
        let urlString : String = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place.placeID + "&key=" + appKey
        let url = NSURL(string: urlString)
        
        dataTask = defaultSession.dataTask(with: url! as URL) {
            (data, response, error) in
           
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                // now we have the todo, let's just print it to prove we can access it
                //print("The todo is: " + todo.description)
                
                let  json = JSON(data: data!)
                
                DispatchQueue.main.async(){
                   self.setValuesFromGooglePlaceAndJSON(place: place, json: json)
                }

                
                // the todo object is a dictionary
        
            } catch {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        
        dataTask?.resume()
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = opnRed
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name: avenir85, size: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
            defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        PhoneRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
            defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        ZipCodeRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
             defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        URLRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
             defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        NameRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
             defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
             defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 18)
            defaultTextFieldCellUpdate(cell: cell, row:row)
        }
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 30)
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = opnBlue
        }
        
        form = Section ("Save time by searching for your business, or enter your business's information manually.") {
            $0.tag = "99"
            }
            <<< ButtonRow("SearchForBusiness") {
                $0.tag = "search"
                $0.title = "Search For Your Business"
                $0.validationOptions = .validatesOnBlur
            }
                .onCellSelection({ cell, row in
                    self.autocompleteClicked()
                    
            })
            <<< ButtonRow("Enter") {
                $0.tag = "manual"
                $0.title = "Enter Manually"
                $0.validationOptions = .validatesOnBlur
                }
                .onCellSelection({ cell, row in
                    print("Search")
                    
                })


            
            +++ Section("Help Opn stay in touch with you") {
            $0.tag = "0"
            $0.hidden = true
            }
            //MARK:
            <<< NameRow("contactName") {
                $0.title = "Contact Name"
                $0.placeholder = "Contact Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            //MARK:
            <<< EmailRow("email") {
                $0.title = "Contact Email"
                $0.placeholder = "Contact Email"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.placeholder = "Password"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
            
            
            
            //MARK:
            +++ Section("Entering accurate information helps customers find your business"){
                $0.tag = "1"
                $0.hidden = true
            }
            <<< TextRow("businessName") {
                $0.title = "Business Name"
                $0.placeholder = "Business Name"
                $0.tag = "businessName"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = opnRed
                }
            }
        .onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = LabelRow() {
                        $0.title = validationMsg
                        $0.cell.height = { 30 }
                        }
                    row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                    }
                }
            }
                       //MARK:
            <<< TextRow("streetAddressOne") {
                $0.title = "Street Address"
                $0.placeholder = "Street Address"
                $0.tag = "streetAddressOne"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            //MARK:
            <<< TextRow("streetAddressTwo") {
                $0.title = "Street Address 2"
                $0.tag = "streetAddressTwo"
                $0.placeholder = "Optional"
            }
            //MARK:
            <<< TextRow("city") {
                $0.title = "City"
                $0.placeholder = "City"
                $0.tag = "city"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            //MARK:
            <<< TextRow("state") {
                $0.title = "State"
                $0.tag = "state"
                $0.placeholder = "State"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
            //MARK:
            <<< ZipCodeRow("zipCode") {
                $0.title = "Zip Code"
                $0.placeholder = "Zip Code"
                $0.tag = "zipCode"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            //MARK:
            <<< PhoneRow("businessNumber") {
                $0.title = "Business Number 📞"
                $0.tag = "businessNumber"
                $0.placeholder = "555.555.5555"
            }
            //MARK:
            <<< URLRow("website") {
                $0.title = "Website"
                $0.tag = "website"
                //$0.add(rule: RuleURL())
                $0.validationOptions = .validatesOnBlur
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = opnRed
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }

            <<< TextAreaRow("businessCategory") {
                $0.title = "Business Category"
                $0.tag = "description"
                $0.placeholder = "Let Customers know what type of business you have."
            }
            +++ Section("Let Customers know what days you are open.") {
                $0.tag = "2"
                $0.hidden = true
            }
                <<< WeekDayRow("weekDayRow") {
                    $0.value = []
                    $0.title = "YEEHAW"
                }
            +++ Section("Let customers know your business hours.") {
                $0.tag = "3"
                $0.hidden = true
            }
            <<< TimeRow("sundayOpen") {
                    $0.title = "Sunday Open"
                    $0.tag = "sundayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.sunday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("sundayClose") {
                    $0.title = "Sunday Close"
                    $0.tag = "sundayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.sunday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("mondayOpen") {
                    $0.title = "Monday Open"
                    $0.tag = "mondayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.monday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                    
                }
                <<< TimeRow("mondayClose") {
                    $0.title = "Monday Close"
                    $0.tag = "mondayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.monday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("tuesdayOpen") {
                    $0.title = "Tuesday Open"
                    $0.tag = "tuesdayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.tuesday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("tuesdayClose") {
                    $0.title = "Tuesday Close"
                    $0.tag = "tuesdayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.tuesday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("wednesdayOpen") {
                    $0.title = "Wednesday Open"
                    $0.tag = "wednesdayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.wednesday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("wednesdayClose") {
                    $0.title = "Wednesday Close"
                    $0.tag = "wednesdayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.wednesday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("thursdayOpen") {
                    $0.title = "Thursday Open"
                    $0.tag = "thursdayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.thursday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("thursdayClose") {
                    $0.title = "Thursday Close"
                    $0.tag = "thursdayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.thursday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("fridayOpen") {
                    $0.title = "Friday Open"
                    $0.tag = "fridayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.friday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("fridayClose") {
                    $0.title = "Friday Close"
                    $0.tag = "fridayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.friday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("saturdayOpen") {
                    $0.title = "Saturday Open"
                    $0.tag = "saturdayOpen"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.saturday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
                <<< TimeRow("saturdayClose") {
                    $0.title = "Saturday Close"
                    $0.tag = "saturdayClose"
                    $0.minuteInterval = 5
                    $0.hidden = Condition.function(["weekDayRow"], { form in
                        let values = (form.rowBy(tag: "weekDayRow") as? WeekDayRow)?.value
                        if (values?.contains(WeekDay.saturday))! {
                            return false
                        } else {
                            return true
                        }
                    })
                }
       +++ Section {
            $0.tag = "4"
            $0.hidden = true
            }
        <<< ButtonRow("EnterButtonRow") {
            $0.tag = "enterButton"
            $0.hidden = false
            $0.title = "Add Info!"
            $0.validationOptions = .validatesOnBlur
            }
        .onCellSelection({ cell, row in
            
            let valuesDictionary = self.form.values()
            print(valuesDictionary)
            switch self.phase {
                case 0:
                    //If let handling for optionals
//                    if let sa2 = valuesDictionary["streetAddressTwo"] as? String ?? nil {
//                        self.streetAddressTwo = sa2.makeFirebaseString()
//                    } else {
//                        self.streetAddressTwo = ""
//                    }
//                    
//                    if let ph = valuesDictionary["businessNumber"] as? String ?? nil {
//                        self.phoneNumber = ph.makeFirebaseString()
//                    } else {
//                        self.phoneNumber = ""
//                    }
                    
                    if let w = valuesDictionary["website"] as? String ?? nil {
                        self.website = w.makeFirebaseString()
                    } else {
                        self.website = ""
                    }
                    
                    if let des = valuesDictionary["businessCategory"] as? String ?? nil {
                        self.businessDescription = des.makeFirebaseString()
                    } else {
                        self.businessDescription = ""
                    }
                    
                    guard let cn = valuesDictionary["contactName"] as? String ?? nil,
                        let pw = valuesDictionary["password"] as? String ?? nil,
                        let em = valuesDictionary["email"] as? String ?? nil,
                        let bn = valuesDictionary["businessName"] as? String ?? nil,
                        let sa1 = valuesDictionary["streetAddressOne"] as? String ?? nil,
                        let cty = valuesDictionary["city"] as? String ?? nil,
                        let st = valuesDictionary["state"] as? String ?? nil,
                        let z = valuesDictionary["zipCode"] as? String ?? nil
                        else {
                            let alert = UIAlertController(title: "More Information Needed!", message: "Please fill out all the required fields!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.show(alert, sender: self)
                            return
                    }
                    
                    self.contactName = cn.makeFirebaseString()
                    self.password = pw.makeFirebaseString()
                    self.email = em.makeFirebaseString()
                    self.businessName = bn.makeFirebaseString()
                    self.streetAddressOne = sa1.makeFirebaseString()
                    self.city = cty.makeFirebaseString()
                    self.state = st.makeFirebaseString()
                    self.zipCode = z.makeFirebaseString()
            
                    let section0 = self.form.sectionBy(tag: "0")
                    section0?.hidden = true
                    section0?.evaluateHidden()
                    let section1 = self.form.sectionBy(tag: "1")
                    section1?.hidden = true
                    section1?.evaluateHidden()
                    let section2 = self.form.sectionBy(tag: "2")
                    section2?.hidden = false
                    section2?.evaluateHidden()
                    let section3 = self.form.sectionBy(tag: "3")
                    section3?.hidden = false
                    section3?.evaluateHidden()
                    let button = self.form.rowBy(tag: "enterButton")
                    button?.title = "Add Hours!"
                    self.phase += 1
            case 1:
                    //If let handling for optionals
                   
                    if let suO = valuesDictionary["sundayOpen"] as? Date ?? nil {
                        self.sundayOpen = suO.stringify().makeFirebaseString()
                    } else {
                        self.sundayOpen = ""
                    }

                    if let suC = valuesDictionary["sundayClose"] as? Date ?? nil {
                        self.sundayClose = suC.stringify().makeFirebaseString()
                    } else {
                        self.sundayClose = ""
                    }

                    if let mO = valuesDictionary["mondayOpen"] as? Date ?? nil {
                        self.mondayOpen = mO.stringify().makeFirebaseString()
                    } else {
                        self.mondayOpen = ""
                    }

                    if let mC = valuesDictionary["mondayClose"] as? Date ?? nil {
                        self.mondayClose = mC.stringify().makeFirebaseString()
                    } else {
                        self.mondayClose = ""
                    }
                    
                    if let tuO = valuesDictionary["tuesdayOpen"] as? Date ?? nil {
                        self.tuesdayOpen = tuO.stringify().makeFirebaseString()
                    } else {
                        self.tuesdayOpen = ""
                    }

                    if let tuC = valuesDictionary["tuesdayClose"] as? Date ?? nil {
                        self.tuesdayClose = tuC.stringify().makeFirebaseString()
                    } else {
                        self.tuesdayClose = ""
                    }

                    if let wO = valuesDictionary["wednesdayOpen"] as? Date ?? nil {
                        self.wednesdayOpen = wO.stringify().makeFirebaseString()
                    } else {
                        self.wednesdayOpen = ""
                    }

                    if let wC = valuesDictionary["wednesdayClose"] as? Date ?? nil {
                        self.wednesdayClose = wC.stringify().makeFirebaseString()
                    } else {
                        self.wednesdayClose = ""
                    }
                    
                    if let thO = valuesDictionary["thursdayOpen"] as? Date ?? nil {
                        self.thursdayOpen = thO.stringify().makeFirebaseString()
                    } else {
                        self.thursdayOpen = ""
                    }

                    if let thC = valuesDictionary["thursdayClose"] as? Date ?? nil {
                        self.thursdayClose = thC.stringify().makeFirebaseString()
                    } else {
                        self.thursdayClose = ""
                    }

                    if let fO = valuesDictionary["fridayOpen"] as? Date ?? nil {
                        self.fridayOpen = fO.stringify().makeFirebaseString()
                    } else {
                        self.fridayOpen = ""
                    }

                    if let fC = valuesDictionary["fridayClose"] as? Date ?? nil {
                        self.fridayClose = fC.stringify().makeFirebaseString()
                    } else {
                        self.fridayClose = ""
                    }
                    
                    if let saO = valuesDictionary["saturdayOpen"] as? Date ?? nil {
                        self.saturdayOpen = saO.stringify().makeFirebaseString()
                    } else {
                        self.saturdayOpen = ""
                    }

                    if let saC = valuesDictionary["saturdayClose"] as? Date ?? nil {
                        self.saturdayClose = saC.stringify().makeFirebaseString()
                    } else {
                        self.saturdayClose = ""
                    }
                
                    let section2 = self.form.sectionBy(tag: "2")
                    section2?.hidden = true
                    section2?.evaluateHidden()
                    let section3 = self.form.sectionBy(tag: "3")
                    section3?.hidden = true
                    section3?.evaluateHidden()
                    let button = self.form.rowBy(tag: "enterButton")
                    button?.title = "Add My Business to Opn!"
                    self.phase += 1
                    self.saveBusiness()
                    self.performSegue(withIdentifier: "addBizShowOpn", sender: self)
            case 2:
                print("Hey hey")
            default:
                break
            }
                   })
                //            <<< EmailRow() {
//                $0.title = "Email Rule"
//                $0.add(rule: RuleRequired())
//                $0.add(rule: RuleEmail())
//                $0.validationOptions = .validatesOnChangeAfterBlurred
//                }
//                .cellUpdate { cell, row in
//                    if !row.isValid {
//                        cell.titleLabel?.textColor = opnRed
//                    }
//                }
//                .onRowValidationChanged { cell, row in
//                    let rowIndex = row.indexPath!.row
//                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
//                        row.section?.remove(at: rowIndex + 1)
//                    }
//                    if !row.isValid {
//                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
//                            let labelRow = LabelRow() {
//                                $0.title = validationMsg
//                                $0.cell.height = { 30 }
//                            }
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
//                        }
//                    }
//        }
        
        // Do any additional setup after loading the view.
    }

    func saveBusiness() {
                let business = Business(businessName: businessName,
                                        contactName: contactName,
                                        password: password,
                                        businessTypeOne: businessTypeOne,
                                        businessTypeTwo: businessTypeTwo,
                                        businessTypeThree: businessTypeThree,
                                        mondayOpen: mondayOpen,
                                        mondayClose: mondayClose,
                                        tuesdayOpen: tuesdayOpen,
                                        tuesdayClose: tuesdayClose,
                                        wednesdayOpen: wednesdayOpen,
                                        wednesdayClose: wednesdayClose,
                                        thursdayOpen: thursdayOpen,
                                        thursdayClose: thursdayClose,
                                        fridayOpen: fridayOpen,
                                        fridayClose: fridayClose,
                                        saturdayOpen: saturdayOpen,
                                        saturdayClose: saturdayClose,
                                        sundayOpen: sundayOpen,
                                        sundayClose: sundayClose,
                                        addressLineOne: streetAddressOne,
                                        addressLineTwo: streetAddressTwo,
                                        city: city,
                                        state: state,
                                        zip: zipCode,
                                        phoneNumber: phoneNumber,
                                        website: website,
                                        email: email,
                                        businessDescription: businessDescription)
        
        let businessRef = self.ref.child(businessName.lowercased())
        businessRef.setValue(business.toAnyObject())
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

func defaultTextFieldCellUpdate<T0: TextFieldCell, T1:FieldRowConformance>(cell: T0, row: T1) -> () {
    let title = (row as! BaseRow).title
    
    cell.textField.font = UIFont(name: avenir65, size: 18)
    
    if (title != nil ) && (row.placeholder == nil){
        let placeholder = ""
        cell.textField.placeholder = placeholder
        
    }
    
    if let label : UILabel = cell.textField.value(forKeyPath: "_placeholderLabel") as? UILabel {
//        guard label.isKind(of: UILabel) else {
//            return
//        }
        label.font = UIFont(name: avenir85, size: 18)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .none
    }
}

//MARK: Custom Rows

//MARK: WeekDayRow

//MARK: WeeklyDayCell

public enum WeekDay {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public class WeekDayCell : Cell<Set<WeekDay>>, CellType {
    
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    open override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .none
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), for: .selected)
                button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    }
    
    open override func update() {
        row.title = nil
        super.update()
        let value = row.value
        mondayButton.isSelected = value?.contains(.monday) ?? false
        tuesdayButton.isSelected = value?.contains(.tuesday) ?? false
        wednesdayButton.isSelected = value?.contains(.wednesday) ?? false
        thursdayButton.isSelected = value?.contains(.thursday) ?? false
        fridayButton.isSelected = value?.contains(.friday) ?? false
        saturdayButton.isSelected = value?.contains(.saturday) ?? false
        sundayButton.isSelected = value?.contains(.sunday) ?? false
        
        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }
    
    @IBAction func dayTapped(_ sender: UIButton) {
        dayTapped(sender, day: getDayFromButton(sender))
    }
    
    private func getDayFromButton(_ button: UIButton) -> WeekDay{
        switch button{
        case sundayButton:
            return .sunday
        case mondayButton:
            return .monday
        case tuesdayButton:
            return .tuesday
        case wednesdayButton:
            return .wednesday
        case thursdayButton:
            return .thursday
        case fridayButton:
            return .friday
        default:
            return .saturday
        }
    }
    
    private func dayTapped(_ button: UIButton, day: WeekDay){
        button.isSelected = !button.isSelected
        if button.isSelected{
            row.value?.insert(day)
            switch button{
            case sundayButton:
                 sundayLabel.text = "OPEN!"
            case mondayButton:
                mondayLabel.text = "OPEN!"
            case tuesdayButton:
                tuesdayLabel.text = "OPEN!"
            case wednesdayButton:
                wednesdayLabel.text = "OPEN!"
            case thursdayButton:
                thursdayLabel.text = "OPEN!"
            case fridayButton:
                fridayLabel.text = "OPEN!"
            case saturdayButton:
                saturdayLabel.text = "OPEN!"
            default:
                sundayLabel.text = "OPEN!"
            }
        }
        else{
            switch button{
            case sundayButton:
                sundayLabel.text = "CLOSED!"
            case mondayButton:
                mondayLabel.text = "CLOSED!"
            case tuesdayButton:
                tuesdayLabel.text = "CLOSED!"
            case wednesdayButton:
                wednesdayLabel.text = "CLOSED!"
            case thursdayButton:
                thursdayLabel.text = "CLOSED!"
            case fridayButton:
                fridayLabel.text = "CLOSED!"
            case saturdayButton:
                saturdayLabel.text = "CLOSED!"
            default:
               sundayLabel.text = "CLOSED!"
            }

            _ = row.value?.remove(day)
        }
    }
    
    private func imageTopTitleBottom(_ button : UIButton){
        
        guard let imageSize = button.imageView?.image?.size else { return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
        let titleSize = title.size(attributes: [NSFontAttributeName: titleLabel.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
    
}

public final class WeekDayRow: Row<WeekDayCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
}

extension AddBusinessViewController {
    func setValuesFromGooglePlaceAndJSON (place: GMSPlace, json: JSON) {
        
        let section99 = self.form.sectionBy(tag: "99")
        section99?.hidden = false
        section99?.evaluateHidden()
        let section0 = self.form.sectionBy(tag: "0")
        section0?.hidden = false
        section0?.evaluateHidden()
        let section1 = self.form.sectionBy(tag: "1")
        section1?.hidden = false
        section1?.evaluateHidden()
        let section4 = self.form.sectionBy(tag: "4")
        section4?.hidden = false
        section4?.evaluateHidden()
        
        let businessNameRow : TextRow? = self.form.rowBy(tag: "businessName")
        let streetAddressOneRow : TextRow? = self.form.rowBy(tag: "streetAddressOne")
        let streetAddressTwoRow : TextRow? = self.form.rowBy(tag: "streetAddressTwo")
        let cityRow : TextRow? = self.form.rowBy(tag: "city")
        let stateRow : TextRow? = self.form.rowBy(tag: "state")
        let zipCodeRow : ZipCodeRow? = self.form.rowBy(tag: "zipCode")
        let businessNumberRow : PhoneRow? = self.form.rowBy(tag: "businessNumber")
        let websiteRow : URLRow? = self.form.rowBy(tag: "website")
        let descriptionRow : TextRow? = self.form.rowBy(tag: "description")
        let mondayOpenRow : TimeRow? = self.form.rowBy(tag: "mondayOpen")
        let mondayCloseRow : TimeRow? = self.form.rowBy(tag: "mondayClose")
        let tuesdayOpenRow : TimeRow? = self.form.rowBy(tag: "tuesdayOpen")
        let tuesdayCloseRow : TimeRow? = self.form.rowBy(tag: "tuesdayClose")
        let wednesdayOpenRow : TimeRow? = self.form.rowBy(tag: "wednesdayOpen")
        let wednesdayCloseRow : TimeRow? = self.form.rowBy(tag: "wednesdayClose")
        let thursdayOpenRow : TimeRow? = self.form.rowBy(tag: "thursdayOpen")
        let thursdayCloseRow : TimeRow? = self.form.rowBy(tag: "thursdayClose")
        let fridayOpenRow : TimeRow? = self.form.rowBy(tag: "fridayOpen")
        let fridayCloseRow : TimeRow? = self.form.rowBy(tag: "fridayClose")
        let saturdayOpenRow : TimeRow? = self.form.rowBy(tag: "saturdayOpen")
        let saturdayCloseRow : TimeRow? = self.form.rowBy(tag: "saturdayClose")
        let sundayOpenRow : TimeRow? = self.form.rowBy(tag: "sundayOpen")
        let sundayCloseRow : TimeRow? = self.form.rowBy(tag: "sundayClose")
        
        
        var streetNumber : String?
        var route : String?
        
        var addressArray = place.formattedAddress?.components(separatedBy: ",")
        
        for component in place.addressComponents! {
            switch component.type {
            case "street_number":
                streetNumber = component.name
            case "route":
                route = component.name
            case "locality":
                cityRow?.value = component.name
                cityRow?.updateCell()
            case "administrative_area_level_1":
                stateRow?.value = component.name
                stateRow?.updateCell()
            case "postal_code":
                zipCodeRow?.value = component.name
                zipCodeRow?.updateCell()
            default:
                break
            }
            
            if let num = streetNumber, let rt = route {
                streetAddressOneRow?.value = num + " " + rt
                streetAddressOneRow?.updateCell()
            } else {
                streetAddressOneRow?.value = addressArray?[0]
                streetAddressOneRow?.updateCell()
            }
            print("\(component.type) \(component.name)")
            
        }
        
        
        
        if let city = cityRow?.value, let array = addressArray {
            if city == array[2].trimmingCharacters(in: .whitespaces) {
                streetAddressTwoRow?.value = addressArray?[1]
                streetAddressTwoRow?.updateCell()
            }
        }
        
        businessNameRow?.value = place.name
        businessNameRow?.updateCell()
        
        businessNumberRow?.value = place.phoneNumber
        businessNumberRow?.updateCell()
        
        websiteRow?.value = place.website
        websiteRow?.updateCell()
        
        descriptionRow?.value = place.types[0]
        descriptionRow?.updateCell()
        
        let arrayValue = json["result"]["opening_hours"]["periods"]
        print(arrayValue)
        
        for (i, value) in arrayValue.enumerated() {
            
            let dayOfWeek = value.1["open"]["day"]
            
            
            switch dayOfWeek {
                case 0:
                    
                if let suo = value.1["open"]["time"].string {
                    let string = addColonToGoogleTimeString(string: suo)
                    sundayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                    sundayOpenRow?.updateCell()
                }
                if let suc = value.1["close"]["time"].string {
                    let string = addColonToGoogleTimeString(string: suc)
                    sundayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                    sundayCloseRow?.updateCell()
                }
                let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                row.cell.dayTapped(row.cell.sundayButton)
                
                case 1:
                    if let mo = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: mo)
                        mondayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        mondayOpenRow?.updateCell()
                    }
                    if let mc = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: mc)
                        mondayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        mondayCloseRow?.updateCell()
                 }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.mondayButton)

                case 2:
                    if let tuo = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: tuo)
                        tuesdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        tuesdayOpenRow?.updateCell()
                    }
                    if let tuc = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: tuc)
                        tuesdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        tuesdayCloseRow?.updateCell()
                }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.tuesdayButton)
                
                case 3:
                    if let wo = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: wo)
                        wednesdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        wednesdayOpenRow?.updateCell()
                    }
                    if let wc = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: wc)
                        wednesdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        wednesdayCloseRow?.updateCell()
                }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.wednesdayButton)
                
                case 4:
                    if let tho = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: tho)
                        thursdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        thursdayOpenRow?.updateCell()
                    }
                    if let thc = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: thc)
                        thursdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        thursdayCloseRow?.updateCell()
                }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.thursdayButton)
                
                case 5:
                    if let fo = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: fo)
                        fridayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        fridayOpenRow?.updateCell()
                    }
                    if let fc = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: fc)
                        fridayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        fridayCloseRow?.updateCell()
                }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.fridayButton)
                case 6:
                    if let sao = value.1["open"]["time"].string {
                        let string = addColonToGoogleTimeString(string: sao)
                        saturdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
                        saturdayOpenRow?.updateCell()
                    }
                    if let sac = value.1["close"]["time"].string {
                        let string = addColonToGoogleTimeString(string: sac)
                        saturdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
                        saturdayCloseRow?.updateCell()
                }
                    let row = form.rowBy(tag: "weekDayRow") as! WeekDayRow
                    row.cell.dayTapped(row.cell.saturdayButton)
                default:
                break
            }
        }
        
//        if let suo = json["result"]["opening_hours"]["periods"][0]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: suo)
//            sundayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            sundayOpenRow?.updateCell()
//        }
//        if let suc = json["result"]["opening_hours"]["periods"][0]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: suc)
//            sundayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            sundayCloseRow?.updateCell()
//        }
//        if let mo = json["result"]["opening_hours"]["periods"][1]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: mo)
//            mondayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            mondayOpenRow?.updateCell()
//        }
//        if let mc = json["result"]["opening_hours"]["periods"][1]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: mc)
//            mondayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            mondayCloseRow?.updateCell()
//        }
//        if let tuo = json["result"]["opening_hours"]["periods"][2]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: tuo)
//            tuesdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            tuesdayOpenRow?.updateCell()
//        }
//        if let tuc = json["result"]["opening_hours"]["periods"][2]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: tuc)
//            tuesdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            tuesdayCloseRow?.updateCell()
//        }
//        if let wo = json["result"]["opening_hours"]["periods"][3]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: wo)
//            wednesdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            wednesdayOpenRow?.updateCell()
//        }
//        if let wc = json["result"]["opening_hours"]["periods"][3]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: wc)
//            wednesdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            wednesdayCloseRow?.updateCell()
//        }
//
//        if let tho = json["result"]["opening_hours"]["periods"][4]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: tho)
//            thursdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            thursdayOpenRow?.updateCell()
//        }
//        if let thc = json["result"]["opening_hours"]["periods"][4]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: thc)
//            thursdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            thursdayCloseRow?.updateCell()
//        }
//
//        if let fo = json["result"]["opening_hours"]["periods"][5]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: fo)
//            fridayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            fridayOpenRow?.updateCell()
//        }
//        if let fc = json["result"]["opening_hours"]["periods"][5]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: fc)
//            fridayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            fridayCloseRow?.updateCell()
//        }
//
//        if let sao = json["result"]["opening_hours"]["periods"][6]["open"]["time"].string {
//            let string = addColonToGoogleTimeString(string: sao)
//            saturdayOpenRow?.value = firebaseTimeStringToDate(string: string!)
//            saturdayOpenRow?.updateCell()
//        }
//        if let sac = json["result"]["opening_hours"]["periods"][6]["close"]["time"].string {
//            let string = addColonToGoogleTimeString(string: sac)
//            saturdayCloseRow?.value = firebaseTimeStringToDate(string: string!)
//            saturdayCloseRow?.updateCell()
//        }

    }
}

extension AddBusinessViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        jsonForGooglePlaceID(place: place)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
