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
	
	static var manager : Manager?
	
	class func setupManager(){
		
		//Get the latest token used
		let latestToken = NSUserDefaults.standardUserDefaults().objectForKey(App.tokenKey) as? String
		
		if latestToken != nil {
			App.token = latestToken
			configureManager()
		}
		
	}
	
	class func configureManager(){
		
		// Adding headers
		var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
		defaultHeaders["x-access-token"] = App.token
		
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		configuration.HTTPAdditionalHeaders = defaultHeaders
		
		// Adding parameters
		manager = Alamofire.Manager(configuration: configuration)
		
		
	}
	
	class func authenticateUser(completionHandler: (Result<AnyObject>) -> Void){
	
		// Re capochax TODO: Create a proper registration
		let myParams = "name=tappas&password=j3%2FnTB5(s%3F%3D%2Bh6zv"
		let postData = myParams.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
		let postLength = String(format: "%d", postData!.length)
		
		let myRequest = NSMutableURLRequest(URL: NSURL(string:API.authenticate)!)
		myRequest.HTTPMethod = "POST"
		myRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
		myRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		myRequest.HTTPBody = postData
		
		
		let request = Alamofire.Manager.sharedInstance.request(myRequest)
		
		request.responseJSON(completionHandler: {(request, response, result) -> Void in

			if result.isSuccess {
				
				guard let token = result.value!["token"] as? String else{
					NSLog("Authentication failed, no token returned")
					return
				}

				NSUserDefaults.standardUserDefaults().setObject(token, forKey: App.tokenKey)
				App.token = token
				self.configureManager()
				completionHandler(result)
			}
			
		})
		
		request.resume()
		
		
	}
	
	
	class func fetchShops(location loc : CLLocation,completionHandler: (NSArray) -> Void) -> Void {
			
		
		manager!.request(.GET, API.shops, parameters: ["user":"tappas","latitude":"\(loc.coordinate.latitude)","longitude":"\(loc.coordinate.longitude)"], encoding: .JSON, headers: nil).responseJSON { (request, response, result) -> Void in
					
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
//            manager!.request(.GET, API.shops )
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
		manager!.request(.GET, API.settings).responseJSON { (request, response, result) -> Void in
			
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
			
			manager!.request(.GET, API.settings).responseJSON { (request, response, result) -> Void in
				
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
		
		
		manager!.request(.GET, link! ).responseData { (request, response, result) -> Void in
			
			if response?.statusCode == 200 {
				let img = UIImage(data: result.value!)
				completionHandler(Result.Success(img!))
			}
		}
		
	}
	
	
	class func fetchShopReviews(shop: Shop, completionHandler: (Result<AnyObject>) -> Void) -> Void {
		//NSUserDefaults.standardUserDefaults().removeObjectForKey(DefaultKeys.ShopsJSON)
		let link  = NSString(format: API.review, shop.id!) as String
		
	
		manager!.request(.GET,link).responseJSON { (request, response, result) -> Void in
			completionHandler(result)
		}
		
	}
	
	
}