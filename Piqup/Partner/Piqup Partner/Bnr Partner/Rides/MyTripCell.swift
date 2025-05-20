 //
//  MyTripCell.swift
//  Carry
//
//  Created by NCrypted on 21/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class MyTripCell: UITableViewCell {

    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblTripDate: UILabel!
    @IBOutlet weak var imgVehichle: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var driverIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTripDate: UIView!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.viewTripDate.addDashedBorder()
            }
        }
    }
    @IBOutlet weak var viewTripTime: UIView!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.viewTripTime.addDashedBorder()
            }
        }
    }
    @IBOutlet weak var viewDriverName: UIView!{
        didSet{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.viewDriverName.addDashedBorder()
            }
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
