//
//  RedeemptionHistoryell.swift
//  XPhorm
//
//  Created by admin on 6/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RedeemptionHistoryell: UITableViewCell {

    @IBOutlet weak var lblReedemedDate: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRedeemedAmount: UILabel!
    @IBOutlet weak var lblAdminFees: UILabel!
    @IBOutlet weak var lblRequestedDate: UILabel!
    @IBOutlet weak var lblRequestedAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
