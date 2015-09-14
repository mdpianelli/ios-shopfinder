//
//  ServerManager.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift




class ServerManager : NSObject {
    
    
    
    class func retrieveShops(completionHandler: (AnyObject?, NSError?) -> Void) -> Void {
        
        if Reachability.reachabilityForInternetConnection().isReachable() {
            Alamofire.request(.GET, API.shops )
                .responseJSON { (_, _, obj, error) in
                    NSUserDefaults.standardUserDefaults().setObject(obj, forKey: DefaultKeys.ShopsJSON)
                    completionHandler(obj,error)
            }
        }else{
            let obj: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.ShopsJSON)
            if obj != nil {
                completionHandler(obj,nil)
            }
        }
        
    }
    
    
    class func fetchSettings(completionHandler: (AnyObject?, NSError?) -> Void) -> Void {
        
        Alamofire.request(.GET, API.settings )
            .responseJSON { (_, _, obj, error) in
                completionHandler(obj,error)
        }
        
    }
    
}