//
//  OTPVC.swift
//  YUPPTV
//
//  Created by Ankoos on 19/09/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import MaterialComponents


class OTPViewController: UIViewController,UIGestureRecognizerDelegate ,SuccessPopUpViewControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var navigationView: UIView!
    var identifier:String!
    var referenceId:String?
    var otpSent: Bool!
    var countdown=0
    var myTimer: Timer? = nil
    var maxOTPTime = 60
    var viewControllerName = ""
    var referenceID = 0
    var actionCode = -1
    var isSignInError:Bool = false
    var isSignUpError:Bool = false
    var isFromForgotPwd:Bool = false
    var identifierType:String = "mobile"
    var target = ""
    var targetType = ""
    var context = ""
    @IBOutlet weak var otpHeaderLabel: UILabel!
    @IBOutlet weak var otpSubHeaderLabel: UILabel!
    @IBOutlet weak var txtOTP1: MDCTextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var changeNumberBtn: UIButton!
    @IBOutlet var appLogoImageWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var backButtonHeightConstaint : NSLayoutConstraint!
    @IBOutlet weak var nagivationLbl : UILabel!
    @IBOutlet weak var AppIconLeft: NSLayoutConstraint!
    var isFromBackButton = false
    var isFromFaceBuk = false
    var isSubscribing: Bool!
    var isFromPlayer: Bool = false
    
    var accountDelegate : AccontDelegate?
    var targetVC : UIViewController?
    var resentOtpCount = 0

    var otpController: MDCTextInputControllerOutlined?
    
    
     // MARK: -  View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .firstshows {
            appLogoImageWidthConstraint.isActive = false
        }
        if appContants.appName == .gac {
            self.AppIconLeft.constant = (self.view.frame.width - appLogoImageWidthConstraint.constant)/2
        }
        if appContants.appName == .aastha || appContants.appName == .gac{
            nagivationLbl.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }else {
            nagivationLbl.backgroundColor = .clear
        }
        self.maxOTPTime = AppDelegate.getDelegate().enableOTPBtnTime
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
//        self.view.backgroundColor = UIColor.appBackgroundColor
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)
        backButton.isHidden = true
        backButtonHeightConstaint.constant = 0
        changeNumberBtn.isHidden = false
        if actionCode == 2 || actionCode == 4 {
            changeNumberBtn.isHidden = true
            backButton.isHidden = false
            backButtonHeightConstaint.constant = 44
        }
//        if OTTSdk.preferenceManager.user == nil {
//            LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification")
//        }
//        else {
//            LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>OTP verification")
//        }
        self.otpHeaderLabel.text = "Enter one-time passcode".localized
        self.otpSubHeaderLabel.text = self.statusLabelWithStars()
//        resendButton.cornerDesign()
        resendButton.backgroundColor = .clear
        verifyButton.viewCornerRadiusWithTwo()
        
        //self.resendButton.backgroundColor = UIColor.init(hexString: "232326")

        self.verifyButton.isEnabled = true
     
        //self.OtpTextF.attributedPlaceholder = NSAttributedString(string: "Enter OTP".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        //self.OtpTextF.becomeFirstResponder()

        self.verifyButton.setTitle("Verify".localized, for: UIControl.State.normal)
        self.resendButton.setTitle("Resend".localized, for: UIControl.State.normal)
        
        //self.OtpTextF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.otpHeaderLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.verifyButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.verifyButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        resendButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        //self.resendButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.verifyButton.isHidden = false
        // Do any additional setup after loading the view.
        setupTextField(txtOTP1)
        let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.ottRegularFont(withSize: 14),
        .foregroundColor : AppTheme.instance.currentTheme.changeMobileColor as Any,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
        if actionCode == 3 || actionCode == 4 {
            let attributeString = NSMutableAttributedString(string: "Change email address",
            attributes: attributes)
            changeNumberBtn.setAttributedTitle(attributeString, for: .normal)
        }else {
            let attributeString = NSMutableAttributedString(string: "Change Mobile Number",
            attributes: attributes)
            changeNumberBtn.setAttributedTitle(attributeString, for: .normal)
        }
