//
//  PersnolDetailBaseCell.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 28/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol PersnolDetailBaseCellDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField, withCell:PersnolDetailBaseCell )
    func textFieldDidChangeSelection(_ textField: UITextField, withCell:PersnolDetailBaseCell)
    func textFieldDidEndEditing(_ textField: UITextField,withCell:PersnolDetailBaseCell)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String,withCell:PersnolDetailBaseCell) -> Bool
    func textFieldShouldReturn(_ textField: UITextField,withCell:PersnolDetailBaseCell) -> Bool
    func saveChangeBtnPress()
    func updateDob(_ textField: UITextField,withCell:PersnolDetailBaseCell)
    func updatePrifex(_ textField: UITextField,withCell:PersnolDetailBaseCell)
    func updateGender(_ textField: UITextField,withCell:PersnolDetailBaseCell)
    func editAddressBook(Cell:addressBookCell)
    func removeAddressBook(Cell:addressBookCell)
    func updateMobileNumber(_ textField: UITextField,withCell:PersnolDetailBaseCell)
}

class PersnolDetailBaseCell: UITableViewCell,UITextFieldDelegate {
     @IBOutlet weak var txtIsdcode: UITextField!
        @IBOutlet weak var txtUserdetail: UITextField!
     var selectedGender = 0
     var delegate: PersnolDetailBaseCellDelegate?
    var cellType = ""
     var addressdata : Addresses?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
           textField.resignFirstResponder()
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

}
