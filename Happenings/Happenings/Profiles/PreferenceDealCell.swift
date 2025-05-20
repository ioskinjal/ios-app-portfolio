//
//  PreferenceDealCell.swift
//  Happenings
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PreferenceDealCell: UICollectionViewCell {

    @IBOutlet weak var lblsubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnUnsubscribe: UIButton!{
        didSet{
            btnUnsubscribe.layer.borderColor = UIColor.init(hexString: "D22428").cgColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
