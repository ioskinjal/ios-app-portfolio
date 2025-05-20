//
//  FacilityCell.swift
//  Explore Local
//
//  Created by NCrypted on 04/12/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class FacilityCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
