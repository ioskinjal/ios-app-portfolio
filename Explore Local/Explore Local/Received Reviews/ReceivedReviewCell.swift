//
//  ReceivedReviewCell.swift
//  Explore Local
//
//  Created by NCrypted on 14/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Cosmos

class ReceivedReviewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        }
    }
   
    @IBOutlet weak var lblView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgReview: UIImageView!{
        didSet{
            imgReview.setRadius()
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lblMerchantReply: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
