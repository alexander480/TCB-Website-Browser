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
import JavaScriptCore

class PasswordManager: NSObject
{
    // ------ Save New Login Data ------ //
    // ------------------------------ //
    
    var loginObjects = [LoginObject]()
    
    // ------ Save New Login Data ------ //
    // ------------------------------ //
    func saveLoginFor(LoginObject: LoginObject) -> LoginObject
    {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LoginEntity", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
             object.setValue(LoginObject.title, forKey: "title" )
             object.setValue(LoginObject.url, forKey: "url" )
             object.setValue(LoginObject.username, forKey: "username")
             object.setValue(LoginObject.password, forKey: "password" )
        
        do { try context.save(); LoginObject.coreObject = object; print("Succesfully Saved New LoginObject") }
        catch { print("Error - Failed To Save Object - #00") }
        
        return LoginObject
    }
    
    // ------ Update Saved Login Data ------ //
    // ---------------------------------- //
    func updateLoginFor(LoginObject: LoginObject)
    {
        let context = appDelegate.persistentContainer.viewContext
        if let object = LoginObject.coreObject
        {
            object.setValue(LoginObject.title, forKey: "title" )
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
                    let title = object.value(forKey: "title") as! String
                    let url = object.value(forKey: "url") as! String
                    let username = object.value(forKey: "username") as! String
                    let password = object.value(forKey: "password") as! String
                    
                    loginObject = LoginObject(Title: title, CoreObject: object, URL: url, Username: username, Password: password )
                }
            }
        }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        return loginObject
    }
    
    // ------ Return All Login Objects ------ //
    // ------------------------------- //
    func fetchLoginObjects() -> [LoginObject]?
    {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoginEntity")
        
        var bufArray = [LoginObject]()
        
        do
        {
            let result = try context.fetch(fetchRequest)
            for object in result
            {
                let title = object.value(forKey: "title") as! String
                let url = object.value(forKey: "url") as! String
                let username = object.value(forKey: "username") as! String
                let password = object.value(forKey: "password") as! String
                
                let buf = LoginObject(Title: title, CoreObject: object, URL: url, Username: username, Password: password)
                bufArray.append(buf)
            }
        }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        return bufArray
    }
    
    func insertLogin(LoginObject: LoginObject, WebView: WKWebView)
    {
        if let url = WebView.url?.absoluteString, let loginObjects = fetchLoginObjects()
        {
            for loginObject in loginObjects
            {
                if loginObject.url == url
                {
                    evaluateJs(WebView: WebView, DictionaryData: loginObject.toDictionary())
                }
            }
        }
    }
    
    private func evaluateJs(WebView: WKWebView, DictionaryData: [String: String])
    {
        let serializedData = try! JSONSerialization.data(withJSONObject: DictionaryData, options: .prettyPrinted)
        let encodedData = serializedData.base64EncodedString(options: .endLineWithLineFeed)
        
        let jsString = "autofill(\(encodedData)); function autofill(sBinaryParam) { console.log('// ------- Initializing Password Manager ------- //'); var sDecodedParam = window.atob(sBinaryParam); var oData = JSON.parse(sDecodedParam); var url = oData.url; var username = oData.username; var password = oData.password; console.log('URL: ' + url); console.log('Username: ' + username); console.log('Password: ' + password); console.log('// ------- Autofilling Login Forms ------ //'); var emailField = document.querySelectorAll('input[type='email']'); var passwordField = document.querySelectorAll('input[type='password']'); emailField.text = username; passwordField.text = password; } "

        WebView.evaluateJavaScript(jsString);
    }
    
}

// --------------------------- //
// ------ LoginObject Class ------ //
// --------------------------- //
class LoginObject: NSObject
{
    var title: String?
    var url: String!
    
    var username: String!
    var password: String!
    
    var coreObject: NSManagedObject?
    
    init(Title: String?, CoreObject: NSManagedObject?,  URL: String, Username: String, Password: String)
    {
        self.title = Title
        self.url = URL
        self.username = Username
        self.password = Password
        self.coreObject = CoreObject
    }
    
    func toDictionary() -> [String: String] { return ["username": self.username, "password": self.password, "url": self.url] }
}

