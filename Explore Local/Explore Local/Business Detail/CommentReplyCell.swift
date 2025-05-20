//
//  CommentReplyCell.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class CommentReplyCell: UITableViewCell {

    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: UILabel!
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
