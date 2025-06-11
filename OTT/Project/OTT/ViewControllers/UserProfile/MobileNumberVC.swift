//
//  NewSignUpController.swift
//  OTT
//
//  Created by Pramodkumar on 27/08/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import FBSDKLoginKit
import GoogleSignIn
import MaterialComponents
class MobileNumberVC: UIViewController {
    @IBOutlet weak var emailIdTf : MDCTextField!
    @IBOutlet weak var mobileTf : MDCTextField!
    @IBOutlet weak var dobTextField: MDCTextField?
    @IBOutlet weak var signUpButton : UIButton!
    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var mainStackView : UIStackView!
    @IBOutlet var emailView : UIView!
    @IBOutlet var mobileView : UIView!
    @IBOutlet weak var topTitleLbl : UILabel!
    @IBOutlet weak var navigationView :UIView!
    @IBOutlet weak var countryView : UIView!
    @IBOutlet weak var countryImageView : UIImageView!
    @IBOutlet weak var countNumberLbl : UILabel!
    @IBOutlet var appLogoImageWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTitleLbl : UILabel!
    @IBOutlet weak var subTitleLbl : UILabel!
    
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var toolBar : UIToolbar!
    @IBOutlet var checkBoxImageViewArray: [UIImageView]!
    @IBOutlet var genderLabelsArray: [UILabel]!
    var genderIndex = -1
    @IBOutlet var genderLabel : UILabel!
    var tempTimeInterval : TimeInterval!
    @IBOutlet var genderBgView : UIView!
    @IBOutlet var dobView : UIView!
    
    private var dobController: MDCTextInputControllerOutlined?
    private var emailController: MDCTextInputControllerOutlined? = nil
    private var mobileController: MDCTextInputControllerOutlined? = nil
    var parameters : [String : String]?
    var isFromSignIn = false
    var accountDelegate : AccontDelegate?
    var countriesInfoArray = [Country]()
    var countryCode = ""
    var viewControllerName = ""
    var dob = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .firstshows {
            appLogoImageWidthConstraint.isActive = false
        }
        emailController = MDCTextInputControllerOutlined(textInput: emailIdTf)
        mobileController = MDCTextInputControllerOutlined(textInput: mobileTf)
        // Do any additional setup after loading the view.
        for label in genderLabelsArray {
            label.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        loadData()
        setUpUI()
//        mainStackView.removeArrangedSubview(emailView)
//        emailView.removeFromSuperview()
//        if appContants.appName == .reeldrama {
//            mainStackView.insertArrangedSubview(emailView, at: 0)
//        }else {
//            mainStackView.addArrangedSubview(emailView)
//        }
        for stackView in mainStackView.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        dobView.removeFromSuperview()
        genderBgView.removeFromSuperview()
        emailView.removeFromSuperview()
        mobileView.removeFromSuperview()
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
            if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                emailIdTf.isUserInteractionEnabled = false
                emailIdTf.isEnabled = false
                mobileTf.isUserInteractionEnabled = false
                mobileTf.isEnabled = false
                if fields.isEmailSupported == true, fields.isMobileSupported == true {
                    if let p = parameters, p["email"]?.count != 0 {
                        mainStackView.removeArrangedSubview(emailView)
                        emailView.removeFromSuperview()
                        mainStackView.addArrangedSubview(mobileView)
                        mobileTf.isUserInteractionEnabled = true
                        mobileTf.isEnabled = true
                    }else {
                        mainStackView.addArrangedSubview(emailView)
                        mainStackView.addArrangedSubview(mobileView)
                        enableFieldsForEmailOrMobile(isMobile: true)
                        enableFieldsForEmailOrMobile(isMobile: false)
                    }
                }else if fields.isMobileSupported == true {
                    mainStackView.addArrangedSubview(mobileView)
                    enableFieldsForEmailOrMobile(isMobile: true)
                }else if fields.isEmailSupported == true {
                    mainStackView.addArrangedSubview(emailView)
                    if let p = parameters, p["email"]?.count == 0 {
                        enableFieldsForEmailOrMobile(isMobile: false)
                    }else if let p = parameters, let email = p["email"] as? String, email.count > 0 {
                        emailIdTf.text = email
                    }
                }
            }
            if let user_fields = system_features.userfields as? FeatureAndFields, let fields = user_fields.fields as? Fields {
                if fields.age > 0 {
                    mainStackView.addArrangedSubview(dobView)
                }
                if fields.gender > 0 {
                    mainStackView.addArrangedSubview(genderBgView)
                }
            }
        }
        
        topTitleLbl.text = "Signup".localized
        if isFromSignIn {
            topTitleLbl.text = "Sign-in".localized
        }
        if let fields = AppDelegate.otpAuthenticationFields, fields.otp_verification_order == "email" {
            subTitleLbl.text = "An OTP willl be sent to your email id for verification".localized
        }else if let fields = AppDelegate.otpAuthenticationFields, fields.otp_verification_order == "mobile" || fields.otp_verification_order == "phone" {
            subTitleLbl.text = "An OTP willl be sent to your mobile number for verification".localized
        }
        if mainStackView.arrangedSubviews.count == 2 {
            mainTitleLbl.text = "Enter Your Email Id & Mobile Number"
        }else if mainStackView.arrangedSubviews.contains(emailView) {
            mainTitleLbl.text = "Enter Your Email ID"
        }else {
            mainTitleLbl.text = "Enter Your Mobile Number"
        }
