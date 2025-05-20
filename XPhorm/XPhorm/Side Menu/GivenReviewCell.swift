//
//  GivenReviewCell.swift
//  XPhorm
//
//  Created by admin on 6/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos


class GivenReviewCell: UITableViewCell {
@IBOutlet weak var lblId: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
