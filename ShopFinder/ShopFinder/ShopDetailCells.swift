//
//  ShopDetailCells.swift
//  ShopFinder
//
//  Created by Marcos Pianelli on 20/12/15.
//  Copyright © 2015 Barkala Studios. All rights reserved.
//

import Foundation
import SDWebImage



class ShopDetailDescriptionCell : UITableViewCell {
	
	@IBOutlet weak var descriptionLabel: UILabel!
	
}


class ShopDetailCell : UITableViewCell {
	
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var iconButton: FADesignableIconButton!
}


class ShopDetailGalleryCell : UITableViewCell {
	
	@IBOutlet weak var collectionView: UICollectionView!

	func reloadCollectionView(){
		collectionView.reloadData()
	}
	
	func setCollectionViewDataSourceDelegate
		<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
		(dataSourceDelegate: D, forRow row: Int) {
					
			collectionView.delegate = dataSourceDelegate
			collectionView.dataSource = dataSourceDelegate
			collectionView.tag = row
			collectionView.performSelector(Selector("reloadData"), withObject:nil, afterDelay:0.1)
	}
	
}

class ShopDetailGalleryPhotoCell : UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	
	
	
}