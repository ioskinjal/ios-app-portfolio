//
//  ProfileCarCell.swift
//  BnR Partner
//
//  Created by KASP on 11/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class ProfileCarCell: UITableViewCell {

    @IBOutlet weak var carIcon: UIImageView!
    
    @IBOutlet weak var lblCarName: UILabel!
    
    @IBOutlet weak var lblCarBrand: UILabel!
    @IBOutlet weak var lblCarNumber: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
