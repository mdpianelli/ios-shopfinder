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

    
    let titles = ["Home", "Calendar", "Profile", "Settings"]
    let images = ["IconHome", "IconCalendar", "IconProfile", "IconSettings"]

    
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
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        cell.textLabel!.textColor = UIColor.whiteColor()
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
                self.sideMenuViewController.setContentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("NavShopListController") as! UIViewController, animated: true)
                
            case 1:
                self.sideMenuViewController.setContentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("secondViewController") as! UIViewController, animated: true)
                
            default:break;
        }
    
        self.sideMenuViewController.hideMenuViewController()

    }
    
    
    
}