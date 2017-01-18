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

class LoginViewController: UIViewController, UITextFieldDelegate {

    let opnSegue = "OpnSegue"
    
    enum LoginState {
        case notLoggingIn, loggingIn
        mutating func toggle() {
            switch self {
            case .notLoggingIn:
                self = .loggingIn
            case .loggingIn:
                self = .notLoggingIn
            }
        }
    }
    
    var state = LoginState.notLoggingIn
    
    @IBOutlet weak var textFieldLoginEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var textFieldLoginPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var addBusinessButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldLoginEmail.iconText = "\u{f2be}"
        textFieldLoginEmail.iconFont = UIFont(name: fontAwesome, size: 24)
        textFieldLoginEmail.iconWidth = 40
        textFieldLoginEmail.title = ""
        textFieldLoginPassword.iconText = "\u{f0f7}"
        textFieldLoginPassword.iconFont = UIFont(name: fontAwesome, size: 24)
        textFieldLoginPassword.iconWidth = 40
        textFieldLoginPassword.title = ""
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                //self.performSegue(withIdentifier: self.opnSegue, sender: nil)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonDidTouch(_ sender: AnyObject) {
        switch state {
            case .loggingIn:
                textFieldLoginEmail.resignFirstResponder()
                state.toggle()
                textFieldLoginEmail.isHidden = true
                textFieldLoginPassword.isHidden = true
                backButton.isHidden = true
                signupButton.isHidden = false
                addBusinessButton.isHidden = false
            default:
                break
        }

    }
    
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        switch state {
            case .notLoggingIn:
                state.toggle()
                textFieldLoginEmail.isHidden = false
                textFieldLoginEmail.becomeFirstResponder()
                textFieldLoginPassword.isHidden = false
                backButton.isHidden = false
                signupButton.isHidden = true
                addBusinessButton.isHidden = true
            
            case .loggingIn:
                if let email = textFieldLoginEmail.text, let pw = textFieldLoginPassword.text {
                    FIRAuth.auth()!.signIn(withEmail: email, password: pw)
                }
            default:
                break
        }
        
    }

    @IBAction func signupDidTouch(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: self.opnSegue, sender: nil)
        
    }
    
    //TO DO: Put this in signup VC
//    if let email = textFieldLoginEmail.text, let pw = textFieldLoginPassword.text {
//        
//        FIRAuth.auth()!.createUser(withEmail: email, password: pw, completion: { user, error in
//            
//            if error == nil {
//                FIRAuth.auth()!.signIn(withEmail: email, password: pw)
//            }
//            
//        })
//        
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
