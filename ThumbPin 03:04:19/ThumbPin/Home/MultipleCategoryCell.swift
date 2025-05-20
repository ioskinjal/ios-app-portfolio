//
//  MultipleCategoryCell.swift
//  ThumbPin
//
//  Created by admin on 4/5/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class MultipleCategoryCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgcheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
