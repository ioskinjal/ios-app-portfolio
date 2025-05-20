//
//  FinanceInformationVC.swift
//  BnR Partner
//
//  Created by KASP on 11/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class FinanceInformationVC: BaseVC {

    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var lblTotalRidesConst:UILabel!
    @IBOutlet weak var lblTotalRides: UILabel!
    @IBOutlet weak var lblTotalEarnedConst:UILabel!
    @IBOutlet weak var lblTotalEarned: UILabel!
    @IBOutlet weak var lblTotalCommissionConst:UILabel!
    @IBOutlet weak var lblTotalCommission: UILabel!
    @IBOutlet weak var lblNetEarnedConst: UILabel!
    @IBOutlet weak var lblNetEarned: UILabel!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnGo:UIButton!
    @IBOutlet weak var navTitle:UILabel!
    
    @IBOutlet weak var lblfilter:UILabel!
    
    var isFromDate = false
    
    var fromDate:Date?
    var toDate:Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fromView.applyBorder(color: UIColor.darkGray, width: 1.0)
        toView.applyBorder(color: UIColor.darkGray, width: 1.0)
        
        getFinanceInfo()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblfilter.text = appConts.const.lBL_FILTER
        lblTotalRidesConst.text = appConts.const.lBL_TOTAL_RIDES
        lblNetEarnedConst.text = appConts.const.lBL_NET_EARNED
        lblTotalCommissionConst.text = appConts.const.lBL_TOTAL_COMMISION
        lblTotalEarnedConst.text = appConts.const.lBL_TOTAL_EARNED
        btnGo.setTitle(appConts.const.bTN_GO, for: .normal)
        navTitle.text = appConts.const.tITLE_FINANCIAL_INFO
    }
    
   
    @IBAction func btnFromDateClicked(_ sender: Any) {
        
        self.isFromDate = true
        addDatePickerController()
    }
    
    @IBAction func btnToDateClicked(_ sender: Any) {
        
        self.isFromDate = false
        addDatePickerController()
    }
    
    @IBAction func btnGoClicked(_ sender: Any) {
        
        let alert = Alert()
        if (self.lblFromDate.text?.isEmpty)! {
            
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_SELECT_FROM_DATE, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.lblToDate.text?.isEmpty)! {
            
            alert.showAlert(titleStr: "", messageStr: appConts.const.MSG_SELECT_TO_DATE, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.toDate! < self.fromDate!) {
            
             alert.showAlert(titleStr: "", messageStr: appConts.const.dATE_ERROR, buttonTitleStr: appConts.const.bTN_OK)
        }

        else{
            getFinanceInfoFilter()
        }
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        openMenu()
    }
    
    func addDatePickerController(){
        
        let dateController = DatePickerVC(nibName: "DatePickerVC", bundle: nil)
        dateController.delegate = self
        
        self.addChildViewController(dateController)
        view.addSubview(dateController.view)
        
        dateController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint =  NSLayoutConstraint(item: dateController.view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint =  NSLayoutConstraint(item: dateController.view, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint =  NSLayoutConstraint(item: dateController.view, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        
        let bottomConstraint =  NSLayoutConstraint(item: dateController.view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([leadingConstraint,trailingConstraint,topConstraint,bottomConstraint])
        self.view.layoutIfNeeded()
        
        dateController.didMove(toParentViewController: self)
        
    }
    
    func getFinanceInfo(){
        
        startIndicator(title: "")
        
        
        let params: Parameters = ["driverId":sharedAppDelegate().currentUser!.uId,"lId":Language.getLanguage().id]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Finance.getPartnerFinancialInfo, parameters: params, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                DispatchQueue.main.async {
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary

                    let netEarning:String = String(format: "%@",dataAns.object(forKey: "netEarning") as! CVarArg)
                    let rideChargesTotal:String = String(format: "%@",dataAns.object(forKey: "rideChargesTotal") as! CVarArg)
                    let totalCommition:String = String(format: "%@",dataAns.object(forKey: "totalCommition") as! CVarArg)
                    let totalRidesAns:String = String(format: "%@",dataAns.object(forKey: "totalRidesAns") as! CVarArg)
                    
                    self.lblTotalRides.text = totalRidesAns
                    self.lblTotalEarned.text =  String(format:"%@%@",ParamConstants.Currency.currentValue,rideChargesTotal)
                    self.lblTotalCommission.text =  String(format:"%@%@",ParamConstants.Currency.currentValue,totalCommition)
                    self.lblNetEarned.text = String(format:"%@%@",ParamConstants.Currency.currentValue,netEarning)

                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: "OK")
                    self.lblTotalRides.text = "N/A"
                    self.lblTotalEarned.text =  "N/A"
                    self.lblTotalCommission.text = "N/A"
                    self.lblNetEarned.text = "N/A"
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_NO)
            }
        }
        
    }
    
    
    
    
    func getFinanceInfoFilter(){
        
        startIndicator(title: "")
        
        let params: Parameters = [
            "driverId":sharedAppDelegate().currentUser!.uId,
            "startDate":self.lblFromDate.text!,
            "endDate":self.lblToDate.text!,
            "lId":Language.getLanguage().id
            
        ]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Finance.getPartnerFinancialInfoFilter, parameters: params, successBlock: { (json, urlResponse) in
            
            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                
                DispatchQueue.main.async {
                    
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    let netEarning:String = String(format: "%@",dataAns.object(forKey: "netEarning") as! CVarArg)
                    let rideChargesTotal:String = String(format: "%@",dataAns.object(forKey: "rideChargesTotal") as! CVarArg)
                    let totalCommition:String = String(format: "%@",dataAns.object(forKey: "totalCommition") as! CVarArg)
                    let totalRidesAns:String = String(format: "%@",dataAns.object(forKey: "totalRidesAns") as! CVarArg)
                    
                    self.lblTotalRides.text = totalRidesAns
                    self.lblTotalEarned.text =  String(format:"%@%@",ParamConstants.Currency.currentValue,rideChargesTotal)
                    self.lblTotalCommission.text = String(format:"%@%@",ParamConstants.Currency.currentValue,totalCommition)
                    self.lblNetEarned.text = String(format:"%@%@",ParamConstants.Currency.currentValue,netEarning)
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: "OK")
                    self.lblTotalRides.text = "N/A"
                    self.lblTotalEarned.text =  "N/A"
                    self.lblTotalCommission.text = "N/A"
                    self.lblNetEarned.text = "N/A"
                    
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
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

extension FinanceInformationVC:DatePickerDelegate{
    
    func userDidSelectDate(selectedDate: Date) {
        
        let diplayDate:String = RideUtilities.getStringFromDate(format: "yyyy-MM-dd", date: selectedDate)
        
        print(diplayDate)
        
        if self.isFromDate {
            self.lblFromDate.text = diplayDate
            self.fromDate = selectedDate
        }
        else{
            self.lblToDate.text = diplayDate
            self.toDate = selectedDate
        }
        cancelDateClicked()
        
    }
    
    func cancelDateClicked() {
        
        if let nav = self.navigationController, let codeVC = nav.topViewController as? FinanceInformationVC {
            
            if codeVC.childViewControllers.count>0{
                DispatchQueue.main.async {
                    let forgotPasswordVC =  codeVC.childViewControllers[0]
                    
                    forgotPasswordVC.willMove(toParentViewController: self)
                    forgotPasswordVC.view.removeFromSuperview()
                    forgotPasswordVC.removeFromParentViewController()
                }
            }
        }
    }
    
}


