//
//  PortfolioCollCell.swift
//  ThumbPin
//
//  Created by NCT109 on 04/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class PortfolioCollCell: UICollectionViewCell {

    @IBOutlet weak var labelAddImage: UILabel!
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var stackViewAddimage: UIStackView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgvwPortFolio: UIImageView!
    @IBOutlet weak var btnAddimage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = Color.Custom.blackColor.cgColor
    }

}
