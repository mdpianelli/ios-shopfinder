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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuTableViewCell.idenfitier()) as! MenuTableViewCell
			
				cell.titleLabel.text = titles[indexPath.row]
				cell.iconView.imageType = 106
			
        return cell
    }
    
    
    //MARK : - UITableViewDelegate
    
    func tableView(atableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
			
			
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
			
				let nav = self.sideMenuViewController.contentViewController as? UINavigationController
				var vc : UIViewController?
			
			
        switch(indexPath.row)
        {
            case 0 :
										vc = self.storyboard!.instantiateViewControllerWithIdentifier("ShopListController")
					
            case 2:
										vc = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsController")
                
            default:break;
        }
			
				if vc != nil {
					nav?.setViewControllers([vc!], animated: true)
				}
			
        self.sideMenuViewController.hideMenuViewController()

    }
    
    
    
}


class MenuTableViewCell : UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var iconView: FADesignableIconButton!
	
	class func idenfitier()-> String {
		return "MenuTableViewCell"
	}

	required init?(coder aDecoder: NSCoder) {
	    super.init(coder: aDecoder)
		let bgView = UIView(frame: self.contentView.frame)
		bgView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
		self.selectedBackgroundView = bgView

	}
	
	
	
}