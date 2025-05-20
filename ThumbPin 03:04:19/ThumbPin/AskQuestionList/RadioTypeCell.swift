//
//  RadioTypeCell.swift
//  ThumbPin
//
//  Created by NCT109 on 27/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class RadioTypeCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgvwRadio: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
