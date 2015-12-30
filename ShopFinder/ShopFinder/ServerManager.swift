//
//  ServerManager.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation
import Alamofire
//import ReachabilitySwift
import CoreLocation




class ServerManager : NSObject {
	
	class func setupManager(){
		
		ServerManager.authenticateUser()
		//Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["x-access-token":"TOKEN"]
	}
    
	
	class func authenticateUser(){
	
		// Re capochax TODO: Create a proper registration
		let myParams = "username=tappas&password=j3/nTB5(s?=+h6zv"
		let postData = myParams.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
		let postLength = String(format: "%d", postData!.length)
		
		let myRequest = NSMutableURLRequest(URL: NSURL(string:API.authenticate)!)
		myRequest.HTTPMethod = "POST"
		myRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
		myRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		myRequest.HTTPBody = postData
		
		
		let request = Alamofire.request(myRequest)
		request.responseJSON(completionHandler: {(request, response, result) -> Void in

			NSLog("assda")
			
		})
		
		
	}
	
	
	class func fetchShops(location loc : CLLocation,completionHandler: (NSArray) -> Void) -> Void {
			
		
		Alamofire.request(.POST, API.shops, parameters: ["user":"tappas","latitude":"\(loc.coordinate.latitude)","longitude":"\(loc.coordinate.longitude)"], encoding: .JSON, headers: nil).responseJSON { (request, response, result) -> Void in
					
						var data : AnyObject?
					
						if result.isFailure {
							data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.ShopsJSON)
							
							if data == nil {
								print(result.error)
								return
							}
							
						}else{
							NSUserDefaults.standardUserDefaults().setObject(result.value!, forKey: DefaultKeys.ShopsJSON)
							data = result.value
						}
					
					if data != nil {
            completionHandler(data as! NSArray)
					}
					
        }
        
       // if Reachability.reachabilityForInternetConnection().isReachable() {
//            Alamofire.request(.GET, API.shops )
//                .responseJSON { (_, _, obj, error) in
//                    NSUserDefaults.standardUserDefaults().setObject(obj, forKey: DefaultKeys.ShopsJSON)
//                    completionHandler(obj,error)
//            }
//        }else{
//            let obj: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.ShopsJSON)
//            if obj != nil {
//                completionHandler(obj,nil)
//            }
//        }
        
    }
	
	
	
	class func prefetchAppSettings(completionHandler: (AnyObject?) -> Void) -> Void {

		//fetch App Settings
		Alamofire.request(.GET, API.settings).responseJSON { (request, response, result) -> Void in
			
			if result.isSuccess {
				let dic = result.value as! NSDictionary
				NSUserDefaults.standardUserDefaults().setObject(dic.copy(), forKey: DefaultKeys.SettingsJSON)
				completionHandler(dic)
			}
		}
		
	}
	
	
    class func fetchSettings(completionHandler: (AnyObject?) -> Void) -> Void {
		//NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultKeys.ShopsJSON)
		
		let dic  = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.SettingsJSON) as? NSDictionary
		
		if dic != nil {
			completionHandler(dic)
			return
		}else{
			
			Alamofire.request(.GET, API.settings).responseJSON { (request, response, result) -> Void in
				
				if result.isSuccess {
					let dic = result.value as! NSDictionary
					NSUserDefaults.standardUserDefaults().setObject(dic, forKey: DefaultKeys.SettingsJSON)
					completionHandler(dic)
				}
			}
		}
		
    }
	
	
	class func fetchImageWithURL(link : String? ,completionHandler:(Result<UIImage>)-> Void){
		
		guard link != nil else {
			return
		}
		
		
		Alamofire.request(.GET, link! ).responseData { (request, response, result) -> Void in
			
			if response?.statusCode == 200 {
				let img = UIImage(data: result.value!)
				completionHandler(Result.Success(img!))
			}
		}
		
	}
	
	
	class func fetchShopReviews(shop: Shop, completionHandler: (Result<AnyObject>) -> Void) -> Void {
		//NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultKeys.ShopsJSON)
		let link  = NSString(format: API.review, shop.id!) as String
		
	
		Alamofire.request(.GET,link).responseJSON { (request, response, result) -> Void in
			completionHandler(result)
		}
		
	}
	
	
}