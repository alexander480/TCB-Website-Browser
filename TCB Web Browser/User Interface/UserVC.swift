//
//  UserVC.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/21/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var buttonSelected = "Default"
    
    var history = [HistoryObject]()
    var bookmarks = [BookmarkObject]()
    var logins = [LoginObject]()
    var settings = ["Toggle Javascript", "Default Search Engine", "Delete User Data"]
    
    @IBOutlet weak var tablePopup: UIView!
    @IBOutlet weak var tableCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tableDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var accountPopup: UIView!
    @IBOutlet weak var accountCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var authPopup: UIView!
    @IBOutlet weak var authCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func login(_ sender: Any)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            auth.signIn(withEmail: email, password: password, completion: { (User, Err) in
                if let user = User
                {
                    tcbUser = TCBUser(FIRUser: user)
                    print("User \(tcbUser.uid) Has Logged In")
                }
            })
        }
    }
    
    override func viewDidLoad()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        switch(buttonSelected)
        {
            case "History":
                self.tableLabel.text = "Website History"
                self.tableDescription.text = "Manage history data here"
            case "Bookmarks":
                self.tableLabel.text = "Website Bookmarks"
                self.tableDescription.text = "Manage bookmark data here"
            case "Passwords":
                self.tableLabel.text = "Website Logins"
                self.tableDescription.text = "Manage login data here"
            case "Settings":
                self.tableLabel.text = "Browser Settings"
                self.tableDescription.text = "Manage browser settings here"
            default:
                self.tableLabel.text = "Table Title"
                self.tableDescription.text = "Data will be displayed below"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(buttonSelected) {
        case "History":
            return history.count
        case "Bookmarks":
            return bookmarks.count
        case "Passwords":
            return logins.count
        case "Settings":
            return settings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        
        switch(buttonSelected) {
        case "History":
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as UITableViewCell!
            cell!.textLabel!.text = history[row].title
            return cell!
        case "Bookmarks":
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as UITableViewCell!
            cell!.textLabel!.text = bookmarks[row].title
            return cell!
        case "Passwords":
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as UITableViewCell!
            cell!.textLabel!.text = logins[row].title
            return cell!
        case "Settings":
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as UITableViewCell!
            cell!.textLabel!.text = settings[row]
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as UITableViewCell!
            cell!.textLabel!.text = "Error #01"
            return cell!
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = indexPath.row
        
        switch(buttonSelected)
        {
            case "History":
            case "Bookmarks":
            case "Passwords":
            case "Settings":
            default:
        }
    }
    */
    
}











