//
//  CollectionViewCell.swift
//  OTT
//
//  Created by YuppTV Ent on 19/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionViewCell"
    
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 0.5
        self.layer.borderColor = AppTheme.instance.currentTheme.lineColor.cgColor
        titleLabel.font = UIFont.ottRegularFont(withSize: 14)
        titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        dateLabel.font = UIFont.ottRegularFont(withSize: 12)
        dateLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        
        subTitleLabel.font = UIFont.ottMothlyPlannerSubTitleFont(withSize: 20)
        subTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
}
