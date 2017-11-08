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
    func clean() -> String
    {
        var array = self.lowercased().components(separatedBy: ".")
        var cleanedURL = ""
        
        if array.count == 3  {
            if !array[0].contains("http://") || !array[0].contains("https://") {
                array[0] = "http://" + array[0]
                cleanedURL = array.joined(separator: ".")
            }
        }
        else if array.count == 2 {
            cleanedURL = "http://www." + array.joined(separator: ".")
        }
        else if array.count == 1 {
            cleanedURL = array[0]
        }
        
        return cleanedURL
    }
}
