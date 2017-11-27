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

var history = [NSManagedObject]()

var fromHistory = false
var urlFromHistory = ""

var engine = "Google"
var cookies = true
var js = true

class BrowserVC: UIViewController, UISearchBarDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource
{
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
    
    // ------- Elements ------- //
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var popupCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    // ------- Actions ------- //
    @IBAction func homeButtonAction(_ sender: Any) { dismissAllPopups(); goHome(); }
    @IBAction func mailButtonAction(_ sender: Any) { dismissAllPopups(); goEmail(); }
    @IBAction func reloadButtonAction(_ sender: Any) { dismissAllPopups(); refresh(); }
    @IBAction func backButtonAction(_ sender: Any) { dismissAllPopups(); goBack(); }
    @IBAction func forwardButtonAction(_ sender: Any) { dismissAllPopups(); goForward(); }
    @IBAction func showAdvancedPopup(_ sender: Any) { revealPopup(isAdvanced: true) }

    
    // ------- Advanced Popup  ------- //
    
    // ------- Elements ------- //
    @IBOutlet weak var advancedPopup: UIView!
    @IBOutlet weak var advancedCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var jsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    // ------- Actions ------- //
    @IBAction func jsButtonAction(_ sender: Any) { toggleJs(); dismissAllPopups(); }
    @IBAction func trashButton(_ sender: Any) { clearWebData(); dismissAllPopups(); }
    @IBAction func searchButtonAction(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "UP"); revealSearchPopup(); }
    @IBAction func historyButtonAction(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "UP"); revealHistoryPopup(); }
    @IBAction func dismissAdvancedPopup(_ sender: Any) { dismissPopup(Constraint: advancedCenterConstraint, Direction: "DOWN"); revealPopup(isAdvanced: false) }
    
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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progress.transform = transform
        
        self.dismissPopupButton.alpha = 0.0
        
        self.popupCenterConstraint.constant = 750
        self.advancedCenterConstraint.constant = 750
        self.searchCenterConstraint.constant = 750
        self.historyCenterConstraint.constant = 750
            
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        
        if fromHistory { webView.load(URLRequest(url: URL(string: urlFromHistory)!)); fromHistory = false }
        else { webView.load(URLRequest(url: URL(string: "https://tcb.ai/")!)) }
        
        pref.javaScriptEnabled = js
    }
    
    // ------- Progress Monitoring Functionn ------- //
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    { if keyPath == "estimatedProgress" { progress.progress = Float(webView.estimatedProgress) } }
    
    // ------- Search Bar Handler ------- //
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
        webView.resignFirstResponder()
        
        if let rawString = searchBar.text
        {
            let searchString = rawString.urlFormat(searchEngine: engine)
            if let searchURL = URL(string: searchString)
            {
                webView.load(URLRequest(url: searchURL) )
                
                let date = Date()
                let historyObject = self.historyObject(URL: searchString, Date: date)
                if historyObject.value(forKey: "url") == nil
                {
                    print("Error Creating History Object")
                }
                else
                {
                    history.append(historyObject)
                    print(historyObject)
                }
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
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        
        history = [NSManagedObject]()
        
        self.alert(Title: "Browsing Data Deleted", Message: "")
        dismissAllPopups()
    }
    
    func toggleJs()
    {
        if js
        {
            js = false
            jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal)
            
            pref.javaScriptEnabled = false
            alert(Title: "Javascript Disabled", Message: "")
            dismissAllPopups()
        }
        else
        {
            js = true
            jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal)
            
            pref.javaScriptEnabled = true
            self.alert(Title: "Javascript Enabled", Message: "")
            dismissAllPopups()
        }
    }
    
    func revealPopup(isAdvanced: Bool)
    {
        if isAdvanced
        {
            self.advancedCenterConstraint.constant = 750; self.view.layoutIfNeeded()
            self.popupCenterConstraint.constant = -750
            self.advancedCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
            
            if js { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled")  , for: .normal) } else { jsButton.setImage( #imageLiteral(resourceName: "icons8-javascript-filled (1)")  , for: .normal) }
        }
        else
        {
            takeScreenshot()
            
            self.popupCenterConstraint.constant = 0
            self.dismissPopupButton.alpha = 1.0
            
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
            
            if webView.canGoBack { backButton.isEnabled = true } else { backButton.isEnabled = false }
            if webView.canGoForward { forwardButton.isEnabled = true } else { forwardButton.isEnabled = false }
        }
    }
    
    func revealSearchPopup()
    {
        self.advancedCenterConstraint.constant = -750
        self.searchCenterConstraint.constant = 0
        
        self.dismissPopupButton.alpha = 1.0
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
        
        if engine == "Google" { googleButton.setImage(#imageLiteral(resourceName: "icons8-google (3)"), for: .normal) }
        else if engine == "Yahoo" { yahooButton.setImage(#imageLiteral(resourceName: "icons8-yahoo (1)"), for: .normal) }
        else if engine == "Bing" { bingButton.setImage(#imageLiteral(resourceName: "icons8-bing (2)"), for: .normal) }
        else if engine == "DuckDuckGo" { duckButton.setImage(#imageLiteral(resourceName: "icons8-duckduckgo (1)"), for: .normal) }
    }
    
    func revealHistoryPopup()
    {
        history = fetchCoreDate(EntityName: "History")
        
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
        var direction = 0
        
        if Direction == "UP" { direction = -750 }
        else if Direction == "DOWN" { direction = 750 }
        
        Constraint!.constant = CGFloat(direction)
        
        self.dismissPopupButton.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
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
    
    func takeScreenshot()
    {
        print("Taking Screenshot...")
        let sixzevid = CGSize(width: 1024, height: 1100)
        UIGraphicsBeginImageContext(sixzevid)
        webView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageData = NSData()
        imageData = UIImagePNGRepresentation(viewImage!)! as NSData
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathFolder = String(String(format:"%@", "new.png"))
        let defaultDBPathURL = NSURL(fileURLWithPath: documentsPath).appendingPathComponent(pathFolder)
        let defaultDBPath = "\(String(describing: defaultDBPathURL))"
        imageData.write(toFile: defaultDBPath, atomically: true)
        let image = UIImage(data: imageData as Data)
        print("Done.")
        
        UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
    }
}

