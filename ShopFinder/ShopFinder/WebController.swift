//
//  WebController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 28/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit

class WebController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var link : NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: link!))
    }

    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
