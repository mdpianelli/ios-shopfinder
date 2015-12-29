//
//  Review.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 28/12/15.
//  Copyright © 2015 Barkala Studios. All rights reserved.
//

import Foundation

class Review: AnyObject {
	
	var rating : NSNumber?
	var text : String?
	var date : NSDate?
	
	
	init(initWithDic dic : NSDictionary){
		
		rating = dic["rating"] as? NSNumber
		text = dic["text"] as? String
		let timestamp  = dic["time"] as? NSNumber
		date = NSDate(timeIntervalSince1970: timestamp!.doubleValue);
		
	}

}