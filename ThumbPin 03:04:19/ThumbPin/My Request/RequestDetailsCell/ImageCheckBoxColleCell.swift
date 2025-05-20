//
//  ImageCheckBoxColleCell.swift
//  ThumbPin
//
//  Created by NCT109 on 30/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ImageCheckBoxColleCell: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgvw: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = Color.Custom.lightGrayColor.cgColor
        contentView.layer.borderWidth = 2
    }

}
