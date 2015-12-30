//
//  GalleryViewerViewController.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 30/12/15.
//  Copyright © 2015 Barkala Studios. All rights reserved.
//

import UIKit
import FSImageViewer


class GalleryViewerController: FSImageViewerViewController {
	
	var isPresented : Bool
	var closeBtn : FADesignableIconButton?
	
	
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		isPresented = true

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	internal override init(imageSource: FSImageSource, imageIndex: Int)
	{
		isPresented = true
		
		super.init(imageSource: imageSource, imageIndex: imageIndex)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		
		closeBtn?.center = CGPointMake(size.width-closeBtn!.frame.size.width,30.0)
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let size = 28 as CGFloat
		closeBtn = FADesignableIconButton.closeButton(CGRectMake(self.view.frame.size.width - size-5,30, size, size))
		
		closeBtn!.tintColor = UIColor(hex:"#0091FF")
		closeBtn!.addTarget(self, action: Selector("dismiss"), forControlEvents: .TouchUpInside)
		self.view.addSubview(closeBtn!)
	}
	
	func dismiss()
	{
		isPresented = false
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

}