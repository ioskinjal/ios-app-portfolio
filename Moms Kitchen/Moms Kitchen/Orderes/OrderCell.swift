//
//  OrderCell.swift
//  Moms Kitchen
//
//  Created by NCrypted on 29/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    
   
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblqty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
