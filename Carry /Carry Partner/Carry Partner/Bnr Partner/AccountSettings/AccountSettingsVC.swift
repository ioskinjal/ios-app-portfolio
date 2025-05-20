
//
//  AccountSettingsVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire


class AccountSettingsVC: BaseVC,CodeDelegate {
    
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    @IBOutlet weak var txtPanicContactNo: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var txtPayalEmail: UITextField!
    
    @IBOutlet weak var rideCancelImgView: UIImageView!
    @IBOutlet weak var rideCompleteImgView: UIImageView!
    @IBOutlet weak var fundDepositImgView: UIImageView!
    @IBOutlet weak var redeemRequestImgView: UIImageView!
    
    // UIView for border
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    
    @IBOutlet weak var panicContactView: UIView!
    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtSelectionsLanguage:UITextField!
    @IBOutlet weak var selectionsLanguageView:UIView!
    @IBOutlet weak var btnUpdateLanguage:UIButton!{
        didSet{
            btnUpdateLanguage.addTarget(self, action: #selector(didTapBtnUpdateLanguage), for: .touchUpInside)
        }
    }
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var lblChangePasswordConst:UILabel!
    @IBOutlet weak var btnChnagePassword:UIButton!
    @IBOutlet weak var lblChangePaypalEmailConst:UILabel!
    @IBOutlet weak var btnChnagePayPalEmail:UIButton!
    @IBOutlet weak var lblChnageSelectLanguage:UILabel!
    @IBOutlet weak var lblChnageNotificationsConst:UILabel!
    @IBOutlet weak var lblnotifyMeWhenRideIsCancel:UILabel!
    @IBOutlet weak var lblnotifyMeWhenRideIsComplete:UILabel!
    @IBOutlet weak var btnSaveNotificationsSetting:UIButton!
    
    
    
    var accountSetting = AccountSetting()
    var selectedCode = CountryCode()
    
    var countryCodes = NSArray()
    var picker = UIPickerView()
    var language = [Language]()
    var selectedLanguage:Language = Language.getLanguage()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
        }
        
        picker.delegate = self
        picker.dataSource = self
        txtSelectionsLanguage.inputView = picker
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountryCodes()
        self.layoutSetup()
        self.fetchLanguage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAccountSettings()
        setConst()
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setConst(){
        txtSelectionsLanguage.text = Language.getLanguage().languageName
        navTitle.text = appConts.const.tITLE_ACCOUNT_SETTINGS
        lblChangePasswordConst.text = appConts.const.lBL_CHANGE_PASSWORD
        txtOldPassword.placeholder = appConts.const.lBL_OLD_PWD
        txtNewPassword.placeholder = appConts.const.lBL_NEW_PASSWORD
        txtConfirmNewPassword.placeholder = appConts.const.lBL_CONFIRM_PWD
        btnChnagePassword.setTitle(appConts.const.lBL_CHANGE_PASSWORD.uppercased(), for: .normal)
        lblChangePaypalEmailConst.text = appConts.const.lBL_CHANGE_PAYPAL_EMAIL
        txtPayalEmail.placeholder = appConts.const.lBL_PAYPAL_EMAIL
        btnChnagePayPalEmail.setTitle(appConts.const.lBL_CHANGE_PAYPAL_EMAIL.uppercased(), for: .normal)
        lblChnageSelectLanguage.text = appConts.const.lBL_CHANGE_LANGUAGE
        txtSelectionsLanguage.placeholder = appConts.const.lBL_CHANGE_LANGUAGE
        btnUpdateLanguage.setTitle(appConts.const.lBL_CHANGE_LANGUAGE.uppercased(), for: .normal)
        lblChnageNotificationsConst.text = appConts.const.cHANGE_SETTINGS
        lblnotifyMeWhenRideIsCancel.text = appConts.const.lBL_NOTIFY_RIDE_CANCEL
        lblnotifyMeWhenRideIsComplete.text = appConts.const.lBL_NOTIFY_RIDE_COMPLETED
        btnSaveNotificationsSetting.setTitle(appConts.const.bTN_NOTIFICATION_SETTINGS.uppercased(), for: .normal)
        
    }
    
    func layoutSetup(){
        oldPasswordView.applyBorder(color: UIColor.lightGray, width: 1.0)
        newPasswordView.applyBorder(color: UIColor.lightGray, width: 1.0)
        confirmPasswordView.applyBorder(color: UIColor.lightGray, width: 1.0)
        panicContactView.applyBorder(color: UIColor.lightGray, width: 1.0)
        paypalView.applyBorder(color: UIColor.lightGray, width: 1.0)
        selectionsLanguageView.applyBorder(color: .lightGray, width: 1.0)
        
    }
    
