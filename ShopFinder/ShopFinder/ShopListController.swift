//
//  ShopListController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 15/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import SVProgressHUD
import FontAwesomeKit
import SDWebImage
import Spring
import GoogleMobileAds
import CoreLocation




class ShopListController: UIViewController, GADInterstitialDelegate, UIScrollViewDelegate,CLLocationManagerDelegate {

    enum SortType {
        case Distance
        case Rating
        case ReviewCount
    }

    
    @IBOutlet weak var table: UITableView!
    
    var adBannerFull : GADInterstitial?
    var shops : NSArray = []
    var selectedShop : NSDictionary?
    var refreshControl : YALSunnyRefreshControl?  //UIRefreshControl()
    var locManager : CLLocationManager?
    var currentLocation : CLLocation?
    var sortType : SortType = .Distance
    
    //Segues Identifiers
    let  segueShowFilter  = "showFilter"
    let  segueShowShopDetail  = "showShopDetail"

    
    //Transition  manager
    let transitionManager = ZoomAnimator()



    
    //MARK: UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
        if locManager == nil {
            locManager =  CLLocationManager()
            locManager?.delegate = self
            
            if( locManager!.respondsToSelector(Selector("requestWhenInUseAuthorization")) ){
                locManager!.requestWhenInUseAuthorization()
            }
            
            locManager!.desiredAccuracy = kCLLocationAccuracyBest
            locManager!.startUpdatingLocation()
        }
        
