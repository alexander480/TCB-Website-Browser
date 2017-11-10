//
//  SettingsVC.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/8/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    let settings = ["Enable Javascript", "Enable Cookies", "History", "Passwords", "Search Engine"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch (indexPath.row)
        {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowCell", for: indexPath as IndexPath)
                let tap = UITapGestureRecognizer(target: cell, action: #selector(didTapBrowser(Sender:)))
                
                cell.textLabel!.text = settings[4]
                cell.addGestureRecognizer(tap)
                
                return cell
        
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowCell", for: indexPath as IndexPath)
                let tap = UITapGestureRecognizer(target: cell, action: #selector(didTapHistory(Sender:)))
                
                cell.textLabel!.text = settings[2]
                cell.addGestureRecognizer(tap)
                
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowCell", for: indexPath as IndexPath)
                let tap = UITapGestureRecognizer(target: cell, action: #selector(didTapPassword(Sender:)))
                
                cell.textLabel!.text = settings[3]
                cell.addGestureRecognizer(tap)
                
                return cell
           
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchCell
                cell.label.text = settings[0]
                if cell.slider.isOn { js = true } else { js = false }
            
                return cell
            
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchCell
                
                cell.label.text = settings[1]
                if cell.slider.isOn { cookies = true } else { cookies = false }
            
                return cell
            
            
            
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchCell
            cell.label.text = "Default"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    @objc func didTapHistory(Sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "toHistory", sender: Sender)
    }
    
    @objc func didTapPassword(Sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "toPassword", sender: Sender)
    }
    
    @objc func didTapBrowser(Sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "toBrowser", sender: Sender)
    }
}

class SwitchCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISwitch!
}
