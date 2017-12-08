//
//  SegmentedControlExt.swift
//  TCB Web Browser
//
//  Created by Alexander Lester on 12/5/17.
//  Copyright © 2017 LAGB Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl
{
    func removeBorders() {
        if let background = self.backgroundColor
        { setBackgroundImage(imageWithColor(color: background), for: .normal, barMetrics: .default) }
        
        if let tint = self.tintColor
        { setBackgroundImage(imageWithColor(color: tint), for: .selected, barMetrics: .default) }
        
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
