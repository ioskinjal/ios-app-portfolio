//
//  ProductSizeTableViewCell.swift
//  Level Shoes
//
//  Created by Zing Mobile on 10/04/20.
//  Copyright © 2020 IDSLogic. All rights reserved.
//

import UIKit

class ProductSizeTableViewCell: UITableViewCell {

    @IBOutlet var sizeLbl: UILabel!
    @IBOutlet var stockLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
