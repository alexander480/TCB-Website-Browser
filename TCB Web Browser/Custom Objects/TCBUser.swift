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
    
    var bookmarkReference: DatabaseReference!
    var bookmarkObjects: [BookmarkObject]!
    
    var historyReference: DatabaseReference!
    var historyObjects: [HistoryObject]!
    
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
        self.historyReference = Database.database().reference(withPath: "/users/\(FIRUser.uid)/history")
        self.bookmarkReference = Database.database().reference(withPath: "/users/\(FIRUser.uid)/bookmarks")
        
        super.init()
        
        self.loginObjects = getLoginObjects()
        self.historyObjects = getHistoryObjects()
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
                let dict = object.dictionaryWithValues(forKeys: ["Title", "URL", "Date", "Username", "Password"]) as! [String: String]
                if let title = dict["Title"], let url = dict["URL"], let date = dict["Date"], let username = dict["Username"], let password = dict["Password"]
                {
                    let newObject = LoginObject(Title: title, URL: url, Date: date, Username: username, Password: password, ID: object.key)
                    array.append(newObject)
                }
            }
        })
        
        return array
    }
    
    private func getHistoryObjects() -> [HistoryObject]?
    {
        var array = [HistoryObject]()
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            for object in snapshot.children.allObjects as! [DataSnapshot]
            {
                let dict = object.dictionaryWithValues(forKeys: ["Title", "URL", "Date"]) as! [String: String]
                if let title = dict["Title"], let url = dict["URL"], let date = dict["Date"]
                {
                    let newObject = HistoryObject(Title: title, URL: url, Date: date, ID: object.key)
                    array.append(newObject)
                }
            }
        })
        
        return array
    }
}
