//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        webView.resignFirstResponder()
        if let rawString = searchBar.text
        {
            let searchString = rawString.clean()

            if let searchURL = URL(string: searchString)
            {
                webView.load(URLRequest(url: searchURL))
            }
            else
            {
                // Search searchString In Default Search Engine
            }
        }
    }
    
    func goBack() { if webView.canGoBack { webView.goBack() } }
    
    func goForward() { if webView.canGoForward { webView.goForward() } }
    
    func refresh() { webView.reload() }
}

