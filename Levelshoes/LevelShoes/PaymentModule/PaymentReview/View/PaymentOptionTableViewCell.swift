//
//  PaymentOptionTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol PaymentProtocol {
    func editPaymentOption()
}

class PaymentOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPaymentOption: UILabel!{
        didSet{
            lblPaymentOption.text = "payOption".localized
        }
    }
    
    @IBOutlet weak var lblEditPayment: UILabel!{
        didSet{
            lblEditPayment.text = "editPayOptions".localized
            lblEditPayment.underline()
        }
    }
    @IBOutlet weak var cardEndingNumberLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTypeLabel: UILabel!{
        didSet{
            cardTypeLabel.text = "cc".localized
        }
    }
    
    var delegate: PaymentProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editPaymentOptionAction(_ sender: UIButton) {
        delegate?.editPaymentOption()
    }
    
}
