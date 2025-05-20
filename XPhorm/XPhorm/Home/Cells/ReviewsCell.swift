//
//  ReviewsCell.swift
//  XPhorm
//
//  Created by admin on 5/30/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
}
