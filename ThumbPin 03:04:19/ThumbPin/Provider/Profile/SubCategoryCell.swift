//
//  SubCategoryCell.swift
//  ThumbPin
//
//  Created by NCT109 on 05/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Color.Custom.lightGrayColor.cgColor
    }

}
