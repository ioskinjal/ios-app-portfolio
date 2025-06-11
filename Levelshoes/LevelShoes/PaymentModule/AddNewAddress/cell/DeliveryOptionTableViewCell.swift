//
//  DeliveryOptionTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol DeliveryOptionProtocol {
    func editDeliveryOption()
}

class DeliveryOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    
    var delegate: DeliveryOptionProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        delegate?.editDeliveryOption()
    }
}
