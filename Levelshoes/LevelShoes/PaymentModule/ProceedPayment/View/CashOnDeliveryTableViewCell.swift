//
//  CashOnDeliveryTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol cashonDeliveryProtocol {
    func cashOnDeliveryEnable()
}

class CashOnDeliveryTableViewCell: UITableViewCell {

    var delegate: cashonDeliveryProtocol?
    @IBOutlet weak var lblCashOnDelivery: UILabel!{
        didSet{
            lblCashOnDelivery.text = "cashOndelivery".localized
        }
    }
    @IBOutlet weak var lblPayCash: UILabel!{
        didSet{
            lblPayCash.text = "codDesc".localized
        }
    }
    @IBOutlet weak var cashOnDeliveryCheckbtnoutlet: UIButton!
    @IBOutlet weak var cashOnDeliveryView: UIView!
    
    @IBOutlet weak var viewBg: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func cashOnDeliveryAction(_ sender: UIButton) {
        delegate?.cashOnDeliveryEnable()
    }
}
