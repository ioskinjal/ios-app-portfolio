//
//  SignUpVC.swift
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

class SignUpViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate,CountySelectionProtocol,UITextViewDelegate,GIDSignInDelegate,ASAuthorizationControllerDelegate { //#warning ios13 : removed ,GIDSignInUIDelegate
    
    
    
    
    // MARK: - View outlets
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var iphoneContainerView: UIView!
    @IBOutlet weak var signUpHeaderLbl: UILabel!
    @IBOutlet weak var haveAnAccnt: UILabel!
    var viewControllerName = NSString()
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet weak var showHideBtnInConfirmPassword: UIButton!
    @IBOutlet weak var SignInBtn: UIButton!
    @IBOutlet weak var MobileNumberTxtf: MDCTextField!
    @IBOutlet weak var phoneNumberTxtf: MDCTextField!
    @IBOutlet weak var PasswordTxtF: MDCTextField!
    @IBOutlet weak var ConfirmPasswordTxtF: MDCTextField!
    @IBOutlet weak var dobTextField: MDCTextField?
    @IBOutlet weak var SignUpBtn: UIButton!
    @IBOutlet weak var continueFbBtn: UIButton!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var orView1: UIView!
    @IBOutlet weak var orLabel1: UILabel!
    @IBOutlet weak var orView1DivLabel1: UILabel!
    @IBOutlet weak var orView1DivLabel2: UILabel!
    @IBOutlet weak var countyCodeView: UIView!
    @IBOutlet weak var contryFlagimgView : UIImageView!
    @IBOutlet weak var countryDropDownimgView : UIImageView!
    @IBOutlet weak var countryCodeLbl : UILabel!
    @IBOutlet weak var termsLbl : UILabel!
    @IBOutlet var appLogoImageWidthConstraint : NSLayoutConstraint!
    @IBOutlet var stackViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet var orViewTopConstraint : NSLayoutConstraint!
    @IBOutlet var stackViewTopConstraint : NSLayoutConstraint!
    @IBOutlet var haveAccountTopConstraint : NSLayoutConstraint!
    @IBOutlet var termsTopConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var appIconLeft: NSLayoutConstraint!
    @IBOutlet weak var appleLoginBgView: UIView!
    @IBOutlet weak var appleLoginBgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleLoginBgViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var emaildescLbl : UILabel!
    @IBOutlet weak var otpLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileStackView : UIStackView!
    @IBOutlet var emailStackView : UIStackView!
    @IBOutlet var mobileStackView : UIStackView!
    @IBOutlet var emailOTPStackView : UIStackView!
    @IBOutlet var mobileOTPStackView : UIStackView!
    
    
    @IBOutlet weak var userNameStackView : UIStackView!
    @IBOutlet weak var firstNameTxtF: MDCTextField!
    @IBOutlet weak var lastNameTxtF: MDCTextField!
//    var countryCodeContainer = UIView()
//    var emailImgContainer = UIView()
//    var contryFlagimgView = UIImageView()
//    var countryCodeLbl = UILabel()
//    var countryCodeContainerWidth = CGFloat()
    
    var countryCodeTap : UITapGestureRecognizer!
    var countriesInfoArray = [Country]()
    var emailImView = UIImageView()
    var countryCode = String()
    var gender = String()
    var dob = String()

    var accountDelegate : AccontDelegate?
    var targetVC : UIViewController?
    var isFromSignPage:Bool = false
    
    
    
