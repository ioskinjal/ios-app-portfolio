//
//  ReviewHomeAddressTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ReviewHomeAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEditYourAddress: UILabel!{
        didSet{
            lblEditYourAddress.text = "edit_address".localized
            lblEditYourAddress.underline()
        }
    }
    @IBOutlet weak var btnEditYourAddress: UIButton!
    @IBOutlet weak var addressTypeLabel: UILabel!{
        didSet{
            addressTypeLabel.text = "home".localized.uppercased()
        }
    }
    @IBOutlet weak var addressDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
