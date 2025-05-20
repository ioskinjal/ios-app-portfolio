//
//  InviteFriendCell.swift
//  Talabtech
//
//  Created by NCT 24 on 19/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCreditEarned: UILabel!
    @IBOutlet weak var lblInviteDate: UILabel!
    
    @IBOutlet weak var lblValEmail: UILabel!
    @IBOutlet weak var lblValStatus: UILabel!
    @IBOutlet weak var lblValCreditEarned: UILabel!
    @IBOutlet weak var lblValInviteDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFullWidthSeparator()
        
        lblValEmail.text = ""
        lblValStatus.text = ""
        lblValCreditEarned.text = ""
        lblValInviteDate.text = ""
    }
    
//    var cellData:InviteFriends? {
//        didSet {
//            self.loadCellData()
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func loadCellData() {
//        if let celldata = self.cellData {
//            lblValEmail.text = celldata.email
//            lblValStatus.text = celldata.status
//            lblValCreditEarned.text = celldata.credit_earn
//            lblValInviteDate.text = celldata.invite_date
//        }
//        else{
//
//        }
//    }
    
}
