//
//  DealDetailOptionCell.swift
//  Happenings
//
//  Created by admin on 3/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DealDetailOptionCell: UITableViewCell {

    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var viewContent: UIView!{
        didSet{
            viewContent.border(side: .all, color: UIColor.init(hexString: "E0171E"), borderWidth: 1.0)
        }
    }
    @IBOutlet weak var lblDiscountPrice: UILabel!{
        didSet{
            lblDiscountPrice.sizeToFit()
        }
    }
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            lblPrice.sizeToFit()
        }
    }
    @IBOutlet weak var lblDealTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
