//
//  StringExtensions.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/5/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation

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
