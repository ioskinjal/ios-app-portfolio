//
//  RedeemHistoryCell.swift
//  BooknRide
//
//  Created by KASP on 22/02/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class RedeemHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayHistory(history:RedeemHistory){
        
        lblDate.text = history.createdDateTime
        lblAmount.text = "\(ParamConstants.Currency.currentValue)\(history.amount)"
        lblDescription.text = history.redeemDescription
        lblEmailAddress.text = history.emailAddress

        if history.status.lowercased() == "p"{
        statusBtn.setTitle("  Pending  ", for: UIControlState.normal)
        }
        else if history.status.lowercased() == "c"{
            statusBtn.setTitle("  Completed  ", for: UIControlState.normal)
        }
        else if history.status.lowercased() == "r"{
            statusBtn.setTitle("  Rejected  ", for: UIControlState.normal)
        }        
        
    }
    
}
