//
//  ServerManager.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation
import Alamofire


let API_URL = "http://shop-finder.eu01.aws.af.cm/api/shops"



class ServerManager : NSObject {
    
    
    
    class func retrieveShops(completionHandler: (AnyObject?, NSError?) -> Void) -> Void {
        
        Alamofire.request(.GET, API_URL)
            .responseJSON { (_, _, obj, error) in
                completionHandler(obj,error)
        }
              
    }
    
}