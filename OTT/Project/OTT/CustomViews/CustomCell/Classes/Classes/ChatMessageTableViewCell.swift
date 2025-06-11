//
//  ChatMessageTableViewCell.swift
//  OTT
//
//  Created by Chandra Sekhar on 15/09/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var chatUserIcon: UIImageView!
    @IBOutlet weak var chatUsername: UILabel!
    @IBOutlet weak var chatUserMessage: UILabel!
    
    @IBOutlet weak var chatUserMessageTxtView: UITextView!
    @IBOutlet weak var chatDateTimeLbl: UILabel!
    @IBOutlet weak var chatSeperatorLbl: UILabel!
    
    static let nibname:String = "ChatMessageTableViewCell"
    static let identifier:String = "ChatMessageTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
