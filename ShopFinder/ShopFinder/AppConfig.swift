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

let API_URL = "http://shop-finder.eu01.aws.af.cm/api"
//let API_URL = "http://192.168.1.133:3000/api"

struct API {
    
    static let base = API_URL
    
    static let shops =  base + "/shops"
    
    static let settings = base + "/settings"
    
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