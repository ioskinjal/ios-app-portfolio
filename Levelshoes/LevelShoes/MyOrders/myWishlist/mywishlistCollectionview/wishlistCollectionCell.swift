//
//  wishlistCollectionCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 11/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class wishlistCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var wishlistImageItem: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                _lblTitle.addTextSpacing(spacing: 1.07)
            }
        }
    }
    @IBOutlet weak var _lblSubTitle: UILabel!
    @IBOutlet weak var _lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.backgroundColor = .white
        viewContainer.layer.shadowRadius = 7
        viewContainer.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        viewContainer.layer.shadowOpacity = 0.05
        viewContainer.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor

        // Initialization code
//        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
//        viewContainer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.04).cgColor
//        viewContainer.layer.shadowOpacity = 1
//        viewContainer.layer.shadowRadius = 16
//        viewContainer.layer.shadowPath = UIBezierPath(rect: viewContainer.bounds).cgPath
//        viewContainer.layer.shouldRasterize = true
//        viewContainer.layer.rasterizationScale = UIScreen.main.scale
    }
    

}
