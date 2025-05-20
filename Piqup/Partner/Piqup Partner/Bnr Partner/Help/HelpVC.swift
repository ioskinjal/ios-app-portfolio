//
//  HelpVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class HelpVC: BaseVC,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var fNameView: UIView!
    @IBOutlet weak var lNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblQuery: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var lblGetInTouch:UILabel!
    @IBOutlet weak var lblAlwaysWithinYouReachConst:UILabel!
    @IBOutlet weak var btnSend:UIButton!
    
    var selectedCode = CountryCode()
    var countryCodes = NSArray()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
            // safe area constraints already set
        }
        else {
            self.topLayoutConstraint = self.navView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor)
            self.topLayoutConstraint.isActive = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCode.country_code = "+91"
        layoutSetup()
        getCountryCodes()
        displayUser()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navTitle.text = appConts.const.hELP
      //  lblGetInTouch.text = appConts.const.lBL_IN_TOUCH
        //lblAlwaysWithinYouReachConst.text = appConts.const.lBL_IN_TOUCH_TAG
        //txtEmail.placeholder = appConts.const.lBL_EMAIL
        //txtLastName.placeholder = appConts.const.lBL_LAST_NAME
        //txtFirstName.placeholder = appConts.const.lBL_FIRST_NAME
        //txtMobileNumber.placeholder = appConts.const.lBL_MOBILE_NO
        //lblQuery.text = appConts.const.lBL_QUERY
        //btnSend.setTitle(appConts.const.bTN_SEND, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Mobile Number textfield max length is fixed to 15
        if textField == self.txtMobileNumber {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered:String = compSepByCharInSet.joined(separator: "")
            let totalText:String = describe(self.txtMobileNumber.text)
            
            if (string == numberFiltered) && (totalText.count <= 14) {
                return true
            }
            else if string == "" {
                return true
            }
            else{
                return false
            }
            
        }
        
        return true
    }

    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        
        if self.countryCodes.count > 0 {
            
            self.view.endEditing(true)
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
            getCountryCodes()
        }
    }
    @IBAction func btnHelpMenuClicked(_ sender: Any) {
        openMenu()
        
    }
    
    @IBAction func btnSendHelpClicked(_ sender: Any) {
        
        let alert = Alert()
        let validate = Validator()
        
        if (self.txtFirstName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_FIRST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtLastName.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_LAST_NAME, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: self.txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtMobileNumber.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.pLEASE_ENTER_MOBILE_NO, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtDescription.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.lBL_QUERY, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            contactUs()
            
        }
    }
    func layoutSetup(){
        fNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        lNameView.applyBorder(color: UIColor.lightGray, width: 1.0)
        emailView.applyBorder(color: UIColor.lightGray, width: 1.0)
        mobileNumberView.applyBorder(color: UIColor.lightGray, width: 1.0)
        descriptionView.applyBorder(color: UIColor.lightGray, width: 1.0)
    }
    
    func displayUser(){
        
        self.txtFirstName.text = sharedAppDelegate().currentUser?.firstName
        self.txtLastName.text = sharedAppDelegate().currentUser?.lastName
        self.txtEmail.text = sharedAppDelegate().currentUser?.email
        self.txtMobileNumber.text  = sharedAppDelegate().currentUser?.mobileNo
        
        self.lblCountryCode.text = "+"+(sharedAppDelegate().currentUser?.countryCode)!
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMobileNumber{
            // self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            
        }
        else if textField == txtEmail {
            // self.scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lblQuery.isHidden = true
        self.scrollView.isScrollEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.lblQuery.isHidden = false
        }
        else{
            self.lblQuery.isHidden = true
        }
        self.scrollView.isScrollEnabled = true
    }
    
    func getCountryCodes(){
        
        let params: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        startIndicator(title: "")
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.countryCode, parameters: params, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let codes = CountryCode.initWithResponse(array: (dataAns as! [Any]))
                self.countryCodes = codes as NSArray
                
                for code in self.countryCodes {
                    
                    let newCode = code as! CountryCode
                    
                    if newCode.country_code == "+91"
                    {
                        self.selectedCode = newCode
                        break
                    }else{
                        let newCode = code as! CountryCode
                        let strCode:String = self.sharedAppDelegate().currentUser?.countryCode ?? ""
                        if newCode.typeId == strCode{
                            self.lblCountryCode.text =  newCode.country_code
                            self.selectedCode = newCode
                            break
                        }
                    }
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
        
    }
    
    func contactUs(){
        
        if NetworkManager.isNetworkConneted() {
            let params: Parameters = [
                "firstName":txtFirstName.text!,
                "lastName":txtLastName.text!,
                "emailAddress":txtEmail.text!,
                "countryCode":lblCountryCode.text!,
                "mobileNo":txtMobileNumber.text!,
                "message":txtDescription.text!,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Contact.contactUs, parameters: params, successBlock: { (json, urlResponse) in
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HelpVC:CodeDelegate{
    func didSelectCode(code: CountryCode) {
        if let nav = self.navigationController, let codeVC = nav.topViewController as? HelpVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
        selectedCode = code
        
        lblCountryCode.text = code.country_code
    }
}
