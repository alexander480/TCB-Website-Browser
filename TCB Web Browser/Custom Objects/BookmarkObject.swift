//
//  BookmarkObject.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/21/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation

class BookmarkObject: NSObject
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
        let newBookmark = User.bookmarkReference.childByAutoId()
        newBookmark.setValuesForKeys(self.asDictionary)
        
        print("Bookmark Object Saved To Firebase")
        self.id = newBookmark.key
    }
    
    func removeFromFirebase(User: TCBUser)
    {
        if let key = self.id
        {
            let ref = User.bookmarkReference.child(key)
            ref.removeValue()
            print("Bookmark Object Removed From Database")
        }
        else
        {
            print("Bookmark Object Never Saved To Firebase")
        }
    }
    
}
