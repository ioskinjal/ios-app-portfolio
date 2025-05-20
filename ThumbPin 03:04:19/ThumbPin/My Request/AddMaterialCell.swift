//
//  AddMaterialCell.swift
//  ThumbPin
//
//  Created by admin on 5/9/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class AddMaterialCell: UITableViewCell {

    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblMaterialName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
