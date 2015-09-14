//
//  BaseController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 14/09/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import UIAlertView_Blocks

class BaseController:  UIViewController {

    
    
    func callAction(item: TableRow){
        
        var number = item.action?.data as! String
        var trimNumber = number.removeWhitespace()
        
        if let url = NSURL(string: "tel://\(trimNumber)") {
   
            UIAlertView.showWithTitle(NSLocalizedString("Would you like to call?",comment:""), message:"", cancelButtonTitle: "Cancel", otherButtonTitles:["Call"]) { (alertView, index) -> Void in
                
                switch(index){
                case 1 :
                    UIApplication.sharedApplication().openURL(url)
                    
                default : break;
                    
                }
            }
            
        }
    
        
    }
    
    
    //MARK: Actions

    func openDlinkAction(item: TableRow){
        
        //open deepLink
        
        if let dic = item.action!.data as? NSDictionary{
            
            let dlink  = NSURL(string:dic.objectForKey("dlink") as! String)
            
            var link : NSURL?
            if let lStr = dic.objectForKey("link") as? String {
                link  = NSURL(string:lStr)
            }
            
            if UIApplication.sharedApplication().canOpenURL(dlink!) {
                UIApplication.sharedApplication().openURL(dlink!)
            }else{
                if link != nil {
                    UIApplication.sharedApplication().openURL(link!)
                }
            }
        }
    }
    
    
    func openLinkAction(item: TableRow){
        
        if let link = item.action!.data as? String {
            
            if link.hasPrefix("http") {
                //open normal link
                let nav = self.storyboard?.instantiateViewControllerWithIdentifier("NavWebController") as! UINavigationController
                let wc = nav.topViewController as! WebController
                
                wc.link = NSURL(string: link)
                wc.title = item.title
                
                self.presentViewController(nav, animated: true, completion: nil)
                
            }
        }
    }

    
}

