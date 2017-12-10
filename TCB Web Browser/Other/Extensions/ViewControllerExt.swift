//
//  ext.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 11/7/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import CoreData
import WebKit
import UIKit


extension UIViewController
{
    func clearDataAlert(WebView: WKWebView)
    {
        WebView.WKDataAlert(ViewController: self, WebView: WebView)
        (self as! BrowserVC).dismissAllPopups()
    }
    
    func alert(Title: String, Message: String )
    {
        if Message.isEmpty
        {
            let alert = UIAlertController(title: Title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    @objc func alertControllerBackgroundTapped() { self.dismiss(animated: true, completion: nil) }
}

@IBDesignable class FormTextField: UITextField {
    @IBInspectable var borderColor: UIColor? { didSet { layer.borderColor = borderColor?.cgColor } }
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }
    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } }
}

@IBDesignable class ViewClass: UIView { @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } } }


