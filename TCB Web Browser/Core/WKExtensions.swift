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
    func historyObject(URL: String, Date: Date) -> NSManagedObject?
    {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(URL, forKey: "url" )
        object.setValue(Date, forKey: "date")
        
        do { try context.save(); print("Succesfully Saved History Object."); return object }
        catch { print("Error - Saving History Object - #00"); return nil }
    }
    
    func fetchHistory() -> Array<NSManagedObject>?
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        let context = appDelegate.persistentContainer.viewContext
        
        do { let result = try context.fetch(fetchRequest); print("Succesfully Retreived History Data."); return result }
        catch { print("Error - Fetching Core History Data - #00 "); return nil }
    }
    
    func clearHistory()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        let context = appDelegate.persistentContainer.viewContext
        
        if let result = try? context.fetch(fetchRequest) { for object in result { context.delete(object) } }
    }
    
    func getRequest(urlString: String, Private: Bool) -> URLRequest?
    {
        if Private
        {
            if let url = URL(string: urlString) { let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData); return request }
            else { print("Error Invalid URL For Request #00"); return nil }
        }
        else
        {
            if let url = URL(string: urlString) { let request = URLRequest(url: url); return request }
            else { print("Error Invalid URL For Request #00"); return nil }
        }
    }
    
    func clearData()
    {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! { storage.deleteCookie(cookie) }
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
    }
}
