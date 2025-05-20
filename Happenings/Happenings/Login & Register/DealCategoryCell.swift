//
//  DealCategoryCell.swift
//  Happenings
//
//  Created by admin on 1/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DealCategoryCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
