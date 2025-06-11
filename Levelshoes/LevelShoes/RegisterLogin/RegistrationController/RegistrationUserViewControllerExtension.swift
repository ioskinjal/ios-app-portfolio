//
//  RegistrationUserViewControllerExtension.swift
//  LevelShoes
//
//  Created by Maa on 15/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

extension RegistrationUserViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == _txtSalutation {
           
            _btnSLTDropDown.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
            
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tagNo = textField.tag
        
        if textField.tag == 101 || textField.tag == 1 {
            userTitlePicker.selectRow(0, inComponent: 0, animated: false)
            userTitlePicker.reloadAllComponents()
        }
        
        
        if textField == _txtSalutation {
                   _btnSLTDropDown.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
               }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTF{
            let characterCountLimit = 100
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.firstNameCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
            
        }else if textField == lastNameTF{
            let characterCountLimit = 100
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.lastNameCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else if textField == emailTF{
            let characterCountLimit = 999
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.emailCount?.text = "\(newLength)/1000"
            return newLength <= characterCountLimit
        }
        else if textField == mobileTF{
            let characterCountLimit = 15
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.mobileCount?.text = "\(newLength)/10"
            return newLength <= characterCountLimit
        }
        else if textField == passwordTF{
            let characterCountLimit = 100
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.passwordCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else if textField == confirmPassTF{
            let characterCountLimit = 100
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.confirmPassCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else{
            return true
        }
    }
}
