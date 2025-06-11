//
//  ForgotPinVC.swift
//  OTT
//
//  Created by Apalya on 14/12/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//

import UIKit
import MaterialComponents
import OTTSdk

class ForgotPinVC: UIViewController {
    @IBOutlet weak var passwordTf : MDCTextField!
    @IBOutlet weak var navigationView :UIView!
    @IBOutlet weak var mainTitleLbl : UILabel!
    @IBOutlet weak var subTitleLbl : UILabel!
    @IBOutlet weak var signUpButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    private var passwordController: MDCTextInputControllerOutlined? = nil
    var cancelSelected : (()->Void)!
    var showPinView : ((ParentalPinResponse)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTf)
        setUpUI()
    }
    @IBAction func backAction(_ sender : UIButton) {
        if cancelSelected != nil {
            cancelSelected()
        }
        navigationController?.popViewController(animated: true)
    }
    private func setUpUI() {
        mainTitleLbl.text = "Forgot Your PIN ?".localized
        subTitleLbl.text = "Please enter your Account password to change After Dark PIN".localized
        mainTitleLbl.font = UIFont.ottMediumFont(withSize: 18)
        subTitleLbl.font = UIFont.ottRegularFont(withSize: 12)
        passwordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        passwordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.textInput?.clearButton.isHidden = true
        passwordTf?.center = .zero
        passwordTf?.clearButtonMode = .never
        
        signUpButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        signUpButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        signUpButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.layer.masksToBounds = true
        signUpButton.setTitle("Verify".localized, for: .normal)
        
        cancelButton.setTitle("Cancel".localized, for: .normal)
        cancelButton.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        cancelButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.masksToBounds = true
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        
        forgotPasswordBtn.setTitle("Forgot Password?".localized, for: .normal)
        forgotPasswordBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.8), for: .normal)
        forgotPasswordBtn.titleLabel?.font = UIFont.ottMediumFont(withSize: 12)
    }
    @IBAction func signInSignUpButtonAction(_ sender : Any) {
        guard let password = passwordTf.text?.trimmingCharacters(in: .whitespaces), password.count > 0 else {
            errorAlert(forTitle: String.getAppName(), message: "Password must not be empty and does not contain spaces".localized, needAction: false, reslt: { _ in})
            return
        }
        guard textFieldShouldReturn(passwordTf, minLen: 4, maxLen: 16) == true else {
            errorAlert(forTitle: String.getAppName(), message: "Password length should be between 4-50 characters".localized, needAction: false, reslt: { _ in})
            return
        }
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.authenticateUsreParentalControlerWith(password: password, context: .parentalcontrol, profileId: OTTSdk.preferenceManager.user!.profileId) { pin_response in
            self.stopAnimating()
            if self.showPinView != nil {
                self.showPinView(pin_response)
            }
            self.navigationController?.popViewController(animated: false)
        } onFailure: { error in
            self.stopAnimating()
            self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false, reslt: { _ in})
        }
    }
    @IBAction func ForgotButtonAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.isNavigationBarHidden = true
        nextViewController.viewControllerName = "SignInVC"
        nextViewController.isFromForgotPin = true
        if nextViewController.viewControllerName == "PlayerVC" {
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
extension ForgotPinVC : UITextFieldDelegate {
    // MARK: - textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField, minLen:Int, maxLen:Int) -> Bool {
        let inte: Int = (textField.text?.count)!
        if inte<=maxLen && inte>=minLen {
            return true
        }
        else {
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 50 // Bool
    }
}
