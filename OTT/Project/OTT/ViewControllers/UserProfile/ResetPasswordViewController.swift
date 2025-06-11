//
//  ResetPasswordVC.swift
//  sampleColView
//
//  Created by Ankoos on 15/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
class ResetPasswordViewController: UIViewController,UITextFieldDelegate {

    enum FormError: Error {
        case emptyOtpField
        case OtpFieldMaxLimit
        case emptyNewPasswordField
        case newPasswordFieldMaxLimit
        case newPasswordWithSpaces
        case emptyConfirmPasswordField
        case confirmPasswordFieldMaxLimit
        case confirmPasswordWithSpaces
        case NewAndConfirmPasswordFieldsNotSame
        case EnterValidOTP
    }
    
    
     // MARK: - Outlets
    
    
    @IBOutlet weak var resetPwdHeaderLbl2: UILabel!
    
    @IBOutlet weak var resetPwdHeaderLbl3: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var resetPwdHeaderLbl1: UILabel!
    @IBOutlet weak var newPasswordTF: FloatLabelTextField!
    @IBOutlet weak var confirmPasswordTF: FloatLabelTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var confirmPwdShowBtn: UIButton!
    @IBOutlet weak var newPwdShowBtn: UIButton!
    var email :String?
    var mobile : String?
    var viewControllerName = ""
    
    var referenceID = 0
    var countdown=0
    var myTimer: Timer? = nil
    var maxOTPTime = 60
    var resentOtpCount = 0
    var otpField = 0

     // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maxOTPTime = AppDelegate.getDelegate().enableOTPBtnTime
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
//        self.view.backgroundColor = UIColor.appBackgroundColor
        self.resetPwdHeaderLbl1.text = "Reset Password".localized
        self.resetPwdHeaderLbl2.text = "Once you reset your password, you will automatically sign in.".localized
        
        self.resetPwdHeaderLbl3.text = "Reset Password".localized
        self.submitButton.setTitle("RESET & SIGN IN".localized, for: .normal)
        self.newPwdShowBtn.setTitle("Show".localized, for: .normal)
        self.confirmPwdShowBtn.setTitle("Show".localized, for: .normal)
        self.submitButton.backgroundColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        self.newPasswordTF.attributedPlaceholder = NSAttributedString(string: "New Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        
        self.confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: "Confirm Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        
        self.newPasswordTF.returnKeyType = .next
        self.confirmPasswordTF.returnKeyType = .go

        self.newPasswordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        
        self.newPasswordTF.titleTextColour = AppTheme.instance.currentTheme.cardSubtitleColor
        self.newPasswordTF.titleActiveTextColour = AppTheme.instance.currentTheme.cardTitleColor
        
        
        self.confirmPasswordTF.titleTextColour = AppTheme.instance.currentTheme.cardSubtitleColor
        self.confirmPasswordTF.titleActiveTextColour = AppTheme.instance.currentTheme.cardTitleColor
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)

