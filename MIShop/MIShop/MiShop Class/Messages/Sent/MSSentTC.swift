//
//  MSSentTC.swift
//  MIShop
//
//  Created by nct48 on 06/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSSentTC: UITableViewCell
{
    
    @IBOutlet var imgUserImage: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var btnDeleteMessage: UIButton!
    @IBOutlet var lblLastMessage: UILabel!
    @IBOutlet var lblTimeOfLastMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
