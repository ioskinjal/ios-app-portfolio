//
//  ReportDriverVC.swift
//  BooknRide
//
//  Created by KASP on 29/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

// This protocol method is used to identify success/failure for Report Driver
protocol ReportDriverDelegate {
    func dimissReportDriverClicked()
}

class ReportDriverVC: BaseVC {
    
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var lblDescriptionToHide: UILabel!
    
    @IBOutlet weak var lblNavTitle:UILabel!
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    
    
    
    var delegate:ReportDriverDelegate?
    var driverId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtSubject.placeholder = appConts.const.sUBJECT
        lblDescriptionToHide.text = appConts.const.dESCRIPTION
        lblNavTitle.text = appConts.const.rPT_DRIVER
        btnDone.setTitle(appConts.const.bTN_DONE, for: .normal)
        btnClose.setTitle(appConts.const.cLOSE, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reportDriver(){
        
        if NetworkManager.isNetworkConneted() {
            startIndicator(title: "")
            
            let parameters: Parameters = [
                "userId":self.sharedAppDelegate().currentUser!.uId,
                "driverId":driverId!,
                "subject":self.txtSubject.text!,
                "desc":self.txtDescription.text,
                "lId":Language.getLanguage().id
            ]
            
            
            let alert = Alert()
            
            WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Partener.report, parameters: parameters, successBlock: { (json, urlResponse) in
                
                self.stopIndicator()
                
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                let message = jsonDict?.object(forKey: "message") as! String
                
                
                if status == true{
                    
                    DispatchQueue.main.async {
                        alert.showAlertWithCompletionHandler(titleStr: appConts.const.lBL_MESSAGE, messageStr: message, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                            self.delegate?.dimissReportDriverClicked()
                        })
                    }
                }
                else{
                    DispatchQueue.main.async {
                        alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr: appConts.const.bTN_OK)
                        
                        
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
                }
            }
        }else{
            displayNetworkAlert()
        }
    }
    
    @IBAction func btnDoneClicked(_ sender: Any) {
        
        let alert = Alert()
        
        if (self.txtSubject.text?.isEmpty)!
        {
            alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.pLEASE_ADD_SUBJECT, buttonTitleStr: appConts.const.bTN_OK)
        }
        else if (self.txtDescription.text?.isEmpty)!
        {
            alert.showAlert(titleStr: appConts.const.lBL_MESSAGE, messageStr: appConts.const.pLEASE_ADD_DESC, buttonTitleStr: appConts.const.bTN_OK)
        }
        else{
            reportDriver()
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        
        self.delegate?.dimissReportDriverClicked()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ReportDriverVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lblDescriptionToHide.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            self.lblDescriptionToHide.isHidden = false
        }
        else{
            self.lblDescriptionToHide.isHidden = true
        }
    }
}
