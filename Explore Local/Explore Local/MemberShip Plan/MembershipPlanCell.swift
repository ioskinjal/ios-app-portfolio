//
//  MembershipPlanCell.swift
//  Explore Local
//
//  Created by NCrypted on 29/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class MembershipPlanCell: UITableViewCell {

    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblduration: UILabel!
    @IBOutlet weak var lblPoint2: UILabel!
    @IBOutlet weak var lblPoint1: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnUpgrade: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
