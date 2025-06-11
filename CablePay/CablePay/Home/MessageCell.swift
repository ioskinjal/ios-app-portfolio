//
//  MessageCell.swift
//  CablePay
//
//  Created by Harry on 12/03/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRadius()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
