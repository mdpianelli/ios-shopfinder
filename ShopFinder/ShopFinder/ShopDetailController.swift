//
//  ShopDetailController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//


import UIKit
import SVProgressHUD
import FontAwesomeKit
import SDWebImage
import MapKit

class ShopDetailController: UIViewController, MKMapViewDelegate {

    
    var shop : NSDictionary?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialSetup()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = NSLocalizedString("Shop", comment: "shop")
        
        let backItem = UIBarButtonItem(title: "hkh", style: .Plain, target: nil, action: nil)
       
      //  self.navigationItem.leftBarButtonItem?.title = "sdasda"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        

        
    }
    
    //MARK: Methods
    
    func initialSetup(){
        
        
        
        titleLabel.text = shop!.objectForKey("name") as? String
        addressLabel.text = shop!.objectForKey("address") as? String
        
        if let photos: AnyObject = shop!.objectForKey("photos")
        {
            let imageURL = photos[0] as! String
            imageView!.sd_setImageWithURL(NSURL(string: imageURL))
        }
        
        
        
    }
    

    
    
    
    

}