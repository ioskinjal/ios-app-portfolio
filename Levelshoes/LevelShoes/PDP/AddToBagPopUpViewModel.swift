//
//  MiniBasketViewModel.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 19/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

class AddToBagPopUpViewModel {
    
   
    
    func getQuoteID(_ params:[String:Any] , sucess: @escaping (String) -> () , failure:@escaping () -> ()){
        
        ApiManager.getQuoteID(params: params, success: { (response) in
            
           // UserDefaults.standard.setValue(response, forKey: "QUOTE_ID")
            if(!M2_isUserLogin && UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") == nil){
                
            UserDefaults.standard.setValue(response,forKey: "guest_carts__item_quote_id")
                
            }
            sucess(response)
        }) {
           failure()
        }
    }
    func addItemInCart(_ params:[String:Any] , success: @escaping (_ response:Any) -> () , failure:@escaping () -> ()){
        var body:[String:Any] = [:]
        body = [:]
       var cartItem = params
     
        if(!M2_isUserLogin){
            userLoginStatus(status: false)
        }else{
             userLoginStatus(status: true)
        }
        if((!M2_isUserLogin && UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") == nil || M2_isUserLogin) ){
                  
            self.getQuoteID(body, sucess: { (resp) in
                 
                cartItem["quote_id"] = resp
                body["cartItem"] = cartItem
                if !M2_isUserLogin && UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == nil {
                UserDefaults.standard.set(resp, forKey: "guest_carts__item_quote_id")
                   
                }
                if(!M2_isUserLogin){
                         userLoginStatus(status: false)
                }else{
                          userLoginStatus(status: true)
                }
               
                ApiManager.addItemInCart(params: body, success: { (response) in
                   
                    success(response)
                }) {
                   // failure
                    failure()
                }
            }) {
               // quote failure
                failure()
            }
            }
        else{
            cartItem["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
            guest_carts__item_quote_id = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") as! String
            body["cartItem"] = cartItem
            ApiManager.addItemInCart(params: body, success: { (response) in
             
                //body["cartItem"]
                success(response)
            }) {
               // failure
                failure()
            }
        }
        
    }
    
    func saveCartDataInDatabase(_ data:[String:Any]){
        var skuData:[String:Any] = [:]
        skuData["allSKU"] = data["sku"]
        
        var cartData:[String:Any] = [:]
        cartData["allSKU"] = data["sku"]
        cartData["imageURL"] = data["imageURL"]
        cartData["productName"] = data["name"]
        cartData["productPrice"] = data["price"]
        cartData["quantity"] = data["qty"]
        cartData["size"] = data["size"]
        cartData["selectedSize"] = data["selectedSize"]
        
        if let item = CoreDataManager.getDataByID(entity: "Cart", data: skuData), item.count > 0 {
            CoreDataManager.updateData(entity: "Cart", searchData: skuData, updateData: cartData)
        }else{
        CoreDataManager.saveData(data: cartData, entity: "Cart")
        }
    }
}
