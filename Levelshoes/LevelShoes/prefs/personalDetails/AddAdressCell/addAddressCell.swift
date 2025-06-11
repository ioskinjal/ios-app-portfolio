//
//  addAddressCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class addAddressCell: PersnolDetailBaseCell {
    @IBOutlet weak var btnAddAddress: UIButton!{
        didSet{
            btnAddAddress.setTitle("addAddress".localized, for: .normal)
             btnAddAddress.addTextSpacingButton(spacing: 1.5)
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
