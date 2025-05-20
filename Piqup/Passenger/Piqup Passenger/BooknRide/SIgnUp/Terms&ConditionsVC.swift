//
//  Terms&ConditionsVC.swift
//  Carry Partner
//
//  Created by NCrypted on 03/11/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit
import Alamofire

class Terms_ConditionsVC: BaseVC {
 
    static var storyboardInstance:Terms_ConditionsVC? {
        return StoryBoard.main.instantiateViewController(withIdentifier: Terms_ConditionsVC.identifier) as? Terms_ConditionsVC
    }
    
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startIndicator(title: "")
        
        let params: Parameters = ["userType":"d","cmsId":"6","cmsConstant":"terms_conditions"]
        
        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.getCms, parameters: params, successBlock: { (json, urlResponse) in
            
            
            self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            
            if status == true{
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                var dict = NSDictionary()
                dict = dataAns[0] as! NSDictionary
                let str:String = dict.value(forKey: "html_content") as! String
                 let data = Data(str.utf8)
                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    self.txtView.attributedText = attributedString
                    
                }
                
            }
        }){ (error) in
            DispatchQueue.main.async {
                self.stopIndicator()
                alert.showAlert(titleStr: appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
