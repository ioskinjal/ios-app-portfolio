//
//  ImageCVC.swift
//  OTT
//
//  Created by Muzaffar on 15/05/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit

class ImageCVC: UICollectionViewCell {
    
    static let size = CGSize.init(width:  (productType.iPad ? 181:145), height: (productType.iPad ? 102 : 82))
    static let nibname:String = "ImageCVC"
    static let identifier:String = "ImageCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }

}


