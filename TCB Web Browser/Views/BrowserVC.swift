//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import WebKit

var lastURL = URL(string: "https://tcb.ai/")!

var searchEngine = "Google"
var cookies = true
var js = true

class BrowserVC: UIViewController, UISearchBarDelegate
{
    // Elements //
    
    // Popup Elements //
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var popupCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissPopupButton: UIButton!
    
    @IBOutlet weak var advancedPopup: UIView!
    @IBOutlet weak var advancedCenterConstraint: NSLayoutConstraint!
    
    // Popup Actions //
    
    @IBAction func showPopup(_ sender: Any) { revealPopup(isAdvanced: false) }
    @IBAction func dismissPopup(_ sender: Any) { dismissPopups() }
    
    @IBAction func showAdvancedPopup(_ sender: Any) { revealPopup(isAdvanced: true) }
    @IBAction func dismissAdvancedPopup(_ sender: Any) { dismissPopups() }
    
    // Popup Buttons //
    
    @IBAction func homeButton(_ sender: Any) { dismissPopups(); goHome(); }
    
    @IBOutlet weak var reloadButton: UIButton!
    @IBAction func reloadButtonAction(_ sender: Any) { dismissPopups(); refresh(); }
    
    @IBAction func mailButton(_ sender: Any) { dismissPopups(); goEmail(); }
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonAction(_ sender: Any) { dismissPopups(); goBack(); }
    
    @IBOutlet weak var forwardButton: UIButton!
    @IBAction func forwardButtonAction(_ sender: Any) { dismissPopups(); goForward(); }
    
    @IBOutlet weak var jsButton: UIButton!
    @IBAction func jsButtonAction(_ sender: Any)
    {
        dismissPopups()
        if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) }
        else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
    }
    
    @IBOutlet weak var cookieButton: UIButton!
    @IBAction func cookieButtonAction(_ sender: Any)
    {
        dismissPopups()
        if cookies { cookieButton.setImage(#imageLiteral(resourceName: "icons8-cookie-filled (1)"), for: .normal) }
        else { cookieButton.setImage(#imageLiteral(resourceName: "icons8-cookie-filled"), for: .normal) }
    }
    
    @IBAction func historyButton(_ sender: Any) {  }
    
    @IBAction func passwordButton(_ sender: Any) {  }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
            
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        
        webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress"
        {
            progress.progress = Float(webView.estimatedProgress)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        webView.resignFirstResponder()
        if let rawString = searchBar.text
        {
            let searchString = rawString.urlFormat()

            if let searchURL = URL(string: searchString)
            {
                webView.load(URLRequest(url: searchURL))
            }
        }
    }
    
    func  goHome() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!)) }
    func goEmail() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/webmail")!)) }
    
    
    func refresh() { webView.reload() }
    func goBack() { if webView.canGoBack { webView.goBack() } }
    func goForward() { if webView.canGoForward { webView.goForward() } }
    
    func revealPopup(isAdvanced: Bool)
    {
        if isAdvanced
        {
            self.advancedCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.view.layoutIfNeeded()
                })
        
            if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) }
            else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
            
            if cookies { cookieButton.setImage(#imageLiteral(resourceName: "icons8-cookie-filled (1)"), for: .normal) }
            else { cookieButton.setImage(#imageLiteral(resourceName: "icons8-cookie-filled"), for: .normal) }
        }
        else
        {
            self.popupCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.view.layoutIfNeeded()
                })
            
            if webView.canGoBack { backButton.isEnabled = true }
            else { backButton.isEnabled = false }
            
            if webView.canGoForward { forwardButton.isEnabled = true }
            else { forwardButton.isEnabled = false }
        }
    }

    func dismissPopups()
    {
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
        
        self.dismissPopupButton.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations:
            {
                self.view.layoutIfNeeded()
            })
    }
}

