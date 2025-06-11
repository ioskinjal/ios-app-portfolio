//
//  ContentVC.swift
//  XPhorm
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

class ContentVC: BaseViewController {

    static var storyboardInstance:ContentVC? {
        return StoryBoard.accountSetting.instantiateViewController(withIdentifier: ContentVC.identifier) as? ContentVC
    }
    
    @IBOutlet weak var lblTitle: LabelBold!
   
    @IBOutlet weak var lblContent: UILabel!
    
    var data:ContentPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lblTitle.text = data?.page_title
//        let url = URL(string: data?.pageURL ?? "")!
//        webView.load(URLRequest(url: url))
        let htmlData = NSString(string: "<h2>\(data?.page_desc ?? "")</h2>").data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                              options: options,
                                                              documentAttributes: nil)
        lblContent.attributedText = attributedString
        
       
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        popViewController(animated: true)
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
