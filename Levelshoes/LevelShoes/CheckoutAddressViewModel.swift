//
//  CheckoutAddressViewModel.swift
//  LevelShoes
//
//  Created by Naveen Wason on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

class CheckoutAddressViewModel{
    
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
}
