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
		
		ServerManager.fetchImageWithURL(appSettings[App.shareImageLink] as? String ) { (result) -> Void in
			if result.isSuccess {
				activityItems = [appSettings[App.shareMessage]!,appSettings[App.shareLink]!,result.value!]
			}
		}
		
	}
	
	class func share(vc : UIViewController){
		
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
//		[activityController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
//		
//		NSString *rewardsID = nil;
//		
//		if( !completed || activityError != nil ){
//		NSLog(@"%@",[activityError description]);
//		return;
//		}
//		
//		if([activityType.lowercaseString containsString:@"facebook"])
//		{
//		rewardsID = @"pts_share_facebook";
//		}
//		if([activityType.lowercaseString containsString:@"twitter"])
//		{
//		rewardsID = @"pts_share_twitter";
//		}
//		if([activityType.lowercaseString containsString:@"instagram"])
//		{
//		rewardsID = @"pts_share_instragram";
//		
//		}
//		
//		
//		if(rewardsID){
//		
//		[FBSDKAppEvents logEvent:rewardsID
//		valueToSum:nil
//		parameters:nil
//		accessToken:[FBSDKAccessToken currentAccessToken]];
//		
//		NSURLSessionTask *task = [[GIRestApiManager sharedInstance] rewardsWithID:rewardsID
//		withCompletionHandler:^(id dataObject, NSHTTPURLResponse *response, NSError *error) {
//		
//		dispatch_barrier_async(dispatch_get_main_queue(), ^{
//		[[[UIAlertView alloc] initWithTitle:[NSLocalizedString(@"SIDE_MENU_REWARDS", @"") uppercaseString] message:NSLocalizedString(@"REWARDS_SHARED_MESSAGE", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//		});
//		
//		
//		}];
//		[task resume];
//		}
//		}];
//		
//		
//		
//		
//  if(self.showInViewController){
//	if(IS_IPAD){
//		UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
//		
//		[popup presentPopoverFromRect:CGRectMake(self.showInViewController.view.frame.size.width/2,
//			self.showInViewController.view.frame.size.height/2,
//			0,
//			0)
//			inView:self.showInViewController.view
//			permittedArrowDirections:UIPopoverArrowDirectionUnknown
//			animated:YES];
//	}else
//	{
//		[self.showInViewController presentViewController:activityController
//			animated:YES
//			completion:^{
//			[self.showInViewController.view bringSubviewToFront:activityController.view];
//			}];
//	}
//  }

		
		
	}
	
	
	
}