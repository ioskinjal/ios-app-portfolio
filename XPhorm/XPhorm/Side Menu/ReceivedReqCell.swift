//
//  ReceivedReqCell.swift
//  XPhorm
//
//  Created by admin on 6/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReceivedReqCell: UITableViewCell {

    
   
  
    @IBOutlet weak var lblRequestName: UILabel!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPaynow: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblServiceChanges: UILabel!
    @IBOutlet weak var lblAdminFees: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAdditionalInfo: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRequest: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
