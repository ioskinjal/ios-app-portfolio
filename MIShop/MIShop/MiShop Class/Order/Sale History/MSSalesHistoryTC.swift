//
//  MSSalesHistoryTC.swift
//  MIShop
//
//  Created by nct48 on 20/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSSalesHistoryTC: UITableViewCell {
    @IBOutlet var imgProductImage: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblBuyer: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var btnPending: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
