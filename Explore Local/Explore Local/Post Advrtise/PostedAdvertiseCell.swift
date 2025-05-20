//
//  PostedAdvertiseCell.swift
//  Explore Local
//
//  Created by NCrypted on 13/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class PostedAdvertiseCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var lblRejectedReason: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var btnApproved: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
