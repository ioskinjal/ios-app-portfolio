//
//  passwordCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 30/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField
protocol changePasswordCellDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField, withCell:passwordCell )
    func textFieldDidChangeSelection(_ textField: UITextField, withCell:passwordCell)
     func textFieldDidEndEditing(_ textField: UITextField,withCell:passwordCell)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String,withCell:passwordCell) -> Bool
     func textFieldShouldReturn(_ textField: UITextField,withCell:passwordCell) -> Bool
}
class passwordCell: UITableViewCell ,UITextFieldDelegate {

    weak var delegate : changePasswordCellDelegate?
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var tfPassword: RMTextField!{
        didSet{
            tfPassword.dtLayer.isHidden = true
            tfPassword.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }
    }
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var btnShowPassord: UIButton!
    @IBOutlet weak var viewLIne: UIView!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    @IBOutlet weak var viewCover: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             textField.resignFirstResponder()
            print("Keybord Return")
          return  (self.delegate?.textFieldShouldReturn(textField, withCell: self))!
    
         }
         func textFieldDidBeginEditing(_ textField: UITextField) {
          self.delegate?.textFieldDidBeginEditing(textField, withCell: self)
         }
         func textFieldDidChangeSelection(_ textField: UITextField) {
             self.delegate?.textFieldDidChangeSelection(textField, withCell: self)
         }
         
         func textFieldDidEndEditing(_ textField: UITextField) {
              self.delegate?.textFieldDidEndEditing(textField, withCell: self)
             
         }
         
         func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
             //input text
          return (self.delegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string, withCell: self))!
             
          
         }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- Click Show Button
    @IBAction func onClickShow(_ sender: UIButton) {
        if sender.tag == 0{
            if btnShowPassord.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                btnShowPassord.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                tfPassword.isSecureTextEntry = true
            }else{
                btnShowPassord.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                tfPassword.isSecureTextEntry = false
            }
        }
    }

}
