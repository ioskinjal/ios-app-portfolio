//
//  BusinessItemCell.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class BusinessItemCell: UICollectionViewCell {

  
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
