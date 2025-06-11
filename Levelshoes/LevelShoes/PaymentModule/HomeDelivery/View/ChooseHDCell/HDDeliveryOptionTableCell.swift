//
//  HDDeliveryOptionTableCell.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class HDDeliveryOptionTableCell: UITableViewCell {
    @IBOutlet weak var _lblDeliveryOption: UILabel!{
        didSet{
            _lblDeliveryOption.text = "delivery_option".localized
        }
    }
    @IBOutlet weak var _lblDeliveryTitle: UILabel!{
        didSet{
        _lblDeliveryTitle.text = "delivery_option_desc".localized
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
