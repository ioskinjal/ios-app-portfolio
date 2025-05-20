//
//  AddressCell.swift
//  Moms Kitchen
//
//  Created by NCrypted on 30/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnOffice: UIButton!{
        didSet{
            btnOffice.layer.borderColor = UIColor.init(hexString: "0DACF1").cgColor
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
