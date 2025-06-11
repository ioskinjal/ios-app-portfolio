//
//  AddNewAddressViewModel.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 26/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

class AddNewAddressViewModel{
    
    var addressParams:[String:Any]  = [:]
    var addressArray : [Addresses] = [Addresses]()
    var isValidationError: ((String) -> ())?
    
    func addAddress(_ success: @escaping (Any)-> () , failure:@escaping([String:Any])->()){
        
        var param:[String:Any] = [:]
        var customer:[String:Any] = [:]
        

        customer["firstname"] = addressParams["First Name"]
        customer["lastname"] = addressParams["Last Name"]
        guard let email = UserDefaults.standard.value(forKey: "userEmail") as? String else{
            return
        }
        customer["email"] = email

        customer["store_id"] = getStoreId()
        customer["website_id"] = getWebsiteId()
        

        customer["website_id"] = getWebsiteId()

        //customer
        var addressArr:[[String:Any]] = [[String:Any]]()
        var addresses:[String:Any] = [:]
        addresses["firstname"] = addressParams["First Name"]
        addresses["lastname"] = addressParams["Last Name"]
        addresses["company"] = addressParams[""]

        addresses["region"] = UserDefaults.standard.value(forKey: "countryName")as? String ?? "Uniteds Arab Amirat"
        var strCountry:String = getM2StoreCode()
        let array = strCountry.components(separatedBy: "_")
        strCountry = array[0]
        addresses["country_id"] = strCountry.uppercased()

        addresses["region"] = ["region" : addressParams["City"]]
//        addresses["country_id"] = UserDefaults.standard.value(forKey: "country") ?? ""
        addresses["country_id"] = UserDefaults.standard.string(forKey: "storecode")?.uppercased()

        addresses["city"] = addressParams["City"]
        addresses["postcode"] = "40637"
        addresses["telephone"] = addressParams["Phone Number"]
        
       
        var streetArr:[Any] = [Any]()
        var lineTwo = String()
//        if let add1:String = addressParams["Flat/House no."] as? String, add1.count > 0 {
//            streetArr.append(add1)
//        }
        guard let add2:String = addressParams["Address line 1"] as? String, add2.count > 0 else{
            return
        }
        if let add3:String = addressParams["Address line 2"] as? String, add3.count > 0 {
            lineTwo = add2 + " " + add3
            streetArr.append(lineTwo)
        }
        addresses["street"] = streetArr
      
        addresses["default_shipping"] = true
        
        addressArr.append(addresses)
        if addresses["default_shipping"] as? Bool == true{
            addresses.removeValue(forKey: "default_shipping")
            addresses["default_billing"] = true
            addressArr.append(addresses)
        }
        
        
        if addressArray.count > 0 {
            for addr: Addresses in addressArray{
                addresses = [:]
                 //id: Int
                //customerId: Int
                //regionId: Int
                
                addresses["id"] =  addr.id?.val
                addresses["customer_id"] = addr.customerId
                addresses["firstname"] = addr.firstname
                addresses["lastname"] = addr.lastname
                addresses["company"] = addr.company
                addresses["region"] = addr.region?.region ?? ""
                // Need to modify
                addresses["country_id"] = UserDefaults.standard.string(forKey: "storecode")?.uppercased()
                addresses["city"] = addr.city
               // addresses["postcode"] = addr.postcode
                addresses["telephone"] = addr.telephone
                addresses["street"] = addr.street
              
                addressArr.append(addresses)
            }
        }
        customer["addresses"] = addressArr
        param["customer"] = customer
      /*   var addrType = ""
           if(isWork){ addrType = "Work" }
           else if(isHome){ addrType = "Home" }
           else{ addrType = "Other" }

        let addressType = ["attribute_code":"address_type", "value": addrType]
    
        param["custom_attributes"] = [addressType] */
        
        
        print(param)
            
        ApiManager.addAddress(params: param, success: { (response) in
            print(response)
            do{
                
             let address: AddressInformation  = try JSONDecoder().decode(AddressInformation.self , from: response )
             success(address)
            }catch{
                failure([:])
            }
        }) { (error) in
            failure(error)
        }
    }
    func validate(_ params:[String:Any] ,isWork:Bool) -> Bool{
        addressParams = [:]
        
        if isWork {
            
            if (params["10"] as? String ?? "").count > 0 {
                addressParams["Company Name"] = params["10"]
            }
        }
        
        if (params["11"] as? String ?? "").count > 0 {
            addressParams["Salutation"] = params["11"]
        }
        
        if (params["12"] as? String ?? "").count > 0 {
            addressParams["First Name"] = params["12"]
        }
        
        if (params["13"] as? String ?? "").count > 0 {
            addressParams["Last Name"] = params["13"]
        }
        
        
        if (params["14"] as? String ?? "").count > 0 {
            addressParams["Phone Number"] = params["14"]
        }
       /* if (params["15"] as? String ?? "").count > 0 {
            addressParams["Email"] = params["15"]
        }else{
            return false
        }
        */
        
        
        if (params["30"] as? String ?? "").count > 0 {
            addressParams["City"] = params["30"]
        }
        
        if (params["31"] as? String ?? "").count > 0 {
            addressParams["Address line 1"] = params["31"]
        }
        addressParams["Address line 2"] = params["32"]
        
        if (params["33"] as? String ?? "").count > 0 {
            addressParams["Flat/House no."] = params["33"]
        }
        
        addressParams["Shipping notes"] = params["34"]
        addressParams["defaultShipping"] = params["defaultShipping"]
        return true
    }
     
}
