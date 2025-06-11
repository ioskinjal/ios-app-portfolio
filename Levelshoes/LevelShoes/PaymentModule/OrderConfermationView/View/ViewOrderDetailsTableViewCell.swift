//
//  ViewOrderDetailsTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ViewOrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var vieworderBtnOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        vieworderBtnOutlet.layer.borderWidth = 1
        vieworderBtnOutlet.layer.borderColor = UIColor.black.cgColor
        vieworderBtnOutlet.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
