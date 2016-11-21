//
//  SignupViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 10/24/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseDatabase

class SignupViewController: UIViewController, UITextFieldDelegate{

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
    lazy var addressLineOne = String()
    lazy var addressLineTwo = String()
    lazy var city = String()
    lazy var state = String()
    lazy var zip = String()
    lazy var phoneNumber = String()
    lazy var website = String()
    lazy var email = String()
    lazy var businessDescription = String()
    
    //MARK: UI components
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Text Entry fields
    @IBOutlet weak var entryFieldOneOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldOneTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldTwoOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldTwoTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldThreeOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldThreeTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldFourOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldFourTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldFourThree: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldFiveOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldFiveTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldSixOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldSixTwo: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldSevenOne: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var entryFieldSevenTwo: SkyFloatingLabelTextFieldWithIcon!
    
    
    //Outlet Collections
    @IBOutlet var entryFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet var allFieldsButFirst: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet var nonAddressFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet var columnOneEntryFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet var columnTwoEntryFields: [SkyFloatingLabelTextFieldWithIcon]!
    @IBOutlet var addressFields: [SkyFloatingLabelTextFieldWithIcon]!
    
    var currentTextField : UITextField?
    
    var phase: Int = 0

    lazy var lastOpen : String = "09:00"
    lazy var lastClose : String = "17:00"
    
    let prompts : [String] = ["Hi, what's your name?", //0
                              "What's the name of your business?", //1
                              "Please provide a description of the focus of your business.", //2
                              "What are your typical business hours? (for days the business is closed, leave the appropriate fields blank :) )", //3
                              "Where is your business located?", //4
                              "What's a phone number where your business can be reached?", //5
                              "What's your business website and business e-mail?", //6
                              "Please provide a brief description of your business" //7
                              ]
    
    let promptDescription : [String] = ["Name",
                                        "Business Name",
                                        "Food Truck, Boutique, Restaurant",
                                        "",
                                        "",
                                        "(555)-555-5555",
                                        "www.businessname.com",
                                        ""
                                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        uiSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
        
        //MARK: listener on Firebase database. Listen for add/removed/changed event to .value type
        ref.queryOrdered(byChild: "businessName").observe(.value, with: { snapshot in
            
            var newBusiness: [Business] = []
            
            for item in snapshot.children {
                let business = Business(snapshot: item as! FIRDataSnapshot)
                newBusiness.append(business)
            }
            
            self.items = newBusiness
            //self.tableView.reloadData()
            
        })

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
                                addressLineOne: addressLineOne,
                                addressLineTwo: addressLineTwo,
                                city: city,
                                state: state,
                                zip: zip,
                                phoneNumber: phoneNumber,
                                website: website,
                                email: email,
                                businessDescription: businessDescription)
        
