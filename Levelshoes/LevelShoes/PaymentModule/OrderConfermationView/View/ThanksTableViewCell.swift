//
//  ThanksTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ThanksTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderNumberHead: UILabel!{
        didSet{
            lblOrderNumberHead.text = "yourOrderno".localized
        }
    }
    @IBOutlet weak var lblThankyouForShopping: UILabel!{
        didSet{
            lblThankyouForShopping.text = "thankyouForshopping".localized
            lblThankyouForShopping.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var lblThanks: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var orderNumber: UILabel!{
        didSet{
            orderNumber.text = orderId
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
