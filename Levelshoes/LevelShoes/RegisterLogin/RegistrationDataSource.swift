//
//  RegistrationDataSource.swift
//  LevelShoes
//
//  Created by apple on 4/26/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON
import MBProgressHUD
import Alamofire
import STPopup



extension RegistartionViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func firstTextFieldplaceHolder(text:String, textfieldname :UITextField)
     {
        
           var myMutableStringTitle = NSMutableAttributedString()
               let Name: String?  = text
            myMutableStringTitle = NSMutableAttributedString(string:Name!)
            let range = (myMutableStringTitle.string as NSString).range(of: "*")
            myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)    // Color
               textfieldname.attributedPlaceholder = myMutableStringTitle
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.setSignUpInputCell(indexPath: indexPath, tableView: tableView, placeholder: "First Name *", text: registerData.firstName, keyboardType: .default, returnKey: .next)
        case 1: return self.setSignUpInputCell(indexPath: indexPath, tableView: tableView, placeholder: "Last Name *", text: registerData.lastName, keyboardType: .default, returnKey: .next)
        case 2: return self.setSignUpInputCell(indexPath:indexPath
            , tableView: tableView, placeholder: "Email Address *", text: registerData.emailAddress, keyboardType: .default, returnKey: .next)
        case 3: return self.setSignUpInputCell(indexPath: indexPath, tableView: tableView, placeholder: "Mobile Number *", text: registerData.mobileNumber, keyboardType: .numberPad, returnKey: .next)
        case 4: return self.setSignUpInputCell(indexPath: indexPath, tableView: tableView, placeholder: "Password *", text: registerData.password, keyboardType: .default, returnKey: .next)
        case 5: return self.setSignUpInputCell(indexPath: indexPath, tableView: tableView, placeholder: "Confirm Password *", text: registerData.confirmPAssword, keyboardType: .default, returnKey: .next)
        default:
            break
        }
      
       return UITableViewCell ()
        
    }
    func setSignUpInputCell(indexPath : IndexPath, tableView: UITableView, placeholder:String, text:String, keyboardType:UIKeyboardType, returnKey : UIReturnKeyType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTexfielTableViewCell") as! CommonTexfielTableViewCell
        cell.namenewTf.delegate = self
        cell.namenewTf.placeholder = placeholder
        let textnew = SkyFloatingLabelTextField ()
        textnew.title = placeholder
        cell.namenewTf.text = text
        textnew.selectedTitleColor = UIColor.lightGray
        self.firstTextFieldplaceHolder(text:textnew.selectedTitle ?? "new", textfieldname:cell.namenewTf)
        self.firstTextFieldplaceHolder(text:placeholder, textfieldname:cell.namenewTf)
        //cell.eyebtnWidthConstant.constant = indexPath.row == 5 ? 30 : 0
        cell.namenewTf.errorFont = BrandenFont.thin(with: 16.0)
        cell.namenewTf.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        cell.namenewTf.font = BrandenFont.thin(with: 18.0)
        cell.namenewTf.dtLayer.isHidden = true
        cell.namenewTf.tag = indexPath.row
        cell.newimageView.tag = indexPath.row
        cell.eyeNewBtn.tag = indexPath.row
        cell.eyeNewBtn .addTarget(self, action: #selector(onClickShow), for: .touchUpInside)
        
        
        if indexPath.row == 4 || indexPath.row == 5
        {
           cell.eyeNewBtn.isHidden = false
        }
        else
        {
            cell.eyeNewBtn.isHidden = true
        }
        if indexPath.row == errorIndex {
              cell.namenewTf.errorMessage = self.errorMessage
            cell.errorView.backgroundColor = UIColor.red
            cell.newimageView.isHidden = false
            cell.namenewTf.showError()
            cell.namenewTf.floatPlaceholderActiveColor = UIColor.red
        }
        else
        {
             cell.newimageView.isHidden = true
        }
        cell.namenewTf.addTarget(self, action: #selector(didChangeTextValue), for: .editingChanged)
        cell.namenewTf.addTarget(self, action: #selector(didChangeTextValue), for: .editingChanged)
        return cell
    }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
   let indexpath = IndexPath(row: textField.tag, section: 0)
    let cell = tableView.cellForRow(at: indexpath) as! CommonTexfielTableViewCell
    let color2 = UIColor(hex: 0xFAFAFA)
    cell.namenewTf.backgroundColor = color2//delegate method
    errorIndex = 999
    errorMessage =  ""
    return true
  }
    
    func onclickValidate (_ textField:Float)
    {
                  let indexpath = IndexPath(row: Int(textField), section: 0)
                  let cell = tableView.cellForRow(at: indexpath) as! CommonTexfielTableViewCell
                   let u_first_name = ValidationClass.verifyFirstname(text: registerData.firstName)
                   let u_last_name = ValidationClass.verifyLastname(text: registerData.lastName)
                   let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
                   let u_contact = ValidationClass.verifyPhoneNumber(text: registerData.mobileNumber)
                   let u_password = ValidationClass.verifyPassword(text: registerData.password)
                   let u_confirm_pass = ValidationClass.verifyPasswordAndConfirmPassword(password: registerData.password, confirmPassword: registerData.confirmPAssword)
                   if !u_first_name.1 {
                       errorIndex = 0
                       errorMessage = u_first_name.0
                    cell.newimageView.isHidden = false
                    cell.eyeNewBtn.isHidden = true
                    cell.errorView.backgroundColor = UIColor.red
                    cell.newimageView.image = UIImage(named: "icn_error")
                       
                   } else if !u_last_name.1 {
                       errorIndex = 1
                       errorMessage = u_last_name.0
                    cell.newimageView.isHidden = false
                    cell.eyeNewBtn.isHidden = true
                    cell.errorView.backgroundColor = UIColor.red
                    cell.newimageView.image = UIImage(named: "icn_error")
                   }
                       else if !u_email.1 {
                           errorIndex = 2
                           errorMessage = u_email.0
                    cell.newimageView.isHidden = false
                    cell.eyeNewBtn.isHidden = true
                    cell.errorView.backgroundColor = UIColor.red
                    cell.newimageView.image = UIImage(named: "icn_error")
                       }
                   else if !u_contact.1 {
                       errorIndex = 3
                       errorMessage = u_contact.0
                    cell.newimageView.isHidden = false
                    cell.eyeNewBtn.isHidden = true
                    cell.errorView.backgroundColor = UIColor.red
                    cell.newimageView.image = UIImage(named: "icn_error")
                   }
                   else if !u_password.1 {
                       errorIndex = 4
                       errorMessage = u_password.0
                    cell.newimageView.isHidden = false
                    cell.eyeNewBtn.isHidden = false
                    cell.errorView.backgroundColor = UIColor.red
                    cell.newimageView.image = UIImage(named: "icn_error")
                   }  else if !u_confirm_pass.1 {
                       errorIndex = 5
                       errorMessage = u_confirm_pass.0
                    cell.newimageView.isHidden = false
                    cell.errorView.backgroundColor = UIColor.red
                    cell.eyeNewBtn.isHidden = false
                    cell.newimageView.image = UIImage(named: "icn_error")
                   }
        else
                   {
                    cell.newimageView.isHidden = false
                    cell.errorView.backgroundColor = UIColor.lightGray
                   cell.newimageView.image = UIImage(named: "Successnew@1x.png")
        }
        
    }
    
    @IBAction func onClickShow(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! CommonTexfielTableViewCell
             if sender.tag == 4{
                 if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                     sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                    cell.namenewTf.isSecureTextEntry = true
                 }else{
                     sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                      cell.namenewTf.isSecureTextEntry = false
                 }
             }
             else if sender.tag == 5{
                if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                                   sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                                  cell.namenewTf.isSecureTextEntry = true
                               }else{
                                   sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                                    cell.namenewTf.isSecureTextEntry = false
                               }
                
        }
         }
    
    
    @objc func didChangeTextValue(textField :SkyFloatingLabelTextField)  {
        let indexpath = IndexPath(row: textField.tag, section: 0)
        let cell = tableView.cellForRow(at: indexpath) as! CommonTexfielTableViewCell
        let color2 = UIColor(hex: 0x616161)
        cell.errorView.backgroundColor = color2
        textField.errorMessage = nil
        cell.namenewTf.hideError()
        errorIndex = 999
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 ;//Choose your custom row height
    }
}

