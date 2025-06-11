//
//  PdfFileViewController.swift
//  OTT
//
//  Created by Srikanth on 2/3/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import Foundation
import PDFKit

class PdfFileViewController: UIViewController,PDFViewDelegate {
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet var pdfView: PDFView!
    var isExternal = true
    var pdfPath : String?
    var pageString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.titleLabel.text = pageString
        self.titleLabel.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        self.backButton.isHidden = false
        self.titleLabel.isHidden = false
        pdfView.delegate = self
        if let _path = pdfPath {
            let url = URL.init(string: _path)
            if let document = PDFDocument(url: url!) {
                pdfView.document = document
            }
        }
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        self.navigationController?.popViewController(animated: true)
        
    }
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        print(url)
        if isExternal {
            UIApplication.shared.open(url)
        }
        else {
            
        }
        
    }

}


