//
//  WebExtensions.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/27/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView
{
    func deleteCookies()
    {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! { storage.deleteCookie(cookie) }
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
    }
}
