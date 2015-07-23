//
//  UIViewController+Style.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 23/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import FontAwesomeKit

extension UIViewController {
    
    
    func menuBtn()-> UIBarButtonItem {
        
        // set left navBarIcon to open left menu
        var cogIcon : FAKFontAwesome = FAKFontAwesome.naviconIconWithSize(20)
        
        var image = self.imageFromAFont(cogIcon)
        
        return UIBarButtonItem(image: image, landscapeImagePhone: nil, style:.Plain, target:self, action:"presentLeftMenuViewController:")
        
    }
    
    
    func imageFromAFont(icon : FAKFontAwesome)-> UIImage {
        
        icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
        
       return icon.imageWithSize(CGSizeMake(icon.iconFontSize, icon.iconFontSize))
        
    }
    
    
    
}
