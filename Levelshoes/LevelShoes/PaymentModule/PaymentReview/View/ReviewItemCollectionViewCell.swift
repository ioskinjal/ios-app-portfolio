//
//  ReviewItemCollectionViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 28/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ReviewItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblSale: UILabel!{
        didSet{
            lblSale.text = "SALE".localized
        }
    }
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var irtemTypeLabel: UILabel!
    @IBOutlet weak var itemnameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
