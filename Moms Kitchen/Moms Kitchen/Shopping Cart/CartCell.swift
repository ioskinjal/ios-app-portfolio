//
//  CartCell.swift
//  Moms Kitchen
//
//  Created by NCrypted on 30/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var viewQTY: UIView!{
        didSet{
            viewQTY.border(side: .all, color: Color.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewCustomization: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnMinus: UIButton!{
        didSet{
             btnMinus.border(side: .left, color: Color.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var btnPlus: UIButton!{
        didSet{
            btnPlus.border(side: .right, color: Color.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var lblCustomization: UILabel!
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
