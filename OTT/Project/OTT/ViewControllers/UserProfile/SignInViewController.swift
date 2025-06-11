//
//  SignInVC.swift
//  YUPPTV
//
//  Created by Ankoos on 21/07/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import FBSDKLoginKit
import GoogleSignIn
import MaterialComponents
import AuthenticationServices

class SignInViewController: UIViewController ,UIGestureRecognizerDelegate, UITextFieldDelegate,CountySelectionProtocol,DelinkingDeviceProtocol, UITextViewDelegate,GIDSignInDelegate,ASAuthorizationControllerDelegate {
   
    //#warning ios13 : removed GIDSignInUIDelegate
    
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    /* public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
     }*/
    // MARK: - View outlets
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var appIconLeft: NSLayoutConstraint!
    @IBOutlet weak var delinkDeviceSuperView: UIView!
    @IBOutlet weak var delinkDeviceLbl1: UILabel!
    @IBOutlet weak var delinkDeviceLbl2: UILabel!
    @IBOutlet weak var delinkDeviceCancelBtn: UIButton!
    @IBOutlet weak var delinkDeviceDelinkBtn: UIButton!
    //    @IBOutlet var signInHeaderLbl: UILabel!
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet weak var mobileTf: MDCTextField!
    @IBOutlet weak var emailTf: MDCTextField!
    @IBOutlet weak var passwordTxtf: MDCTextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInHeaderLabel: UILabel!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var continueFbBtn: UIButton!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var appleLoginBgView: UIView!
    @IBOutlet weak var appleLoginBgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleLoginBgViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orView1: UIView!
    @IBOutlet weak var orLabel1: UILabel!
    
    @IBOutlet weak var orView1DivLabel1: UILabel!
    @IBOutlet weak var orView1DivLabel2: UILabel!
    
    @IBOutlet weak var countyCodeView: UIView!
    @IBOutlet weak var countryImageView : UIImageView!
    @IBOutlet weak var countryDropDownimgView : UIImageView!
    @IBOutlet weak var countNumberLbl : UILabel!
    @IBOutlet weak var termsLbl : UILabel!
    @IBOutlet weak var mainStackView : UIStackView!
    @IBOutlet weak var emailOrMobileButton : UIButton!
    @IBOutlet var appLogoImageWidthConstraint : NSLayoutConstraint!
    @IBOutlet var stackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet var stackViewTopConstraint : NSLayoutConstraint!
    @IBOutlet var haveAccountTopConstraint : NSLayoutConstraint!
    @IBOutlet var termsTopConstraint : NSLayoutConstraint!
    @IBOutlet var mobileView : UIView!
    @IBOutlet var emailView : UIView!
    @IBOutlet weak var haveAnAccountHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var emailIdButtonHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var emailIdButtonTopConstraint : NSLayoutConstraint!
    var viewControllerName = NSString()
    
    
    //var countryCodeContainer = UIView()
    //var emailImgContainer = UIView()
    //var contryFlagimgView = UIImageView()
    //var countryCodeLbl = UILabel()
    //var countryCodeContainerWidth = CGFloat()
    var countryCodeTap : UITapGestureRecognizer!
    var countriesInfoArray = [Country]()
    var isSignInOtpEnabled:Bool = false
    var accountDelegate : AccontDelegate?
    var targetVC : UIViewController?
    var countryCode = String()
    var isFromSignUpPage:Bool = false
    var isFromFavLibTab:Bool = false
    
    let ButtonUnderLineAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: (appContants.appName == .gac ? AppTheme.instance.currentTheme.textFieldBorderColor : (AppTheme.instance.currentTheme.themeColor ?? UIColor.init(hexString: "EB3495"))),
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    var emailController: MDCTextInputControllerOutlined?
    var passwordController: MDCTextInputControllerOutlined?
    var mobileController: MDCTextInputControllerOutlined?
    var isEmailID = false
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
        if appContants.appName == .aastha || appContants.appName == .gac {
            countryDropDownimgView.image = #imageLiteral(resourceName: "country_dropdown_icon").withRenderingMode(.alwaysTemplate)
            countryDropDownimgView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            if self.viewControllerName != "PlayerVC" {
                playerVC?.removeViews()
                playerVC = nil
            }
        }
        //#warning ios13 : removed uiDelegate
        //        GIDSignIn.sharedInstance().uiDelegate = self
        //Changes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        AppDelegate.getDelegate().handleSupportButton(isHidden: true, isFromTabVC: false)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
        //        AppDelegate.getDelegate().sourceScreen = "SignIn_Page"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .firstshows {
            appLogoImageWidthConstraint.isActive = false
        }
        AppAnalytics.shared.updateUser()
        mainStackView.removeArrangedSubview(emailView)
        mainStackView.removeArrangedSubview(mobileView)
        emailView.removeFromSuperview()
        mobileView.removeFromSuperview()
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
            emailIdButtonTopConstraint.constant = 0.0
            emailIdButtonHeightConstraint.constant = 0.0
            emailOrMobileButton.isHidden = true
            if fields.isEmailSupported == true, fields.isMobileSupported == true {
                emailIdButtonTopConstraint.constant = 16.0
                emailIdButtonHeightConstraint.constant = 50.0
                mainStackView.addArrangedSubview(mobileView)
                emailOrMobileButton.isHidden = false
            }else if fields.isMobileSupported == true {
                mainStackView.addArrangedSubview(mobileView)
            }else if fields.isEmailSupported == true {
                mainStackView.addArrangedSubview(emailView)
            }
        }
        countyCodeView.viewBorderWidthWithTwo(color: .lightGray, isWidthOne: true)
        countyCodeView.backgroundColor = .clear
        //        countyCodeView.isHidden = true
        //        countryCodeViewWidthConstraint.constant = 0
        //        countryCodeViewTrailingConstraint.constant = 0
        emailController = MDCTextInputControllerOutlined(textInput: emailTf)
        mobileController = MDCTextInputControllerOutlined(textInput: mobileTf)
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTxtf)
        
        emailController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        
        emailController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
