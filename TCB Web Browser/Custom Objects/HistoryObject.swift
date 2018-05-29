//
//  HistoryObject.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/21/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation

class HistoryObject: NSObject
{
    var title: String!
    var url: String!
    var date: String!
    
    var id: String?
    var asDictionary: [String: String]!
    
    init(Title: String, URL: String, Date: String, ID: String?)
    {
        self.title = Title
        self.url = URL
        self.date = Date
        self.id = ID
        
        self.asDictionary = ["Title": self.title, "URL": self.url, "Date": self.date]
    }
    
    func saveToFirebase(User: TCBUser)
    {
        let newHistory = User.historyReference.childByAutoId()
        newHistory.setValuesForKeys(self.asDictionary)
        
        print("History Object Saved To Firebase")
        self.id = newHistory.key
    }
    
    func removeFromFirebase(User: TCBUser)
    {
        if let key = self.id
        {
            let ref = User.historyReference.child(key)
            ref.removeValue()
            print("History Object Removed From Database")
        }
        else
        {
            print("History Object Never Saved To Firebase")
        }
    }
    
}