extension RegistartionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           guard let nextTextField = view.viewWithTag(textField.tag + 1) else {
               view.endEditing(true)
               return false
           }
           _ = nextTextField.becomeFirstResponder()
           return false
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        switch textField.tag {
        case 0:
            if str.length > 160 {
                return false
            }
            break
        case 1:
            
            if str.length > 160 || string == " " {
                return false
            }
            break
      
        case 2:
            if str.length > 160 || string == " " {
                return false
            }
            break
        case 3:
            if str.length > 160 || string == " " {
                return false
            }
            break
            
        case 4:
            if str.length > 160 {
                return false
            }
            break
        case 5:
            if str.length > 160  {
                return false
            }
            break
        default:
            break
        }
        return true
        
    }
        func textFieldDidEndEditing(_ textField: UITextField) {
               let indexpath = IndexPath(row: textField.tag, section: 0)
               let cell = tableView.cellForRow(at: indexpath) as! CommonTexfielTableViewCell
               let color2 = UIColor.clear
            switch textField.tag {
            case 0: registerData.firstName = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            case 1: registerData.lastName = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            case 2: registerData.emailAddress = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            case 3: registerData.mobileNumber = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            case 4: registerData.password = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            case 5: registerData.confirmPAssword  = textField.text!.trimWhiteSpace
            cell.namenewTf.backgroundColor = color2
            cell.newimageView.image = UIImage(named:"Successnew.png")
                break
            default:
                break
            }
        }
     //validation methods
        func isAllValid() -> Bool {
            var isValid = false
            let u_first_name = ValidationClass.verifyFirstname(text: registerData.firstName)
            let u_last_name = ValidationClass.verifyLastname(text: registerData.lastName)
             let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
            let u_contact = ValidationClass.verifyPhoneNumber(text: registerData.mobileNumber)
            let u_password = ValidationClass.verifyPassword(text: registerData.password)
            let u_confirm_pass = ValidationClass.verifyPasswordAndConfirmPassword(password: registerData.password, confirmPassword: registerData.confirmPAssword)
            errorIndex = 999
            errorMessage = ""
            
            if !u_first_name.1 {
                errorIndex = 0
                errorMessage = u_first_name.0
            } else if !u_last_name.1 {
                errorIndex = 1
                errorMessage = u_last_name.0
            }
                else if !u_email.1 {
                    errorIndex = 2
                    errorMessage = u_email.0
                }
            /*else if !u_contact.1 {
                errorIndex = 3
                errorMessage = u_contact.0
            }*/
            else if !u_password.1 {
                errorIndex = 4
                errorMessage = u_password.0
            }  else if !u_confirm_pass.1 {
                errorIndex = 5
                errorMessage = u_confirm_pass.0
            } else {
                isValid = true
            }
            
            return isValid
        }
    
    //MARK:- Registration Api
     func CallCreateUserApi ()
     {
        MBProgressHUD.showAdded(to: view, animated: true)
               
        let populatedDictionary = ["firstname":registerData.firstName, "lastname":registerData.lastName, "email" :registerData.emailAddress]
                      let params = [
                          "customer"  : populatedDictionary,
                          "password" : registerData.password as Any
                        ] as [String : Any]
               
        
        let url = getWebsiteBaseUrl(with: "rest")+CommonUsed.globalUsed.KUserregistration

                   ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
                   if let error = error{
                       print(error)
                       if error.localizedDescription.contains(s: "offline"){
                           let nextVC = NoInternetVC.storyboardInstance!
                           nextVC.modalPresentationStyle = .fullScreen
                           nextVC.delegate = self

                           
                       }
                       self.sharedAppdelegate.stoapLoader()
                       return
                   }
                   if response != nil{
                       if statusCode == 200  {
                        let popupController = STPopupController.init(rootViewController: SuccessScreenViewController.storyboardInstance!)
                                      popupController.style = .bottomSheet
                                      popupController.present(in: self)
                                      popupController.hidesCloseButton = true
                                      popupController.setNavigationBarHidden(true, animated: true)
                        
                       }
                       if statusCode == 401  {
                            let errorMessage = response?.dictionaryValue["result"]?.stringValue
                           let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                           alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                           self.present(alert, animated: true, completion: nil)
                       }
                       else{
                        let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message: "something_wrong".localized, preferredStyle: UIAlertControllerStyle.alert)
                           alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                           self.present(alert, animated: true, completion: nil)
                       }
                       MBProgressHUD.hide(for: self.view, animated: true)
                   }else{
                       print("something went wrong")
                        MBProgressHUD.hide(for: self.view, animated: true)
                   }
               }
           }
    }
    



