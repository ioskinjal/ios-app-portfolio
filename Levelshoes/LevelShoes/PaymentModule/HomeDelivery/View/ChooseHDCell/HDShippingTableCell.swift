//
//  HDShippingTableCell.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class HDShippingTableCell: UITableViewCell {
   
    @IBOutlet weak var lblShippingAddress: UILabel!{
        didSet{
            lblShippingAddress.text = "shipping_add".localized
        }
    }
    @IBOutlet weak var _lblSelectTitle: UILabel!{
        didSet{
            _lblSelectTitle.text = "shipping_desc".localized
            _lblSelectTitle.addTextSpacing(spacing: 0.5)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
