//
//  ForgotVC.swift
//  YUPPTV
//
//  Created by Ankoos on 26/10/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import MaterialComponents

class ForgotViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,CountySelectionProtocol {
    
    enum ForgotFormError: Error {
        case emptyEmailField
        case emailFieldFieldMaxLimit
        case notValidEmail
        case emptyMobileNumberField
        case mobileNumberMaxLimit
        case notValidMobileNumber
        case notValidCountryCode
    }
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var forgotPwdHeaderLbl: UILabel!
    @IBOutlet weak var forgotPwdHeaderLbl2: UILabel!
    @IBOutlet weak var forgotPwdHeaderLbl1: UILabel!
    @IBOutlet weak var emailTF: MDCTextField!
    @IBOutlet weak var sendlinkButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var countyCodeView: UIView!
//    @IBOutlet weak var countryCodeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contryFlagimgView : UIImageView!
    @IBOutlet weak var countryDropDownimgView : UIImageView!
    @IBOutlet weak var countryCodeLbl : UILabel!
    @IBOutlet var appLogoImageWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var countryViewWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var mobileNumberLeftConstraint : NSLayoutConstraint!
    @IBOutlet var tryWithEmailButton : UIButton!
    @IBOutlet weak var buttonsStackView : UIStackView!
    @IBOutlet weak var appLogoLeft: NSLayoutConstraint!
//    var countryCodeContainer = UIView()
    var emailImgContainer = UIView()
//    var contryFlagimgView = UIImageView()
//    var countryCodeLbl = UILabel()
//    var countryCodeContainerWidth = CGFloat()
    var countryCodeTap : UITapGestureRecognizer!
    var countriesInfoArray = [Country]()
    var viewControllerName = ""
    var mobileController: MDCTextInputControllerOutlined?
    var isEmailID = false
    var isFromForgotPin = false
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .firstshows {
            appLogoImageWidthConstraint.isActive = false
        }
        if appContants.appName == .gac {
            appLogoLeft.constant = (self.view.frame.width - appLogoImageWidthConstraint.constant)/2
        }
        tryWithEmailButton.isHidden = true
        tryWithEmailButton.cornerDesignWithoutBorder()
        tryWithEmailButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        tryWithEmailButton.setTitle("Try with email address", for: .normal)
        if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gac {
            tryWithEmailButton.removeFromSuperview()
            buttonsStackView.removeArrangedSubview(tryWithEmailButton)
        }
        countyCodeView.viewBorderWidthWithTwo(color: AppTheme.instance.currentTheme.textFieldBorderColor, isWidthOne: true)
        countyCodeView.backgroundColor = .clear
        
        mobileController = MDCTextInputControllerOutlined(textInput: emailTF)
        
        mobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
//        mobileController?.textInput?.textColor = .lightGray
        emailTF.center = .zero
        emailTF.clearButtonMode = .never
        
//        countyCodeView.layer.cornerRadius = 6
//        countyCodeView.layer.borderWidth = 1
//        countyCodeView.layer.borderColor = UIColor.lightGray.cgColor
//        countyCodeView.backgroundColor = .clear
//        countryCodeViewWidthConstraint.constant = 90
        
//        self.emailTF.leftView = countyCodeView
//        self.emailTF.leftViewMode = UITextField.ViewMode.always
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        countryCodeLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        countryDropDownimgView.image = #imageLiteral(resourceName: "country_dropdown_icon").withRenderingMode(.alwaysTemplate)
        countryDropDownimgView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        if appContants.appName == .aastha {
            navigationView.isHidden = false
        }
//        self.navigationView.cornerDesign()
        //        self.view.backgroundColor = UIColor.appBackgroundColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.forgotPwdHeaderLbl1.text = "Forgot Password".localized
        self.forgotPwdHeaderLbl2.text = "Forgot your password?".localized
        self.forgotPwdHeaderLbl.text = "Please enter your mobile number and will send you an OTP to reset password.".localized
        forgotPwdHeaderLbl.font = UIFont.ottRegularFont(withSize: 12)
        forgotPwdHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.45)
        self.sendlinkButton.setTitle("Submit".localized, for: UIControl.State.normal)
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "\("Mobile Number".localized)", attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        self.emailTF.returnKeyType = .go
        if let fields = AppDelegate.otpAuthenticationFields, fields.forgot_password_identifier_type == "email" {
            self.emailTF.keyboardType = .emailAddress
            self.forgotPwdHeaderLbl.text = "Please enter your email address and we will send you a one-time passcode to reset your password.".localized
            self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email ID".localized)
            countryViewWidthConstraint.constant = 0.0
            mobileNumberLeftConstraint.constant = 0.0
            countyCodeView.isHidden = true
        }else if let fields = AppDelegate.otpAuthenticationFields,  fields.forgot_password_identifier_type == "mobile" || fields.forgot_password_identifier_type == "phone" {
            self.emailTF.keyboardType = .phonePad
        }
        else{
            if appContants.appName == .reeldrama {
                self.emailTF.keyboardType = .emailAddress
                self.forgotPwdHeaderLbl.text = "Please enter your email address and we will send you a one-time passcode to reset your password.".localized
                self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email ID".localized)
                countryViewWidthConstraint.constant = 0.0
                mobileNumberLeftConstraint.constant = 0.0
                countyCodeView.isHidden = true
            }else {
                self.emailTF.keyboardType = .phonePad
            }
        }

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)
        
