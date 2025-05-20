//
//  LGInfoVC.swift
//  Losinger
//
//  Created by nct48 on 18/07/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit
import WebKit
class MSAboutUs: BaseViewController,WKNavigationDelegate
{

   
   
    @IBOutlet weak var txtAboutUs: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: false, btnTitle: "", navigationTitle: "AboutUS", action: #selector(btnSideMenuOpen))
        callAboutUs()
    }
    
    func callAboutUs() {
        ModelClass.shared.getAboutUs(vc: self) { (dic) in
            let data = AboutUs(dictionary: ResponseKey.fatchData(res: dic, valueOf: .data).dic)
            self.txtAboutUs.text = data.pageDesc.htmlToString
            
        }
    }
    
    @objc func btnSideMenuOpen()
    {
        sideMenuController?.showLeftView()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
//extension MSAboutUs :UITableViewDataSource,UITableViewDelegate
//{
//    func numberOfSections(in tableView: UITableView) -> Int
//    {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return infoList.count //reviewAllList.review.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//
//        if( !(cell != nil))
//        {
//            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
//        }
//        cell?.textLabel?.text = infoList[indexPath.row].name
//        return cell!
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        showLosingerLoader(view: self,isFullScreen: false)
//        viewForWebView.isHidden = false
//        let webConfiguration = WKWebViewConfiguration()
//
//        webView.frame = CGRect(x: 0, y: 0, width: viewForWebView.frame.size.width, height: viewForWebView.frame.size.height)
//        webView = WKWebView(frame: webView.frame, configuration: webConfiguration)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        self.viewForWebView.addSubview(webView)
//        webView.topAnchor.constraint(equalTo: viewForWebView.topAnchor).isActive = true
//        webView.rightAnchor.constraint(equalTo: viewForWebView.rightAnchor).isActive = true
//        webView.leftAnchor.constraint(equalTo: viewForWebView.leftAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: viewForWebView.bottomAnchor).isActive = true
//        webView.heightAnchor.constraint(equalTo: viewForWebView.heightAnchor).isActive = true
//
//        webView.allowsBackForwardNavigationGestures = true
//        webView.navigationDelegate = self
//        webView.scrollView.bounces = false
//        viewForWebView.addSubview(webView)
//        webView.loadHTMLString(infoList[indexPath.row].content, baseURL: nil)
//
//        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: localizedString(key:"Info"), action: #selector(btnBackClick))
//
//    }
//    //Equivalent of webViewDidFinishLoad:
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
//    {
//        //print(String(describing: webView.url))
//        hideLosingerLoader(view: self)
//    }
////    func webViewDidFinishLoad(_ webView: UIWebView) {
////        hideLosingerLoader(view: self)
////    }
//}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
