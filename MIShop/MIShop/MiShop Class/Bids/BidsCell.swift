//
//  BidsCell.swift
//  MIShop
//
//  Created by NCrypted on 16/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class BidsCell: UITableViewCell {

    @IBOutlet weak var lblBidAmount: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
