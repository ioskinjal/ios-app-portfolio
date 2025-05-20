//
//  ProductCollectionCell.swift
//  MIShop
//
//  Created by NCrypted on 17/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblResereved: UILabel!
    @IBOutlet weak var imgReserved: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
