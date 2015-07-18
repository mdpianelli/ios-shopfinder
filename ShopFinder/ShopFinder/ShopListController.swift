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


class ShopListController: UIViewController, GADInterstitialDelegate, ShopFilterOptionsControllerDelegate {

    
    @IBOutlet weak var table: UITableView!
    
    var adBannerFull : GADInterstitial?
    var shops : NSArray = []
    
    //MARK: UIViewController Methods

    override func viewDidLoad() {
        
       super.viewDidLoad()
        
       initialSetup()
       fetchShops()
 
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
      //  self.navigationController?.navigationBarHidden = false

    }
    
    //MARK: Setup Methods
    
    func initialSetup(){
    
        setupNavMenu()
      //  adBannerSetup()
    }
    
    
    func setupNavMenu(){
        
       // self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 1, alpha: 0.3)
        
        var cogIcon : FAKFontAwesome = FAKFontAwesome.naviconIconWithSize(20)
        
        cogIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
        
        cogIcon.iconFontSize = 20
        //cogIcon.drawingBackgroundColor = UIColor.whiteColor()
        
        var image : UIImage = cogIcon.imageWithSize(CGSizeMake(30, 30))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style:.Plain, target:self, action:"presentLeftMenuViewController:")
        
        
        
        cogIcon  = FAKFontAwesome.sortIconWithSize(20)
        
        cogIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
        
        cogIcon.iconFontSize = 20
        //cogIcon.drawingBackgroundColor = UIColor.whiteColor()
        
         image = cogIcon.imageWithSize(CGSizeMake(30, 30))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style:.Plain, target:self, action:"showFilterOptions")
        
    }
    
    func showFilterOptions()
    {
        self.performSegueWithIdentifier("showFilterSegue", sender: self)
    }
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        if let options = segue.destinationViewController as? ShopFilterOptionsController {
            options.delegate = self
        }
    }
    
    func adBannerSetup(){

        adBannerFull = GADInterstitial(adUnitID: Ads.fullscreenId)
        adBannerFull?.delegate = self
        adBannerFull?.loadRequest(GADRequest())

    }
    
    //MARK: Receiver Methods
    
    
    func minimizeView(sender: AnyObject) {
      
        
        var view  = self.navigationController?.view!
        
        spring(0.7, {
   
            view?.transform = CGAffineTransformMakeScale(0.935, 0.935)
            view?.alpha = 0.75

        })
        

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    func maximizeView(sender: AnyObject) {
        

        var view = self.navigationController?.view!

        spring(0.7, {
            
             view?.transform = CGAffineTransformMakeScale(1, 1)
             view?.alpha = 1
        })
        
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
    }
    

    
    //MARK:-  GADInterstitialDelegate
    
    
    func interstitialDidReceiveAd(ad: GADInterstitial!)
    {
        adBannerFull?.presentFromRootViewController(self)
    }
    
    
    //MARK:- Methods

    func fetchShops(){
        
        self.view.showLoading()
        
        //retrieve shops and reload table
        ServerManager.retrieveShops(){
            obj, error in
            
            if obj != nil {
                self.shops = obj as! NSArray
            }
            self.table.reloadData()
            
            self.view.hideLoading()
            
        }
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
        
        if let photos: AnyObject = shop.objectForKey("photos")
        {
            let imageURL = photos[0] as! String
            
            cell.shopImageView!.sd_setImageWithURL(NSURL(string: imageURL), completed:{
                (image, error, _, _) -> Void in
                
               // self.table.reloadData()
            })
            
        }
        
        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let shop = shops[indexPath.row] as! NSDictionary

        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ShopDetailController") as! ShopDetailController
        
        vc.shop = shop
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

   

}

