//
//  changePasswordCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class changePasswordCell: PersnolDetailBaseCell {
    @IBOutlet weak var btnChangePassword: UIButton!{
        didSet{
            btnChangePassword.setTitle("pass_change".localized, for: .normal)
            btnChangePassword.addTextSpacingButton(spacing: 1.5)
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
