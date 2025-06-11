//
//  WrapGiftTableViewCell.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol WrapGiftTableViewProtocol:class {
    func wrapGiftShowOrHide()
    func cartTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
}

class WrapGiftTableViewCell: UITableViewCell {

    weak var delegate:WrapGiftTableViewProtocol!
    
    @IBOutlet weak var txtMessage: RMTextField!
    @IBOutlet weak var txtTo: RMTextField!
    @IBOutlet weak var txtFrom: RMTextField!
    @IBOutlet weak var giftToggle: Toggle!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnGiftWrap: UIButton!
    @IBOutlet weak var fromTextField:RMTextField!{
        didSet{
            fromTextField.placeholder = "From".localized
            fromTextField.dtLayer.isHidden = true
        }
    }
    @IBOutlet weak var toTextField:RMTextField!
    {
        didSet{
            toTextField.placeholder = "To".localized
            toTextField.dtLayer.isHidden = true
        }
    }
    @IBOutlet weak var messageTextField:RMTextField!{
        didSet{
            messageTextField.placeholder = "write_msg_here".localized
            messageTextField.dtLayer.isHidden = true
        }
    }
    @IBOutlet weak var lblGift: UILabel!{
        didSet{
            lblGift.text = "gift_wrap".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblGift.font = UIFont(name: "Cairo-Light", size: lblGift.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblFree: UILabel!{
        didSet{
            lblFree.text = "free".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFree.font = UIFont(name: "Cairo-Light", size: lblFree.font.pointSize)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        giftToggle.delegate = self
        giftToggle.setOn(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func wrapGiftShowOrHide(_ sender: UIButton){
//        delegate.wrapGiftShowOrHide()
//    }
    func updateGiftColor() {
        UIView.transition(with: lblGift, duration: 0.30, options: .transitionCrossDissolve,
                                  animations: {() -> Void in
                                    self.lblGift.textColor = self.giftToggle.isOn == true ? .black : UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
                                    },
                                  completion: {(finished: Bool) -> Void in
                        })
    }
    func updateFreeColor() {
        UIView.transition(with: lblFree, duration: 0.30, options: .transitionCrossDissolve,
                                  animations: {() -> Void in
                                    self.lblFree.textColor = self.giftToggle.isOn == true ? .black : UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
                                    //self.viewHeightConstant.constant = self.giftToggle.isOn == true ? 250 : 0
                                    },
                                  completion: {(finished: Bool) -> Void in
                        })
    }
    
}
extension WrapGiftTableViewCell : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate.cartTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
}
extension WrapGiftTableViewCell: ToggleDelegate {
    func toggleChanged(_ toggle: Toggle) {
        updateGiftColor()
        updateFreeColor()
        delegate.wrapGiftShowOrHide()
    }
}
