//
//  CommentCell.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Cosmos

class CommentCell: UITableViewCell {

    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblDateMerchant: UILabel!
    @IBOutlet weak var lblMerchantComment: UILabel!
    @IBOutlet weak var lblNameMerchant: UILabel!
    @IBOutlet weak var imgMerchant: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnFlag: UIButton!
    @IBOutlet weak var viewRate: CosmosView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
