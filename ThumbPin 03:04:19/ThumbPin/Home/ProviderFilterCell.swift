//
//  ProviderFilterCell.swift
//  ThumbPin
//
//  Created by admin on 4/25/19.
//  Copyright © 2019 NCT109. All rights reserved.
//

import UIKit

class ProviderFilterCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgProvider: UIImageView!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
