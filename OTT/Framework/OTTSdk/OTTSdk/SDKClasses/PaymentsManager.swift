//
//  PaymentsManager.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PaymentsManager: NSObject {
    public func cancelSubscription(package_id : Int? ,gateway : String?, onSuccess : @escaping (_ message : String)-> Void, onFailure : @escaping(_ error : APIError) -> Void){
        
        let params = "package_id=\(package_id!)" + "&gateway=" + gateway!

        API.instance.request(baseUrl: API.baseUrl.paymentUnSubscribeURl, parameters: params, methodType: .post, info: nil, logString: "SignIn", onSuccess: { (response) in
            
            let successResponse = response as! [String : Any]
            onSuccess(successResponse["message"] as! String)
            
            return
        }) { (error) in
            onFailure(error)
            return
        }

    }
}
