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

class ShopDetailController: BaseController, MKMapViewDelegate, GADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    var shop : NSDictionary?
    var shopInfo : [TableSection]?
    var shopAnnotation : ShopAnnotation?
    
    @IBOutlet weak var imageView: SpringImageView!
    @IBOutlet weak var titleLabel: UILabel!
		@IBOutlet weak var ratingLabel: UILabel!
	
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var header: ParallaxHeaderView!
    
    var descriptionExpanded = false
    
    var adBanner: GADBannerView?

    let descriptionFieldHeight = 120
    
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
        
        scrollViewDidScroll(table)
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        adBanner?.delegate = nil

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.refreshBlurViewForNewImage()

    }
    
    
    
    //MARK: Initial Setup Methods
    
    func initialSetup(){
        
        adBannerSetup()
        
        shopInfoSetup()
        
    }
    
    func shopInfoSetup(){
        
        //set title
        titleLabel.text = shop!.objectForKey("name") as? String
				ratingLabel.text = shop!.objectForKey("rating") as? String
			
			
        //initialize table sections and rows
        shopInfo = [TableSection(sectionName:"",rows:[])]
        
        if let address = shop!.objectForKey("address") as? String {
            
            shopInfo![0].rows?.append(TableRow(title:address ,icon:Icon(type:0,index:215,color:UIColor(hex: "#0091FF")),action:Action(type:.Location,data:nil),height:60,type:.Standard))
        }
        
        
        if let phoneNumber = shop!.objectForKey("phone_number") as? String {
            
            shopInfo![0].rows?.append(TableRow(title:phoneNumber ,icon:Icon(type:0,index:372,color:UIColor(hex: "#0091FF")),action:Action(type:.Call,data:phoneNumber),height:60,type:.Standard))
        }
        
        
        if let website = shop!.objectForKey("website") as? String {
            
            shopInfo![0].rows?.append(TableRow(title:website,icon:Icon(type:2,index:221,color:UIColor(hex: "#0091FF")),action:Action(type:.Link,data:website),height:60,type:.Standard))
            
        }
        
        if let description = shop!.objectForKey("description") as? String {
            
            shopInfo![0].rows?.append(TableRow(title:description,icon:nil,action:Action(type:.Expand,data:description),height:descriptionFieldHeight,type:.Text))
            
        }
        
        
        if let openingHours = shop!.objectForKey("opening_hours") as? NSDictionary {
            
            let weekdayArray = openingHours.objectForKey("weekday_text") as! NSArray
            
            shopInfo?.append(
                TableSection(sectionName:"Opening Hours",rows:[
                    TableRow(title:weekdayArray[0] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[1] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[2] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[3] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[4] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[5] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    TableRow(title:weekdayArray[6] as! String,icon:nil,action:nil,height:40,type:.Standard),
                    ])
            )
            
        }
        
        
        header.frame.size.height = 170
        
        if let photos = shop!.objectForKey("photos") as? [String]
        {
            let imageURL = photos[0]
            
            let key = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL(string: imageURL))
            let img = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(key)
            header.headerImage = img
        }
        
        table.tableHeaderView = header
        
        
        
        if let loc: AnyObject = shop!.objectForKey("geolocation"){
            if let geoloc : AnyObject = loc.objectForKey("location"){
                let lat = geoloc.objectForKey("lat") as! Double
                let long = geoloc.objectForKey("lng") as! Double
                
                let annotation = ShopAnnotation(title: titleLabel.text, subtitle:shop!.objectForKey("address") as! String, lat: lat, lon: long, row: 0)
                
                mapView.addAnnotation(annotation)
                mapView.showAnnotations(mapView.annotations, animated: true)
                shopAnnotation = annotation
            }
        }
        
        table.reloadData()

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
        
        SpringAnimation.spring(1,animations: {
            self.adBanner?.alpha = 1
        })
        
        table.contentInset = UIEdgeInsetsMake(0,0,50,0)

       
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!){
        
        //println(error)
    }
    
    
    //MARK: UITableView Methods

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let row = shopInfo![indexPath.section].rows![indexPath.row] as TableRow
        return CGFloat(row.height)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shopInfo![section].sectionName
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return shopInfo!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopInfo![section].rows!.count
    }
    
    // for table parallax effect
    func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = table.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
       // table.tableHeaderView = header
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let data = shopInfo![indexPath.section].rows![indexPath.row] as TableRow
        
        
        switch(data.type){
            
            case .Standard :
            
                let cell  = tableView.dequeueReusableCellWithIdentifier("Standard") as! ShopDetailCell
                
                cell.infoLabel!.text = data.title
                
               
               // if data.icon != nil {
                    cell.iconButton!.icon = data.icon
              //  }
                
                //print("\(cell.iconButton!.frame)")
                
               // cell.contentView.addSubview(cell.iconButton!)
                
              //  print("\(data.icon?.type) + \(data.icon?.index) + \(data.icon?.color)", terminator: "")
                
                if data.action == nil {
                    cell.selectionStyle = .None
                    cell.separatorInset = UIEdgeInsetsMake(0,table.frame.size.width,0,0);


                }else{
                    cell.selectionStyle = .Default
                    cell.separatorInset = UIEdgeInsetsMake(0,0, 0, 0)

                }
            
                return cell
            
            case .Text :
            
                let cell  = tableView.dequeueReusableCellWithIdentifier("Text") as! ShopDetailDescriptionCell
                
                cell.descriptionLabel!.text = data.title
                cell.selectionStyle = .None
                
                return cell
            
        }
  
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = shopInfo![indexPath.section].rows![indexPath.row] as TableRow
        
        if row.action == nil {
            return
        }
        
        
        switch(row.action!.type){

            case .Expand :
                expandAction(row.title,indexPath: indexPath)
            case .Location:
                locationAction(row)
            case .Call:
                callAction(row)
            case .Link:
                openLinkAction(row)
            case .DLink:
                openDlinkAction(row)
                
            default : break;
        }
        
    }

    //MARK: Actions
    
    func expandAction( text: String, indexPath : NSIndexPath){

        //mofidy row height
        var height = 0
        
        if descriptionExpanded {
            height = descriptionFieldHeight
        }else{
            height = calculateHeightForString(text)
        }
        
        table.beginUpdates()
        shopInfo![indexPath.section].rows![indexPath.row].height = height
        table.endUpdates()
        
        
        descriptionExpanded = !descriptionExpanded
    }
    
    func calculateHeightForString(inString:String) -> Int
    {
        let messageString = inString
        let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(17.0)]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        let rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(table.frame.width,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        
        
        return Int(requredSize.height+80)  //to include button's in your tableview
        
    }
    
    
    func locationAction(row : TableRow?){
			
        let address = "\(shopAnnotation!.coordinate.latitude),\(shopAnnotation!.coordinate.longitude)"
        
        let actionController = UIAlertController(title:NSLocalizedString("Show Directions:", comment: ""), message: nil, preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
          //  self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
       // if UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!){
                
            let googleAction = UIAlertAction(title: NSLocalizedString("Open in Google Maps", comment: ""), style: .Default) { (action) -> Void in
                
                
                    let url = NSURL(string: "comgooglemaps://?daddr=\(address)&directionsmode=transit")
                
                    UIApplication.sharedApplication().openURL(url!)
                
            }
            
            actionController.addAction(googleAction)

       // }
        
        let mapsAction = UIAlertAction(title: NSLocalizedString("Open in Maps", comment: ""), style: .Default) { (action) -> Void in
            
            let url = NSURL(string: "http://maps.apple.com/?daddr=\(address)&dirflg=r")
            
            UIApplication.sharedApplication().openURL(url!)
            
            
        }
        
        
        actionController.addAction(mapsAction)
        actionController.addAction(cancelAction)
        
        
        self.presentViewController(actionController, animated: true, completion: nil)
        
    }

    
    
    //MARK: Map View Delegate
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        locationAction(nil)
    }
    
 

}







class ShopDetailDescriptionCell : UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
}


class ShopDetailCell : UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var iconButton: FADesignableIconButton!
}





class ShopAnnotation : NSObject, MKAnnotation {
    
    // Center latitude and longitude of the annotation view.
    // The implementation of this property must be KVO compliant.
    var coordinate : CLLocationCoordinate2D;
    
    // Title and subtitle for use by selection UI.
    var title: String?
    var subtitle: String?
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
