//
//  ViewController.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/6/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreData
import Firebase
import WebKit


// -------------------------------------------------- //
// ------------------ Global Variables ------------------ //
// -------------------------------------------------- //

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

let auth = Auth.auth()
var tcbUser: TCBUser!


// -------------------------------------------------- //
// -------------- Start View Controller Class -------------- //
// -------------------------------------------------- //

class BrowserVC: UIViewController, UISearchBarDelegate, WKUIDelegate,  WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource
{
    let pref = WKPreferences()
    var history = [NSManagedObject]()
    
    var engine = "Google"
    var isPrivate = false
    var cookies = true
    var js = true
    
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
    @IBAction func dismissPopup(_ sender: Any) { dismissAllPopups() }
    
    
    // -------------------------------------------------- //
    // -------------------- Main Popup -------------------- //
    // -------------------------------------------------- //
    
    @IBOutlet weak var mainPopup: UIView!
    @IBOutlet weak var mainCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userButton: UIButton!
    @IBAction func userAction(_ sender: Any)
    {
        if let user = auth.currentUser
        {
            print("User \(user.uid) Is Currently Signed In")
            dismissPopup(Constraint: self.mainCenterConstraint, Direction: "UP")
            self.present(UserVC(), animated: true, completion: nil)
        }
        else
        {
            print("No User Is Currently Signed In")
            dismissPopup(Constraint: self.mainCenterConstraint, Direction: "UP")
            self.present(AuthVC(), animated: true, completion: nil)
        }
    }
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func homeAction(_ sender: Any) { dismissAllPopups(); goHome(); }
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshAction(_ sender: Any) { dismissAllPopups(); refresh(); }
    
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreAction(_ sender: Any) { revealPopup(isAdvanced: true) }
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backAction(_ sender: Any) { dismissAllPopups(); goBack(); }
    
    @IBOutlet weak var forwardButton: UIButton!
    @IBAction func forwardAction(_ sender: Any) { dismissAllPopups(); goForward(); }

    
    // -------------------------------------------------- //
    // ------------------ Advanced Popup ------------------ //
    // -------------------------------------------------- //
    
    @IBOutlet weak var advancedPopup: UIView!
    @IBOutlet weak var advancedCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var privateButton: UIButton!
    @IBAction func privateAction(_ sender: Any) { togglePrivate(); dismissAllPopups() }
    
    @IBOutlet weak var jsButton: UIButton!
    @IBAction func jsAction(_ sender: Any) { toggleJs(); dismissAllPopups() }
    
    @IBOutlet weak var passwordButton: UIButton!
    @IBAction func passwordAction(_ sender: Any) { dismissPopup(Constraint: self.advancedCenterConstraint, Direction: "UP") }
    
    @IBOutlet weak var trashButton: UIButton!
    @IBAction func trashAction(_ sender: Any) { clearDataAlert(WebView: self.webView); dismissAllPopups(); }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchAction(_ sender: Any) { dismissPopup(Constraint: self.advancedCenterConstraint, Direction: "UP") }
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissAction(_ sender: Any) { dismissPopup(Constraint: self.advancedCenterConstraint, Direction: "DOWN") }
    
    
    // ---------------------------------------- //
    // -------------- View Did Load -------------- //
    // ---------------------------------------- //
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dismissPopupButton.alpha = 0.0
        self.mainCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = 750
        self.historyCenterConstraint.constant = 750
        
