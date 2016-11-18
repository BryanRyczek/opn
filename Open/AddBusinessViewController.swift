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

class AddBusinessViewController: FormViewController {

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
        TextAreaRow.defaultCellUpdate = { cell, row in
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
        
        form = Section("Section1")
            //MARK:
            <<< TextRow("BusinessName") {
                $0.title = "Business Name"
                $0.placeholder = "Business Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
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
            <<< NameRow("ContactName") {
                $0.title = "Contact Name"
                $0.placeholder = "Contact Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            <<< EmailRow("Contact Email") {
                $0.title = "Contact Email"
                $0.placeholder = "Contact Email"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            +++ TextRow("StreetAddress") {
                $0.title = "Street Address"
                $0.placeholder = "Street Address"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            <<< TextRow("StreetAddress2") {
                $0.title = "Street Address 2"
                $0.placeholder = "Optional"
            }
            //MARK:
            <<< TextRow("City") {
                $0.title = "City"
                $0.placeholder = "City"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            <<< TextRow("State") {
                $0.title = "State"
                $0.placeholder = "State"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            <<< ZipCodeRow("ZipCode") {
                $0.title = "Zip Code"
                $0.placeholder = "Zip Code"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            <<< PhoneRow("BusinessNumber") {
                $0.title = "Business Number 📞"
                $0.placeholder = "555.555.5555"
            }
            //MARK:
            <<< URLRow() {
                $0.title = "Website"
                $0.add(rule: RuleURL())
                $0.validationOptions = .validatesOnBlur
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
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
            +++ TextAreaRow("BusinessCategory") {
                $0.title = "Business Category"
                $0.placeholder = "Write "
        }
        
//            <<< EmailRow() {
//                $0.title = "Email Rule"
//                $0.add(rule: RuleRequired())
//                $0.add(rule: RuleEmail())
//                $0.validationOptions = .validatesOnChangeAfterBlurred
//                }
//                .cellUpdate { cell, row in
//                    if !row.isValid {
//                        cell.titleLabel?.textColor = .red
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
        let placeholder = "请输入"
        cell.textField.placeholder = placeholder
        
    }
    
    if let label : UILabel = cell.textField.value(forKeyPath: "_placeholderLabel") as? UILabel {
//        guard label.isKind(of: UILabel) else {
//            return
//        }
        label.font = UIFont(name: avenir65, size: 18)
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .none
    }
}
