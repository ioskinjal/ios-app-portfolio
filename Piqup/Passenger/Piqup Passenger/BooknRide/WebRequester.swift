//
//  WebRequester.swift
//  BooknRide
//
//  Created by Ncrypted on 09/07/18.
//  Copyright © 2018 NCrypted Technologies. All rights reserved.
//

import UIKit

class WebRequester {
    
   static var shareManager:WebRequester{
        return WebRequester()
    }
    
    
    func fetchLanguage(success:@escaping ([Language]) -> Void){
        let alert = Alert()
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.getLanguage, parameters: ["lId":Language.getLanguage().id], successBlock: { (json, urlResponse) in
            
            //            self.stopIndicator()
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")     // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                let data = jsonDict?.object(forKey: "dataAns") as! [Any]
                
                success(data.map({Language(data: $0 as! [String:Any])}))
            }
            else{
                DispatchQueue.main.async {
                    //                    self.stopIndicator()
                    alert.showAlert(titleStr: appConts.const.aLERT, messageStr: message, buttonTitleStr:  appConts.const.bTN_OK)
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                //                self.stopIndicator()
                alert.showAlert(titleStr:  appConts.const.aLERT, messageStr: error.localizedDescription, buttonTitleStr: appConts.const.bTN_OK)
            }
        }
        
    }
}
