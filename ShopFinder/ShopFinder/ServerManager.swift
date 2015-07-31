//
//  ServerManager.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation
import Alamofire





class ServerManager : NSObject {
    
    
    
    class func retrieveShops(completionHandler: (AnyObject?, NSError?) -> Void) -> Void {
        
        Alamofire.request(.GET, API.shops )
            .responseJSON { (_, _, obj, error) in
                completionHandler(obj,error)
        }
              
    }
    
    
    class func fetchSettings(completionHandler: (AnyObject?, NSError?) -> Void) -> Void {
        
        Alamofire.request(.GET, API.settings )
            .responseJSON { (_, _, obj, error) in
                completionHandler(obj,error)
        }
        
    }
    
}