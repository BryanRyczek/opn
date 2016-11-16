//
//  LoginViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/16/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    let opnSegue = "OpnSegue"
    
    @IBOutlet weak var textFieldLoginEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldLoginPassword: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.opnSegue, sender: nil)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        if let email = textFieldLoginEmail.text, let pw = textFieldLoginPassword.text {
        FIRAuth.auth()!.signIn(withEmail: email,
                               password: pw)
        }
    }

    @IBAction func signupDidTouch(_ sender: AnyObject) {
        
        if let email = textFieldLoginEmail.text, let pw = textFieldLoginPassword.text {
        
            FIRAuth.auth()!.createUser(withEmail: email, password: pw, completion: { user, error in
            
                if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: email, password: pw)
                }
            
            })
        
        }
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
