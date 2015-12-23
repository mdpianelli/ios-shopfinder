//
//  LeftMenuController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 08/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import RESideMenu


class MenuController: UIViewController, RESideMenuDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    
    let titles = ["Home", "Nearby", "Settings"]
    let images = ["IconHome","IconProfile", "IconSettings"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(100, 0,0, 0)
    }
    

    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(atableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        cell.textLabel!.textColor = UIColor.whiteColor()
		    cell.textLabel!.font = UIFont.systemFontOfSize(20)
        cell.textLabel!.text = titles[indexPath.row];
        cell.imageView!.image = UIImage(named:images[indexPath.row])

        return cell
    }
    
    
    //MARK : - UITableViewDelegate
    
    func tableView(atableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch(indexPath.row)
        {
            case 0 :
                self.sideMenuViewController.setContentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("NavShopListController") , animated: true)
                
            case 2:
                self.sideMenuViewController.setContentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("NavSettingsController") , animated: true)
                
            default:break;
        }
    
        self.sideMenuViewController.hideMenuViewController()

    }
    
    
    
}