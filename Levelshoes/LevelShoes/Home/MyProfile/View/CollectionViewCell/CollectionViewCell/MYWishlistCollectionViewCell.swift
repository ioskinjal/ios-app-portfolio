//
//  MYWishlistCollectionViewCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class MYWishlistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                _lblTitle.addTextSpacing(spacing: 1.07)
            }
        }
    }
    @IBOutlet weak var _lblSubTitle: UILabel!
    @IBOutlet weak var _lblPrice: UILabel!
    
//    static let identifier = MYWishlistCollectionViewCell.name
//    static let nib = UINib(nibName: MYWishlistCollectionViewCell.name, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
          super.layoutSubviews()

    }
}
