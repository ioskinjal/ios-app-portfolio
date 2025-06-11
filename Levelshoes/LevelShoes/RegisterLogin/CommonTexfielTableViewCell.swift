//
//  CommonTexfielTableViewCell.swift
//  LevelShoes
//
//  Created by apple on 4/26/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField

class CommonTexfielTableViewCell: UITableViewCell {
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var namenewTf: DTTextField!
    @IBOutlet weak var newimageView: UIImageView!
    @IBOutlet weak var eyeNewBtn: UIButton!
    @IBOutlet weak var eyebtnWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
