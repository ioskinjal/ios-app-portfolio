//
//  RideCell.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class RideCell: UITableViewCell {
    
    @IBOutlet weak var driveImgView: UIImageView!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var driverIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lblCarType: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var lblParenterName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblRideStatus: UILabel!
    
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var rideDetailView: UIView!
    
    @IBOutlet weak var lblPickUpConst:UILabel!
    @IBOutlet weak var lblDropOffConst:UILabel!
    @IBOutlet weak var lblViewDetail:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPickUpConst.text = appConts.const.pICK_UP
        lblDropOffConst.text = appConts.const.dROP_OFF
        lblViewDetail.text = appConts.const.lBL_VIEW_DETAILS
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
