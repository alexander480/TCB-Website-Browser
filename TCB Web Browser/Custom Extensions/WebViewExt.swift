//
//  WebExtensions.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/27/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import WebKit

extension WKWebView
{
    func injectLogin(LoginObject: LoginObject)
    {
        let dictionaryData = LoginObject.asDictionary
        
        let serializedData = try! JSONSerialization.data(withJSONObject: dictionaryData!, options: .prettyPrinted)
        let encodedData = serializedData.base64EncodedString(options: .endLineWithLineFeed)
        
        let jsString = "autofill(\(encodedData)); function autofill(sBinaryParam) { console.log('// ------- Initializing Password Manager ------- //'); var sDecodedParam = window.atob(sBinaryParam); var oData = JSON.parse(sDecodedParam); var url = oData.url; var username = oData.username; var password = oData.password; console.log('URL: ' + url); console.log('Username: ' + username); console.log('Password: ' + password); console.log('// ------- Autofilling Login Forms ------ //'); var emailField = document.querySelectorAll('input[type='email']'); var passwordField = document.querySelectorAll('input[type='password']'); emailField.text = username; passwordField.text = password; } "
        
        self.evaluateJavaScript(jsString);
    }
    
    func historyObject(URL: String, Date: Date) -> NSManagedObject?
    {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        object.setValue(URL, forKey: "url" )
        object.setValue(Date, forKey: "date")
        
        do { try context.save(); print("Success - Saved History Object"); return object }
        catch { print("Error - Could Not Save History Object"); return nil }
    }
    
    func fetchHistory() -> Array<NSManagedObject>?
    {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
    
        do { let result = try context.fetch(fetchRequest); print("Success - Retreived History Data."); print(result); return result }
        catch { print("Error - Could Not Fetch Core History Data"); return nil }
    }
    
    func getRequest(urlString: String, Private: Bool) -> URLRequest?
    {
        if Private
        {
            if let url = URL(string: urlString) { let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData); return request }
            else { print("Error - Invalid URL For Request"); return nil }
        }
        else
        {
            if let url = URL(string: urlString) { let request = URLRequest(url: url); return request }
            else { print("Error - Invalid URL For Request"); return nil }
        }
    }
    
    func WKDataAlert(ViewController: UIViewController, WebView: WKWebView)
    {
        let dataAlert = self.createDataAlert(ViewController: ViewController, WebView: WebView)
        ViewController.present(dataAlert, animated: true, completion:
        {
            dataAlert.view.superview?.isUserInteractionEnabled = true
            dataAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: ViewController, action: #selector(ViewController.alertControllerBackgroundTapped)))
        })
    }
    
    private func createDateAlert(ViewController: UIViewController, WebView: WKWebView, dataToDelete: String) -> UIAlertController
    {
        let dateAlert = UIAlertController(title: dataToDelete, message: "Please select how much data you would like to delete.", preferredStyle: .alert)

        dateAlert.addAction(UIAlertAction(title: " 24 Hours", style: .default, handler: { (action) in
            switch (dataToDelete) {
                case "Delete History":
                    (ViewController as! BrowserVC).deleteHistory(FromPastDays: 1)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "History Deleted", Message: "")
                case "Delete Cookies":
                    (ViewController as! BrowserVC).deleteCookies(FromPastDays: 1)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cookies Deleted", Message: "")
                case "Delete Cache":
                    (ViewController as! BrowserVC).deleteCache(FromPastDays: 1)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cache Deleted", Message: "")
                case "Delete All Data":
                    (ViewController as! BrowserVC).deleteData(FromPastDays: 1)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Data Deleted", Message: "")
                default:
                    dateAlert.dismiss(animated: true, completion: nil)
            }
        }))
        
        dateAlert.addAction(UIAlertAction(title: "7 Days", style: .default, handler: { (action) in
            switch (dataToDelete) {
                case "Delete History":
                    (ViewController as! BrowserVC).deleteHistory(FromPastDays: 7)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "History Deleted", Message: "")
                case "Delete Cookies":
                    (ViewController as! BrowserVC).deleteCookies(FromPastDays: 7)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cookies Deleted", Message: "")
                case "Delete Cache":
                    (ViewController as! BrowserVC).deleteCache(FromPastDays: 7)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cache Deleted", Message: "")
                case "Delete All Data":
                    (ViewController as! BrowserVC).deleteData(FromPastDays: 7)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Data Deleted", Message: "")
                default:
                    dateAlert.dismiss(animated: true, completion: nil)
            }
        }))
        
        dateAlert.addAction(UIAlertAction(title: " 30 Days", style: .default, handler: { (action) in
            switch (dataToDelete) {
                case "Delete History":
                    (ViewController as! BrowserVC).deleteHistory(FromPastDays: 31)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "History Deleted", Message: "")
                case "Delete Cookies":
                    (ViewController as! BrowserVC).deleteCookies(FromPastDays: 31)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cookies Deleted", Message: "")
                case "Delete Cache":
                    (ViewController as! BrowserVC).deleteCache(FromPastDays: 31)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cache Deleted", Message: "")
                case "Delete All Data":
                    (ViewController as! BrowserVC).deleteData(FromPastDays: 31)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Data Deleted", Message: "")
                default:
                    dateAlert.dismiss(animated: true, completion: nil)
            }
        }))
        
        dateAlert.addAction(UIAlertAction(title: "Delete All Data", style: .destructive, handler: { (action) in
            switch (dataToDelete)  {
                case "Delete History":
                    (ViewController as! BrowserVC).deleteHistory(FromPastDays: 3650)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "History Deleted", Message: "")
                case "Delete Cookies":
                    (ViewController as! BrowserVC).deleteCookies(FromPastDays: 3650)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cookies Deleted", Message: "")
                case "Delete Cache":
                    (ViewController as! BrowserVC).deleteCache(FromPastDays: 3650)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Cache Deleted", Message: "")
                case "Delete All Data":
                    (ViewController as! BrowserVC).deleteData(FromPastDays: 3650)
                    dateAlert.dismiss(animated: true, completion: nil)
                    (ViewController as! BrowserVC).alert(Title: "Data Deleted", Message: "")
                default:
                    dateAlert.dismiss(animated: true, completion: nil)
            }
        }))
        
