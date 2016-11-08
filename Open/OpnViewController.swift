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
    
    //Interactor for mobile
    let interactor = Interactor()
    
    //Firebase Ref
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    var businesses : [Business] = []
    //Icons for Table View cell swipe buttons
    lazy var callLogo : UIImage = UIImage(named: "PhoneIconLabel80x100")!
    lazy var chatLogo : UIImage = UIImage(named: "ChatIconLabel80x100")!
    lazy var newLogo : UIImage = UIImage(named: "NewIconLabel80x100")!
    lazy var orderLogo : UIImage = UIImage(named: "OrderIconLabel80x100")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ModalBusinessViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
    }

}

//MARK: Transitioning Delegate Extension
extension OpnViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
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
            print("call")
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
       
        cell.businessName.text = business.businessName
        cell.backgroundColor = UIColor.red
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = opnTableView.cellForRow(at: indexPath) else { return }
        let business = businesses[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.35
    }
    
}

