
//
//  EstimatedShippingModel.swift
//  LevelShoes
//
//  Created by Naveen Wason on 31/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

struct EstimatedShippingModel: Codable {
    
    let carrierCode: String
    let methodCode: String
    let carrierTitle: String
    let methodTitle: String
    let amount: Int
    let baseAmount: Int
    let available: Bool
    let errorMessage: String
    let priceExclTax: Int
    let priceInclTax: Int
    let estimatedExtentionAttribute: EstimatedExtentionAttribute?

     enum CodingKeys: String, CodingKey {
        case carrierCode = "carrier_code"
        case methodCode = "method_code"
        case carrierTitle = "carrier_title"
        case methodTitle = "method_title"
        case amount = "amount"
        case baseAmount = "base_amount"
        case available = "available"
        case errorMessage = "error_message"
        case priceExclTax = "price_excl_tax"
        case priceInclTax = "price_incl_tax"
        case estimatedExtentionAttribute = "extension_attributes"
    }
}
struct EstimatedExtentionAttribute: Codable {
    
    let timeSlot: [String]?
    enum CodingKeys: String, CodingKey {
        case timeSlot = "time_slots"
    }
}
