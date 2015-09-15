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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var header: ParallaxHeaderView!
    
    var descriptionExpanded = false
    
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
            
            shopInfo![0].rows?.append(TableRow(title:description,icon:nil,action:Action(type:.Expand,data:description),height:90,type:.Text))
            
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
        
        if let photos: AnyObject = shop!.objectForKey("photos")
        {
            let imageURL = photos[0] as! String
            
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
        
        spring(1,{
            adBanner?.alpha = 1
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
        
        var data = shopInfo![indexPath.section].rows![indexPath.row] as TableRow
        
        
        switch(data.type){
            
            case .Standard :
            
                let cell  = tableView.dequeueReusableCellWithIdentifier("Standard") as! ShopDetailCell
                
                cell.infoLabel!.text = data.title
                
              //  if !descriptionExpanded {
                    cell.iconButton!.icon = data.icon
              //  }
                
                println("\(data.icon?.type) + \(data.icon?.index) + \(data.icon?.color)")
                
                if data.action == nil {
                    cell.selectionStyle = .None
                }else{
                    cell.selectionStyle = .Default
                }
            
                return cell
            
            case .Text :
            
                let cell  = tableView.dequeueReusableCellWithIdentifier("Text") as! ShopDetailDescriptionCell
                
                cell.descriptionLabel!.text = data.title
                cell.selectionStyle = .None
                
                return cell
            
            default : break
        }
  
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var row = shopInfo![indexPath.section].rows![indexPath.row] as TableRow
        
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
            height = 90
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
        var messageString = inString
        var attributes = [UIFont(): UIFont.systemFontOfSize(17.0)]
        var attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        var rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(170,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        var requredSize:CGRect = rect
        
        println( "\(requredSize.height)")
        
        return Int(requredSize.height)  //to include button's in your tableview
        
    }
    
   
    
    
    
    //MARK: Map View Delegate
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!)
    {
        view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        //TODO: Somethings
    }
    
    
    func locationAction(row : TableRow){
    

 //       let indexPath = NSIndexPath(forRow:table.numberOfRowsInSection(table.numberOfSections()-1)-1 , inSection:table.numberOfSections()-1)
        
        //table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Bottom)
        
        table.setContentOffset(CGPointMake(0,table.contentSize.height-table.frame.height+40), animated: true)
        mapView.selectAnnotation(shopAnnotation , animated: true)

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
