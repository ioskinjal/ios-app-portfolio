//
//  QuestionListCell.swift
//  ThumbPin
//
//  Created by NCT109 on 21/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class QuestionListCell: UITableViewCell {

    @IBOutlet weak var imgvwCheckmark: UIImageView!
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
