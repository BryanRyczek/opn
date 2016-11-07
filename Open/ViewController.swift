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
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var ref = FIRDatabase.database().reference(withPath: "business-list")
    
    var items : [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
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

