//
//  MainRootController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 08/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit


class MainRootController:  RESideMenu, RESideMenuDelegate {
    
    

    override func awakeFromNib() {

        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0,0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.backgroundImage =  UIImage(named:"Stars")
        self.delegate = self
        
        //setup controllers
       self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController") as! UIViewController
        
        self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
        
        self.rightMenuViewController =
            self.storyboard!.instantiateViewControllerWithIdentifier("rightMenuViewController") as! UIViewController
        
        
    }
    
    
}