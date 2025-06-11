//
//  CreditCardTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField

protocol creditCardProtocol {
    func creditCardEnable()
    //func creditTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
   

}

class CreditCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var securityCode: DTTextField!{
        didSet{
            securityCode.placeHolder(text: "securty_code".localized, textfieldname: securityCode)
            
            securityCode.dtLayer.isHidden = true
            securityCode.keyboardType = .asciiCapableNumberPad
            securityCode?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            securityCode.floatPlaceholderColor = .black
        }
    }
    @IBOutlet weak var expiaryTxtField: DTTextField!{
        didSet{
             
            expiaryTxtField.placeHolder(text: "mm/yy*".localized, textfieldname: expiaryTxtField)
            
            expiaryTxtField.dtLayer.isHidden = true
            expiaryTxtField?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            expiaryTxtField.keyboardType = .asciiCapableNumberPad
            expiaryTxtField.floatPlaceholderColor = .black
        }
    }
    @IBOutlet weak var cardNumberTextField: DTTextField!{
        didSet{
            cardNumberTextField.placeHolder(text: "cardNo".localized, textfieldname: cardNumberTextField)
            cardNumberTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
            cardNumberTextField.dtLayer.isHidden = true
            cardNumberTextField?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            cardNumberTextField.floatPlaceholderColor = .black
        }
    }
    @IBOutlet weak var creditCardHolderName: DTTextField!{
        didSet{
            creditCardHolderName.placeHolder(text: "nameonCC".localized, textfieldname: creditCardHolderName)
             creditCardHolderName.keyboardType = UIKeyboardType.alphabet
            creditCardHolderName.dtLayer.isHidden = true
            creditCardHolderName?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            creditCardHolderName.floatPlaceholderColor = .black
        }
    }
    @IBOutlet weak var creditCardStackView: UIStackView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var icCreditCard: UIImageView!
    @IBOutlet weak var errorCreditCard: UILabel!
    @IBOutlet weak var lineExpiry: UILabel!
    @IBOutlet weak var lineCreditCard: UILabel!
    @IBOutlet weak var icCardNumber: UIImageView!
    @IBOutlet weak var errorCardNumber: UILabel!
    @IBOutlet weak var lineCardNumber: UILabel!
    @IBOutlet weak var errorExpiry: UILabel!
    @IBOutlet weak var errorSecurityCode: UILabel!
    @IBOutlet weak var lineSecurityCode: UILabel!
    @IBOutlet weak var viewThree: UIStackView!
    @IBOutlet weak var lblWeAccept: UILabel!{
        didSet{
            lblWeAccept.text = "We Accept".localized
        }
    }
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var icExpiry: UIImageView!
    @IBOutlet weak var icSecurity: UIImageView!
    @IBOutlet weak var lblCreditCard: UILabel!{
        didSet{
            lblCreditCard.text = "cc".localized
        }
    }
    @IBOutlet weak var creditCardCheckBtnOutlet: UIButton!
    var delegate: creditCardProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func creditCardAction(_ sender: UIButton) {
        delegate?.creditCardEnable()
    }
}
extension CreditCardTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            cardNumberTextField.floatPlaceholderActiveColor = .black
            let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
            if text.count > 16 {
                return false
            }else{
               // self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
                return true
            }
        }
        if textField == creditCardHolderName{
            creditCardHolderName.floatPlaceholderActiveColor = .black
            let correctLetters = containsOnlyLetters(input: string)
            if(correctLetters){
                //self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
                return true
            }
            else{
                return false
            }
            
        }
        if textField == expiaryTxtField {
            expiaryTxtField.floatPlaceholderActiveColor = .black
//            if (textField.text?.count == 2) {
//                                   //Handle backspace being pressed
//                let month = Int(string) ?? 0
//                                   if !(string == "" && month > 12) {
//
//                                       // append the text
//                                       textField.text = (textField.text)! + "/"
//                                   }else{
//                                    return false
//                }
//        }
//             let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
//            if text.count > 5 {
//                return false
//            }else{
//                self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
//                return true
//            }
             let currentText = textField.text! as NSString
                let updatedText = currentText.replacingCharacters(in: range, with: string)

                if string == "" {

                    if textField.text?.count == 3
                    {
                        textField.text = "\(updatedText.prefix(1))"
                        return false
                    }

                return true
                }

                if updatedText.count == 5
                {

                    expDateValidation(dateStr:updatedText)
                    return updatedText.count <= 5
                } else if updatedText.count > 5
                {
                    return updatedText.count <= 5
                } else if updatedText.count == 1{
                    if updatedText > "1"{
                        return updatedText.count < 1
                    }
                }  else if updatedText.count == 2{   //Prevent user to not enter month more than 12
                    if updatedText > "12"{
                        return updatedText.count < 2
                    }
                }

                textField.text = updatedText


            if updatedText.count == 2 {

                   textField.text = "\(updatedText)/"   //This will add "/" when user enters 2nd digit of month
            }
            //self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
            //                return true

               return false
        }
            if textField == securityCode {
                securityCode.floatPlaceholderActiveColor = .black
                let text = (textField.text! + string).trimmingCharacters(in: .whitespacesAndNewlines)
                if text.count > 6 {
                    return false
                }else{
                    //self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
                    return true
                }
            }
//        if textField == expiaryTxtField{
//                if (textField.text?.count == 2) {
//                        //Handle backspace being pressed
//                        if !(string == "") {
//                            // append the text
//                            textField.text = (textField.text)! + "/"
//                        }
//                   self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
//                    return !(textField.text!.count == 5 && (string.count ) > range.length)
//                }else{
//                    return true
//            }
//            }
        else{
           // self.delegate?.creditTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
            return true
        }
       // return true
    }
    
    func expDateValidation(dateStr:String) {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        if enterdYr > currentYear
        {
            if (1 ... 12).contains(enterdMonth){
                print("Entered Date Is Right")
            } else
            {
                print("Entered Date Is Wrong")
            }

        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                   print("Entered Date Is Right")
                }  else
                {
                   print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else
        {
           print("Entered Date Is Wrong")
        }

    }
    func containsOnlyLetters(input: String) -> Bool {
        for chr in input {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ") ) {
                return false
            }
        }
        return true
    }
}
