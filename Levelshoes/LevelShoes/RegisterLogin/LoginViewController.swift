//
//  LoginViewController.swift
//  LevelShoes
//
//  Created by apple on 4/23/20.
//  Copyright © 2020 Mayank.Bajpai. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import MBProgressHUD
import SwiftyJSON
import SkyFloatingLabelTextField
import UIKit
import STPopup
import CryptoSwift

extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
class LoginViewController: UIViewController, UITextFieldDelegate, emailPopupVCDelegate,mobilePopupVCDelegate {
    
    var isToShowMobilePopup = false
    var addresses: AddressInformation?
    var isCommingFromHomeScreen = false
    var isCommingPwdSuccessScreen = false
    typealias isAvailbleMail = (Bool?) -> Void
    @IBOutlet weak var EyeHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordError: UIImageView?
    @IBOutlet weak var emailErrorLbl: UILabel?
    @IBOutlet weak var enjoyLbl: UILabel?{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                enjoyLbl?.font = UIFont(name: "Cairo-Light", size: (enjoyLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var signinwithfbLbl: UILabel?
    @IBOutlet weak var newCustomeLbl: UILabel?{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                newCustomeLbl?.font = UIFont(name: "Cairo-SemiBold", size: (newCustomeLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var passwordMsgLbl: UILabel?
    @IBOutlet weak var signinemailLbl: UILabel?{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                signinemailLbl?.font = UIFont(name: "Cairo-SemiBold", size: (signinemailLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var forgotBtn: UIButton!{
        didSet {
            forgotBtn.setTitle("forgotPassword".localized, for: .normal)
            forgotBtn.addTextSpacingButton(spacing: 1.5)
            forgotBtn.underline()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                forgotBtn.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
            }
            
        }
    }
    @IBOutlet weak var passwordCount: UILabel!
    @IBOutlet weak var forgotBackView: UIView!
    @IBOutlet weak var passImage: UIImageView!
    @IBOutlet weak var orLbl: UILabel!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                orLbl.font = UIFont(name: "Cairo-Light", size: orLbl.font.pointSize)
            }
        }
    }
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var emailTf: RMTextField! {
        didSet {
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                emailTf.textAlignment = .left
            }else{
                emailTf.textAlignment = .right
            }
            emailTf.textColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1)
            let textString = NSMutableAttributedString(string: emailTf.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Regular", size: 16)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.5
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            emailTf.attributedText = textString
            emailTf.sizeToFit()
            
        }
    }
    @IBOutlet weak var signinLbl: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                signinLbl.addTextSpacing(spacing: 1.5)
            }else{
                signinLbl.font = UIFont(name: "Cairo-SemiBold", size: signinLbl.font.pointSize)
            }
        }
    }
    weak var emailTfnew: SkyFloatingLabelTextField!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailError: UIImageView!
    @IBOutlet weak var passWordTf: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                passWordTf.textAlignment = .left
            }else{
                passWordTf.textAlignment = .right
            }
            passWordTf.textColor = UIColor.darkGray
            let textString = NSMutableAttributedString(string: passWordTf.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 16)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.69
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            passWordTf.attributedText = textString
            passWordTf.sizeToFit()
            
        }
    }
    @IBOutlet weak var passWordView: UIView!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    {
        didSet{
            fbBtn.setBackgroundColor(color: UIColor(hexString: "264786"), forState: .highlighted)
            fbBtn.setBackgroundColor(color: UIColor(hexString: "34589D"), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                fbBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    @IBOutlet weak var registerBtn: UIButton!
    {
        didSet{
            registerBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            registerBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                registerBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    
    @IBOutlet weak var viewForShadow: UIView!
    
    let registerData = RegisterDetail()
    var errorIndex = 999
    var errorMessage = ""
    @IBOutlet weak var signInBtn: UIButton! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                signInBtn.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    
    var fbView  =   Bundle.main.loadNibNamed("FBRegistrationView", owner: self, options: nil)?.first as! FBRegistrationView
    
    
    static var storyboardInstance:LoginViewController? {
        return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: LoginViewController.identifier) as? LoginViewController
        
    }
    func firstTextFieldplaceHolder(text:String, textfieldname :UITextField)
    {
        var myMutableStringTitle = NSMutableAttributedString()
        let Name: String?  = text
        myMutableStringTitle = NSMutableAttributedString(string:Name!)
        let range = (myMutableStringTitle.string as NSString).range(of: "*")
        myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)    // Color
        textfieldname.attributedPlaceholder = myMutableStringTitle
    }
    
    func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(moveHoveScreen), name: Notification.Name(notificationName.LetGO_LOGIN_TO_HOME), object: nil)
        emailTf.tag = 10
        //        passWordTf.delegate = self
        emailTf.addTarget(self, action: #selector(didChangeTextValue), for: .editingChanged)
        passWordTf.addTarget(self, action: #selector(didChangePasswordTextValues), for: .editingChanged)
        passWordTf.addTarget(self, action: #selector(didEditPasswordTextValues), for: .editingDidBegin)
        passWordTf.addTarget(self, action: #selector(didEditEndPasswordTextValues), for: .editingDidEnd)
        passWordTf.isUserInteractionEnabled = true
        eyeBtn.contentVerticalAlignment = .center
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            emailTf.floatPlaceholderFont =  UIFont(name: "BrandonGrotesque-Light", size: 14)!
            passWordTf.floatPlaceholderFont =  UIFont(name: "BrandonGrotesque-Light", size: 14)!
        }else{
            emailTf.floatPlaceholderFont =  UIFont(name: "Cairo-Light", size: 14)!
            passWordTf.floatPlaceholderFont =  UIFont(name: "Cairo-Light", size: 14)!
        }
        
        emailTf.floatPlaceholderActiveColor = colorNames.c4747
        passWordTf.floatPlaceholderActiveColor = colorNames.c4747
        passWordTf?.floatPlaceholderColor = colorNames.c4747
        emailTf.dtLayer.backgroundColor = UIColor.clear.cgColor
        passWordTf.dtLayer.backgroundColor = UIColor.clear.cgColor
        passWordTf.dtLayer.isHidden = true
        emailTf.dtLayer.isHidden = true
        newCustomeLbl?.text = "New Customers".localized
        orLbl?.text = validationMessage.or.localized
        enjoyLbl?.text = "enjoyFasterEasierCheckout".localized
        //Return customer
        signinemailLbl?.text = "Return customer".localized
        signinwithfbLbl?.text = validationMessage.signInWithFacebook.localized
        let attributedTitle = NSAttributedString(string: "accountSignup".localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        registerBtn.setAttributedTitle(attributedTitle, for: .normal)
        let attributedTitlesecond = NSAttributedString(string: validationMessage.btnSignInWithFacebook.localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        fbBtn?.setAttributedTitle(attributedTitlesecond, for: .normal)
        let fbTitle = validationMessage.btnSignInWithFacebook.localized
        fbBtn?.setTitle(fbTitle, for: .normal)
        let attributedTitlethird = NSAttributedString(string: "SIGN IN".localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        signInBtn.setAttributedTitle(attributedTitlethird, for: .normal)
        
        
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starEmail.localized, textFieldname: emailTf, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starPassword.localized, textFieldname: passWordTf, startIndex: 0)
        //MARK:- Font Size
        emailTf.errorFont = BrandenFont.thin(with: 16.0)
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            emailTf.font = UIFont(name: "BrandonGrotesque-Regular", size: 16)
            passWordTf.font = UIFont(name: "BrandonGrotesque-Regular", size: 16)
        }else{
            
            emailTf.font =  UIFont(name: "Cairo-Regular", size: 16)
            passWordTf.font = UIFont(name: "Cairo-Regular", size: 16)
        }
        
        passWordTf.errorFont = BrandenFont.thin(with: 16.0)
        emailTf.textColor = UIColor.black
        passWordTf.textColor = UIColor.black
        passWordTf.isEnabled = true
        signinLbl.text = "SIGN IN".localized
        
    }
    
    // MARK:- TextField Delegate
    
    @objc func didChangePasswordTextValues(textField :UITextField)
    {
        
        errorIndex = 999
        registerData.password = textField.text!
        //        if passWordTf.text!.length > 0{
        //            eyeBtn.contentVerticalAlignment = .bottom
        //            eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -11, 0)
        //        }else{
        //            eyeBtn.contentVerticalAlignment = .center
        //            eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        //        }
        print("mayank :\(textField.text!)")
        // self.ischeckPassword()
        self.enablSignUpBtn()
    }
    
    @objc func didChangeTextValue(textField :UITextField)  {
        errorIndex = 999
        registerData.emailAddress = textField.text!
        
        self.ischeckemail()
        self.enablSignUpBtn()
    }
    
    @objc func didEditPasswordTextValues(textField: UITextField){
        //        if passWordTf.text!.length > 0 {
        //            eyeBtn.contentVerticalAlignment = .bottom
        //            eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -11, 0)
        //        }
        //        if passWordTf.text == "" {
        //            eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        //            eyeBtn.contentVerticalAlignment = .center
        //        }
    }
    
    @objc func didEditEndPasswordTextValues(textField: UITextField){
        //        if passWordTf.text == "" {
        //            eyeBtn.contentVerticalAlignment = .center
        //            eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        //        }
    }
    func enablSignUpBtn () {
        if emailTf.hasText && passWordTf.hasText {
            signInBtn.isEnabled = true
            signInBtn.backgroundColor = UIColor.black
        } else {
            signInBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK:- UIButton Click events
    @IBAction func onClickForgotPasswordBtn(_ sender: Any) {
        self.navigationController?.pushViewController(ResetPwdVC.storyboardInstance!, animated: true)
    }
    
    @IBAction func onClickShow(_ sender: UIButton) {
        if sender.tag == 0{
            if eyeBtn.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                eyeBtn.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                passWordTf.isSecureTextEntry = true
            }else{
                eyeBtn.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                passWordTf.isSecureTextEntry = false
            }
        }
    }
    @IBAction func onClickSignIn(_ sender: Any) {
        userLoginApi()
        print("Show popup")
        
    }
    
    
    @IBAction func onClickCrossBtn(_ sender: Any) {
        if isCommingPwdSuccessScreen {
            isCommingPwdSuccessScreen = false
            self.dismiss(animated: true, completion: nil)
        }
        else{
            closeView()
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func moveHoveScreen(_ notification:Notification){
        print("changeCategory===========")
        closeView()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button Connections
    //***********
    //MARK:-  User Registration
    @IBAction func onClickRegisterBtn(_ sender: Any) {
        let loginVC = RegistrationUserViewController.storyboardInstance!
        let transition = CATransition()
        loginVC.isCommingFromHomeScreen = self.isCommingFromHomeScreen
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    @IBAction func onClickfbBtn(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            if error != nil{
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error as Any)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let info = JSON(dataDictionary!)
                let lastName = info["last_name"].stringValue
                let email = info["email"].stringValue
                let first_name = info["first_name"].stringValue
                let fb_ID = info["id"].stringValue
                if email == "" || email == nil {
                    self.showEmailpopup(email: email, first_name :first_name, lastName: lastName , fb_ID: fb_ID)
                }else{
                    self.CheckEmailAvailbaleForRegis(email: email, first_name :first_name, lastName: lastName, fb_ID: fb_ID)
                }
            }
        }
        
    }
    func showEmailpopup(email: String, first_name :String,lastName: String, fb_ID: String) {
        let storyboard = UIStoryboard(name: "emailPopup", bundle: Bundle.main)
        let popupVC: emailPopupVC! = storyboard.instantiateViewController(withIdentifier: "emailPopupVC") as? emailPopupVC
        popupVC.emailPopupDelegate = self
        popupVC.first_name = first_name
        popupVC.lastName = lastName
        popupVC.fb_ID = fb_ID
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
        //self.navigationController?.present(popupVC, animated: true, completion: nil)
    }
    func continuousBtnAction(emailPopupVC :emailPopupVC, email:String){
        
        CheckEmailAvailbaleForRegis(email: email, first_name : emailPopupVC.first_name,lastName: emailPopupVC.lastName , fb_ID:emailPopupVC.fb_ID )
    }
    func linkCustomerAccount(emailPopupVC :emailPopupVC){
        if emailPopupVC.isRegisterUser{
            self.CallReadonlyUserApi(emil:emailPopupVC.verificationEmailAddress , fbID:emailPopupVC.fb_ID ,customerId:"")
        }else{
            getlinkCustomerAccountApiCall(emailPopupVC :emailPopupVC)
        }
        
    }
    func getlinkCustomerAccountApiCall(emailPopupVC :emailPopupVC){
        // $email, $reqOrigin, $websiteId, $providerId, $providerType
        ///V1/customers/linkcustomer
        //Turning on the Loader
        let emailEncription = encryptIt(salt: validationMessage.salt, value: emailPopupVC.verificationEmailAddress)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        let param = [
            validationMessage.keyEmail: emailEncription,
            validationMessage.website_id: getWebsiteId(),
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: emailPopupVC.fb_ID,
            validationMessage.providerType: "facebook",
            
        ] as [String : Any]
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kLinkcustomer
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Sending put request without any params. But with generated url to Magento 2.2.5
        ApiManager.apiPut(url: urlReadOnly, params: param) { (response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            //If The application is offline, then it should show the No Internet Connection Screen
            if let error = error{
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    //Presenting the no internet connection screen
                    self.present(nextVC, animated: true, completion: nil)
                    
                }
                //Hiding the Loader if screen got presented!
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            // Statuscode has been checked in the apiPut function. if statusCode is not 200 then response will come nil always. If status code is 200 then it will return one JSON type object.
            if response != nil{
                if response?.description == "true" {
                    self.getTokenApiAfterFaceBooKRegistration(emil:emailPopupVC.verificationEmailAddress, fbID:emailPopupVC.fb_ID ,customerId:"")
                    MBProgressHUD.hide(for: self.view, animated: true)
                }else{
                    let successMessage:String = response?.dictionaryObject?["message"] as? String ?? ""
                    let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:successMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    
                    //Presenting the Alert in the page.
                    self.present(alert, animated: true, completion: nil)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
                //Hiding the Loader if screen got presented!
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }
        
    }
    func CheckEmailAvailbaleForRegis(email: String, first_name :String,lastName: String ,fb_ID: String ){
        self.CheckEmailAvailbale(email: email){ (status) in
            if status == true{
                let bounds = UIScreen.main.bounds
                let width = bounds.size.width
                let height = bounds.size.height
                self.fbView._btnClose.addTarget(self, action: #selector(self.cancelRegistration), for: .touchUpInside)
                self.fbView.createBtn.addTarget(self, action: #selector(self.createRegistrationUsingFacebook), for: .touchUpInside)
                self.fbView._btnNewsOffer.addTarget(self, action: #selector(self.changeToggleUsingFacebook), for: .touchUpInside)
                self.fbView._btnNewsOffer.isSelected = UserDefaults.standard.bool(forKey: "offerNotification")
                self.fbView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                self.fbView.firstNameTF.text = first_name
                self.fbView.lastNameTF.text = lastName
                self.fbView.fb_ID = fb_ID
                
                if email != nil {
                    self.fbView.emailTF.text = email
                    self.fbView.emailTF.isUserInteractionEnabled = false
                }else{
                    self.fbView.emailTF.isUserInteractionEnabled = true
                }
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromTop
                self.view.layer.add(transition, forKey: kCATransition)
                self.view.addSubview(self.fbView)
            }else{
                if email != nil{
                    self.CallReadonlyUserApi(emil:email , fbID:fb_ID ,customerId:"")
                }
            }
        }
        
    }
    
    func setUpFBViews(){
        
    }
    
    //MARK:- Check Email Available
    
    func CheckEmailAvailbale(email: String, onCompletion: @escaping isAvailbleMail)  {
        MBProgressHUD.showAdded(to: view, animated: true)
        var emailStatus : Bool? = nil
        let params = [
            "customerEmail" : email,
            "websiteId" : getWebsiteId()
        ] as [String : Any] as [String : Any]
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.isEmailAvailable
        ApiManager.apiPostWithHeaderCode(url: url, params: params) {(response:JSON?, error:Error?, statusCode: Int ) in
            if let error = error {
                if error.localizedDescription.contains(s: "offline") {
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                }
                self.sharedAppdelegate.stoapLoader()
                return
            }
            
            if response != nil{
                if statusCode == 200  {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let info = JSON(rawValue: response!)
                    emailStatus = info?.rawValue as? Bool
                    print("emailStatus: -",emailStatus as Any)
                    onCompletion(emailStatus)
                }
                
            }
        }
    }
    
    //MARK:- Facebook functionality
    @objc func cancelRegistration() {
        print("Close Registration")
        FacebookSignInManager.logoutFromFacebook()
        animationOut()
        self.fbView.removeFromSuperview()
    }
    
    func animationOut() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.layer.add(transition, forKey: kCATransition)
    }
    
    @objc func createRegistrationUsingFacebook(){
        if self.fbView.isAllValid() {
            CallCreateUserApi()
        }
    }
    
    //MARK:- FB Toggle
    @objc func  changeToggleUsingFacebook(_ sender:UIButton){
        fbView._btnNewsOffer.isSelected = !fbView._btnNewsOffer.isSelected
        if fbView._btnNewsOffer.isSelected {
            fbView.notifyLbl?.textColor = .black
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
        } else {
            fbView.notifyLbl?.textColor = UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
        }
    }
    
    //MARK:- Facebook Registration API
    func CallCreateUserApi () {
        MBProgressHUD.showAdded(to: view, animated: true)
        let storeCode:String = UserDefaults.standard.value(forKey: validationMessage.keyStorecode) as! String
        
        let custom_attributes =    [
            [
                validationMessage.attribute_code : validationMessage.keyTelephone,
                validationMessage.value : self.fbView.mobileTF.text!
            ]
        ]
        let extension_attributes =
            [
                "is_subscribed" : self.fbView._btnNewsOffer.isSelected
            ]
        
        
        let populatedDictionary = [
            validationMessage.keyFirstname: self.fbView.firstNameTF.text!,
            validationMessage.keyLastname: self.fbView.lastNameTF.text!,
            validationMessage.keyEmail: fbView.emailTF.text!,
            "extension_attributes":extension_attributes,
            validationMessage.custom_attributes:custom_attributes
        ] as [String : Any]
        let params = [
            validationMessage.keyCustomer  : populatedDictionary
            
        ] as [String : Any]
        
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.KUserregistration
        
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
            if let error = error{
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            if response != nil{
                if statusCode == 200  {
                    //call social update api
                    let id = response!["id"].stringValue
                    self.CallSocialupdateApiRegister(faceBookView: self.fbView,customerId:id)
                    // self.getTokenApiAfterFaceBooKRegistration(email:  self.fbView.emailTF.text!)
                    //                    let popview = SuccessScreenViewController.storyboardInstance
                    //                    let transition = CATransition()
                    //                    transition.duration = 0.5
                    //                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    //                    transition.type = kCATransitionPush
                    //                    transition.subtype = kCATransitionFromTop
                    //                    self.view.layer.add(transition, forKey: kCATransition)
                    //                    self.addChildViewController(popview!)
                    //                    self.view.addSubview(popview!.view)
                    //                    self.fbView.setAllValuesNil()
                }
                if statusCode == 401  {
                    let errorMessage = response?.dictionaryValue["result"]?.stringValue
                    let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let errorMessage = response?.dictionaryValue["message"]?.stringValue
                    let alert = UIAlertController(title: CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    func conversionLoginUserToGuestUser(){
          
       let param =  ["customerId" : UserDefaults.standard.value(forKey: string.customerId) , "storeId" : UserDefaults.standard.value(forKey: string.storeId) ]
        MBProgressHUD.showAdded(to: self.view, animated: true)
       ApiManager.guestCartToLoggedUserCartConversionApiCall(params:param as [String : Any] ,success: { (response) in
             
           UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
           //UserDefaults.standard.set(nil,forKey: "quote_id_to_convert")
           DispatchQueue.main.async {
               MBProgressHUD.hide(for: self.view, animated: true)
               //self.updateCartItemsAfterInactive()
           }
          
         },failure:{
             () in
           MBProgressHUD.hide(for: self.view, animated: true)
         }
         )
          
      }
    func getTokenApiAfterFaceBooKRegistration(emil:String , fbID:String ,customerId:String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //$email, $reqOrigin, $websiteId, $providerId, $providerType
        let emailEncription = encryptIt(salt: validationMessage.salt, value: emil)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        let param = [
            validationMessage.keyEmail: emailEncription,
            validationMessage.website_id: getWebsiteId(),
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: fbID,
            validationMessage.providerType: "facebook",
        ] as [String : Any]
        
        
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kReadOnly
        ApiManager.apiGet(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                print(error)
                if error.localizedDescription.contains(s: "offline"){
                    let nextVC = NoInternetVC.storyboardInstance!
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.delegate = self
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.sharedAppdelegate.stoapLoader()
                return
            }
            if response != nil{
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let test = response?.description
                let responseDic = convertToDictionary(text: test ?? "")
                if  responseDic!["verify"] != nil  {
                    // contains key
                    //0pen popup
                    let storyboard = UIStoryboard(name: "emailPopup", bundle: Bundle.main)
                    let popupVC: emailPopupVC! = storyboard.instantiateViewController(withIdentifier: "emailPopupVC") as? emailPopupVC
                    popupVC.emailPopupDelegate = self
                    popupVC.popUpType = "verify"
                    popupVC.verificationCode = "\(responseDic!["verify"]!)"
                    // popupVC.first_name = first_name
                    //  popupVC.lastName = lastName
                    popupVC.fb_ID = fbID
                    popupVC.verificationEmailAddress = emil
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: true, completion: nil)
                } else if responseDic!["token"] != nil {
                    
                    UserDefaults.standard.set(test, forKey: string.userToken)
                    UserDefaults.standard.set(true, forKey: string.isFBuserLogin)
                    M2_isUserLogin = true
                    userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                    // UserDefaults.standard.set(response?.description, forKey: "userData")
                    self.conversionLoginUserToGuestUser()
                    let popview = SuccessScreenViewController.storyboardInstance
                    popview?.isCommingFromHomeScreen = self.isCommingFromHomeScreen
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionFromTop
                    self.view.layer.add(transition, forKey: kCATransition)
                    self.addChildViewController(popview!)
                    self.view.addSubview(popview!.view)
                    
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    //Added by Nitikesh . Dt: 02-08-2020
                    ApiManager.getCustomerInformation(success: { (response) in
                        do{
                            guard let data = response else {
                                //failure()
                                return
                            }
                            if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                                //success(address)
                                let customerId = address.id
                                let storeId = address.storeId
                                self.checkMobileNumber(userData: address)
                                UserDefaults.standard.set(customerId, forKey:"customerId")
                                UserDefaults.standard.set(storeId, forKey:"storeId")
                                UserDefaults.standard.set(address.email, forKey: "userEmail")
                                addMyWishListInLocalDb()
                            }else{
                                //failure()
                            }
                        }catch{
                            //failure()
                        }
                    }) {
                        //failure()
                    }
                }
                
            }else{
                print("something went wrong")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
    }
    //MARK:- check mobile number
    func checkMobileNumber(userData: AddressInformation){
        var mobileNo = ""
        var customAtr = userData.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                mobileNo = customAtrbt.value ?? ""
            }
        }
        if mobileNo == "" {
            showMobilepopup(userData: userData)
        }
    }
    func showMobilepopup(userData: AddressInformation) {
        let storyboard = UIStoryboard(name: "mobilepopup", bundle: Bundle.main)
        let popupVC: mobilePopupVC! = storyboard.instantiateViewController(withIdentifier: "mobilePopupVC") as? mobilePopupVC
        popupVC.mobilePopupDelegate = self
        popupVC.userData = userData
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: true, completion: nil)
    }
    func continuousBtnAction(mobilePopupVC :mobilePopupVC, mobile: String){
        //update mobile Number
        var dataDic = [String:String]()
        var userData: AddressInformation?
        if self.isToShowMobilePopup {
            self.isToShowMobilePopup = false
            userData = self.addresses
        }
        else{
            userData = mobilePopupVC.userData
        }
        
        dataDic =  ["dob":"\(userData?.dob ?? "")","salutation":"\(userData?.prefix ?? "")","firstName":"\(userData?.firstname ?? "")","lastName":"\(userData?.lastname ?? "")","mobileNo":"","emailAddress":"\(userData?.email ?? "")","gender":"\(userData?.gender)"]
        var customAtr = userData?.customAttributes ?? [CustomAttributes]()
        for customAtrbt in customAtr{
            if customAtrbt.attributeCode == "telephone"{
                dataDic["mobileNo"] = "\(mobile)"
            }
        }
        
        var dobstr = dataDic["dob"]?.replace(string: "/", replacement: "-")
        
        var paramdata =
            [
                
                "customer": [
                    "prefix": dataDic["salutation"] ,
                    "firstname": dataDic["firstName"],
                    "lastname": dataDic["lastName"] ,
                    "email":dataDic["emailAddress"] ,
                    "middlename": "",
                    "dob": dobstr,
                    "gender": "",
                    "store_id": userData?.storeId ,
                    "website_id": userData?.websiteId ,
                    "custom_attributes": [
                        [
                            "attribute_code" : "telephone",
                            "value": mobile
                        ]
                    ]
                    
                ]
                
            ] as! [String : Any]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiManager.saveChangePref(params: paramdata, success: {  (response, error)  in
            MBProgressHUD.hide(for: self.view, animated: true)
            mobilePopupVC.dismiss(animated: true, completion: nil)
            if self.isCommingFromHomeScreen {
                
                self.closeView()
                self.navigationController?.popViewController(animated: true)
                
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }) {_ in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Error".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showThankyouPopup() {
        let storyboard = UIStoryboard(name: "thanksPopup", bundle: Bundle.main)
        let popupVC: ThanksPopupVC! = storyboard.instantiateViewController(withIdentifier: "ThanksPopupVC") as? ThanksPopupVC
        popupVC.popupHeader = "Thanks".localized
        // popupVC.popupDesc = "Pass your ANy Desc Here TO see DESC"
        popupVC.popupDescHidden = true
        self.present(popupVC, animated: true, completion: nil)
        
    }
    
    //MARK:- Readonly API through Facebook
    func CallSocialupdateApiRegister(faceBookView: FBRegistrationView,customerId:String){
        // $reqOrigin, $providerId, $providerType, $customerId
        //        let superDuperSecret = "iosdev1@idslogic.com"
        let emailEncription = encryptIt(salt: validationMessage.salt, value: faceBookView.emailTF.text!)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        
        
        let param = [
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: faceBookView.fb_ID,
            validationMessage.providerType: "facebook",
            validationMessage.customerId: customerId
        ] as [String : Any]
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kSocialupdate
        ApiManager.apiGet(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
            
            if let error = error{
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if response != nil{
                self.getTokenApiAfterFaceBooKRegistration(emil:faceBookView.emailTF.text! , fbID:faceBookView.fb_ID ,customerId:customerId)
                // self.getTokenApiAfterFaceBooKRegistration(email:  self.fbView.emailTF.text!)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func CallReadonlyUserApiRegister(emil:String , fbID:String ,customerId:String){
        let emailEncription = encryptIt(salt: validationMessage.salt, value: emil)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        let param = [
            validationMessage.keyEmail: emailEncription,
            validationMessage.website_id: getWebsiteId(),
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: fbID,
            validationMessage.providerType: "facebook",
        ] as [String : Any]
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kReadOnly
        ApiManager.apiGet(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
            
            if let error = error{
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if response != nil{
                let test = response?.description
                
                let responseDic = convertToDictionary(text: test ?? "")
                if  responseDic!["verify"] != nil  {
                    // contains key
                    //0pen popup
                    let storyboard = UIStoryboard(name: "emailPopup", bundle: Bundle.main)
                    let popupVC: emailPopupVC! = storyboard.instantiateViewController(withIdentifier: "emailPopupVC") as? emailPopupVC
                    popupVC.emailPopupDelegate = self
                    popupVC.popUpType = "verify"
                    popupVC.isRegisterUser = true
                    popupVC.verificationCode = "\(responseDic!["verify"]!)"
                    // popupVC.first_name = first_name
                    //  popupVC.lastName = lastName
                    popupVC.fb_ID = fbID
                    popupVC.verificationEmailAddress = emil
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: true, completion: nil)
                } else if responseDic!["token"] != nil {
                    
                    UserDefaults.standard.set(responseDic!["token"], forKey: "userToken")
                    
                    UserDefaults.standard.set(true, forKey: string.isFBuserLogin)
                    M2_isUserLogin = true
                    userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                    self.conversionLoginUserToGuestUser()
                    // UserDefaults.standard.set(response?.description, forKey: "userData")
                    //Added by Nitikesh . Dt: 02-08-2020
                    ApiManager.getCustomerInformation(success: { (response) in
                        do{
                            guard let data = response else {
                                //failure()
                                return
                            }
                            if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                                let customerId = address.id
                                let storeId = address.storeId
                                self.checkMobileNumber(userData: address)
                                UserDefaults.standard.set(customerId, forKey:"customerId")
                                UserDefaults.standard.set(storeId, forKey:"storeId")
                                UserDefaults.standard.set(address.email, forKey: "userEmail")
                                addMyWishListInLocalDb()
                                
                            }else{
                                //failure()
                            }
                        }catch{
                            //failure()
                        }
                    }) {
                        //failure()
                    }
                    if self.isCommingFromHomeScreen {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name(notificationName.LetGO_LOGIN_TO_HOME), object: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
                
            }
        }
    }
    
    
    func CallReadonlyUserApi(emil:String , fbID:String ,customerId:String){
        
        let emailEncription = encryptIt(salt: validationMessage.salt, value: emil)
        
        let urlEncryption = encryptIt(salt: validationMessage.salt, value: getWebsiteBaseUrl(with: ""))
        
        //Parameter for read only Api.
        let param = [
            validationMessage.keyEmail: emailEncription,
            validationMessage.website_id: getWebsiteId(),
            validationMessage.reqOrigin: urlEncryption,
            validationMessage.providerId: fbID,
            validationMessage.providerType: "facebook",
        ] as [String : Any]
        
        let urlReadOnly = getWebsiteBaseUrl(with: "rest") + CommonUsed.globalUsed.kReadOnly
        
        ApiManager.apiGet(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            if response != nil {
                let test = response?.description
                
                let responseDic = convertToDictionary(text: test ?? "")
                if  responseDic!["verify"] != nil  {
                    // contains key
                    //0pen popup
                    let storyboard = UIStoryboard(name: "emailPopup", bundle: Bundle.main)
                    let popupVC: emailPopupVC! = storyboard.instantiateViewController(withIdentifier: "emailPopupVC") as? emailPopupVC
                    popupVC.emailPopupDelegate = self
                    popupVC.popUpType = "verify"
                    popupVC.isRegisterUser = false
                    popupVC.verificationCode = "\(responseDic!["verify"]!)"
                    // popupVC.first_name = first_name
                    //  popupVC.lastName = lastName
                    popupVC.fb_ID = fbID
                    popupVC.verificationEmailAddress = emil
                    popupVC.modalPresentationStyle = .overCurrentContext
                    self.present(popupVC, animated: true, completion: nil)
                } else if responseDic!["token"] != nil {
                    
                    UserDefaults.standard.set(responseDic!["token"], forKey: "userToken")
                    UserDefaults.standard.set(true, forKey: string.isFBuserLogin)
                    M2_isUserLogin = true
                    userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                    self.conversionLoginUserToGuestUser()
                    //Added by Nitikesh . Dt: 02-08-2020
                    ApiManager.getCustomerInformation(success: { (response) in
                        do {
                            guard let data = response else {
                                return
                            }
                            if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                                let customerId = address.id
                                let storeId = address.storeId
                                self.checkMobileNumber(userData: address)
                                UserDefaults.standard.set(customerId, forKey:"customerId")
                                UserDefaults.standard.set(storeId, forKey:"storeId")
                                UserDefaults.standard.set(address.email, forKey: "userEmail")
                                addMyWishListInLocalDb()
                                if self.isCommingFromHomeScreen {
                                    self.closeView()
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }else{
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                                
                            } else {}
                        } catch {}
                    }) {
                    }
                }
            }
        }
    }
    
    
    
    // MARK : UserLogin Api
    
    func userLoginApi ()
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let params = [
            "username" : emailTf.text!,
            "password" : passWordTf.text!
        ] as [String : Any] as [String : Any]
        
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.kUserLogin
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
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
                if statusCode == 200  {
                    let test = response?.description
                    UserDefaults.standard.set(test, forKey: "userToken")
                    UserDefaults.standard.set(false, forKey: string.isFBuserLogin)
                    M2_isUserLogin = true
                    userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil,forKey: "guest_carts__item_quote_id")
                    self.conversionLoginUserToGuestUser()
                    //Added by Nitikesh . Dt: 02-08-2020
                    ApiManager.getCustomerInformation(success: { (response) in
                        do{
                            guard let data = response else {
                                //failure()
                                return
                            }
                            if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                                //success(address)
                                let customerId = address.id
                                let storeId = address.storeId
                                UserDefaults.standard.set(customerId, forKey:"customerId")
                                UserDefaults.standard.set(storeId, forKey:"storeId")
                                UserDefaults.standard.set(address.email, forKey: "userEmail")
                                UserDefaults.standard.set(address.firstname, forKey: "firstname")
                                UserDefaults.standard.set(address.lastname, forKey: "lastname")
                                UserDefaults.standard.set(address.prefix, forKey: "prefix")
                                addMyWishListInLocalDb()
                                var mobileNo = ""
                                var customAtr = address.customAttributes ?? [CustomAttributes]()
                                for customAtrbt in customAtr{
                                    if customAtrbt.attributeCode == "telephone"{
                                        mobileNo = customAtrbt.value ?? ""
                                    }
                                }
                                if mobileNo == "" {
                                    self.addresses = address
                                    self.isToShowMobilePopup = true
                                    //self.showMobilepopup(userData: address) // hide this as per narayan
                                    let storyboard = UIStoryboard(name: "mobilepopup", bundle: Bundle.main)
                                    let popupVC: mobilePopupVC! = storyboard.instantiateViewController(withIdentifier: "mobilePopupVC") as? mobilePopupVC
                                    self.continuousBtnAction(mobilePopupVC: popupVC, mobile: "")
                                }else {
                                    if self.isCommingFromHomeScreen {
                                        self.closeView()
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }else{
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }else{
                                //failure()
                            }
                        }catch{
                            //failure()
                        }
                    }) {
                        //failure()
                    }
                    //  UserDefaults.standard.set(response?.description, forKey: "userData")
                    // self.NextVCMethod()
                    // self.navigationController?.popViewController(animated: true)
                }
                if statusCode == 401  {
                    let errorMessage = response?.dictionaryValue["message"]?.stringValue
                    let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }else{
                print("something went wrong")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
    }
    
    func NextVCMethod(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
        nextViewController.selectedIndex = 0
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        self.sharedAppdelegate.window?.rootViewController = self.navigationController
        self.sharedAppdelegate.window?.makeKeyAndVisible()
        self.setAllValuestoNil()
        
        
    }
    
    
    @IBAction func onClickMenu(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("")
        case 1:
            print("")
        case 2:
            
            self.tabBarController?.selectedIndex = 2
        case 3:
            print("")
        case 4:
            self.tabBarController?.selectedIndex = 4
        default:
            return
        }
    }
    func ischeckemail ()
    {
        let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.emailAddress.count == 0 {
                emailErrorLbl?.isHidden = true
                emailImage.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                emailErrorLbl?.text = errorMessage
                emailErrorLbl?.backgroundColor = .white
                emailErrorLbl?.isHidden = false
                emailImage.isHidden = false
                emailImage.image = UIImage(named: "icn_error@2x.png")
                emailTf.floatPlaceholderActiveColor = UIColor.red
            }
        }
        else
        {
            emailImage.image = UIImage(named: "Successnew")
            emailErrorLbl?.isHidden = true
            emailErrorLbl?.backgroundColor = .white
            emailTf.floatPlaceholderActiveColor =  colorNames.c4747
            emailTf?.floatPlaceholderColor = colorNames.c4747
        }
    }
    
    func ischeckPassword ()
    {
        let u_password = ValidationClass.verifyPassword(text: registerData.password)
        errorIndex = 999
        errorMessage = ""
        
        if !u_password.1 {
            if registerData.password.count == 0 {
                passwordMsgLbl?.isHidden = true
                //                passWordView?.backgroundColor = UIColor.white
                passImage?.isHidden = true
            }else{
                errorIndex = 2
                errorMessage = u_password.0
                passwordMsgLbl?.isHidden = false
                passImage.isHidden = false
                passImage.image = UIImage(named: "icn_error@2x.png")
                passWordTf.floatPlaceholderActiveColor = UIColor.red
            }
        }else{
            passImage?.image = UIImage(named: "Successnew")
            passwordError?.isHidden = true
            passwordMsgLbl?.isHidden = true
            
            passWordTf.floatPlaceholderActiveColor =  colorNames.c4747
            passWordTf?.floatPlaceholderColor = colorNames.c4747
        }
        /*
         let u_password = ValidationClass.verifyPassword(text: registerData.password)
         errorIndex = 999
         errorMessage = ""
         if !u_password.1
         {
         if registerData.password.count == 0 {
         passwordMsgLbl?.isHidden = true
         //            passWordView.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 71.0, alpha: 1.0)
         //              self.passwordCount.isHidden = true
         passImage.isHidden = true
         
         }
         else
         {
         errorIndex = 4
         errorMessage = u_password.0
         passwordMsgLbl?.text = errorMessage
         passwordMsgLbl?.isHidden = false
         passImage.isHidden = false
         //                   passWordView.backgroundColor = UIColor.red
         passImage.image = UIImage(named: "icn_error@2x.png")
         passWordTf.floatPlaceholderColor = UIColor.red
         //                   self.passwordCount.isHidden = false
         
         }
         }
         else
         {
         passImage.isHidden = false
         passImage.image = UIImage(named: "Successnew")
         passwordMsgLbl?.isHidden = true
         //                 self.passwordCount.isHidden = false
         passWordTf.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
         }
         */
    }
    
    func setAllValuestoNil ()
    {
        emailTf.text = ""
        passWordTf.text = ""
    }
    
    
    // MARK : Validation For TextField
    
    func isAllValid() -> Bool {
        var isValid = false
        let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
        let u_password = ValidationClass.verifyPassword(text: registerData.password)
        errorIndex = 999
        errorMessage = ""
        if !u_email.1 {
            errorIndex = 2
            errorMessage = u_email.0
            emailErrorLbl?.isHidden = false
            emailErrorLbl?.text = errorMessage
            emailErrorLbl?.backgroundColor = .white
        }
        else if !u_password.1
        {
            errorIndex = 4
            errorMessage = u_password.0
            passwordMsgLbl?.isHidden = false
            // passwordMsgLbl?.text = errorMessage
        }
        
        else {
            isValid = true
        }
        return isValid
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1: registerData.emailAddress = textField.text!.trimWhiteSpace
            break
        case 2: registerData.password = textField.text!.trimWhiteSpace
            
            break
        default:
            break
        }
    }
    /*
     func encrypt(){
     let secretKey = "qJB0rGtIn5UB1xG03efyCp".sha256()
     let secretIv = "qJB".sha256()
     
     let keyString: String = String(secretKey.sha256().prefix(32))
     let ivString: String = String(secretIv.sha256().prefix(16))
     
     let data = "nagrgk2@gmail.com".data(using: String.Encoding.utf8)
     
     var result = ""
     
     do {
     
     let enc = try AES(keyString: <#String#>, key: secretKey, iv: secretIv).encrypt(data!.bytes)
     let encData = NSData(bytes: enc, length: Int(enc.count))
     let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
     result = String(base64String)
     print(result)
     } catch {
     print("Error \(error)")
     }
     } */
    
    // MARK: FACEBOOK Log In Code
    
    func fetchDataFromFB(){
        if(AccessToken.current != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else { return }
                print("info",Info)
                
                if (((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String) != nil {
                    //Download image from imageURL
                }
                let json = JSON(Info)
                let height = json["picture"]["data"]["height"].intValue
                let url = json["picture"]["data"]["url"].stringValue
                let lastName = json["last_name"].stringValue
                let email = json["email"].stringValue
                let first_name = json["first_name"].stringValue
                let fb_ID = json["id"].intValue
                
                print("height",height)
                print("url",url)
                print("lastName",lastName)
                print("email",email)
                print("first_name",first_name)
                print("fb_ID",fb_ID)
            })
        }
    }
    
}
extension LoginViewController{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == emailTf {
            let characterCountLimit = 9999
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = emailTf.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            return newLength <= characterCountLimit
        }
        else if textField == passWordTf{
            let characterCountLimit = 9999
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = passWordTf.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            return newLength <= characterCountLimit
        }
        else{
            return true
        }
        
    }
}

extension LoginViewController:NoInternetDelgate{
    func didCancel() {
        self.userLoginApi()
    }
}

