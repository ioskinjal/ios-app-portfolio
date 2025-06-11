//
//  OrderReviewTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class OrderReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblShippingAddress: UILabel!{
        didSet{
            lblShippingAddress.text = "shipping_add".localized.uppercased()
        }
    }
    
    @IBOutlet weak var lblOrderReview: UILabel!{
        didSet{
            lblOrderReview.text = "order_review".localized
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
