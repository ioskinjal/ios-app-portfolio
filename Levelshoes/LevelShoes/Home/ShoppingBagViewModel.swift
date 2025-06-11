//
//  ShoppingBagViewModel.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 19/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//
import UIKit
import Foundation
protocol ShoppingBagViewModelDelegate: class {
    func refreshview()
    func showPopUpErrorMessage(response:[String:Any])
}

class ShoppingBagViewModel{
    var delegate : ShoppingBagViewModelDelegate?
    var data:CartModel?
    var cartUpdated: ((String , Any) -> ())?

    
    
    
    func getCartItems(success: @escaping (CartModel) -> () , failure:@escaping () -> ()){
        
        
            ApiManager.getCartItems(success: { (response) in
                do{
                    guard let data = response else {
                        failure()
                        return
                    }
                    if let cart: CartModel  = try JSONDecoder().decode(CartModel.self , from: data){
                     
                        success(cart)
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
    
    func getCheckoutTotal(success: @escaping (CartTotalModel) -> () , failure:@escaping () -> ()){
        
        ApiManager.getCheckoutTotal(success: { (response) in
            do{
                guard let data = response else {
                    failure()
                    return
                }
                if let totalCart: CartTotalModel  = try JSONDecoder().decode(CartTotalModel.self , from: data){
                    success(totalCart)
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
    
    func updateCartItemQuantity(qty:Int , model:CartItem, navigationController: UINavigationController){
        
        var params:[String:Any] = [:]
        params["qty"] = qty
        if(M2_isUserLogin){
        params["quote_id"] = model.quoteID
        }
        else{
            params["quote_id"] = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id")
        }
        params["item_id"] = model.itemID
        
        ApiManager.updateCartItem(params: params, success: { (response) in
            
            if let errorMessage = (response as? [String:Any])?["message"] {
            let alert = UIAlertController(title:  CommonUsed.globalUsed.KAlert, message:errorMessage as? String ?? "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: CommonUsed.globalUsed.KAlertBtn, style: UIAlertActionStyle.default, handler: nil))
                
                navigationController.present(alert, animated: true, completion: nil)
                //self.delegate?.showPopUpErrorMessage(response: errorMessage as! [String : Any])
            }
            self.cartUpdated?("updateCart",response)
            self.delegate?.refreshview()
            
        }) {
            
        }
    }
    
    func addToWishList(_ params:[String:Any]){
       // var params:[String:Any] = [:]
      //  params["itemId"] = model.itemID
        ApiManager.addTowishList(params: params, success: { (response) in
            print(response)
        }) {
            
        }
    }
    
    func deleteItem(_ model:CartItem, success: @ escaping (Any) -> ()){
        var params:[String:Any] = [:]
        params["itemId"] = model.itemID
        ApiManager.deleteCartItem(params: params, success: { (response) in
            var skuData:[String:Any] = [:]
            skuData["allSKU"] = model.sku
            CoreDataManager.deleteData(entity: NSStringFromClass(Cart.self), deleteData: skuData)
            self.getCartItems(success: { (cartModel) in
                self.cartUpdated?("getCart",cartModel)
            }) {
             success(response)
            }
        }, failure: {
            success([:])
        })
    }
}