        let businessRef = self.ref.child(businessName.lowercased())
        businessRef.setValue(business.toAnyObject())
        
    }
    
    func deleteBusiness() {
        let businessRef = items[0]
        businessRef.ref?.removeValue()
    }
    
    func setDelegates() {
        
    }
    
    func uiSetup() {
        
        for field in entryFields {
            field.delegate = self
            field.font = UIFont(name: "AvenirLTStd-Roman", size: 30)
            field.text = ""
            field.title = ""
            field.iconFont = UIFont(name: fontAwesome, size: 36)
            field.iconWidth = 40
        }
        
        currentTextField = entryFieldOneOne
        uiRefresh()
    }
    
    func uiRefresh() {
        
        //reset description label
        entryLabel.text = prompts[phase]
        
        //clear fields of last entry screen's values
        for field in entryFields {
            field.text = ""
            field.placeholder = ""
        }
        
        entryFieldOneOne.placeholder = promptDescription[phase]
        entryFieldOneOne.becomeFirstResponder()
        
        switch phase {
        case 0:
            addDoneButtonOnKeyboardForTextField(textField: entryFieldOneOne)
            for field in allFieldsButFirst {
                field.isHidden = true
            }
            entryFieldOneOne.iconText = "\u{f2be}"
        case 1:
            entryLabel.text = "Hi \(contactName)! What's the name of your business?"
            entryFieldOneOne.iconText = "\u{f0f7}"
        case 2:
            addDoneButtonOnKeyboardForTextField(textField: entryFieldTwoOne)
            addDoneButtonOnKeyboardForTextField(textField: entryFieldThreeOne)
            entryFieldTwoOne.isHidden = false
            entryFieldThreeOne.isHidden = false
            entryFieldOneOne.placeholder = "Food Truck"
            entryFieldTwoOne.placeholder = "Tacos"
            entryFieldThreeOne.placeholder = "Lunch"
            entryFieldOneOne.iconText = "\u{f105}"
            entryFieldTwoOne.iconText = "\u{f105}"
            entryFieldThreeOne.iconText = "\u{f105}"
        case 3:
            
            addDoneButtonOnKeyboard()
            
            addDatePicker()
            
            entryFieldTwoOne.becomeFirstResponder()
            entryFieldOneOne.becomeFirstResponder()
            
            scrollView.isScrollEnabled = true
            
            for field in entryFields {
                //field.keyboardType = .numberPad
                field.isHidden = false
                field.iconFont = UIFont(name: avenir65, size: 30)
            }
            
            for field in columnTwoEntryFields {
                field.iconWidth = 0
            }
            
            entryFieldFourThree.isHidden = true
            
            entryFieldOneOne.iconText = "M"
            entryFieldTwoOne.iconText = "Tu"
            entryFieldThreeOne.iconText = "W"
            entryFieldFourOne.iconText = "Th"
            entryFieldFiveOne.iconText = "F"
            entryFieldSixOne.iconText = "Sa"
            entryFieldSevenOne.iconText = "Su"
            
            entryFieldOneOne.placeholder = "9"
            entryFieldOneTwo.placeholder = "5"
            entryFieldTwoOne.placeholder = "9"
            entryFieldTwoTwo.placeholder = "5"
            entryFieldThreeOne.placeholder = "9"
            entryFieldThreeTwo.placeholder = "5"
            entryFieldFourOne.placeholder = "9"
            entryFieldFourTwo.placeholder = "5"
            entryFieldFiveOne.placeholder = "9"
            entryFieldFiveTwo.placeholder = "5"
            entryFieldSixOne.placeholder = "9"
            entryFieldSixTwo.placeholder = "5"
            entryFieldSevenOne.placeholder = "9"
            entryFieldSevenTwo.placeholder = "5"
            
          case 4:
            
            removeDatePicker()
            removeDoneButton()
            addDoneButtonOnKeyboardForTextField(textField: entryFieldFourThree)
            
            scrollView.isScrollEnabled = false
            
            for field in entryFields {
                field.isHidden = true
                field.keyboardType = .default
                field.iconText = ""
                field.iconWidth = 0
            }
            
            for field in addressFields {
                field.isHidden = false
                
            }
        
            entryFieldFourThree.keyboardType = .numberPad
            entryFieldTwoOne.keyboardType = .default
            entryFieldFourTwo.autocapitalizationType = .allCharacters
            entryFieldOneOne.text = "\(businessName)"
            entryFieldThreeOne.becomeFirstResponder()
            entryFieldTwoOne.becomeFirstResponder()
            entryFieldOneOne.isUserInteractionEnabled = false
            
            entryFieldTwoOne.placeholder = "Address Line 1"
            entryFieldThreeOne.placeholder = "Address Line 2"
            entryFieldFourOne.placeholder = "City"
            entryFieldFourTwo.placeholder = "State"
            entryFieldFourThree.placeholder = "ZIP"
          case 5: //Phone number
            entryFieldOneOne.resignFirstResponder()
            entryFieldOneOne.becomeFirstResponder()
//            entryFieldOneOne.iconWidth = 40
//            entryFieldOneOne.iconText = "\u{f10b}"
            entryFieldOneOne.textAlignment = .center
            addDoneButtonOnKeyboardForTextField(textField: entryFieldOneOne)
            entryFieldOneOne.isUserInteractionEnabled = true
            entryFieldOneOne.keyboardType = .numberPad
            for field in allFieldsButFirst {
                field.isHidden = true
            }
            
        case 6: // e-mail
            entryFieldOneOne.keyboardType = .emailAddress
            entryFieldOneOne.autocapitalizationType = .none
            entryFieldTwoOne.isHidden = false
            entryFieldTwoOne.placeholder = "e-mail"
            addDoneButtonOnKeyboardForTextField(textField: entryFieldTwoOne)
            entryFieldOneOne.resignFirstResponder()
            entryFieldOneOne.becomeFirstResponder()
        case 7:
            entryFieldTwoOne.isHidden = true
        default:
            break
        }
    }
 
    //MARK: To Handle Formatting of Phone #
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if phase == 3 {

            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if (length - index) > 1 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 1))
                formattedString.appendFormat("%@:", areaCode)
                index += 1
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
    } else if phase == 5 {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        } else {
            return true
        }
    }
    
    func validateUrl (stringURL : String) -> Bool {
        
        let urlRegEx = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.withSubstitutionVariables(predicate)
        
        return predicate.evaluate(with: stringURL)
    }
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}

//MARK: TextField Delegate Methods Extension
extension SignupViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

//MARK: Date Picker extension
extension SignupViewController {
    
