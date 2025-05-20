//
//  NotificationSettingCell.swift
//  Happenings
//
//  Created by admin on 2/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NotificationSettingCell: UITableViewCell {

    @IBOutlet weak var btnSwitch: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
