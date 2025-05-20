//
//  ReceiverChatCell.swift
//  ThumbPin
//
//  Created by NCT109 on 20/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ReceiverChatCell: UITableViewCell {

    @IBOutlet weak var btnDownloadFile: UIButton!
    @IBOutlet weak var conLabelMessageLeading: NSLayoutConstraint!
    @IBOutlet weak var imgvwAttachement: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
