//
//  FBRegistrationView.swift
//  LevelShoes
//
//  Created by Maa on 17/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField

class FBRegistrationView: UIView {
    var fb_ID :String = ""
    @IBOutlet weak var txtIsdcode: UITextField!
    @IBOutlet weak var btnTC: UIButton!
    @IBOutlet weak var backGroundVieew: UIView!
    
    @IBOutlet weak var firstNameTF: DTTextField!
    @IBOutlet weak var firstNameOuterView: UIView?
    @IBOutlet weak var firstNameImageView: UIImageView?
    @IBOutlet weak var firstNameError: UILabel?
    @IBOutlet weak var firstNameCount: UILabel?
    @IBOutlet weak var fisrtNameErrorLine: UIView?
    
    //*********** Last Name declartion *************//
    @IBOutlet weak var lastNameTF: DTTextField!
    @IBOutlet weak var lastNameOuterView: UIView?
    @IBOutlet weak var lastNameImageView: UIImageView?
    @IBOutlet weak var lastNameError: UILabel?
    @IBOutlet weak var lastNameCount: UILabel?
    @IBOutlet weak var lastNameErrorLine: UIView?
    
    //*********** Email Name declartion *************//
    @IBOutlet weak var emailTF: DTTextField!
    @IBOutlet weak var emailOuterView: UIView?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var emailError: UILabel?
    @IBOutlet weak var emailCount: UILabel?
    @IBOutlet weak var emailErrorLine: UIView?
    
    //*********** Mobile Number declartion *************//
    @IBOutlet weak var mobileTF: DTTextField!
    @IBOutlet weak var mobileOuterView: UIView?
    @IBOutlet weak var mobileImageView: UIImageView?
    @IBOutlet weak var mobileError: UILabel?
    @IBOutlet weak var mobileCount: UILabel?
    @IBOutlet weak var mobileErrorLine: UIView?
    
    
    @IBOutlet weak var notifyLbl: UILabel?
    @IBOutlet weak var createAcclbl: UILabel?
    @IBOutlet weak var byClickLbl: UILabel?
    @IBOutlet weak var termsLbl: UIButton?
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var _btnClose: UIButton!
    @IBOutlet weak var _btnNewsOffer: UIButton!{
        didSet{
            
        }
    }
    @IBOutlet weak  var scrollView: UIScrollView!
    @IBOutlet weak var ConstHeight: NSLayoutConstraint!
    
    @IBOutlet weak var registerLbl: UILabel?
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    
    @IBOutlet weak var createBtn: UIButton!
        {
        didSet{
            createBtn.setBackgroundColor(color: UIColor(hexString: "424242"), forState: .highlighted)
            createBtn.setBackgroundColor(color: UIColor(hexString: "000000"), forState: .normal)
            createBtn.setTitle(validationMessage.btnCreateAccount.localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                createBtn.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            }
        }
    }
    
