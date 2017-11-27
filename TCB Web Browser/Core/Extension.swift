//
//  ext.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/7/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension UISegmentedControl
{
    func removeBorders() {
        if let background = self.backgroundColor
        { setBackgroundImage(imageWithColor(color: background), for: .normal, barMetrics: .default) }
        
        if let tint = self.tintColor
        { setBackgroundImage(imageWithColor(color: tint), for: .selected, barMetrics: .default) }
        
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

extension String
{
    func urlFormat(searchEngine: String) -> String
    {
        var array = self.lowercased().components(separatedBy: ".")
        var cleanedURL = ""
        
        if array.count == 3
        {
            if array[0].contains("http://") || array[0].contains("https://") { cleanedURL = array.joined(separator: ".") }
            else { array[0] = "http://" + array[0]; cleanedURL = array.joined(separator: ".") }
        }
        else if array.count == 2 { cleanedURL = "http://www." + array.joined(separator: ".") }
        else
        {
            let query = self.lowercased().replacingOccurrences(of: " ", with: "+")
            
            if searchEngine == "Google" { cleanedURL = "http://www.google.com/search?q=\(query)" }
            else if searchEngine == "Yahoo" { cleanedURL = "https://search.yahoo.com/search?p=\(query)" }
            else if searchEngine == "Bing" { cleanedURL = "https://www.bing.com/search?q=\(query)" }
            else if searchEngine == "DuckDuckGo" { cleanedURL = "https://duckduckgo.com/?q=\(query)" }
        }
        
        print(cleanedURL)
        return cleanedURL
    }
}

extension UIViewController
{
    func historyObject(URL: String, Date: Date) -> NSManagedObject
    {
        let context = appDelegate.persistentContainer.viewContext
        print("Context: \(context)")
        
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)!
        print("Entity: \(entity)")
        
        let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue(URL, forKey: "url" )
            object.setValue(Date, forKey: "date")
        
        do { try context.save(); print("Object: \(object)") }
        catch { print("Failed To Store History Object") }
        
        return object
    }
    
    func fetchCoreDate(EntityName: String) -> Array<NSManagedObject>
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityName)
        let context = appDelegate.persistentContainer.viewContext
        
        var result: [NSManagedObject]!
        
        do { result = try context.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        return result
    }
    
    func setTCBLogin(Username: String, Password: String) -> NSManagedObject
    {
        let context = appDelegate.persistentContainer.viewContext
        print("Context: \(context)")
        
        let entity = NSEntityDescription.entity(forEntityName: "TCBLogin", in: context)!
        print("Entity: \(entity)")
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(Username, forKey: "username" )
        object.setValue(Password, forKey: "password")
        
        do { try context.save(); print("Object: \(object)") }
        catch { print("Failed To Store TCBLogin Object") }
        
        return object
    }
    
    func setWebMailLogin(Username: String, Password: String) -> NSManagedObject
    {
        let context = appDelegate.persistentContainer.viewContext
        print("Context: \(context)")
        
        let entity = NSEntityDescription.entity(forEntityName: "WebMailLogin", in: context)!
        print("Entity: \(entity)")
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(Username, forKey: "username" )
        object.setValue(Password, forKey: "password")
        
        do { try context.save(); print("Object: \(object)") }
        catch { print("Failed To Store TCBLogin Object") }
        
        return object
    }
    
    func alert(Title: String, Message: String)
    {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
}


