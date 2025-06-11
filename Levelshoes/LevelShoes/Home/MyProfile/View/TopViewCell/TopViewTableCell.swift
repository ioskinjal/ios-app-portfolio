//
//  TopViewTableCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class TopViewTableCell: UITableViewCell {

    @IBOutlet weak var _btnClose: UIButton!
    @IBOutlet weak var lblUserAccount: UILabel!{
        didSet{
            lblUserAccount.text = "aacountAccount".localized.uppercased()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblUserAccount.addTextSpacing(spacing: 1.5)
            }
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
    
    override func layoutSubviews() {
          super.layoutSubviews()

    }
    
}
