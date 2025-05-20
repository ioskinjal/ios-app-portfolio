//
//  DisplayAnswCell.swift
//  XPhorm
//
//  Created by admin on 7/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DisplayAnswCell: UITableViewCell {

    @IBOutlet weak var lblAns: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
