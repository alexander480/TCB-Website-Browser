//
//  HistoryVC.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/9/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit

var history: [NSManagedObject]!

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Fetch History Objects From Core Data Here //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as UITableViewCell!
             cell!.textLabel!.text = history[indexPath.row].value(forKey: "url") as? String
             cell!.detailTextLabel!.text = history[indexPath.row].value(forKey: "date") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url = history[indexPath.row].value(forKey: "url") as! String
        print(url)
    }
}







