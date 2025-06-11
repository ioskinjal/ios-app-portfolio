//
//  RegisterNewViewController.swift
//  LevelShoes
//
//  Created by apple on 5/16/20.
//  Copyright © 2020 Mayank Bajpai. All rights reserved.
//

import UIKit
import DTTextField
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import SwiftyJSON
import STPopup

class RegisterNewViewController: UIViewController {
     var isCommingFromHomeScreen = false
    @IBOutlet weak var fbBtn: UIButton! {
        didSet {
            fbBtn.setBackgroundColor(color: UIColor(hexString: "264786"), forState: .highlighted)
            fbBtn.setBackgroundColor(color: UIColor(hexString: "34589D"), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en" {
                fbBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
            fbBtn.setTitle("SIGN IN WITH FACEBOOK".localized, for: .normal)
        }
    }
    @IBOutlet weak var createBtn: UIButton! {
        didSet {
            createBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            createBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            createBtn.setTitle("CREATE ACCOUNT".localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                createBtn.addTextSpacing(spacing: 1.5, color: "ffffff")
            }
        }
    }
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    
    //*********** First Name declartion *************//
    @IBOutlet weak var firstNameTF: DTTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                firstNameTF.textAlignment = .left
            }else{
                firstNameTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var firstNameOuterView: UIView?
    @IBOutlet weak var firstNameImageView: UIImageView?
    @IBOutlet weak var firstNameError: UILabel?
    @IBOutlet weak var firstNameCount: UILabel?
    @IBOutlet weak var fisrtNameErrorLine: UIView?
    @IBOutlet weak var orLbl: UILabel?
    
    //*********** Last Name declartion *************//
    @IBOutlet weak var lastNameTF: DTTextField!
    {
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                lastNameTF.textAlignment = .left
            }else{
                lastNameTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lastNameOuterView: UIView?
    @IBOutlet weak var lastNameImageView: UIImageView?
    @IBOutlet weak var lastNameError: UILabel?
    @IBOutlet weak var lastNameCount: UILabel?
    @IBOutlet weak var lastNameErrorLine: UIView?
    
    //*********** Email Name declartion *************//
    @IBOutlet weak var emailTF: DTTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                emailTF.textAlignment = .left
            }else{
                emailTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var emailOuterView: UIView?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var emailError: UILabel?
    @IBOutlet weak var emailCount: UILabel?
    @IBOutlet weak var emailErrorLine: UIView?
    
    //*********** Mobile Number declartion *************//
    @IBOutlet weak var mobileTF: DTTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                mobileTF.textAlignment = .left
            }else{
                mobileTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var mobileOuterView: UIView?
    @IBOutlet weak var mobileImageView: UIImageView?
    @IBOutlet weak var mobileError: UILabel?
    @IBOutlet weak var mobileCount: UILabel?
    @IBOutlet weak var mobileErrorLine: UIView?
    
    //*********** Password declartion *************//
    @IBOutlet weak var passwordTF: DTTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                passwordTF.textAlignment = .left
            }else{
                passwordTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var passwordOuterView: UIView?
    @IBOutlet weak var passwordImageView: UIImageView?
    @IBOutlet weak var passwordError: UILabel?
    @IBOutlet weak var passwordCount: UILabel?
    @IBOutlet weak var passwordErrorLine: UIView?
    @IBOutlet weak var signwithFbLbl: UILabel?
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var notifyLbl: UILabel?
    @IBOutlet weak var createAcclbl: UILabel?
    @IBOutlet weak var byClickLbl: UILabel?
    @IBOutlet weak var termsLbl: UIButton?
    //*********** Confirm  Password declartion *************//
    
    @IBOutlet weak var confirmPassTF: DTTextField!
    {
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                confirmPassTF.textAlignment = .left
            }else{
                confirmPassTF.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var confirmPassOuterView: UIView?
    @IBOutlet weak var confirmPassImageView: UIImageView?
    @IBOutlet weak var confirmPassError: UILabel?
    @IBOutlet weak var confirmPassCount: UILabel?
    @IBOutlet weak var confirmPassBtn: UIButton!
    @IBOutlet weak var confirmPassErrorLine: UIView?
    @IBOutlet weak var registerLbl: UILabel?
    @IBOutlet weak var viewForShadow: UIView!
    
    var errorIndex = 999
    var errorMessage = ""
    var languageCode = ""
    var languageStr = ""
    let registerData = RegisterDetail()
    func firstTextFieldplaceHolder(text:String, textfieldname :UITextField)
    {
        var myMutableStringTitle = NSMutableAttributedString()
        let Name: String?  = text
        myMutableStringTitle = NSMutableAttributedString(string:Name!)
        let range = (myMutableStringTitle.string as NSString).range(of: "*")
        myMutableStringTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range:range)    // Color
        textfieldname.attributedPlaceholder = myMutableStringTitle
    }
    static var storyboardInstance:RegisterNewViewController? {
        return StoryBoard.Loginregistration.instantiateViewController(withIdentifier: RegisterNewViewController.identifier) as? RegisterNewViewController
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForShadow.addBottomShadow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }
        signwithFbLbl?.text = "Sign in with Facebook".localized
        signwithFbLbl?.isHidden = true
        createAcclbl?.text = "Create an account".localized
        byClickLbl?.text = "By clicking Create Account, you agree to our".localized
        let titleText = "registerTermConditionForAccount".localized
        termsLbl?.setTitle(titleText, for: .normal)
        createBtn?.setTitle("CREATE ACCOUNT".localized, for: .normal)
        notifyLbl?.text = "Sign up for exclusive news and personalised special offers".localized
        orLbl?.text = "Or".localized
        let attributedTitlesecond = NSAttributedString(string: "SIGN IN WITH FACEBOOK".localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        fbBtn.setAttributedTitle(attributedTitlesecond, for: .normal)
        fbBtn.isHidden = true
        languageCode = (data._source?.languageList[0].name)!
        if languageCode == "English" {
            languageStr = "en"
        }
        else{
            languageStr = "ar"
        }
        self.firstTextFieldplaceHolder(text: "Email Address *".localized, textfieldname: emailTF)
        self.firstTextFieldplaceHolder(text: "Password *".localized, textfieldname: passwordTF)
        
        self.firstTextFieldplaceHolder(text: "First Name *", textfieldname: firstNameTF  )
        self.firstTextFieldplaceHolder(text: "Last Name *", textfieldname: lastNameTF )
        self.firstTextFieldplaceHolder(text: "Mobile Number *".localized, textfieldname: mobileTF)
        self.firstTextFieldplaceHolder(text: "Confirm Password *".localized, textfieldname: confirmPassTF)
        firstNameTF?.dtLayer.isHidden = true
        lastNameTF?.dtLayer.isHidden = true
        emailTF.dtLayer.isHidden = true
        mobileTF.dtLayer.isHidden = true
        passwordTF.dtLayer.isHidden = true
        confirmPassTF.dtLayer.isHidden = true
        firstNameTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        lastNameTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        emailTF.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        mobileTF.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        passwordTF.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        confirmPassTF.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        let attributedTitlefourth = NSAttributedString(string: "REGISTER".localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.black] )
        registerLbl?.attributedText = attributedTitlefourth
        firstNameTF?.addTarget(self, action: #selector(didChangeFirstNameTextValue), for: .editingChanged)
        lastNameTF?.addTarget(self, action: #selector(didChangeLastNameTextValue), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(didChangeEmailTextValue), for: .editingChanged)
        mobileTF.addTarget(self, action: #selector(didChangeMobileTextValue), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(didChangePasswordTextValue), for: .editingChanged)
        confirmPassTF.addTarget(self, action: #selector(didChangeConfirmPasswordTextValue), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: .editingChanged Text Field//************* .editingChanged Text Field ***************//
    @objc func didChangeFirstNameTextValue(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        firstNameOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        fisrtNameErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.firstName = textField.text!
        self.ischeckFirstNamr()
        
    }
    @objc func didChangeLastNameTextValue(textField :UITextField)  {
        // self.lastNameTF.isHidden = false
        lastNameOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        lastNameErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.lastName = textField.text!
        self.ischeckLastName()
    }
    @objc func didChangeEmailTextValue(textField :UITextField)  {
        // self.emailCount.isHidden = false
        emailOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        emailErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.emailAddress = textField.text!
        self.ischeckemail()
        
    }
    @objc func didChangeMobileTextValue(textField :UITextField)  {
        //self.mobileCount.isHidden = false
        mobileOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        mobileErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.mobileNumber = textField.text!
        self.ischeckMobile()
        
    }
    @objc func didChangePasswordTextValue(textField :UITextField)  {
        // self.passwordCount.isHidden = false
        passwordOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        passwordErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.password = textField.text!
        self.ischeckPassword()
        
    }
    @objc func didChangeConfirmPasswordTextValue(textField :UITextField)  {
        // self.confirmPassTF.isHidden = false
        confirmPassOuterView?.backgroundColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
        confirmPassErrorLine?.backgroundColor = UIColor(red: 71.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        errorIndex = 999
        registerData.confirmPAssword = textField.text!
        self.ischeckConfirmPassword()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // MARK:Check on click Validation of textfield //****** Check on click Validation of textfield ***********//
    
    func ischeckemail ()
    {
        let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.emailAddress.count == 0 {
                emailError?.isHidden = true
                emailOuterView?.backgroundColor = UIColor.white
                emailImageView?.isHidden = true
                self.emailCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                emailError?.text = errorMessage
                emailError?.isHidden = false
                emailImageView?.isHidden = false
                emailErrorLine?.backgroundColor = UIColor.red
                emailImageView?.image = UIImage(named: "icn_error@2x.png")
                emailTF.floatPlaceholderActiveColor = UIColor.red
                self.emailCount?.isHidden = false
            }
        }
        else
        {
            emailImageView?.image = UIImage(named: "Successnew.png")
            emailError?.isHidden = true
            emailErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            emailTF.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.emailCount?.isHidden = false
        }
    }
    
    
    func ischeckFirstNamr ()
    {
        let u_email = ValidationClass.verifyname(text: registerData.firstName)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.firstName.count == 0 {
                firstNameError?.isHidden = true
                firstNameOuterView?.backgroundColor = UIColor.white
                firstNameImageView?.isHidden = true
                self.firstNameCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                firstNameError?.text = errorMessage
                firstNameError?.isHidden = false
                firstNameImageView?.isHidden = false
                fisrtNameErrorLine?.backgroundColor = UIColor.red
                firstNameImageView?.image = UIImage(named: "icn_error@2x.png")
                firstNameTF?.floatPlaceholderActiveColor = UIColor.red
                self.firstNameCount?.isHidden = false
            }
        }
        else
        {
            firstNameImageView?.image = UIImage(named: "Successnew.png")
            firstNameError?.isHidden = true
            fisrtNameErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            firstNameTF?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.firstNameCount?.isHidden = false
        }
    }
    
    
    func ischeckLastName ()
    {
        let u_email = ValidationClass.verifysurname(text: registerData.lastName)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.lastName.count == 0 {
                lastNameError?.isHidden = true
                lastNameOuterView?.backgroundColor = UIColor.white
                lastNameImageView?.isHidden = true
                self.lastNameCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                lastNameError?.text = errorMessage
                lastNameError?.isHidden = false
                lastNameImageView?.isHidden = false
                lastNameErrorLine?.backgroundColor = UIColor.red
                lastNameImageView?.image = UIImage(named: "icn_error@2x.png")
                lastNameTF?.floatPlaceholderActiveColor = UIColor.red
                self.lastNameCount?.isHidden = false
            }
        }
        else
        {
            lastNameImageView?.image = UIImage(named: "Successnew.png")
            lastNameError?.isHidden = true
            lastNameErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            lastNameTF?.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.lastNameCount?.isHidden = false
        }
    }
    
    
    func ischeckMobile ()
    {
        let u_email = ValidationClass.verifyPhoneNumber(text: registerData.mobileNumber)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.mobileNumber.count == 0 {
                mobileError?.isHidden = true
                mobileOuterView?.backgroundColor = UIColor.white
                mobileImageView?.isHidden = true
                self.mobileCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                mobileError?.text = errorMessage
                mobileError?.isHidden = false
                mobileImageView?.isHidden = false
                mobileErrorLine?.backgroundColor = UIColor.red
                mobileImageView?.image = UIImage(named: "icn_error@2x.png")
                mobileTF.floatPlaceholderActiveColor = UIColor.red
                self.mobileCount?.isHidden = false
            }
        }
        else
        {
            mobileImageView?.image = UIImage(named: "Successnew.png")
            mobileError?.isHidden = true
            mobileErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            mobileTF.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.mobileCount?.isHidden = false
        }
    }
    
    
    func ischeckPassword ()
    {
        let u_email = ValidationClass.verifyPassword(text: registerData.password)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.password.count == 0 {
                passwordError?.isHidden = true
                passwordOuterView?.backgroundColor = UIColor.white
                passwordImageView?.isHidden = true
                self.passwordCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                passwordError?.text = errorMessage
                passwordError?.isHidden = false
                passwordImageView?.isHidden = false
                passwordErrorLine?.backgroundColor = UIColor.red
                passwordImageView?.image = UIImage(named: "icn_error@2x.png")
                passwordTF.floatPlaceholderActiveColor = UIColor.red
                self.passwordCount?.isHidden = false
            }
        }
        else
        {
            passwordImageView?.image = UIImage(named: "Successnew.png")
            passwordError?.isHidden = true
            passwordErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            passwordTF.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.passwordCount?.isHidden = false
        }
    }
    
    func ischeckConfirmPassword ()
    {
        let u_email = ValidationClass.verifyPasswordAndConfirmPassword(password:registerData.password, confirmPassword: registerData.confirmPAssword)
        errorIndex = 999
        errorMessage = ""
        
        if !u_email.1 {
            if registerData.confirmPAssword.count == 0 {
                confirmPassError?.isHidden = true
                confirmPassOuterView?.backgroundColor = UIColor.white
                confirmPassImageView?.isHidden = true
                self.confirmPassCount?.isHidden = true
            }
            else
            {
                errorIndex = 2
                errorMessage = u_email.0
                confirmPassError?.text = errorMessage
                confirmPassError?.isHidden = false
                confirmPassImageView?.isHidden = false
                confirmPassErrorLine?.backgroundColor = UIColor.red
                confirmPassImageView?.image = UIImage(named: "icn_error@2x.png")
                confirmPassTF.floatPlaceholderActiveColor = UIColor.red
                self.confirmPassCount?.isHidden = false
            }
        }
        else
        {
            confirmPassImageView?.image = UIImage(named: "Successnew.png")
            confirmPassError?.isHidden = true
            confirmPassErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            confirmPassTF.floatPlaceholderActiveColor =  UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
            self.confirmPassCount?.isHidden = false
        }
    }
    
    //MARK:SET ALL VALUES TO NIL ***** SET ALL VALUES TO NIL ******//
    
    
    func setAllValuesNil ()
    {
        firstNameTF?.text = ""
        firstNameImageView?.isHidden = true
        firstNameCount?.isHidden = true
        firstNameOuterView?.backgroundColor = .white
        lastNameTF?.text = ""
        lastNameImageView?.isHidden = true
        lastNameCount?.isHidden = true
        lastNameOuterView?.backgroundColor = .white
        emailTF.text = ""
        emailImageView?.isHidden = true
        emailCount?.isHidden = true
        emailOuterView?.backgroundColor = .white
        passwordTF.text = ""
        passwordImageView?.isHidden = true
        passwordCount?.isHidden = true
        passwordOuterView?.backgroundColor = .white
        mobileTF.text = ""
        mobileImageView?.isHidden = true
        mobileCount?.isHidden = true
        mobileOuterView?.backgroundColor = .white
        confirmPassTF.text = ""
        confirmPassImageView?.isHidden = true
        confirmPassCount?.isHidden = true
        confirmPassOuterView?.backgroundColor = .white
    }
    
    
    func isAllValid() -> Bool {
        var isValid = false
        let u_first_name = ValidationClass.verifyFirstname(text: registerData.firstName)
        let u_last_name = ValidationClass.verifyLastname(text: registerData.lastName)
        let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
        let u_contact = ValidationClass.verifyPhoneNumber(text: registerData.mobileNumber)
        let u_password = ValidationClass.verifyPassword(text: registerData.password)
        let u_confirm_pass = ValidationClass.verifyPasswordAndConfirmPassword(password: registerData.password, confirmPassword: registerData.confirmPAssword)
        errorIndex = 999
        errorMessage = ""
        
        if !u_first_name.1 {
            errorIndex = 0
            errorMessage = u_first_name.0
            firstNameError?.isHidden = false
            firstNameError?.text = errorMessage
            fisrtNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            firstNameImageView?.isHidden = false
            firstNameCount?.isHidden = false
        } else if !u_last_name.1 {
            errorIndex = 1
            errorMessage = u_last_name.0
            lastNameError?.isHidden = false
            lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            lastNameError?.text = errorMessage
            lastNameImageView?.isHidden = false
            lastNameCount?.isHidden = false
        }
        else if !u_email.1 {
            errorIndex = 2
            errorMessage = u_email.0
            emailError?.isHidden = false
            emailError?.text = errorMessage
            lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            emailImageView?.isHidden = false
            emailCount?.isHidden = false
        }
        else if !u_contact.1 {
            errorIndex = 3
            errorMessage = u_contact.0
            mobileError?.isHidden = false
            mobileError?.text = errorMessage
            mobileErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            mobileImageView?.isHidden = false
            mobileCount?.isHidden = false
        }
        else if !u_password.1 {
            errorIndex = 4
            errorMessage = u_password.0
            passwordError?.isHidden = false
            passwordError?.text = errorMessage
            passwordErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            passwordImageView?.isHidden = false
            passwordCount?.isHidden = false
        }  else if !u_confirm_pass.1 {
            errorIndex = 5
            errorMessage = u_confirm_pass.0
            confirmPassError?.isHidden = false
            confirmPassErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            confirmPassError?.text = errorMessage
            confirmPassImageView?.isHidden = false
            confirmPassCount?.isHidden = false
        } else {
            isValid = true
        }
        
        return isValid
    }
    
    // MARK:on CLick Button Cal //******************** on CLick Button Call **************************************//
    @IBAction func onCLickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onClickCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onClickShow(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                passwordTF.isSecureTextEntry = true
            }else{
                sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                passwordTF.isSecureTextEntry = false
            }
        }
    }
    @IBAction func onCLickFbBtn(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        if AccessToken.current != nil{
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Move to Another VC")
        }
        else{
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email", "public_profile", "user_birthday"], from: self)
            { loginResult, error in
               // print("Result",loginResult as Any)
                MBProgressHUD.hide(for: self.view, animated: true)
                if ((error) != nil){
                    print("Process error", error?.localizedDescription as Any)
                }
                else if loginResult!.isCancelled {
                    print("Cancelled")
                }
                else{
                    print(loginResult?.token as Any)
                    if (loginResult?.grantedPermissions.contains("email"))! {
                        print(loginResult as Any);
                        self.navigationController?.pushViewController(LatestHomeViewController.storyboardInstance!, animated: true)
                        self.fetchDataFromFB()
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func onClickShowSecond(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                sender.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                confirmPassTF.isSecureTextEntry = true
            }else{
                sender.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                confirmPassTF.isSecureTextEntry = false
            }
        }
    }
    
    @IBAction func onClickNotify(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "ic_switch_on"){
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
        }
    }
    @IBAction func onClickCreateBtn(_ sender: Any) {
        self.view.endEditing(true)
        if isAllValid() {
            CallCreateUserApi()
        }
    }
    
    
    
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
    
    
    //MARK:- Registration Api
    func CallCreateUserApi ()
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        let storeCode:String = UserDefaults.standard.value(forKey: "storecode") as! String
        let finalStr = storeCode + "_" + languageStr
        let populatedDictionary = ["firstname":registerData.firstName, "lastname":registerData.lastName, "email" :registerData.emailAddress, "phone": registerData.mobileNumber]
        let params = [
            "customer"  : populatedDictionary,
            "password" : registerData.password as Any
            ] as [String : Any]
        
        
        let url = getWebsiteBaseUrl(with: "rest")  + getM2StoreCode() + "/" + CommonUsed.globalUsed.KUserregistration
        
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
            if let error = error{
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            if response != nil{
                if statusCode == 200  {
                    let popupController = STPopupController.init(rootViewController: SuccessScreenViewController.storyboardInstance!)
                    popupController.style = .bottomSheet
                    popupController.present(in: self)
                    popupController.hidesCloseButton = true
                    popupController.setNavigationBarHidden(true, animated: true)
                    self.setAllValuesNil()
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
}

extension RegisterNewViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTF{
            let characterCountLimit = 999
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.firstNameCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
            
        }else if textField == lastNameTF{
            let characterCountLimit = 999
            
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.lastNameCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else if textField == emailTF{
            let characterCountLimit = 999
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.emailCount?.text = "\(newLength)/1000"
            return newLength <= characterCountLimit
        }
        else if textField == mobileTF{
            let characterCountLimit = 9
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.mobileCount?.text = "\(newLength)/10"
            return newLength <= characterCountLimit
        }
        else if textField == passwordTF{
            let characterCountLimit = 999
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.passwordCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else if textField == confirmPassTF{
            let characterCountLimit = 999
            // We need to figure out how many characters would be in the string after the change happens
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            //        self.confirmPassCount?.text = "\(newLength)/20"
            return newLength <= characterCountLimit
        }
        else{
            return true
        }
    }
}

