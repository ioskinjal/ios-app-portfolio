//
//  ChangePasswordViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 24/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import MaterialComponents
class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    
    enum FormError: Error {
        case emptyOtpField
        case OtpFieldMaxLimit
        case emptyNewPasswordField
        case newPasswordFieldMaxLimit
        case emptyConfirmPasswordField
        case confirmPasswordFieldMaxLimit
        case NewAndConfirmPasswordFieldsNotSame
        case confirmPasswordWithSpaces
        case newPasswordWithSpaces
        case oldPasswordWithSpaces
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var resetPwdHeaderLbl2: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var resetPwdHeaderLbl1: UILabel!
    @IBOutlet weak var oldPassword: MDCTextField!
    @IBOutlet weak var newPasswordTF: MDCTextField!
    @IBOutlet weak var confirmPasswordTF: MDCTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var currentPwdShowBtn: UIButton!
    
    @IBOutlet weak var confirmNewPwdShwBtn: UIButton!
    @IBOutlet weak var newPwdShowBtn: UIButton!
    var email :String?
    var mobile : String?
    var currentPasswordController: MDCTextInputControllerOutlined?
    var newPasswordController: MDCTextInputControllerOutlined?
    var confirmPasswordController: MDCTextInputControllerOutlined?
    // MARK: - View Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.oldPassword.attributedPlaceholder = NSAttributedString(string: "Current Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        self.newPasswordTF.attributedPlaceholder = NSAttributedString(string: "New Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        
        self.confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: "Confirm Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        
        self.oldPassword.returnKeyType = .next
        self.newPasswordTF.returnKeyType = .next
        self.confirmPasswordTF.returnKeyType = .go
        oldPassword.font = UIFont.ottRegularFont(withSize: 14)
        newPasswordTF.font = UIFont.ottRegularFont(withSize: 14)
        confirmPasswordTF.font = UIFont.ottRegularFont(withSize: 14)
        self.oldPassword.delegate = self
        self.newPasswordTF.delegate = self
        self.confirmPasswordTF.delegate = self

        self.resetPwdHeaderLbl1.text = "Change Password".localized
        self.submitButton.setTitle("Save".localized, for: UIControl.State.normal)
        self.currentPwdShowBtn.setTitle("Show".localized, for: .normal)
        self.newPwdShowBtn.setTitle("Show".localized, for: .normal)
        self.confirmNewPwdShwBtn.setTitle("Show".localized, for: .normal)
        
        self.submitButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)

        self.resetPwdHeaderLbl1.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        self.oldPassword.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.newPasswordTF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.confirmPasswordTF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.currentPwdShowBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6), for: .normal)
        self.newPwdShowBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6), for: .normal)
        self.confirmNewPwdShwBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6), for: .normal)
        
        self.submitButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.submitButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        setupUI()
        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        currentPasswordController = MDCTextInputControllerOutlined(textInput: oldPassword)
        currentPasswordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        currentPasswordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        currentPasswordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        currentPasswordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        oldPassword.center = .zero
        oldPassword.clearButtonMode = .never
        
        newPasswordController = MDCTextInputControllerOutlined(textInput: newPasswordTF)
        newPasswordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newPasswordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newPasswordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newPasswordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newPasswordTF.center = .zero
        newPasswordTF.clearButtonMode = .never
        
        confirmPasswordController = MDCTextInputControllerOutlined(textInput: confirmPasswordTF)
        confirmPasswordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordTF.center = .zero
        confirmPasswordTF.clearButtonMode = .never
    }
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Custom Actions
    
    @IBAction func BackAction(_ sender: Any) {
        self.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        do {
            _ =  try checkResetPasswordFormErrors()
            self.startAnimating(allowInteraction: false)
            self.oldPassword.resignFirstResponder()
            self.newPasswordTF.resignFirstResponder()
            self.confirmPasswordTF.resignFirstResponder()
            OTTSdk.userManager.changePassword(oldPassword: oldPassword.text!, newPassword: newPasswordTF.text!,onSuccess: { (response) in
                self.stopAnimating()
                self.showAlertWithText(String.getAppName(), message: response,Action: true)
            }, onFailure: { (error) in
                print(error)
                self.showAlertWithText(String.getAppName(), message: error.message,Action: false)
                self.stopAnimating()
            })
        } catch FormError.emptyOtpField {
            
            let message = "Please Enter Code".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }catch FormError.OtpFieldMaxLimit {
            
            let message = "Password length should be between 4-50 characters".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.emptyNewPasswordField {
            
            let message = "Please enter your password".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.newPasswordFieldMaxLimit {
            
            let message = "New password length should be between 4-50 characters".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.emptyConfirmPasswordField {
            
            let message = "Please Enter Confirm Password".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.confirmPasswordFieldMaxLimit {
            
            let message = "Confirm password length should be between 4-50 characters".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.NewAndConfirmPasswordFieldsNotSame {
            
            let message = "New and Confirm Passwords Should be same".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.newPasswordWithSpaces {
            
            let message = "New Password should not contain spaces".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.confirmPasswordWithSpaces {
            
            let message = "Confirm Password should not contain spaces".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.oldPasswordWithSpaces {
            
            let message = "Current Password should not contain spaces".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch{
            let message = "Invalid details".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        
    }
    func checkResetPasswordFormErrors() throws -> Bool{
        if oldPassword.text?.isEmpty == true {
            
            throw FormError.emptyOtpField
        }
        let string2 = self.oldPassword.text!
        if Int((string2 as NSString).range(of: " ").location) != NSNotFound {
            throw FormError.oldPasswordWithSpaces
        }
        else  if !textFieldShouldReturn(self.oldPassword, minLen: 4, maxLen: 16) {
            throw FormError.OtpFieldMaxLimit
        }
        else if newPasswordTF.text?.isEmpty == true{
            throw FormError.emptyNewPasswordField
        }
        let string = self.newPasswordTF.text!
        if Int((string as NSString).range(of: " ").location) != NSNotFound {
            throw FormError.newPasswordWithSpaces
        }
        else if !textFieldShouldReturn(self.newPasswordTF, minLen: 4, maxLen: 16) {
            throw FormError.newPasswordFieldMaxLimit
        }
        else if confirmPasswordTF.text?.isEmpty == true{
            // valid phone number.. so return true and don't throw any error.
            throw FormError.emptyConfirmPasswordField
        }
        let string1 = self.confirmPasswordTF.text!
        if Int((string1 as NSString).range(of: " ").location) != NSNotFound {
            throw FormError.confirmPasswordWithSpaces
        }
        else if !textFieldShouldReturn(self.confirmPasswordTF, minLen: 4, maxLen: 16) {
            throw FormError.confirmPasswordFieldMaxLimit
        }
        else{
            // invalid phone number
            if newPasswordTF.text  != confirmPasswordTF.text{
                // valid email.. so return false and don't throw any error.
                
                throw FormError.NewAndConfirmPasswordFieldsNotSame
            }
            else{
                return true
            }
        }
    }
    
    @IBAction func showHidePasswordText(_ sender: UIButton) {
        if sender.tag == 1 {
            if (oldPassword.text?.count)! > 0 {
                if oldPassword.isSecureTextEntry {
                    oldPassword.isSecureTextEntry = false
                    sender.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    oldPassword.isSecureTextEntry = true
                    sender.setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
        }
        else if sender.tag == 2 {
            if (newPasswordTF.text?.count)! > 0 {
                if newPasswordTF.isSecureTextEntry {
                    newPasswordTF.isSecureTextEntry = false
                    sender.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    newPasswordTF.isSecureTextEntry = true
                    sender.setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
        }
        else if sender.tag == 3 {
            if (confirmPasswordTF.text?.count)! > 0 {
                if confirmPasswordTF.isSecureTextEntry {
                    confirmPasswordTF.isSecureTextEntry = false
                    sender.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    confirmPasswordTF.isSecureTextEntry = true
                    sender.setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
        }
    }
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String,Action:Bool) {
        errorAlert(forTitle: header, message: message, needAction: Action) { (flag) in
            if flag {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    // MARK: -  textfield delegates
    func textFieldShouldReturn(_ textField: UITextField, minLen:Int, maxLen:Int) -> Bool {
        let inte: Int = (textField.text?.count)!
        if inte<=maxLen && inte>=minLen {
            return true
        }
        else {
            return false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        let inte: Int = newString.length
        if inte<=16 {
            return true
        }
        else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.oldPassword {
            self.newPasswordTF.becomeFirstResponder()
        }
        if textField == self.newPasswordTF {
            self.confirmPasswordTF.becomeFirstResponder()
        }
        if textField == self.confirmPasswordTF {
            self.confirmPasswordTF.resignFirstResponder()
            self.SubmitAction(self.submitButton!)
            
        }
        return true
    }
    
}
