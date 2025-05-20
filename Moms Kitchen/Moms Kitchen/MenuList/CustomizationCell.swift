//
//  CustomizationCell.swift
//  Moms Kitchen
//
//  Created by NCrypted on 21/09/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class CustomizationCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
