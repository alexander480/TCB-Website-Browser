//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import WebKit
import CoreFoundation
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class BrowserVC: UIViewController, UISearchBarDelegate, WKUIDelegate,  WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource
{
    let pref = WKPreferences()
    
    
    var history = [NSManagedObject]() 
    
    var engine = "Google" // Default Search Engine //
    var cookies = true // Save Cookies //
    var js = true // Enable Javascript //
    var pb = false // Private Browsing //
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progress: UIProgressView!

    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var historyPopup: UIView!
    @IBOutlet weak var historyCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dismissPopupButton: UIButton!
    @IBAction func showPopup(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3, animations: { self.menuButton.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/4)) })
        revealPopup(isAdvanced: false)
    }
    @IBAction func dismissPopup(_ sender: Any)
    {
        dismissAllPopups()
    }

    // ------- Main Popup ------- //

    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var popupCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    @IBAction func homeButtonAction(_ sender: Any) { dismissAllPopups(); goHome(); }
    @IBAction func mailButtonAction(_ sender: Any) { dismissAllPopups(); goEmail(); }
    @IBAction func reloadButtonAction(_ sender: Any) { dismissAllPopups(); refresh(); }
    @IBAction func backButtonAction(_ sender: Any) { dismissAllPopups(); goBack(); }
    @IBAction func forwardButtonAction(_ sender: Any) { dismissAllPopups(); goForward(); }
    @IBAction func showAdvancedPopup(_ sender: Any) { revealPopup(isAdvanced: true) }

    // ------- Advanced Popup  ------- //

    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var advancedPopup: UIView!
    @IBOutlet weak var advancedCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var jsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    
    @IBAction func privateButtonAction(_ sender: Any)
    {
        if pb
        {
            pb = false
            privateButton.setImage(#imageLiteral(resourceName: "icons8-hide-filled-50"), for: .normal)
            
            self.alert(Title: "Private Browsing Disabled", Message: "")
            self.dismissAllPopups()
        }
        else
        {
            pb = true
            privateButton.setImage(#imageLiteral(resourceName: "icons8-hide-filled-50 (1)"), for: .normal)
            
            self.alert(Title: "Private Browsing Enabled", Message: "")
            self.dismissAllPopups()
            
        }
    }
    @IBAction func jsButtonAction(_ sender: Any) { toggleJs(); dismissAllPopups(); }
    @IBAction func trashButton(_ sender: Any) { clearWebData(); dismissAllPopups(); }
    @IBAction func searchButtonAction(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "UP"); revealSearchPopup(); }
    @IBAction func historyButtonAction(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "UP"); revealHistoryPopup(); }
    @IBAction func dismissAdvancedPopup(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "DOWN"); revealPopup(isAdvanced: false) }
    
    // ------- Search Popup ------- //

    @IBOutlet weak var searchPopup: UIView!
    @IBOutlet weak var searchCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var yahooButton: UIButton!
    @IBOutlet weak var bingButton: UIButton!
    @IBOutlet weak var duckButton: UIButton!
    
    @IBAction func googleButtonAction(_ sender: Any)
    {
        engine = "Google"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (3)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissAllPopups()
    }

    @IBAction func yahooButtonAction(_ sender: Any)
    {
        engine = "Yahoo"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo (1)"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissAllPopups()
    }
    
    @IBAction func bingButtonAction(_ sender: Any)
    {
        engine = "Bing"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (2)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo"), for: .normal)
        
        dismissAllPopups()
    }

    @IBAction func duckButtonAction(_ sender: Any)
    {
        engine = "DuckDuckGo"
        
        googleButton.setImage(#imageLiteral(resourceName: "icons8-google (2)"), for: .normal)
        yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo"), for: .normal)
        bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (1)"), for: .normal)
        duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo (1)"), for: .normal)
        
        dismissAllPopups()
    }
    
    @IBAction func dismisSearchAction(_ sender: Any) { dismissPopup(Constraint: searchCenterConstraint, Direction: "DOWN"); revealPopup(isAdvanced: true); }
    
    // ------- View Did Load ------- //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        webView.uiDelegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dismissPopupButton.alpha = 0.0
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = 750
        self.searchCenterConstraint.constant = 750
        self.historyCenterConstraint.constant = 750
        
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        pref.javaScriptEnabled = js
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url: URL(string: "https://tcb.ai")!))
    }
    
    // ------- Monitor Progress ------- //
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    { if keyPath == "estimatedProgress" { progress.progress = Float(webView.estimatedProgress) } }
    
    // ------- Search Bar Handler ------- //
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
        webView.resignFirstResponder()
        
        if let input = searchBar.text
        {
            let searchString = input.urlFormat(searchEngine: engine)
            if let request = webView.getRequest(urlString: searchString, Private: pb) { webView.load(request) }
        }
    }
    
    // ------- Website Finished Loading ------- //
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if let url = webView.url?.absoluteString
        {
             if let historyObject = self.webView.historyObject(URL: url, Date: Date())
             {
                history.append(historyObject)
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
        self.webView.clearData()
        self.webView.clearHistory()
        self.history.removeAll()
        
        self.dismissAllPopups()
        self.alert(Title: "Browsing Data Deleted", Message: "Website cache, history and cookies have been deleted.")
    }
    
    func toggleJs()
    {
        if js { js = false; pref.javaScriptEnabled = false; jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal); alert(Title: "Javascript Disabled", Message: ""); }
        else { js = true; pref.javaScriptEnabled = true; jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal); self.alert(Title: "Javascript Enabled", Message: ""); }
        
        dismissAllPopups()
    }
    
    func revealPopup(isAdvanced: Bool)
    {
        if isAdvanced
        {
            self.advancedCenterConstraint.constant = 750; self.view.layoutIfNeeded()
            self.popupCenterConstraint.constant = -750
            self.advancedCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) }
            else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
        else
        {
            self.popupCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            if webView.canGoBack { backButton.isEnabled = true } else { backButton.isEnabled = false }
            if webView.canGoForward { forwardButton.isEnabled = true } else { forwardButton.isEnabled = false }
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
    }
    
    func revealSearchPopup()
    {
        self.advancedCenterConstraint.constant = -750
        self.dismissPopupButton.alpha = 1.0
        self.searchCenterConstraint.constant = 0
        
        if engine == "Google" { googleButton.setImage(#imageLiteral(resourceName: "icons8-google (3)"), for: .normal) }
        else if engine == "Yahoo" { yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo (1)"), for: .normal) }
        else if engine == "Bing" { bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (2)"), for: .normal) }
        else if engine == "DuckDuckGo" { duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo (1)"), for: .normal) }
        
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
    
    func revealHistoryPopup()
    {
        if let historyData = self.webView.fetchHistory() { self.history = historyData }
        
        tableView.reloadData()
        
        self.advancedCenterConstraint.constant = -750
        self.historyCenterConstraint.constant = 0
        self.dismissPopupButton.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
    
    func dismissAllPopups()
    {
        dismissPopup(Constraint: self.searchCenterConstraint, Direction: "DOWN")
        dismissPopup(Constraint: self.historyCenterConstraint, Direction: "DOWN")
        dismissPopup(Constraint: self.advancedCenterConstraint, Direction: "DOWN")
        dismissPopup(Constraint: self.popupCenterConstraint, Direction: "DOWN")
        
        UIView.animate(withDuration: 0.3, animations: { self.menuButton.transform = CGAffineTransform.identity.rotated(by: CGFloat(0)) })
    }
    
    func dismissPopup(Constraint: NSLayoutConstraint?, Direction: String?)
    {
        if Direction == "UP"
        {
            self.dismissPopupButton.alpha = 0.0
            Constraint!.constant = CGFloat(-750)
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
        else if Direction == "DOWN"
        {
            self.dismissPopupButton.alpha = 0.0
            Constraint!.constant = CGFloat(750)
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
    }
    
    // ------- Table View ------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return history.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as UITableViewCell!
            cell?.textLabel?.text = "Website History"
            
            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as UITableViewCell!
            cell?.textLabel?.text = history[indexPath.row - 1].value(forKey: "url") as? String
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        dismissAllPopups()
        
        let url = history[indexPath.row - 1].value(forKey: "url") as? String
        webView.load(URLRequest(url: URL(string: url!)!))
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
        self.searchCenterConstraint.constant = 750
    }
}

