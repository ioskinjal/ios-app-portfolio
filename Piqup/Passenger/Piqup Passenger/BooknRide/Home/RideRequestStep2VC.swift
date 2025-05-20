//
//  RideRequestStep2VC.swift
//  Carry
//
//  Created by NCrypted on 20/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices.UTType

class RideRequestStep2VC: BaseVC,CodeDelegate {
    
    let requestTypePickerView = UIPickerView()
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewSenderName: UIView!
    @IBOutlet weak var viewSenderEmail: UIView!
    @IBOutlet weak var btnNO: UIButton!
    @IBOutlet weak var btnyes: UIButton!
    @IBOutlet weak var btnMyself: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var txtNumber: UITextField!{
        didSet{
            txtNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCode: UITextField!{
        didSet{
            txtCode.rightView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), image: #imageLiteral(resourceName: "Dropdown"))
        }
    }
    @IBOutlet weak var txtSenderEmail: UITextField!{
        didSet{
            txtSenderEmail.keyboardType = .emailAddress
        }
    }
    @IBOutlet weak var txtSenderName: UITextField!
    @IBOutlet weak var navigationView: UIView!
    
    var selectedCode = CountryCode()
    var countryCodes = NSArray()
    var strReceipent:String = ""
    var strVerification:String = "y"
    var selectedRequestType:[String:String] = [:]
    var requestType = [[
        "isScheduled": "0",
        "name":  "Quick Request"
        ],[
            "isScheduled": "1",
            "name": "Scheduled Request"
        ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onClickSelectReceipent(btnMyself)
        onClickVerificationCode(btnNO)
        selectedCode.country_code = "+91"
        getCountryCodes()
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
                    }
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
        
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    func isValidated() -> Bool {
        
        let validate = Validator()
        var ErrorMsg = ""
        
        if strReceipent != "myself" {
        if (txtSenderName.text?.isEmpty)! {
            ErrorMsg = "Please enter recipient name"
        }
//        else if (txtSenderEmail.text?.isEmpty)! {
//            ErrorMsg = "Please enter sender email id"
//        }
            
        
        else if (txtNumber.text?.isEmpty)! {
            ErrorMsg = "Please enter recipient phone number"
        }else if txtNumber.text?.count != 10 {
            ErrorMsg = "Please enter valid phone number"
            }
        }else{
            if (txtSenderName.text?.isEmpty)! {
                ErrorMsg = "Please enter sender name"
            }
//            else if (txtSenderEmail.text?.isEmpty)! {
//                ErrorMsg = "Please enter email id"
//            }
            else if (txtNumber.text?.isEmpty)! {
                ErrorMsg = "Please enter sender phone number"
            }else if txtNumber.text?.count != 10 {
                ErrorMsg = "Please enter valid phone number"
            }
           
        }
        if txtSenderEmail.text != ""{
            if !validate.isValidEmail(emailStr: txtSenderEmail.text!){
                ErrorMsg = "Please enter a valid email id"
            }
        }
        if ErrorMsg != "" {
            let alert = UIAlertController(title: "Error", message: ErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    
    // MARK: - Code Delegate method
    func didSelectCode(code: CountryCode) {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? RideRequestStep2VC {
            
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
        
        txtCode.text = code.country_code
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickContinue(_ sender: UIButton) {
        if isValidated(){
            if strReceipent == "other"{
                dictParam["recipientName"] = sharedAppDelegate().currentUser!.firstName
                dictParam["recipientEmail"] = sharedAppDelegate().currentUser!.email
                dictParam["recipientPhone"] = "+" + sharedAppDelegate().currentUser!.countryCode + sharedAppDelegate().currentUser!.mobileNo
                dictParam["verificationCodeRequired"] = strVerification
                dictParam["senderName"] = txtSenderName.text!
                dictParam["senderEmail"] = txtSenderEmail.text!
                dictParam["senderPhone"] = "+" + txtCode.text! + txtNumber.text!
                
            }else{
                dictParam["senderName"] = sharedAppDelegate().currentUser!.firstName
                dictParam["senderEmail"] = sharedAppDelegate().currentUser!.email
                dictParam["senderPhone"] = "+" + sharedAppDelegate().currentUser!.countryCode + sharedAppDelegate().currentUser!.mobileNo
                dictParam["verificationCodeRequired"] = strVerification
                dictParam["recipientName"] = txtSenderName.text!
                dictParam["recipientEmail"] = txtSenderEmail.text!
                dictParam["recipientPhone"] = "+" + txtCode.text! + txtNumber.text!
                
            }
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let requestRideVC2 = storyBoard.instantiateViewController(withIdentifier: "RequestRideStep3VC") as! RequestRideStep3VC
            self.navigationController?.pushViewController(requestRideVC2, animated: true)
        }
    }
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
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
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_COUNTRY_SELECTION    , buttonTitleStr: appConts.const.bTN_OK)
        }
    }
    
    
    @IBAction func onClickSelectReceipent(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage == #imageLiteral(resourceName: "Radio"){
                sender.setImage(#imageLiteral(resourceName: "SelectRadio"), for: .normal)
                btnOther.setImage(#imageLiteral(resourceName: "Radio"), for: .normal)
                strReceipent = "myself"
                txtSenderName.placeholder = "SENDER NAME*"
                txtSenderEmail.placeholder = "SENDER EMAIL ID"
                txtNumber.placeholder = "SENDER PHONE NUMBER*"
            }
        }else{
            if sender.currentImage == #imageLiteral(resourceName: "Radio"){
                
                sender.setImage(#imageLiteral(resourceName: "SelectRadio"), for: .normal)
                btnMyself.setImage(#imageLiteral(resourceName: "Radio"), for: .normal)
                strReceipent = "other"
                txtSenderName.placeholder = "RECIPIENT NAME*"
                txtSenderEmail.placeholder = "RECIPIENT EMAIL ID"
                txtNumber.placeholder = "RECIPIENT PHONE NUMBER*"
                
            }
        }
    }
    
    @IBAction func onClickVerificationCode(_ sender: UIButton) {
        if sender.tag == 0{
            if sender.currentImage == #imageLiteral(resourceName: "Radio"){
                sender.setImage(#imageLiteral(resourceName: "SelectRadio"), for: .normal)
                btnNO.setImage(#imageLiteral(resourceName: "Radio"), for: .normal)
                strVerification = "y"
                
            }
        }else{
            if sender.currentImage == #imageLiteral(resourceName: "Radio"){
                sender.setImage(#imageLiteral(resourceName: "SelectRadio"), for: .normal)
                btnyes.setImage(#imageLiteral(resourceName: "Radio"), for: .normal)
                strVerification = "n"
                
            }
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