//        setupTextField(txtOTP2)
//        setupTextField(txtOTP3)
//        setupTextField(txtOTP4)
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
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
    func statusLabelWithStars() -> String {
        if self.identifier != nil {
            let tempShowOtpSentText : String = target.count > 0 ? target : self.identifier
            if checkContainsCharacters(inputStr: tempShowOtpSentText) {
                var subStrings1 = [String]()
                if tempShowOtpSentText.contains("@") {
                    subStrings1 = tempShowOtpSentText.components(separatedBy: "@")
                }else {
                    subStrings1 = (OTTSdk.preferenceManager.user?.email ?? "").components(separatedBy: "@")
                }
                let emailStr = NSMutableString()
                if subStrings1.count > 0 {
                    for (index, str) in subStrings1[0].enumerated() {
                        if index > 1 {
                            emailStr.append("*")
                        }
                        else {
                            emailStr.append(str.description)
                        }
                    }
                    let subStrings2 = subStrings1[1].components(separatedBy: ".")
                    if subStrings2.count > 0 {
                        emailStr.append("@")
                        for (index, str) in subStrings2[0].enumerated() {
                            if index > 1 {
                                emailStr.append("*")
                            }
                            else {
                                emailStr.append(str.description)
                            }
                        }
                        for (index, str) in subStrings2.enumerated() {
                            if index > 0 {
                                emailStr.append(".")
                                for _ in str.enumerated() {
                                    emailStr.append("*")
                                }
                            }
                        }
                    }
                }
                return String.init(format: "%@%@%@", " A one-time passcode has been sent to\nyour email address".localized," ",emailStr)
            }
            else {
                if tempShowOtpSentText.contains("-") {
                    let strArr = tempShowOtpSentText.components(separatedBy: "-")
                    return String.init(format: "%@%@%@%@", "A one-time passcode has been sent to\nyour mobile ".localized,"+\(strArr[0])-","******",tempShowOtpSentText.substring(from:tempShowOtpSentText.index(tempShowOtpSentText.endIndex, offsetBy: -4)))
                } else if tempShowOtpSentText.count > 5{
                    return String.init(format: "%@%@%@", "A one-time passcode has been sent to\nyour mobile ".localized,"******",tempShowOtpSentText.substring(from:tempShowOtpSentText.index(tempShowOtpSentText.endIndex, offsetBy: -4)))
                } else {
                    return String.init(format: "%@%@%@", "A one-time passcode has been sent to\nyour mobile ".localized,"******","")
                }
                
            }
        }
        return ""
    }

    
    //Customisation and setting OTPTextFields
    func setupTextField(_ textField: MDCTextField){
        
        otpController = MDCTextInputControllerOutlined(textInput: textField)
        
        otpController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        
        otpController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        otpController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        otpController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        
        textField.clearButtonMode = .never
        otpController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        textField.delegate = self
        //Adding constraints wrt to its parent i.e OTPStackView
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.textAlignment = .left3
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.ottRegularFont(withSize: 16)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if #available(iOS 12.0, *) {
//            textField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            textField.keyboardType = .asciiCapableNumberPad
        } else {
           textField.keyboardType = .numberPad
            // Fallback on earlier versions
        }

    }
    
    @objc func changeTextFieldFocus(toNextTextField textField: UITextField?) {
//        let tagValue: Int = (textField?.tag ?? 0) + 1
//        let txtField = view.viewWithTag(tagValue) as? UITextField
//        txtField?.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if let fields = AppDelegate.otpAuthenticationFields, fields.otp_length > 0 {
            if (textField.text?.count ?? 0 < fields.otp_length) || string == ""  {
                return allowedCharacters.isSuperset(of: characterSet)
            }
            else {
                return false
            }
        }
        return allowedCharacters.isSuperset(of: characterSet)
//        if (textField.text?.count ?? 0) == 0  {
//            perform(#selector(self.changeTextFieldFocus(toNextTextField:)), with: textField, afterDelay: 0.0)
//        }
//        else if string.count > 0{
//            textField.text = string
//            perform(#selector(self.changeTextFieldFocus(toNextTextField:)), with: textField, afterDelay: 0.0)
//        }
//        else {
//
//            // if (textField.text?.count ?? 0) == 0 && (textField.text == "") {
//            let tagValue: Int = (textField.tag) - 1
//            var txtField = view.viewWithTag(tagValue) as? UITextField
//            if (txtField == nil){
//                txtField = textField.superview?.viewWithTag(1) as? UITextField
//            }
//            textField.text = string
//
//            txtField?.becomeFirstResponder()
//            return false
//            // }
//        }
//        return range.location < 1
        return true
    }


    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
