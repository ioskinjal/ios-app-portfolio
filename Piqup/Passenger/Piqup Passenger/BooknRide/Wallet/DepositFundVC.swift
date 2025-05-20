//
//  DepositFundVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class DepositFundVC: BaseVC {

    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblDepositFund: UILabel!
    
    @IBOutlet weak var lblAddFundDescription: UILabel!
    
    var balance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSetup()
        displayBalance(balance: self.balance)
        
        lblDepositFund.text = appConts.const.dEPOSIT_FUND
        lblAddFundDescription.text = appConts.const.fUND_MSG
        txtAmount.placeholder = appConts.const.LBL_ENTER_DEPOSIT_AMOUNT
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
    
    func layoutSetup(){
        self.depositView.applyBorder(color: UIColor.lightGray, width: 1.0)
    }
    
    func displayBalance(balance:String){
        self.lblAvailableBalance.text = String(format:"\(appConts.const.aVAILAB_BAL) \(ParamConstants.Currency.currentValue)%@",self.balance)
    }
    
    func depositFund(){
        
        let webController = PaypalWebVC(nibName: "PaypalWebVC", bundle: nil)
        webController.amount = self.txtAmount.text!
        self.navigationController?.pushViewController(webController, animated: true)
    }

    @IBAction func btnGoBackClicked(_ sender: Any) {
        goBack()
    }
    @IBAction func btnPayPalClicked(_ sender: Any) {
        
        let alert = Alert()
        
        if (self.txtAmount.text?.isEmpty)! {
            alert.showAlert(titleStr: "", messageStr: appConts.const.REQ_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)
        }
        else if Int(self.txtAmount.text!)! < 1 {
            alert.showAlert(titleStr: "", messageStr: appConts.const.REQ_VALID_AMOUNT    , buttonTitleStr: appConts.const.bTN_OK)

        }
        else{
            self.depositFund()

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

extension DepositFundVC:UITextFieldDelegate{
    
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
