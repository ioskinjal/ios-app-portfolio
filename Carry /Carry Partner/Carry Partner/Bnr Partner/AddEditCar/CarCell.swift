//
//  CarCell.swift
//  BnR Partner
//
//  Created by KASP on 12/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import DropDown

class CarCell: DropDownCell {

    @IBOutlet weak var brandIconImgView: UIImageView!
    @IBOutlet weak var brandBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
