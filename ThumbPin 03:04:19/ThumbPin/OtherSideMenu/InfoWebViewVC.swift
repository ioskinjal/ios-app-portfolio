//
//  InfoWebViewVC.swift
//  ThumbPin
//
//  Created by NCT109 on 01/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class InfoWebViewVC: BaseViewController,UIWebViewDelegate {

    @IBOutlet weak var labelTitleNav: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelTitle: UILabel!
    
    static var storyboardInstance:InfoWebViewVC? {
        return StoryBoard.otherSideMenu.instantiateViewController(withIdentifier: InfoWebViewVC.identifier) as? InfoWebViewVC
    }
    var cmsPages = CmsPages()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        labelTitle.text = cmsPages.pageTitle
        if cmsPages.page_or_url == "p" {
            webView.loadHTMLString(cmsPages.pageDesc, baseURL: nil)
        }else {
            if let url = URL(string: cmsPages.page_url) {
                webView.loadRequest(URLRequest(url: url))
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidStartLoad(_ webView: UIWebView){
        AppHelper.showLoadingView()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        AppHelper.hideLoadingView()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        AppHelper.hideLoadingView()
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
