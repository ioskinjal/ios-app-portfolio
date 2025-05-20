//
//  MenuCell.swift
//  Moms Kitchen
//
//  Created by NCrypted on 31/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var stackViewCustomize: UIStackView!
    @IBOutlet weak var btncart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblfoodName: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
