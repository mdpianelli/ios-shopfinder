//
//  AwesomeFontsDesignableImage.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 18/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Spring

@IBDesignable public class FADesignableIconLabel: SpringLabel {
    

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
            
            self.textAlignment = NSTextAlignment.Center
            
            let font = UIFont(name:self.fontClassName(), size: self.imageFontSize)
            self.font = font
        
            let dic : [NSObject : AnyObject] = self.fontAllIcons()
    
            if imageType < dic.count {
                let fontCode  = Array(dic.keys)[imageType] as! String
                self.text = fontCode
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
        
        var dic : [NSObject : AnyObject]

        
        switch(imageFontClass){
            
            case 0 :
                dic = FAKFontAwesome.allIcons()
                
            case 1:
                dic = FAKFoundationIcons.allIcons()
                
            case 2:
                dic = FAKIonIcons.allIcons()
                
            case 3:
                dic = FAKZocial.allIcons()
                
            default :
                dic = FAKFontAwesome.allIcons()
        }
        
        return dic
        
        
    }
    private func fontClassName() -> String {
        
        
        let fontClasses = ["FontAwesome","fontcustom","Ionicons","Zocial-Regular"]
        
        
        return fontClasses[abs(self.imageFontClass%fontClasses.count)]
    }
    
}
    