//
//  CartDataModel.swift
//  LevelShoes
//
//  Created by Naveen Wason on 31/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

public struct CartDataModel {
    public static let shared  = CartDataModel()
    
    public static var cart: CartModel?
    public static var cartTotal: CartTotalModel?
    
    public func setValue(_ cart:CartModel? ,cartTotal:CartTotalModel?){
        CartDataModel.self.cart = cart
        CartDataModel.self.cartTotal = cartTotal
    }
    
    public func getCart() -> CartModel?{
        return CartDataModel.cart
    }
    
    public func getCartTotalModel() -> CartTotalModel?{
        return CartDataModel.cartTotal
    }
}
