//
//  ZoomAnimator.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 22/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//


import UIKit
import Spring

public class ZoomAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = true
    var duration = 0.4
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        if !isPresenting {
            container!.addSubview(fromView)
            container!.addSubview(toView)
            
            toView.alpha = 0
            toView.transform = CGAffineTransformMakeScale(2, 2)
            SpringAnimation.springEaseInOut(duration) {
                fromView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                fromView.alpha = 0
                toView.transform = CGAffineTransformIdentity
                toView.alpha = 1
            }
        }
        else {
            container!.addSubview(toView)
            container!.addSubview(fromView)
            
             SpringAnimation.springEaseInOut(duration) {
                fromView.transform = CGAffineTransformMakeScale(2, 2)
                fromView.alpha = 0
                toView.transform = CGAffineTransformMakeScale(1, 1)
                toView.alpha = 1
            }
        }
        
        delay(duration, closure: {
            transitionContext.completeTransition(true)
        })
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}