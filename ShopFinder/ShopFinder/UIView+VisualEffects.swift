//
//  UIView+VisualEffects.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 18/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit



extension UIView {
    
    
    func addLightBlur(){
        
        self.backgroundColor = UIColor.clearColor()
        
        let lightBlur = UIBlurEffect(style: .Light)
        let lightBlurView = UIVisualEffectView(effect: lightBlur)
        
        let lightVibrancyView = vibrancyEffectView(forBlurEffectView: lightBlurView)
        lightBlurView.contentView.addSubview(lightVibrancyView)
        lightBlurView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.insertSubview(lightBlurView, atIndex: 0)
        

    }
    
    
    func addExtraLightBlur(){
        
        self.backgroundColor = UIColor.clearColor()
        
        let extraLightBlur = UIBlurEffect(style: .ExtraLight)
        let lightBlurView = UIVisualEffectView(effect: extraLightBlur)
        
        let lightVibrancyView = vibrancyEffectView(forBlurEffectView: lightBlurView)
        lightBlurView.contentView.addSubview(lightVibrancyView)
        lightBlurView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.insertSubview(lightBlurView, atIndex: 0)
        
        
    }
    
    func addDarkBlur(){
        
        self.backgroundColor = UIColor.clearColor()
        
        let darkBlur = UIBlurEffect(style: .Dark)
        let lightBlurView = UIVisualEffectView(effect:darkBlur)
        
        let lightVibrancyView = vibrancyEffectView(forBlurEffectView: lightBlurView)
        lightBlurView.contentView.addSubview(lightVibrancyView)
        lightBlurView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.insertSubview(lightBlurView, atIndex: 0)
        
        
    }
    
    
    
    private func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffectView.effect as! UIBlurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.frame = blurEffectView.bounds
        vibrancyView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return vibrancyView
    }
    
    func addVibrantStatusBarBackground(effect: UIBlurEffect) {
        let statusBarBlurView = UIVisualEffectView(effect: effect)
        statusBarBlurView.frame = UIApplication.sharedApplication().statusBarFrame
        statusBarBlurView.autoresizingMask = .FlexibleWidth
        
        let statusBarVibrancyView = vibrancyEffectView(forBlurEffectView: statusBarBlurView)
        statusBarBlurView.contentView.addSubview(statusBarVibrancyView)
        
        let statusBar = UIApplication.sharedApplication().valueForKey("statusBar") as! UIView
        statusBar.superview!.insertSubview(statusBarBlurView, belowSubview: statusBar)
        self.addSubview(statusBarBlurView)
        
        let statusBarBackgroundImage = UIImage(named: "MaskPixel")!.imageWithRenderingMode(.AlwaysTemplate)
        let statusBarBackgroundView = UIImageView(image: statusBarBackgroundImage)
        statusBarBackgroundView.frame = statusBarVibrancyView.bounds
        statusBarBackgroundView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        statusBarVibrancyView.contentView.addSubview(statusBarBackgroundView)
        
        statusBarBlurView.tag = 1
        
    }
    
    func removeVibrantStatusBarBackground(){
        self.viewWithTag(1)?.removeFromSuperview()
    }

    
    
    
}