//        self.countryCodeContainerWidth = 60
        self.sendlinkButton.backgroundColor = UIColor.getButtonsBackgroundColor()
//        self.emailImgContainer = UIView(frame: CGRect(x: 0, y: 12, width: 50, height: 30.0))
        
//        self.countryCodeContainer = UIView(frame: CGRect(x: countyCodeView.frame.origin.x/2 + 15.0, y: 14.0, width: 80, height: 30.0))
//        self.countryCodeContainer.isHidden = true
//        self.countryCodeContainer.backgroundColor = .clear
        
        countryCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.showCountriesInfoPopUp(_:)))
        countryCodeTap.delegate = self
//        self.countryCodeContainer.addGestureRecognizer(countryCodeTap)
        self.countyCodeView.addGestureRecognizer(countryCodeTap)

//        self.contryFlagimgView = UIImageView(frame: CGRect(x: 2.0, y: 8.0, width: 15, height: 15))
        
//        self.countryCodeLbl = UILabel(frame: CGRect(x: (contryFlagimgView.frame.origin.x+contryFlagimgView.frame.size.width) + 5.0, y: 0, width: self.countryCodeContainer.frame.size.width - (contryFlagimgView.frame.origin.x+contryFlagimgView.frame.size.width + 8), height: self.countryCodeContainer.frame.size.height))
//        countryCodeLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
//        countryCodeLbl.textAlignment = NSTextAlignment.left
//        if #available(iOS 8.2, *) {
//            countryCodeLbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
//        } else {
            countryCodeLbl.font = UIFont.ottRegularFont(withSize: 14)
//        }
        
