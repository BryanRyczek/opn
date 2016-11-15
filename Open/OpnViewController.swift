//
//  OpnViewController.swift
//  
//
//  Created by Bryan Ryczek on 11/7/16.
//
//

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

import UIKit
import FirebaseDatabase
import MGSwipeTableCell
import PopupDialog

class OpnViewController: UIViewController {

    @IBOutlet weak var opnTableView: UITableView!
    
    //Firebase Ref
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    var businesses : [Business] = []
    //Icons for Table View cell swipe buttons
    lazy var callLogo : UIImage = UIImage(named: "PhoneIconLabel80x100")!
    lazy var chatLogo : UIImage = UIImage(named: "ChatIconLabel80x100")!
    lazy var newLogo : UIImage = UIImage(named: "NewIconLabel80x100")!
    lazy var orderLogo : UIImage = UIImage(named: "OrderIconLabel80x100")!
    
    lazy var todayOpen = String()
    lazy var todayClose = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let open = ref.child("open")
        let opn = open.child("wednesdayOpen")
        print(open)
        print(opn.key)
        
        //set Delegates
        opnTableView.delegate = self
        opnTableView.dataSource = self
        
        //register custom cells to storyboard
        opnTableView.register(UINib(nibName: "OpnBusinessCell", bundle: nil), forCellReuseIdentifier: "opnBusinessCell")
        
        //MARK: listener on Firebase database. Listen for add/removed/changed event to .value type
        ref.queryOrdered(byChild: "businessName").observe(.value, with: { snapshot in
            
            var newBusiness: [Business] = []
            
            for item in snapshot.children {
                let business = Business(snapshot: item as! FIRDataSnapshot)
                newBusiness.append(business)
            }
            
            self.businesses = newBusiness
            self.opnTableView.reloadData()
            
        })
    }
    
    func showPopoverForBusiness(business: Business) {
        
        let businessVc = ModalBusinessViewController(nibName: "ModalBusinessViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: businessVc,
                                buttonAlignment: .vertical,
                                transitionStyle: .bounceUp,
                                gestureDismissal: true) {
                                    print("done!")
        }
        
        let vc = popup.viewController as! ModalBusinessViewController
        vc.businessName.text = business.businessName
        vc.mondayOpen.text = business.mondayOpen
        vc.mondayClose.text = business.mondayClose
        vc.tuesdayOpen.text = business.tuesdayOpen
        vc.tuesdayClose.text = business.tuesdayClose
        vc.wednesdayOpen.text = business.wednesdayOpen
        vc.wednesdayClose.text = business.wednesdayClose
        vc.thursdayOpen.text = business.thursdayOpen
        vc.thursdayClose.text = business.thursdayClose
        vc.fridayOpen.text = business.fridayOpen
        vc.fridayClose.text = business.fridayClose
        vc.saturdayOpen.text = business.saturdayOpen
        vc.saturdayClose.text = business.saturdayClose
        vc.sundayOpen.text = business.sundayOpen
        vc.sundayClose.text = business.sundayClose
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        
        overlayAppearance.opacity = 0.50
        overlayAppearance.blurEnabled = false

        // Present dialog
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    func showImageDialog() {
        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "pexels-photo-103290")
        
        // Create the dialog
        //let popup = PopupDialog(title: title, message: message, image: image)
        
        let businessVc = ModalBusinessViewController(nibName: "ModalBusinessViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: businessVc,
                                buttonAlignment: .vertical,
                                transitionStyle: .bounceUp,
                                gestureDismissal: true) { 
                                    print("done!")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL") {
            //self.label.text = "You canceled the car dialog."
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
            //self.label.text = "What a beauty!"
        }
        
        // Create third button
        let buttonThree = DefaultButton(title: "BUY CAR") {
            //self.label.text = "Ah, maybe next time :)"
        }
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        
        overlayAppearance.opacity = 0.50
        overlayAppearance.blurEnabled = false
        
        // Add buttons to dialog
        //popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        // Present dialog
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    func showPopover(business: Business) {
        let businessVc = ModalBusinessViewController(nibName: "ModalBusinessViewController", bundle: nil)
        
        //businessVc.businessName.text = "$#!T"
        
        let popup = PopupDialog(viewController: businessVc,
                                buttonAlignment: .vertical,
                                transitionStyle: .bounceUp,
                                gestureDismissal: true) {
                                    print("done!")
        }
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        
        overlayAppearance.opacity = 0.50
        overlayAppearance.blurEnabled = false
        
        // Present dialog
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // in half a second...
            self.present(popup, animated: true, completion: nil)
        }

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}

