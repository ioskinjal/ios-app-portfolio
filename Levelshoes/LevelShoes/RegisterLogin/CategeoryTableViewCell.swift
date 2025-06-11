//
//  CategeoryTableViewCell.swift
//  LevelShoes
//
//  Created by apple on 4/25/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class CategeoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var textLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
