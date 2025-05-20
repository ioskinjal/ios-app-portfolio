//
//  PaypalPaymentVC.swift
//  ThumbPin
//
//  Created by NCT109 on 17/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import WebKit

var isfromChat = false
class PaypalPaymentVC: BaseViewController, WKUIDelegate {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var viewWeb: UIView!
    
    static var storyboardInstance:PaypalPaymentVC? {
        return StoryBoard.serviceNotifications.instantiateViewController(withIdentifier: PaypalPaymentVC.identifier) as? PaypalPaymentVC
    }
    var paypalUrl = GetPaypalURL()
    var papal_url = GetPrePaypalURL()
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        //viewWeb = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLang()
        viewWeb.layoutIfNeeded()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: viewWeb.frame.size.width, height: viewWeb.frame.size.height), configuration: webConfiguration)
        webView.navigationDelegate = self
        viewWeb.addSubview(webView)
        if isfromChat == false{
            if let url = URL(string: paypalUrl.paypal_url) {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
        }else{
            if let url = URL(string: papal_url.paypal_url) {
                let myRequest = URLRequest(url: url)
                webView.load(myRequest)
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    func setUpLang() {
        labelPayment.text = localizedString(key: "Payment")
        btnDone.setTitle(localizedString(key: "Done"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func handleResponseOfPayPal(reloadString: String) {
        if isfromChat == false{
        if reloadString.lowercased().contains("success"){
            self.navigationController?.popViewController(animated: true)
        }
        else if reloadString.lowercased().contains("failed"){
            AppHelper.showAlert(StringConstants.alert, message: MessageConstants.paymentFailed)
            self.navigationController?.popViewController(animated: true)
        }
            
        }else{
            if reloadString.lowercased().contains("success"){
                self.navigationController?.popViewController(animated: true)
            }
            else if reloadString.lowercased().contains("failed"){
                AppHelper.showAlert(StringConstants.alert, message: MessageConstants.paymentFailed)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PaypalPaymentVC: /*WKUIDelegate*/ WKNavigationDelegate{
    
    //Equivalent of webViewDidStartLoad:
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print(String(describing: webView.url))
        AppHelper.showLoadingView()
    }
    
    
    //Equivalent of shouldStartLoadWithRequest :
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //AppHelper.showLoadingView()
        var action: WKNavigationActionPolicy?
        defer {decisionHandler(action ?? .allow)}
        
        guard let url = navigationAction.request.url else { return }
        print("url: \(url)")
        self.handleResponseOfPayPal(reloadString: url.absoluteString)
    
        
    }
    
    //Equivalent of didFailLoadWithError:
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        print("webView:\(webView) didFailNavigation:\(navigation) withError:\(error)")
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("404 - Page Not Found", baseURL: URL(string: "http://www.example.com/"))
            //webView.loadHTMLStrin
        }
    }
    
    //Equivalent of webViewDidFinishLoad:
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print(String(describing: webView.url))
        AppHelper.hideLoadingView()
    }
    
}
