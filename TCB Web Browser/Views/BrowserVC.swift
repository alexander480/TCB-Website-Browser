//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import WebKit

class BrowserVC: UIViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var useGoogle = true
    var useYahoo = false
    var useBing = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        
        activity.startAnimating()
        webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!))
        activity.stopAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        webView.resignFirstResponder()
        if let rawString = searchBar.text
        {
            let searchString = rawString.urlFormat()

            if let searchURL = URL(string: searchString)
            {
                activity.startAnimating()
                webView.load(URLRequest(url: searchURL))
                activity.stopAnimating()
            }
            else
            {
                if (useGoogle)
                {
                    let query = rawString.replacingOccurrences(of: " ", with: "+")
                    if let searchURL = URL(string: "http://www.google.com/search?q=\(query)")
                    {
                        webView.load(URLRequest(url: searchURL))
                    }
                }
            }
        }
    }
    
    func goBack() { if webView.canGoBack { webView.goBack() } }
    
    func goForward() { if webView.canGoForward { webView.goForward() } }
    
    func refresh() { webView.reload() }
}