//        let countryDropDownImView = UIImageView(frame: CGRect(x: countryCodeLbl.frame.origin.x + 40.0, y: 12, width: 7, height: 5))
//        countryDropDownImView.image = #imageLiteral(resourceName: "country_dropdown_icon")
//
//        countryCodeContainer.addSubview(contryFlagimgView)
//        countryCodeContainer.addSubview(countryCodeLbl)
//        countryCodeContainer.addSubview(countryDropDownImView)
//        emailImgContainer.addSubview(countryCodeContainer)
//        countyCodeView.addSubview(emailImgContainer)
        
        
        //        emailTF.returnKeyType = .go
        //        emailTF.leftView = emailImgContainer
        //        emailTF.leftViewMode = UITextField.ViewMode.always
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
//        self.countryCodeContainer.isHidden = false
//        self.countryCodeContainerWidth = self.countryCodeContainer.frame.size.width
//        self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
        if AppDelegate.getDelegate().countriesInfoArray.count == 0 {
            AppDelegate.getDelegate().getMyCountiesList(isUpdated: true) {
                self.updateData()
            }
        }else {
            updateData()
        }
        self.forgotPwdHeaderLbl1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.forgotPwdHeaderLbl2.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.forgotPwdHeaderLbl.font = UIFont.ottRegularFont(withSize: 12)
        self.forgotPwdHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.45)
        self.emailTF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.sendlinkButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.sendlinkButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        self.sendlinkButton.cornerDesignWithoutBorder()
        self.cancelButton.backgroundColor = .clear
        if appContants.appName == .gac {
            self.cancelButton .setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        }
        else {
            self.cancelButton .setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)

        }
        if isFromForgotPin {
            self.cancelButton.setTitle("Cancel".localized, for: .normal)
        }else {
            self.cancelButton.setTitle("Back to Sign in".localized, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    private func updateData() {
        self.countriesInfoArray = AppDelegate.getDelegate().countriesInfoArray
        let predicate = NSPredicate(format: "code == %@", AppDelegate.getDelegate().countryCode)
        
        let filteredarr = self.countriesInfoArray.filter { predicate.evaluate(with: $0) };
        if filteredarr.count > 0{
            let dict = filteredarr[0]
            self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
        }
        else if self.countriesInfoArray.count > 0{
            let dict = self.countriesInfoArray[0]
            self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
        }
        if AppDelegate.getDelegate().headerEnrichmentNum.count > 10 {
            let headerEnrichNum = AppDelegate.getDelegate().headerEnrichmentNum
            let countryCodeIndex = headerEnrichNum.index(AppDelegate.getDelegate().headerEnrichmentNum.startIndex, offsetBy: 2)
            let countryCode = headerEnrichNum.substring(to: countryCodeIndex)
            let mobileNum = headerEnrichNum.substring(from: countryCodeIndex)
            let predicate = NSPredicate(format: "isdCode == %d", Int(countryCode)!)
            
            let filteredarr = self.countriesInfoArray.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let dict = filteredarr[0]
                self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
                self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
            } else {
                self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(countryCode)")
            }
            self.emailTF.text = mobileNum
        } else {
            self.emailTF.text = AppDelegate.getDelegate().headerEnrichmentNum
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Custom Actions
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }
    @IBAction func emailOrMobileAction(_ sender : UIButton) {
        emailTF.text = ""
        if (sender.titleLabel?.text?.lowercased().contains("email"))! {
            tryWithEmailButton.setTitle("Try with Mobile Number", for: .normal)
            sender.setTitle("Try with Mobile Number", for: .normal)
            isEmailID = true
            self.emailTF.keyboardType = .emailAddress
            self.forgotPwdHeaderLbl.text = "Please enter your email address and we will send you a one-time passcode to reset your password.".localized
            self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email ID".localized)
            countryViewWidthConstraint.constant = 0.0
            mobileNumberLeftConstraint.constant = 0.0
            countyCodeView.isHidden = true
        }else {
            tryWithEmailButton.setTitle("Try with Email ID", for: .normal)
            sender.setTitle("Try with Email ID", for: .normal)
            isEmailID = false
            self.emailTF.keyboardType = .phonePad
            self.forgotPwdHeaderLbl.text = "Please enter your mobile number and will send you an OTP to reset password.".localized
            self.emailTF.attributedPlaceholder = NSAttributedString(string: "Mobile Number".localized)
            countryViewWidthConstraint.constant = 100.0
            mobileNumberLeftConstraint.constant = 12.0
            countyCodeView.isHidden = false
        }
    }
    @IBAction func sendButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        var mobile : String? = nil
        var email : String? = nil
        self.emailTF.text = self.emailTF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if let _ = AppDelegate.otpAuthenticationFields {
            if AppDelegate.otpAuthenticationFields.forgot_password_identifier_type == "email" {
                email = self.emailTF.text!
                if email == "" {
                    self.showAlertWithText(String.getAppName(), message: "Please enter Email".localized)
                    return
                }
                else if !(self.isValidEmail(testStr: email ?? "")) {
                    self.showAlertWithText(String.getAppName(), message: "Please enter a valid Email Id".localized)
                    return
                }
            }else if AppDelegate.otpAuthenticationFields.forgot_password_identifier_type == "mobile" || AppDelegate.otpAuthenticationFields.forgot_password_identifier_type == "phone" {
                mobile = self.emailTF.text!
                if self.countryCodeLbl.text != nil {
                    mobile = String.init(format: "%@%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!,mobile!)
                }
                else {
                    mobile = String.init(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),mobile!)
                }
            }
        }
        else {
            if appContants.appName == .reeldrama || isEmailID {
                email = self.emailTF.text!
                if email == "" {
                    self.showAlertWithText(String.getAppName(), message: "Please enter Email".localized)
                    return
                }
                else if !(self.isValidEmail(testStr: email ?? "")) {
                    self.showAlertWithText(String.getAppName(), message: "Please enter a valid Email Id".localized)
                    return
                }
            }else {
                mobile = self.emailTF.text!
                if self.countryCodeLbl.text != nil {
                    mobile = String.init(format: "%@%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!,mobile!)
                }
                else {
                    mobile = String.init(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),mobile!)
                }
            }
        }
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)

        
        //let trimmedString = self.emailTF.text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
//        if checkContainsCharacters(inputStr: trimmedString as String) || trimmedString.length == 0 {
            //Email
            do {
                let status =  try checkFPFormErrors()
                printLog(log: status as AnyObject)
                
                
                /* OTTSdk.userManager.getOTP(mobile: nil, email: email, context: .updatePassword, onSuccess: { (response) in
                    self.stopAnimating()
                    self.GotoResetView(messageStr: response.message,emailStr:email, mobileStr: nil, referenceId: response.referenceId)
                }, onFailure: { (error) in
                    self.stopAnimating()
                    Log(message: error.message)
                    self.showAlertWithText(String.getAppName(), message: error.message)
                }) */
                
                OTTSdk.userManager.getOTP(mobile: mobile, email: email, context: .updatePassword, onSuccess: { (response) in
                    self.stopAnimating()
                    self.GotoResetView(messageStr: response.message,emailStr:email, mobileStr: mobile, referenceId: response.referenceId, actionCode: response.statusCode, showOTPScreen: response.showOTPScreen)

                }, onFailure: { (error) in
                    self.stopAnimating()
                    Log(message: error.message)
                    self.showAlertWithText(String.getAppName(), message: error.message)
                })
                
            }
            catch ForgotFormError.emptyEmailField {
                self.stopAnimating()
                let message = "Please enter a valid Email Id".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
            catch ForgotFormError.emailFieldFieldMaxLimit
            {
                self.stopAnimating()
                let message = "Email ID length should be between 6-50 characters".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
            catch ForgotFormError.notValidEmail
            {
                self.stopAnimating()
                let message = "Please enter a valid Email Id".localized
                self.showAlertWithText(String.getAppName(), message: message)
                
            }
            catch ForgotFormError.emptyMobileNumberField {
                self.stopAnimating()
                let message = "Please enter Valid Number".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
            catch ForgotFormError.mobileNumberMaxLimit {
                self.stopAnimating()
                let message = "Please enter valid Number".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
            catch ForgotFormError.notValidMobileNumber {
                self.stopAnimating()
                let message = "Please enter valid Number".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
            catch ForgotFormError.notValidCountryCode {
                self.stopAnimating()
                let message = "Select your country code".localized
                self.showAlertWithText(String.getAppName(), message: message)
            }
                
            catch{
                self.stopAnimating()
            }
        /*}
        else {
            //Mobile
            if !textFieldShouldReturn(self.emailTF, minLen: 7, maxLen: 15) {
                self.stopAnimating()
                self.showAlertWithText(String.getAppName(), message: "Please enter a valid Mobile Number".localized)
                return
            }

            if self.countryCodeLbl.text != nil {
                email = String.init(format: "%@%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!,email)
            }
            else {
                email = String.init(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),email)
            }
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            OTTSdk.userManager.getOTP(mobile: email, email: nil, context: .updatePassword, onSuccess: { (response) in
                self.stopAnimating()
                self.GotoResetView(messageStr: response.message,emailStr:email, mobileStr: email, referenceId: response.referenceId)
            }, onFailure: { (error) in
                self.stopAnimating()
                Log(message: error.message)
                self.showAlertWithText(String.getAppName(), message: error.message)
            })
        }*/
    }
    
    
    
    func GotoResetView(messageStr:String,emailStr:String?,mobileStr:String?, referenceId:Int,actionCode:Int, showOTPScreen: Bool) {
        errorAlert(forTitle: String.getAppName(), message: messageStr, needAction: true) { (flag) in
            if flag {
                if AppDelegate.getDelegate().configs != nil && AppDelegate.getDelegate().configs!.forgotPasswordViaWebportal == false {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
                let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                
                otpVC.identifier = emailStr ?? mobileStr
                otpVC.referenceID = referenceId
                otpVC.otpSent = true
                otpVC.isFromBackButton = false
                otpVC.actionCode = actionCode
                /*if let _ = AppDelegate.otpAuthenticationFields{
                    otpVC.identifierType = AppDelegate.otpAuthenticationFields.otp_verification_order
                }
                else {
                    otpVC.identifierType = ((emailStr != nil) ? "email" : "mobile")
                }*/
                if actionCode == 1 || actionCode == 2 {
                    otpVC.identifierType = "mobile"
                }
                else if actionCode == 3 || actionCode == 4 {
                    otpVC.identifierType =  "email"
                }
                else {
                    otpVC.identifierType = ((emailStr != nil) ? "email" : "mobile")
                }
                otpVC.viewControllerName = self.viewControllerName == "ProfileVC" ? "ProfileVC" : "VerifyMobileVC"
                otpVC.isFromForgotPwd = true
                otpVC.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(otpVC, animated: true)
                } else {
                    self.BackAction(UIButton())
                }
            }
        }
        
        /*
         let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
         resetVC.email = emailStr
         resetVC.mobile = mobileStr
         resetVC.viewControllerName = self.viewControllerName
         if self.viewControllerName == "PlayerVC" {
         let topVC = UIApplication.topVC()!
         topVC.navigationController?.pushViewController(resetVC, animated: true)
         } else {
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(resetVC, animated: true)
         }
         */
        //_ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func BackAction(_ sender: AnyObject) {
        self.stopAnimating()
        if viewControllerName == "PlayerVC" {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.isNavigationBarHidden = true
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    func checkFPFormErrors() throws -> Bool{
        if let _ = AppDelegate.otpAuthenticationFields {
            if AppDelegate.otpAuthenticationFields.forgot_password_identifier_type == "email" {
                return true
            }
        }
        else {
            if appContants.appName == .reeldrama || isEmailID {
                return true
            }
//            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        }
        var mobileRegEx = AppDelegate.getDelegate().mobileRegExp
          mobileRegEx = mobileRegEx.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
          let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        
        
        if emailTF.text?.isEmpty == true {
            throw ForgotFormError.emptyMobileNumberField
        }
        else if !textFieldShouldReturn(self.emailTF, minLen: 6, maxLen: 15) {
            throw ForgotFormError.mobileNumberMaxLimit
        }
        else if !(mobileRegEx.isEmpty) && mobileTest.evaluate(with: emailTF.text) == false{
           throw ForgotFormError.notValidMobileNumber
        }
        else if self.countryCodeLbl.text == nil {
            throw ForgotFormError.notValidCountryCode
        }
        else
        {
            //is valid email . so return true.
            // is valid mobile number
                return true
        }
        
    }
    @IBAction func keyboardRemove(_ sender: AnyObject) {
    }
    // MARK: - Custom methods
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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

    @objc func showCountriesInfoPopUp(_ sender: UITapGestureRecognizer? = nil) {
        
        self.view.endEditing(true)
        if self.countriesInfoArray.count > 0 {
            let popvc = CountriesInfoPopupViewController()
            popvc.countriesArray = self.countriesInfoArray
            popvc.delegate = self
            self.present(popvc, animated: true, completion: nil)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            
            self.emailTF.resignFirstResponder()
            self.sendButtonAction(self.sendlinkButton)
            
        }
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = AppDelegate.otpAuthenticationFields {
            if AppDelegate.otpAuthenticationFields.forgot_password_identifier_type == "email" {
                guard let text = textField.text else { return true }
                
                let newLength = text.count + string.count - range.length
                return newLength <= 50
            }
        }
        else {
            if appContants.appName == .reeldrama {
                return true
            }
        }
        if textField == self.emailTF, !isEmailID {
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            let final = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return final.count <= 15
            //var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            //newString = newString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
//            if checkContainsCharacters(inputStr: newString as String) {
//                return true
//            } else {
//                return true
//            }
//            else {
//                self.countryCodeContainer.isHidden = false
//                self.countryCodeContainerWidth = self.countryCodeContainer.frame.size.width
//                self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
//
//                let newLength = (textField.text?.count)! + string.count - range.length
//
//                if newLength <= 15 {
//                    textField.text = newString as String
//                    return false
//                }
//                else {
//                    return false
//                }
//            }
        } else {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 50 // Bool
            
        }
    }

    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
extension ForgotViewController{
    /**/
    func countrySelected(countryObj:Country) {
        self.contryFlagimgView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countryCodeLbl.text = String.init(format: "%@%@", "+", "\(countryObj.isdCode)")
    }
    
}

