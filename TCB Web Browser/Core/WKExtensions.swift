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
    func cleanUp()
    {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! { storage.deleteCookie(cookie) }
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
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
}
