//
//  ColorCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var imgColor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