//MARK: Table View Extension
extension OpnViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opnBusinessCell", for: indexPath) as! OpnBusinessCell
        let business = businesses[indexPath.row]
            if let dtl = cell.detailTextLabel {
                dtl.font = UIFont(name: avenir85, size: 14)
                dtl.textColor = UIColor.black
                dtl.text = String(indexPath.row)
            }

        var chatButton : MGSwipeButton = MGSwipeButton(title: "", icon: chatLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("chat")
            return true
        }
        chatButton.centerIconOverText(withSpacing: 0.0)
        
        var callButton : MGSwipeButton = MGSwipeButton(title: "", icon: callLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            
            let phoneNumber = business.phoneNumber
            
            if let phoneCallURL = NSURL(string: "tel:\(phoneNumber)") {
                let application = UIApplication.shared
                if application.canOpenURL(phoneCallURL as URL) {
                    application.openURL(phoneCallURL as URL)
                }
                else{
                    print("failed")
                }
            }
            
            return true
        }
        callButton.centerIconOverText(withSpacing: 0.0)
        let newButton : MGSwipeButton = MGSwipeButton(title: "", icon: newLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("new")
            return true
        }
        newButton.centerIconOverText(withSpacing: 0.0)
        let orderButton : MGSwipeButton = MGSwipeButton(title: "", icon: orderLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("order")
            return true
        }
        orderButton.centerIconOverText(withSpacing: 0.0)

        cell.rightSwipeSettings.transition = MGSwipeTransition.static
        cell.rightButtons = [chatButton,callButton]
        cell.leftSwipeSettings.transition = MGSwipeTransition.static
        cell.leftButtons = [newButton, orderButton]
        cell.descriptionLabel.text = business.businessName
        //cell.businessName.text = business.businessName
        
        let openClose: [Date] = getOpenClose(business: business)
//        do {
//            try checkTime(business: business, completion: { string in
//                print("super cali\(string)")
//            })
//            //openClose = try checkTime(business: business, completion: <#T##(String) -> Void#>)
//        } catch {
//            print("F*** how we gonna know if this business is open?")
//        }
//        print(openClose)
//        
//        print("TV OPEN\(openClose[0]) TV CLOSE \(openClose[1])")
        switch isDateWithinInverval(open: openClose[0], close: openClose[1]) {
        case true:
            cell.openLabel.text = "\(business.businessName) is OPEN!"
            cell.backgroundColor = openBlue
        case false:
            cell.openLabel.text = "\(business.businessName) is CLOSED!"
            cell.backgroundColor = openRed
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = opnTableView.cellForRow(at: indexPath) else { return }
        let business = businesses[indexPath.row]
        showPopoverForBusiness(business: business)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.24
    }
    
}

extension OpnViewController {
            
    enum TimeError: Error {
        case couldNotConvert
    }
    
    func getOpenClose(business: Business) -> [Date] {
        
        let date : [Date] = []
        
        var openTime: String = ""
        var closingTime: String = ""
        
        if let today = Date().dayOfWeek() {
            switch today {
                case "monday":
                    openTime = business.mondayOpen
                    closingTime = business.mondayClose
                case "tuesday":
                    openTime = business.tuesdayOpen
                    closingTime = business.tuesdayClose
                case"wednesday":
                    openTime = business.wednesdayOpen
                    closingTime = business.wednesdayClose
                case"thursday":
                    openTime = business.thursdayOpen
                    closingTime = business.thursdayClose
                case"friday":
                    openTime = business.fridayOpen
                    closingTime = business.fridayClose
                case"saturday":
                    openTime = business.saturdayOpen
                    closingTime = business.saturdayClose
                case"sunday":
                    openTime = business.sundayOpen
                    closingTime = business.sundayClose
                default:
                    break
            }
        }
        
        let todayOpenDate = convertFirebaseTimeStringToDate(firebaseString: openTime)
        let todayCloseDate = convertFirebaseTimeStringToDate(firebaseString: closingTime)

        return [todayOpenDate, todayCloseDate]
    }
    
