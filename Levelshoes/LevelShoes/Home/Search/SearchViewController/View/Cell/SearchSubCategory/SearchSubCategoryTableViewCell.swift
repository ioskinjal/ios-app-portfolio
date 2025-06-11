//
//  SearchSubCategoryTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SearchSubCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var _lblCategoryName: UILabel!
    @IBOutlet weak var _imgArrow: UIImageView!
    @IBOutlet weak var _line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
