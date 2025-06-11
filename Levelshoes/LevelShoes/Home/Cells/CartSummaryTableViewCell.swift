//
//  CartSummaryTableViewCell.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class CartSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.text = "Order Summary".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
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