    //MARK:- Normal Variable
    var errorIndex = 999
    var errorMessage = ""
    var languageCode = ""
    var languageStr = ""
    let registerData = RegisterDetail()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        xibSetup()
        _btnNewsOffer.underlinesButton()
        setupTextFieldPlaceHolder()
    }
    func xibSetup(){
        createAcclbl?.text = validationMessage.createAccount.localized
        notifyLbl?.text = validationMessage.signUpNewsAndPersonalised.localized
        byClickLbl?.text = validationMessage.aggremntForAccount.localized
        let titleText = validationMessage.termConditionForAccount.localized
        termsLbl?.setTitle(titleText, for: .normal)
                languageCode = (data._source?.languageList[0].name)!
                if languageCode == validationMessage.languegeEng {
                    languageStr = "en"
                }
                else{
                    languageStr = "ar"
                }
        
        setupTextFieldLayer()
        setupFont()
        setupSelectorMethed()
        let attributedTitlefourth = NSAttributedString(string: validationMessage.btnRegister.localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.black] )
        registerLbl?.attributedText = attributedTitlefourth
    }
    func setupTextFieldPlaceHolder(){
        
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starEmail.localized, textFieldname: emailTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starFirstName.localized, textFieldname: firstNameTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starLastName.localized, textFieldname: lastNameTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starMobileNum.localized, textFieldname: mobileTF, startIndex: 0)
        firstNameTF.isUserInteractionEnabled = false
        lastNameTF.isUserInteractionEnabled = false
        
    }
    func setupTextFieldLayer(){
        firstNameTF?.dtLayer.isHidden = true
        lastNameTF?.dtLayer.isHidden = true
        emailTF?.dtLayer.isHidden = true
        mobileTF?.dtLayer.isHidden = true
    }
    
    //MARK:- Setup Font
    func setupFont(){
        firstNameTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        lastNameTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        emailTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
        mobileTF?.floatPlaceholderFont = BrandenFont.thin(with: 16.0)
    }
    
    //MARK:- Setup Selector
    func setupSelectorMethed(){
        firstNameTF?.addTarget(self, action: #selector(didChangeFirstNameTextValue), for: .editingChanged)
        lastNameTF?.addTarget(self, action: #selector(didChangeLastNameTextValue), for: .editingChanged)
        emailTF?.addTarget(self, action: #selector(didChangeEmailTextValue), for: .editingChanged)
        mobileTF?.addTarget(self, action: #selector(didChangeMobileTextValue), for: .editingChanged)
    }
    
    //MARK:- Selector Metheds
    
    //MARK: First Name Selector
    @objc func didChangeFirstNameTextValue(textField :UITextField)  {
        //  self.firstNameCount.isHidden = false
        firstNameOuterView?.backgroundColor = colorNames.textOuterView
        //        firstNameOuterView?.backgroundColor = UIColor(hexString: colorHexaCode.addTextSpacing)
        fisrtNameErrorLine?.backgroundColor = colorNames.errorTextField
        errorIndex = 999
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space First name ",textString)
            registerData.firstName = textString
            
        }
        //        registerData.firstName = textField.text!
        self.ischeckFirstNamr()
        
    }
    
    //MARK:- Last Name Selector
    
    @objc func didChangeLastNameTextValue(textField :UITextField)  {
        // self.lastNameTF.isHidden = false
        lastNameOuterView?.backgroundColor = colorNames.textOuterView
        lastNameErrorLine?.backgroundColor = colorNames.errorTextField
        errorIndex = 999
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space Last name ",textString)
            registerData.lastName = textString
            //                   self.ischeckLastName()
        }
        //        registerData.lastName = textField.text!
        self.ischeckLastName()
    }
    
    //MARK: Email Selector Methed
    
    @objc func didChangeEmailTextValue(textField :UITextField)  {
        // self.emailCount.isHidden = false
        emailOuterView?.backgroundColor = colorNames.textOuterView
        emailErrorLine?.backgroundColor = colorNames.errorTextField
        errorIndex = 999
        guard let text = textField.text else { return }
        let trimmedString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString != "" {
            print("White space Email ",trimmedString)
            registerData.emailAddress = trimmedString
        }
        //        registerData.emailAddress = textField.text!
        self.ischeckemail()
        
    }
    //MARK:- MObile Selector
    @objc func didChangeMobileTextValue(textField :UITextField)  {
        //self.mobileCount.isHidden = false
        mobileOuterView?.backgroundColor = colorNames.textOuterView
        mobileErrorLine?.backgroundColor = colorNames.errorTextField
        errorIndex = 999
        guard let text = textField.text else { return }
        let trimmedString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString != "" {
            print("White space Mobile ",trimmedString)
            registerData.mobileNumber = trimmedString
        }
        //        registerData.mobileNumber = textField.text!
        self.ischeckMobile()
        print(registerData.mobileNumber)
        
        
    }
    
    //MARK:- Validation Conditions
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
            emailImageView?.image = UIImage(named: "Successnew")
            emailError?.isHidden = true
            emailErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            emailTF.floatPlaceholderActiveColor =  colorNames.ErrorLineBGColor
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
            firstNameImageView?.image = UIImage(named: "Successnew")
            firstNameError?.isHidden = true
            fisrtNameErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            firstNameTF?.floatPlaceholderActiveColor =  colorNames.ErrorLineBGColor
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
        }else{
            
            lastNameImageView?.image = UIImage(named: "Successnew")
            lastNameError?.isHidden = true
            lastNameErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            lastNameTF?.floatPlaceholderActiveColor = colorNames.ErrorLineBGColor
            self.lastNameCount?.isHidden = false
        }
    }
    
    //MARK:- Check Mobile
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
        }else{
            mobileImageView?.image = UIImage(named: "Successnew")
            mobileError?.isHidden = true
            mobileErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            mobileTF.floatPlaceholderActiveColor = colorNames.ErrorLineBGColor
            self.mobileCount?.isHidden = false
        }
    }
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
        mobileTF.text = ""
        mobileImageView?.isHidden = true
        mobileCount?.isHidden = true
        mobileOuterView?.backgroundColor = .white
    }
    
    //MARK:- Validate Text Field
    
    func isAllValid() -> Bool {
        var isValid = false
        print(registerData.firstName)
        print(registerData.lastName)
        print(registerData.emailAddress)
        print(registerData.mobileNumber)
        print(registerData.password)
        print(registerData.confirmPAssword)
        
        
        let u_first_name = ValidationClass.verifyFirstname(text: firstNameTF.text!)
        let u_last_name = ValidationClass.verifyLastname(text: lastNameTF.text!)
        let u_email = ValidationClass.verifyEmail(text: emailTF.text!)
        let u_contact = ValidationClass.verifyPhoneNumber(text: mobileTF.text!)
        errorIndex = 999
        errorMessage = ""
        //Don't  delete below code
        
//        guard u_first_name.1 as Bool else { return false }
//        errorIndex = 0
//        errorMessage = u_first_name.0
//        firstNameError?.isHidden = false
//        firstNameError?.text = errorMessage
//        fisrtNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        firstNameImageView?.isHidden = false
//        firstNameCount?.isHidden = false
//
//        guard u_last_name.1 as Bool else {
//            return false
//        }
//        errorIndex = 1
//        errorMessage = u_last_name.0
//        lastNameError?.isHidden = false
//        lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//        lastNameError?.text = errorMessage
//        lastNameImageView?.isHidden = false
//        lastNameCount?.isHidden = false
        
        guard u_email.1 as Bool else {
            errorMessage = u_contact.0
            emailError?.isHidden = false
            emailError?.text = errorMessage
            emailErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            emailImageView?.isHidden = false
            return false
        }
        errorIndex = 2
        errorMessage = u_email.0
        emailError?.isHidden = false
        emailError?.text = errorMessage
//        emailErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        emailImageView?.isHidden = true
        emailCount?.isHidden = false
        
        guard u_contact.1 else {
            errorMessage = u_contact.0
            mobileError?.isHidden = false
            mobileError?.text = errorMessage
            mobileErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            mobileImageView?.isHidden = false
            return false
        }
        
        errorIndex = 3
        errorMessage = u_contact.0
        mobileError?.isHidden = true
        mobileError?.text = errorMessage
//        mobileErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        mobileImageView?.isHidden = true
        mobileCount?.isHidden = false
        
        
        isValid = true
        
        return isValid
    }
    
    
}
