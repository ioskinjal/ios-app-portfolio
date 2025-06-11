//
//  ChangeMobileNumberVC.swift
//  OTT
//
//  Created by Pramodkumar on 16/09/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import MaterialComponents

class ChangeMobileNumberVC: UIViewController {
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var navigationView : UIView!
    @IBOutlet weak var headerLbl : UILabel!
    @IBOutlet weak var currentMobileNumTf : MDCTextField!
    @IBOutlet weak var newMobileNumTf : MDCTextField!
    @IBOutlet weak var newEmailTf : MDCTextField!
    @IBOutlet weak var continueButton : UIButton!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var mainStackView : UIStackView!
    @IBOutlet var mobileView : UIView!
    @IBOutlet var emailView : UIView!
    @IBOutlet weak var countyCodeView: UIView!
    @IBOutlet weak var countryImageView : UIImageView!
    @IBOutlet weak var countryDropDownimgView : UIImageView!
    @IBOutlet weak var countNumberLbl : UILabel!
    var countriesInfoArray = [Country]()
    var mobileController: MDCTextInputControllerOutlined?
    var newMobileController: MDCTextInputControllerOutlined?
    var emailController: MDCTextInputControllerOutlined?
    var typeView = ViewType.mobileNumber
    var countryCode = ""
    enum ViewType {
        case mobileNumber, email
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        headerLbl.text = "Change Mobile Number".localized
        headerLbl.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        descLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        descLbl.isHidden = false
        if let user = OTTSdk.preferenceManager.user {
            currentMobileNumTf.text = user.phoneNumber
            mainStackView.removeArrangedSubview(emailView)
            emailView.removeFromSuperview()
            mainStackView.removeArrangedSubview(mobileView)
            mobileView.removeFromSuperview()
            if typeView == .email {
                currentMobileNumTf.text = user.email
//                descLbl.isHidden = true
                headerLbl.text = "Change email address".localized
                currentMobileNumTf.placeholder = "Current email"
                newEmailTf.placeholder = "New email"
                mainStackView.addArrangedSubview(emailView)
            }else {
                mainStackView.addArrangedSubview(mobileView)
//                if appContants.appName == .reeldrama || appContants.appName == .aastha {
//                    descLbl.isHidden = true
//                }
            }
        }
        
