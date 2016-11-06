//
//  ViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 10/16/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation



class ViewController: UIViewController {

    @IBOutlet weak var businessNameField: UITextField!
    @IBOutlet weak var businessTypeField: UITextField!
    @IBOutlet weak var streetNumberField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var addressLineTwoField: UITextField!
    @IBOutlet weak var stateField: UITextField!
     @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var ref = FIRDatabase.database().reference(withPath: "open-list")
    
    var items : [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //saveBusiness()
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
        
        //MARK: listener on Firebase database. Listen for add/removed/changed event to .value type
        ref.queryOrdered(byChild: "businessName").observe(.value, with: { snapshot in
            
            var newBusiness: [Business] = []
            
            for item in snapshot.children {
                let business = Business(snapshot: item as! FIRDataSnapshot)
                newBusiness.append(business)
            }
            
            self.items = newBusiness
            self.tableView.reloadData()
            
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveBusiness() {
        
        let businessName : String = "Joule"
        let businessType : String = "Technology"
        let latitude : Double = 42.382884
        let longitude : Double =  -71.071386
        //let coordinates : Coordinates = Coordinates(latitude: 42.382884, longitude: -71.071386)
        //let location : CLLocation = CLLocation(latitude: 42.382884, longitude: -71.071386)
        let streetNumber = 11
        let street = "Charles Street"
        let addressLineTwo : String? = nil
        let city = "Boston"
        let state = "MA"
        let zip = "02129"
        let addedByUser: String = "Bryan"
        
//        let business = Business(businessName: businessName,
//                                businessType: businessType,
//                                streetNumber: streetNumber,
//                                      street: street,
//                              //addressLineTwo: addressLineTwo?,
//                                        city: city,
//                                       state: state,
//                                         zip: zip,
//                                    latitude: latitude,
//                                   longitude: longitude,
//                                   completed: false,
//                                      isOpen: true,
//                                 addedByUser: addedByUser)
        
        let businessRef = self.ref.child(businessName.lowercased())
        
        //businessRef.setValue(business.toAnyObject())
        
    }
    
    func deleteBusiness() {
        let businessRef = items[0]
        businessRef.ref?.removeValue()
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let business = items[indexPath.row]
        
        cell.textLabel?.text = business.businessName
        cell.backgroundColor = UIColor.red
        //cell.detailTextLabel?.text = business.addedByUser
        
        //toggleCellCheckbox(cell, isCompleted: business.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let business = items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let business = items[indexPath.row]
            business.ref?.removeValue()
        }
    }
    
}

