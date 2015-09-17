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
    
    
    class func fetchSettings(completionHandler: (Result<AnyObject>) -> Void) -> Void {
        
        Alamofire.request(.GET, API.settings ).responseJSON { (request, response, result) -> Void in
            
            if result.isSuccess {
                NSUserDefaults.standardUserDefaults().setObject(result.value!, forKey: DefaultKeys.ShopsJSON)
            }
            
            completionHandler(result)
            
        }
        
     
        
    }
    
}