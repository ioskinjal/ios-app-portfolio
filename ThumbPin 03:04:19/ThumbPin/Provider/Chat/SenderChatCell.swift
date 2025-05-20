//
//  SenderChatCell.swift
//  ThumbPin
//
//  Created by NCT109 on 20/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class SenderChatCell: UITableViewCell {

    @IBOutlet weak var btnDownLoadFile: UIButton!
    @IBOutlet weak var conLabelMessageLeading: NSLayoutConstraint!
    @IBOutlet weak var imgvwAttachement: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
