//
//  AppConfig.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 17/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import Foundation



//Check iOS Device

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
   
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}


// Storage Keys

struct DefaultKeys {
    static let ShopsJSON = "shopsJSON"
    static let SettingsJSON = "settingsJSON"

}



// API Structs

//let API_URL = "http://192.168.1.133:3000/api"

struct API {
	
	static func baseURL()-> String
	{
		let mainBundle = NSBundle.mainBundle();
		let appInfo = mainBundle.objectForInfoDictionaryKey("ApplicationInfo");
		return appInfo!["BASE_URL"] as! String
	}
	
	static var api : String {
		get {
			return "\(baseURL())/api"
		}
	}
	
	static var authenticate : String{
		get{
			return "\(api)/authenticate"
		}
	}
	
	static var shops : String{
		get{
			return "\(api)/shops"
		}
	}
	
	static var settings : String {
		get{
			return "\(api)/settings"
		}
	}
	
	static var review : String {
		get{
			return "\(api)/shops/%@/reviews"
		}
	}
}


struct App {
	
	// Share JSON values
	static var shareDic = "share"
	static var shareImageLink = "appShareImageLink"
	static var shareMessage = "appShareMessage"
	static var shareLink = "appShareLink"
	
	// Share Tracking
	static var shareFacebook = "shareFacebook"
	static var shareTwitter = "shareTwitter"
	static var shareMail = "shareMail"

	// App's Assets
	static var menuBackgroundImage = "appMenuBackgroundImageLink"
	
	
	
}

// Advertisement Structs

struct Ads {
    
    static let bannerId = "ca-app-pub-3524769816987474/6568279341"
    static let fullscreenId = "ca-app-pub-3524769816987474/8045012542"
    
}



class AppConfig {
    
    
     static func appTitleVersionBuild() -> String  {
    
        let appName : String =  NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        
        let appBuild = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String

        
        let versionBuild = "\(appName) v\(appVersion) (\(appBuild)) "
    
        return versionBuild
    }
    
    
}