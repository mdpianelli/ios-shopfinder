//
//  SplashController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 14/02/16.
//  Copyright © 2016 Barkala Studios. All rights reserved.
//

import UIKit
import SVProgressHUD


class SplashController:  BaseController {

	
	override func viewDidLoad() {
		super.viewDidLoad()
		authenticate()
	}
	
	func authenticate(){
		
		SVProgressHUD.show()
		
		ServerManager.authenticateUser { (result) -> Void in
			if result.isSuccess {
				self.performSegueWithIdentifier("showRootController", sender: self)
			}
			
			SVProgressHUD.dismiss()
		}
		
	}
	
}