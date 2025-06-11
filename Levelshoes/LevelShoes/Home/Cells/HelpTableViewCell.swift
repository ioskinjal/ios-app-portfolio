//
//  HelpTableViewCell.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {
    @IBOutlet weak var btnNeedHelp: UIButton!{
        didSet{
            btnNeedHelp.setTitle("Need Help".localized.uppercased(), for: .normal)
            btnNeedHelp.addTextSpacing(spacing: 1.5, color: Common.blackColor)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnNeedHelp.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
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

}
