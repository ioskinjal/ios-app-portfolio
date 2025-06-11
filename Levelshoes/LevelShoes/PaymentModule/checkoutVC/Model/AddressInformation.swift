//
//  AddressInformation.swift
//  LevelShoes
//
//  Created by Naveen Wason on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

struct AddressInformation: Codable {
    
    let id: Int?
    let groupId: Int?
    let defaultShipping: String?
    let defaultBilling: String?
    let createdAt: String?
    let updatedAt: String?
    let createdIn: String?
    let email: String?
    let firstname: String?
    let lastname: String?
    let storeId: Int?
    let websiteId: Int?
    var addresses: [Addresses]
    let disableAutoGroupChange: Int?
    let extensionAttributes: ExtensionAttributes?
    let customAttributes: [CustomAttributes]?
    let prefix: String?
    let dob : String?
    let gender : Int?
   
     enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case groupId = "group_id"
        case defaultShipping = "default_shipping"
        case defaultBilling = "default_billing"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdIn = "created_in"
        case email = "email"
        case firstname = "firstname"
        case lastname = "lastname"
        case storeId = "store_id"
        case websiteId = "website_id"
        case addresses = "addresses"
        case disableAutoGroupChange = "disable_auto_group_change"
       case extensionAttributes = "extension_attributes"
       case customAttributes = "custom_attributes"
         case prefix = "prefix"
        case dob = "dob"
         case gender = "gender"
    }
}

struct Addresses: Codable {
    
    let id: Value?
    let customerId: Int?
    let region: Region?
    let regionId: Int?
    let countryId: String?
    let street: [String]
    let company: String?
    let telephone: String?
    let postcode: String?
    let city: String?
    let firstname: String?
    let lastname: String?
    var defaultShipping: Bool?
    var defaultBilling: Bool?
    let prefix : String?
    var isselected: Bool?
    var customAttributes: [CustomAttributes]?
    
    //let id: String
    //let telephone: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case customerId = "customer_id"
        case region = "region"
        case regionId = "region_id"
        case countryId = "country_id"
        case street = "street"
        case company = "company"
        case telephone = "telephone"
        case postcode = "postcode"
        case city = "city"
        case firstname = "firstname"
        case lastname = "lastname"
        case defaultShipping = "default_shipping"
        case defaultBilling = "default_billing"
        case prefix = "prefix"
        case isselected = "isselected"
        case customAttributes = "custom_attributes"

    }
}
struct CustomAttributes: Codable {

    var attributeCode: String?
    var value: String?

     enum CodingKeys: String, CodingKey {
        case attributeCode = "attribute_code"
        case value = "value"
    }
}


struct Value: Codable {
    //case integer(Int)
    //case string(String)

    let val:Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            //self = .integer(x)
            val = x
            return
        }
        if let x = try? container.decode(String.self) {
            //self = .integer(Int(x) ?? 0)
            val = Int(x) ?? 0
            return
        }
        throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
    }

    /*func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }*/
}
/*
// MARK: - ExtensionAttributes
struct ExtensionAttributes: Codable {
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case isSubscribed
    }
}*/

