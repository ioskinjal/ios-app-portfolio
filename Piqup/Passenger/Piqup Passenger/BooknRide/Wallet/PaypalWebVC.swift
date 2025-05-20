//
//  PaypalWebVC.swift
//  BooknRide
//
//  Created by KASP on 20/02/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class PaypalWebVC: BaseVC,UIWebViewDelegate {

    @IBOutlet weak var paymentWebView: UIWebView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var amount:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPaymentRequest()
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
    
    func createPaymentRequest(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":sharedAppDelegate().currentUser?.uId ?? "",
                "amount":self.amount,
                "lId":Language.getLanguage().id
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.paymentRequest, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")     // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        
                        let returnAns:NSDictionary = (jsonDict?.object(forKey: "returnAns") as! NSDictionary?)!
                        let paypal_Link:String = (returnAns.object(forKey: "paypal_link") as? String)!
                        
                        if let paypalURL = URL(string: paypal_Link) {
                            
                            self.paymentWebView.loadRequest(URLRequest(url: paypalURL))
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
        }else{
            displayNetworkAlert()
        }
        
    }
    
  
    
    // To Get Value from URl query string
    func getQueryStringParameter(url: String, param: String) -> String? {
        
        let url = NSURLComponents(string: url)!
        
        return
            (url.queryItems! as [NSURLQueryItem])
                .filter({ (item) in item.name == param }).first?
                .value
    }
    
    func despositFund(transactionId:String,amount:String){
        
        
            if NetworkManager.isNetworkConneted() {
                startIndicator(title: "")
                
                let parameters: Parameters = [
                    "userId":sharedAppDelegate().currentUser?.uId ?? "",
                    "transactionId":transactionId,
                    "amount":amount,
                    "paymentStaus":"c",
                    "lId":Language.getLanguage().id
                ]
                
                let alert = Alert()
                
                WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Wallet.depositFund, parameters: parameters, successBlock: { (json, urlResponse) in
                    
                    self.stopIndicator()
                    
                    print("Request: \(String(describing: urlResponse?.request))")   // original url request
                    print("Response: \(String(describing: urlResponse?.response))") // http url response
                    print("Result: \(String(describing: urlResponse?.result))")     // response serialization result
                    
                    let jsonDict = json as NSDictionary?
                    
                    let status = jsonDict?.object(forKey: "status") as! Bool
                    let message = jsonDict?.object(forKey: "message") as! String
                    
                    
                    if status == true{
                        
                        DispatchQueue.main.async {
                            
                           // alert.showAlertWithCompletionHandler(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                                self.navigationController?.popToRootViewController(animated: true)
                           // })
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
    
    // MARK:- WebView delegate methods
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.actIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.actIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
       // print(describe(request.url))
        
        let reloadString:String = (request.url?.absoluteString)!
        
        if reloadString.lowercased().range(of: "action=") != nil {
            
            let action = self.getQueryStringParameter(url: reloadString, param: "action")
            
            if action?.lowercased() == "payment_complete" {
                
                let depositAmount = self.getQueryStringParameter(url: reloadString, param: "amount")
                let txn_id = self.getQueryStringParameter(url: reloadString, param: "txn_id")
                
                self.despositFund(transactionId:txn_id!, amount: depositAmount!)
            }
            else if action?.lowercased() == "fail" {
                 let alert = Alert()

                alert.showAlertWithCompletionHandler(titleStr: "", messageStr: appConts.const.MSG_PAYMENT_FAILED    , buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            
        }
        else if reloadString.lowercased().range(of: "failed") != nil {
            let alert = Alert()
            
            alert.showAlertWithCompletionHandler(titleStr: "", messageStr: appConts.const.MSG_PAYMENT_FAILED, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        
        
        return true
    }
    
    // MARK: - Button events
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
    }
}