    let ButtonUnderLineAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.systemFont(ofSize: 14),
    .foregroundColor: AppTheme.instance.currentTheme.themeColor ?? UIColor.init(hexString: "EB3495"),
    .underlineStyle: NSUnderlineStyle.single.rawValue]
    var mobileController: MDCTextInputControllerOutlined?
    var phoneNumberController: MDCTextInputControllerOutlined?
    var passwordController: MDCTextInputControllerOutlined?
    var confirmPasswordController: MDCTextInputControllerOutlined?
    var dobController: MDCTextInputControllerOutlined?
    
    var firstNameController: MDCTextInputControllerOutlined?
    var lastNameController: MDCTextInputControllerOutlined?

    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var toolBar : UIToolbar!
    @IBOutlet var checkBoxImageViewArray: [UIImageView]!
    @IBOutlet var genderLabelsArray: [UILabel]!
    var genderIndex = -1
    @IBOutlet var genderLabel : UILabel!
    var tempTimeInterval : TimeInterval!
    @IBOutlet var genderBgView : UIView!
    @IBOutlet var dobView : UIView!
    @IBOutlet weak var userFieldStackView : UIStackView!
    public class var instance: SignUpViewController {
        struct Singleton {
            static let obj = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        }
        return Singleton.obj
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
    // MARK: - View methods
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if appContants.appName == .aastha || appContants.appName == .gac {
            countryDropDownimgView.image = #imageLiteral(resourceName: "country_dropdown_icon").withRenderingMode(.alwaysTemplate)
            countryDropDownimgView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        if viewControllerName != "PlayerVC" {
            playerVC?.removeViews()
            playerVC = nil
        }
        //#warning ios13 : removed uiDelegate
//        GIDSignIn.sharedInstance().uiDelegate = self
        //Changes
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .firstshows {
            appLogoImageWidthConstraint.isActive = false
        }
        for label in genderLabelsArray {
            label.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        for stackView in userProfileStackView.arrangedSubviews {
            stackView.removeFromSuperview()
        }
        emailStackView.removeFromSuperview()
        mobileStackView.removeFromSuperview()
        userNameStackView.removeFromSuperview()
        userFieldStackView.removeFromSuperview()
        

        dobView.removeFromSuperview()
        genderBgView.removeFromSuperview()
        userFieldStackView.removeArrangedSubview(dobView)
        userFieldStackView.removeArrangedSubview(genderBgView)
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
            if let globalsettings = system_features.globalsettings as? FeatureAndFields, let fields = globalsettings.fields as? Fields {
                if fields.showFirstName == true || fields.showLastName == true {
                    self.firstNameTxtF.isHidden = !(fields.showFirstName)
                    self.lastNameTxtF.isHidden = !(fields.showLastName)
                    userProfileStackView.addArrangedSubview(userNameStackView)
                }
                if fields.isEmailSupported == true {
                    userProfileStackView.addArrangedSubview(emailStackView)
                }
                if fields.isMobileSupported == true {
                    userProfileStackView.addArrangedSubview(mobileStackView)
                }
            }
            if let user_fields = system_features.userfields as? FeatureAndFields, let fields = user_fields.fields as? Fields {
                if fields.age > 0 {
                    userFieldStackView.addArrangedSubview(dobView)
                }
                if fields.gender > 0 {
                    userFieldStackView.addArrangedSubview(genderBgView)
                }
            }

        }
        userProfileStackView.addArrangedSubview(userFieldStackView)
        genderLabel.textColor = AppTheme.instance.currentTheme.textFieldBorderColor
        genderBgView.backgroundColor = .clear
        datePicker.maximumDate = Date()
        descLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        emaildescLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        emailStackView.removeArrangedSubview(emailOTPStackView)
        emailOTPStackView.removeFromSuperview()
        mobileStackView.removeArrangedSubview(mobileOTPStackView)
        mobileOTPStackView.removeFromSuperview()
        if let fields = AppDelegate.otpAuthenticationFields, fields.otp_verification_order == "email" {
            emailStackView.addArrangedSubview(emailOTPStackView)
        }else if let fields = AppDelegate.otpAuthenticationFields, fields.otp_verification_order == "mobile" || fields.otp_verification_order == "phone" {
            if appContants.appName != .mobitel {
                mobileStackView.addArrangedSubview(mobileOTPStackView)
            }
        }
//        if appContants.appName == .reeldrama || appContants.appName == .aastha {
//            descLbl.text = "An OTP will be sent to your Email for verification."
//            descLbl.isHidden = true
//            otpLblHeightConstraint.constant = 0.0
//        }else if appContants.appName == .aastha {
//            descLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
//            descLbl.alpha = 0.55
//        }
        countyCodeView.viewBorderWidthWithTwo(color: .lightGray, isWidthOne: true)
        countyCodeView.backgroundColor = .clear
        
        firstNameController = MDCTextInputControllerOutlined(textInput: firstNameTxtF)
        lastNameController = MDCTextInputControllerOutlined(textInput: lastNameTxtF)

        mobileController = MDCTextInputControllerOutlined(textInput: MobileNumberTxtf)
        phoneNumberController = MDCTextInputControllerOutlined(textInput: phoneNumberTxtf)
        passwordController = MDCTextInputControllerOutlined(textInput: PasswordTxtF)
        confirmPasswordController = MDCTextInputControllerOutlined(textInput: ConfirmPasswordTxtF)
        dobController = MDCTextInputControllerOutlined(textInput: dobTextField)
                //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton], animated: false)
        
        
        firstNameController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        firstNameTxtF.center = .zero
        firstNameTxtF.clearButtonMode = .never
        
        
        lastNameController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        lastNameTxtF.center = .zero
        lastNameTxtF.clearButtonMode = .never
        
        
        mobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        MobileNumberTxtf.center = .zero
        MobileNumberTxtf.clearButtonMode = .never
        
        phoneNumberController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        phoneNumberController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        phoneNumberController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        phoneNumberController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        phoneNumberController?.textInput?.textColor = .white
        phoneNumberTxtf.center = .zero
        phoneNumberTxtf.clearButtonMode = .never
        
        passwordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        passwordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
//        passwordController?.textInput?.textColor = .lightGray
        PasswordTxtF.center = .zero
        PasswordTxtF.clearButtonMode = .never
        
        self.showHideBtn.setTitleColor(UIColor.init(hexString: "9ea2ac"), for: .normal)
        
        
        confirmPasswordController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        confirmPasswordController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        ConfirmPasswordTxtF.center = .zero
        ConfirmPasswordTxtF.clearButtonMode = .never
        self.showHideBtnInConfirmPassword.setTitleColor(UIColor.init(hexString: "9ea2ac"), for: .normal)
        
        dobController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        dobController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        dobTextField?.center = .zero
        dobTextField?.clearButtonMode = .never
        
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
//        self.navigationView.cornerDesign()
        self.navigationView.backgroundColor = .clear
        if appContants.appName == .aastha {
            self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }
//        self.view.backgroundColor = UIColor.appBackgroundColor
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
        
        
        self.updateUI()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        self.view.addGestureRecognizer(singleTap)
        
//        let receivePromoTap = UITapGestureRecognizer(target: self, action: #selector(self.receivePromoTapped))
//        self.recievePromotionalLbl.addGestureRecognizer(receivePromoTap)
//        self.recievePromotionalLbl.isUserInteractionEnabled = true
        
        if #available(iOS 10.0, *) {
            self.MobileNumberTxtf.keyboardType = .emailAddress
        } else {
            self.MobileNumberTxtf.keyboardType = .emailAddress
            // Fallback on earlier versions
        }
        
        if AppDelegate.getDelegate().supportAppleLogin == true {
            if #available(iOS 13.0, *) {
                let authorizationButton = ASAuthorizationAppleIDButton()
//                authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
//                authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchDown)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAppleIdRequest))
                authorizationButton.addGestureRecognizer(tapGesture)
                authorizationButton.cornerRadius = 10
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(50)) {
                    authorizationButton.frame = CGRect.init(x: 0, y: 0, width: self.appleLoginBgView.frame.size.width, height: 50)
                    
                }
                self.appleLoginBgView.backgroundColor = .clear
                self.appleLoginBgView.isHidden = false
                self.appleLoginBgViewHeightConstraint.constant = 50
                self.appleLoginBgViewTopConstraint.constant = 14
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
        if appContants.appName == .gac {
            self.appIconLeft.constant = (self.view.frame.width - 80)/2
        }
    }
    
    func updateUI() {
        dobTextField?.inputView = datePicker
        dobTextField?.inputAccessoryView = toolBar
        countryCodeLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.haveAnAccnt.text = "Have an account ?".localized
        self.signUpHeaderLbl.text = "Signup".localized
        self.signUpHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.SignUpBtn.setTitle("SIGN UP".localized, for: .normal)
        let signInBtnAttrString = NSAttributedString(string: "Sign-in".localized, attributes: ButtonUnderLineAttributes)
        self.SignInBtn.setAttributedTitle(signInBtnAttrString, for: .normal)
        self.SignInBtn.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        self.SignUpBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        self.showHideBtn.setTitle("Show".localized, for: UIControl.State.normal)
        //self.headLabel.text = "Create your \(String.getAppName()) Account".localized
        self.headLabel.text =  "Create Your Account".localized
        self.headLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        //        self.continueFbBtn.setTitle("Continue with Facebook".localized, for: UIControl.State.normal)
        //        self.googleSignInBtn.setTitle("Login with Google".localized, for: UIControl.State.normal)
                
        self.orLabel1.text = "OR".localized
        self.haveAnAccnt.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.orLabel1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.firstNameTxtF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.lastNameTxtF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.MobileNumberTxtf.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.phoneNumberTxtf.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.PasswordTxtF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.ConfirmPasswordTxtF.textColor = AppTheme.instance.currentTheme.cardTitleColor
        //        self.continueFbBtn.cornerDesign()
        self.SignUpBtn.cornerDesign()
        //        self.SignInBtn.cornerDesign()
        //        self.googleSignInBtn.cornerDesign()
        self.headLabel.text = "Create Your Account".localized
        
        
        self.SignUpBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        
        self.orView1DivLabel1.backgroundColor = AppTheme.instance.currentTheme.viewDivColor
        self.orView1DivLabel2.backgroundColor = AppTheme.instance.currentTheme.viewDivColor
        
        let tersmAndCondtionString = "By Continuing, you agree to \(String.getAppName())  Terms and Conditions"
        var tempTermsColor:UIColor = UIColor.init(hexString: "898B93")
        if appContants.appName == .gac {
            tempTermsColor = AppTheme.instance.currentTheme.textFieldBorderColor

        }
        let attributedString = NSMutableAttributedString(string: tersmAndCondtionString, attributes: [
            .font: UIFont.ottRegularFont(withSize: 10.0),
            .foregroundColor: tempTermsColor
        ])
        var tempConditionsColor:UIColor = UIColor(white: 1.0, alpha: 0.75)
        if appContants.appName == .aastha {
            tempConditionsColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        else if appContants.appName == .gac {
            tempConditionsColor = AppTheme.instance.currentTheme.navigationBarColor
        }
        if let range = NSString(string: tersmAndCondtionString).range(of: "Terms and Conditions", options: String.CompareOptions.caseInsensitive) as? NSRange {
            attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
            attributedString.addAttribute(.foregroundColor, value: tempConditionsColor, range: range)
            attributedString.addAttribute(.foregroundColor, value: tempConditionsColor, range: range)
        }
        /*if let range = NSString(string: tersmAndCondtionString).range(of: "Conditions", options: String.CompareOptions.caseInsensitive) as? NSRange {
            attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
            attributedString.addAttribute(.foregroundColor, value: appContants.appName == .aastha ? AppTheme.instance.currentTheme.cardTitleColor as Any : UIColor(white: 1.0, alpha: 0.75), range: range)
        }*/
        termsLbl.attributedText = attributedString
        
        firstNameTxtF.delegate = self
        firstNameTxtF.returnKeyType = .next
        
        lastNameTxtF.delegate = self
        lastNameTxtF.returnKeyType = .next
        
        MobileNumberTxtf.delegate = self
        MobileNumberTxtf.returnKeyType = .next
                
        PasswordTxtF.delegate = self
        PasswordTxtF.returnKeyType = .next
        
        ConfirmPasswordTxtF.delegate = self
        ConfirmPasswordTxtF.returnKeyType = .go
        
        dobTextField?.delegate = self
        dobTextField?.returnKeyType = .go
       
        
        countryCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.showCountriesInfoPopUp(_:)))
        countryCodeTap.delegate = self
        self.countyCodeView.addGestureRecognizer(countryCodeTap)
        

        MobileNumberTxtf.delegate = self

        continueFbBtn.isHidden = (AppDelegate.getDelegate().isFacebookLoginSupported ? false : true)
        googleSignInBtn.isHidden = (AppDelegate.getDelegate().supportGoogleLogin ? false : true)
        stackViewHeightConstraint.constant = 40
        orViewTopConstraint.constant = 16
        stackViewTopConstraint.constant = 16
        haveAccountTopConstraint.constant = 26
        termsTopConstraint.constant = 12
        orView1.isHidden = false
        if continueFbBtn.isHidden && googleSignInBtn.isHidden {
            stackViewHeightConstraint.constant = 0
            orViewTopConstraint.constant = 0
            stackViewTopConstraint.constant = 0
            haveAccountTopConstraint.constant = 0
            termsTopConstraint.constant = 6
            orView1.isHidden = true
        }
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
        if filteredarr.count > 0{
            let dict = filteredarr[0]
            self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
            self.countryCode = dict.code
        }
        else if self.countriesInfoArray.count > 0{
            let dict = self.countriesInfoArray[0]
            self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
            self.countryCode = dict.code
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
                self.countryCode = dict.code
                self.contryFlagimgView.loadingImageFromUrl(dict.iconUrl, category: "")
            } else {
                self.countryCodeLbl.text = String.init(format: "%@%@", "+","\(countryCode)")
            }
            
            self.MobileNumberTxtf.text = mobileNum
        } else {
            self.MobileNumberTxtf.text = AppDelegate.getDelegate().headerEnrichmentNum
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
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.stopAnimating()
        if viewControllerName == "PlayerVC" {
            if sender.tag == 14 {
                if self.isFromSignPage {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.popViewController(animated: true)
            } else {
                if self.isFromSignPage {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(false)
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
            self.navigationController?.popViewController(animated: true)
            //            AppDelegate .getDelegate().loadTabbar()
            //            AppDelegate .getDelegate().tabbar.selectedIndex = AppDelegate.getDelegate().selectedTabBarIndex
        }
        else if viewControllerName.isEqual(to: "PLAYERVC"){
            //            AppDelegate .getDelegate().loadTabbar()
            //            AppDelegate .getDelegate().tabbar.selectedIndex = AppDelegate.getDelegate().selectedTabBarIndex
        }
        else{
            
            for aviewcontroller : UIViewController in fromViewController
            {
                if aviewcontroller is AccountVC {
                    _ = self.navigationController?.popToViewController(aviewcontroller, animated: true)
                    break
                }
            }
            
        }
        */
    }
    func OpenUrlInWebview(urlstring : String,pageString:String) -> Void {
        
        /**/
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
        view1.urlString = urlstring
        view1.pageString = pageString
        view1.hidesBottomBarWhenPushed = true
        view1.viewControllerName = "SignUpVC"
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }
    
    
    // MARK: - Button actions
    @IBAction func SignUpAction(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        
        self.firstNameTxtF.text = self.firstNameTxtF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        self.lastNameTxtF.text = self.lastNameTxtF.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        self.MobileNumberTxtf.text = self.MobileNumberTxtf.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let password = self.PasswordTxtF.text
        //let confirmPassword = self.ConfirmPasswordTxtF.text
        var email = self.MobileNumberTxtf.text
        var phoneNumber = self.phoneNumberTxtf.text
        //var firstname = self.firstNameTextField.text
        //var lastname = self.lastNameTextField.text
        var isHeaderEnrichment = (AppDelegate.getDelegate().headerEnrichmentNum .isEmpty) ? false:true
        if self.MobileNumberTxtf.text != AppDelegate.getDelegate().headerEnrichmentNum {
            isHeaderEnrichment = false
        }
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
            if self.PasswordTxtF.text != "" || self.ConfirmPasswordTxtF.text != "" {
                
                /**/
                
                var mobileRegEx = AppDelegate.getDelegate().mobileRegExp
                mobileRegEx = mobileRegEx.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
                if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                    var firstNameMaxLength = 32
                    if fields.firstNameCharLimit != -1 {
                        firstNameMaxLength = fields.firstNameCharLimit
                    }
                    var lastNameMaxLength = 32
                    if fields.lastNameCharLimit != -1 {
                        lastNameMaxLength = fields.lastNameCharLimit
                    }
                    if fields.showFirstName == true {
                        if firstNameTxtF.text == "" {
                            self.showAlertWithText(String.getAppName(), message: "Please enter FirstName".localized)
                            return
                        }
                        else if !textFieldShouldReturn(self.firstNameTxtF, minLen: 0, maxLen: firstNameMaxLength) {
                            self.showAlertWithText(String.getAppName(), message: "First Name length should be between 0-\(firstNameMaxLength) characters".localized)
                            return
                        }
                    }
                    if fields.showLastName == true {
                        if lastNameTxtF.text == "" {
                            self.showAlertWithText(String.getAppName(), message: "Please enter LastName".localized)
                            return
                        }
                        else if !textFieldShouldReturn(self.lastNameTxtF, minLen: 0, maxLen: lastNameMaxLength) {
                            self.showAlertWithText(String.getAppName(), message: "Last Name length should be between 0-\(lastNameMaxLength) characters".localized)
                            return
                        }
                    }
                    
                    if fields.isEmailSupported == true {
                        if email == "" {
                            self.showAlertWithText(String.getAppName(), message: "Please enter Email".localized)
                            return
                        }
                        else if !(self.isValidEmail(testStr: email ?? "")) {
                            self.showAlertWithText(String.getAppName(), message: "Please enter a valid Email Id".localized)
                            return
                        }
                        else if !textFieldShouldReturn(self.MobileNumberTxtf, minLen: 6, maxLen: 50) {
                            self.showAlertWithText(String.getAppName(), message: "Email ID length should be between 6-50 characters".localized)
                            return
                        }
                    }
                    if fields.isMobileSupported == true {
                        if self.phoneNumberTxtf.text != "" && !textFieldShouldReturn(self.phoneNumberTxtf, minLen: 6, maxLen: 15) {
                            self.showAlertWithText(String.getAppName(), message: "Please enter valid Number".localized)
                            return
                        }
                        else if !(mobileRegEx .isEmpty) && mobileTest.evaluate(with: phoneNumberTxtf.text) == false{
                            self.showAlertWithText(String.getAppName(), message: "Please enter valid Number".localized)
                            return
                        }
                        if self.countryCodeLbl.text != nil {
                            phoneNumber = String.init(format: "%@%@", (self.countryCodeLbl.text?.replacingOccurrences(of: "+", with: ""))!,phoneNumber!)
                        }
                        else {
                            phoneNumber = String.init(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),phoneNumber!)
                        }
                    }
                }
                
                let string = self.PasswordTxtF.text!
                if Int((string as NSString).range(of: " ").location) != NSNotFound {
                    self.showAlertWithText(String.getAppName(), message: "Password should not contain spaces".localized)
                    return
                }
                if !textFieldShouldReturn(self.PasswordTxtF, minLen: 4, maxLen: 16) {
                    self.showAlertWithText(String.getAppName(), message: "Password length should be between 4-50 characters".localized)
                    return
                }
                
                if self.PasswordTxtF.text != self.ConfirmPasswordTxtF.text {
                    self.showAlertWithText(String.getAppName(), message: "Passwords are mismatched".localized)
                    return
                    
                }
                if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let user_fields = system_features.userfields as? FeatureAndFields, let fields = user_fields.fields as? Fields {
                    let _dob = dobTextField?.text?.trimmingCharacters(in: .whitespaces) ?? ""
                    if fields.age == 2 {
                        guard _dob.count > 0 else {
                            self.showAlertWithText(String.getAppName(), message: "Please select date of birth".localized)
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
                            self.showAlertWithText(String.getAppName(), message: "Please select gender".localized)
                            return
                        }
                    }
                }
                
                if !Utilities.hasConnectivity() {
                    self.stopAnimating()
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Sign_up_Clicks", ["User_Type":""])

                var _isFirstName = ""
                if firstNameTxtF.isHidden == false {
                    _isFirstName = firstNameTxtF.text ?? ""
                }
                var _isLastName = ""
                if lastNameTxtF.isHidden == false {
                    _isLastName = lastNameTxtF.text ?? ""
                }
                
                OTTSdk.userManager.signup(firstName:_isFirstName, lastName: _isLastName, email: email, mobile: phoneNumber, password: password!, appVersion: "1.0", referralType: nil, referralId: nil, isHeaderEnrichment: isHeaderEnrichment, socialAccountId: nil, socialAccountType: nil, dob: getDob(), gender: getGenderString(), onSuccess: { (response) in
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
                                        self.updateUI()
                                    })
                                }
                                else {
                                    TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                                        self.updateUI()
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
                                self.BackAction(UIButton())
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
                                    otpVC.isSignUpError = true
                                    otpVC.actionCode = response.actionCode
                                    
                                    if response.actionCode == 1 || response.actionCode == 2 {
                                        if !(response.details!.mobile.isEmpty){
                                            otpVC.identifier = response.details!.mobile
                                        }
                                        else{
                                            otpVC.identifier = phoneNumber
                                        }
                                    }
                                    else if response.actionCode == 3 || response.actionCode == 4{
                                        otpVC.identifier = email
                                    }
                                    
                                    otpVC.referenceId = response.details!.referenceKey
                                    if self.viewControllerName == "PlayerVC" {
                                        let topVC = UIApplication.topVC()!
                                        //                                        _ = topVC.navigationController?.popViewController(animated: false)
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
                                        otpVC.identifier = phoneNumber
                                    }
                                }
                                else if response.actionCode == 3 || response.actionCode == 4 {
                                    otpVC.identifier = email
                                }
                                let topVC = UIApplication.topVC()!
                                topVC.navigationController?.pushViewController(otpVC, animated: true)
                            }
                            break;
                        case .unKnown:
                            self.showAlertWithText(message: "Something went wrong")
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
                                self.SignUpAction(self.SignUpBtn)
                            }, onFailure: { (error) in
                                self.stopAnimating()
                                self.showAlertWithText(message: error.message as String)
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
                                    storyBoardVC.identifier = email
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
                                self.showAlertWithText(String.getAppName(), message: error.message)
                            }
                            
                        }else {
                            self.showAlertWithText(String.getAppName(), message: error.message)
                        }
                    } else {
                        self.showAlertWithText(String.getAppName(), message: error.message)
                    }
                })
            }
            else{
                showAlertWithText(message: "Please enter valid credentials!".localized)
            }
        }
    }
    
    @IBAction func SigninBtnAction(_ sender: AnyObject)
    {
        //        if self.viewControllerName == "PlayerVC" && isFromSignPage {
        //            self.dismiss(animated: true, completion: nil)
        //        } else {
        
        //Check wether SignInVC is available in stack
        if let viewControllers = self.navigationController?.viewControllers{
            for viewController in viewControllers{
                if viewController is SignInViewController{
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return;
                }
            }
        }
        
        // SignInVC is not found in stack. so create and push
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        
        let signinView = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signinView.viewControllerName = self.viewControllerName
        signinView.targetVC = self.targetVC
        signinView.accountDelegate = self.accountDelegate
        signinView.isFromSignUpPage = true
        if self.viewControllerName == "PlayerVC" {
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.pushViewController(signinView, animated: true)
        } else {
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(signinView, animated: true)
        }
        //        }
    }
    
    
    
    // MARK: - Google Button Actions
    @IBAction func googleBtnAction(_ sender: Any) {
        AppDelegate.getDelegate().socialMediaLoginStr = "Google"
        AppDelegate.getDelegate().socialMediaLoginFrom = "SignUp"
        GIDSignIn.sharedInstance().disconnect()
        GIDSignIn.sharedInstance().signIn()
    }

    // MARK: - Facebook Button Actions
    @IBAction func ContinueFBAction(_ sender: AnyObject)
    {
        /**/
        AppDelegate.getDelegate().socialMediaLoginStr = "Facebook"
        let fbmanager : LoginManager = LoginManager()
        fbmanager.logOut()
        fbmanager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if error != nil
            {
                self.printLog(log:"error" as AnyObject?)
            }
            else if(result?.isCancelled)!{
                self.printLog(log:"result cancelled" as AnyObject?)
            }
            else{
                self.printLog(log:"success Get user information." as AnyObject?)
                let fbloginresult : LoginManagerLoginResult = result!
                
//                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.startAnimating(allowInteraction: false)
                    self.getFBUserData()
//                }
                
            }
        }
    }
    func getFBUserData(){
        /*
         ["fields": "user_birthday, id, name, first_name, last_name, picture.type(large), email, user_birthday"]
         */
        if let fbAccessToken = AccessToken.current,!fbAccessToken.isExpired {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, birthday, gender,name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //                    everything works print the user data
                    self.printLog(log:"User Info : \(String(describing: result))" as AnyObject?)
                    guard let r = result as? [AnyHashable : Any] else { return }
                    let parameters = ["email" : (r["email"] as? String ?? ""),
                                      "id" : (r["id"] as? String ?? ""),
                                      "name" : (r["name"] as? String ?? ""),
                                      "login_type" : "facebook"]
                    let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
                    mobileVc.viewControllerName = self.viewControllerName as String
                    mobileVc.parameters = parameters
                    self.navigationController?.pushViewController(mobileVc, animated: true)
                    //                    var unameStr:String? = nil
                    //                    if dict["email"] != nil {
                    //                        unameStr = dict["email"] as? String
                    //                    }
                    //                    let userId = dict["id"] as! String
                    //                    let username = dict["name"] as! String
                    self.stopAnimating()
                    //                    self.signUpWithSocialAccount(uname: unameStr, userName: username, accesToken: userId,loginType: "facebook",password: "facebook")
                }else {
                    self.stopAnimating()
                    self.printLog(log: error as AnyObject?)
                }
            })
        }
        else {
            self.ContinueFBAction(continueFbBtn)
        }
    }
    
    func signUpWithSocialAccount(uname:String?, userName:String, accesToken:String,loginType:String,password:String) {
        OTTSdk.userManager.signInWithSocialAccount(loginId: accesToken, password: password, appVersion: Bundle.applicationVersionNumber, login_type: loginType, onSuccess: { (response) in
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
                        self.updateUI()
                    })
                }
                else {
                    TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                        self.updateUI()
                    })
                }
            }
