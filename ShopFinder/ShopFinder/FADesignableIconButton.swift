//
//  FADesignableIconButton.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 20/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import Spring
import FontAwesomeKit


@IBDesignable public class FADesignableIconButton : DesignableButton {
    

    var icon : Icon? {
        didSet{
            if icon != nil {
                self.imageFontClass = icon!.type
                self.imageType = icon!.index
                self.tintColor = icon!.color
                self.alpha = 1
            }else{
                self.alpha = 0
            }
        }
    }
    
    public override var tintColor : UIColor! {
        
        didSet{
            self.borderColor = tintColor!
            self.titleLabel?.textColor = tintColor!
        }
    }
    
    @IBInspectable public var imageFontClass: Int = 0 {
        
        didSet{
            
            if(imageFontClass < 0){
                imageFontClass = 0
            }
            
            if(imageFontClass >= 4){
                imageFontClass = 3
            }
            
            let type = self.imageType
            self.imageType = type
        }
    }
   
    
    @IBInspectable public var imageType: Int = 0 {
        didSet {
            
//            //Helper to list font names
//            let names = UIFont.familyNames()
//
//            for  eachName in names {
//                let n = UIFont.fontNamesForFamilyName(eachName as! String)
//                println(eachName)
//
//                for newName in n {
//                    println("----"+(newName as! String))
//                }
//            }
            
            
            if imageType < 0{
                imageType = 0
            }
            
            let font = UIFont(name:self.fontClassName(), size: self.imageFontSize)
            self.titleLabel?.font = font
            
            let dic : [NSObject : AnyObject] = self.fontAllIcons()
            
            
            if imageType < dic.count {
                let fontCode  = Array(dic.keys)[imageType] as! String
                self.titleLabel?.text = fontCode
                self.setTitle(fontCode, forState: UIControlState.Normal)
            }
        }
    }
    
    @IBInspectable public var imageFontSize: CGFloat = 50 {
        
        didSet{
            let type = self.imageType
            self.imageType = type
        }
    }
    
    
    public func fontAllIcons() -> [NSObject : AnyObject] {
        
        switch(imageFontClass){
            
        case 0 :
            return FAKFontAwesome.allIcons()
            
        case 1:
            return FAKFoundationIcons.allIcons()
            
        case 2:
            return FAKIonIcons.allIcons()
            
        case 3:
            return FAKZocial.allIcons()
            
        default :
            return FAKFontAwesome.allIcons()
        }
        
    }
    
    private func fontClassName() -> String {
        
        let fontClasses = ["FontAwesome","fontcustom","Ionicons","Zocial-Regular"]
        
        
        return fontClasses[abs(self.imageFontClass%fontClasses.count)]
    }
    
}
