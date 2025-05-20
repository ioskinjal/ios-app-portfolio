//
//  AboutUsVC.swift
//  Moms Kitchen
//
//  Created by NCrypted on 03/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class AboutUsVC: BaseViewController {
    var strDesc:String?
    static var storyboardInstance: AboutUsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: AboutUsVC.identifier) as? AboutUsVC
    }
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblAbout: UITextView!
    var dataAbout:InfoList?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "About Us", action: #selector(onClickMenu(_:)), isRightBtn: false)
        self.navigationBar.btnCart.addTarget(self, action: #selector(onCLickAddToCart(_:)), for: .touchUpInside)
        let count:Int = UserDefaults.standard.value(forKey: "cartCount") as! Int
        self.navigationBar.lblCount.text = String(format: "%d", count)
        if dataAbout?.pageDesc != "" {
            strDesc = dataAbout?.pageDesc
            let data = Data(strDesc!.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                self.lblAbout.attributedText = attributedString
                self.webView.isHidden = true
            }
        }else{
            if let url = URL(string: (dataAbout?.url)!) {
                webView.loadRequest(URLRequest(url: url))
                webView.isHidden = false
            }
        }
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onCLickAddToCart(_ sender:UIButton) {
        let nextVC = ShoppingCartVC.storyboardInstance!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func onClickMenu(_ sender: UIButton){
            self.navigationController?.popViewController(animated: true)
        
    }
   

}
extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