       //fetchShops()
    }
    
 
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if(adBannerFull?.hasBeenUsed != true){
         //   adBannerSetup()
        }
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // self.transitionManagerManageringDelegate = transitionManagerManagerZoom()
        if segue.identifier == segueShowFilter {
            if let options = segue.destinationViewController as? ShopFilterOptionsController {
                options.delegate = self
            }
        }
        
        
        if segue.identifier == segueShowShopDetail {
            if let vc = segue.destinationViewController as? ShopDetailController {
                vc.shop = selectedShop
                vc.transitioningDelegate =  transitionManager
            }
        }
        
        
    }
    
    
    //MARK: Setup Methods
    
    func initialSetup()
    {
    
        setupNavMenu()
      // adBannerSetup()
        
        table.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        table.scrollIndicatorInsets = table.contentInset
        
        refreshControl = YALSunnyRefreshControl.attachToScrollView(self.table, target: self, refreshAction: Selector("fetchShops"))
    }
    
    
    
    func setupNavMenu(){
        
    
        self.view.showLoading()
        
        // set left navBarIcon to open left menu
        self.navigationItem.leftBarButtonItem = self.menuBtn()
        
        // set right navBarIcon to show Sorting Menu
        let cogIcon  = FAKFontAwesome.sortIconWithSize(20)
        
        let  image = self.imageFromAFont(cogIcon)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style:.Plain, target:self, action:"showFilterOptions")
        
        }
    
    
    func showFilterOptions()
    {
        self.performSegueWithIdentifier(segueShowFilter, sender: self)
    }
    
    
    func adBannerSetup(){

        adBannerFull = GADInterstitial(adUnitID: Ads.fullscreenId)
        adBannerFull?.delegate = self
        adBannerFull?.loadRequest(GADRequest())

    }
    
    
    
    
    //MARK: Receiver Methods
    
    
    func minimizeView(sender: AnyObject) {
      
        let view  = self.navigationController?.view!
        
        SpringAnimation.springEaseOut(0.4, animations:{
   
            view?.transform = CGAffineTransformMakeScale(0.875, 0.875)
            //view?.alpha = 0.85

        })
        

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    func maximizeView(sender: AnyObject) {
        //SpringButton

        let view = self.navigationController?.view!

        SpringAnimation.springEaseIn(0.4, animations:{
            
             view?.transform = CGAffineTransformMakeScale(1, 1)
             view?.alpha = 1
        })
        
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
    }
    
    func sortTable(sender: AnyObject?){
        
        switch sortType {
            
            case .Distance :
                    sortByDistance()

            case .Rating :
                    sortByRating()

            case .ReviewCount :
                    sortByReviewCount()

        }
     
        table.reloadSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Fade )
        

       // table.reloadData()
    }
    
    

    
    //MARK:-  GADInterstitialDelegate
    
    
    func interstitialDidReceiveAd(ad: GADInterstitial!)
    {
        adBannerFull?.presentFromRootViewController(self)
    }
    
    
    //MARK:- Methods

    func fetchShops(){

       // SVProgressHUD.show()
       
        if CLLocationManager.locationServicesEnabled() &&
                currentLocation == nil {
            return
        }
        
        //retrieve shops and reload table
        ServerManager.retrieveShops(){  result in
            
            var data: AnyObject?
            
            if result.isFailure {
                
                print(result.error)
                data = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.ShopsJSON)
           
            }else{
                data = result.value
            }
            
            self.shops = data as! NSArray
            
            var aux : [NSDictionary] = []
            
            for eachShop in self.shops {
                if let loc: AnyObject = eachShop.objectForKey("geolocation"){
                    if let geoloc : AnyObject = loc.objectForKey("location"){
                        
                        let lat = geoloc.objectForKey("lat") as! Double
                        let long = geoloc.objectForKey("lng") as! Double

                        //calculate shop distance
                        let shopLocation = CLLocation(latitude: lat, longitude: long)
                        var distanceType = "m"
                        var distance = self.currentLocation?.distanceFromLocation(shopLocation)
        
                        
                        let shopDic = eachShop.mutableCopy() as! NSMutableDictionary
                       
                        if distance == nil {
                            distance = 0
                        }
                       
                        shopDic.setObject(distance!, forKey: "distanceValue")
                        
                        
                        if distance > 1000 {
                            distanceType = "km"
                            distance = distance!/1000
                        }
                        
                        var format = "%.0f%@"
                        
                        if distanceType == "Km" {
                            format = "%.1f%@"
                        }
                        
                        let distanceStr = String(format: format ,distance!,distanceType)
                        
                        shopDic.setObject(distanceStr, forKey: "distance")
                        aux.append(shopDic)
                    }
                }
            }
            
            self.shops = aux
            self.sortTable(nil)
            self.refreshControl?.endRefreshing()

        }
        
    
    }
    
    //MARK: Sort Methods
    
    func sortByDistance() {
        
        var aux = self.shops as! [NSDictionary]
        
        aux.sortInPlace({ $1.objectForKey("distanceValue") as! Double > $0.objectForKey("distanceValue") as! Double })

       self.shops = aux
    }
    
    func sortByRating() {
        
        var aux = self.shops as! [NSDictionary]
        
        aux.sortInPlace({
            
            return $0.objectForKey("rating") as! Double > $1.objectForKey("rating") as! Double
        })
        
        self.shops = aux
    }
    
    func sortByReviewCount() {
        
        var aux = self.shops as! [NSDictionary]
        
        aux.sortInPlace({ $0.objectForKey("reviews_count") as! Double > $1.objectForKey("reviews_count") as! Double })
        
        self.shops = aux
    }
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shops.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: ShopCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ShopCell
        
        let shop = shops[indexPath.row] as! NSDictionary
        
        //cell.textLabel!.textColor = UIColor.whiteColor()
        cell.titleLabel!.text =  shop.objectForKey("name") as? String
        let rating = shop.objectForKey("rating") as? NSNumber
        
        if rating != nil {
            cell.ratingLabel!.text = "\(rating!.stringValue)/5"
        }
        
        cell.distanceLabel!.text = shop.objectForKey("distance") as? String
        
        let reviewCount = shop.objectForKey("reviews_count") as? NSNumber
        
        if reviewCount != nil {
          //  cell.reviewCountLabel!.text = reviewCount!.stringValue
        }
        
        if let photos = shop.objectForKey("photos") as? [AnyObject]
        {
            let imageURL = photos[0] as! String
            
            cell.shopImageView!.sd_setImageWithURL(NSURL(string: imageURL), completed:{
                (image, error, _, _) -> Void in
                
                cell.imageView?.alpha = 0
                SpringAnimation.spring(0.4, animations:{
                   // cell.imageView?.image = image
                    cell.imageView?.alpha = 1
                })
               // self.table.reloadData()
            })
            
        }
        
        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
     
        // Get visible cells on table view.
        let visibleCells = self.table.visibleCells as! [JBParallaxCell]
        
        for cell : JBParallaxCell in visibleCells {
            cell.cellOnTableView(self.table, didScrollOnView: self.view)
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // set selected shop
        selectedShop = shops[indexPath.row] as? NSDictionary
        
        self.performSegueWithIdentifier(segueShowShopDetail, sender: self)

    }


    
    //MARK: - CoreLocation Stuff
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        manager.stopUpdatingLocation()
        currentLocation = locations[0] 
        fetchShops()
    }
    
    
    //    func saveImageWithView(view : UIView)
    //    {
    //        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    //        view.layer.renderInContext(UIGraphicsGetCurrentContext())
    //
    //        let img = UIGraphicsGetImageFromCurrentImageContext();
    //
    //        UIGraphicsEndImageContext();
    //        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    //
    //    }
    
    //    func listAllFontsIntoImage(){
    //
    //
    //        let scroll = UIScrollView(frame: CGRectMake(0, 0,810,1500))
    //        scroll.minimumZoomScale = 0.1
    //
    //
    //        scroll.contentSize = CGSizeMake(810, 1500)
    //        scroll.backgroundColor = UIColor.whiteColor()
    //
    //        for index in 0...3{
    //
    //            var inc = -1
    //
    //            let b =  FADesignableIconLabel()
    //            b.imageFontClass = index
    //            var dic : [NSObject : AnyObject] = b.fontAllIcons()
    //
    //
    //            for jindex in 0 ... dic.count{
    //
    //                let a = FADesignableIconLabel()
    //
    //                if jindex%40 == 0{
    //                   inc++
    //                }
    //
    //
    //
    //                a.imageFontClass = index
    //                a.imageType = jindex
    //                a.imageFontSize = 15
    //                let x  = CGFloat((jindex%40)*20+5)
    //                let y  = CGFloat((20+9)*inc + index*470)
    //                a.frame = CGRectMake(0,0,20,20)
    //                a.frame.origin = CGPointMake(x, y)
    //                a.textColor = UIColor.blackColor()
    //                scroll.addSubview(a)
    //
    //                let l = UILabel(frame: CGRectMake(0,0,20,20))
    //                l.center = a.center
    //                l.center.y += 15
    //                l.font = UIFont.systemFontOfSize(10)
    //                l.textColor = UIColor.redColor()
    //                l.text = "\(jindex)"
    //                l.textAlignment = .Center
    //                scroll.addSubview(l)
    //                
    //
    //            }
    //
    //            
    //        }
    //        
    //        
    //        self.view = scroll
    //        
    //        self.saveImageWithView(scroll)
    //    }


}




