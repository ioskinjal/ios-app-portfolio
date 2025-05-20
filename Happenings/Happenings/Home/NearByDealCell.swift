//
//  NearByDealCell.swift
//  Happenings
//
//  Created by admin on 2/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NearByDealCell: UICollectionViewCell {

    @IBOutlet weak var satckViewPrice: UIStackView!
    @IBOutlet weak var stackViewLocation: UIStackView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var viewRound2: UIImageView!
    @IBOutlet weak var lblDistance2: UILabel!
    @IBOutlet weak var viewRound: UIImageView!
    @IBOutlet weak var lblRealPrice: UILabel!
    @IBOutlet weak var lblPriceDiscount: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDealName: UILabel!
    @IBOutlet weak var imgDeal: UIImageView!
    @IBOutlet weak var stackViewRate: UIStackView!
    @IBOutlet weak var lblRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
