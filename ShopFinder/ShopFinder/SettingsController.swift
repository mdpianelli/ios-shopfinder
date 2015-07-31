//
//  SettingsController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 22/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import SVProgressHUD
import Spring

struct Icon {
    let type : Int
    let index : Int
    let color : UIColor
    
}

struct Action {
    let type : String
    let data : AnyObject?
}

struct TableRow {
    
    let title : String
    let icon : Icon
    let action : Action
}

struct TableSection {
    
    let sectionName : String
    let rows : [TableRow]
    
}

class SettingsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var versionBuildLabel: UILabel!
    
    //table view sections
    
//    let sections = [
//        TableSection(sectionName: "SUPPORT", rows:[
//            TableRow(title: NSLocalizedString("Help and Feedback",comment:""),icon:(1,1,UIColor.cyanColor()),action:("mail","something")),
//            
//            TableRow(title: NSLocalizedString("Email Us",comment:""), icon:(1,2,UIColor.orangeColor()),action:("mail","something"))]),
//        
//
//        TableSection(sectionName: "", rows:[
//            TableRow(title: NSLocalizedString("Rate this App",comment:""), icon:(1,3,UIColor(hex: "2CA390")),action:("mail","something")),
//            TableRow(title: NSLocalizedString("Follow Us on Twitter",comment:""), icon:(1,4,UIColor.redColor()),action:("mail","something")),
//            TableRow(title: NSLocalizedString("Like Us on Facebook",comment:""), icon:(1,5,UIColor.greenColor()),action:("mail","something")),
//            TableRow(title: NSLocalizedString("Terms of Service",comment:""), icon:(1,6,UIColor.grayColor()),action:("mail","something")),
//            TableRow(title: NSLocalizedString("Privacy Policy",comment:""), icon:(1,7,UIColor.blackColor()),action:("mail","something"))])
//        ]
//
//    
    
    var sections : [TableSection] = []
    
    // Background task to fetch settings

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
        
        
        
        ServerManager.fetchSettings { (data, error) -> Void in
            
            
            if let info = data as? NSDictionary {
                if let table = info["table"] as? NSDictionary {
                    if let sections = table["sections"] as? NSArray {
                        for section in sections{
                            
                            var rows : [TableRow] = []
                            
                            if let tableRows = section["data"] as? NSArray {
                                for row in tableRows{
                                    
                                    let title = row["title"] as! String
                                    
                                    let icon = row["icon"] as! NSDictionary
                                    
                                    let action = row["action"] as!  NSDictionary
                            
                                    
                                    rows.append(TableRow(title: title,
                                        
                                        icon: Icon(type: icon["class"] as! NSInteger, index: icon["class"] as! NSInteger, color: UIColor(hex: icon["color"] as! String)),
                                        
                                        action: Action(type: action["type"] as! String, data: action["data"] )
                                    ))
                                    
                                }
                                
                            }
                            self.sections.append(TableSection(sectionName:section["name"] as! String, rows:rows))
                        }
                    }
                }
            }
            
        }
        
    
    }

    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].rows.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : SettingsCell  = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as!
        SettingsCell
        
        let itemData = sections[indexPath.section].rows[indexPath.row] as TableRow
        
        cell.titleLabel.text = itemData.title
        cell.iconBtn.icon = itemData.icon
        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let rowItem = sections[indexPath.section].rows[indexPath.row] as TableRow
        
        switch(rowItem.action.type){
            
            case "mail":
                        mailAction(rowItem)
            
            case "link":
                        openLinkAction(rowItem)
            
            
            default : break;
            
        }
        
//        // set selected shop
//        selectedShop = shops[indexPath.row] as? NSDictionary
//        
//        self.performSegueWithIdentifier(segueShowShopDetail, sender: self)
        
    }
    
    
    func mailAction(item : TableRow){
        
        
    }
    
    func openLinkAction(item: TableRow){
  
        let link = item.action.data as! String
        
        
        if link.hasPrefix("http") {
            //open normal link
            let wc = self.storyboard?.instantiateViewControllerWithIdentifier("NavWebController") as! WebController
            
            wc.link = NSURL(string: link)
            wc.title = item.title
            
            self.presentViewController(wc, animated: true, completion: nil)
            
        }else{
            //open deepLink
            
            var fileURL  = NSURL(fileURLWithPath: link)
            
            
            if UIApplication.sharedApplication().canOpenURL(fileURL!) {
                UIApplication.sharedApplication().openURL(fileURL!)
            }else{
                //Notify deepLink App not installed
                SVProgressHUD.showErrorWithStatus(NSLocalizedString("This App is not installed on your phone. Install it and try again later",comment:""))
                
            }
        }
        
    }

    
  
    
}



class SettingsCell : UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconBtn: FADesignableIconButton!
    
    
}
