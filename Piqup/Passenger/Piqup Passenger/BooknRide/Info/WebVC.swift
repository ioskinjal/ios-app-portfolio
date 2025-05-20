//
//  WebVC.swift
//  BooknRide
//
//  Created by KASP on 03/01/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import  Alamofire

class WebVC: BaseVC,UIWebViewDelegate {
    
    var cmsID = ""
    var cmsConstant = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCms()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCms(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            
            
            let parameters: Parameters = [
                "userType":"u",
                "cmsId":cmsID,
                "cmsConstant":cmsConstant,
                "lId":Language.getLanguage().id
                
            ]
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.WebPages.getcms, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let dataDict = dataAns.object(at: 0) as? NSDictionary
                    print("Items \(dataAns)")
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.lblTitle.text = String(format:"%@",dataDict?.object(forKey: "title") as! CVarArg)
                        
                        let htmlContent = String(format:"%@",dataDict?.object(forKey: "html_content") as! CVarArg)
                        self.webView.loadHTMLString(htmlContent, baseURL: URL(string: URLConstants
                            .Domains.ServiceUrl))
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.bTN_OK, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        goBack()
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
