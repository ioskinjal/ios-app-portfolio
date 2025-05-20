//
//  NotificationSetingCell.swift
//  XPhorm
//
//  Created by admin on 6/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NotificationSetingCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
