//
//  RedeemFundVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class RedeemFundVC: BaseVC {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var lblDescToHide: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var lblNavTitle: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var balance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetup()
        displayBalance()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
    }
    
    func layoutSetup(){
        self.emailView.applyBorder(color: UIColor.lightGray, width: 1.0)
        self.amountView.applyBorder(color: UIColor.lightGray, width: 1.0)
        self.txtDescription.applyBorder(color: UIColor.lightGray, width: 1.0)

        lblNavTitle.text = appConts.const.rEDEEM_REQ
        submitBtn.setTitle(appConts.const.lBL_SUBMIT, for: UIControlState.normal)
        
        self.txtEmail.placeholder = appConts.const.lBL_EMAIL
        self.txtAmount.placeholder = appConts.const.aMOUNT
        self.lblDescToHide.text = appConts.const.dESCRIPTION
    }
    
    func displayBalance(){
        
        self.lblAvailableBalance.text = String(format:"\(appConts.const.aVAILAB_BAL) \(ParamConstants.Currency.currentValue)%@",self.balance)
        self.txtEmail.text = sharedAppDelegate().currentUser?.paypalEmail
        
    }
    
    func submitRedeemRequqest(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser?.uId ?? "",
                "emailAddress":self.txtEmail.text!,
                "amount":self.txtAmount.text!,
                "description":self.txtDescription.text!,
                "lId":Language.getLanguage().id
                ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.redeemRequest, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")     // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        // Success response of Redeem request.
                        alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.navigationController?.popViewController(animated: true)
                        })
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
        }else{
            displayNetworkAlert()
        }
        
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        
        let validate = Validator()
        let alert = Alert()
        
        if (txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if (txtAmount.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.REQ_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if Int(txtAmount.text!)! < 1 {
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.REQ_VALID_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if (txtDescription.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_INVALID_DESC, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else{
            self.view.endEditing(true)
           
            submitRedeemRequqest()
            
        }
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        self.txtEmail.becomeFirstResponder()
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

extension RedeemFundVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Mobile Number textfield max length is fixed to 15
        if textField == self.txtAmount {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered:String = compSepByCharInSet.joined(separator: "")
            let totalText:String = describe(self.txtAmount.text)
            
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
}

extension RedeemFundVC:UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.lblDescToHide.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            self.lblDescToHide.isHidden = false
        }
        else{
            self.lblDescToHide.isHidden = true
        }

}
}
