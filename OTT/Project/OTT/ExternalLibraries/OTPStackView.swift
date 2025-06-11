//
//  OTPStackView.swift
//  OTT
//
//  Created by Rajesh Nekkanti on 16/03/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import Foundation
import UIKit

//Colors
let inactiveFieldBorderColor = UIColor(white: 1, alpha: 0.3)
let textBackgroundColor = UIColor(white: 1, alpha: 0.5)
let activeFieldBorderColor = UIColor.white

class OTPStackView: UIStackView {
    
    //Customise the OTPField here
    let numberOfFields = 4
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleToFill
        self.distribution = .fillEqually
        self.spacing = 20
    }
    
    //Adding each OTPfield to stack view
    func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        //setting first field as firstResponder
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        //Adding constraints wrt to its parent i.e OTPStackView
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: CGFloat(Int(bounds.width)/numberOfFields - 40)).isActive = true
        
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.ottRegularFont(withSize: 21)
        textField.textColor = .white
        textField.viewBorderWidthWithTwo(color : inactiveFieldBorderColor, isWidthOne: false)
        textField.keyboardType = .numberPad
    }
    
    //checks if all the OTPfields are filled
    func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.changeBorder(color: color)
        }
        showsWarningColor = isWarningColor
    }
    
}

//TextField related operations
extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.changeBorder(color: activeFieldBorderColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.changeBorder(color: inactiveFieldBorderColor)
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
                
        if (range.length == 0){
            
            if textField.text == nil {
                textField.resignFirstResponder()
            }else{
                textField.becomeFirstResponder()
            }
            textField.text? = string
            return false
            
        }
        else if (range.length == 1) {
            textField.becomeFirstResponder()
            textField.text? = ""
            return false
            
        }
        return true
    }
    
}


protocol OTPDelegate: class {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}

class OTPTextField: UITextField {
  weak var previousTextField: OTPTextField?
  weak var nextTextField: OTPTextField?
  override public func deleteBackward(){
  if text == "" {
    previousTextField?.becomeFirstResponder()
   }
  }
}

