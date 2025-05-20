//
//  WebVC.swift
//  Happenings
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class WebVC: BaseViewController {

    static var storyboardInstance: WebVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: WebVC.identifier) as? WebVC
    }
    @IBOutlet weak var webView: UIWebView!
    
    var strTitle:String = ""
    var strLink:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: strTitle, action: #selector(onClickMenu(_:)))
        
        let url =  strLink
        
        let request = URLRequest.init(url: URL.init(string: url)!)
        webView.loadRequest(request)
    }
    
    @objc func onClickMenu(_ sender: UIButton){
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
