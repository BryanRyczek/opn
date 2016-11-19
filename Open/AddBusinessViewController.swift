//
//  AddBusinessViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/17/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import Eureka
import PostalAddressRow
import FirebaseDatabase

class AddBusinessViewController: FormViewController {

    var phase = 0
    
    //Mark: Firebase components
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    var items : [Business] = []
    
    //MARK: vars for storing information to send to Firebase when all is complete :)
    lazy var businessName = String()
    lazy var contactName = String()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               //let email = ValidationRulePattern(pattern: Email)
        
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
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont(name: avenir65, size: 30)
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = opnBlue
        }
        
        form = Section("Help Opn stay in touch with you") {
            $0.tag = "0"
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

            //MARK:
            +++ Section("Entering accurate information helps customers find your business"){
                $0.tag = "1"
            }
            <<< TextRow("businessName") {
                $0.title = "Business Name"
                $0.placeholder = "Business Name"
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
                $0.placeholder = "Optional"
            }
            //MARK:
            <<< TextRow("city") {
                $0.title = "City"
                $0.placeholder = "City"
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
                $0.placeholder = "555.555.5555"
            }
            //MARK:
            <<< URLRow("website") {
                $0.title = "Website"
                $0.add(rule: RuleURL())
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

//            <<< LocationRow("Location") {
//                $0.title = "
//            }
            <<< TextAreaRow("businessCategory") {
                $0.title = "Business Category"
                $0.placeholder = "Let Customers know what type of business you have."
        }
            +++ Section("Let Customers know what days you are open.") {
                $0.tag = "2"
                $0.hidden = true
            }
                <<< WeekDayRow("weekDayRow") {
                    $0.value = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
                    $0.title = "YEEHAW"
                }
            +++ Section("Let customers know what times you are open.") {
                $0.tag = "3"
                $0.hidden = true
            }
            <<< TimeRow("sundayOpen") {
                    $0.title = "Sunday Open"
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
            
            +++ ButtonRow("DoneRow") {
                $0.tag = "done"
                $0.title = "Add Info!"
                $0.validationOptions = .validatesOnBlur
        }
        .onCellSelection({ cell, row in
            
            
            let valuesDictionary = self.form.values()
            print(valuesDictionary)
            switch self.phase {
                case 0:
//                    //If let handling for optionals
//                    if let sa2 = valuesDictionary["streetAddressTwo"] as? String ?? nil {
//                        self.streetAddressTwo = sa2
//                    } else {
//                        self.streetAddressTwo = ""
//                    }
//                    
//                    if let ph = valuesDictionary["businessNumber"] as? String ?? nil {
//                        self.phoneNumber = ph
//                    } else {
//                        self.phoneNumber = ""
//                    }
//                    
//                    if let w = valuesDictionary["website"] as? String ?? nil {
//                        self.website = w
//                    } else {
//                        self.website = ""
//                    }
//                    
//                    if let des = valuesDictionary["businessCategory"] as? String ?? nil {
//                        self.businessDescription = des
//                    } else {
//                        self.businessDescription = ""
//                    }
//                    
//                    guard let cn = valuesDictionary["contactName"] as? String ?? nil,
//                        let em = valuesDictionary["email"] as? String ?? nil,
//                        let bn = valuesDictionary["businessName"] as? String ?? nil,
//                        let sa1 = valuesDictionary["streetAddressOne"] as? String ?? nil,
//                        let cty = valuesDictionary["city"] as? String ?? nil,
//                        let st = valuesDictionary["state"] as? String ?? nil,
//                        let z = valuesDictionary["zipCode"] as? String ?? nil
//                        else {
//                            let alert = UIAlertController(title: "More Information Needed!", message: "Please fill out all the required fields!", preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                            self.show(alert, sender: self)
//                            return
//                    }
//                    
//                    self.contactName = cn
//                    self.email = em
//                    self.businessName = bn
//                    self.streetAddressOne = sa1
//                    self.city = cty
//                    self.state = st
//                    self.zipCode = z
            
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
                    let button = self.form.rowBy(tag: "done")
                    button?.title = "Add Hours!"
                    self.phase += 1
            case 1:
                    //If let handling for optionals
                    let type = valuesDictionary["mondayOpen"]
                    dump(type)
                    if let suO = valuesDictionary["sundayOpen"] as? Date ?? nil {
                        self.sundayOpen = suO.stringify()
                    } else {
                        self.sundayOpen = ""
                    }

                    if let suC = valuesDictionary["sundayClose"] as? Date ?? nil {
                        self.sundayClose = suC.stringify()
                    } else {
                        self.sundayClose = ""
                    }

                    if let mO = valuesDictionary["mondayOpen"] as? Date ?? nil {
                        self.mondayOpen = mO.stringify()
                    } else {
                        self.mondayOpen = ""
                    }

                    if let mC = valuesDictionary["mondayClose"] as? Date ?? nil {
                        self.mondayClose = mC.stringify()
                    } else {
                        self.mondayClose = ""
                    }
                    //If let handling for optionals
                    if let tuO = valuesDictionary["tuesdayOpen"] as? Date ?? nil {
                        self.tuesdayOpen = tuO.stringify()
                    } else {
                        self.tuesdayOpen = ""
                    }

                    if let tuC = valuesDictionary["tuesdayClose"] as? Date ?? nil {
                        self.tuesdayClose = tuC.stringify()
                    } else {
                        self.tuesdayClose = ""
                    }

                    if let wO = valuesDictionary["wednesdayOpen"] as? Date ?? nil {
                        self.wednesdayOpen = wO.stringify()
                    } else {
                        self.wednesdayOpen = ""
                    }

                    if let wC = valuesDictionary["wednesdayClose"] as? Date ?? nil {
                        self.wednesdayClose = wC.stringify()
                    } else {
                        self.wednesdayClose = ""
                    }
                    //If let handling for optionals
                    if let thO = valuesDictionary["thursdayOpen"] as? Date ?? nil {
                        self.thursdayOpen = thO.stringify()
                    } else {
                        self.thursdayOpen = ""
                    }

                    if let thC = valuesDictionary["thursdayClose"] as? Date ?? nil {
                        self.thursdayClose = thC.stringify()
                    } else {
                        self.thursdayClose = ""
                    }

                    if let fO = valuesDictionary["fridayOpen"] as? Date ?? nil {
                        self.fridayOpen = fO.stringify()
                    } else {
                        self.fridayOpen = ""
                    }

                    if let fC = valuesDictionary["fridayClose"] as? Date ?? nil {
                        self.fridayClose = fC.stringify()
                    } else {
                        self.fridayClose = ""
                    }
                    //If let handling for optionals
                    if let saO = valuesDictionary["saturdayOpen"] as? Date ?? nil {
                        self.saturdayOpen = saO.stringify()
                    } else {
                        self.saturdayOpen = ""
                    }

                    if let saC = valuesDictionary["saturdayClose"] as? Date ?? nil {
                        self.saturdayClose = saC.stringify()
                    } else {
                        self.saturdayClose = ""
                    }
                
                    let section2 = self.form.sectionBy(tag: "2")
                    section2?.hidden = true
                    section2?.evaluateHidden()
                    let section3 = self.form.sectionBy(tag: "3")
                    section3?.hidden = true
                    section3?.evaluateHidden()
                    let button = self.form.rowBy(tag: "done")
                    button?.title = "Add My Business to Opn!"
                    self.phase += 1
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

