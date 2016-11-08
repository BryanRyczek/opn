//
//  OpnViewController.swift
//  
//
//  Created by Bryan Ryczek on 11/7/16.
//
//

import UIKit
import FirebaseDatabase
import MGSwipeTableCell


class OpnViewController: UIViewController {

    @IBOutlet weak var opnTableView: UITableView!
    
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    lazy var callLogo : UIImage = UIImage(named: "PhoneIcon80x80")!
    lazy var chatLogo : UIImage = UIImage(named: "ChatIcon80x80")!
    lazy var newLogo : UIImage = UIImage(named: "SpecialsIcon80x80")!
    
    var businesses : [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opnTableView.delegate = self
        opnTableView.dataSource = self
        
        //register custom cells to storyboard
        opnTableView.register(UINib(nibName: "OpnBusinessCell", bundle: nil), forCellReuseIdentifier: "opnBusinessCell")
        
        // Do any additional setup after loading the view.
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
        
        //var chatButton : MGSwipeButton = MGSwipeButton(title: "", icon: chatLogo, backgroundColor: UIColor.white)
        let chatButton : MGSwipeButton = MGSwipeButton(title: "", icon: chatLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("chat")
            return true
        }
        var callButton : MGSwipeButton = MGSwipeButton(title: "", icon: callLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("call")
            return true
        }

        let newButton : MGSwipeButton = MGSwipeButton(title: "", icon: newLogo, backgroundColor: UIColor.white) { (sender: MGSwipeTableCell!) -> Bool in
            print("new")
            return true
        }

        cell.rightButtons = [chatButton,callButton,newButton]
       
        cell.businessName.text = business.businessName
        cell.backgroundColor = UIColor.red
        
        //toggleCellCheckbox(cell, isCompleted: business.completed)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = opnTableView.cellForRow(at: indexPath) else { return }
        let business = businesses[indexPath.row]
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        //let call = BGTableView
//
//        let cellHeight = (UInt(tableView.cellForRow(at: indexPath)!.frame.height))
//        let call = BGTableViewRowActionWithImage.rowAction( with: .normal,
//                                                            title: " Call ",
//                                                            titleColor: UIColor.black,
//                                                  backgroundColor: UIColor.white,
//                                                            image: callLogo,
//                                                    forCellHeight: cellHeight + 80,
//                                                   andFittedWidth: false) { (action, indexPath) in
//                                                    print("call!")
//        }
//        
//        //call.backgroundColor = UIColor(patternImage: UIImage(named: "PhoneIcon")!)
//        let
//        let chat = BGTableViewRowActionWithImage.rowAction( with: .normal,
//                                                            title: " Chat  ",
//                                                            titleColor: UIColor.black,
//                                                            backgroundColor: UIColor.white,
//                                                            image: chatLogo,
//                                                            forCellHeight: cellHeight + 80,
//                                                            andFittedWidth: false) { (action, indexPath) in
//                                                                print("chat!")
//        }
//        
//        let
//        let specials = BGTableViewRowActionWithImage.rowAction( with: .normal,
//                                                            title: "  New! ",
//                                                            titleColor: UIColor.black,
//                                                            backgroundColor: UIColor.white,
//                                                            image: specialsLogo,
//                                                            forCellHeight: cellHeight + 80,
//                                                            andFittedWidth: false) { (action, indexPath) in
//                                                                print("specials!")
//        }
//
     return[]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.35
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(editingStyle)
//        switch editingStyle {
//            case .delete:
//                let business = businesses[indexPath.row]
//                business.ref?.removeValue()
//            case .none:
//                print("none")
//            case .insert:
//                 print("insert")
//            default:
//                break
//        }
    }
    
}

