//
//  ext.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/7/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import UIKit

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
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    func alert(Title: String, Message: String)
    {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


