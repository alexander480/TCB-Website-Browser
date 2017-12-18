//
//  TCBAuth.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/18/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class TCBAuth: NSObject
{
    func checkForUser() -> Bool
    {
        if Auth.auth().currentUser != nil { return true } else { return false }
    }
    
    func getUser() -> TCBUser?
    {
        if let user = Auth.auth().currentUser
        {
            print("User Is Available")
            return TCBUser(FIRUser: user)
        }
        else
        {
            print("User Is Not Available")
            return nil
        }
    }
    
    func createUser(email: String, password: String) -> TCBUser?
    {
        var currentUser: User?
        Auth.auth().createUser(withEmail: email, password: password) {  (user, error) in if user != nil { currentUser = user } else { if let err = error { print(err) } } }
        if let user = currentUser { return TCBUser(FIRUser: user) } else { return nil }
    }
    
    func loginUser(email: String, password: String) -> TCBUser?
    {
        var currentUser: User?
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in if user != nil { currentUser = user } else { if let err = error { print(err) } } }
        if let user = currentUser { return TCBUser(FIRUser: user) } else { return nil }
    }
}
