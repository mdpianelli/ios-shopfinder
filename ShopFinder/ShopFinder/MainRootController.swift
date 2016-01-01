//
//  MainRootController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 08/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import RESideMenu

class MainRootController:  RESideMenu, RESideMenuDelegate {
	
		var navController : UINavigationController?
	

    override func awakeFromNib() {
			
				navController = self.storyboard?.instantiateViewControllerWithIdentifier("AppNavigationController") as? UINavigationController
			
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0,0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.backgroundImage =  UIImage(named:"Stars")
        self.delegate = self
        
        //setup controllers
       self.contentViewController = navController
   
			navController?.setViewControllers(
				[self.storyboard!.instantiateViewControllerWithIdentifier("ShopListController")], animated: false)
			
        self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuController") 
        
//        self.rightMenuViewController =
//            self.storyboard!.instantiateViewControllerWithIdentifier("rightMenuViewController") as! UIViewController
        
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//prefetch all app's settings
		SocialManager.prefetchSharingAssets()
		
		
		ServerManager.prefetchAppSettings { (result) -> Void in
			
			guard let dic = result as? NSDictionary else{
				return;
			}
			
			guard let config = dic["config"] as? NSDictionary else{
				return
			}
			
			guard let  link  = config[App.menuBackgroundImage] as? String else{
				return;
			}
			
		
			ServerManager.fetchImageWithURL(link, completionHandler: { (result) -> Void in
				if result.isSuccess{
					self.backgroundImage = result.value;
				}
			})
			
			
		}
			
	}
	
	
	func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!)
	{
		UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)

	}
	
	
	func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!)
	{
		UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

	}
}