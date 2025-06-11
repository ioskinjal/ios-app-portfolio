//
//  RedeemEGIftTableViewCell.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class RedeemEGiftTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEgiftcard: UILabel!{
        didSet{
            lblEgiftcard.text = "egift_card".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEgiftcard.font = UIFont(name: "Cairo-SemiBold", size: lblEgiftcard.font.pointSize)
            }
        }
    }
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var stackViewCorrect: UIStackView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var redeemGiftTextField:UITextField!{
        didSet{
            redeemGiftTextField.placeholder = "Enter your e-gift code".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                redeemGiftTextField.font = UIFont(name: "Cairo-Regular", size: 16)
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
extension RedeemEGiftTableViewCell : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate.cartTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
}

