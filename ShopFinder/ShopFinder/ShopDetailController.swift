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
import Spring
import GoogleMobileAds


class ShopDetailController: UIViewController, MKMapViewDelegate, GADBannerViewDelegate {

    
    var shop : NSDictionary?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var adBanner: GADBannerView?

    
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
        
        
        //setup adBanner
        adBannerSetup()
        
        
        titleLabel.text = shop!.objectForKey("name") as? String
        let address = shop!.objectForKey("address") as? String
        addressLabel.text = address
        
        if let photos: AnyObject = shop!.objectForKey("photos")
        {
            let imageURL = photos[0] as! String
            imageView!.sd_setImageWithURL(NSURL(string: imageURL))
        }
        
        if let geoloc: AnyObject = shop!.objectForKey("geolocation"){
            
            let lat = geoloc.objectForKey("lat") as! Double
            let long = geoloc.objectForKey("lng") as! Double

            let annotation = ShopAnnotation(title: titleLabel.text, subtitle: address, lat: lat, lon: long, row: 0)
            
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            mapView.selectAnnotation(annotation , animated: true)
        }
        
       
        //mapView.anima
        //mapView.showLoading()
    
//        var zoomRect : MKMapRect = MKMapRectNull;
//        
//        for ( annotation : MKAnnotation in mapView.annotations)
//        {
//            
//            
//            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//            zoomRect = MKMapRectUnion(zoomRect, pointRect);
//        }
//        [mapView setVisibleMapRect:zoomRect animated:YES];
        
        
    }
    

    func adBannerSetup(){
        
        adBanner = GADBannerView(adSize: kGADAdSizeBanner)
        adBanner?.adSize = kGADAdSizeBanner
        adBanner?.adUnitID = Ads.bannerId
        adBanner?.rootViewController = self
        adBanner?.autoloadEnabled = true;
        adBanner?.delegate = self
        adBanner?.loadRequest(GADRequest())
    }
    
    
    
    
    //MARK: - GADBannerViewDelegate
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        
        var frame  = adBanner!.frame
        frame.origin.y = self.view.frame.size.height - frame.size.height
        adBanner?.frame = frame
        self.view.addSubview(adBanner!)

        
     //   adBanner?.layer.animation =  "squeezeDown"
//        adBanner?.alpha = 0
//
//        
//        UIView.animateWithDuration(1, delay: 0, options: nil , animations: { () -> Void in
//            
//            adBanner?.alpha = 1
//            
//        }, completion: nil)
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!){
        
        println(error)
    }

    

}








class ShopAnnotation : NSObject, MKAnnotation {
    
    // Center latitude and longitude of the annotation view.
    // The implementation of this property must be KVO compliant.
    var coordinate : CLLocationCoordinate2D;
    
    // Title and subtitle for use by selection UI.
    var title: String!
    var subtitle: String!
    var row: Int!
    
    
    init(title:String!,subtitle:String!,lat:CLLocationDegrees!,lon:CLLocationDegrees!,row:Int!){
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2DMake(lat, lon)
        self.row = row
        
        super.init()
        
    }
    
}
