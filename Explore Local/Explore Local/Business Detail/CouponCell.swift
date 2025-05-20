//
//  CouponCell.swift
//  Explore Local
//
//  Created by admin on 1/8/19.
//  Copyright © 2019 NCrypted. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var headPromocode: UILabel!
    @IBOutlet weak var imgRedeem: UIImageView!
    @IBOutlet weak var btnRedeem: UIButton!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
               // self.btnRedeem.border(side: .all, color: UIColor.init(hexString: "006300"), borderWidth: 1.0)
            }
        }
    }
    
    @IBOutlet weak var lblRedeemedDate: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!{
        didSet{
            lblPromocode.border(side: .all, color: UIColor.black, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var lblValidDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
