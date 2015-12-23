//
//  SocialManager.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 20/12/15.
//  Copyright © 2015 Barkala Studios. All rights reserved.
//

import Foundation
import FBSDKCoreKit


class SocialManager: NSObject {
	
	static var activityItems : [AnyObject]? = nil
	
	

	
	class func prefetchSharingAssets(){
		
			guard let appSettings = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.SettingsJSON) as? NSDictionary else {
				return
			}
			
			guard let share = appSettings[App.shareDic] as? NSDictionary else{
				return
			}
		
			ServerManager.fetchImageWithURL(share[App.shareImageLink] as? String ) { (result) -> Void in
				if result.isSuccess {
					activityItems = [share[App.shareMessage]!,share[App.shareLink]!,result.value!]
				}
			}
			
	}
	
	
	class func shareApp(vc : UIViewController){
		
		if(activityItems == nil){
			return
		}

		let excludeActivities = [UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypePrint]
		
		let activityController = UIActivityViewController(activityItems: self.activityItems!, applicationActivities: nil)
		activityController.excludedActivityTypes = excludeActivities
		
		activityController.completionWithItemsHandler = { (activityType, completed, returnedItems,activityError) in
			
			if completed == false || activityError != nil {
				return;
			}
			
			var rewardID : String?
			let activity : String? = activityType
			
			if activity!.containsString("facebook"){
				rewardID = App.shareFacebook
			}
			
			if activity!.containsString("twitter"){
				rewardID = App.shareTwitter
			}
			
			if activity!.containsString("mail"){
				rewardID = App.shareMail
			}
			
			if rewardID != nil {
				FBSDKAppEvents.logEvent(rewardID, valueToSum: nil, parameters: nil, accessToken: FBSDKAccessToken.currentAccessToken())
				
				//TODO Do something with our servicies
			}
			
			
		}
		
		vc.presentViewController(activityController, animated: true, completion: nil)
	}
	
	
	class func shareShop(shop : Shop)
	{
		
		
		
	}
	
	
}