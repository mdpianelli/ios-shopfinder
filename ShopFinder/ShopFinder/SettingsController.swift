//
//  SettingsController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 22/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit


struct TableData {
    
    let title : String
    let icon : (iconClass: Int,iconType: Int,fontSize: CGFloat)
    
}

struct TableSection {
    
    let sectionName : String
    let data : [TableData]
    
}

class SettingsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var versionBuildLabel: UILabel!
    
    //table view sections
    
    let sections = [
        TableSection(sectionName: "SUPPORT", data:[
            TableData(title: NSLocalizedString("Help and Feedback",comment:""), icon:(1,1,25)),
            TableData(title: NSLocalizedString("Email Us",comment:""), icon:(1,2,20))]),
        
        TableSection(sectionName: "", data:[
            TableData(title: NSLocalizedString("Rate this App",comment:""), icon:(1,3,20)),
            TableData(title: NSLocalizedString("Follow Us on Twitter",comment:""), icon:(1,4,20)),
            TableData(title: NSLocalizedString("Like Us on Facebook",comment:""), icon:(1,5,20)),
            TableData(title: NSLocalizedString("Terms of Service",comment:""), icon:(1,6,20)),
            TableData(title: NSLocalizedString("Privacy Policy",comment:""), icon:(1,7,20))])
        ]


    //MARK: UIViewController Methods

    override func viewDidLoad() {
       
        super.viewDidLoad()
      
        initialSetup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: Internal Methods

    func initialSetup(){
        
        //set version number
        versionBuildLabel.text = AppConfig.appTitleVersionBuild()
        
        self.title = NSLocalizedString("Settings",comment:"")
        
        self.navigationItem.leftBarButtonItem = self.menuBtn()

        self.table.contentInset = UIEdgeInsetsMake(0, 0,20,0)
    }

    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : SettingsCell  = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as!
        SettingsCell
        
        let itemData = sections[indexPath.section].data[indexPath.row] as TableData
        
        cell.titleLabel.text = itemData.title
        //cell.iconBtn.imageFontSize = itemData.icon.fontSize
        cell.iconBtn.imageFontClass = itemData.icon.iconClass
        cell.iconBtn.imageType = itemData.icon.iconType

        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        // set selected shop
//        selectedShop = shops[indexPath.row] as? NSDictionary
//        
//        self.performSegueWithIdentifier(segueShowShopDetail, sender: self)
        
    }

    
    
    
}



class SettingsCell : UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconBtn: FADesignableIconButton!
    
    
}
