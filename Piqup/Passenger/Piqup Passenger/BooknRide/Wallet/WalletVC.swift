//
//  WalletVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class WalletVC: BaseVC {
    
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblRedeemRequest: UILabel!
    
    @IBOutlet weak var viewDeposit: UIView!
    @IBOutlet weak var currentBalanceView: UIView!
    @IBOutlet weak var reedemBalaneView: UIView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var lblDepositeAmnt: UILabel!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var lblCurrentBalanceConst:UILabel!

    @IBOutlet weak var lblAmountUsedForRedeemRequest:UILabel!
    @IBOutlet weak var lblViewRedeemHistory:UILabel!
    @IBOutlet weak var btnDepositFunc:UIButton!
    @IBOutlet weak var btnRedeemRequest:UIButton!

    var currentBalance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        // Do any additional setup after loading the view.
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
    
    func layoutSetup(){
        self.currentBalanceView.applyBorder(color: UIColor.lightGray, width: 1.0)
        self.reedemBalaneView.applyBorder(color: UIColor.lightGray, width: 1.0)
        self.viewDeposit.applyBorder(color: UIColor.lightGray, width: 1.0)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
       // getBalance()
        getWalletDetails()
        
    }
    
//    func getBalance(){
//
//
//        let parameters: Parameters = ["userId":sharedAppDelegate().currentUser?.uId ?? ""]
//
//        let alert = Alert()
//
//        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.getBalance, parameters: parameters, successBlock: { (json, urlResponse) in
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
//
//            if status == true{
//
//                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
//                let balanceDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//
//                print("Items \(dataAns)")
//
//                DispatchQueue.main.async {
//
//                    if let balance = balanceDict.object(forKey: "currenctBalance") {
//                    self.currentBalance = balance as! String
//                    self.lblCurrentBalance.text = "\(ParamConstants.Currency.currentValue)\(self.currentBalance)"
//                    }
//                }
//            }
//            else{
//                DispatchQueue.main.async {
//
//                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: "OK")
//
//                }
//            }
//        }) { (error) in
//            DispatchQueue.main.async {
//
//                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: "OK")
//            }
//        }
//    }
    
    func getWalletDetails(){
        
        
        let parameters: Parameters = ["userId":sharedAppDelegate().currentUser?.uId ?? "","lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.getDetails, parameters: parameters, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let balanceDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                print("Items \(dataAns)")
                
                DispatchQueue.main.async {
                    
                    if let balance = balanceDict.object(forKey: "currenctBalance") {
                        self.currentBalance = balance as! String
                        
                        if self.currentBalance.isEmpty{
                            self.currentBalance = "0"
                        }
                        self.lblCurrentBalance.text = "\(ParamConstants.Currency.currentValue)\(self.currentBalance)"
                    }
                    
                    if let redeemRequest = balanceDict.object(forKey: "redeemRequest") {
                        var finalRequest = redeemRequest as! String
                        if finalRequest.isEmpty{
                            finalRequest = "0"
                        }
                        self.lblRedeemRequest.text = "\(ParamConstants.Currency.currentValue)\(finalRequest)"
                    }
                    
                    if let depositFund = balanceDict.object(forKey: "depositFund") {
                        var finalRequest = depositFund as! String
                        if finalRequest.isEmpty{
                            finalRequest = "0"
                        }
                        self.lblDepositeAmnt.text = "\(ParamConstants.Currency.currentValue)\(finalRequest)"
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
                
                alert.showAlert(titleStr: "", messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
    }
    
    // MARK: Button events
    @IBAction func btnWalletMenuClicked(_ sender: Any) {
        openMenu()
    }
    
    @IBAction func btnDepositFundClicked(_ sender: Any) {
        
        let depositController = DepositFundVC(nibName: "DepositFundVC", bundle: nil)
        depositController.balance = self.currentBalance
        self.navigationController?.pushViewController(depositController, animated: true)
    }
    
    @IBAction func btnRedeemRequestClicked(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let requestRideVC2 = storyBoard.instantiateViewController(withIdentifier: "RedeemRequestVC") as! RedeemRequestVC
        requestRideVC2.balance = self.currentBalance
        self.navigationController?.pushViewController(requestRideVC2, animated: true)
        
    }
    
    @IBAction func btnViewRedeemHistoryClicked(_ sender: Any) {
        let historyController = RedeemHistoryVC(nibName: "RedeemHistoryVC", bundle: nil)
        
        self.navigationController?.pushViewController(historyController, animated: true)
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
