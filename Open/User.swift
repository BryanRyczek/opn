//
//  User.swift
//  Open
//
//  Created by Bryan Ryczek on 11/16/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
