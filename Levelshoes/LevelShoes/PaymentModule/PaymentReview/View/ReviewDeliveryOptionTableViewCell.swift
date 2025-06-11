//
//  ReviewDeliveryOptionTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol ReviewDeliveryOptionPortocol {
    func editDeliveryOprion()
}

class ReviewDeliveryOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDeliveryOption: UILabel!{
        didSet{
            lblDeliveryOption.text = "delOption".localized
        }
    }
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryDataLabel: UILabel!
    
    @IBOutlet weak var lblEditDelivery: UILabel!{
        didSet{
            lblEditDelivery.text = "edit_delivery_option".localized
            lblEditDelivery.underline()
        }
    }
    var delegate: ReviewDeliveryOptionPortocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editDeliveryAction(_ sender: UIButton) {
        delegate?.editDeliveryOprion()
    }
    
}
