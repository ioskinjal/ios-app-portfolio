//
//  OrderSummaryCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

class OrderSummaryCell: UITableViewCell {

    @IBOutlet weak var lblheadOrderSummary: UILabel!{
        didSet{
            lblheadOrderSummary.text = "Order Summary".localized
        }
    }
    @IBOutlet weak var lblHeadAutoDiscount: UILabel!{
        didSet{
            lblHeadAutoDiscount.text = "Auto Discount".localized
        }
    }
    @IBOutlet weak var lblShippingHead: UILabel!{
        didSet{
            lblShippingHead.text = "Shipping".localized
        }
    }
    @IBOutlet weak var lblHeadGrandTotla: UILabel!{
        didSet{
        lblHeadGrandTotla.text = "Grand Total".localized
        }
    }
    @IBOutlet weak var vatLabel: UILabel!{
        didSet{
            vatLabel.text = getVatName()
        }
    }
    @IBOutlet weak var subtotalLeftLabel: UILabel!
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var autoDiscount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
