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




class ServerManager : NSObject {
    
    
    
    class func retrieveShops(completionHandler: (Result<AnyObject>) -> Void) -> Void {
        
        Alamofire.request(.GET, API.shops).responseJSON { (request, response, result) -> Void in
            
            if result.isSuccess {
                NSUserDefaults.standardUserDefaults().setObject(result.value!, forKey: DefaultKeys.ShopsJSON)
            }
            
            completionHandler(result)

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
		
		Alamofire.request(.GET, link! ).responseJSON { (request, response, result) -> Void in
			
			if result.isSuccess {
				let img = UIImage(data: result.value as! NSData)
				completionHandler(Result.Success(img!))
			}
		}
		
	}
	
}