        if typeView == .email {
            if let fields = AppDelegate.otpAuthenticationFields,  fields.verify_otp_for_email_update == true {
                if fields.verification_type_for_email_update == "email" {
                    descLbl.text = "An OTP will be sent to your email id for verification"
                }else {
                    descLbl.text = "An OTP will be sent to your mobile number for verification"
                }
            }else {
                descLbl.isHidden = true
            }
        }else if typeView == .mobileNumber {
            if let fields = AppDelegate.otpAuthenticationFields,  fields.verify_otp_for_mobile_update == true {
                if fields.verification_type_for_mobile_update == "email" {
                    descLbl.text = "An OTP will be sent to your email id for verification"
                }else {
                    descLbl.text = "An OTP will be sent to your mobile number for verification"
                }
            }else {
                descLbl.isHidden = true
            }
        }else {
            descLbl.isHidden = true
        }
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
    private func setupUI() {
        countryDropDownimgView.image = #imageLiteral(resourceName: "country_dropdown_icon").withRenderingMode(.alwaysTemplate)
        countryDropDownimgView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        countNumberLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        continueButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        containerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        continueButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        continueButton.cornerDesignWithoutBorder()
        continueButton.setTitle("Continue".localized, for: .normal)
        continueButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        currentMobileNumTf.font = UIFont.ottRegularFont(withSize: 14)
        newMobileNumTf.font = UIFont.ottRegularFont(withSize: 14)
        newEmailTf.font = UIFont.ottRegularFont(withSize: 14)
        
        countyCodeView.viewBorderWidthWithTwo(color: .lightGray, isWidthOne: true)
        countyCodeView.backgroundColor = .clear
        
        mobileController = MDCTextInputControllerOutlined(textInput: currentMobileNumTf)
        mobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        mobileController?.textInput?.textColor = AppTheme.instance.currentTheme.textFieldBorderColor
        currentMobileNumTf.center = .zero
        currentMobileNumTf.clearButtonMode = .never
        
        newMobileController = MDCTextInputControllerOutlined(textInput: newMobileNumTf)
        newMobileController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newMobileController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newMobileController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newMobileController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        newMobileController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        newMobileNumTf.center = .zero
        newMobileNumTf.clearButtonMode = .never
        
        emailController = MDCTextInputControllerOutlined(textInput: newEmailTf)
        emailController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        emailController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        emailController?.textInput?.clearButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        newEmailTf.center = .zero
        newEmailTf.clearButtonMode = .whileEditing
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        updateLocation()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newEmailTf.resignFirstResponder()
        newMobileNumTf.resignFirstResponder()
    }
    private func updateLocation() {
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
        self.countriesInfoArray = AppDelegate.getDelegate().countriesInfoArray
        let predicate = NSPredicate(format: "code == %@", AppDelegate.getDelegate().countryCode)
        let filteredarr = self.countriesInfoArray.filter { predicate.evaluate(with: $0) };
        if filteredarr.count > 0{
            let dict = filteredarr[0]
            self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
            self.countryCode = dict.code
        }
        else if self.countriesInfoArray.count > 0{
            let dict = self.countriesInfoArray[0]
            self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
            self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
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
                self.countNumberLbl.text = String.init(format: "%@%@", "+","\(dict.isdCode)")
                self.countryCode = dict.code
                self.countryImageView.loadingImageFromUrl(dict.iconUrl, category: "")
            } else {
                self.countNumberLbl.text = String.init(format: "%@%@", "+","\(countryCode)")
            }
            self.newMobileNumTf.text = mobileNum
        } else {
            self.newMobileNumTf.text = AppDelegate.getDelegate().headerEnrichmentNum
        }
    }
    @IBAction func backAction(_ sender : Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func continueAction(_ sender : Any) {
        newEmailTf.resignFirstResponder()
        newMobileNumTf.resignFirstResponder()
        if typeView == .email {
            guard let email = newEmailTf.text, email.count > 0 else {
                errorAlert(forTitle: String.getAppName(), message: "Please enter Email".localized, needAction: false) { (flag) in }
                return
            }
            guard email.validateEmail() else {
                errorAlert(forTitle: String.getAppName(), message: "Please enter a valid Email Id".localized, needAction: false) { (flag) in }
                return
            }
            self.startAnimating(allowInteraction: false)
            OTTSdk.userManager.changeMobileOrEmailAddress(newEmail: email, newMobile: nil, onSuccess: { (response) in
                OTTSdk.userManager.userInfo(onSuccess: { (message) in }, onFailure: { (error) in })

                self.stopAnimating()
                self.errorAlert(forTitle: String.getAppName(), message: response.message, needAction: false) { (flag) in
                    if response.statusCode == 2 ||  response.statusCode == 4 {
                        self.gotoOTPScreen(value: email, targetType: response.targetType, target: response.target, referenceID: response.referenceId, actionCode: response.statusCode,context: response.context)
                    }
                    else {
                        OTTSdk.userManager.userInfo(onSuccess: { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }) { (error) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }) { (error) in
                self.stopAnimating()
                self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
            }
        }else {
            guard let number = newMobileNumTf.text, number.count > 0 else {
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

            var phoneNumber = number
            if countNumberLbl.text != nil {
                phoneNumber = String(format: "%@%@", (countNumberLbl.text?.replacingOccurrences(of: "+", with: ""))!,phoneNumber)
            }else {
                phoneNumber = String(format: "%@%@", ("".replacingOccurrences(of: "+", with: "")),phoneNumber)
            }
            self.startAnimating(allowInteraction: false)
            OTTSdk.userManager.changeMobileOrEmailAddress(newEmail: nil, newMobile: phoneNumber, onSuccess: { (response) in
                self.stopAnimating()
                self.errorAlert(forTitle: String.getAppName(), message: response.message, needAction: true) { (flag) in
                    if response.statusCode == 2 || response.statusCode == 4 {
                        self.gotoOTPScreen(value: phoneNumber, targetType: response.targetType, target: response.target, referenceID: response.referenceId, actionCode: response.statusCode,context: response.context)
                    }
                    else {
                        OTTSdk.userManager.userInfo(onSuccess: { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }) { (error) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }) { (error) in
                self.stopAnimating()
                self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
            }
        }
    }
    func gotoOTPScreen(value : String, targetType : String, target : String,referenceID:Int,actionCode:Int,context:String) {
        let otpVC = TargetPage.otpViewController()
        otpVC.otpSent = true
        otpVC.isSignUpError = false
        otpVC.isSignInError = false
        otpVC.actionCode = actionCode
        otpVC.targetType = targetType
        otpVC.target = target
        otpVC.context = context
        otpVC.viewControllerName = "ChangeMobile"
        otpVC.identifier = value
        otpVC.referenceID = referenceID
        navigationController?.pushViewController(otpVC, animated: true)
    }
    @IBAction func showCountriesInfoPopUp(_ sender: Any) {
        self.view.endEditing(true)
        if self.countriesInfoArray.count > 0 {
            let popvc = CountriesInfoPopupViewController()
            popvc.countriesArray = self.countriesInfoArray
            popvc.delegate = self
            self.present(popvc, animated: true, completion: nil)
        }
    }
}
extension ChangeMobileNumberVC : CountySelectionProtocol {
    func countrySelected(countryObj: Country) {
        countryImageView.loadingImageFromUrl(countryObj.iconUrl, category: "")
        self.countNumberLbl.text = String.init(format: "%@%@", "+", "\(countryObj.isdCode)")
        self.countryCode = countryObj.code
    }
}
extension ChangeMobileNumberVC : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == newMobileNumTf {
            if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                return false
            }
            let final = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return final.count <= 15
        }
        return true
    }
}
extension ChangeMobileNumberVC : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
