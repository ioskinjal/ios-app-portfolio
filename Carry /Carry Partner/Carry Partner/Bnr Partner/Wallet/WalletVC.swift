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
    
    @IBOutlet weak var navTitle:UILabel!
    @IBOutlet weak var lblCurrentBalanceConst:UILabel!
    @IBOutlet weak var lblBookRideConst:UILabel!
    @IBOutlet weak var lblRedeemRequestConst:UILabel!
    @IBOutlet weak var lblRedeemAmountConst:UILabel!
    @IBOutlet weak var btnViewRedeemHistoryConst:UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBalance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navTitle.text = appConts.const.wALLET
        lblCurrentBalance.text = appConts.const.cURRENT_BAL
        lblBookRideConst.text = appConts.const.cURRENT_BAL_MSG
        lblRedeemRequestConst.text = appConts.const.rEDEEM_REQ
        lblRedeemAmountConst.text = appConts.const.rEDEEM_REQ_MSG
        btnViewRedeemHistoryConst.setTitle(appConts.const.rEDEEM_HISTORY, for: .normal)
    }
    
    func getBalance(){
        
    
        let parameters: Parameters = ["lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.getBalance, parameters: parameters, successBlock: { (json, urlResponse) in
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                
                print("Items \(dataAns)")
                
                DispatchQueue.main.async {
                    
              
                    
                }
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
    
    @IBAction func btnWalletMenuClicked(_ sender: Any) {
       openMenu()
    }
    
    @IBAction func btnDepositFundClicked(_ sender: Any) {
        
        let depositController = DepositFundVC(nibName: "DepositFundVC", bundle: nil)
        self.navigationController?.pushViewController(depositController, animated: true)
    }
    
    @IBAction func btnRedeemRequestClicked(_ sender: Any) {
        let depositController = RedeemFundVC(nibName: "RedeemFundVC", bundle: nil)
        self.navigationController?.pushViewController(depositController, animated: true)
    }
    

    @IBAction func btnViewRedeemHistoryClicked(_ sender: Any) {
        
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
