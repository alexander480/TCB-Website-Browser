//
//  PasswordVC.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/9/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit

var passwords: [NSManagedObject]!

class PasswordVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return passwords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell") as UITableViewCell!
        cell!.textLabel!.text = history[indexPath.row].value(forKey: "url") as? String
        cell!.detailTextLabel!.text = history[indexPath.row].value(forKey: "date") as? String
        
        return cell!
    }
}

