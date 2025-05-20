//
//  TermsVC.swift
//  XPhorm
//
//  Created by admin on 7/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

class TermsVC: BaseViewController {

    static var storyboardInstance:TermsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: TermsVC.identifier) as? TermsVC
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    var navTitle = ""
    var strUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: navTitle, action: #selector(onClickBack(_:)))
        
        
        let url = URL(string: strUrl)!
        webView.load(URLRequest(url: url))
    }
    @objc func onClickBack(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