        self.resetPwdHeaderLbl1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.resetPwdHeaderLbl2.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6)
        self.resetPwdHeaderLbl3.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.newPasswordTF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.confirmPasswordTF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.submitButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.submitButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        self.newPwdShowBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6), for: .normal)
        self.confirmPwdShowBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.6), for: .normal)
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
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentScrollView.contentSize = CGSize.init(width: contentScrollView.contentSize.width, height: contentScrollView.frame.size.height + 170)
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startOTPResendTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        countdown = maxOTPTime
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if myTimer != nil {
            myTimer!.invalidate()
            myTimer = nil
        }
        countdown = maxOTPTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: -  getOTPForMobile API
    @IBAction func ResendOTPButtonClicked(_ sender: Any) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if self.resentOtpCount <= AppDelegate.getDelegate().resendOtpLimit {
            self.resentOtpCount = self.resentOtpCount + 1
            self.resendOtp()
        } else {
            self.showAlertWithText(message: "You have reached a Maximum Limit. Please try again after some time".localized, Action: false)
        }
    }
    
    func resendOtp() {
        if mobile == nil && email != nil {
            mobile = email
        }
        if mobile != "" {
            
            self.startAnimating(allowInteraction: false)
            
            mobile = mobile?.replacingOccurrences(of: "-", with: "")
            
            if checkContainsCharacters(inputStr: mobile ?? "") {
                
                OTTSdk.userManager.getOTP(mobile: nil, email: mobile, context: .updatePassword, onSuccess: { (response) in
                    Log(message: "\(response)")
                    self.stopAnimating()
                    self.referenceID = response.referenceId
                    self.showAlertWithText(String.getAppName(), message: response.message, Action: false)
                    self.startOTPResendTimer()
                }, onFailure: { (error) in
                    self.resentOtpCount = 0
                    Log(message: error.message)
                    self.stopAnimating()
                    let message:String = error.message
                    self.showAlertWithText(String.getAppName(), message: message, Action: false)
                })
            }
            else {
                mobile = mobile?.replacingOccurrences(of: "-", with: "")
                
                OTTSdk.userManager.getOTP(mobile: mobile, email: nil, context: .updatePassword, onSuccess: { (response) in
                    Log(message: "\(response)")
                    self.stopAnimating()
                    self.referenceID = response.referenceId
                    self.showAlertWithText(String.getAppName(), message: response.message, Action: false)
                    self.startOTPResendTimer()
                }, onFailure: { (error) in
                    self.resentOtpCount = 0
                    Log(message: error.message)
                    self.stopAnimating()
                    let message:String = error.message
                    self.showAlertWithText(String.getAppName(), message: message, Action: false)
                })
            }
        }
    }
    
    // MARK: -  custom Method
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }
    
    func startOTPResendTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ResetPasswordViewController.otpCountDownTick), userInfo: nil, repeats: true)
    }
    @objc func otpCountDownTick() {
        countdown -= 1
        if (countdown == 0) {
            if myTimer != nil {
                myTimer!.invalidate()
            }
            myTimer = nil
            countdown = maxOTPTime
            return
        }
        var countDownStr = String()
        if countdown < 10 && countdown > 0 {
            countDownStr = String(format: "%@%d%@", "Resend in (00:0", countdown,")")
        }
        else if countdown > 0{
            countDownStr = String(format: "%@%d%@", "Resend in (00:", countdown,")")
        } else {
            countDownStr = String(format: "%@%d%@", "Resend in (00:", self.maxOTPTime,")")
        }
    }
    @IBAction func BackAction(_ sender: Any) {
        self.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        do {
            _ =  try checkResetPasswordFormErrors()
        
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }

       self.startAnimating(allowInteraction: false)
            
            OTTSdk.userManager.updatePassword(email: email, mobile: mobile, password: newPasswordTF.text!, otp: self.otpField, onSuccess: { (response) in
                self.stopAnimating()
                self.showAlertWithText(String.getAppName(), message: response,Action: true)
            }, onFailure: { (error) in
                Log(message: "\(error)")
                self.showAlertWithText(String.getAppName(), message: error.message,Action: false)
                self.stopAnimating()
            })
        } catch FormError.emptyOtpField {
            
            let message = "Please Enter Your OTP".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }catch FormError.OtpFieldMaxLimit {
            
            let message = "Code length should be between 4-6 characters".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.EnterValidOTP{
            let message = "OTP Field should contain only numbers".localized
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
            
            let message = "Please enter Confirm password".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.confirmPasswordFieldMaxLimit {
            
            let message = "Confirm password length should be between 4-50 characters".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }
        catch FormError.NewAndConfirmPasswordFieldsNotSame {
            
            let message = "Password mismatch".localized
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
        catch{
            let message = "Invalid details".localized
            self.showAlertWithText(String.getAppName(), message: message,Action: false)
        }

    }
    func checkResetPasswordFormErrors() throws -> Bool{
        if newPasswordTF.text?.isEmpty == true{
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
        else if sender.tag == 2 {
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
            if flag == false {
                return
            }
            self.startAnimating(allowInteraction: true)
            //OTTSdk.userManager.signInWithEncryption(loginId:...
            let login = self.mobile ?? self.email
            OTTSdk.userManager.signInWithPassword(loginId: login ?? "", password: self.newPasswordTF.text!, appVersion: Bundle.applicationVersionNumber, isHeaderEnrichment: false, onSuccess: {(response, actionCode)  in
                AppAnalytics.shared.updateUser()
                LocalyticsEvent.tagEventWithAttributes("Sign_in_Success", ["User_Type":""])
                LocalyticsEvent.pushProfileOnLogin()
                self.stopAnimating()
                let userAttributes = OTTSdk.preferenceManager.user?.attributes
                AppDelegate.getDelegate().userStateChanged = true
                if !(userAttributes?.timezone .isEmpty)! && (userAttributes?.timezone)! != "false"{
                    NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
                }
                if !(userAttributes?.displayLanguage .isEmpty)! {
                    OTTSdk.preferenceManager.selectedDisplayLanguage = (userAttributes?.displayLanguage)!
                    Localization.instance.updateLocalization()
                    // config nill to get menu in selected language
                    ConfigResponse.StoredConfig.lastUpdated = nil
                    ConfigResponse.StoredConfig.response = nil
                }
                if self.viewControllerName != "PlayerVC" {
                    if  playerVC != nil{
                        playerVC?.expandViews(isInitialSetUp: true)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                }
                AppDelegate.getDelegate().loadHomePage(toFristViewController: true)
            }, onFailure: { (error) in
                self.showAlertWithText(message: error.message, Action: false)
            })
            AppDelegate.getDelegate().loadHomePage(toFristViewController: true)
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
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        let inte: Int = newString.length
        if inte<=16 {
            return true
        }
        else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.newPasswordTF {
            self.confirmPasswordTF.becomeFirstResponder()
        }
        if textField == self.confirmPasswordTF {
            self.confirmPasswordTF.resignFirstResponder()
            self.SubmitAction(self.submitButton!)
            
        }
        return true
    }
    func checkContainsCharacters(inputStr:String) -> Bool {
        
        let charStatusArr = NSMutableArray()
        
        
        for chr in inputStr{
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                charStatusArr.add(NSNumber.init(value: false))
            }
            else {
                charStatusArr.add(NSNumber.init(value: true))
            }
        }
        if charStatusArr.contains(NSNumber.init(value: true)) {
            return true
        }
        else {
            return false
        }
    }
}
