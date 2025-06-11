//
//  RedeemVoucherTableViewCell.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class RedeemVoucherTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGiftVoucher: UILabel!{
        didSet{
            lblGiftVoucher.text = "Reedem your voucher".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblGiftVoucher.font = UIFont(name: "Cairo-SemiBold", size: lblGiftVoucher.font.pointSize)
            }
        }
    }
    @IBOutlet weak var stackViewCorrect: UIStackView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var redeemVoucherTextField:UITextField!{
        didSet{
            redeemVoucherTextField.placeholder = "Enter your discount code".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                redeemVoucherTextField.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    weak var delegate:WrapGiftTableViewProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension RedeemVoucherTableViewCell : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate.cartTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
}

