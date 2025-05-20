//
//  ImageCheckBoxCell.swift
//  ThumbPin
//
//  Created by NCT109 on 26/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ImageCheckBoxCell: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgvwName: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderColor = Color.Custom.lightGrayColor.cgColor
        contentView.layer.borderWidth = 2
    }

}