        progress.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        pref.javaScriptEnabled = js
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.load(URLRequest(url: URL(string: "https://tcb.ai")!))
    }
    
    // -------------- Monitor Loading Progress -------------- //
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    { if keyPath == "estimatedProgress" { progress.progress = Float(webView.estimatedProgress) } }

    
    // -------------- Search Bar Handler -------------- //
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
        webView.resignFirstResponder()
        
        if let input = searchBar.text
        {
            let searchString = input.urlFormat(searchEngine: engine)
            if let request = webView.getRequest(urlString: searchString, Private: isPrivate) { webView.load(request) }
        }
    }

    // -------------- Website Finished Loading -------------- //
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if (isPrivate) { print("Private Mode Active - Not Saving History Data") }
        else
        {
            if let url = webView.url?.absoluteString
            {
                if (url == "https://tcb.ai/" || url == "https://www.tcb.ai/" || url == "http://tcb.ai/" || url == "http://tcb.ai/") { print("Visted Home Page - Not Saving To History Data"); return }
                else {  if let historyObject = self.webView.historyObject(URL: url, Date: Date()) { history.append(historyObject); print(historyObject) } }
            }
        }
    }
    
    // -------------- Browser Navigation -------------- //
    
    func  goHome() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!)) }
    func goEmail() { webView.load(URLRequest(url: URL(string: "https://tcb.ai/webmail")!)) }
    
    func refresh() { webView.reload() }
    func goBack() { if webView.canGoBack { webView.goBack() } }
    func goForward() { if webView.canGoForward { webView.goForward() } }
    
    // -------------- Browser Data Management -------------- //

    func deleteHistory(FromPastDays: Int)
    {
        var bufArray = [NSManagedObject]()
        for object in history
        {
            if let date = object.value(forKey: "date")
            {
                let daysSinceCreation = Int((((date as! Date).timeIntervalSinceNow) / 86400))
                
                if daysSinceCreation <= FromPastDays { context.delete(object) }
                else { bufArray.append(object) }
            }
        }
        self.history = bufArray
    }
    
    func deleteSessionData(FromPastDays: Int)
    {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage])
        let seconds = ((((FromPastDays) * 24) * 60) * 60)
        let date = Date(timeInterval: TimeInterval(seconds), since: Date())
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
    }
    
    func deleteCookies(FromPastDays: Int)
    {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeCookies])
        let seconds = ((((FromPastDays) * 24) * 60) * 60)
        let date = Date(timeInterval: TimeInterval(seconds), since: Date())
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler: { })
    }
    
    func deleteCache(FromPastDays: Int)
    {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let seconds = ((((FromPastDays) * 24) * 60) * 60)
        let date = Date(timeInterval: TimeInterval(seconds), since: Date())
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        
        self.deleteHistory(FromPastDays: FromPastDays)
    }
    
    func deleteData(FromPastDays: Int)
    {
        self.deleteHistory(FromPastDays: FromPastDays)
        self.deleteCookies(FromPastDays: FromPastDays)
        self.deleteCache(FromPastDays: FromPastDays)
        self.deleteSessionData(FromPastDays: FromPastDays)
    }
    
    // -------------- Browser Settings -------------- //
    
    private func toggleJs()
    {
        if js { js = false; pref.javaScriptEnabled = false; jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal); alert(Title: "Javascript Disabled", Message: ""); }
        else { js = true; pref.javaScriptEnabled = true; jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal); self.alert(Title: "Javascript Enabled", Message: ""); }
        
        dismissAllPopups()
    }
    
    private func togglePrivate()
    {
        if isPrivate
        {
            isPrivate = false;
            privateButton.setImage(#imageLiteral(resourceName: "icons8-hide-filled-50"), for: .normal);
            
            self.alert(Title: "Private Browsing Disabled", Message: "");
            self.dismissAllPopups()
        }
        else
        {
            isPrivate = true;
            privateButton.setImage(#imageLiteral(resourceName: "icons8-hide-filled-50 (1)"), for: .normal);
            
            self.alert(Title: "Private Browsing Enabled", Message: "");
            self.dismissAllPopups()
        }
    }
    
    // -------------- Popup Control -------------- //
    
    private func revealPopup(isAdvanced: Bool)
    {
        if isAdvanced
        {
            self.advancedCenterConstraint.constant = 750; self.view.layoutIfNeeded()
            self.mainCenterConstraint.constant = -750
            self.advancedCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) }
            else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
        else
        {
            self.mainCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            if webView.canGoBack { backButton.isEnabled = true } else { backButton.isEnabled = false }
            if webView.canGoForward { forwardButton.isEnabled = true } else { forwardButton.isEnabled = false }
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        }
    }
    
    
    
    private func revealHistoryPopup()
    {
        if let historyData = self.webView.fetchHistory() { history = historyData }
        
        tableView.reloadData()
        
        self.advancedCenterConstraint.constant = -750
        self.historyCenterConstraint.constant = 0
        self.dismissPopupButton.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
    
    func dismissAllPopups()
    {
        dismissPopup(Constraint: self.historyCenterConstraint, Direction: "DOWN")
        dismissPopup(Constraint: self.advancedCenterConstraint, Direction: "DOWN")
        dismissPopup(Constraint: self.mainCenterConstraint, Direction: "DOWN")
        
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
    
    // -------------- Table View -------------- //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return history.count + 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {  if indexPath.row == 0 { return 75.0 } else {  return 50.0 } }
    
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
        
        if indexPath.row == 0 { dismissPopup(Constraint: historyCenterConstraint, Direction: "DOWN") }
        else { let url = history[indexPath.row - 1].value(forKey: "url") as? String; webView.load(URLRequest(url: URL(string: url!)!)) }
    }
    
    // -------------- View Will Disappear -------------- //
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        
        self.mainCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = -750
    }

}

