//
//  ProviderListCell.swift
//  ThumbPin
//
//  Created by NCT109 on 21/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ProviderListCell: UICollectionViewCell {
    
    @IBOutlet weak var imgvwProvider: UIImageView!{
        didSet {
            imgvwProvider.createCorenerRadiuss()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