//     dateAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in dateAlert.dismiss(animated: true, completion: nil) }))
        return dateAlert
    }
    
    func createDataAlert(ViewController: UIViewController, WebView: WKWebView) -> UIAlertController
    {
        let alert = UIAlertController(title: "Manage Browser Data", message: "In the next alert you will be able to select how much data to delete.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete History", style: .default, handler: { (action) in
            let dateAlert = self.createDateAlert(ViewController: ViewController, WebView: WebView, dataToDelete: action.title!)
            alert.dismiss(animated: true, completion: nil)
            ViewController.present(dateAlert, animated: true, completion:
            {
                dateAlert.view.superview?.isUserInteractionEnabled = true
                dateAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: ViewController, action: #selector(ViewController.alertControllerBackgroundTapped)))
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Cookies", style: .default, handler: { (action) in
            let dateAlert = self.createDateAlert(ViewController: ViewController, WebView: WebView, dataToDelete: action.title!)
            alert.dismiss(animated: true, completion: nil)
            ViewController.present(dateAlert, animated: true, completion:
            {
                dateAlert.view.superview?.isUserInteractionEnabled = true
                dateAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: ViewController, action: #selector(ViewController.alertControllerBackgroundTapped)))
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Delete Cache", style: .default, handler: { (action) in
            let dateAlert = self.createDateAlert(ViewController: ViewController, WebView: WebView, dataToDelete: action.title!)
            alert.dismiss(animated: true, completion: nil)
            ViewController.present(dateAlert, animated: true, completion:
            {
                dateAlert.view.superview?.isUserInteractionEnabled = true
                dateAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: ViewController, action: #selector(ViewController.alertControllerBackgroundTapped)))
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Delete All Data", style: .destructive, handler: { (action) in
            let dateAlert = self.createDateAlert(ViewController: ViewController, WebView: WebView, dataToDelete: action.title!)
            alert.dismiss(animated: true, completion: nil)
            ViewController.present(dateAlert, animated: false, completion:
            {
                dateAlert.view.superview?.isUserInteractionEnabled = true
                dateAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: ViewController, action: #selector(ViewController.alertControllerBackgroundTapped)))
            })
        }))
        
//     alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
        return alert
    }
}
