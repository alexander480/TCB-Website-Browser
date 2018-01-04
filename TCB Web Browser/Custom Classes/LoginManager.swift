//
//  PasswordManager.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/16/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//
//                                                      TODO
//  --------------------------------------------------------
//                                  Test Javascript Injection Script
//                      Add Function To Update LoginObjects In Firebase
//

import Foundation
import CoreData
import FirebaseAuth
import FirebaseDatabase
import WebKit
import JavaScriptCore

class LoginManager: NSObject
{
    var user: TCBUser
    var loginObjects: [LoginObject]
    var reference: DatabaseReference
    
    init(ForUser: TCBUser, LoginObjects: [LoginObject])
    {
        self.user = ForUser
        self.loginObjects = LoginObjects
        self.reference = ForUser.reference.child("logins")
        
        super.init()
    }
    
    
    
    
}
