//
//  ModalBusinessViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/8/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class ModalBusinessViewController: UIViewController {
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var opnLogo: UIImageView!
    
    @IBOutlet weak var mondayOpen: UILabel!
    @IBOutlet weak var mondayClose: UILabel!
    @IBOutlet weak var tuesdayOpen: UILabel!
    @IBOutlet weak var tuesdayClose: UILabel!
    @IBOutlet weak var wednesdayOpen: UILabel!
    @IBOutlet weak var wednesdayClose: UILabel!
    @IBOutlet weak var thursdayOpen: UILabel!
    @IBOutlet weak var thursdayClose: UILabel!
    @IBOutlet weak var fridayOpen: UILabel!
    @IBOutlet weak var fridayClose: UILabel!
    @IBOutlet weak var saturdayOpen: UILabel!
    @IBOutlet weak var saturdayClose: UILabel!
    @IBOutlet weak var sundayOpen: UILabel!
    @IBOutlet weak var sundayClose: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //opnLogo.image = UIImage(named: "OpnIconGrayscale")
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
