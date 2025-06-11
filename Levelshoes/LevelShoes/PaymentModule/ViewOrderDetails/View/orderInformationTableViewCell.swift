//
//  orderInformationTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 25/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class orderInformationTableViewCell: UITableViewCell {

   
    @IBOutlet weak var lblOrderType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblAddType: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblOrderInformation: UILabel!{
        didSet{
            lblOrderInformation.text = "Order Information".localized
        }
    }
    @IBOutlet weak var lblYourOrderNumber: UILabel!{
        didSet{
            lblYourOrderNumber.text = "YOUR ORDER NUMBER:".localized
        }
    }
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
