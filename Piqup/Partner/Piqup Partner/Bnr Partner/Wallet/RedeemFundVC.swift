//
//  RedeemFundVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class RedeemFundVC: BaseVC {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var lblDescToHide: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
    }
    
    func submitRedeemRequqest(){
        
//        let params: Parameters = ["userId":appDelegate.currentUser!.uId]
//
//
//        let alert = Alert()
//
//        WSManager.getResponseFrom(serviceUrl: api, parameters: parameters, successBlock: { (json, urlResponse) in
//
//            print("Request: \(String(describing: urlResponse?.request))")   // original url request
//            print("Response: \(String(describing: urlResponse?.response))") // http url response
//            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
//
//            let jsonDict = json as NSDictionary?
//
//            let status = jsonDict?.object(forKey: "status") as! Bool
//            let message = jsonDict?.object(forKey: "message") as! String
//
//            if status == true{
//                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
//                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//                print("Items \(dataAns)")
//
//                let person = User.initWithResponse(dictionary: userDict as? [String : Any])
//
//                if person.isActive == "y"{
//                    DispatchQueue.main.async {
//
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        User.saveUser(loggedUser: person)
//                        appDelegate.currentUser = person
//                        appDelegate.rootToHome()
//
//                    }
//                }
//                else{
//                    DispatchQueue.main.async {
//                        alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
//                    }
//                }
//            }
//            else{
//                DispatchQueue.main.async {
//
//                    alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
//                }
//            }
//
//
//        }) { (error) in
//            DispatchQueue.main.async {
//
//                let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
//                self.navigationController?.present(oopsVC, animated: true, completion: nil)
//                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
//            }
//        }
        
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
            alert.showAlert(titleStr: appConts.const.aLERT, messageStr: appConts.const.pLEASE_ADD_AMOUNT, buttonTitleStr: appConts.const.bTN_OK)
            
        }
        else{
            self.view.endEditing(true)
           
            submitRedeemRequqest()
            
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
