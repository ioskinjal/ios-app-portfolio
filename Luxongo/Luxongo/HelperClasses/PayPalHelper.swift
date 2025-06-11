//
//  PayPalHelper.swift
//  Luxongo
//
//  Created by admin on 9/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController:BaseViewController{
    
    var containerView:UIView = {
        let view = UIView()
        return view
    }()
    var webview:WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private var url:String
    private var success:String
    private var fail:String
    private var navigationTitle:String
    private var isNavBar:Bool
    var isPaymentDone:((Bool)->())?
    
    
    init(url:String,success:String = "",fail:String = "",navigationTitle:String = "", isNavBar:Bool = false ){
        self.url = url
        self.success = success
        self.fail = fail
        self.navigationTitle = navigationTitle
        self.isNavBar = isNavBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.isLodingSomething = true
        self.view.backgroundColor = .white
        //self.navTitle = self.navigationTitle
        setupUI()
        loadWeb()
    }
    
    
    private func setupUI(){
        webview.navigationDelegate = self
        self.view.addSubview(containerView)
        if isNavBar{
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onClickBtnCancel))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
        if #available(iOS 11.0, *) {
            containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        } else {
            containerView.fillSuperview()
        }
        self.containerView.addSubview(webview)
        webview.fillSuperview()
    }
    
    private func loadWeb(){
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {self.dismiss(animated: true); return }
        guard let url = URL(string:urlString) else { self.dismiss(animated: true); return }
        webview.load(URLRequest(url: url))
    }
    
    private func handleResponseOfPayPal(reloadString: String) {
        //if reloadString.lowercased().contains(string: success ){
        if reloadString.lowercased().contains(string: success ) || reloadString.lowercased().contains(string: "payment-thankyou"){
            self.isPaymentDone?(true)
        }
        else if reloadString.lowercased().contains(string: fail ){
            UIApplication.alert(title: "", message: "Payment failed") {
                self.isPaymentDone?(false)
            }
        }
    }
    
    @objc private func onClickBtnCancel(_ sender:UIBarButtonItem){
        self.dismiss(animated: true)
    }
}


extension WebViewController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //self.isLodingSomething = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        defer {decisionHandler(action ?? .allow)}
        
        guard let url = navigationAction.request.url else { return }
        print("url: \(url)")
        self.handleResponseOfPayPal(reloadString: url.absoluteString)
    }
}
