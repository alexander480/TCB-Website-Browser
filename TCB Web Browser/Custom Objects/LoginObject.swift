//
//  LoginObject.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/17/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

// ------------------------------- //
// -------- Login Object Class ------- //
// ------------------------------ //

class LoginObject: NSObject
{
    var title: String!
    var url: String!
    var date: String!
    var username: String!
    var password: String!
    
    var asDictionary: [String: String]!
    var uid: String?
    
    init(Title: String, URL: String, Date: String, Username: String, Password: String, uid: String?)
    {
        self.title = Title
        self.url = URL
        self.date = Date
        self.username = Username
        self.password = Password
        self.uid = uid
        
        self.asDictionary = ["Title": self.title, "Url": self.url, "Date": self.date, "Username": self.username, "Password": self.password]
    }
    
    func saveToFirebase(User: TCBUser)
    {
        let newLogin = User.loginReference.childByAutoId()
        newLogin.setValuesForKeys(self.asDictionary)
        
        self.uid = newLogin.key
    }
    
    func removeFromFirebase(User: TCBUser)
    {
        if let key = self.uid
        {
            let ref = User.loginReference.child(key)
            ref.removeValue()
            print("Login Removed From Database")
        }
        else
        {
            print("Login Never Saved To Firebase")
        }
    }
}
