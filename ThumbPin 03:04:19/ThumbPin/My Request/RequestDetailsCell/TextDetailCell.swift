//
//  TextDetailCell.swift
//  ThumbPin
//
//  Created by NCT109 on 30/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class TextDetailCell: UITableViewCell {

    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
