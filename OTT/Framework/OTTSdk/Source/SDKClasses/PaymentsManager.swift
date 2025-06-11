//
//  PaymentsManager.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PaymentsManager: NSObject {

    /**
     In App Product ID Details API
     
     - Parameters:
         - entityId: the movie/ TV show id the user clicks
         - onSuccess: BaseResponse Object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func inAppProductDetails(entityId : String ,onSuccess : @escaping (InAppProductDetails)-> Void, onFailure : @escaping(APIError) -> Void){
        let params = "entity_id=" + entityId
        API.instance.request(baseUrl: API.url.productDetails, parameters: params, methodType: .get, info: nil, logString: "InAppProductDetails", onSuccess: { (response) in
            guard let _response = response as? [String : Any] else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(InAppProductDetails.init(withJSON: _response))
        }) { (error) in
            onFailure(error)
        }
    }
    
    /**
     In App receipt Submit API
     
     - Usage:
     ````
         “productId”:”a-aa”,
         “currency”:”USD”,
         “receipt”:”124143255dfg”
     ````
     
     - Parameters:
         - productId: The product user purchased, get the product ID from Product ID API
         - currency: 3 letter currency code
         - receipt: Apple Receipt
         - onSuccess: BaseResponse Object
         - onFailure: failed
             - APIError: error object with code and message
     - Returns: void
     */
    
    public func validateAppleReceipt(productId : String ,currency : String ,receipt : String ,onSuccess : @escaping (String)-> Void, onFailure : @escaping(APIError) -> Void){
        let addresses = ["product_id":productId,"currency":currency,"receipt":receipt]
       
        API.instance.request(baseUrl: API.url.validateReceipt, parameters: "", methodType: .post, info: ["DICTIONARY":addresses], logString: "ValidateAppleReceipt", onSuccess: { (response) in
            
            guard let _response = response as? String else{
                onFailure(APIError.defaultError())
                return
            }
            onSuccess(_response)
            
        }) { (error) in
            onFailure(error)
        }
    }
}
