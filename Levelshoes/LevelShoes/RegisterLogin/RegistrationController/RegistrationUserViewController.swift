//
//  RegistrationUserViewController.swift
//  LevelShoes
//
//  Created by Maa on 14/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import SwiftyJSON
import STPopup

class RegistrationUserViewController: UIViewController, UIScrollViewDelegate,emailPopupVCDelegate, mobilePopupVCDelegate {
     var isCommingFromHomeScreen = false
    
    @IBOutlet weak var btnterms: UIButton!{
        didSet{
            self.btnterms.border(side: .bottom, color: .black, borderWidth: 1.0)
            
        }
    }
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var orView: UIView!
    
    @IBOutlet weak var lblCountry: UILabel!{
        didSet{
            lblCountry.text = "Coutry Code*".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblCountry.font = UIFont(name: "Cairo-Light", size: lblCountry.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblTopHeader: UILabel!{
        didSet{
            lblTopHeader.addTextSpacing(spacing: 1.5)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTopHeader.font = UIFont(name: "Cairo-SemiBold", size: lblTopHeader.font.pointSize)
            }
        }
    }
    var tagNo = 0
    var fixedCC = "0"
    var countryData =  Common.sharedInstance.countryCodeList()
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                txtCountryCode.textAlignment = .left
            }else{
                txtCountryCode.font =  UIFont(name: "Cairo-Regular", size: 16)
                txtCountryCode.textAlignment = .right
            }
        }
    }
    var countryCheck = "Arabic"
    @IBOutlet weak var scrollViews: UIScrollView!
    
    //************************//
    //MARK:- First Name Declartion
    @IBOutlet weak var firstNameTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                firstNameTF.textAlignment = .left
            }else{
                firstNameTF.textAlignment = .right
                firstNameTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var firstNameOuterView: UIView?
    @IBOutlet weak var firstNameImageView: UIImageView?
    @IBOutlet weak var firstNameError: UILabel?
    @IBOutlet weak var firstNameCount: UILabel?
    @IBOutlet weak var fisrtNameErrorLine: UIView?
    @IBOutlet weak var orLbl: UILabel?{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                orLbl?.font = UIFont(name: "Cairo-Light", size: (orLbl?.font.pointSize)!)
            }
        }
    }
    
    //************************//
    //MARK:- Last Name Declartion
    @IBOutlet weak var lastNameTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                lastNameTF.textAlignment = .left
            }else{
                lastNameTF.textAlignment = .right
                 lastNameTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var lastNameOuterView: UIView?
    @IBOutlet weak var lastNameImageView: UIImageView?
    @IBOutlet weak var lastNameError: UILabel?
    @IBOutlet weak var lastNameCount: UILabel?
    @IBOutlet weak var lastNameErrorLine: UIView?
    
    //************************//
    //MARK:- Email Name Declartion
    @IBOutlet weak var emailTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                emailTF.textAlignment = .left
            }else{
                emailTF.textAlignment = .right
                emailTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var emailOuterView: UIView?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var emailError: UILabel?
    @IBOutlet weak var emailCount: UILabel?
    @IBOutlet weak var emailErrorLine: UIView?
    
    //************************//
    //MARK:- Mobile Number Declartion
    
    @IBOutlet weak var mobileTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                mobileTF.textAlignment = .left
            }else{
                mobileTF.textAlignment = .right
                mobileTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var mobileOuterView: UIView?
    @IBOutlet weak var mobileImageView: UIImageView?
    @IBOutlet weak var mobileError: UILabel?
    @IBOutlet weak var mobileCount: UILabel?
    @IBOutlet weak var mobileErrorLine: UIView?
    
    //************************//
    //MARK:- PersonalID number Declartion
    
    @IBOutlet weak var viewPersonalID: UIView!
    @IBOutlet weak var PersonalIDTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                PersonalIDTF.textAlignment = .left
            }else{
                PersonalIDTF.textAlignment = .right
                PersonalIDTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var PersonalIDOuterView: UIView?
    @IBOutlet weak var PersonalIDImageView: UIImageView?
    @IBOutlet weak var PersonalIDError: UILabel?
    @IBOutlet weak var PersonalIDCount: UILabel?
    @IBOutlet weak var PersonalIDErrorLine: UIView?
    @IBOutlet weak var personalIdHeightConstrant: NSLayoutConstraint!
    
    //************************//
    //MARK:-  Password Declartion
    
    @IBOutlet weak var passwordTopFromPersonalId: NSLayoutConstraint!
    @IBOutlet weak var passwordTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var passwordTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                passwordTF.textAlignment = .left
            }else{
                passwordTF.textAlignment = .right
                passwordTF.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var passwordOuterView: UIView?
    @IBOutlet weak var passwordImageView: UIImageView?
    @IBOutlet weak var passwordError: UILabel?
    @IBOutlet weak var passwordCount: UILabel?
    @IBOutlet weak var passwordErrorLine: UIView?
    @IBOutlet weak var signwithFbLbl: UILabel?{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                signwithFbLbl?.font = UIFont(name: "Cairo-SemiBold", size: (signwithFbLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnBack)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnBack)
            }
        }
    }
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var notifyLbl: UILabel?{
                didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                notifyLbl?.font = UIFont(name: "Cairo-Light", size: (notifyLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var createAcclbl: UILabel?{
                didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                createAcclbl?.font = UIFont(name: "Cairo-SemiBold", size: (createAcclbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var byClickLbl: UILabel?{
                didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                byClickLbl?.font = UIFont(name: "Cairo-SemiBold", size: (byClickLbl?.font.pointSize)!)
            }
        }
    }
    @IBOutlet weak var termsBtn: UIButton?{
                didSet{
            if UserDefaults.standard.string(forKey: string.language) != string.en{
                termsBtn?.titleLabel?.font = UIFont(name: "Cairo-SemiBold", size: 16)
            }
        }
    }
    
    //************************//
    //MARK:- Confirm  Password Declartion
    @IBOutlet weak var confirmPassTF: RMTextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                confirmPassTF.textAlignment = .left
            }else{
                confirmPassTF.textAlignment = .right
                confirmPassTF.font = UIFont(name: "Cairo-Light", size: 16)
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
    
    
    @IBOutlet weak var _txtSalutation: UITextField!{
        didSet{
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                _txtSalutation.textAlignment = .left
            }else{
                _txtSalutation.textAlignment = .right
                _txtSalutation.font = UIFont(name: "Cairo-Light", size: 16)
            }
        }
    }
    @IBOutlet weak var _btnSLTDropDown: UIButton!
    @IBOutlet weak var viewForShadow: UIView!

    //************************//
    
    var userTitlePicker = UIPickerView()
    var titleArray = [String]()
    
    
    //MARK:- Toogle Declartion
    @IBOutlet weak var btnToggleNews: UIButton!
    let data = onBoardingData(dictionary: ResponseKey.fatchData(res: UserData.shared.getData()!, valueOf: .data).dic)
    
    typealias isAvailbleMail = (Bool?) -> Void
    var fbView  =   Bundle.main.loadNibNamed("FBRegistrationView", owner: self, options: nil)?.first as! FBRegistrationView
    
    //********************************//
    //MARK:- Facebook Button Declartion
    
    @IBOutlet weak var fbBtn: UIButton!
        {
        didSet{
            fbBtn.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnFBHighlight), forState: .highlighted)
            fbBtn.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnFBNormal), forState: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                fbBtn.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            }else{
                fbBtn.titleLabel?.font =  UIFont(name: "Cairo-Regular", size: 14)
            }
//            fbBtn.setTitle(validationMessage.btnSignInWithFacebook.localized, for: .normal)
        }
    }
    //******************************//
    //MARK:- Create Button Declartion
    
    @IBOutlet weak var createBtn: UIButton!
        {
        didSet{
            createBtn.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnFBHighlight), forState: .highlighted)
            createBtn.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnCreateNormal), forState: .normal)
            createBtn.setTitle(validationMessage.btnCreateAccount.localized, for: .normal)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                createBtn.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            }else{
                createBtn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
        }
    }
    
    //MARK:- Normal Variable
    var errorIndex = 999
    var errorMessage = ""
    var languageCode = ""
    var languageStr = ""
    let registerData = RegisterDetail()
    
    //MARK:- Controller Instance
    static var storyboardInstance:RegistrationUserViewController? {
        return StoryBoard.Registration.instantiateViewController(withIdentifier: RegistrationUserViewController.identifier) as? RegistrationUserViewController
        
    }
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryData.insert((countryName: "countryCodeTitle", countryCode: ""), at: 0)
        validateCreateButtonEnable()
        //Enable or Disable Personal Id
        if countryCheck == "Arabic" {
            personalIdHeightConstrant.constant = 0
            viewPersonalID.isHidden = true
            passwordTopFromPersonalId.constant = 0
            self.view.layoutIfNeeded()
        }
        //end of person Id
        if UserDefaults.standard.value(forKey: "userlanguage")as? String == "Arabic"{
            switchViewControllers(isArabic: true)
        }        
        setUpLoadView()
        setupTextFieldPlaceHolder()
        setupTextFieldLayer()
        setupFont()
        setupSelectorMethed()
        let attributedTitlefourth = NSAttributedString(string: validationMessage.btnRegister.localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.black] )
        registerLbl?.attributedText = attributedTitlefourth
        passwordTF.textContentType = UITextContentType("")
        confirmPassTF.textContentType = UITextContentType("")
        
        titleArray = [validationMessage.MR.localized,validationMessage.Ms.localized,validationMessage.Mrs.localized]
         userTitlePicker.delegate = self
        userTitlePicker.dataSource = self;
        _txtSalutation.delegate = self
        _txtSalutation.inputView = self.userTitlePicker
        txtCountryCode.inputView = self.userTitlePicker
        userTitlePicker.selectRow(0, inComponent: 0, animated: false)
        userTitlePicker.reloadAllComponents()
        _txtSalutation.text = titleArray[0]
        
         btnToggleNews.isSelected = true
        print("I am selected.")
        self.notifyLbl?.textColor = .black
        btnToggleNews.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //createBtn.isUserInteractionEnabled = false
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func showCountyCodePicker(_ sender: Any) {
        
        tagNo = txtCountryCode.tag
        //txtCountryCode.text = "+\(countryData[0].countryCode)"
        userTitlePicker.delegate = self
        userTitlePicker.dataSource = self
        txtCountryCode.inputView = self.userTitlePicker
        txtCountryCode.becomeFirstResponder()
        userTitlePicker.selectRow(0, inComponent: 0, animated: false)
        userTitlePicker.reloadAllComponents()
    }
    @objc func onTap(_ sender:UITextField){
           _btnSLTDropDown.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)

       }
       @objc func onEnd(_ sender:UITextField) {
           _btnSLTDropDown.setImage(#imageLiteral(resourceName: "ic_dropdown"), for: .normal)
       }
    //MARK:- Setup view
    func setUpLoadView(){
        signwithFbLbl?.text = validationMessage.signInWithFacebook.localized
        createAcclbl?.text = validationMessage.createAccount.localized
        byClickLbl?.text = validationMessage.aggremntForAccount.localized
        let titleText = validationMessage.termConditionForAccount.localized
        termsBtn?.setTitle(titleText, for: .normal)
        
        //termsBtn?.addTextSpacingButton(spacing: 1.5)
        createBtn?.setTitle(validationMessage.btnCreateAccount.localized, for: .normal)
        notifyLbl?.text = validationMessage.signUpNewsAndPersonalised.localized
        orLbl?.text = validationMessage.or.localized
        let attributedTitlesecond = NSAttributedString(string: validationMessage.btnSignInWithFacebook.localized, attributes: [NSAttributedStringKey.kern: 1.5, NSAttributedStringKey.foregroundColor:UIColor.white] )
        fbBtn?.setAttributedTitle(attributedTitlesecond, for: .normal)
        let fbTitle = validationMessage.btnSignInWithFacebook.localized
         fbBtn?.setTitle(fbTitle, for: .normal)
        
        languageCode = (data._source?.languageList[0].name)!
        if languageCode == validationMessage.languegeEng {
            languageStr = "en"
            termsBtn?.underlinesButton()
        }
        else{
            languageStr = "ar"
        }
       
    }
    
    //MARK:- Setup Text Field Placeholder
    func setupTextFieldPlaceHolder(){
        
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.Salutation.localized, textFieldname: _txtSalutation, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starEmail.localized, textFieldname: emailTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starFirstName.localized, textFieldname: firstNameTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starLastName.localized, textFieldname: lastNameTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starMobileNum.localized, textFieldname: mobileTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starPersonalId.localized, textFieldname: PersonalIDTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starPassword.localized, textFieldname: passwordTF, startIndex: 0)
        TextPlaceHolder.textFieldPlaceHolder(text: validationMessage.starConfPassword.localized, textFieldname: confirmPassTF, startIndex: 0)
       
    }
    
    //MARK:- Setup TextField layer
    func setupTextFieldLayer(){
        firstNameTF?.dtLayer.isHidden = true
        lastNameTF?.dtLayer.isHidden = true
        emailTF.dtLayer.isHidden = true
        mobileTF.dtLayer.isHidden = true
        PersonalIDTF.dtLayer.isHidden = true
        passwordTF.dtLayer.isHidden = true
        confirmPassTF.dtLayer.isHidden = true
    }
    
    //MARK:- Setup Font
    func setupFont(){
        if UserDefaults.standard.string(forKey: string.language) == string.en{
            firstNameTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            lastNameTF?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            emailTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            mobileTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            PersonalIDTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            passwordTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            confirmPassTF.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
        }else{
            
            firstNameTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            lastNameTF?.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            emailTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            mobileTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            PersonalIDTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            passwordTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
            confirmPassTF.floatPlaceholderFont = UIFont(name: "Cairo-Light", size: 14)!
        }

        firstNameTF.textColor = UIColor.black
        lastNameTF.textColor = UIColor.black
        emailTF.textColor = UIColor.black
        mobileTF.textColor = UIColor.black
        PersonalIDTF.textColor = UIColor.black
        confirmPassTF.textColor = UIColor.black
        passwordTF.textColor = UIColor.black
    }
    
    //MARK:- Setup Selector
    func setupSelectorMethed(){
        // passwordError?.frame.size.height = passwordError!.optimalLabelHeight
        firstNameTF?.addTarget(self, action: #selector(didChangeFirstNameTextValue), for: .editingChanged)
        lastNameTF?.addTarget(self, action: #selector(didChangeLastNameTextValue), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(didChangeEmailTextValue), for: .editingChanged)
        mobileTF.addTarget(self, action: #selector(didChangeMobileTextValue), for: .editingChanged)
        PersonalIDTF.addTarget(self, action: #selector(didChangePersonalIdTextValue), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(didChangePasswordTextValue), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(didEditPasswordTextValues), for: .editingDidBegin)
        passwordTF.addTarget(self, action: #selector(didEditEndPasswordTextValues), for: .editingDidEnd)
        confirmPassTF.addTarget(self, action: #selector(didChangeConfirmPasswordTextValue), for: .editingChanged)
        confirmPassTF.addTarget(self, action: #selector(didEditConfPasswordTextValues), for: .editingDidBegin)
        confirmPassTF.addTarget(self, action: #selector(didEditEndConfPasswordTextValues), for: .editingDidEnd)
    }
    
    //MARK:- Selector Metheds
    
    //MARK: First Name Selector
    @objc func didChangeFirstNameTextValue(textField :UITextField)  {
        validateCreateButtonEnable()
        //  self.firstNameCount.isHidden = false
//        firstNameOuterView?.backgroundColor = colorNames.textOuterView
        firstNameOuterView?.backgroundColor  = .white
        fisrtNameErrorLine?.backgroundColor = colorNames.errorTextField
        //firstNameTF?.floatPlaceholderColor = colorNames.c4747
        firstNameTF?.floatPlaceholderActiveColor =  colorNames.c4747
        errorIndex = 999
//         firstNameTF.floatingDisplayStatus = .always
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space First name ",textString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                firstNameTF.font = BrandenFont.regular(with: 16.0)
            }else{
                firstNameTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            
            registerData.firstName = textString
             self.ischeckFirstNamr()
        }else{
           firstNameError?.isHidden = true
                     fisrtNameErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                     self.firstNameCount?.isHidden = false
                   firstNameImageView?.isHidden = true
        }
       
        
    }
    
    //MARK:- Last Name Selector
    
    @objc func didChangeLastNameTextValue(textField :UITextField)  {
        validateCreateButtonEnable()
        // self.lastNameTF.isHidden = false
        
        lastNameOuterView?.backgroundColor = .white
        lastNameErrorLine?.backgroundColor = colorNames.errorTextField
        lastNameTF?.floatPlaceholderActiveColor = colorNames.ErrorLineBGColor
        errorIndex = 999
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space Last name ",textString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                lastNameTF.font = BrandenFont.regular(with: 16.0)
            }else{
                lastNameTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            
            registerData.lastName = textString
            self.ischeckLastName()
        }else{
            lastNameError?.isHidden = true
                       lastNameErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                       self.lastNameCount?.isHidden = false
                       lastNameImageView?.isHidden = true
        }
        
    }
    
    //MARK: Email Selector Methed
    
    @objc func didChangeEmailTextValue(textField :UITextField)  {
        // self.emailCount.isHidden = false
        emailOuterView?.backgroundColor = .white
        emailErrorLine?.backgroundColor = colorNames.errorTextField
         emailTF.floatPlaceholderActiveColor =  colorNames.c4747
        errorIndex = 999
        guard let text = textField.text else { return }
        let trimmedString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString != "" {
            print("White space Email ",trimmedString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                emailTF.font = BrandenFont.regular(with: 16.0)
            }else{
                emailTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            
            registerData.emailAddress = trimmedString
            self.ischeckemail()
        }else{
           emailError?.isHidden = true
                       emailErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                      
                       self.emailCount?.isHidden = false
                       emailImageView?.isHidden = true
        }

    }
    //MARK:- MObile Selector
    @objc func didChangeMobileTextValue(textField :UITextField)  {
        validateCreateButtonEnable()
        //self.mobileCount.isHidden = false
        mobileOuterView?.backgroundColor = .white
        mobileErrorLine?.backgroundColor = colorNames.errorTextField
        mobileTF.floatPlaceholderActiveColor = colorNames.ErrorLineBGColor
        errorIndex = 999
        guard let text = textField.text else { return }
        let trimmedString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString != "" {
            print("White space Mobile ",trimmedString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                mobileTF.font = BrandenFont.regular(with: 16.0)
            }else{
                 mobileTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            registerData.mobileNumber = trimmedString
            self.ischeckMobile()

        }else{
            mobileError?.isHidden = true
                       mobileErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                       
                       self.mobileCount?.isHidden = false
                       mobileImageView?.isHidden = true
        }
        
        print(registerData.mobileNumber)
        
        
    }
    //MARK:- Personal ID Selector
    @objc func didChangePersonalIdTextValue(textField :UITextField)  {
        PersonalIDOuterView?.backgroundColor = .white
        PersonalIDErrorLine?.backgroundColor = colorNames.errorTextField
        errorIndex = 999
        guard let text = textField.text else { return }
        let trimmedString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmedString != "" {
            print("Personal Id check ",trimmedString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                passwordTF.font = BrandenFont.regular(with: 16.0)
            }else{
                 passwordTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            
            //registerData.mobileNumber = trimmedString
            //self.ischeckMobile()

        }else{
            PersonalIDImageView?.isHidden = true
        }
        
        print("PERSONAL ID--Ck")
        
        
    }
    // MARK:- Change Password Selector
    @objc func didChangePasswordTextValue(textField :UITextField)  {
        validateCreateButtonEnable()
        // self.passwordCount.isHidden = false
        passwordOuterView?.backgroundColor = .white
        passwordErrorLine?.backgroundColor = colorNames.errorTextField
        passwordTF.textContentType = UITextContentType("")
        passwordTF.inputAccessoryView = nil
        passwordTF.reloadInputViews()
        //        confirmPassTF.textContentType = UITextContentType("")
        passwordTF.floatPlaceholderActiveColor =  colorNames.c4747
        errorIndex = 999
        
        
//        if passwordTF.text!.length > 0{
//            passBtn.contentVerticalAlignment = .bottom
//            passBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -8, 0)
//        }else{
//            passBtn.contentVerticalAlignment = .center
//            passBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space Password ",textString)
            if UserDefaults.standard.string(forKey: string.language) == string.en{
                 confirmPassTF.font = BrandenFont.regular(with: 16.0)
            }else{
                 confirmPassTF.font = UIFont(name: "Cairo-Regular", size: 16)
            }
           
            registerData.password = textString
            self.ischeckPassword()
        }else{
           passwordError?.isHidden = true
                     passwordErrorLine?.backgroundColor = UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
                     
                     self.passwordCount?.isHidden = false
                   passwordImageView?.isHidden = true
        }
        
        
    }
    
    @objc func didEditPasswordTextValues(textField: UITextField){
//        if passwordTF.text!.length > 0{
//            passBtn.contentVerticalAlignment = .bottom
//            passBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -8, 0)
//        }else{
//
//        }
//        if passwordTF.text == ""
//        {
//            passBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//            passBtn.contentVerticalAlignment = .center
//        }
    }
    
    @objc func didEditEndPasswordTextValues(textField: UITextField){
//        if passwordTF.text == ""{
//            passBtn.contentVerticalAlignment = .center
//            passBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
    }
    
    //MARK:- Confirm password Selector
    @objc func didChangeConfirmPasswordTextValue(textField :UITextField)  {
        validateCreateButtonEnable()
        // self.confirmPassTF.isHidden = false
        confirmPassOuterView?.backgroundColor = .white
        confirmPassErrorLine?.backgroundColor = colorNames.errorTextField
        confirmPassTF.floatPlaceholderActiveColor = colorNames.c4747
        errorIndex = 999
        confirmPassTF.textContentType = UITextContentType("")
        confirmPassTF.inputAccessoryView = nil
        confirmPassTF.reloadInputViews()
        //        print("Auto Fill Password",textField.text!)
        //        registerData.confirmPAssword = textField.text!
//        if confirmPassTF.text!.length > 0{
//            confirmPassBtn.contentVerticalAlignment = .bottom
//            confirmPassBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -8, 0)
//        }else{
//            confirmPassBtn.contentVerticalAlignment = .center
//            confirmPassBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
        
        guard let text = textField.text else { return }
        let textString = text.removeWhitespaceFromAnyString()
        if textString != "" {
            print("White space Confirm password ",textString)
            registerData.confirmPAssword = textString
             self.ischeckConfirmPassword()
        }else{
            confirmPassError?.isHidden = true
                       confirmPassErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
                       
                       self.confirmPassCount?.isHidden = false
                       confirmPassImageView?.isHidden = true
        }
       
        
    }
    @objc func didEditConfPasswordTextValues(textField: UITextField){
//        if confirmPassTF.text!.length > 0{
//            confirmPassBtn.contentVerticalAlignment = .bottom
//            confirmPassBtn.imageEdgeInsets = UIEdgeInsetsMake(27, 10, -8, 0)
//        }else{
//
//        }
//        if confirmPassTF.text == ""
//        {
//            confirmPassBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//            confirmPassBtn.contentVerticalAlignment = .center
//        }
    }
    
    @objc func didEditEndConfPasswordTextValues(textField: UITextField){
//        if confirmPassTF.text == ""{
//            confirmPassBtn.contentVerticalAlignment = .center
//            confirmPassBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
    }
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
            emailTF.floatPlaceholderActiveColor =  colorNames.placeHolderColor
            emailTF?.floatPlaceholderColor = colorNames.c4747
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
            firstNameTF?.floatPlaceholderActiveColor = colorNames.c4747
            firstNameTF?.floatPlaceholderColor = colorNames.c4747
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
            lastNameTF?.floatPlaceholderActiveColor = colorNames.c4747
            lastNameTF?.floatPlaceholderColor = colorNames.c4747
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
                PersonalIDTF.floatPlaceholderActiveColor = UIColor.red
                self.mobileCount?.isHidden = false
            }
        }else{
            mobileImageView?.image = UIImage(named: "Successnew")
            mobileError?.isHidden = true
            mobileErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            mobileTF.floatPlaceholderActiveColor = colorNames.c4747
            mobileTF?.floatPlaceholderColor = colorNames.c4747
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
            }else{
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
        }else{
            //passwordError?.frame.size.height = 22
            passwordImageView?.image = UIImage(named: "Successnew")
            passwordError?.isHidden = true
            passwordErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            passwordTF.floatPlaceholderActiveColor =  colorNames.placeHolderColor
            passwordTF?.floatPlaceholderColor = colorNames.c4747
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
            }else{
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
        }else{
            confirmPassImageView?.image = UIImage(named: "Successnew")
            confirmPassError?.isHidden = true
            confirmPassErrorLine?.backgroundColor = colorNames.ErrorLineBGColor
            confirmPassTF.floatPlaceholderActiveColor = colorNames.c4747
            confirmPassTF?.floatPlaceholderColor = colorNames.c4747
            self.confirmPassCount?.isHidden = false
        }
    }
    
    //***************************//
    //MARK:- SET ALL VALUES TO NIL
    
    
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
        PersonalIDTF.text = ""
        mobileImageView?.isHidden = true
        mobileCount?.isHidden = true
        mobileOuterView?.backgroundColor = .white
        confirmPassTF.text = ""
        confirmPassImageView?.isHidden = true
        confirmPassCount?.isHidden = true
        confirmPassOuterView?.backgroundColor = .white
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
        
        
        let u_first_name = ValidationClass.verifyFirstname(text: registerData.firstName)
        let u_last_name = ValidationClass.verifyLastname(text: registerData.lastName)
        let u_email = ValidationClass.verifyEmail(text: registerData.emailAddress)
        let u_contact = ValidationClass.verifyPhoneNumber(text: registerData.mobileNumber)
        let u_password = ValidationClass.verifyPassword(text: registerData.password)
        let u_confirm_pass = ValidationClass.verifyPasswordAndConfirmPassword(password: registerData.password, confirmPassword: registerData.confirmPAssword)
        errorIndex = 999
        errorMessage = ""
        
        guard u_first_name.1 as Bool else {
            errorMessage = u_first_name.0
            firstNameError?.isHidden = false
            firstNameError?.text = errorMessage
            fisrtNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            firstNameImageView?.isHidden = false
            return false
            
        }
        errorIndex = 0
        errorMessage = u_first_name.0
        firstNameError?.isHidden = false
        firstNameError?.text = errorMessage
//        fisrtNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        firstNameImageView?.isHidden = true
        firstNameCount?.isHidden = false
        
        guard u_last_name.1 as Bool else {
            errorMessage = u_last_name.0
            lastNameError?.isHidden = false
            lastNameError?.text = errorMessage
            lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            lastNameImageView?.isHidden = false
            return false
        }
        errorIndex = 1
        errorMessage = u_last_name.0
        lastNameError?.isHidden = false
//        lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        lastNameError?.text = errorMessage
        lastNameImageView?.isHidden = true
        lastNameCount?.isHidden = false
        
        guard u_email.1 as Bool else {
            errorMessage = u_email.0
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
//        lastNameErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
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
        mobileError?.isHidden = false
        mobileError?.text = errorMessage
//        mobileErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        mobileImageView?.isHidden = true
        mobileCount?.isHidden = false
        
        guard u_password.1 as Bool else {
            errorMessage = u_password.0
            passwordError?.isHidden = false
            passwordError?.text =  errorMessage
            passwordErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            passwordImageView?.isHidden = false
            return false
        }
        
        errorIndex = 4
        errorMessage = u_password.0
        passwordError?.isHidden = false
        passwordError?.text =  errorMessage
//        passwordErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        passwordImageView?.isHidden = true
        passwordCount?.isHidden = false
        
        
        guard u_confirm_pass.1 else {
            errorMessage = u_confirm_pass.0
            confirmPassError?.isHidden = false
            confirmPassError?.text = errorMessage
            confirmPassErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            confirmPassImageView?.isHidden = false
            return false
            
        }
        
        errorIndex = 5
        errorMessage = u_confirm_pass.0
        confirmPassError?.isHidden = false
//        confirmPassErrorLine?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        confirmPassError?.text = errorMessage
        confirmPassImageView?.isHidden = true
        confirmPassCount?.isHidden = false
        
        isValid = true
        
        return isValid
    }
    
    //MARK:- Back Button
    @IBAction func onCLickBackBtn(_ sender: Any) {
        //        self.navigationController?.popViewController(animated: true)
        //        dismiss(animated: true, completion: nil)
        closeView()
    }
    func closeView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
    
    func animationIn(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.layer.add(transition, forKey: kCATransition)
    }
    //MARK:- Close/Cross Button
    @IBAction func onClickCrossBtn(_ sender: Any) {
        //        self.navigationController?.popViewController(animated: true)
        //        dismiss(animated: true, completion: nil)
        closeView()
    }
    
    //MARK:- Click Show Button
    @IBAction func onClickShow(_ sender: UIButton) {
        if sender.tag == 0{
            if passBtn.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                passBtn.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                passwordTF.isSecureTextEntry = true
            }else{
                passBtn.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                passwordTF.isSecureTextEntry = false
            }
        }
    }
    
    //MARK:- Confirm Password click Show Button
    @IBAction func onClickShowSecond(_ sender: UIButton) {
        if sender.tag == 0{
            if confirmPassBtn.currentImage == #imageLiteral(resourceName: "ic_showpwd"){
                confirmPassBtn.setImage(#imageLiteral(resourceName: "ic_hidePwd"), for: .normal)
                confirmPassTF.isSecureTextEntry = true
            }else{
                confirmPassBtn.setImage(#imageLiteral(resourceName: "ic_showpwd"), for: .normal)
                confirmPassTF.isSecureTextEntry = false
            }
        }
    }
    
    //MARK:- Notify Button
    @IBAction func onClickNotify(_ sender: UIButton) {
        btnToggleNews.isSelected = !btnToggleNews.isSelected
        if btnToggleNews.isSelected {
            print("I am selected.")
            self.notifyLbl?.textColor = .black
            sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
        } else {
            print("I am not selected.")
            self.notifyLbl?.textColor = UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
            sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
        }
 
    }
    
    //MARK:- Create Button
    @IBAction func onClickCreateBtn(_ sender: Any) {
        self.view.endEditing(true)
        if isAllValid() {
            CallCreateUserApi(isFaceBook:false)
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
    //MARK:- Get Token after Registration
    func getTokenApiAfterRegistration(username:String, password: String){
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let params = [
            "username" : username,
            "password" : password
            ] as [String : Any] as [String : Any]
        
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.kUserLogin
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
              MBProgressHUD.hide(for: self.view, animated: true)
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
                MBProgressHUD.hide(for: self.view, animated: true)

                if statusCode == 200  {
                    let test = response?.description
                    UserDefaults.standard.set(test, forKey: string.userToken)
                    UserDefaults.standard.set(false, forKey: string.isFBuserLogin)
                    
                    M2_isUserLogin = true
                     userLoginStatus(status: true)
                    UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                    UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                   // UserDefaults.standard.set(response?.description, forKey: "userData")
                    self.conversionLoginUserToGuestUser()
                    let popview = SuccessScreenViewController.storyboardInstance
                                              let transition = CATransition()
                    popview?.isCommingFromHomeScreen = self.isCommingFromHomeScreen
                                              transition.duration = 0.5
                                              transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                              transition.type = kCATransitionPush
                                              transition.subtype = kCATransitionFromTop
                                              self.view.layer.add(transition, forKey: kCATransition)
                                               self.addChildViewController(popview!)
                                              self.view.addSubview(popview!.view)

                                               self.setAllValuesNil()
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
                                        UserDefaults.standard.set(address.email, forKey: "userEmail")
                                        UserDefaults.standard.set(address.firstname, forKey: "firstname")
                                        UserDefaults.standard.set(address.lastname, forKey: "lastname")
                                        UserDefaults.standard.set(address.prefix, forKey: "prefix")
                                        addMyWishListInLocalDb()
                                      }else{
                                          //failure()
                                          MBProgressHUD.hide(for: self.view, animated: true)
                                      }
                                  }catch{
                                      //failure()
                                      MBProgressHUD.hide(for: self.view, animated: true)
                                  }
                              }) {
                                  //failure()
                                  MBProgressHUD.hide(for: self.view, animated: true)
                              }
                           MBProgressHUD.hide(for: self.view, animated: true)
                }
                if statusCode == 401  {
                      MBProgressHUD.hide(for: self.view, animated: true)
                    let errorMessage = response?.dictionaryValue["message"]?.stringValue
                    let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                      MBProgressHUD.hide(for: self.view, animated: true)
                }
            }else{
                print("something went wrong")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
    }
    func getTokenApiAfterFaceBooKRegistration(emil:String , fbID:String ,customerId:String){
       
        MBProgressHUD.showAdded(to: view, animated: true)
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
                 
             //              let strDesc:String = d?["description"]as? String ?? ""
                UserDefaults.standard.set(responseDic!["token"], forKey: string.userToken)
                UserDefaults.standard.set(true, forKey: string.isFBuserLogin)
                
                M2_isUserLogin = true
                userLoginStatus(status: true)
                UserDefaults.standard.set(UserDefaults.standard.string(forKey: "guest_carts__item_quote_id"),forKey: "quote_id_to_convert")
                UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
                // UserDefaults.standard.set(response?.description, forKey: "userData")
                    self.conversionLoginUserToGuestUser()
                let popview = SuccessScreenViewController.storyboardInstance
                let transition = CATransition()
                popview?.isCommingFromHomeScreen = self.isCommingFromHomeScreen
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromTop
                self.view.layer.add(transition, forKey: kCATransition)
                self.addChildViewController(popview!)
                self.view.addSubview(popview!.view)
                
                self.setAllValuesNil()
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
            popupVC.userData = userData
              popupVC.mobilePopupDelegate = self
                 popupVC.modalPresentationStyle = .overCurrentContext
                 self.present(popupVC, animated: true, completion: nil)
             }
          func continuousBtnAction(mobilePopupVC :mobilePopupVC, mobile: String){
             //update mobile Number
               var dataDic = [String:String]()
               var userData = mobilePopupVC.userData
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
                                         "value": dataDic["mobileNo"]
                                     ]
                                 ]
                                 
                             ]
                             
                             ] as! [String : Any]
                     MBProgressHUD.showAdded(to: self.view, animated: true)
                     ApiManager.saveChangePref(params: paramdata, success: {  (response, error)  in
                         MBProgressHUD.hide(for: self.view, animated: true)
                       mobilePopupVC.dismiss(animated: true, completion: nil)
                       if self.isCommingFromHomeScreen {
                           self.navigationController?.popViewController(animated: true)
                           NotificationCenter.default.post(name: Notification.Name(notificationName.LetGO_LOGIN_TO_HOME), object: nil)
                       }else{
                       self.navigationController?.popViewController(animated: true)
                       }
                        // self.showThankyouPopup()
                         
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
    //MARK:- Registration Api
    
    func CallCreateUserApi (isFaceBook:Bool)
    {
        
        let password = registerData.confirmPAssword
        MBProgressHUD.showAdded(to: view, animated: true)
       // let storeCode:String = UserDefaults.standard.value(forKey: validationMessage.keyStorecode) as! String
        
        //MObile no with ISD
        fixedCC = isFaceBook == true ? self.fbView.txtIsdcode.text ?? "+ISD"  : txtCountryCode.text ?? "+ISD"
        if !fixedCC.isNumeric {
            fixedCC = ""
        }
        let mobileNO = registerData.mobileNumber
        let finalMobileNo = "\(fixedCC.deletingPrefix("+"))-\(mobileNO)"
        //-------------End Of MObile--------
       
        let custom_attributes =    [
            [
                validationMessage.attribute_code : validationMessage.keyTelephone,
                validationMessage.value : "\(finalMobileNo.deletingPrefix("-"))"
            ]
        ]
        var populatedDictionary = [validationMessage.keyFirstname:registerData.firstName, validationMessage.keyLastname:registerData.lastName,validationMessage.prefix:_txtSalutation.text!,
        validationMessage.keyEmail :registerData.emailAddress, validationMessage.custom_attributes:custom_attributes ] as [String : Any]
        
        if btnToggleNews.isSelected {
       let extension_attributes =
            [
            "is_subscribed" : btnToggleNews.isSelected,
            ]
            populatedDictionary ["extension_attributes"] = extension_attributes
             
        }
       
        var params : [String : Any] = [:]
        if isFaceBook {
             params = [validationMessage.keyCustomer  : populatedDictionary
                       
                       ] as [String : Any]
        }else{
             params = [validationMessage.keyCustomer  : populatedDictionary,
                       validationMessage.keyPassword : registerData.password as Any
                       ] as [String : Any]
        }
        
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.KUserregistration
       
        ApiManager.apiPostWithCode(url: url, params:params) { (response:JSON?, error:Error?, statusCode: Int) in
             MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            if response != nil{
                if statusCode == 200  {
                   
                    let email = response!["email"].stringValue
                    let id = response!["id"].stringValue
                    //MARK:- token
                    if isFaceBook {
                        //call social update api
                        self.CallSocialupdateApiRegister(faceBookView: self.fbView,customerId:id)
                      //  self.getTokenApiAfterFaceBooKRegistration(faceBookView: self.fbView,customerId:id)
                    }else if email != ""{
                        self.getTokenApiAfterRegistration(username: email, password: password)
                        return
                    }
                 
                }
                else if statusCode == 401  {
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
    
    //MARK:- Facebook Integration
    @IBAction func onCLickFbBtn(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        FacebookSignInManager.basicInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            if error != nil{
                MBProgressHUD.hide(for: self.view, animated: true)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                let bounds = UIScreen.main.bounds
                let width = bounds.size.width
                let height = bounds.size.height
                let info = JSON(dataDictionary!)
                //                    let height = info!["picture"]["data"]["height"].intValue
                //                    let url = info?["picture"]["data"]["url"].stringValue
                let lastName = info["last_name"].stringValue
                let email = info["email"].stringValue
                let first_name = info["first_name"].stringValue
                let fb_ID = info["id"].stringValue
                if email == "" || email == nil {
                    self.showEmailpopup(email: email, first_name :first_name, lastName: lastName, fb_ID: fb_ID)
                }else{
                self.CheckEmailAvailbaleForRegis(email: email, first_name :first_name, lastName: lastName,fb_ID: fb_ID)
                }
                //
                
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
        CheckEmailAvailbaleForRegis(email: email, first_name : emailPopupVC.first_name,lastName: emailPopupVC.lastName,fb_ID:emailPopupVC.fb_ID )
    }
    func linkCustomerAccount(emailPopupVC :emailPopupVC){
        //kk
        if emailPopupVC.isRegisterUser {
            self.CallReadonlyUserApiRegister(emil:emailPopupVC.verificationEmailAddress , fbID:emailPopupVC.fb_ID ,customerId:"")
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
    func CheckEmailAvailbaleForRegis(email: String, first_name :String,lastName: String, fb_ID: String ){
        self.CheckEmailAvailbaleRegis(email: email){ (status) in
            
                        let bounds = UIScreen.main.bounds
                        let width = bounds.size.width
                        let height = bounds.size.height
                            if status == true{
                                self.fbView._btnClose.addTarget(self, action: #selector(self.cancelRegisteration), for: .touchUpInside)
                                self.fbView.btnTC.addTarget(self, action: #selector(self.tcPressed), for: .touchUpInside)
                                self.fbView.createBtn.addTarget(self, action: #selector(self.createRegisterUsingFacebook), for: .touchUpInside)
                                self.fbView._btnNewsOffer.addTarget(self, action: #selector(self.changeToggleUsingFacebook), for: .touchUpInside)
                                self.fbView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                                self.fbView.firstNameTF.text = first_name
                                self.fbView.lastNameTF.text = lastName
                                self.fbView.fb_ID = fb_ID
                                self.fbView.txtIsdcode.inputView = self.userTitlePicker
                                self.tagNo = 102
                                if email != nil {
                                    self.fbView.emailTF.text = email
                                    self.fbView.emailTF.isUserInteractionEnabled = false
                                }else{
                                    self.fbView.emailTF.isUserInteractionEnabled = true
                                }
        //                        UIView.transition(with: self.fbView,
        //                                          duration: 0.5,
        //                                          options: [.transitionFlipFromBottom],
        //                                          animations: {
        //                        },
        //                                          completion: nil)
                                let transition = CATransition()
                                transition.duration = 0.5
                                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition.type = kCATransitionPush
                                transition.subtype = kCATransitionFromTop
                                self.view.layer.add(transition, forKey: kCATransition)
                                self.view.addSubview(self.fbView)
                            }else{
                                if email != ""{
                                    //check if vatification api call email available
                                    self.CallReadonlyUserApiRegister(emil:email , fbID:fb_ID ,customerId:"")
                                   // self.CallReadonlyUserApiRegister(email: email)
                                    //showOTPPopUpView()
                                }
                            }
                        }
    }
    func showOTPPopUpView(){
        let nextVC = CodeVCViewController.storyboardInstance!
        nextVC.strEmail = ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK:- Facebook functionality
    @objc func tcPressed(){
        print("SHOW t&C")
        showTermandConditions()
    }
    @objc func cancelRegisteration(){
        
        print("Close Registration")
        FacebookSignInManager.logoutFromFacebook()
        animationOut()
        self.fbView.removeFromSuperview()
        
    }
    
    func animationOut(){
           let transition = CATransition()
           transition.duration = 0.5
           transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
           transition.type = kCATransitionPush
           transition.subtype = kCATransitionFromBottom
           self.view.layer.add(transition, forKey: kCATransition)
       }
    
    @objc  func createRegisterUsingFacebook(){
        
        if self.fbView.isAllValid() {
            registerData.emailAddress = self.fbView.emailTF.text!
            registerData.mobileNumber = self.fbView.mobileTF.text!
            //registerData.mobileNumber = self.fbView.mobileTF.text!
            registerData.firstName = self.fbView.firstNameTF.text!
            registerData.lastName   = self.fbView.lastNameTF.text!
            
            CallCreateUserApi(isFaceBook:true)
        }
    }
    //MARK:- FB Toggle
    @objc func  changeToggleUsingFacebook(_ sender:UIButton){
        fbView._btnNewsOffer.isSelected = !fbView._btnNewsOffer.isSelected
        if fbView._btnNewsOffer.isSelected {
                   print("I am selected.")
                   fbView.notifyLbl?.textColor = .black
                   sender.setImage(#imageLiteral(resourceName: "ic_switch_on"), for: .normal)
               } else {
                   print("I am not selected.")
                   fbView.notifyLbl?.textColor = UIColor(red: 97.0/255, green: 97.0/255, blue: 97.0/255, alpha: 1)
                   sender.setImage(#imageLiteral(resourceName: "ic_switch_off"), for: .normal)
               }
    }
    //MARK:- Buttons Action
    @IBAction func showCountryList(_ sender: Any) {
        print("Show Country List")
        
       
    }
    func showTermandConditions(){
        let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
        let changeVC = storyboards.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
         changeVC!.screenType = "TermsAndCondition"
        self.navigationController?.pushViewController(changeVC!, animated: true)
    }
    @IBAction func termAndConditionSelector(_ sender: UIButton) {
        showTermandConditions()
    }
    
    //MARK:- Check Email Available
    
    func CheckEmailAvailbaleRegis(email: String, onCompletion: @escaping isAvailbleMail)  {
        MBProgressHUD.showAdded(to: view, animated: true)
        var emailStatus : Bool? = nil
        let params = [
            "customerEmail" : email,
            "websiteId" : getWebsiteId()
            ] as [String : Any] as [String : Any]
        let url = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/" + CommonUsed.globalUsed.isEmailAvailable
        ApiManager.apiPostWithHeaderCode(url: url, params: params) {(response:JSON?, error:Error?, statusCode: Int ) in
            if let error = error{
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
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let info = JSON(rawValue: response!)
                    emailStatus = info?.rawValue as? Bool
                    onCompletion(emailStatus)
                }
                
            }
        }
        //        return emailStatus!
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
           ApiManager.apiPut(url: urlReadOnly, params: param){ (response:JSON?, error:Error?) in
               
               if let error = error{
                   MBProgressHUD.hide(for: self.view, animated: true)
                   return
               }
               
               if response != nil{
                self.getTokenApiAfterFaceBooKRegistration(emil:faceBookView.emailTF.text! , fbID:faceBookView.fb_ID ,customerId:customerId)
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
   func validateCreateButtonEnable(){
        
        if firstNameTF.text!.length > 0 && lastNameTF.text!.length > 0 && emailTF.text!.length > 0  && passwordTF!.text!.length > 0 && confirmPassTF.text!.length > 0{
            createBtn.setBackgroundColor(color:.black, forState: .normal)
             createBtn.isUserInteractionEnabled = true
            
        }else{
            createBtn.setBackgroundColor(color:UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0), forState: .normal)
             createBtn.isUserInteractionEnabled = false
        }
       
        
    }
   
    @IBAction func termConditionBtnAction(_ sender:UIButton){
        let storyboards = UIStoryboard(name: "MyProfile", bundle: Bundle.main)
        let changeVC = storyboards.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as? PrivacyPolicyViewController
        self.navigationController?.pushViewController(changeVC!, animated: true)

    }

}
extension RegistrationUserViewController:NoInternetDelgate{
    func didCancel() {
        
    }
}

extension RegistrationUserViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

       
        return NSAttributedString(string: titleArray[row], attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if tagNo == 1 {
            return self.titleArray.count ?? 0
        }
        else{
            return countryData.count
        }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if tagNo == 1 {
            _txtSalutation.text = titleArray[row]
        }
        else{
            if tagNo == 101 {
                if row == 0 {
                    txtCountryCode.text = ""
                }
                else{
                   txtCountryCode.text = "+\(countryData[row].countryCode)"
                }
                
            }
            else{
                if row == 0 {
                    txtCountryCode.text = ""
                }
                else{
                    self.fbView.txtIsdcode.text = "+\(countryData[row].countryCode)"
                    print("COUNTRY CODE FOR FB \("+\(countryData[row].countryCode)")")
                }
            }
        }
  
       }
       
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if tagNo == 1 {
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.text = self.titleArray[row]
            return label
        }
        else{
            var label: UILabel
            if let view = view as? UILabel { label = view }
            else { label = UILabel() }
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            let countryCode = countryData[row].countryCode
            let countryName = countryData[row].countryName
            if row == 0 {
               // label.font = .boldSystemFont(ofSize: 20)
                label.text = "\(countryName)".localized
            }
            else{
                label.text = "+\(countryCode)  \(countryName)"
            }
            
            return label
        }
    }

}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