    func convertFirebaseTimeStringToDate (firebaseString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        let count = firebaseString.characters.count
        
        if count == 5 {
            dateFormatter.dateFormat = "HH:mm"
        } else if count == 8 {
            dateFormatter.dateFormat = "hh:mm a"
        }
        
        guard let date = dateFormatter.date(from: firebaseString) else {
            return Date()
        }
        
        let newDate =  currentDateCustomTime(dateWithTime: date)
        
        return newDate
    }
    
    func currentDateCustomTime(dateWithTime: Date)  -> Date {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: currentDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: dateWithTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        guard let newDate = calendar.date(from: dateComponents) else {
            return Date()
        }
        
        return newDate
    }
    
    func isDateWithinInverval(open: Date, close: Date) -> Bool {
        var isOpen : Bool = false
        let currentDate = Date()
        
        if currentDate > open && close > currentDate {
            isOpen = true
        }
        
        return isOpen
    }
    
//    func setOpenClose(business: Business) throws -> [Date] {
//        
//        guard let today = Date().dayOfWeek() else {
//            throw  TimeError.couldNotConvert }
//        let todayPlusOpen: String = today + "Open"
//        let todayPlusClose: String = today + "Close"
//        
//        let businessName = business.businessName.lowercased()
//
//        ref.child(businessName).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            self.todayOpen = value?[todayPlusOpen] as! String
//                
//                //value?[todayPlusOpen] as? String ?? ""
//            self.todayClose = value?[todayPlusClose] as! String
//            
//            print("bn1 \(businessName) tO \(self.todayOpen) tC \(self.todayClose)")
//            //let user = User.init(username: username)
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        print("bn2 \(businessName) t0 \(todayOpen) tc \(todayClose)")
//        
//        let todayOpenDate = try convertFirebaseTimeStringToDate(firebaseString: todayOpen)
//        let todayCloseDate = try convertFirebaseTimeStringToDate(firebaseString: todayClose)
//        
//         print("\(todayOpenDate) \(todayCloseDate)")
//        return[todayOpenDate, todayCloseDate]
//        
//    }
    
//    func checkAM(business: Business, completion:@escaping (String) -> Void) throws {
//        
//        guard let today = Date().dayOfWeek() else {
//            throw  TimeError.couldNotConvert }
//        let todayPlusOpen: String = today + "Open"
//        let todayPlusClose: String = today + "Close"
//        let businessName = business.businessName.lowercased()
//        
//        ref.child(businessName).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if let value = snapshot.value as? [String:AnyObject] {
//                completion(value[todayPlusOpen] as! String)
//            } else {
//                completion("DIE")
//            }
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//    func checkPM(business: Business, completion:@escaping (String) -> Void) throws {
//        
//        guard let today = Date().dayOfWeek() else {
//            throw  TimeError.couldNotConvert }
//        let todayPlusClose: String = today + "Close"
//        let businessName = business.businessName.lowercased()
//        
//        ref.child(businessName).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if let value = snapshot.value as? [String:AnyObject] {
//                completion(value[todayPlusOpen] as! String)
//            } else {
//                completion("DIE")
//            }
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//    }

    
        
//    //TO DO: FIX THROWS METHOD
//    func convertFirebaseTimeStringToDate (firebaseString: String) throws -> Date {
//        
//        let dateFormatter = DateFormatter()
//        //dateFormatter.dateStyle = .short
//        let count = firebaseString.characters.count
//        
//        if count == 5 {
//            dateFormatter.dateFormat = "HH:mm"
//        } else if count == 8 {
//            dateFormatter.dateFormat = "hh:mm a"
//        }
//        
//        guard let date = dateFormatter.date(from: firebaseString) else {
//            throw  TimeError.couldNotConvert }
//        
//        let newDate = try currentDateCustomTime(dateWithTime: date)
//        
//        return newDate
//    }
    
    
//    func currentDateCustomTime(dateWithTime: Date) throws -> Date {
//        
//        let currentDate = Date()
//        let calendar = Calendar.current
//        
//        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: currentDate)
//        let timeComponents = calendar.dateComponents([.hour, .minute], from: dateWithTime)
//        dateComponents.hour = timeComponents.hour
//        dateComponents.minute = timeComponents.minute
//        
//        guard let newDate = calendar.date(from: dateComponents) else {
//            throw TimeError.couldNotConvert
//        }
//        
//        return newDate
//    }
    
}

extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).lowercased()
        // or use lowercaseed(with: locale)
    }
    
}
