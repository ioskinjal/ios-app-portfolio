//
//  RedeemRequestVC.swift
//  Carry
//
//  Created by NCrypted on 19/12/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class RedeemRequestVC: BaseVC {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var txtDesc: UITextView!{
        didSet{
            txtDesc.placeholder = "DESCRIPTION*"
        }
    }
    @IBOutlet weak var txtAmmount: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var balance = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.lblAvailableBalance.text = String(format:"\(appConts.const.aVAILAB_BAL) \(ParamConstants.Currency.currentValue)%@",self.balance)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitRedeemRequqest(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser?.uId ?? "",
                "emailAddress":self.txtEmail.text!,
                "amount":self.txtAmmount.text!,
                "description":self.txtDesc.text!,
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

    @IBAction func onClickSubmit(_ sender: UIButton) {
        let validate = Validator()
        let alert = Alert()
        
        if (txtEmail.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if !validate.isValidEmail(emailStr: txtEmail.text!){
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.vALID_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if (txtAmmount.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.REQ_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if Int(txtAmmount.text!)! < 1 {
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.REQ_VALID_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else if (txtDesc.text?.isEmpty)!{
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.mSG_INVALID_DESC, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else{
            self.view.endEditing(true)
            
            submitRedeemRequqest()
            
        }
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        //openMenu()
        self.navigationController?.popViewController(animated: true)
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
