//
//  PartialWebViewViewController.swift
//  OTT
//
//  Created by Malviya Ishansh on 29/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class PartialWebViewViewController: UIViewController {

    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var insideViewHeight: NSLayoutConstraint!
    @IBOutlet weak var actionbutton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var contentDetailResponse: PageContentResponse!
    var htmlString = ""
    var pdfTarget: String!
    var outputPDF: String! = ""
    var viewHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insideView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.insideViewHeight.constant = self.viewHeight
        self.titleView.backgroundColor = .black.withAlphaComponent(0.32)
        self.closeButton.setImage(UIImage.init(named: "miniplayer-close"), for: .normal)
        self.closeButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        self.titleLable.text = "Recipe"
        self.titleLable.textColor = AppTheme.instance.currentTheme.cardTitleColor
        if self.contentDetailResponse != nil {
            for pageData in self.contentDetailResponse!.data {
                if pageData.paneType == .content {
                    let content = pageData.paneData as? Content
                    for dataRow in (content?.dataRows)! {
                        for element in dataRow.elements {
                            if element.contentCode == "recipe" {
                                let type = element.elementType as? DataElement
                                if type == .html {
                                    var tempData = element.data
                                    
                                    if let _themeColoursList = AppDelegate.getDelegate().configs?.themeColoursList.convertToJson() as? [String : Any] {
                                        if let _selectedThemeName = _themeColoursList["themeName"] as? String {
                                            tempData = tempData.replacingOccurrences(of: "__theme__", with: _selectedThemeName)
                                        }
                                    }
                                    
                                    self.htmlString = tempData
                                    
                                }
                                if type == .button {
                                    self.actionbutton.setTitle(element.data, for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }
        self.actionbutton.titleLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.actionbutton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        self.actionbutton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .highlighted)
        self.actionbutton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .selected)
        self.actionbutton.tintColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        self.actionbutton.backgroundColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        self.actionbutton.tintColor = AppTheme.instance.currentTheme.homeCollectionBGColor

        self.webView.loadHTMLString(htmlString, baseURL: nil)
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func action(_ sender: Any) {
        self.savePDF()
        if let pdf = outputPDF {
            self.sharePDF(path: pdf)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeArea(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePDF() {
        self.outputPDF = self.webView.exportAsPdfFromWebView()
        print(outputPDF)
    }
    
    func sharePDF(path: String) {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path){
            let pdf = NSData(contentsOfFile: path)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [pdf!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("document was not found")
        }
    }
    
}

extension WKWebView {
    
    func exportAsPdfFromWebView() -> String {
        let pdfData = createPdfFile(printFormatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData)
    }
    
    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }
    
    func saveWebViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("webViewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

extension UIPrintPageRenderer {
    
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0...self.numberOfPages {
                    UIGraphicsBeginPDFPage()
                    self.drawPage(at: pdfPage, in: printRect)
                }
        UIGraphicsEndPDFContext();
        return pdfData
    }
}