    func datePickerValueChanged(sender:UIDatePicker) {
        if let ctf = currentTextField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            ctf.text = dateFormatter.string(from: sender.date)
            dateFormatter.dateFormat = "hh:mm"
            if (ctf.tag % 2) == 0 {
                lastOpen = dateFormatter.string(from: sender.date)
            } else if (ctf.tag % 2) == 1 {
                lastClose = dateFormatter.string(from: sender.date)
            }
        }
    }
    
    func addDatePicker() {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        datePickerView.minuteInterval = 5
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        for field in entryFields {
            field.inputView = datePickerView
            if (field.tag % 2) == 0 {
                let date = dateFormatter.date(from: lastOpen)
                datePickerView.date = date!
            } else if(field.tag % 2) == 1 {
                let date = dateFormatter.date(from: lastClose)
                datePickerView.date = date!
            }
            datePickerView.addTarget(self, action: #selector(SignupViewController.datePickerValueChanged), for: .valueChanged)
        }
    }
    
    func removeDatePicker() {
        if phase == 4 {
            for field in entryFields {
                field.inputView = nil
            }
        }
    }

    // MARK: - Navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
}


extension SignupViewController { //MARK: Keyboard Buttons extension
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "All Set!", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        
        for field in entryFields {
            field.inputAccessoryView = doneToolbar
        }
    }
    
    func addDoneButtonOnKeyboardForTextField(textField: UITextField) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "All Set!", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
    }
    
    func removeDoneButton() {
        for field in entryFields {
            field.inputAccessoryView = nil
        }
    }
    
    func removeDoneButtonFromField(textField: UITextField) {
        textField.inputAccessoryView = nil
    }
    
    func doneButtonAction() {
        
        guard let text = entryFieldOneOne.text else {
            return
        }
        
//        if (textField.text?.isEmpty) == true || (textField.text) == promptDescription[phase] {
//            //            errorLabel.text = "OOPS! YOU DIDNT ENTER ANYTHING! 😮"
//            //            errorLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
//            //            errorLabel.textColor = UIColor.red
//            return true
//        }
        
        switch phase {
        case 0: //Contact Name
            contactName = text.makeFirebaseString()
            
            
        case 1: // Business Name
            businessName = text.makeFirebaseString()
           
        case 2: // Tags
            businessTypeOne = text.makeFirebaseString()
            guard let text2 = entryFieldTwoOne.text else {
                break
            }
            businessTypeTwo = text2.makeFirebaseString()
            guard let text3 = entryFieldThreeOne.text else {
                break
            }
            businessTypeThree = text3.makeFirebaseString()
        case 3: // Hours
            mondayOpen = text.makeFirebaseString()
            guard let text2 = entryFieldTwoOne.text else {
                break
            }
            tuesdayOpen = text2.makeFirebaseString()
            guard let text3 = entryFieldThreeOne.text else {
                break
            }
            wednesdayOpen = text3.makeFirebaseString()
            guard let text4 = entryFieldFourOne.text else {
                break
            }
            thursdayOpen = text4.makeFirebaseString()
            guard let text5 = entryFieldFiveOne.text else {
                break
            }
            fridayOpen = text5.makeFirebaseString()
            guard let text6 = entryFieldSixOne.text else {
                break
            }
            saturdayOpen = text6.makeFirebaseString()
            guard let text7 = entryFieldSevenOne.text else {
                break
            }
            sundayOpen = text7.makeFirebaseString()
            guard let text8 = entryFieldOneTwo.text else {
                break
            }
            mondayClose = text8.makeFirebaseString()
            guard let text9 = entryFieldTwoTwo.text else {
                break
            }
            tuesdayClose = text9.makeFirebaseString()
            guard let text10 = entryFieldThreeTwo.text else {
                break
            }
            wednesdayClose = text10.makeFirebaseString()
            guard let text11 = entryFieldFourTwo.text else {
                break
            }
            thursdayClose = text11.makeFirebaseString()
            guard let text12 = entryFieldFiveTwo.text else {
                break
            }
            fridayClose = text12.makeFirebaseString()
            guard let text13 = entryFieldSixTwo.text else {
                break
            }
            saturdayClose = text13.makeFirebaseString()
            guard let text14 = entryFieldSevenTwo.text else {
                break
            }
            sundayClose = text14.makeFirebaseString()
            
        case 4:
            guard let text2 = entryFieldTwoOne.text else {
                break
            }
            addressLineOne = text2.makeFirebaseString()
            guard let text3 = entryFieldThreeOne.text else {
                break
            }
            addressLineTwo = text3.makeFirebaseString()
            guard let text4 = entryFieldFourOne.text else {
                break
            }
            city = text4.makeFirebaseString()
            guard let text5 = entryFieldFourTwo.text else {
                break
            }
            state = text5.makeFirebaseString()
            guard let text6 = entryFieldFourThree.text else {
                break
            }
            zip = text6.makeFirebaseString()
            
            
        case 5:
            
            phoneNumber = text.makeFirebaseString()

            
        case 6:
            if (validateUrl(stringURL: text)) {
                website = text.makeFirebaseString()
            }
            guard let text2 = entryFieldTwoOne.text else {
                break
            }
            email = text2.makeFirebaseString()
        case 7:
            businessDescription = text.makeFirebaseString()
            saveBusiness()
            
        default:
            break
        }
        if phase < 7 {
            phase += 1
            uiRefresh()
        }
    }
}




