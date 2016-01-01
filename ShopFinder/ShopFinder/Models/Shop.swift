//
//  Shop.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 22/12/15.
//  Copyright © 2015 Barkala Studios. All rights reserved.
//

import Foundation
import CoreLocation


class Shop: AnyObject {
	
	var id : String?
	var name : String?
	var rating : NSNumber?
	var address : String?
	var phoneNumber : String?
	var website : String?
	var description : String?
	var openingHours : [String]?
	var gallery : [String]?
	var geolocation : CLLocation?
	var reviewCount : NSNumber?
	
	var distance : CLLocationDistance?
	var reviews : [Review]?
	
	
	
		init(initWithDic dic : NSDictionary){
		
			id = dic["_id"] as? String
			name = dic["name"] as? String
			rating = dic["rating"] as? NSNumber
			address = dic["address"] as? String
			phoneNumber = dic["phone_number"] as? String
			description = dic["description"] as? String
			gallery = dic["photos"] as? [String]
			reviewCount = dic["reviews_count"] as? NSNumber
			
			website = dic["website"] as? String
			website = website?.stringByReplacingOccurrencesOfString("http://", withString:"")
			
			if let loc: AnyObject = dic["geolocation"]{
				if let geoloc : AnyObject = loc["location"]{
					let lat = geoloc.objectForKey("lat") as! Double
					let long = geoloc.objectForKey("lng") as! Double

					geolocation = CLLocation(latitude: lat, longitude: long)
				}
			}
		
			if let openingDic = dic["opening_hours"] as? NSDictionary {
				openingHours = openingDic["weekday_text"] as? [String]
			}
		
			
	}
	
	
	func distanceString() -> String?{
		
		var distance = self.distance
		
		if distance < 1 {
			return "On spot"
		}
		
		var distanceType = "m"
		
		if distance > 1000 {
			distanceType = "km"
			distance = distance!/1000
		}
		
		var format = "%.0f%@"
		
		if distanceType == "Km" {
			format = "%.1f%@"
		}
		
		return String(format: format ,distance!,distanceType)
		
	}
	
	
	func ratingString() -> String? {
		
		return "\(rating!.stringValue)/5"

	}
	
	func fetchReviews(completionHandler: (Shop) -> Void) -> Void {
		
		ServerManager.fetchShopReviews(self) { (result) -> Void in
			
			if result.isSuccess {
				
				guard let reviews = result.value as? [NSDictionary] else{
					return
				}
				
				var array : [Review] = []
				
				for eachReview : NSDictionary in reviews {
					array.append(Review(initWithDic: eachReview))
				}
				
				self.reviews = array
				completionHandler(self)
			}
			
		}
	}
	

}