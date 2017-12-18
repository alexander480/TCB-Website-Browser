//
//  StoryboardExt.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/13/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class FormTextField: UITextField
{
    @IBInspectable var borderColor: UIColor? { didSet { layer.borderColor = borderColor?.cgColor } }
    @IBInspectable var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }
    @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } }
}

@IBDesignable class ViewClass: UIView { @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } } }
@IBDesignable class ButtonClass: UIButton { @IBInspectable var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius  } } }
