//
//  ShopFilterOptions.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 17/07/15.
//  Copyright (c) 2015 Barkala Studios. All rights reserved.
//

import UIKit
import Spring



class ShopFilterOptionsController : UIViewController {
    
    
    @IBOutlet weak var modalView: SpringView!
    weak var delegate : ShopListController?

    @IBOutlet weak var resetButton: DesignableButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      modalView.transform = CGAffineTransformMakeTranslation(0, 300)
    
    }

    
    private func titleLabel(text text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 12, y: 12)
        return label
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
      
        modalView.addDarkBlur()
        //resetButton.makeTinted()
        //modalView.insertSubview(resetButton, atIndex: 1)
        //self.view.addVibrantStatusBarBackground(UIBlurEffect(style: .Light))
        
        UIApplication.sharedApplication().sendAction("minimizeView:", to:self.delegate, from: self, forEvent: nil)
//        
        modalView.animate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.removeVibrantStatusBarBackground()
    }
 
    @IBAction func resetButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        UIApplication.sharedApplication().sendAction("maximizeView:", to:self.delegate, from: self, forEvent: nil)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        UIApplication.sharedApplication().sendAction("maximizeView:", to:self.delegate, from: self, forEvent: nil)
    }
    
    
    func callSortTable(){
        
        UIApplication.sharedApplication().sendAction("sortTable:", to:self.delegate, from: self, forEvent: nil)
        
        resetButtonPressed(self)

    }
    
    @IBAction func sortByDistance(sender: AnyObject) {
    
        self.delegate?.sortType = .Distance
        callSortTable()
    }
    
    @IBAction func sortByRating(sender: AnyObject) {
     
        self.delegate?.sortType = .Rating
        
        callSortTable()

    }
    
    @IBAction func sortByReviewCount(sender: AnyObject) {
        
        self.delegate?.sortType = .ReviewCount

        callSortTable()


    }
    
}