    func fetchLanguageConst(){
        let alert = Alert()
        startIndicator(title: "")
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.languageConst, parameters: ["deviceId":CustomerDefaults.getDeviceToken(),"lId":Language.getLanguage().id], successBlock: { (json, urlResponse) in
            
                        self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                let data = jsonDict?.object(forKey: "response") as! [String:Any]
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = documentDirectory.appending("/bnrPartnerConts.plist")
                
                
                let appConstData = NSDictionary(dictionary: data)
                let isWritten = appConstData.write(toFile: path, atomically: true)
                AppConst.shared.setConst(data: data)
                self.setConst()
                NotificationCenter.default.post(name: NSNotification.Name("ConstChnage"), object: nil)
                print("is the file created: \(isWritten)")
                
                self.sharedAppDelegate().rootToHome()
            }
            else{
                DispatchQueue.main.async {
                    //                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                //                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    
    // MARK: - Settings & Country Code WS Methods
    
    func getAccountSettings(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "lId":Language.getLanguage().id
                 ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Settings.getAccountSettings, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    print("Items \(dataAns)")
                    
                    
                    self.accountSetting = AccountSetting.initWithResponse(array: (dataAns as! [Any]))
                    
                    
                    DispatchQueue.main.async {
                        self.displaySettings(settings: self.accountSetting)
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func updateAccountSettings(settings:AccountSetting){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "ride_cancel":settings.ride_cancel,
                 "ride_complete":settings.ride_complete,
                 "deposit_fund":settings.deposit_fund,
                 "redeem_request_accept_or_reject":settings.redeem_request_accept_or_reject,
                 "lId":Language.getLanguage().id
                 ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Settings.updateAccountSettings, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                self.getAccountSettings()
                DispatchQueue.main.async {
                    //  alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                    
                    
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    func displaySettings(settings:AccountSetting){
        
        if settings.ride_cancel.lowercased() == "y" {
            self.rideCancelImgView.image = #imageLiteral(resourceName: "checkbox_selected")
        }
        else{
            self.rideCancelImgView.image = #imageLiteral(resourceName: "checkbox_deselected")
        }
        
        if settings.ride_complete.lowercased() == "y" {
            self.rideCompleteImgView.image = #imageLiteral(resourceName: "checkbox_selected")
        }
        else{
            self.rideCompleteImgView.image = #imageLiteral(resourceName: "checkbox_deselected")
        }
        
        if settings.deposit_fund.lowercased() == "y" {
            self.fundDepositImgView.image = #imageLiteral(resourceName: "checkbox_selected")
            
        }
        else{
            self.fundDepositImgView.image = #imageLiteral(resourceName: "checkbox_deselected")
            
        }
        
        if settings.redeem_request_accept_or_reject.lowercased() == "y" {
            self.redeemRequestImgView.image = #imageLiteral(resourceName: "checkbox_selected")
            
        }
        else{
            self.redeemRequestImgView.image = #imageLiteral(resourceName: "checkbox_deselected")
            
        }
        
        self.txtPanicContactNo.text = settings.panicNumber
        self.lblCountryCode.text = settings.panicCountryNumber
        self.txtPayalEmail.text = settings.paypalEmail
    }
    
    func getCountryCodes(){
        
        let params: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.countryCode, parameters: params, successBlock: { (json, urlResponse) in
            
            // print("Request: \(String(describing: urlResponse?.request))")   // original url request
            // print("Response: \(String(describing: urlResponse?.response))") // http url response
            //print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let codes = CountryCode.initWithResponse(array: (dataAns as! [Any]))
                self.countryCodes = codes as NSArray
                
                
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    func updatePaypalEmail(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "email":self.txtPayalEmail.text ?? "",
                 "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Settings.editpaypalemail, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                // print("Request: \(String(describing: urlResponse?.request))")   // original url request
                // print("Response: \(String(describing: urlResponse?.response))") // http url response
                //print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                _ = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                self.accountSetting.paypalEmail = self.txtPayalEmail.text!
                
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
            
        }else{
            displayNetworkAlert()
        }
    }
    
    func changePassword(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "userType":"d",
                 "oldPassword":self.txtOldPassword.text!,
                 "newPassword":self.txtNewPassword.text!,
                 "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.chnagePassowrd, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                // print("Request: \(String(describing: urlResponse?.request))")   // original url request
                // print("Response: \(String(describing: urlResponse?.response))") // http url response
                //print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                _ = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                self.sharedAppDelegate().currentUser?.password = self.txtNewPassword.text!
                User.saveUser(loggedUser: self.sharedAppDelegate().currentUser!)
                
                
                DispatchQueue.main.async {
                    self.txtOldPassword.text = ""
                    self.txtNewPassword.text = ""
                    self.txtConfirmNewPassword.text = ""
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        
    }
    
    func updatePanicContactNumber(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            let parameters: Parameters =
                ["userId":sharedAppDelegate().currentUser!.uId,
                 "userType":"d",
                 "panicCountryCode":selectedCode.typeId,
                 "panicNumber":self.txtPanicContactNo.text!,
                 "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Panic.editContact, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                // print("Request: \(String(describing: urlResponse?.request))")   // original url request
                // print("Response: \(String(describing: urlResponse?.response))") // http url response
                //print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                _ = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                DispatchQueue.main.async {
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
        
    }
    
    // MARK: - Code Delegate method
    func didSelectCode(code: CountryCode) {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? AccountSettingsVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        self.selectedCode = code
        self.lblCountryCode.text = code.country_code
    }
    
    func fetchLanguage(){
        let alert = Alert()
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.getLanguage, parameters: ["lId":Language.getLanguage().id], successBlock: { (json, urlResponse) in
            
            //            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                let data = jsonDict?.object(forKey: "dataAns") as! [Any]
                self.language = data.map({Language(data: $0 as! [String:Any])})
                self.picker.reloadAllComponents()
                
            }
            else{
                DispatchQueue.main.async {
                    //                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                //                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func btnAccountSettingsMenuClicked(_ sender: Any) {
        openMenu()
        
    }
    @IBAction func btnOpenCountryCodeClicked(_ sender: Any) {
        
        if self.countryCodes.count > 0 {
            let codeController = CountryCodeVC(nibName: "CountryCodeVC", bundle: nil)
            codeController.delegate = self
            codeController.codes = self.countryCodes
            self.addChildViewController(codeController)
            view.addSubview(codeController.view)
            
            codeController.view.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
            
            let trailingConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            let topConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint =  NSLayoutConstraint(item: codeController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
            self.view.layoutIfNeeded()
            
            codeController.didMove(toParentViewController: self)
        }
        else{
            let alert = Alert()
            alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.pLEASE_ENTER_COUNTRY_CODE, buttonTitleStr: appConts.const.bTN_OK)
        }
    }
    
    @IBAction func btnChangePasswordClicked(_ sender: Any) {
        
        let alert = Alert()
        
        if (self.txtOldPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_OLD_PWD, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtNewPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_NEW_PWD, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtConfirmNewPassword.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_CONFIRM_PWD, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtConfirmNewPassword.text != self.txtNewPassword.text){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_PWD_NO_MATCH, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            self.changePassword()
            
        }
    }
    
    @IBAction func btnChangePanicContactNoClicked(_ sender: Any) {
        
        
        let alert = Alert()
        
        if (self.lblCountryCode.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.pLEASE_ENTER_COUNTRY_CODE, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtPanicContactNo.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_INVALID_CONTACT, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            self.updatePanicContactNumber()
            
        }
    }
    
    @IBAction func btnChangePaypalEmailClicked(_ sender: Any) {
        
        let alert = Alert()
        let validate = Validator()
        
        if (self.txtPayalEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: self.txtPayalEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            self.updatePaypalEmail()
            
        }
    }
    
    
    
    @IBAction func btnRideCancelClicked(_ sender: Any) {
        if self.accountSetting.ride_cancel == "y" {
            self.accountSetting.ride_cancel = "n"
        }
        else{
            self.accountSetting.ride_cancel = "y"
            
        }
        self.displaySettings(settings: self.accountSetting)
    }
    
    
    @IBAction func btnRideCompletedClicked(_ sender: Any) {
        if self.accountSetting.ride_complete == "y" {
            self.accountSetting.ride_complete = "n"
        }
        else{
            self.accountSetting.ride_complete = "y"
            
        }
        self.displaySettings(settings: self.accountSetting)
    }
    
    @IBAction func btnDepositFundClicked(_ sender: Any) {
        if self.accountSetting.deposit_fund == "y" {
            self.accountSetting.deposit_fund = "n"
        }
        else{
            self.accountSetting.deposit_fund = "y"
            
        }
        self.displaySettings(settings: self.accountSetting)
    }
    
    @IBAction func btnRedeemRequestNotifyClicked(_ sender: Any) {
        if self.accountSetting.redeem_request_accept_or_reject == "y" {
            self.accountSetting.redeem_request_accept_or_reject = "n"
        }
        else{
            self.accountSetting.redeem_request_accept_or_reject = "y"
            
        }
        self.displaySettings(settings: self.accountSetting)
    }
    
    @IBAction func btnSaveNotificaitonSettingsClicked(_ sender: Any) {
        self.updateAccountSettings(settings: self.accountSetting)
        
    }
    @objc func didTapBtnUpdateLanguage(){
        
        if selectedLanguage.id == -1{
            self.alert(title: "", message: appConts.const.lBL_SELECT_LANGUAGE)
        }else{
            Language.saveLanguage(loggedUser: selectedLanguage)
            fetchLanguageConst()
        }
    }
}

extension AccountSettingsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return language.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Select language"
        } else {
            return language[row - 1].languageName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0) {
            self.txtSelectionsLanguage.text = ""
            self.selectedLanguage = Language(data: [:])
        } else{
            if language.count > 0{
                txtSelectionsLanguage.text = language[row - 1].languageName
                self.selectedLanguage = self.language[row - 1]
            }
        }
    }
}
