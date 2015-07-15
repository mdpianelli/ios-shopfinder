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

class ShopListController: UIViewController {

    
    @IBOutlet weak var table: UITableView!
    var shops : NSArray = []
    
    
    //MARK: UIViewController Methods

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       initialSetup()
       fetchShops()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

      
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
      //  self.navigationController?.navigationBarHidden = false

    }
    
    //MARK: Methods
    
    func initialSetup(){
        
        //        self.navigationController?.navigationBar.hidden = true
        // self.navigationController?.hidesBarsOnSwipe = true
        
        let cogIcon : FAKFontAwesome = FAKFontAwesome.naviconIconWithSize(20)
        
        cogIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
        
        cogIcon.iconFontSize = 20
        //cogIcon.drawingBackgroundColor = UIColor.whiteColor()
        
        let image : UIImage = cogIcon.imageWithSize(CGSizeMake(30, 30))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: nil, style:.Plain, target:self, action:"presentLeftMenuViewController:")
        
    }
    
    func fetchShops(){
        
        SVProgressHUD.show()
        
        //retrieve shops and reload table
        ServerManager.retrieveShops(){
            obj, error in
            
            self.shops = obj as! NSArray
            self.table.reloadData()
            
            SVProgressHUD.dismiss()
            
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

