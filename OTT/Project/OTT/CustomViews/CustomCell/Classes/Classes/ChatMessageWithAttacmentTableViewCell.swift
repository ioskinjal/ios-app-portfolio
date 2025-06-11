//
//  ChatMessageWithAttacmentTableViewCell.swift
//  OTT
//
//  Created by Chandra Sekhar on 15/09/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit

struct ChatMessageText {
    let scrBounds = UIScreen.main.bounds.size
    var chatMessageStr : String{
        set{
            chatMsgStr = newValue
            
            let constraintRect = CGSize(width: (scrBounds.width - 55.0), height: CGFloat.greatestFiniteMagnitude)
            let boundingBox = chatMsgStr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 12.0)], context: nil)
            messageHeight = boundingBox.height + 20
        }
        get{
            return chatMsgStr
        }
    }
    
    var messageHeight : CGFloat = 0
    var chatMsgStr = ""
}


class ChatMessageWithAttacmentTableViewCell: UITableViewCell {

    @IBOutlet weak var chatUserIcon: UIImageView!
    @IBOutlet weak var attachmentIcon: UIImageView!
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var chatUsername: UILabel!
    
    @IBOutlet weak var chatUserMessageTxtView: UITextView!
    @IBOutlet weak var chatUserMessageTxtViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatDateTimeLbl: UILabel!
    @IBOutlet weak var attachmentImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var atachmentButton: UIButton!

    static let nibname:String = "ChatMessageWithAttacmentTableViewCell"
    static let identifier:String = "ChatMessageWithAttacmentTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
