//
//  ExtWebLinksVC.swift
//  YUPPTV
//
//  Created by Ankoos on 16/11/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import WebKit

class ExtWebLinksViewController: UIViewController,UIGestureRecognizerDelegate,WKUIDelegate {
   
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var webviewBgView: UIView!
    @IBOutlet private weak var navigationViewTopConstraint : NSLayoutConstraint!
    var extWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    var pageString :String!
    var viewControllerName : String!
    var urlString : String!
    var lmsDetails = [String:Any]()
    var isFromParentalControl = false
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    // MARK: - View methods

     override func viewDidLoad() {
        
        
        super.viewDidLoad()
        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        if isFromParentalControl {
            navigationViewTopConstraint.constant = -56.0
            navigationView.isHidden = true
        }else {
            navigationViewTopConstraint.constant = 0.0
            navigationView.isHidden = false
        }
        
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.webviewBgView.frame.size.height))
        self.extWebView = WKWebView (frame: customFrame , configuration: webConfiguration)
        extWebView.translatesAutoresizingMaskIntoConstraints = false
        self.webviewBgView.addSubview(extWebView)
        extWebView.topAnchor.constraint(equalTo: webviewBgView.topAnchor).isActive = true
        extWebView.rightAnchor.constraint(equalTo: webviewBgView.rightAnchor).isActive = true
        extWebView.leftAnchor.constraint(equalTo: webviewBgView.leftAnchor).isActive = true
        extWebView.bottomAnchor.constraint(equalTo: webviewBgView.bottomAnchor).isActive = true
        extWebView.heightAnchor.constraint(equalTo: webviewBgView.heightAnchor).isActive = true
        extWebView.uiDelegate = self
        extWebView.navigationDelegate = self

        
        AppDelegate.getDelegate().handleSupportButton(isHidden: true, isFromTabVC: true)

//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
//        self.navigationView.cornerDesign()
//        self.navigationView.backgroundColor =  AppTheme.instance.currentTheme.navigationBarColor
         if appContants.appName == .gac {
             self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
         }
         else{
             self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
         }
        self.extWebView.isOpaque = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        urlString = urlString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if urlString != "" {
            let myURL = URL(string: urlString)
            self.titleLabel.text = pageString.localized
            self.titleLabel.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
            
            if lmsDetails.keys.count > 0{
                var request = URLRequest(url: myURL!)
                let un = lmsDetails["un"]!
                let pd = lmsDetails["pd"]!
                let url = lmsDetails["url"]!
                request.httpMethod = "POST"
                let params = "un=\(un)&pd=\(pd)&url=\(url)"
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                request.httpBody = params.data(using: .utf8)
                self.extWebView.load(request)
                
//                let task = URLSession.shared.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
//                    if data != nil {
//                        if let returnString = String(data: data!, encoding: .utf8) {
//                            DispatchQueue.main.async {
//                                                            self.webView.loadHTMLString(returnString, baseURL: myURL)
//                            }
//                        }
//                    }
//                }
//                task.resume()
            }
            else{
                let myRequest = URLRequest(url: myURL!)
                self.startAnimating(allowInteraction: true)
                extWebView.load(myRequest)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
  // MARK: - custom methods
    @IBAction func BackAction(_ sender: Any) {
        self.stopAnimating()
        if viewControllerName == "InAppPurchase" {
            self.dismiss(animated: true, completion: nil)
        }
        else if lmsDetails.keys.count > 0{
            if playerVC != nil{
                playerVC?.showHidePlayerView(true)
                playerVC?.player.playFromCurrentTime()
                if playerVC?.playBtn != nil {
                    playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                }
                if viewControllerName == "PlayerVC" {
                    playerVC?.expandViewsIntermediate()
                }
                playerVC?.isNavigatingToBrowser = false
            }
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.popViewController(animated: true)
        }
        else if playerVC != nil{
            playerVC?.isNavigatingToBrowser = false
            playerVC?.showHidePlayerView(true)
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.popViewController(animated: true)
        }
        else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ExtWebLinksViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
//        toolBar.items?[0].isEnabled = webView.canGoBack
//        toolBar.items?[1].isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.startAnimating(allowInteraction: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopAnimating()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(String(describing: navigationAction))
        
        guard let urlAsString = navigationAction.request.url?.absoluteString.lowercased() else {
            return
        }
        if urlAsString == AppDelegate.getDelegate().siteURL, isFromParentalControl {
            self.navigationController?.popViewController(animated: true)
        }
        decisionHandler(.allow)
    }

}