//        if (text?.utf16.count)! >= 1{
//            switch textField{
//            case txtOTP1:
//                txtOTP2.becomeFirstResponder()
//            case txtOTP2:
//                txtOTP3.becomeFirstResponder()
//            case txtOTP3:
//                txtOTP4.becomeFirstResponder()
//            case txtOTP4:
//                txtOTP4.resignFirstResponder()
//            default:
//                break
//            }
//        }else{
//
//        }
    }


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromPlayer {
            self.dismiss(animated: true, completion: nil)
            return;
        }
        
        countdown = maxOTPTime
        if otpSent == false && !isFromBackButton {
            self.getOTPForMobile()
        }
        else{
            if !isFromBackButton {
                self.startOTPResendTimer()
//                self.OTPStatusLabel.text = setOtpStatusLabel()
            }
        }
        
        if viewControllerName.isEqual("UpdateMobileNumberVC") {
            otpHeaderLabel.text = "Enter One Time Password to verify your mobile number".localized
            otpHeaderLabel.textAlignment = NSTextAlignment.center
        }
        if playerVC != nil {
            playerVC?.showHidePlayerView(true)
        }
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if myTimer != nil {
            myTimer!.invalidate()
            myTimer = nil
        }
        
        AppDelegate.getDelegate().removeStatusBarView()
        countdown = maxOTPTime
        self.verifyButton.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        countdown = maxOTPTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -  show popup
   
      // MARK: -  showAlertWithText Method
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
     // MARK: -  getOTPForMobile API
    func getOTPForMobile() -> Void {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if identifier != "" {
            
            self.startAnimating(allowInteraction: false)
            
//            mobileNumber = mobileNumber?.replacingOccurrences(of: "-", with: "")
            let tempMobileNumber = (target.count > 0 ? target : identifier).replacingOccurrences(of: "-", with: "")
            if checkContainsCharacters(inputStr: tempMobileNumber) {
                if self.isSignUpError {
                    OTTSdk.userManager.getOTP(mobile: nil, email: tempMobileNumber, context: .signup, onSuccess: { (response) in
                        print(response)
                        self.stopAnimating()
                        self.referenceID = response.referenceId
                        //                self.showAlertWithText(String.getAppName(), message: message)
                        self.startOTPResendTimer()
                        self.verifyButton.isHidden = false
                        //                    self.OTPStatusLabel.text = self.setOtpStatusLabel()
                        //                    self.timerLabel.text = self.setOtpStatusLabel()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                        self.verifyButton.isHidden = false
                    })
                    
                }else if self.isSignInError {
                    OTTSdk.userManager.getOTP(mobile: nil, email: tempMobileNumber, context: .signin, onSuccess: { (response) in
                        print(response)
                        self.stopAnimating()
                        self.referenceID = response.referenceId
                        //                self.showAlertWithText(String.getAppName(), message: message)
                        self.startOTPResendTimer()
                        self.verifyButton.isHidden = false
                        //                    self.OTPStatusLabel.text = self.setOtpStatusLabel()
                        //                    self.timerLabel.text = self.setOtpStatusLabel()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                        self.verifyButton.isHidden = false
                    })
                    
                }
                else{
                    OTTSdk.userManager.getOTP(mobile: nil, email: tempMobileNumber, context: .verifyEmail, onSuccess: { (response) in
                        print(response)
                        self.stopAnimating()
                        self.referenceID = response.referenceId
                        //                self.showAlertWithText(String.getAppName(), message: message)
                        self.startOTPResendTimer()
                        self.verifyButton.isHidden = false
                        //                    self.OTPStatusLabel.text = self.setOtpStatusLabel()
                        //                    self.timerLabel.text = self.setOtpStatusLabel()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                        self.verifyButton.isHidden = false
                    })
                    
                }
            }
            else {
                if self.isSignUpError {
                    OTTSdk.userManager.getOTP(mobile: tempMobileNumber, email: nil, context: .signup, onSuccess: { (response) in
                        print(response)
                        self.referenceID = response.referenceId
                        self.setOTPSuccessResponse()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.setOTPFailureResponse()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                    })
                } else if self.isSignInError {
                    OTTSdk.userManager.getOTP(mobile: tempMobileNumber, email: nil, context: .signin, onSuccess: { (response) in
                        print(response)
                        self.referenceID = response.referenceId
                        self.setOTPSuccessResponse()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.setOTPFailureResponse()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                    })
                }
                else{
//                    mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
                    OTTSdk.userManager.getOTP(mobile: tempMobileNumber, email: nil, context: .verifyMobile, onSuccess: { (response) in
                        print(response)
                        self.referenceID = response.referenceId
                        self.setOTPSuccessResponse()
                    }, onFailure: { (error) in
                        Log(message: error.message)
                        self.setOTPFailureResponse()
                        let message:String = error.message
                        self.showAlertWithText(String.getAppName(), message: message)
                    })
                }
            }
        }
    }
    func setOTPSuccessResponse(){
        self.stopAnimating()
        self.startOTPResendTimer()
        self.verifyButton.isHidden = false
    }
    
    func setOTPFailureResponse(){
        self.stopAnimating()
        self.verifyButton.isHidden = false
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
    

    func resendOtp() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if identifier != "" {
            self.startAnimating(allowInteraction: false)
            OTTSdk.userManager.resendOTP(referenceId: self.referenceID, onSuccess: { (response) in
                self.stopAnimating()
                self.startOTPResendTimer()
                self.verifyButton.isHidden = false
//                self.OTPStatusLabel.text = self.setOtpStatusLabel()
                self.showAlertWithText(String.getAppName(), message: response)
            }, onFailure: { (error) in
                self.resentOtpCount = 0
                self.stopAnimating()
                let message:String = error.message
                self.showAlertWithText(String.getAppName(), message: message)
                self.verifyButton.isHidden = false
            })
        }
    }
    
    // MARK: -  custom Method
    func startOTPResendTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(OTPViewController.otpCountDownTick), userInfo: nil, repeats: true)
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
        if countdown < 10 {
            countDownStr = String(format: "%@%d%@", "(00:0", countdown,")")
        }
        else {
            countDownStr = String(format: "%@%d%@", "(00:", countdown,")")
        }
    }
    
   
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
 
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
     // MARK: -  custom actions
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }


    @IBAction func backButAction(_ sender: Any) {
        //self.OtpTextF.resignFirstResponder()
        if self.referenceId != nil {
            if (actionCode == 2 || actionCode == 4) {
                self.goToPreviousPage()
            }
            else {
                self.showOTPSkipAlert(message: "Are You sure you want to leave this page ?")
            }
        }
        else {
            self.goToPreviousPage()
        }
    }
    
    func goToPreviousPage() {
        let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        if viewControllerName.isEqual("SignUpVC") ||  viewControllerName.isEqual("SignInVC") {
            AppDelegate.getDelegate().loadHomePage()
            OTTSdk.userManager.userInfo { _ in
            } onFailure: { _ in
            }
        }
        else if viewControllerName == "ChangeMobile" || viewControllerName == "VerifyMobileVC" {
             _ = self.navigationController?.popViewController(animated: true)
            /*
            if self.targetVC != nil{
                if self.navigationController!.viewControllers.contains(self.targetVC!){
                    self.navigationController?.popToViewController(self.targetVC!, animated: true)
                    return;
                }
            }
            if OTTSdk.preferenceManager.selectedLanguages .isEmpty {
                if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                    TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                        AppDelegate.getDelegate().loadHomePage()
                    })
                }  else {
                    AppDelegate.getDelegate().loadHomePage()
                }
                return;
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }*/
        }
        else if viewControllerName == "PlayerVC" {
            AppDelegate.getDelegate().cancelOTPFromPlayer = true
            if  playerVC != nil{
                playerVC?.showHidePlayerView(false)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
            _ = self.navigationController?.popViewController(animated: true)
            
        }
        else {
            if self.navigationController?.viewControllers.count ?? 0 > 1 {
                _ = self.navigationController?.popViewController(animated: true)
            }
            else{
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                storyBoardVC.viewControllerName = "SignInVC"
                let nav = UINavigationController.init(rootViewController: storyBoardVC)
                nav.isNavigationBarHidden = true
                AppDelegate.getDelegate().window?.rootViewController = nav
            }
        }
    }
    

    @IBAction func ResendOTPAction(_ sender: AnyObject) {
        //self.OtpTextF.text = ""
        if self.resentOtpCount <= AppDelegate.getDelegate().resendOtpLimit {
            self.resentOtpCount = self.resentOtpCount + 1
            self.resendOtp()
        } else {
            self.showAlertWithText(message: "You have reached a Maximum Limit. Please try again after some time".localized)
        }
    }
    @IBAction func VerifyClicked(_ sender: AnyObject) {
        if self.txtOTP1.text != ""
        {
            self.view.endEditing(true)
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            let otpTextString = "\(txtOTP1.text!)"
            self.startAnimating(allowInteraction: false)
            if self.isFromForgotPwd {
                if self.identifierType == "email" {
                    OTTSdk.userManager.verifyEmail(email: self.identifier, otp: Int(otpTextString)!, context: .updatePassword, targetType: self.targetType, target: self.target, onSuccess: { (response) in
                        self.stopAnimating()
                        let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        if self.identifierType == "email" {
                            resetVC.email = self.identifier
                            resetVC.mobile = nil
                        } else {
                            resetVC.mobile = self.identifier
                            resetVC.email = nil
                        }
                        resetVC.otpField = Int(otpTextString)!
                        resetVC.viewControllerName = self.viewControllerName as String
                        if self.viewControllerName == "PlayerVC" {
                            let topVC = UIApplication.topVC()!
                            topVC.navigationController?.pushViewController(resetVC, animated: true)
                        } else {
                            self.navigationController?.isNavigationBarHidden = true
                            self.navigationController?.pushViewController(resetVC, animated: true)
                        }
                        
                    }) { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        self.txtOTP1.text = ""
                        self.txtOTP2.text = ""
                        self.txtOTP3.text = ""
                        self.txtOTP4.text = ""
                        self.showAlertWithText(String.getAppName(), message: error.message)
                    }
                }
                else {
                    OTTSdk.userManager.verifyMobile(mobile: self.identifier, otp: Int(otpTextString)!, context: .updatePassword, targetType: self.targetType,target: self.target, onSuccess: { (response) in
                        self.stopAnimating()
                        let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        if self.identifierType == "email" {
                            resetVC.email = self.identifier
                            resetVC.mobile = nil
                        } else {
                            resetVC.mobile = self.identifier
                            resetVC.email = nil
                        }
                        resetVC.otpField = Int(otpTextString)!
                        resetVC.viewControllerName = self.viewControllerName as String
                        if self.viewControllerName == "PlayerVC" {
                            let topVC = UIApplication.topVC()!
                            topVC.navigationController?.pushViewController(resetVC, animated: true)
                        } else {
                            self.navigationController?.isNavigationBarHidden = true
                            self.navigationController?.pushViewController(resetVC, animated: true)
                        }
                        
                    }) { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        self.txtOTP1.text = ""
                        self.txtOTP2.text = ""
                        self.txtOTP3.text = ""
                        self.txtOTP4.text = ""
                        self.showAlertWithText(String.getAppName(), message: error.message)
                    }
                }
                
            } else {
                if self.referenceId != nil {
                    OTTSdk.userManager.signupWithOTPVerification(referenceId: self.referenceId!, otp: Int(otpTextString)!, onSuccess: { (response) in
                        print(response)
                        self.stopAnimating()
                        AppAnalytics.shared.updateUser()
                        guard let fromViewController = self.navigationController?.viewControllers else{
                            Log(message: "Navigation controller is not available..")
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                        if self.identifier.contains("@") {
                            self.showSuccessAlert(message: "Yayy!!Account creation successful")
                        }else {
                            self.showSuccessAlert(message: "Successfully verified Mobile Number")
                        }
                    }) { (error) in
                        Log(message: error.message)
                        self.stopAnimating()
                        self.txtOTP1.text = ""
                        let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        
                        if self.viewControllerName.isEqual("SignUpVC") {
                            for aviewcontroller : UIViewController in fromViewController
                            {
                                if aviewcontroller is SignUpViewController {
                                    
                                    self.showAlertWithText(String.getAppName(), message: error.message)
                                    
                                    break
                                }
                            }
                        }
                        else
                        {
                            self.showAlertWithText(String.getAppName(), message: error.message)
                        }
                        
                    }
                }else if self.isSignInError{
                    var isHeaderEnrichment = (AppDelegate.getDelegate().headerEnrichmentNum .isEmpty) ? false:true
                    if identifier != AppDelegate.getDelegate().headerEnrichmentNum {
                        isHeaderEnrichment = false
                    }
                    OTTSdk.userManager.signInWithOtp(loginId: identifier, otp: otpTextString, appVersion: "1.0", onSuccess: { (response) in
                        self.stopAnimating()
                        AppAnalytics.shared.updateUser()
                        //                    LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success")
                        guard let fromViewController = self.navigationController?.viewControllers else{
                            Log(message: "Navigation controller is not available..")
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                        if self.identifier.contains("@") {
                            self.showSuccessAlert(message: "Successfully verified Email")
                        }else {
                            self.showSuccessAlert(message: "Successfully verified Mobile Number")
                        }
                        
                    }) { (error) in
                        self.stopAnimating()
                        self.txtOTP1.text = ""
                        self.txtOTP2.text = ""
                        self.txtOTP3.text = ""
                        self.txtOTP4.text = ""
                        let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                        
                        if self.viewControllerName.isEqual("SignUpVC") {
                            for aviewcontroller : UIViewController in fromViewController
                            {
                                if aviewcontroller is SignUpViewController {
                                    
                                    self.showAlertWithText(String.getAppName(), message: error.message)
                                    
                                    break
                                }
                            }
                        }
                        else
                        {
                            self.showAlertWithText(String.getAppName(), message: error.message)
                        }
                        
                    }
                }
                else {
                    if context.count > 0 {
                        if context == "verify_email" {
                            OTTSdk.userManager.verifyEmail(email: identifier, otp: Int(otpTextString)!, context: isSignUpError == true ? .signup : .verifyEmail, targetType: self.targetType, target: self.target, onSuccess: { (response) in
                                self.stopAnimating()
                                AppAnalytics.shared.updateUser()
                                self.showSuccessAlert(message: "Successfully verified Email ID")
                            }) { (error) in
                                self.txtOTP1.text = ""
                                self.txtOTP2.text = ""
                                self.txtOTP3.text = ""
                                self.txtOTP4.text = ""
                                self.stopAnimating()
                                self.showAlertWithText(String.getAppName(), message: error.message)
                            }
                            return
                        }
                        OTTSdk.userManager.verifyMobile(mobile: self.identifier, otp: Int(otpTextString)!, context: isSignUpError == true ? .signup : .verifyMobile, targetType: self.targetType, target: self.target, onSuccess: { (response) in
                            print(response)
                            self.stopAnimating()
                            AppAnalytics.shared.updateUser()
                            //                    LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success")
                            guard let fromViewController = self.navigationController?.viewControllers else{
                                Log(message: "Navigation controller is not available..")
                                self.navigationController?.popViewController(animated: true)
                                return
                            }
                            if self.identifier.contains("@") {
                                self.showSuccessAlert(message: "Successfully verified Email")
                            }else {
                                self.showSuccessAlert(message: "Successfully verified Mobile Number")
                            }
                            
                        }, onFailure: { (error) in
                            Log(message: error.message)
                            self.stopAnimating()
                            self.txtOTP1.text = ""
                            self.txtOTP2.text = ""
                            self.txtOTP3.text = ""
                            self.txtOTP4.text = ""
                            let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            
                            if self.viewControllerName.isEqual("SignUpVC") {
                                for aviewcontroller : UIViewController in fromViewController
                                {
                                    if aviewcontroller is SignUpViewController {
                                        
                                        self.showAlertWithText(String.getAppName(), message: error.message)
                                        
                                        break
                                    }
                                }
                            }
                            else
                            {
                                self.showAlertWithText(String.getAppName(), message: error.message)
                            }
                        })
                    }
                    else {
                        if checkContainsCharacters(inputStr: identifier) {
                            OTTSdk.userManager.verifyEmail(email: identifier, otp: Int(otpTextString)!, context: isSignUpError == true ? .signup : .verifyEmail, targetType: self.targetType, target: self.target, onSuccess: { (response) in
                                self.stopAnimating()
                                AppAnalytics.shared.updateUser()
                                self.showSuccessAlert(message: "Successfully verified Email ID")
                            }) { (error) in
                                self.txtOTP1.text = ""
                                self.txtOTP2.text = ""
                                self.txtOTP3.text = ""
                                self.txtOTP4.text = ""
                                self.stopAnimating()
                                self.showAlertWithText(String.getAppName(), message: error.message)
                            }
                            return
                        }
                        OTTSdk.userManager.verifyMobile(mobile: self.identifier, otp: Int(otpTextString)!, context: isSignUpError == true ? .signup : .verifyMobile, targetType: self.targetType, target: self.target, onSuccess: { (response) in
                            print(response)
                            self.stopAnimating()
                            AppAnalytics.shared.updateUser()
                            //                    LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success")
                            guard let fromViewController = self.navigationController?.viewControllers else{
                                Log(message: "Navigation controller is not available..")
                                self.navigationController?.popViewController(animated: true)
                                return
                            }
                            if self.identifier.contains("@") {
                                self.showSuccessAlert(message: "Successfully verified Email")
                            }else {
                                self.showSuccessAlert(message: "Successfully verified Mobile Number")
                            }
                            
                        }, onFailure: { (error) in
                            Log(message: error.message)
                            self.stopAnimating()
                            self.txtOTP1.text = ""
                            self.txtOTP2.text = ""
                            self.txtOTP3.text = ""
                            self.txtOTP4.text = ""
                            let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                            
                            if self.viewControllerName.isEqual("SignUpVC") {
                                for aviewcontroller : UIViewController in fromViewController
                                {
                                    if aviewcontroller is SignUpViewController {
                                        
                                        self.showAlertWithText(String.getAppName(), message: error.message)
                                        
                                        break
                                    }
                                }
                            }
                            else
                            {
                                self.showAlertWithText(String.getAppName(), message: error.message)
                            }
                        })
                    }
                }
            }
            /*
             YuppTVSDK.userManager.verify(mobile: self.mobileNumber, otp: self.OtpTextF.text!, onSuccess: { (response) in
             self.stopAnimating()
             self.accountDelegate?.didFinishOTPValidation?()
             guard let fromViewController = self.navigationController?.viewControllers else{
             Log(message: "Navigation controller is not available..")
             self.navigationController?.popViewController(animated: true)
             return
             }
             if self.viewControllerName.isEqual(to: "SignUpVC") ||  self.viewControllerName.isEqual(to: "SignInVC") ||  self.viewControllerName.isEqual(to: "VerifyMobileVC") {
             if self.targetVC != nil{
             if self.navigationController!.viewControllers.contains(self.targetVC!){
             self.navigationController?.popToViewController(self.targetVC!, animated: true)
             return;
             }
             }
             self.navigationController?.popViewController(animated: true)
             }
             /*  if self.viewControllerName.isEqual(to: "SignUpVC") {
             for aviewcontroller : UIViewController in fromViewController
             {
             if aviewcontroller is SignUpVC {
             
             let alert = UIAlertController(title: String.getAppName(), message: responseMessage, preferredStyle: UIAlertController.Style.alert)
             
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(_ action: UIAlertAction) -> Void in
             /*
             AppDelegate .getDelegate().loadTabbar()
             AppDelegate .getDelegate().tabbar.selectedIndex = 0
             */
             
             let prefsVC = self.storyboard?.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
             prefsVC.fromPage = true
             prefsVC.Signup_Process = true
             self.navigationController?.isNavigationBarHidden = true
             self.navigationController?.pushViewController(prefsVC, animated: true)
             
             }))
             self.present(alert, animated: true, completion: nil)
             break
             }
             }
             
             } */
             else if self.viewControllerName == "BrowseDetailsVC" && self.isSubscribing {
             for aviewcontroller : UIViewController in fromViewController
             {
             //                            if aviewcontroller is BrowseDetailsVC {
             //                                let keychainM = KeychainSwift()
             //                                let mobileStatus:Bool = true
             //                                keychainM.set(mobileStatus, forKey: "MOBILE_STATUS")
             //                                _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
             //                            }
             }
             }
             else if self.viewControllerName == "TVShowDetailsVC" && self.isSubscribing {
             for aviewcontroller : UIViewController in fromViewController
             {
             //                            if aviewcontroller is TVShowDetailsVC {
             //                                let keychainM = KeychainSwift()
             //                                let mobileStatus:Bool = true
             //                                keychainM.set(mobileStatus, forKey: "MOBILE_STATUS")
             //                                _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
             //                            }
             }
             }
             else if self.viewControllerName == "UpdateMobileNumberVC" {
             for aviewcontroller : UIViewController in fromViewController
             {
             if aviewcontroller is ProfileVC {
             self.view.endEditing(true)
             let popvc = SuccessPopUpVC()
             popvc.delegate = self
             popvc.fromUpdateMobile = true
             popvc.destinationVC = aviewcontroller
             self.presentpopupViewController(popvc, animationType: .bottomBottom, completion: { () -> Void in
             
             })
             }
             }
             }
             else
             {
             //self.showpopupSuccess(successStatus: true, message: "")
             }
             
             }, onFailure: { (error) in
             self.stopAnimating()
             self.OtpTextF.text = ""
             let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
             
             if self.viewControllerName.isEqual(to: "SignUpVC") {
             for aviewcontroller : UIViewController in fromViewController
             {
             if aviewcontroller is SignUpVC {
             
             self.showAlertWithText(AppDelegate.getDelegate().genericAlertStr.getAppName(), message: error.message)
             
             break
             }
             }
             }
             else
             {
             self.countdown = self.maxOTPTime
             self.verifyButton.isHidden = true
             self.resendButton.isHidden = false
             self.voiceCallButton.isHidden = false
             //self.showpopupSuccess(successStatus: false, message: error.message)
             self.showAlertWithText(AppDelegate.getDelegate().genericAlertStr.getAppName(), message: error.message)
             }
             })
             */
        }
        else{
            self.showAlertWithText(String.getAppName(), message: "Please enter valid one-time passcode".localized)
        }
        
    }
    
    func showSuccessAlert(_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: true) { (flag) in
            self.moveToNextPage()
        }
    }

    func showOTPSkipAlert(_ header : String = String.getAppName(), message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let leaveAction = UIAlertAction.init(title: "Leave", style: .default) { (action) in
            self.goToPreviousPage()
        }
        let stayAction = UIAlertAction.init(title: "Stay", style: .default) { (action) in
        }
        alert.addAction(leaveAction)
        alert.addAction(stayAction)
        self.present(alert, animated: true, completion: nil)
    }

    func moveToNextPage() {
        
        TargetPage.userNavigationPage(fromViewController: self, shouldUpdateUserObj: true,actionCode: -1) { (pageType) in
            switch pageType {
            case .home :
                if playerVC != nil {
                    playerVC?.showHidePlayerView(false)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                    _ = self.navigationController?.popViewController(animated: true)
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.popViewController(animated: true)
                } else {
                    AppDelegate.getDelegate().loadHomePage(toFristViewController : true)
                }
                break;
            case .packages:
                AppDelegate.getDelegate().loadNoPackagesPage()
                break;
            case .userProfile:
                let userProfileVC = TargetPage.userProfileViewController()
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(userProfileVC, animated: true)
                break;
            case .OTP:
                let otpVC = TargetPage.otpViewController()
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(otpVC, animated: true)
                break;
            case .unKnown:
                self.showAlertWithText(message: "Something went wrong")
                break;
            }
        }
    }
    
    //MARK: - SuccessPopUpVCDelegate methods
    @objc(DoneButtonClicked) func DoneButtonClicked() {
        self.dismissPopupViewController(.fade)
        self.navigationController?.popViewController(animated: true)
    }
    func doneButtonClickedForDestination(destination: UIViewController) {
        self.dismissPopupViewController(.fade)
        self.navigationController?.popToViewController(destination, animated: true)
    }
    @IBAction func changeNumberClicked(_ sender: UIButton) {
        if viewControllerName.isEqual("SignUpVC") ||  viewControllerName.isEqual("SignInVC") || viewControllerName == "ChangeMobile" || viewControllerName == "VerifyMobileVC" || viewControllerName == "PlayerVC" || viewControllerName == "DetailsVC" {
            navigationController?.popViewController(animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
}
