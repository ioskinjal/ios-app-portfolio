//
//  DashboardTC.swift
//  Luxongo
//
//  Created by admin on 6/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DashboardTC: UITableViewCell {

    
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblTittle: LabelSemiBold!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeSeparatorLeftPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
