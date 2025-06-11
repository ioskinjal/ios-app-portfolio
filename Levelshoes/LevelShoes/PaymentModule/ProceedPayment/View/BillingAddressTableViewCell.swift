//
//  BillingAddressTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol BillingAddressProtocol {
    func editBillingAddress()
}

class BillingAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBillingAddress: UILabel!{
        didSet{
            lblBillingAddress.text = "billing_Add".localized
        }
    }
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblEditYourAddress: UILabel!{
        didSet{
            lblEditYourAddress.text = "edit_address".localized
            lblEditYourAddress.underline()
        }
    }
    @IBOutlet weak var addressTypeLabel: UILabel!{
        didSet{
            addressTypeLabel.text = "home".localized
        }
    }
    @IBOutlet weak var addressDetailsLabel: UILabel!
    var delegate: BillingAddressProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editAddressAction(_ sender: UIButton) {
        delegate?.editBillingAddress()
    }
}
