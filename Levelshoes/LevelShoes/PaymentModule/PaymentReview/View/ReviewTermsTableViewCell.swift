//
//  ReviewTermsTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 28/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ReviewTermsTableViewCell: UITableViewCell {

    @IBOutlet weak var termsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let  organizationSettingString = NSMutableAttributedString(string: "t_C_agree".localized, attributes: [
            .foregroundColor: UIColor.black,
            .kern: 0.0
        ])
        /*organizationSettingString.addAttributes([
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 51, length: 19))*/
        termsLabel.attributedText = organizationSettingString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
