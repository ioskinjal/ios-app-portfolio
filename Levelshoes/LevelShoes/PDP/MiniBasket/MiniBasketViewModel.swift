//
//  MiniBasketViewModel.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 26/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
protocol MiniBasketViewModelDelegate: class {
    func refreshview()
}

class MiniBasketViewModel {
    var delegate : MiniBasketViewModelDelegate?
    var cartUpdated: ((String , Any) -> ())?
    
    func updateCartItemQuantity(qty:Int , params:[String:Any]?){
        ApiManager.updateCartItem(params: params!, success: { (response) in
            //self.cartUpdated?("updateCart",response)
            self.delegate?.refreshview()
            print(response)
        }) {
            
        }
    }
}
