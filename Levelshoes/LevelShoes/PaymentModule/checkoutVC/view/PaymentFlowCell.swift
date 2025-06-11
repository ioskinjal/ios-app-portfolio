//
//  PaymentFlowCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

class PaymentFlowCell: UITableViewCell {

    @IBOutlet weak var imgRemainStep: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!{
            didSet{
                reviewLabel.text = "Review".localized
            }
        }
    
    @IBOutlet weak var paymentLabel: UILabel!{
        didSet{
            paymentLabel.text = "Payment".localized
        }
    }
    @IBOutlet weak var shippingLabel: UILabel!{
        didSet{
            shippingLabel.text = "Shipping".localized
        }
    }
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var shippingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.6
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
