//
//  ReviewCell.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblDealName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgMerchant: UIImageView!{
        didSet{
            imgMerchant.setRadius()
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