//            if (OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || (OTTSdk.preferenceManager.user?.isEmailVerified)!{
                if self.viewControllerName == "PlayerVC" {
                    let button = UIButton()
                    button.tag = 14
                    self.BackAction(UIButton())
                    //                            playerVC?.view.isHidden = false
                    //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                    //                            self.dismiss(animated: true, completion: nil)
                    //                            if self.isFromSignPage {
                    //                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
                    //                                    let topVC = UIApplication.topVC()!
                    //                                    topVC.dismiss(animated: true, completion: nil)
                    //                                }
                    //                            }
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
//                            self.BackAction(UIButton())
//                        }
//                        else {
//                            AppDelegate.getDelegate().loadHomePage()
//                        }
//                    }
//                }
//                else {
//                    if self.viewControllerName == "PlayerVC" {
//                        self.BackAction(UIButton())
//                    }
//                    else {
//                        AppDelegate.getDelegate().loadHomePage()
//                    }
//                }
//            }
        }, onFailure: { (error) in
            Log(message: error.message)
            if error.code == -1000 {
                OTTSdk.userManager.signupWithSocialAccount(email: uname, userName: userName, mobile: nil, password: password, appVersion: Bundle.applicationVersionNumber, referralType: nil, referralId: nil, socialAcntId: accesToken, socialAcntType: loginType, onSuccess: { (response) in
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
                                    self.updateUI()
                                })
                            }
                            else {
                                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                                    self.updateUI()
                                })
                            }
                        }
                    }
                    if (OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! || (OTTSdk.preferenceManager.user?.isEmailVerified)!{
                        if self.viewControllerName == "PlayerVC" {
                            let button = UIButton()
                            button.tag = 14
                            self.BackAction(UIButton())
                            //                            playerVC?.view.isHidden = false
                            //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)
                            //                            self.dismiss(animated: true, completion: nil)
                            //                            if self.isFromSignPage {
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
                                    self.BackAction(UIButton())
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
                                self.BackAction(UIButton())
                            }
                            else {
                                AppDelegate.getDelegate().loadHomePage()
                            }
                        }
                    }
                    if self.viewControllerName == "PlayerVC" {
                        let button = UIButton()
                        button.tag = 14
                        self.BackAction(UIButton())
                    }
                    else {
                        AppDelegate.getDelegate().loadHomePage()
                    }
                }, onFailure: { (error) in
                    self.stopAnimating()
                    Log(message: error.message)
                    GIDSignIn.sharedInstance().signOut()
                    self.showAlertWithTextFB(message: error.message)
                })
            }
            else {
                self.stopAnimating()
                GIDSignIn.sharedInstance().signOut()
                self.showAlertWithTextFB(message: error.message)
            }
        })
    }
    
    //MARK:- Google SDK Delegates
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        signIn.signOut()
        self.stopAnimating()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.stopAnimating()
        if (error == nil) {
//            // Perform any operations on signed in user here.
//                        let userId = user.userID                  // For client-side use only!
//                        let fullName = user.profile.name
//            //            let givenName = user.profile.givenName
//            //            let familyName = user.profile.familyName
//            let email = user.profile.email
////            let idToken = user.authentication.idToken // Safe to send to the server
//
//            self.signUpWithSocialAccount(uname: email!, userName: fullName!, accesToken: userId!,loginType: "google",password: "google")
            let params = ["email" : user.profile.email ?? "",
                              "id" : user.userID ?? "",
                              "name" : user.profile.name ?? "",
                              "login_type" : "google"]
            let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
            mobileVc.viewControllerName = self.viewControllerName as String
            mobileVc.parameters = params
            self.navigationController?.pushViewController(mobileVc, animated: true)
        } else {
            Log(message: "\(error.localizedDescription)")
        }
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        self.stopAnimating()
        if (error == nil) {
            // Perform any operations on signed in user here.
//                        let userId = user.userID                  // For client-side use only!
//                        let fullName = user.profile.name
//            //            let givenName = user.profile.givenName
//            //            let familyName = user.profile.familyName
//            let email = user.profile.email
////            let idToken = user.authentication.idToken // Safe to send to the server
//
//            self.signUpWithSocialAccount(uname: email!, userName: fullName!, accesToken: userId!,loginType: "google",password: "google")
            let params = ["email" : user.profile.email ?? "",
                              "id" : user.userID ?? "",
                              "name" : user.profile.name ?? "",
                              "login_type" : "google"]
            let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
            mobileVc.viewControllerName = self.viewControllerName as String
            mobileVc.parameters = params
            self.navigationController?.pushViewController(mobileVc, animated: true)
            // ...
        } else {
            Log(message: "\(error.localizedDescription)")
        }
    }

    @IBAction func RemoveKeyboard(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if self.MobileNumberTxtf.text == "" && self.PasswordTxtF.text == "" && self.ConfirmPasswordTxtF.text == ""{
                
                self.MobileNumberTxtf.becomeFirstResponder()
            }
        }
            
        ))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertWithTextFB (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    
    @IBAction func showHidePasswordText(_ sender: UIButton) {
        /*
        if productType.iPad {
            if (ipadPasswordTxtF.text?.count)! > 0 {
                ipadPasswordTxtF.resignFirstResponder()
                if ipadPasswordTxtF.isSecureTextEntry {
                    ipadPasswordTxtF.isSecureTextEntry = false
                    self.ipadshowHideBtn.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    ipadPasswordTxtF.isSecureTextEntry = true
                    self.ipadshowHideBtn .setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
        }
        else {
            */
            if (PasswordTxtF.text?.count)! > 0 {
                PasswordTxtF.resignFirstResponder()
                if PasswordTxtF.isSecureTextEntry {
                    PasswordTxtF.isSecureTextEntry = false
                    self.showHideBtn.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    PasswordTxtF.isSecureTextEntry = true
                    self.showHideBtn.setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
      //  }
    }
    @IBAction func showHideConfirmPasswordText(_ sender: UIButton) {
     
            if (ConfirmPasswordTxtF.text?.count)! > 0 {
                ConfirmPasswordTxtF.resignFirstResponder()
                if ConfirmPasswordTxtF.isSecureTextEntry {
                    ConfirmPasswordTxtF.isSecureTextEntry = false
                    self.showHideBtnInConfirmPassword.setTitle("Hide".localized, for: UIControl.State.normal)
                }
                else{
                    ConfirmPasswordTxtF.isSecureTextEntry = true
                    self.showHideBtnInConfirmPassword.setTitle("Show".localized, for: UIControl.State.normal)
                }
            }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == firstNameTxtF {
            var firstNameMaxLength = 32
            if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
                if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                    if fields.firstNameCharLimit != -1 {
                        firstNameMaxLength = fields.firstNameCharLimit
                    }
                }
            }
            
            let newLength = (textField.text?.count)! + string.count - range.length
            return newLength <= firstNameMaxLength
        }
        else if textField == lastNameTxtF {
            var lastNameMaxLength = 32
            if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
                if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                    if fields.lastNameCharLimit != -1 {
                        lastNameMaxLength = fields.lastNameCharLimit
                    }
                }
            }
            let newLength = (textField.text?.count)! + string.count - range.length
            return newLength <= lastNameMaxLength
        }
        else if textField == MobileNumberTxtf {
            newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
//            if checkContainsCharacters(inputStr: newString as String) || checkContainsSpecialCharacters(inputString: newString)  {
//                return false
//            }
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 50
            //textField.text = newString as String
            
            //return false
            
        }else if textField == phoneNumberTxtf {
            let newLength = (textField.text?.count)! + string.count - range.length
            if newLength <= 15 {
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            }
        }
        else if textField == PasswordTxtF {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 50 // Bool
        }else if textField == ConfirmPasswordTxtF {
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 50 // Bool
        }
            
        else {
            guard let text = textField.text else { return true }
            
            let newLength = text.count + string.count - range.length
            return newLength <= 50 // Bool
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

    func checkContainsNumbers(inputStr:String) -> Bool {
        
        let decimalCharacters = CharacterSet.decimalDigits
        
        let decimalRange = inputStr.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange != nil {
            return true
        } else {
            return false
        }
    }

    func checkContainsSpecialCharacters(inputString:NSString) -> Bool {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if (inputString.rangeOfCharacter(from: characterSet.inverted).location == NSNotFound){
            return false
        }
        else {
            return true
        }
        
    }
    
    @objc func showCountriesInfoPopUp(_ sender: UITapGestureRecognizer? = nil) {
        
        
        let popvc = CountriesInfoPopupViewController()
        popvc.countriesArray = self.countriesInfoArray
        popvc.delegate = self
        self.present(popvc, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // self.printLog(log:"validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.MobileNumberTxtf {
            if #available(iOS 10.0, *) {
                self.MobileNumberTxtf.keyboardType = .emailAddress
            } else {
                self.MobileNumberTxtf.keyboardType = .emailAddress
                // Fallback on earlier versions
            }
        } else if  textField == self.PasswordTxtF{
            textField.keyboardType = .default
        }else if  textField == self.ConfirmPasswordTxtF{
            textField.keyboardType = .default
        }
    }

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
       
        if textField == self.firstNameTxtF {
            self.lastNameTxtF.becomeFirstResponder()
        }
        else if textField == self.lastNameTxtF {
            self.MobileNumberTxtf.becomeFirstResponder()
        }
        else if textField == self.MobileNumberTxtf {
            if userProfileStackView.arrangedSubviews.contains(self.mobileStackView) {
                self.phoneNumberTxtf.becomeFirstResponder()
            }
            else {
                self.PasswordTxtF.becomeFirstResponder()
            }
        }
        else if textField == self.phoneNumberTxtf {
            self.PasswordTxtF.becomeFirstResponder()
        }
        else if textField == self.PasswordTxtF {
            self.ConfirmPasswordTxtF.becomeFirstResponder()
        }
        else if textField == self.ConfirmPasswordTxtF {
            self.ConfirmPasswordTxtF.resignFirstResponder()
            self.SignUpAction(self.SignUpBtn)
        }
        return false
    }
    
    @IBAction func firstNameTextChanged(sender: AnyObject) {
        var firstNameMaxLength = 32
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
            if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                if fields.firstNameCharLimit != -1 {
                    firstNameMaxLength = fields.firstNameCharLimit
                }
            }
        }
        let firstNameTextField = sender as! UITextField
        checkMaxLength(textField: firstNameTextField, maxLength: firstNameMaxLength)
    }
    @IBAction func lastNameTextChanged(sender: AnyObject) {
        var lastNameMaxLength = 32
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures {
            if let global_settings = system_features.globalsettings, let fields = global_settings.fields as? Fields {
                if fields.lastNameCharLimit != -1 {
                    lastNameMaxLength = fields.lastNameCharLimit
                }
            }
        }
        
        let lastNameTextField = sender as! UITextField
        checkMaxLength(textField: lastNameTextField, maxLength: lastNameMaxLength)
    }
    
    @IBAction func mobileTextChanged(sender: AnyObject) {
        let mobileTextField = sender as! UITextField
        checkMaxLength(textField: mobileTextField, maxLength: 50)
    }

    @IBAction func passwordTextChanged(sender: AnyObject) {
        let pwdTextField = sender as! UITextField
        checkMaxLength(textField: pwdTextField, maxLength: 16)
    }
    @IBAction func confirmPasswordTextChanged(sender: AnyObject) {
        let pwdTextField = sender as! UITextField
        checkMaxLength(textField: pwdTextField, maxLength: 16)
    }

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text!.count > maxLength) {
            textField.deleteBackward()
        }
    }

    @objc func handleSingleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func receivePromoTapped(_ sender: UITapGestureRecognizer) {
//        self.selectCheckBoxBtn(selectCheckBoxBtn)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            /*
            if productType.iPad{
                if size.width < size.height{
                     self.iPadScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height + 100.0)
                    self.iPadScrollContentViewHeightConstraint.constant = self.view.frame.size.height + 100.0
                }
                else{
                    
                    self.iPadScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height + 300.0)
                self.iPadScrollContentViewHeightConstraint.constant = self.view.frame.size.height + 300.0
                }
            } */
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    @IBAction func termsAndConditionAction(_ sender : Any) {
        if let urlStr = Constants.OTTUrls.termsUrl {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = urlStr
            view1.pageString = "Terms & Conditions"
            view1.hidesBottomBarWhenPushed = true
            view1.viewControllerName = "SignUpVC"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
    }
}
extension SignUpViewController{
    /**/
    func countrySelected(countryObj:Country) {
        self.contryFlagimgView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countryCodeLbl.text = String.init(format: "%@%@", "+", "\(countryObj.isdCode)")
        self.countryCode = countryObj.code
    }
    
}

extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding{
    
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
        
            let params = ["email" : email,
                              "id" : userIdentifier,
                              "name" : name,
                              "login_type" : "apple"]
            let mobileVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
            mobileVc.viewControllerName = self.viewControllerName as String
            mobileVc.parameters = params
            self.navigationController?.pushViewController(mobileVc, animated: true)
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