//        if appContants.appName == .reeldrama {
//            if mainStackView.arrangedSubviews.contains(emailView) {
//                mainTitleLbl.text = "Enter Your Email ID"
//                subTitleLbl.text = "An OTP willl be sent to your email id for verification"
//            }else{
//                mainTitleLbl.text = "Enter Your Mobile Number"
//                subTitleLbl.text = "An OTP willl be sent to your email id for verification"
//            }
//        }
    }
    func enableFieldsForEmailOrMobile(isMobile : Bool) {
        if isMobile {
            mobileTf.isUserInteractionEnabled = true
            mobileTf.isEnabled = true
        }else {
            emailIdTf.isUserInteractionEnabled = true
            emailIdTf.isEnabled = true
        }
    }
    func loadData() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if AppDelegate.getDelegate().countriesInfoArray.count == 0 {
            AppDelegate.getDelegate().getMyCountiesList(isUpdated: true) {
                self.updateData()
            }
        }else {
            updateData()
        }
    }
    private func updateData() {
        countriesInfoArray = AppDelegate.getDelegate().countriesInfoArray
        let predicate = NSPredicate(format: "code == %@", AppDelegate.getDelegate().countryCode)
        let filteredarr = self.countriesInfoArray.filter { predicate.evaluate(with: $0) };
        if filteredarr.count > 0 {
            let dict = filteredarr[0]
            self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.countryCode = dict.code
            self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
        }
        else if self.countriesInfoArray.count > 0 {
            let dict = self.countriesInfoArray[0]
            self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.countryCode = dict.code
            self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
        }
        if AppDelegate.getDelegate().headerEnrichmentNum.count > 10 {
            self.setUpUI()
        }
    }
    @IBAction func backAction(_ sender : UIButton) {
        self.stopAnimating()
        if viewControllerName == "PlayerVC" {
            if sender.tag == 14 {
                if isFromSignIn {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.popViewController(animated: true)
            } else {
                if isFromSignIn {
                    navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                navigationController?.popViewController(animated: true)
            }
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func signInSignUpButtonAction(_ sender : Any) {
        var email = ""
        var number = mobileTf.text!
        if let p = parameters, let tempEmail = p["email"], tempEmail.count > 0 {
            email = tempEmail
        }
        else {
            email = emailIdTf.text ?? ""
        }
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
            if fields.isEmailSupported == true {
                guard email.count > 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please enter Email".localized, needAction: false) { (flag) in }
                    return
                }
                guard email.validateEmail() else {
                    errorAlert(forTitle: String.getAppName(), message: "Please enter a valid Email Id".localized, needAction: false) { (flag) in }
                    return
                }
            }
            if fields.isMobileSupported == true {
                guard number.count > 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please enter valid Number".localized, needAction: false) { (flag) in }
                    return
                }
                var mobileRegEx = AppDelegate.getDelegate().mobileRegExp
                mobileRegEx = mobileRegEx.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
                guard number.count >= 6, number.count <= 15 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please enter valid Number".localized, needAction: false) { (flag) in }
                    return
                }
                number = number.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        var phoneNumber = number
        if phoneNumber.count > 0 {
            if countNumberLbl.text != nil {
                phoneNumber = String(format: "%@%@", (countNumberLbl.text?.replacingOccurrences(of: "+", with: ""))!,phoneNumber)
            }else {
                phoneNumber = String(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),phoneNumber)
            }
        }
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let user_fields = system_features.userfields as? FeatureAndFields, let fields = user_fields.fields as? Fields {
            let _dob = dobTextField?.text?.trimmingCharacters(in: .whitespaces) ?? ""
            if fields.age == 2 {
                guard _dob.count > 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please select date of birth".localized, needAction: false) { (flag) in }
                    return
                }
                dob = _dob
            }
            else if fields.age == 1 {
                if _dob.count > 0 {
                    dob = _dob
                }
            }
            if fields.gender == 2 {
                guard genderIndex >= 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please select gender".localized, needAction: false) { (flag) in }
                    return
                }
            }
        }
        if let p = parameters, let uname = p["name"], let id = p["id"], let login_type = p["login_type"] {
            if isFromSignIn {
                signInWithSocialAccount(email: email, userName: uname, accessToken: id, loginType: login_type, password: "")
            }else {
                signUpWithSocialAccount(uname: email, userName: uname, accesToken: id, loginType: login_type, password: "", mobile: phoneNumber)
            }
        }
    }
    func signUpWithSocialAccount(uname:String?, userName:String, accesToken:String,loginType:String,password:String, mobile : String) {
        let isHeaderEnrichment = (AppDelegate.getDelegate().headerEnrichmentNum .isEmpty) ? false:true
        OTTSdk.userManager.signup(firstName:"", lastName: "", email: uname, mobile: mobile, password: password, appVersion: "1.0", referralType: nil, referralId: nil, isHeaderEnrichment: isHeaderEnrichment, socialAccountId: accesToken, socialAccountType: loginType, dob: getDob(), gender: getGenderString(), onSuccess: { (response) in
            if response.userDetails != nil {
                AppAnalytics.shared.updateUser()
                LocalyticsEvent.tagEventWithAttributes("Sign_up_Success", ["User_Type":""])
                LocalyticsEvent.pushProfileOnLogin()
                self.stopAnimating()
                self.accountDelegate?.didFinishSignUp?()
                let userAttributes = OTTSdk.preferenceManager.user?.attributes
                if !(userAttributes?.timezone .isEmpty)! && (userAttributes?.timezone)! != "false"{
                    NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
                }
                if !(userAttributes?.displayLanguage .isEmpty)! {
                    OTTSdk.preferenceManager.selectedDisplayLanguage = (userAttributes?.displayLanguage)!
                    Localization.instance.updateLocalization()
                    // config nill to get menu in selected language
                    ConfigResponse.StoredConfig.lastUpdated = nil
                    ConfigResponse.StoredConfig.response = nil
                    if self.viewControllerName != "PlayerVC" {
                        if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
//                                self.updateUI()
                            })
                        }
                        else {
                            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
//                                self.updateUI()
                            })
                        }
                    }
                }
            }
            self.stopAnimating()
            TargetPage.userNavigationPage(fromViewController: self, shouldUpdateUserObj: false, actionCode: response.actionCode) { (pageType) in
                switch pageType {
                case .home :
                    if self.viewControllerName == "PlayerVC" {
                        let button = UIButton()
                        button.tag = 14
//                        self.BackAction(UIButton())
                        self.backAction(button)
                    }
                    else {
                        AppDelegate.getDelegate().loadHomePage()
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
                    if (response.details != nil) {
                        if !(response.details!.referenceKey .isEmpty) {
                            let otpVC = TargetPage.otpViewController()
                            otpVC.viewControllerName = self.viewControllerName as String
                            otpVC.otpSent = false
                            otpVC.actionCode = response.actionCode
                            otpVC.isSignUpError = true
                            
                            if response.actionCode == 1 || response.actionCode == 2 {
                                if !(response.details!.mobile.isEmpty){
                                    otpVC.identifier = response.details!.mobile
                                }
                                else{
                                    otpVC.identifier = mobile
                                }
                            }
                            else {
                                if !(response.details!.email.isEmpty){
                                    otpVC.identifier = response.details!.email
                                }
                                else{
                                    otpVC.identifier = uname
                                }
                            }
                            
                            otpVC.referenceId = response.details!.referenceKey
                            if self.viewControllerName == "PlayerVC" {
                                let topVC = UIApplication.topVC()!
                                _ = topVC.navigationController?.popViewController(animated: true)
                                if  playerVC != nil{
                                    playerVC?.showHidePlayerView(true)
                                }
                                topVC.navigationController?.pushViewController(otpVC, animated: true)
                            } else {
                                let topVC = UIApplication.topVC()!
                                topVC.navigationController?.pushViewController(otpVC, animated: true)
                            }
                        }
                    }
                    else if (response.userDetails != nil) {
                        let otpVC = TargetPage.otpViewController()
                        otpVC.viewControllerName = self.viewControllerName as String
                        otpVC.actionCode = response.actionCode
                        otpVC.isSignUpError = true
                        otpVC.otpSent = false
                        if response.actionCode == 1 || response.actionCode == 2 {
                            if !(response.userDetails!.phoneNumber.isEmpty){
                                otpVC.identifier = response.userDetails!.phoneNumber
                            }
                            else{
                                otpVC.identifier = mobile
                            }
                        }
                        else if response.actionCode == 3 || response.actionCode == 4 {
                            otpVC.identifier = uname
                        }
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(otpVC, animated: true)
                    }
                    break;
                case .unKnown:
                    self.errorAlert(forTitle:String.getAppName(), message: "Something went wrong", needAction: false){ (flag) in }
                    break;
                }
            }
            
        }, onFailure: { (error) in
            Log(message: error.message)
            LocalyticsEvent.tagEventWithAttributes("Sign_up_Failure", ["User_Type":"", "Reason":error.message])
            self.stopAnimating()
            if error.details != nil, let details = error.details{
                if error.code == -17 {
                    self.startAnimating(allowInteraction: true)
                    OTTSdk.appManager.getToken(onSuccess: {
                        self.stopAnimating()
//                        self.SignUpAction(self.SignUpBtn)
                    }, onFailure: { (error) in
                        self.stopAnimating()
                        self.errorAlert(forTitle:String.getAppName(), message: error.message, needAction: false){ (flag) in }
                    })
                }
                else if error.code == -40{
                    
                    // Details object removed. as it is of type Any and will be served based on context
                    
                    if !(details.referenceId .isEmpty) {
                        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        storyBoardVC.viewControllerName = self.viewControllerName as String
                        storyBoardVC.otpSent = false
                        storyBoardVC.isSignUpError = true
                        if !(details.phoneNumber.isEmpty){
                            storyBoardVC.identifier = details.phoneNumber
                        }
                        else{
                            storyBoardVC.identifier = mobile
                        }
                        storyBoardVC.referenceId = details.referenceId
                        if self.viewControllerName == "PlayerVC" {
                            let topVC = UIApplication.topVC()!
                            _ = topVC.navigationController?.popViewController(animated: true)
                            if  playerVC != nil{
                                playerVC?.showHidePlayerView(true)
                            }
                            topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                        } else {
                            
                            let topVC = UIApplication.topVC()!
                            topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                        }
                        
                    }else {
                        self.errorAlert(forTitle:String.getAppName(), message: error.message, needAction: false){ (flag) in }
                    }
                    
                }else {
                    self.errorAlert(forTitle:String.getAppName(), message: error.message, needAction: false){ (flag) in }
                }
            } else {
                self.errorAlert(forTitle:String.getAppName(), message: error.message, needAction: false){ (flag) in }
            }
        })
        
        
    }
    private func signInWithSocialAccount(email:String?,userName:String,accessToken:String,loginType:String,password:String) {
            
            OTTSdk.userManager.signInWithSocialAccount(loginId: accessToken, password: password, appVersion: Bundle.applicationVersionNumber, login_type: loginType, onSuccess: { (response) in
                AppAnalytics.shared.updateUser()
                self.stopAnimating()
                self.accountDelegate?.didFinishSignIn?(finished: true)
                let userAttributes = OTTSdk.preferenceManager.user?.attributes
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
                    if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                        TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                            self.setUpUI()
                        })
                    }
                    else {
                        TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                            self.setUpUI()
                        })
                    }
                }
    //            if (OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || (OTTSdk.preferenceManager.user?.isEmailVerified)!{
                    if self.viewControllerName == "PlayerVC" {
                        let button = UIButton()
                        button.tag = 14
                        self.backAction(button)
                    }
                    else {
                        AppDelegate.getDelegate().loadHomePage()
                    }
    //            }
                
    //            else {
    //                if AppDelegate.getDelegate().isOTPSupported {
    //                    if !(OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || !(OTTSdk.preferenceManager.user?.isEmailVerified)!{
    //                        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
    //                        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
    //                        storyBoardVC.viewControllerName = self.viewControllerName
    //                        storyBoardVC.otpSent = false
    //                        if (OTTSdk.preferenceManager.user?.email != nil || OTTSdk.preferenceManager.user?.email != "") && (OTTSdk.preferenceManager.user?.phoneNumber == nil || OTTSdk.preferenceManager.user?.phoneNumber == "") {
    //                            storyBoardVC.mobileNumber = OTTSdk.preferenceManager.user?.email
    //                        } else if (OTTSdk.preferenceManager.user?.email == nil || OTTSdk.preferenceManager.user?.email == "") && (OTTSdk.preferenceManager.user?.phoneNumber != nil || OTTSdk.preferenceManager.user?.phoneNumber != "") {
    //                            storyBoardVC.mobileNumber = OTTSdk.preferenceManager.user?.phoneNumber
    //                        }else if (OTTSdk.preferenceManager.user?.email != nil || OTTSdk.preferenceManager.user?.email != "") && (OTTSdk.preferenceManager.user?.phoneNumber != nil || OTTSdk.preferenceManager.user?.phoneNumber != "") {
    //                            storyBoardVC.mobileNumber = OTTSdk.preferenceManager.user?.email
    //                        }
    //                        if self.viewControllerName == "PlayerVC" {
    //                            _ = self.navigationController?.popViewController(animated: true)
    //                            let topVC = UIApplication.topVC()!
    //                            topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    //                        }
    //                        else {
    //                            let topVC = UIApplication.topVC()!
    //                            topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    //                        }
    //                    }
    //                    else {
    //                        if self.viewControllerName == "PlayerVC" {
    //                            self.BackBtnAction(UIButton())
    //                            //                                playerVC?.view.isHidden = false
    //                            //                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
    //                            //                                self.dismiss(animated: true, completion: nil)
    //                            //                                if self.isFromSignUpPage {
    //                            //                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
    //                            //                                        let topVC = UIApplication.topVC()!
    //                            //                                        topVC.dismiss(animated: true, completion: nil)
    //                            //                                    }
    //                            //                                }
    //                        }
    //                        else {
    //                            AppDelegate.getDelegate().loadHomePage()
    //                        }
    //                    }
    //                }
    //                else {
    //                    if self.viewControllerName == "PlayerVC" {
    //                        self.BackBtnAction(UIButton())
    //                        //                            playerVC?.view.isHidden = false
    //                        //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
    //                        //                            self.dismiss(animated: true, completion: nil)
    //                        //                            if self.isFromSignUpPage {
    //                        //                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
    //                        //                                    let topVC = UIApplication.topVC()!
    //                        //                                    topVC.dismiss(animated: true, completion: nil)
    //                        //                                }
    //                        //                            }
    //                    }
    //                    else {
    //                        AppDelegate.getDelegate().loadHomePage()
    //                    }
    //                }
    //            }
            }, onFailure: { (error) in
                Log(message: error.message)
                if error.code == -1000 {
                    OTTSdk.userManager.signupWithSocialAccount(email: email, userName: userName, mobile: nil, password: password, appVersion: Bundle.applicationVersionNumber, referralType: nil, referralId: nil, socialAcntId: accessToken, socialAcntType: loginType, onSuccess: { (response) in
                        AppAnalytics.shared.updateUser()
                        self.stopAnimating()
                        self.accountDelegate?.didFinishSignUp?()
                        let userAttributes = OTTSdk.preferenceManager.user?.attributes
                        if !(userAttributes?.timezone .isEmpty)! && (userAttributes?.timezone)! != "false"{
                            NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
                        }
                        if !(userAttributes?.displayLanguage .isEmpty)! {
                            OTTSdk.preferenceManager.selectedDisplayLanguage = (userAttributes?.displayLanguage)!
                            Localization.instance.updateLocalization()
                            // config nill to get menu in selected language
                            ConfigResponse.StoredConfig.lastUpdated = nil
                            ConfigResponse.StoredConfig.response = nil
                            if self.viewControllerName != "PlayerVC" {
                                if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                                    TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                                        self.setUpUI()
                                    })
                                }
                                else {
                                    TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                                        self.setUpUI()
                                    })
                                }
                            }
                        }
                        if (OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || (OTTSdk.preferenceManager.user?.isEmailVerified)!{
                            if self.viewControllerName == "PlayerVC" {
                                let button = UIButton()
                                button.tag = 14
                                self.backAction(button)
                            }
                            else {
                                AppDelegate.getDelegate().loadHomePage()
                            }
                        }
                        else {
                            if AppDelegate.getDelegate().isOTPSupported {
                                if !(OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || !(OTTSdk.preferenceManager.user?.isEmailVerified)!{
                                    let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                    storyBoardVC.viewControllerName = self.viewControllerName as String
                                    storyBoardVC.otpSent = false
                                    if (OTTSdk.preferenceManager.user?.email != nil || OTTSdk.preferenceManager.user?.email != "") && (OTTSdk.preferenceManager.user?.phoneNumber == nil || OTTSdk.preferenceManager.user?.phoneNumber == "") {
                                        storyBoardVC.identifier = OTTSdk.preferenceManager.user?.email
                                    } else if (OTTSdk.preferenceManager.user?.email == nil || OTTSdk.preferenceManager.user?.email == "") && (OTTSdk.preferenceManager.user?.phoneNumber != nil || OTTSdk.preferenceManager.user?.phoneNumber != "") {
                                        storyBoardVC.identifier = OTTSdk.preferenceManager.user?.phoneNumber
                                    }else if (OTTSdk.preferenceManager.user?.email != nil || OTTSdk.preferenceManager.user?.email != "") && (OTTSdk.preferenceManager.user?.phoneNumber != nil || OTTSdk.preferenceManager.user?.phoneNumber != "") {
                                        storyBoardVC.identifier = OTTSdk.preferenceManager.user?.email
                                    }
                                    if self.viewControllerName == "PlayerVC" {
                                        _ = self.navigationController?.popViewController(animated: true)
                                        let topVC = UIApplication.topVC()!
                                        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                                    }
                                    else {
                                        let topVC = UIApplication.topVC()!
                                        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                                    }
                                }
                                else {
                                    if self.viewControllerName == "PlayerVC" {
                                        let button = UIButton()
                                        button.tag = 14
                                        self.backAction(button)
                                        //                                playerVC?.view.isHidden = false
                                        //                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                                        //                                self.dismiss(animated: true, completion: nil)
                                        //                                if self.isFromSignUpPage {
                                        //                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
                                        //                                        let topVC = UIApplication.topVC()!
                                        //                                        topVC.dismiss(animated: true, completion: nil)
                                        //                                    }
                                        //                                }
                                    }
                                    else {
                                        AppDelegate.getDelegate().loadHomePage()
                                    }
                                }
                            }
                            else {
                                if self.viewControllerName == "PlayerVC" {
                                    let button = UIButton()
                                    button.tag = 14
                                    self.backAction(button)
                                    //                            playerVC?.view.isHidden = false
                                    //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                                    //                            self.dismiss(animated: true, completion: nil)
                                    //                            if self.isFromSignUpPage {
                                    //                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
                                    //                                    let topVC = UIApplication.topVC()!
                                    //                                    topVC.dismiss(animated: true, completion: nil)
                                    //                                }
                                    //                            }
                                }
                                else {
                                    AppDelegate.getDelegate().loadHomePage()
                                }
                            }
                        }
                    }, onFailure: { (error) in
                        self.stopAnimating()
                        Log(message: error.message)
                        GIDSignIn.sharedInstance().signOut()
                        self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
                    })
                }
                else {
                    self.stopAnimating()
                    GIDSignIn.sharedInstance().signOut()
                    self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
                }
            })
            
        }
    private func setUpUI() {
        genderLabel.textColor = AppTheme.instance.currentTheme.textFieldBorderColor
        genderBgView.backgroundColor = .clear
        datePicker.maximumDate = Date()
        dobTextField?.inputView = datePicker
        dobTextField?.inputAccessoryView = toolBar
        countryView.viewBorderWidthWithTwo(color: AppTheme.instance.currentTheme.textFieldBorderColor, isWidthOne: true)
        countryView.backgroundColor = .clear
        emailController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        emailController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.textInput?.clearButton.isHidden = true
        
        mobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        mobileController?.textInput?.clearButton.isHidden = true
        
        dobController = MDCTextInputControllerOutlined(textInput: dobTextField)
        dobController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        dobTextField?.center = .zero
        dobTextField?.clearButtonMode = .never
        
        
        signUpButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        signUpButton.setTitle("CONTINUE", for: .normal)
        signUpButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        signUpButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        backView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        topTitleLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        navigationView.cornerDesign()
        navigationView.backgroundColor = .clear
        countNumberLbl.font = UIFont.ottRegularFont(withSize: 14)
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
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
                self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
                self.countryCode = dict.code
                self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
            } else {
                self.countNumberLbl.text = String.init(format: "%@%@", "+","\(countryCode)")
            }
            
            self.mobileTf.text = mobileNum
        } else {
            self.mobileTf.text = AppDelegate.getDelegate().headerEnrichmentNum
        }
    }
    @IBAction func showCountriesPopUp(_ sender : Any) {
        self.view.endEditing(true)
        if self.countriesInfoArray.count > 0 {
            let popvc = CountriesInfoPopupViewController()
            popvc.countriesArray = self.countriesInfoArray
            popvc.delegate = self
            self.present(popvc, animated: true, completion: nil)
        }
    }
    private func getDob()->String? {
        if dob.count > 0 {
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let epochDate = Int64(tempTimeInterval)
            let timezoneEpochOffset = (epochDate + Int64(timezoneOffset))
            return "\(timezoneEpochOffset)"
        }
        return nil
    }
    private func getGenderString()->String? {
        switch genderIndex {
        case 0: return "M"
        case 1: return "F"
        case 2: return "O"
        default:
            return nil
        }
    }
    @IBAction func doneButtonAction(_ sender : Any) {
        dobTextField?.resignFirstResponder()
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTextField?.text = tempTimeInterval.getDateOfBirth()
    }
    @IBAction func datePickerValueChanged(_ sender : UIDatePicker) {
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTextField?.text = tempTimeInterval.getDateOfBirth()
    }
    @IBAction func genderButtonAction(_ sender : UIButton) {
        genderIndex = sender.tag
        if genderIndex >= 0 {
            for imageView in checkBoxImageViewArray {
                imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_normal")
            }
            if let imageView = checkBoxImageViewArray.first(where: {$0.tag == genderIndex}) {
                imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_selected")
            }
        }
    }
}
extension MobileNumberVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTf {
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            let final = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return final.count <= 15
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension MobileNumberVC : CountySelectionProtocol {
    func countrySelected(countryObj:Country) {
        self.countryImageView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countNumberLbl.text = String.init(format: "%@%@", "+", "\(countryObj.isdCode)")
        self.countryCode = countryObj.code
    }
}
