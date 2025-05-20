//
//  ShoppingCartCell.swift
//  Happenings
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOptionDiscountPrice: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblDealName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
