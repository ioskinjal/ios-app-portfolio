//
//  SingleImageCell.swift
//  Explore Local
//
//  Created by NCrypted on 17/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class SingleImageCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
