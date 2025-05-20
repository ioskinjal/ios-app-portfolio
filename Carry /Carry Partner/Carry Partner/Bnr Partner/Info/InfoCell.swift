//
//  InfoCell.swift
//  BooknRide
//
//  Created by KASP on 03/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
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
