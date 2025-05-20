//
//  PaymentHistoryCell.swift
//  XPhorm
//
//  Created by admin on 6/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet weak var lblTotalAmountHead: UILabel!
    @IBOutlet weak var lblPaymentDateHead: UILabel!
    @IBOutlet weak var lblAdminFeesHead: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblTransactionIdHead: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblPaymentDate: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblAdminFees: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
