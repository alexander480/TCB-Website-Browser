//
//  TCBUser.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/17/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class TCBUser: NSObject
{
    var user: User!
    var uid: String!
    
    var name: String?
    var email: String?
    var photo: URL?
    
    var reference: DatabaseReference!
    
    var loginReference: DatabaseReference!
    var loginObjects: [LoginObject]!
    
    init(FIRUser: User)
    {
        self.user = FIRUser
        self.uid = FIRUser.uid
        self.email = FIRUser.email
        self.photo = FIRUser.photoURL
        self.name = FIRUser.displayName
        self.reference = Database.database().reference(withPath: "/users/\(FIRUser.uid)")
        self.loginReference = Database.database().reference(withPath: "/users/\(FIRUser.uid)/logins")
        
        super.init()
        
        self.loginObjects = getLoginObjects()
    }
    
    func getLogin(forURL: String) -> LoginObject?
    {
        var objectForURL: LoginObject?
        for object in loginObjects
        {
            if object.url == forURL
            {
                objectForURL = object
            }
        }
        
        if let obj = objectForURL
        {
            return obj
        }
        else
        {
            print("Could Not Get Login For Specified URL")
            return nil
        }
    }
    
    private func getLoginObjects() -> [LoginObject]?
    {
        var array = [LoginObject]()
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            for object in snapshot.children.allObjects as! [DataSnapshot]
            {
                let dict = object.dictionaryWithValues(forKeys: ["Title", "Url", "Date", "Username", "Password"]) as! [String: String]
                if let title = dict["Title"], let url = dict["Url"], let date = dict["Date"], let username = dict["Username"], let password = dict["Password"]
                {
                    let newObject = LoginObject(Title: title, URL: url, Date: date, Username: username, Password: password, uid: object.key)
                    array.append(newObject)
                }
            }
        })
        
        return array
    }
}
