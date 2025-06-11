//
//  EmailPrefTC.swift
//  Luxongo
//
//  Created by admin on 6/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EmailPrefTC: UITableViewCell {

    @IBOutlet weak var lblTittle: LabelSemiBold!
    @IBOutlet weak var btnSwitch: UISwitch!{
        didSet{
            btnSwitch.set(offTint: UIColor.darkGray)
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
