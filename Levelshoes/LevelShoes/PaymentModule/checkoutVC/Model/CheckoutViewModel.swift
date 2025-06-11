//
//  CheckoutViewModel.swift
//  LevelShoes
//
//  Created by Naveen Wason on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit
class CheckoutViewModel{
    
    var data: AddressInformation?

    func getAddrssInformation(success: @escaping (AddressInformation) -> () , failure:@escaping () -> ()){

            ApiManager.getCustomerInformation(success: { (response) in
                do{
                    guard let data = response else {
                        failure()
                        return
                    }
                    if let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: data){
                        success(address)
                    }else{
                        failure()
                    }
                }catch{
                    failure()
                }
                
            }) {
                failure()
            }
       
    }
    func getEstimatedShippingMethod(_ params: [String:Any], success: @escaping ([EstimatedShippingModel]) -> () , failure:@escaping ([String:Any]) -> ()){
        
        ApiManager.getShippingEstimatedMethod(params: params, success: { (response) in
            do{
                guard let data = response else {
                    failure([:])
                    return
                }
                if let shippingMethod: [EstimatedShippingModel]  = try JSONDecoder().decode([EstimatedShippingModel].self , from: data){
                    success(shippingMethod)
                }else{
                    failure([:])
                }
            }catch{
                failure([:])
            }
        }) { (errorResponse) in
            failure(errorResponse)
        }
    }
    
    func OMSOrder(_ params: [String:Any] , success: @escaping (_ response:Any) -> () , failure:@escaping ([String:Any]) -> ()){
        
        ApiManager.createorderThoughOMS(params: params, success: { (response) in
            success(response)
        }) {(errorResponse) in
            // failure
           // failure(errorResponse)
             success(errorResponse)
        }
    }
    // cart in active by customer token
    func inActiveCart(_ params: [String:Any] , success: @escaping () -> () , failure:@escaping () -> ()){
        ApiManager.cartInActiveByCustomerToken(params: params, success: { (response) in
            success()
        }) {
            failure()
        }
    }
    
    func generateQuoteID(success: @escaping (_ response:Any) -> () , failure:@escaping () -> ()){
        ApiManager.generateQuateID(success: { (response) in
            success(response)
        }) {
            
        }
     }
    func checkoutPayment(_ params: [String:Any] , success: @escaping (_ response:[String:Any]) -> () , failure:@escaping () -> ()){
        ApiManager.checkoutPaymentGateway(params: params, success: { (response) in
            success(response)
        }) {
            // failure
             // success()
        }
    }
}
