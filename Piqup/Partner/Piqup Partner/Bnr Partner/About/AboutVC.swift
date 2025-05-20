//
//  AboutVC.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class AboutVC: BaseVC {
    
    @IBOutlet weak var aboutWebView: UIWebView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNavTitle: UILabel!
    
    
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
        
        loadHelp()
        //getCms()
        // Do any additional setup after loading the view.
    }
    
    func loadHelp(){
        
        let helpURL = URL(string: URLConstants.Domains.HelpUrl + "/" + (self.sharedAppDelegate().currentUser?.uId)!)
        self.aboutWebView.loadRequest(URLRequest(url: helpURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0))
        
        lblNavTitle.text = appConts.const.aBOUT
    }
    
    func getCms(){
        
        if NetworkManager.isNetworkConneted() {
            
            startIndicator(title: "")
            let parameters: Parameters = [
                "userType":"d",
                "cmsId":5,
                "cmsConstant":"HELP",
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
                        
                        let htmlContent = String(format:"%@",dataDict?.object(forKey: "html_content") as! CVarArg)
                        self.aboutWebView.loadHTMLString(htmlContent, baseURL: URL(string: URLConstants
                            .Domains.ServiceUrl))
                        self.actIndicator.stopAnimating()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.actIndicator.stopAnimating()

                        alert.showAlert(titleStr: "", messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAboutMenuClicked(_ sender: Any) {
        openMenu()
        
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

extension AboutVC:UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.actIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.actIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.actIndicator.stopAnimating()
    }
}


