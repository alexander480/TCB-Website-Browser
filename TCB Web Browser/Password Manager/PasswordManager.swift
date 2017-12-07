//
//  PasswordManager.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/16/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import WebKit

class PasswordManager: NSObject
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // ------ Save New Login Data ------ //
    // ------------------------------ //
    func saveLoginFor(LoginObject: LoginObject)
    {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LoginEntity", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(LoginObject.title, forKey: "website" )
        object.setValue(LoginObject.url, forKey: "url" )
        object.setValue(LoginObject.username, forKey: "username")
        object.setValue(LoginObject.password, forKey: "password" )
        
        do { try context.save(); print("Succesfully Saved New LoginObject") }
        catch { print("Error - Failed To Save Object Within saveLoginFor() - context.save() function failed.") }
    }
    
    // ------ Update Saved Login Data ------ //
    // ---------------------------------- //
    func updateLoginFor(LoginObject: LoginObject)
    {
        let context = appDelegate.persistentContainer.viewContext
        if let object = LoginObject.coreObject
        {
            object.setValue(LoginObject.title, forKey: "website" )
            object.setValue(LoginObject.url, forKey: "url" )
            object.setValue(LoginObject.username, forKey: "username" )
            object.setValue(LoginObject.password, forKey: "password" )
            
            do { try context.save(); print("Successfully Updated LoginObject") }
            catch { print("Error - Failed To Save Object Within updateLoginFor() - context.save() Function Failed.") }
        }
        else { print(" Error - Could Not Update Object Within updateLoginFor() - LoginObject.coreObject Is Nil") }
    }
    
    // ------ Return Login Data For URL ------ //
    // ----------------------------------- //
    func fetchLoginFor(URL: String) -> LoginObject?
    {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoginEntity")
        
        var loginObject: LoginObject?
        do
        {
            let result = try context.fetch(fetchRequest)
            for object in result
            {
                if object.value(forKey: "url") as! String == URL
                {
                    let title = object.value(forKey: "website") as! String
                    let url = object.value(forKey: "url") as! String
                    let username = object.value(forKey: "username") as! String
                    let password = object.value(forKey: "password") as! String
                    
                    loginObject = LoginObject(CoreObject: object, Title: title, URL: url, Username: username, Password: password )
                }
            }
        }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        return loginObject
    }
    
    // ------ Return All Login Objects ------ //
    // ------------------------------- //
    func fetchLoginObjects() -> [LoginObject]
    {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoginEntity")
        
        var bufArray = [LoginObject]()
        
        do
        {
            let result = try context.fetch(fetchRequest)
            for object in result
            {
                let title = object.value(forKey: "website") as! String
                let url = object.value(forKey: "url") as! String
                let username = object.value(forKey: "username") as! String
                let password = object.value(forKey: "password") as! String
                
                let buf = LoginObject(CoreObject: object, Title: title, URL: url, Username: username, Password: password)
                bufArray.append(buf)
            }
        }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        return bufArray
    }
}

// ------ LoginObject Class ------ //
// --------------------------- //
class LoginObject: NSObject
{
    var title: String?
    var url: String!
    var username: String!
    var password: String!
    var coreObject: NSManagedObject?
    
    init(CoreObject: NSManagedObject?, Title: String?, URL: String, Username: String, Password: String)
    {
        self.title = Title
        self.url = URL
        self.username = Username
        self.password = Password
        self.coreObject = CoreObject
    }
}

