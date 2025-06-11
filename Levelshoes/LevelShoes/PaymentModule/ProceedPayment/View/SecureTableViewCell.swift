//
//  SecureTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SecureTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSecurityPayment: UILabel!{
        didSet{
            lblSecurityPayment.text = "securePayOptions".localized
        }
    }
    @IBOutlet weak var lblSendItem: UILabel!{
        didSet{
            lblSendItem.text = "securePayOptionsDesc".localized
            lblSendItem.addTextSpacing(spacing: 0.5)
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
