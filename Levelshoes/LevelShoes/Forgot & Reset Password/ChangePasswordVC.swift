//
//  ChangePasswordVC.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 27/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import STPopup
import DTTextField
import MBProgressHUD

class ChangePasswordVC: UIViewController {
    
    static var storyboardInstance:ChangePasswordVC? {
        return StoryBoard.ForgotPW.instantiateViewController(withIdentifier: ChangePasswordVC.identifier) as? ChangePasswordVC
        
    }
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    
    @IBOutlet weak var lblConfirmCount: UILabel!
    @IBOutlet weak var lblPwdCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
            lblTitle.addTextSpacing(spacing: 1.5)
            }else{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            lblTitle.text = "CHANGE PASSWORD".localized
        }
    }
    @IBOutlet weak var lblToUse: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" != "en"{
                lblToUse.font = UIFont(name: "Cairo-Light", size: lblToUse.font.pointSize)
            }
            lblToUse.text = "To use your level account, please enter a new password.".localized
        }
    }
    @IBOutlet weak var lblEnterPasswordTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" != "en"{
                lblEnterPasswordTitle.font = UIFont(name: "Cairo-SemiBold", size: lblEnterPasswordTitle.font.pointSize)
            }
            lblEnterPasswordTitle.text = "Enter your new password".localized
        }
    }
    @IBOutlet weak var btnErPwd: UIButton!
    @IBOutlet weak var btnErConfirmPwd: UIButton!
    
    @IBOutlet weak var btnChangePWD: UIButton!{
        didSet{
            btnChangePWD.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            btnChangePWD.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
                btnChangePWD.addTextSpacing(spacing: 1.5, color: "ffffff")
            }else{
                btnChangePWD.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
            }
            btnChangePWD.setTitle("CHANGE PASSWORD".localized, for: .normal)
        }
    }
    var ErrorMsg = ""
    @IBOutlet weak var txtConfirmPwd: RMTextField!{
        didSet{
            txtConfirmPwd.borderColor = .black
            txtConfirmPwd.dtborderStyle = .bottom
            txtConfirmPwd.placeHolder(text: "Confirm Password*".localized, textfieldname: txtConfirmPwd)
            if UserDefaults.standard.value(forKey: "language")as? String ?? "en" == "en" {
                txtConfirmPwd.errorFont = BrandenFont.thin(with: 12.0)
                txtConfirmPwd.floatPlaceholderFont = BrandenFont.thin(with: 12.0)
            }else{
                txtConfirmPwd.errorFont = UIFont(name: "Cairo-Light", size: 12)!
                txtConfirmPwd.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 12)!
                txtConfirmPwd.font = UIFont(name: "Cairo-Light", size: 15)
            }

            txtConfirmPwd.delegate = self
        }
    }
    
    func onCLickCheckpassword ()
    {
        if (txtPwd.text?.isEmpty)! {
            txtPwd.showError(message: "Please enter current password".localized)
                  ErrorMsg = txtPwd.errorMessage
                  txtPwd.borderColor = .red
                  btnErPwd.isHidden = false
                  txtPwd.floatPlaceholderActiveColor = .red
              }
        else if (txtPwd.text!.count < 6)
        {
            txtPwd.showError(message: "Password must contain at leat 6 characters".localized)
                             ErrorMsg = txtPwd.errorMessage
                             txtPwd.borderColor = .red
                             btnErPwd.isHidden = false
                             txtPwd.floatPlaceholderActiveColor = .red
        }
        else
        {
                       txtPwd.borderColor = .black
                       btnErPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
                       btnErPwd.isHidden = false
        }
    }
    
    
    func onClickConfirmPassword ()
    {
        if (txtConfirmPwd.text?.isEmpty)! {
            txtConfirmPwd.showError(message: "Please enter confirm password".localized)
                        ErrorMsg = txtConfirmPwd.errorMessage
                        txtConfirmPwd.borderColor = .red
                        btnErConfirmPwd.isHidden = false
                       txtConfirmPwd.floatPlaceholderActiveColor = .red
                    }
              else if (txtConfirmPwd.text!.count < 6)
              {
                txtConfirmPwd.showError(message: "Confirm Password must contain at leat 6 characters".localized)
                                   ErrorMsg = txtConfirmPwd.errorMessage
                                   txtConfirmPwd.borderColor = .red
                                   btnErConfirmPwd.isHidden = false
                                    txtConfirmPwd.floatPlaceholderActiveColor = .red
              }
        else if (txtPwd.text != txtConfirmPwd.text)
                         {
                            txtConfirmPwd.showError(message: "Password and confirm password should be same".localized)
                                              ErrorMsg = txtConfirmPwd.errorMessage
                                              txtConfirmPwd.borderColor = .red
                                             btnErConfirmPwd.isHidden = false
                                              txtConfirmPwd.floatPlaceholderActiveColor = UIColor(hexString: "#474747")
                         }
              else
              {
                             txtConfirmPwd.borderColor = .black
                             btnErConfirmPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
                             btnErConfirmPwd.isHidden = false
              }
    }
    
    @IBOutlet weak var txtPwd: RMTextField!{
        didSet{
            txtPwd.borderColor = .black
            txtPwd.dtborderStyle = .bottom
            txtPwd.placeHolder(text: "Password*".localized, textfieldname: txtPwd)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                txtPwd.errorFont = BrandenFont.thin(with: 12.0)
                txtPwd.floatPlaceholderFont = BrandenFont.thin(with: 12.0)
                txtPwd.font = BrandenFont.thin(with: 16.0)
            }else{
                txtPwd.errorFont = UIFont(name: "Cairo-Light", size: 12)!
                txtPwd.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 12)!
                txtPwd.font = UIFont(name: "Cairo-Light", size: 16)
            }

            txtPwd.delegate = self
        }
    }
    
    var strEmail = ""
    var reseToken = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPwd.addTarget(self, action: #selector(onClickText(_:)), for: .editingChanged)
                   txtConfirmPwd.addTarget(self, action: #selector(didEndText(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func onClickText(_ sender:RMTextField){
        sender.dtLayer.backgroundColor = UIColor(hexString: "FAFAFA").cgColor
        self.onCLickCheckpassword()
    }
    
    @objc func didEndText(_ sender:RMTextField){
        sender.dtLayer.backgroundColor = UIColor.white.cgColor
        self.onClickConfirmPassword()
    }
    @IBAction func onClickClose(_ sender: Any) {
        
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickChangePWD(_ sender: Any) {
        self.view.endEditing(true)
        
        
        
        if isValidated(){
            callChangePWD()
        }
    }
    
    func callChangePWD(){
        MBProgressHUD.showAdded(to: view, animated: true)
         let emailStr:String = UserDefaults.standard.value(forKey: "userEmail") as! String
         let tokenStr:String = UserDefaults.standard.value(forKey: "userTokenforchangePassword") as! String
        let params = [
            "email" : emailStr,
            "newPassword" : txtConfirmPwd.text!,
            "resetToken" : tokenStr,
            "websiteid": getWebsiteId()
            ] as [String : Any] as [String : Any]
        let storeCode:String = UserDefaults.standard.value(forKey: "storecode") as! String
        print("Print Params \(params)")
        let url = getWebsiteBaseUrl(with: "rest")  + getM2StoreCode() + "/" + CommonUsed.globalUsed.changePasword
        ApiManager.apiPost(url: url, params: params) { (response, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
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
                if response?.stringValue == "true" {
                    
                    let popupController = STPopupController.init(rootViewController: PwdSuccessVC.storyboardInstance!)
                    popupController.style = .bottomSheet
                    popupController.present(in: self)
                    popupController.hidesCloseButton = true
                    popupController.setNavigationBarHidden(true, animated: true)
                }else{
                    
                    
                    self.alert(title: "Error".localized, message: response?.dictionaryValue["message"]?.stringValue ?? "")
                }
                
            }
        }
    }
    @IBAction func onClickShow(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                txtPwd.isSecureTextEntry = true
            }else{
                sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                txtPwd.isSecureTextEntry = false
            }
        }else{
            if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                txtConfirmPwd.isSecureTextEntry = true
            }else{
                sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                txtConfirmPwd.isSecureTextEntry = false
            }
        }
    }
    
    
    func isValidated() -> Bool {
        
        var ErrorMsg = ""
        
        if (txtPwd.text?.isEmpty)! {
            txtPwd.showError(message: "Please enter current password".localized)
            ErrorMsg = txtPwd.errorMessage
            txtPwd.borderColor = .red
            txtConfirmPwd.borderColor = .black
            btnErPwd.isHidden = false
            btnErConfirmPwd.isHidden = true
            txtPwd.placeholderColor = .red
            txtConfirmPwd.placeholderColor = UIColor(hexString: "#474747")
        }
        else if (txtConfirmPwd.text?.isEmpty)! {
            txtConfirmPwd.showError(message: "Please enter confirm password".localized)
            ErrorMsg = txtConfirmPwd.errorMessage
            txtConfirmPwd.borderColor = .red
            txtPwd.backgroundColor = .black
            btnErConfirmPwd.isHidden = false
            btnErPwd.isHidden = true
            txtConfirmPwd.placeholderColor = .red
            txtPwd.placeholderColor = UIColor(hexString: "#474747")
        }
            
        else if txtConfirmPwd.text! != txtPwd.text! {
            txtConfirmPwd.showError(message: "new password and confirm password not match!".localized)
            ErrorMsg = txtConfirmPwd.errorMessage
            txtConfirmPwd.borderColor = .red
            txtPwd.borderColor = .black
            btnErConfirmPwd.isHidden = false
            btnErPwd.isHidden = true
            txtConfirmPwd.placeholderColor = .red
            txtPwd.placeholderColor = UIColor(hexString: "#474747")
            
        }
        
        if ErrorMsg != "" {
            
            
            return false
        }
        else {
            txtPwd.borderColor = .black
            txtConfirmPwd.borderColor = .black
            btnErPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
            btnErConfirmPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
            return true
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ChangePasswordVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPwd{
            let characterCountLimit = 999
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            self.lblPwdCount.text = "\(newLength)/20"
            
            if textField.text?.count == 1{
                txtPwd.borderColor = .black
                btnErPwd.isHidden = true
                txtPwd.placeholderColor  = UIColor(hexString: "#474747")
            }else{
                txtPwd.borderColor = .black
                btnErPwd.isHidden = false
                btnErPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
                txtPwd.placeholderColor = UIColor(hexString: "#474747")
            }
            return newLength <= characterCountLimit
            
        }else if textField == txtConfirmPwd{
            let characterCountLimit = 999
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            self.lblConfirmCount.text = "\(newLength)/20"
            
            if textField.text != txtPwd.text || textField.text!.count < 1{
                txtConfirmPwd.borderColor = .red
                btnErConfirmPwd.isHidden = false
                btnErConfirmPwd.setImage(#imageLiteral(resourceName: "icn_error"), for: .normal)
                txtConfirmPwd.placeholderColor = .red
            }else if textField.text!.count == 1 {
                txtConfirmPwd.borderColor = .black
                btnErConfirmPwd.isHidden = true
                txtConfirmPwd.placeholderColor = UIColor(hexString: "#474747")
            }
            else{
                txtConfirmPwd.borderColor = .black
                btnErConfirmPwd.isHidden = false
                btnErConfirmPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
                txtConfirmPwd.placeholderColor = UIColor(hexString: "#474747")
            }
            return newLength <= characterCountLimit
        }else{
            return true
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtConfirmPwd{
            if textField.text != txtPwd.text || textField.text!.count < 1 {
                txtConfirmPwd.borderColor = .red
                btnErConfirmPwd.isHidden = false
                btnErConfirmPwd.setImage(#imageLiteral(resourceName: "icn_error"), for: .normal)
                txtConfirmPwd.placeholderColor = .red
            } else if textField.text!.count == 1{
                    txtConfirmPwd.borderColor = .black
                    btnErConfirmPwd.isHidden = true
                    txtConfirmPwd.placeholderColor = UIColor(hexString: "#474747")
            }else{
                txtConfirmPwd.borderColor = .black
                btnErConfirmPwd.isHidden = false
                btnErConfirmPwd.setImage(#imageLiteral(resourceName: "Successnew"), for: .normal)
                txtConfirmPwd.placeholderColor = UIColor(hexString: "#474747")
            }
        }
    }
}

extension ChangePasswordVC:NoInternetDelgate{
    func didCancel() {
        self.callChangePWD()
    }
}
