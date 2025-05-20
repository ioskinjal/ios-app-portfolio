//
//  ForgotPasswordVC.swift
//  BooknRide
//
//  Created by NCrypted on 30/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

// This protocol method is used to identify success/failure for forgotpassword
protocol ForgotPasswordDelegate {
    func dimissForgotPasswordClicked(isSuccess:Bool)
}

class ForgotPasswordVC: BaseVC {
    
    var delegate: ForgotPasswordDelegate?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.placeholder = appConts.const.lBL_EMAIL
        navTitle.text = appConts.const.lBL_FORGOT_PASSWORD
        btnDone.setTitle(appConts.const.bTN_DONE, for: .normal)
        btnClose.setTitle(appConts.const.cLOSE, for: .normal)
    }
    
    func forgotPassword(){
        
        startIndicator(title: "")
        let parameters: Parameters = [
            "email": txtEmail.text!,
            "userType": "u",
            "lId":Language.getLanguage().id
            ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.forgotPassword, parameters: parameters, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                self.delegate?.dimissForgotPasswordClicked(isSuccess: true)
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
    }
    
    // MARK: - Button event methods
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        if (txtEmail.text?.isEmpty)! {
            let throwAlert = Alert()
            throwAlert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.rEQ_EMAIL, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            forgotPassword()
        }
        
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        
        self.delegate?.dimissForgotPasswordClicked(isSuccess: false)
        
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
