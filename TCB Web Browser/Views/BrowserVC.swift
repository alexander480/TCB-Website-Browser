//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import WebKit
import CoreData

let pref = WKPreferences()

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let entity = NSEntityDescription.entity(forEntityName: "History", in: context)

var engine = "Google"
var cookies = true
var js = true

class BrowserVC: UIViewController, UISearchBarDelegate, UIWebViewDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var dismissPopupButton: UIButton!
    
    @IBAction func showPopup(_ sender: Any) { revealPopup(isAdvanced: false) }
    @IBAction func dismissPopup(_ sender: Any) { dismissPopups() }
    
    
    // ------- Main Popup ------- //
    
    // ------- Elements ------- //
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var popupCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    // ------- Actions ------- //
    @IBAction func homeButtonAction(_ sender: Any) { dismissPopups(); goHome(); }
    @IBAction func mailButtonAction(_ sender: Any) { dismissPopups(); goEmail(); }
    @IBAction func reloadButtonAction(_ sender: Any) { dismissPopups(); refresh(); }
    @IBAction func backButtonAction(_ sender: Any) { dismissPopups(); goBack(); }
    @IBAction func forwardButtonAction(_ sender: Any) { dismissPopups(); goForward(); }
    @IBAction func showAdvancedPopup(_ sender: Any) { revealPopup(isAdvanced: true) }

    
    // ------- Advanced Popup  ------- //
    
    // ------- Elements ------- //
    @IBOutlet weak var advancedPopup: UIView!
    @IBOutlet weak var advancedCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var jsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    // ------- Actions ------- //
    @IBAction func jsButtonAction(_ sender: Any) { toggleJs(); dismissPopups() }
    @IBAction func trashButton(_ sender: Any) { clearWebData(); dismissPopups(); }
    @IBAction func searchButtonAction(_ sender: Any) { revealSearchPopup() }
    @IBAction func dismissAdvancedPopup(_ sender: Any) { dismissPopups() }
    
    
    // ------- Search Popup ------- //
    
    // ------- Elements ------- //
    @IBOutlet weak var searchPopup: UIView!
    @IBOutlet weak var searchCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var yahooButton: UIButton!
    @IBOutlet weak var bingButton: UIButton!
    @IBOutlet weak var duckButton: UIButton!
    
    // ------- Actions ------- //
    @IBAction func googleButtonAction(_ sender: Any)
    {
        engine = "Google"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (3)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissPopups();
    }
    
    @IBAction func yahooButtonAction(_ sender: Any)
    {
        engine = "Yahoo"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo (1)"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissPopups()
    }
    
    @IBAction func bingButtonAction(_ sender: Any)
    {
        engine = "Bing"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (2)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissPopups()
    }

    @IBAction func duckButtonAction(_ sender: Any)
    {
        engine = "DuckDuckGo"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo (1)"), for: .normal)
        
        dismissPopups()
    }
    
    // ------- View Did Load ------- //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
        self.searchCenterConstraint.constant = 750
            
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        
        webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!))
        
        pref.javaScriptEnabled = js
    }
    
    // ------- Progress Monitoring Functionn ------- //
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress"
        {
            progress.progress = Float(webView.estimatedProgress)
        }
    }
    
    // ------- Search Bar Handler ------- //
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        webView.resignFirstResponder()
        if let rawString = searchBar.text
        {
            let searchString = rawString.urlFormat(searchEngine: engine)
            if let searchURL = URL(string: searchString)
            {
                webView.load(URLRequest(url: searchURL) )

                let historyObject = NSManagedObject(entity: entity!, insertInto: context)
                     historyObject.setValue(searchString, forKey: "url" )
                     historyObject.setValue(Date(), forKey: "date")
                
                do { try context.save() } catch { print("Failed saving") }
            }
        }
    }
    
    // ------- Navigation Functions ------- //
    
    func  goHome() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!)) }
    func goEmail() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/webmail")!)) }
    
    func refresh() { webView.reload() }
    func goBack() { if webView.canGoBack { webView.goBack() } }
    func goForward() { if webView.canGoForward { webView.goForward() } }
    
    // ------- Other Functions ------- //
    
    func clearWebData()
    {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! { storage.deleteCookie(cookie) }
        
        self.alert(Title: "Browsing Data Deleted", Message: "")
    }
    
    func toggleJs()
    {
        if js
        {
            js = false
            jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal)
            
            pref.javaScriptEnabled = false
            alert(Title: "Javascript Disabled", Message: "")
        }
        else
        {
            js = true
            jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal)
            
            pref.javaScriptEnabled = true
            self.alert(Title: "Javascript Enabled", Message: "")
        }
    }
    
    func revealPopup(isAdvanced: Bool)
    {
        if isAdvanced
        {
            self.advancedCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
            
            if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) }
            else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
        }
        else
        {
            self.popupCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
            
            if webView.canGoBack { backButton.isEnabled = true }
            else { backButton.isEnabled = false }
            
            if webView.canGoForward { forwardButton.isEnabled = true }
            else { forwardButton.isEnabled = false }
        }
    }
    
    func revealSearchPopup()
    {
        self.searchCenterConstraint.constant = 750
        self.dismissPopupButton.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        
        if engine == "Google" { googleButton.setImage(#imageLiteral(resourceName: "icons8-google (3)"), for: .normal) }
        else if engine == "Yahoo" { yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo (1)"), for: .normal) }
        else if engine == "Bing" { bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (2)"), for: .normal) }
        else if engine == "DuckDuckGo" { duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo (1)"), for: .normal) }
    }
    
    func dismissPopups()
    {
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
        self.searchCenterConstraint.constant = 750
        
        self.dismissPopupButton.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
}

