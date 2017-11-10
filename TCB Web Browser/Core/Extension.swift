//
//  ext.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/7/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation

extension String
{
    func urlFormat() -> String
    {
        var array = self.lowercased().components(separatedBy: ".")
        var cleanedURL = ""
        if array.count == 3
        {
            if array[0].contains("http://") || array[0].contains("https://")
            {
                cleanedURL = array.joined(separator: ".")
            }
            else
            {
                array[0] = "http://" + array[0]
                cleanedURL = array.joined(separator: ".")
            }
        }
        else if array.count == 2
        {
            cleanedURL = "http://www." + array.joined(separator: ".")
        }
        else
        {
            var query = self.lowercased()
            
            if query.contains(" ")
            {
                query = query.replacingOccurrences(of: " ", with: "+")
            }
            
            cleanedURL = "http://www.google.com/search?q=\(query)"
        }
        
        print(cleanedURL)
        return cleanedURL
    }
}