//        emailController?.textInput?.textColor = .lightGray
        
        mobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
//        mobileController?.textInput?.textColor = .lightGray
        
        passwordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
//        passwordController?.textInput?.textColor = .lightGray
        emailController?.textInput?.clearButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        emailController?.textInput?.clearButton.isHidden = false
        passwordController?.textInput?.clearButton.isHidden = true
        mobileController?.textInput?.clearButton.isHidden = true
        countNumberLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        //        self.view.backgroundColor = UIColor.appBackgroundColor
//        self.navigationView.cornerDesign()
        self.navigationView.backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = true
        if appContants.appName == .aastha {
            self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }
        //        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //        self.countryCodeContainerWidth = 60
        self.forgotPasswordBtn.setTitle("\("Forgot Password".localized)?", for: UIControl.State.normal)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)
        self.signInBtn.setTitle("Sign in".localized, for: .normal)
        self.signInHeaderLabel.font = UIFont.ottRegularFont(withSize: 18)
        //        if AppDelegate.getDelegate().signinTitle .isEmpty {
        //            self.signInHeaderLabel.text = "Sign in".localized
        //        } else {
        //            //self.signInHeaderLabel.text = AppDelegate.getDelegate().signinTitle
        //        }
        
        self.showHideBtn.setTitle("Show".localized, for: UIControl.State.normal)
        //        self.signInHeaderLbl.text = "Sign-in".localized
        self.signInBtn.cornerDesignWithoutBorder()
        emailOrMobileButton.cornerDesignWithoutBorder()
        emailOrMobileButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        orLabel1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.forgotPasswordBtn.cornerDesign()
        self.forgotPasswordBtn.backgroundColor = .clear
        /*
         if self.viewControllerName == "PlayerVC" {
         self.forgotPasswordBtn.isHidden = false
         } else {
         self.forgotPasswordBtn.isHidden = false
         }
         */
        var tersmAndCondtionString = "By Continuing, you agree to \(String.getAppName()) Terms and Conditions"
        if appContants.appName == .supposetv {
             tersmAndCondtionString = "By Signing in, you agree to the Terms of Service and Privacy Policy"
        }
        var tempTermsColor:UIColor = UIColor.init(hexString: "898B93")
        if appContants.appName == .gac {
            tempTermsColor = AppTheme.instance.currentTheme.textFieldBorderColor
        }
        let attributedString = NSMutableAttributedString(string: tersmAndCondtionString, attributes: [
            .font: UIFont.ottRegularFont(withSize: 10.0),
            .foregroundColor: tempTermsColor
        ])
        if let range = NSString(string: tersmAndCondtionString).range(of: "Terms and Conditions", options: String.CompareOptions.caseInsensitive) as? NSRange {
            attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
            var tempConditionsColor:UIColor = UIColor(white: 1.0, alpha: 0.75)
            if appContants.appName == .aastha {
                tempConditionsColor = AppTheme.instance.currentTheme.cardTitleColor
            }
            else if appContants.appName == .gac {
                tempConditionsColor = AppTheme.instance.currentTheme.navigationBarColor
            }
            attributedString.addAttribute(.foregroundColor, value: tempConditionsColor, range: range)
        }
        if let range = NSString(string: tersmAndCondtionString).range(of: "Terms of Service", options: String.CompareOptions.caseInsensitive) as? NSRange {
            attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
            attributedString.addAttribute(.foregroundColor, value: appContants.appName == .aastha ? AppTheme.instance.currentTheme.cardTitleColor as Any : UIColor(white: 1.0, alpha: 0.75), range: range)
        }
        if let range = NSString(string: tersmAndCondtionString).range(of: "Privacy Policy", options: String.CompareOptions.caseInsensitive) as? NSRange {
            attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
            attributedString.addAttribute(.foregroundColor, value: appContants.appName == .aastha ? AppTheme.instance.currentTheme.cardTitleColor as Any : UIColor(white: 1.0, alpha: 0.75), range: range)
        }
        termsLbl.attributedText = attributedString
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.termsLblTap))
        self.termsLbl.addGestureRecognizer(labelTap)
        self.termsLbl.isUserInteractionEnabled = true
        continueFbBtn.isHidden = (AppDelegate.getDelegate().isFacebookLoginSupported ? false : true)
        googleSignInBtn.isHidden = (AppDelegate.getDelegate().supportGoogleLogin ? false : true)
        stackViewHeightConstraint.constant = 40
        stackViewTopConstraint.constant = 16
        haveAccountTopConstraint.constant = 26
        termsTopConstraint.constant = 12
        if continueFbBtn.isHidden && googleSignInBtn.isHidden {
            stackViewHeightConstraint.constant = 0
            stackViewTopConstraint.constant = 0
            haveAccountTopConstraint.constant = 16
            termsTopConstraint.constant = 0
        }
        self.setUpUI()
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

        if AppDelegate.getDelegate().supportAppleLogin == true {
            if #available(iOS 13.0, *) {
                let authorizationButton = ASAuthorizationAppleIDButton()
//                authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
//                authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchDown)
                // Adding gesture since touchUpInside is not working properly for Signin with Apple Button
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAppleIdRequest))
                authorizationButton.addGestureRecognizer(tapGesture)
                
                authorizationButton.cornerRadius = 10
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(50)) {
                    self.appleLoginBgViewHeightConstraint.constant = 50
                    self.appleLoginBgViewTopConstraint.constant = 20
                    authorizationButton.frame = CGRect.init(x: 0, y: 0, width: self.appleLoginBgView.frame.size.width, height: 50)
                    
                }
                self.appleLoginBgView.backgroundColor = .clear
                self.appleLoginBgView.isHidden = false
                self.appleLoginBgView.addSubview(authorizationButton)
                
                
                
            } else {
                self.appleLoginBgView.isHidden = true
                self.appleLoginBgViewHeightConstraint.constant = 0
                self.appleLoginBgViewTopConstraint.constant = 0
            }
        }
        else {
            self.appleLoginBgView.isHidden = true
            self.appleLoginBgViewHeightConstraint.constant = 0
            self.appleLoginBgViewTopConstraint.constant = 0
        }
        if self.continueFbBtn.isHidden == true && self.googleSignInBtn.isHidden == true && self.appleLoginBgView.isHidden == true {
            self.orView1DivLabel1.isHidden = true
            self.orView1DivLabel2.isHidden = true
            self.orLabel1.isHidden = true
        }
        if appContants.appName == .gac {
            self.appIconLeft.constant = (self.view.frame.width - 60)/2 
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setUpUI() -> Void {
        
//        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.RegisterNavColor
        self.signInBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        self.delinkDeviceCancelBtn.cornerDesignWithBorder()
        self.delinkDeviceDelinkBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        self.delinkDeviceLbl1.text = "Oops ! Looks like your account is linked with another device.".localized
        self.delinkDeviceLbl2.text = "Please delink the other device to continue signin here.".localized
        self.delinkDeviceCancelBtn.setTitle("cancel".localized, for: UIControl.State.normal)
        self.delinkDeviceDelinkBtn.setTitle("Delink".localized, for: UIControl.State.normal)
//        self.emailTf.attributedPlaceholder = NSAttributedString(string: "\("Email ID".localized) ", attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
//        self.mobileTf.attributedPlaceholder = NSAttributedString(string: "\("Mobile Number".localized)", attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
//
//        self.passwordTxtf.attributedPlaceholder = NSAttributedString(string: "Password".localized, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)])
        if appContants.appName == .gac {
            self.signupLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        else {
            self.signupLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        }
        //        self.emailImgContainer = UIView(frame: CGRect(x: countyCodeView.frame.origin.x/2 + 15.0, y: countyCodeView.frame.origin.y/2 + 5.0, width: self.countryCodeContainerWidth, height: 30.0))
        //        //emailImgContainer.backgroundColor = UIColor.red
        //
        //        self.countryCodeContainer = UIView(frame: CGRect(x: 0, y: emailImgContainer.frame.origin.y - 5.0, width: 70, height: emailImgContainer.frame.size.height))
        //        self.countryCodeContainer.isHidden = true
        //        self.countryCodeContainer.backgroundColor = UIColor.clear
        
        countryCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.showCountriesInfoPopUp(_:)))
        countryCodeTap.delegate = self
        //        self.countryCodeContainer.addGestureRecognizer(countryCodeTap)
        self.countyCodeView.addGestureRecognizer(countryCodeTap)
        
        //        self.contryFlagimgView = UIImageView(frame: CGRect(x: 16.0, y: 11.0, width: 14, height: 36))
        //        contryFlagimgView.contentMode = .scaleAspectFit
        //        self.countryCodeLbl = UILabel(frame: CGRect(x: (contryFlagimgView.frame.origin.x+contryFlagimgView.frame.size.width) + 8.0, y: 18, width: 34, height: 21))
        //        countryCodeLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        //        countryCodeLbl.textAlignment = NSTextAlignment.left
        if #available(iOS 8.2, *) {
            countNumberLbl.font = UIFont.ottRegularFont(withSize: 14)
            //            countryCodeLbl.font = UIFont.ottRegularFont(withSize: 14)
        } else {
            countNumberLbl.font = UIFont.ottRegularFont(withSize: 14)
            //            countryCodeLbl.font = UIFont.ottRegularFont(withSize: 14)
        }
        
        let countryDropDownImView = UIImageView(frame: CGRect(x: countyCodeView.frame.size.width - 32, y: 26, width: 16, height: 26))
        countryDropDownImView.image = #imageLiteral(resourceName: "country_dropdown_icon")
        countryDropDownImView.contentMode = .scaleAspectFit
        //        countryCodeContainer.addSubview(contryFlagimgView)
        //        countryCodeContainer.addSubview(countryCodeLbl)
        //        countryCodeContainer.addSubview(countryDropDownImView)
        //        emailImgContainer.addSubview(countryCodeContainer)
        //        emailImgContainer.isUserInteractionEnabled = true
        //        countyCodeView.addSubview(emailImgContainer)
        //        countyCodeTxtf.returnKeyType = .next
        //        countyCodeTxtf.leftView = emailImgContainer
        //        countyCodeTxtf.leftViewMode = UITextField.ViewMode.always
        
        
        //        self.countryCodeContainerWidth = 100
        //        self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
        //
        
        passwordTxtf.returnKeyType = .go
        
        /*right view*/
        //        self.countryCodeContainer.isHidden = false
        //        self.countryCodeContainerWidth = self.countryCodeContainer.frame.size.width
        //        self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
        self.passwordTxtf.keyboardType = .default
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
        //        self.signInHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        self.signInHeaderLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.emailTf.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.mobileTf.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.passwordTxtf.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.emailTf.font = UIFont.ottRegularFont(withSize: 16)
        self.mobileTf.font = UIFont.ottRegularFont(withSize: 16)
        self.passwordTxtf.font = UIFont.ottRegularFont(withSize: 16
        )
        self.forgotPasswordBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.8), for: .normal)
        self.signInBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.signInBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        if appContants.appName == .gac {
            self.showHideBtn.setTitleColor(AppTheme.instance.currentTheme.textFieldBorderColor, for: .normal)
            self.orView1DivLabel1.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
            self.orView1DivLabel2.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        }
        else {
            self.showHideBtn.setTitleColor(UIColor.init(hexString: "9ea2ac"), for: .normal)
        }
        let signInBtnAttrString = NSAttributedString(string: "Signup".localized, attributes: ButtonUnderLineAttributes)
        self.signupButton.setAttributedTitle(signInBtnAttrString, for: .normal)
        self.signupButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        if AppDelegate.getDelegate().iosAllowSignup {
            self.signupLabel.isHidden = false
            self.signupButton.isHidden = false
            self.haveAnAccountHeightConstraint.constant = 18.0
            self.haveAccountTopConstraint.constant = 32.0
        }
        else{
            self.signupLabel.isHidden = true
            self.signupButton.isHidden = true
            self.haveAnAccountHeightConstraint.constant = 0.0
            self.haveAccountTopConstraint.constant = 0.0
        }
        
      
        
    }
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            self.OpenUrlInWebview(urlstring: Constants.OTTUrls.termsUrl!,pageString: "Terms & Conditions")
            return
            /*
             // print the character index
             self.printLog(log:"character index: \(characterIndex)" as AnyObject?)
             
             // print the character at the index
             let myRange = NSRange(location: characterIndex, length: 1)
             let substring = (myTextView.attributedText.string as NSString).substring(with: myRange)
             self.printLog(log:"character at index: \(substring)" as AnyObject?)
             
             // check if the tap location has a certain attribute
             let attributeName = "MyCustomAttributeName1"
             let attributeValue = myTextView.attributedText.attribute(attributeName, at: characterIndex, effectiveRange: nil) as? String
             if let value = attributeValue {
             self.printLog(log:"You tapped on \(attributeName) and the value is: \(value)" as AnyObject?)
             self.OpenUrlInWebview(urlstring: Constants.termsUrl,pageString: "Terms & Conditions")
             return
             }
             
             let attributeName2 = "MyCustomAttributeName2"
             let attributeValue2 = myTextView.attributedText.attribute(attributeName2, at: characterIndex, effectiveRange: nil) as? String
             if let value2 = attributeValue2 {
             self.printLog(log:"You tapped on \(attributeName2) and the value is: \(value2)" as AnyObject?)
             self.OpenUrlInWebview(urlstring: Constants.termsUrl,pageString: "Terms & Conditions")
             return
             
             }
             */
        }
    }
    /*
     func OpenUrlInWebview(urlstring : String,pageString:String) -> Void {
     
     let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksVC") as! ExtWebLinksVC
     view1.urlString = urlstring
     view1.pageString = pageString
     view1.viewControllerName = "SignInVC"
     self.navigationController?.isNavigationBarHidden = true
     self.navigationController?.pushViewController(view1, animated: true)
     }
     override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     */
    // MARK: - Button Actions
    
    
    @IBAction func delinkDeviceCancelClicked(_ sender: Any) {
        self.delinkDeviceSuperView.isHidden = true
    }
    
    @IBAction func delinkDeviceDelinkClicked(_ sender: Any) {
        self.delinkDeviceSuperView.isHidden = true
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "DevicesViewController") as! DevicesViewController
        storyBoardVC.delegate = self
        let nav = UINavigationController.init(rootViewController: storyBoardVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func ForgotButtonAction(_ sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.isNavigationBarHidden = true
        nextViewController.viewControllerName = self.viewControllerName as String
        if self.viewControllerName == "PlayerVC" {
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func BackBtnAction(_ sender: UIButton) {
        
        if viewControllerName == "PlayerVC" {
            if sender.tag == 14 {
                if self.isFromSignUpPage {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
                    //                playerVC?.expandViews(isInitialSetUp: true)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.popViewController(animated: true)
            } else {
                if self.isFromSignUpPage {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
                    //                playerVC?.expandViews(isInitialSetUp: true)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        /*
         let fromViewController: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
         
         if viewControllerName.isEqual(to: "IntrosViewController") {
         
         for aviewcontroller : UIViewController in fromViewController
         {
         //                if aviewcontroller is IntrosViewController {
         //                    _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
         //                    break
         //                }
         }
         
         
         }
         else if viewControllerName.isEqual(to: "Home"){
         for aviewcontroller : UIViewController in fromViewController
         {
         if aviewcontroller is HomeVC {
         _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
         break
         }
         }
         
         }
         else if viewControllerName.isEqual(to: "MovieDetailsVC") || viewControllerName.isEqual(to: "TVShowDetailsVC"){
         _ = self.navigationController?.popViewController(animated: true)
         
         }
         else if viewControllerName.isEqual(to: "PLAYERVC") || viewControllerName.isEqual(to: "TVShowsVC"){
         for aviewcontroller : UIViewController in fromViewController
         {
         //                if aviewcontroller is PlayerVC || aviewcontroller is TVShowsVC{
         //                    AppDelegate.getDelegate().loadTabbar()
         //                    AppDelegate.getDelegate().tabbar.selectedIndex = 2
         
         //                    break
         //                }
         }
         }
         else{
         
         for aviewcontroller : UIViewController in fromViewController
         {
         if aviewcontroller is AccountVC {
         _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
         break
         }
         if aviewcontroller is SignInVC {
         //                   AppDelegate.getDelegate().loadTabbar()
         break
         }
         }
         
         }
         */
    }
    
    @IBAction func RememberMeClicked(_ sender: UIButton)
    {
        if sender.tag == 1 {
            sender.tag = 2
            self.isSignInOtpEnabled = true
            self.passwordTxtf.isEnabled = false
            self.passwordTxtf.text = nil
            if checkContainsCharacters(inputStr: self.emailTf.text!) {
                self.emailTf.text = nil
            }
            self.passwordTxtf.isEnabled = false
            self.showHideBtn.isEnabled = false
            self.passwordTxtf.alpha = 0.5
            self.showHideBtn.alpha = 0.5
            self.signInBtn.setTitle("Send OTP".localized, for: UIControl.State.normal)
            self.signInBtn.sizeThatFits(CGSize.zero)
            self.signInBtn.titleLabel?.sizeToFit()
            self.emailTf.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 87.0/255.0, green: 88.0/255.0, blue: 89.0/255.0, alpha: 1.0)])
            //            self.countryCodeContainer.isHidden = false
            //            self.countryCodeContainerWidth = self.countryCodeContainer.frame.size.width
            //            self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
            
        }
        else{
            sender.tag = 1
            self.isSignInOtpEnabled = false
            self.signInBtn.setTitle("Sign-in".localized, for: UIControl.State.normal)
            self.signInBtn.sizeThatFits(CGSize.zero)
            self.emailTf.attributedPlaceholder = NSAttributedString(string: "\("Email".localized) \("Or".localized) \("Mobile Number".localized)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 87.0/255.0, green: 88.0/255.0, blue: 89.0/255.0, alpha: 1.0)])
            self.passwordTxtf.isEnabled = true
            self.showHideBtn.isEnabled = true
            self.passwordTxtf.alpha = 1.0
            self.showHideBtn.alpha = 1.0
            //            self.countryCodeContainer.isHidden = true
            //            self.countryCodeContainerWidth = 0.0
            //            self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
        }
        
    }
    @IBAction func KeyboardRemove(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    @IBAction func SignUpAction(_ sender: AnyObject)
    {
        //        if self.viewControllerName == "PlayerVC" && isFromSignUpPage {
        //            self.dismiss(animated: true, completion: nil)
        //        } else {
        
        #warning("OTP View")
        //        let story_Board : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        //        let otpVC = story_Board.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        //
        //        otpVC.mobileNumber = "******6655"
        //        otpVC.otpSent = true
        //        otpVC.referenceID = 1
        //        otpVC.isFromBackButton = false
        //        otpVC.viewControllerName = self.viewControllerName
        //        otpVC.accountDelegate = self.accountDelegate
        //        otpVC.targetVC = self.targetVC
        //        otpVC.navigationController?.isNavigationBarHidden = true
        //        self.navigationController?.pushViewController(otpVC, animated: true)
        //        return
        #warning("OTP View")
        //        let signUp = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "NewSignUpController") as! NewSignUpController
        //        navigationController?.pushViewController(signUp, animated: true)
        //Check wether SignUpVC is available in stack
        if let viewControllers = self.navigationController?.viewControllers{
            for viewController in viewControllers{
                if viewController is SignUpViewController{
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return;
                }
            }
        }
        
        // SignUpVC is not found in stack. so create and push
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        nextViewController.viewControllerName = (self.viewControllerName as String) .isEmpty ? "SignUpVC" : self.viewControllerName
        nextViewController.accountDelegate = self.accountDelegate
        nextViewController.targetVC = self.targetVC
        nextViewController.isFromSignPage = true
        if self.viewControllerName == "PlayerVC" {
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.pushViewController(nextViewController, animated: true)
        } else {
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        //        }
    }
    @IBAction func SignInAction(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        
        self.emailTf.text = self.emailTf.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        var uname = self.emailTf.text
        let password = self.passwordTxtf.text
        //        var isHeaderEnrichment = (AppDelegate.getDelegate().headerEnrichmentNum .isEmpty) ? false:true
        //        if self.emailTf.text != AppDelegate.getDelegate().headerEnrichmentNum {
        //            isHeaderEnrichment = false
        //        }
        if (self.emailTf.text != "" || self.mobileTf.text != "") && self.passwordTxtf.text != ""{
            let string = self.passwordTxtf.text!
            if let value = mainStackView.arrangedSubviews.first, value == emailView {
                if !(self.isValidEmail(testStr: self.emailTf.text!)) {
                    self.showAlertWithText(String.getAppName(), message: "Please enter a valid Email Id".localized)
                    return
                }
                else if !textFieldShouldReturn(self.emailTf, minLen: 6, maxLen: 50) {
                    self.showAlertWithText(String.getAppName(), message: "Email ID length should be between 6-50 characters".localized)
                    return
                }
            }else {
                var mobileRegEx = AppDelegate.getDelegate().mobileRegExp
                mobileRegEx = mobileRegEx.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
                if self.mobileTf.text != "" && !textFieldShouldReturn(self.mobileTf, minLen: 6, maxLen: 15) {
                    self.showAlertWithText(String.getAppName(), message: "Please enter valid Number".localized)
                    return
                }
                else if !(mobileRegEx.isEmpty) && mobileTest.evaluate(with: mobileTf.text) == false{
                    self.showAlertWithText(String.getAppName(), message: "Please enter valid Number".localized)
                    return
                }
                uname = self.mobileTf.text
                uname = String(format: "%@%@", (self.countNumberLbl.text?.replacingOccurrences(of: "+", with: ""))!,uname!)
            }
            if Int((string as NSString).range(of: " ").location) != NSNotFound {
                self.showAlertWithText(String.getAppName(), message: "Password should not contain spaces".localized)
                return
            }
            
            if !textFieldShouldReturn(self.passwordTxtf, minLen: 4, maxLen: 16) {
                self.showAlertWithText(String.getAppName(), message: "Password length should be between 4-50 characters".localized)
                return
            }
            
            
            
            
            /*var mobileRegEx = AppDelegate.getDelegate().mobileRegExp
             mobileRegEx = mobileRegEx.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
             let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
             
             if self.emailmobilenoTxtf.text != "" && !textFieldShouldReturn(self.emailmobilenoTxtf, minLen: 9, maxLen: 10) {
             self.showAlertWithText(String.getAppName(), message: "Mobile number length should be between 9-10 digits".localized)
             return
             }
             else if !(mobileRegEx .isEmpty) && mobileTest.evaluate(with: emailmobilenoTxtf.text) == false{
             self.showAlertWithText(String.getAppName(), message: "Please enter Valid Number".localized)
             return
             }
             else if !textFieldShouldReturn(self.emailmobilenoTxtf, minLen: 6, maxLen: 50) {
             self.showAlertWithText(String.getAppName(), message: "Email ID length should be between 6-50 characters".localized)
             return
             }
             else if self.countryCodeLbl.text == nil {
             self.showAlertWithText(String.getAppName(), message: "Select your country code".localized)
             return
             }
             var uname = self.emailmobilenoTxtf.text
             if self.countryCodeLbl.text != nil {
             uname = String.init(format: "%@%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!,uname!)
             }
             else {
             uname = String.init(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),uname!)
             }*/
            
            if !Utilities.hasConnectivity() {
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            self.startAnimating(allowInteraction: false)
            
            LocalyticsEvent.tagEventWithAttributes("Sign_in_Clicks", ["User_Type":""])
            
            //             OTTSdk.userManager.signInWithEncryption(loginId: uname!, password: password!, onSuccess: { (response) in
            OTTSdk.userManager.signInWithPassword(loginId: uname!, password: password!, appVersion: Bundle.applicationVersionNumber, isHeaderEnrichment: false, onSuccess: {(response, actionCode)  in
                AppAnalytics.shared.updateUser()
                LocalyticsEvent.tagEventWithAttributes("Sign_in_Success", ["User_Type":""])
                LocalyticsEvent.pushProfileOnLogin()
                self.stopAnimating()
                self.accountDelegate?.didFinishSignIn?(finished: true)
                let userAttributes = OTTSdk.preferenceManager.user?.attributes
                AppDelegate.getDelegate().userStateChanged = true
                if !(userAttributes?.timezone .isEmpty)! && (userAttributes?.timezone)! != "false"{
                    NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
                }
                TargetPage.userNavigationPage(fromViewController: self, shouldUpdateUserObj: false, actionCode: actionCode) { (pageType) in
                    switch pageType {
                    case .home :
                        if playerVC != nil {
                            playerVC?.showHidePlayerView(false)
                            playerVC?.isFromErrorFlow = true
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                            _ = self.navigationController?.popViewController(animated: true)
                            let topVC = UIApplication.topVC()!
                            topVC.navigationController?.popViewController(animated: true)
                        }
                        else if self.viewControllerName == "DetailsVC" {
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
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
                        otpVC.actionCode = actionCode
                        otpVC.viewControllerName = "SignInVC"
                        otpVC.otpSent = false
                        if actionCode == 3 || actionCode == 4 {
                            otpVC.identifier = (OTTSdk.preferenceManager.user?.email)
                        }else {
                            otpVC.identifier = (OTTSdk.preferenceManager.user?.phoneNumber)
                        }
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(otpVC, animated: true)
                        break;
                    case .unKnown:
                        self.showAlertWithText(message: "Something went wrong")
                        break;
                    }
                }
                
            }, onFailure: { (error) in
                self.stopAnimating()
                Log(message: error.message)
                LocalyticsEvent.tagEventWithAttributes("Sign_in_Failure", ["User_Type":"", "Reason":error.message])
                if error.code == 101 {
                    self.delinkDeviceSuperView.isHidden = false
                    self.view.bringSubviewToFront(self.delinkDeviceSuperView)
                } else if error.code == -605 || error.code == -6 {
                    let storyBoardVC = TargetPage.otpViewController()
                    storyBoardVC.viewControllerName = self.viewControllerName as String
                    storyBoardVC.isSignInError = true
                    storyBoardVC.otpSent = false
                    storyBoardVC.actionCode = error.actionCode
                    if let identifier = error.details?.identifier {
                        storyBoardVC.identifier = identifier
                    }else {
                        storyBoardVC.identifier = uname!
                    }
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
                }
                else if error.code == -17 {
                    self.startAnimating(allowInteraction: true)
                    OTTSdk.appManager.getToken(onSuccess: {
                        self.stopAnimating()
                        self.SignInAction(self.signInBtn)
                    }, onFailure: { (error) in
                        self.stopAnimating()
                        self.showAlertWithText(message: error.message as String)
                    })
                }
                else {
                    self.showAlertWithText(message: error.message as String)
                }
            })
        }else{
            
            showAlertWithText(message: "Please enter valid credentials!".localized)
        }
    }
    @IBAction func showHidePasswordText(_ sender: UIButton) {
        if (passwordTxtf.text?.count)! > 0 {
            if passwordTxtf.isSecureTextEntry {
                passwordTxtf.isSecureTextEntry = false
                self.showHideBtn.setTitle("Hide".localized, for: UIControl.State.normal)
            }
            else{
                passwordTxtf.isSecureTextEntry = true
                self.showHideBtn.setTitle("Show".localized, for: UIControl.State.normal)
            }
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
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }
    
    // MARK: - Google Button Actions
    @IBAction func googleBtnAction(_ sender: Any) {
        AppDelegate.getDelegate().socialMediaLoginStr = "Google"
        AppDelegate.getDelegate().socialMediaLoginFrom = "SignIn"
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: - Facebook Button Actions
    @IBAction func FacebookBtnAction(_ sender: AnyObject)
    {
        AppDelegate.getDelegate().socialMediaLoginStr = "Facebook"
        let fbmanager : LoginManager = LoginManager()
        fbmanager.logOut()
        fbmanager.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if error != nil
            {
                self.printLog(log:"error" as AnyObject?)
            }else if(result?.isCancelled)!{
                self.printLog(log:"result cancelled" as AnyObject?)
            }else{
                self.printLog(log:"success Get user information." as AnyObject?)
                
                let fbloginresult : LoginManagerLoginResult = result!
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.startAnimating(allowInteraction: true)
                    self.getFBUserData()
                }
                
            }
        }
        
    }
    func getFBUserData(){
        if let fbAccessToken = AccessToken.current,!fbAccessToken.isExpired {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    //                    guard let r = result as? [AnyHashable : Any] else { return }
                    //                    let parameters = ["email" : (r["email"] as? String ?? ""),
                    //                                      "id" : (r["id"] as? String ?? ""),
                    //                                      "name" : (r["name"] as? String ?? ""),
                    //                                      "login_type" : "facebook"]
                    //                    let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
                    //                    mobileVc.isFromSignIn = true
                    //                    mobileVc.viewControllerName = self.viewControllerName as String
                    //                    mobileVc.parameters = parameters
                    //                    self.navigationController?.pushViewController(mobileVc, animated: true)
                    self.printLog(log:"User Info : \(String(describing: result))" as AnyObject?)
                    let dict = result as! NSDictionary
                    
                    var unameStr:String? = nil
                    if dict["email"] != nil {
                        unameStr = dict["email"] as? String
                    }
                    let userId = dict["id"] as! String
                    let username = dict["name"] as! String
                    self.signInWithSocialAccount(email:unameStr, userName: username,accessToken: userId,loginType: "facebook",password: "facebook")
                }
            })
        }
        else {
            self.FacebookBtnAction(continueFbBtn)
        }
    }
    
    func signInWithSocialAccount(email:String?,userName:String,accessToken:String,loginType:String,password:String) {
        
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
                self.BackBtnAction(button)
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
                
                var isMobileNumberRequired = false
                if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                    if fields.isMobileSupported == true {
                        isMobileNumberRequired = true
                    }
                }
                
                
                if isMobileNumberRequired == true {
                    let params = ["email" : email ?? "",
                                  "id" : accessToken,
                                  "name" : userName,
                                  "login_type" : loginType]
                    
                    let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
                    mobileVc.viewControllerName = "SignUpVC"
                    mobileVc.parameters = params
                    self.navigationController?.pushViewController(mobileVc, animated: true)
                }
                else {
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
                                self.BackBtnAction(button)
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
                                        self.BackBtnAction(button)
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
                                    self.BackBtnAction(button)
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
                        self.showAlertWithTextFB(message: error.message)
                    })
                }
            }
            else {
                self.stopAnimating()
                GIDSignIn.sharedInstance().signOut()
                self.showAlertWithTextFB(message: error.message)
            }
        })
        
    }
    
    // MARK: - Show alert
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
        
        //            if self.emailmobilenoTxtf.text == "" && self.passwordTxtf.text == ""{
        //
        //                self.emailmobilenoTxtf.becomeFirstResponder()
        //            }
        
    }
    func showAlertWithTextFB (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    // MARK: - custom methods
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
        if charStatusArr.contains(NSNumber.init(value: true)) || charStatusArr.count == 0 {
            return true
        }
        else {
            return false
        }
    }
    /*
     func showCountriesInfoPopUp(_ sender: UITapGestureRecognizer? = nil) {
     
     self.view.endEditing(true)
     let popvc = CountriesInfoPopupVC()
     popvc.countriesArray = self.countriesInfoArray
     popvc.delegate = self
     self.present(popvc, animated: true, completion: nil)
     
     }
     */
    func isValidEmail(testStr:String) -> Bool {
        // self.printLog(log:"validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func sendMeOTPLblTaped(_ sender: UITapGestureRecognizer) {
    }
    
    func OpenUrlInWebview(urlstring : String,pageString:String) -> Void {
        
        /**/
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
        view1.urlString = urlstring
        view1.pageString = pageString
        view1.hidesBottomBarWhenPushed = true
        view1.viewControllerName = "SignInVC"
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
        
    }
    
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
        if textField == mobileTf {
        }else if textField == self.passwordTxtf {
            if productType.iPhone && (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6) {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mobileTf {
        }else if textField == self.emailTf {
            if #available(iOS 10.0, *) {
                self.emailTf.keyboardType = .emailAddress
            } else {
                self.emailTf.keyboardType = .emailAddress
                // Fallback on earlier versions
            }
        } else {
            if productType.iPhone && (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6) {
                if DeviceType.IS_IPHONE_5 {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame = CGRect.init(x: 0, y: -100, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    }
                }
                else if DeviceType.IS_IPHONE_6 {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame = CGRect.init(x: 0, y: -40, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    }
                }
            }
            self.passwordTxtf.keyboardType = .default
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTf || textField == self.mobileTf {
            self.passwordTxtf.becomeFirstResponder()
        }
        if textField == self.passwordTxtf {
            view.endEditing(true)
            var mobileOrEmail = ""
            if let m = mobileTf.text, m.count > 0 {
                mobileOrEmail = m
            }else if let e = emailTf.text, e.count > 0 {
                mobileOrEmail = e
            }
            if let value = passwordTxtf.text, value.count > 0, mobileOrEmail.count > 0 {
                self.SignInAction(self.signInBtn)
            }
        }
        return false
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if textField == emailTf {
            newString = newString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
            if isSignInOtpEnabled {
                if checkContainsCharacters(inputStr: newString as String)  {
                    return false
                }
                
                //                self.countryCodeContainer.isHidden = false
                //                self.countryCodeContainerWidth = self.countryCodeContainer.frame.size.width
                //                self.emailImgContainer.frame.size.width = self.countryCodeContainerWidth
                
                let newLength = (textField.text?.count)! + string.count - range.length
                
                if newLength <= 15 {
                    textField.text = newString as String
                    return false
                }
                else {
                    return false
                }
            }
        }else if textField == mobileTf {
            let numberSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: numberSet.inverted) != nil {
                return false
            }
            let final = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return final.count <= 15
            
        } else {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 50 // Bool
        }
        return true
    }
    
    @IBAction func mobileTextChanged(sender: AnyObject) {
        let mobileTextField = sender as! UITextField
        checkMaxLength(textField: mobileTextField, maxLength: 50)
    }
    
    @IBAction func passwordTextChanged(sender: AnyObject) {
        let pwdTextField = sender as! UITextField
        checkMaxLength(textField: pwdTextField, maxLength: 16)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }
    
    //MARK:- Google SDK Delegates
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        self.stopAnimating()
        signIn.signOut()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            let email = user.profile.email
            //            let idToken = user.authentication.idToken // Safe to send to the server
            
            self.signInWithSocialAccount(email: email!, userName: fullName!, accessToken: userId!, loginType: "google", password: "google")
            // ...
        } else {
            Log(message: "\(error.localizedDescription)")
        }
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            let email = user.profile.email
            //            let idToken = user.authentication.idToken // Safe to send to the server
            self.signInWithSocialAccount(email: email!, userName: fullName!, accessToken: userId!, loginType: "google", password: "google")
            // ...
        } else {
            Log(message: "\(error.localizedDescription)")
        }
    }
    
    // Facebook Delegate Methods
    /*
     func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
     self.printLog(log:"User Logged In")
     
     if ((error) != nil)
     {
     // Process error
     }
     else if result.isCancelled {
     // Handle cancellations
     }
     else {
     // If you ask for multiple permissions at once, you
     // should check if specific permissions missing
     if result.grantedPermissions.contains("email")
     {
     // Do work
     }
     }
     }
     
     internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
     {
     
     }
     internal func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool{
     return true
     }
     */
    @IBAction func termsLblTap(gesture: UITapGestureRecognizer) {
        let text = (termsLbl.text)!
        let termsConditionsRange = (text as NSString).range(of: "Terms and Conditions")
        let termsServiceRange = (text as NSString).range(of:"Terms of Service")
        let privacyRange = (text as NSString).range(of:"Privacy Policy")

        var urlStr = ""
        var pageString = ""
        if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsConditionsRange) {
            pageString = "Terms and Conditions"
            if let tempStr = Constants.OTTUrls.termsUrl {
                urlStr = tempStr
            }
        } else if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsServiceRange) {
            pageString = "Terms of Service"
            if let tempStr = Constants.OTTUrls.termsUrl {
                urlStr = tempStr
            }
        } else if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: privacyRange) {
            pageString = "Privacy Policy"
            if let tempStr = Constants.OTTUrls.privacyPolicyUrl {
                urlStr = tempStr
            }
        } else {
            print("Tapped none")
        }
        if urlStr.count > 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = urlStr
            view1.pageString = pageString
            view1.hidesBottomBarWhenPushed = true
            view1.viewControllerName = "SignInVC"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
    }
    @IBAction func termsAndConditionAction(_ sender : Any) {
        //Not using
        if let urlStr = Constants.OTTUrls.termsUrl {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = urlStr
            view1.pageString = "Terms & Conditions"
            view1.hidesBottomBarWhenPushed = true
            view1.viewControllerName = "SignInVC"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
    }
    @IBAction func emailOrMobileAction(_ sender : UIButton) {
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        mobileTf.text = ""
        emailTf.text = ""
        mobileView.removeFromSuperview()
        emailView.removeFromSuperview()
        if (sender.titleLabel?.text?.lowercased().contains("email"))! {
            emailOrMobileButton.setTitle("Sign In with Mobile Number", for: .normal)
            sender.setTitle("Sign In with Mobile Number", for: .normal)
            mainStackView.addArrangedSubview(emailView)
            isEmailID = true
        }else {
            emailOrMobileButton.setTitle("Sign In with Email ID", for: .normal)
            sender.setTitle("Sign In with Email ID", for: .normal)
            mainStackView.addArrangedSubview(mobileView)
            isEmailID = false
        }
    }
}
extension SignInViewController{
    /**/
    func countrySelected(countryObj:Country) {
        countryImageView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countNumberLbl.text = String.init(format: "%@%@", "+", "\(countryObj.isdCode)")
        self.countryCode = countryObj.code
    }
    func deviceDelinked() {
        self.SignInAction(self.signInBtn)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding{
    
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self

            authorizationController.performRequests()
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            var name = ""
            var email = ""
            
            let savedUserId = AppDelegate.getDelegate().getDataFromKeychain(keyName: "appleUserIdentifier")
            if savedUserId != "" && savedUserId == userIdentifier {
                name = AppDelegate.getDelegate().getDataFromKeychain(keyName: "appleUserFullName")
                email = AppDelegate.getDelegate().getDataFromKeychain(keyName: "appleUserEmail")
            }
            else{
                let fullName = appleIDCredential.fullName
                
                if let firstName = fullName?.givenName{
                    name = firstName
                }
                if let familyName = fullName?.familyName{
                    name = name + " " + familyName
                }
                
                let email = appleIDCredential.email
                
                
                if let _email = email {
                    _ = AppDelegate.getDelegate().saveDataInKeychain(keyName: "appleUserEmail", keyValue: _email)
                }
                let newString = (name.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)) as String

                if newString != "" {
                    _ = AppDelegate.getDelegate().saveDataInKeychain(keyName: "appleUserFullName", keyValue: name)
                }
                
                _ = AppDelegate.getDelegate().saveDataInKeychain(keyName: "appleUserIdentifier", keyValue: userIdentifier)
            }
            
            
            self.signInWithSocialAccount(email:email, userName: name,accessToken: userIdentifier,loginType: "apple",password: "apple")

            
        }
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
    
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint.init(x: ((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x), y: ((labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y))
       
        let locationOfTouchInTextContainer =  CGPoint.init(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
