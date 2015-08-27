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


class ShopDetailController: UIViewController, MKMapViewDelegate, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var shop : NSDictionary?

    @IBOutlet weak var imageView: SpringImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var header: ParallaxHeaderView!
    
    var adBanner: GADBannerView?

    
    //MARK: UIViewController Methods
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialSetup()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = NSLocalizedString("Shop", comment: "shop")
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        adBanner?.delegate = nil

    }
    
    
    
    //MARK: Methods
    
    func initialSetup(){
        
        
        //setup adBanner
        adBannerSetup()
        
        header.headerImage = UIImage(named: "Stars")
        header.frame.size.height = 150
        table.tableHeaderView = header
        
        titleLabel.text = shop!.objectForKey("name") as? String
        let address = shop!.objectForKey("address") as? String
       // addressLabel.text = address
        
        if let photos: AnyObject = shop!.objectForKey("photos")
        {
            let imageURL = photos[0] as! String
            //imageView!.sd_setImageWithURL(NSURL(string: imageURL))
        }
        
        if let loc: AnyObject = shop!.objectForKey("geolocation"){
                if let geoloc : AnyObject = loc.objectForKey("location"){
                let lat = geoloc.objectForKey("lat") as! Double
                let long = geoloc.objectForKey("lng") as! Double
                
                let annotation = ShopAnnotation(title: titleLabel.text, subtitle: address, lat: lat, lon: long, row: 0)
                
//                mapView.addAnnotation(annotation)
//                mapView.showAnnotations(mapView.annotations, animated: true)
//                mapView.selectAnnotation(annotation , animated: true)
            }
        }
        
       // imageView.animate()
    }
    

    func adBannerSetup(){
        
        adBanner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBanner?.adSize = kGADAdSizeSmartBannerPortrait
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

        
        //FadeIn banner
        adBanner?.alpha = 0
        
        spring(1,{
            adBanner?.alpha = 1
        })
        
       
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!){
        
        //println(error)
    }
    
    
    //MARK: UITableView Methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell  = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        return cell
    }
    
    
    func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = table.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        table.tableHeaderView = header
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
    
    
    init(title:String!,subtitle:String!,lat:CLLocationDegrees!,lon:CLLocationDegrees!,row:Int!)
        {
        
            self.title = title
            self.subtitle = subtitle
            self.coordinate = CLLocationCoordinate2DMake(lat, lon)
            self.row = row
            
            super.init()
        
        }
    
}
