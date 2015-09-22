//
//  WebController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 28/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import UIActionSheet_Blocks

class WebController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var link : NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: link!))
    }

    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Share Action
    
     @IBAction func shareSheet(sender: AnyObject){
        
        let firstActivityItem = "Hey, check out this mediocre site that sometimes posts about Swift!"
        
        
        let activityViewController = UIActivityViewController(activityItems: [firstActivityItem,link!], applicationActivities: nil)
        
//        activityViewController.excludedActivityTypes = [
//            UIActivityTypePostToWeibo,
//            UIActivityTypePrint,
//            UIActivityTypeAssignToContact,
//            UIActivityTypeSaveToCameraRoll,
//            UIActivityTypeAddToReadingList,
//            UIActivityTypePostToFlickr,
//            UIActivityTypePostToVimeo,
//            UIActivityTypePostToTencentWeibo
//        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func actionSheet(sender: AnyObject){
          
        
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        let openAction = UIAlertAction(title: NSLocalizedString("Open in Safari", comment: ""), style: .Default) { (action) -> Void in
            
            if UIApplication.sharedApplication().canOpenURL(self.link!) {
                UIApplication.sharedApplication().openURL(self.link!)
            }
        }
        
        
        let copyLink = UIAlertAction(title: NSLocalizedString("Copy Link", comment: ""), style: .Default) { (action) -> Void in
            
            let pasteBoard = UIPasteboard.generalPasteboard()
            pasteBoard.string = self.link!.absoluteString
            pasteBoard.URL = self.link!
        }
        
        
        actionController.addAction(openAction)
        actionController.addAction(copyLink)
        actionController.addAction(cancelAction)

        //We need to provide a popover sourceView when using it on iPad
        actionController.popoverPresentationController?.sourceView = sender as? UIView
        


        self.presentViewController(actionController, animated: true, completion: nil)
    }

    
}
