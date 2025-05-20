//
//  FavoriteDealCell.swift
//  Happenings
//
//  Created by admin on 2/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import ImageSlideshow

class FavoriteDealCell: UICollectionViewCell {

    @IBOutlet weak var imgAdmin: UIImageView!
    @IBOutlet weak var viewSlideShow: ImageSlideshow!
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var lblOldPrice: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDeal: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgDeal: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
