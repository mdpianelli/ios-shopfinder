//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Marin Todorov on 2/18/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit

public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
   
  var isPresenting = true
  let duration    = 1.0
  var presenting  = true
  var originFrame = CGRect.zeroRect
  
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

    
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning)-> NSTimeInterval {
    return duration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView()
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    let herbView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
    
    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
    
    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: CGRectGetMidX(initialFrame),
        y: CGRectGetMidY(initialFrame))
      herbView.clipsToBounds = true
    }
    
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(herbView)
    
    UIView.animateWithDuration(duration, delay:0.0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      options: nil,
      animations: {
        herbView.transform = self.presenting ?
          CGAffineTransformIdentity : scaleTransform
        
        herbView.center = CGPoint(x: CGRectGetMidX(finalFrame),
          y: CGRectGetMidY(finalFrame))
        
      }, completion:{_ in
        transitionContext.completeTransition(true)
    })
    
  }
    
    
  
}
