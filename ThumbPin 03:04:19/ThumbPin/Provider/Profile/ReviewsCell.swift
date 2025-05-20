//
//  ReviewsCell.swift
//  ThumbPin
//
//  Created by NCT109 on 04/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    @IBOutlet weak var communicationreview: CosmosView!
    @IBOutlet weak var productReview: CosmosView!
    
    @IBOutlet weak var deliveryreview: CosmosView!
    
    @IBOutlet weak var btnFlagThisReview: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
