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


//Table Struct

enum ActionType : String {
    case Mail = "mail",
     Link = "link",
     DLink = "dlink",
     Call = "call",
     Location = "location",
     Expand = "expand",
     None = "none"
    
}

struct Icon {
    let type : Int
    let index : Int
    let color : UIColor
}

struct Action {
    let type : ActionType
    let data : AnyObject?
}

enum TableRowType{
    case Standard,Text
}

struct TableRow {
    let title : String
    var icon : Icon?
    var action : Action?
    var height : Int
    let type : TableRowType

}

struct TableSection {
    
    let sectionName : String
    var rows : [TableRow]?
    
}

// Social Network Struct

struct SocialNetworkUrl {
    let scheme: String
    let page: String
}

enum SocialNetwork {
    case Facebook, GooglePlus, Twitter
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook: return SocialNetworkUrl(scheme: "fb://profile/PageId", page: "https://www.facebook.com/PageName")
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=USERNAME", page: "https://twitter.com/USERNAME")
        case .GooglePlus: return SocialNetworkUrl(scheme: "gplus://plus.google.com/u/0/PageId", page: "https://plus.google.com/PageId")
        }
    }
}


class SettingsController : BaseController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        
        
        ServerManager.fetchSettings { result -> Void in
            
            if result.isSuccess {
                
                if let info = result.value as? NSDictionary {
                    if let table = info["table"] as? NSDictionary {
                        if let sections = table["sections"] as? NSArray {
                            for section in sections{
                                
                                var rows : [TableRow] = []
                                
                                if let tableRows = section["data"] as? NSArray {
                                    for row in tableRows{
                                        
                                        let title = row["title"] as! String
                                        
                                        let icon = row["icon"] as! NSDictionary
                                        
                                        let action = row["action"] as!  NSDictionary
                                
                                        let actionType = ActionType(rawValue:action["type"] as! String)

                                        
                                        rows.append(TableRow(title: title,
                                            
                                            icon: Icon(type: icon["class"] as! NSInteger, index: icon["class"] as! NSInteger, color: UIColor(hex: icon["color"] as! String)),
                                            action: Action(type:actionType!, data: action["data"] ),height:60,type:.Standard
                                        ))
                                        
                                    }
                                    
                                }
                                self.sections.append(TableSection(sectionName:section["name"] as! String, rows:rows))
                            }
                        }
                    }
                }
                
                self.table.reloadData()
            }
        
        }
    
    }

    
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].rows!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : SettingsCell  = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as!
        SettingsCell
        
        let itemData = sections[indexPath.section].rows![indexPath.row] as TableRow
        
        cell.titleLabel.text = itemData.title
        cell.iconBtn.icon = itemData.icon
        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let rowItem = sections[indexPath.section].rows![indexPath.row] as TableRow
        
        switch(rowItem.action!.type){
            
            case .Mail:
                        mailAction(rowItem)
            
            case .Link:
                        openLinkAction(rowItem)
            
            case .DLink:
                        openDlinkAction(rowItem)

            
            default : break;
            
        }
        
//        // set selected shop
//        selectedShop = shops[indexPath.row] as? NSDictionary
//        
//        self.performSegueWithIdentifier(segueShowShopDetail, sender: self)
        
    }
    
    
    func mailAction(item : TableRow){
       
        
        
    }
   
    
  
    
}



class SettingsCell : UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    weak var iconBtn: FADesignableIconButton!
    
    
}
