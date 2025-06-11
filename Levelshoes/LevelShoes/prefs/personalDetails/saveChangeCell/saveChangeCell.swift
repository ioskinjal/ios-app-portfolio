//
//  saveChangeCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class saveChangeCell: PersnolDetailBaseCell {
    @IBOutlet weak var btnSaveChanges: UIButton!{
        didSet{
            btnSaveChanges.setTitle("saveChanges".localized, for: .normal)
            btnSaveChanges.addTextSpacingButton(spacing: 1.5)
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
    @IBAction func saveChangeBtnPress(_ sender: UIButton){
        self.delegate?.saveChangeBtnPress()
    }
    
}
