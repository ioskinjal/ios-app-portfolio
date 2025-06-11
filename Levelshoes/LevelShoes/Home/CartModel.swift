//
//  CartModel.swift
//  LevelShoes
//
//  Created by Rajat Agarwal on 19/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation

public struct CartTotalModel: Codable{
    
    let grandTotal: Double?
    let baseGrandTotal: Double?
    let subtotal, baseSubtotal: Double?
    let discountAmount, baseDiscountAmount: Double?
    let subtotalWithDiscount, baseSubtotalWithDiscount: Double?
    let shippingAmount, baseShippingAmount, shippingDiscountAmount, baseShippingDiscountAmount: Double?
    let taxAmount, baseTaxAmount: Double?
    let weeeTaxAppliedAmount: JSONNull?
    let shippingTaxAmount, baseShippingTaxAmount, subtotalInclTax, shippingInclTax: Double?
    let coupon_code : String?
    let taxPercentage: Double?
    let baseShippingInclTax: Double?
    let baseCurrencyCode, quoteCurrencyCode: String?
    let itemsQty: Int?
    let items: [Item]?
    let totalSegments: [TotalSegment]?
    let extensionAttributes: ExtensionAttributes?

    enum CodingKeys: String, CodingKey {
        case coupon_code = "coupon_code"
        case grandTotal = "grand_total"
        case baseGrandTotal = "base_grand_total"
        case subtotal = "subtotal"
        case baseSubtotal = "base_subtotal"
        case discountAmount = "discount_amount"
        case baseDiscountAmount = "base_discount_amount"
        case subtotalWithDiscount = "subtotal_with_discount"
        case baseSubtotalWithDiscount = "base_subtotal_with_discount"
        case shippingAmount = "shipping_amount"
        case baseShippingAmount = "base_shipping_amount"
        case shippingDiscountAmount = "shipping_discount_amount"
        case baseShippingDiscountAmount = "base_shipping_discount_amount"
        case taxAmount = "tax_amount"
        case taxPercentage = "tax_percent"
        case baseTaxAmount = "base_tax_amount"
        case weeeTaxAppliedAmount = "weee_tax_applied_amount"
        case shippingTaxAmount = "shipping_tax_amount"
        case baseShippingTaxAmount = "base_shipping_tax_amount"
        case subtotalInclTax = "subtotal_incl_tax"
        case shippingInclTax = "shipping_incl_tax"
        case baseShippingInclTax = "base_shipping_incl_tax"
        case baseCurrencyCode = "base_currency_code"
        case quoteCurrencyCode = "quote_currency_code"
        case itemsQty = "items_qty"
        case items
        case totalSegments = "total_segments"
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - Item
struct Item: Codable {
    
    let itemID: Int?
    let price, basePrice: Double?
    let qty: Int?
    let rowTotal, baseRowTotal: Double?
    let rowTotalWithDiscount: Int?
    let taxPercent, taxAmount, discountAmount,  baseDiscountAmount, baseTaxAmount: Double?
    let  discountPercent: Int?
    let priceInclTax, basePriceInclTax, rowTotalInclTax, baseRowTotalInclTax: Double?
    let options: String?
    let weeeTaxAppliedAmount, weeeTaxApplied: JSONNull?
    let extensionAttributes: ItemExtensionAttributes?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case price = "price"
        case basePrice = "base_price"
        case qty
        case rowTotal = "row_total"
        case baseRowTotal = "base_row_total"
        case rowTotalWithDiscount
        case taxAmount = "tax_amount"
        case baseTaxAmount = "base_tax_amount"
        case taxPercent = "tax_percent"
        case discountAmount = "discount_amount"
        case baseDiscountAmount = "base_discount_amount"
        case discountPercent
        case priceInclTax = "price_incl_tax"
        case basePriceInclTax
        case rowTotalInclTax
        case baseRowTotalInclTax
        case options
        case weeeTaxAppliedAmount
        case weeeTaxApplied
        case extensionAttributes = "extension_attributes"
        case name
    }
}

struct TotalSegment: Codable {
    
    let code, title: String?
    let value: Double?
    let extensionAttributes: TotalSegmentExtensionAttributes?
    let area: String?

    enum CodingKeys: String, CodingKey {
        case code, title, value
        case extensionAttributes = "extension_attributes"
        case area
    }
}
// MARK: - ItemExtensionAttributes
struct ItemExtensionAttributes: Codable {
    let isFreeProduct: Int?
    let originalRowTotal: Double?
    let lvl_concession_core_sku: String?
    let zone: Int?
    let sku: String?
    let brand: String?
    enum CodingKeys: String, CodingKey {
        case isFreeProduct = "is_free_product"
        case originalRowTotal = "original_row_total"
        case lvl_concession_core_sku = "lvl_concession_core_sku"
        case zone = "zone"
        case sku = "sku"
        case brand = "brand_name"
    }
}

// MARK: - TotalSegmentExtensionAttributes
struct TotalSegmentExtensionAttributes: Codable {
   // let gwItemIDS: [JSONAny]?
    let gwPrice, gwBasePrice, gwItemsPrice, gwItemsBasePrice: String?
    let gwCardPrice, gwCardBasePrice: String?
    let taxGrandtotalDetails: [TaxGrandtotalDetail]?
     let gift_cards: String?
    enum CodingKeys: String, CodingKey {
        //case gwItemIDS
        case gwPrice = "gw_price"
        case gwBasePrice = "gw_base_price"
        case gwItemsPrice = "gw_items_price"
        case gwItemsBasePrice = "gw_items_base_price"
        case gwCardPrice = "gw_card_price"
        case gwCardBasePrice = "gw_card_base_price"
        case taxGrandtotalDetails = "tax_grandtotal_details"
        case gift_cards = "gift_cards"
}
}

// MARK: - TaxGrandtotalDetail
struct TaxGrandtotalDetail: Codable {
    let amount: Double?
    let rates: [Rate]?
    let groupID: Int?

    enum CodingKeys: String, CodingKey {
        case amount
        case groupID
        case rates = "rates"
    }
}

// MARK: - Rate
struct Rate: Codable {
    let percent, title: String?
    enum CodingKeys: String, CodingKey {
        case percent = "percent"
        case title = "title"
    }
}


public struct CartModel: Codable {
    
    let id: Int?
    let createdAt, updatedAt: String?
    let isActive, isVirtual: Bool?
    let items: [CartItem]?
    let itemsCount, itemsQty: Int?
    let customer: Customer?

    //let billingAddress: BillingAddressClass?
    let origOrderID: Int?
    //let currency: Currency?
    let customerIsGuest, customerNoteNotify: Bool?
    let customerTaxClassID, storeID: Int?
    let extensionAttributes: ExtensionAttributes?
    
    //let items: [JSONAny]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isVirtual = "is_virtual"
        case items
        case itemsCount = "items_count"
        case itemsQty = "items_qty"
        case customer = "customer"
        //case billingAddress = "billing_address"
        case origOrderID = "orig_order_id"
       // case currency
        case customerIsGuest = "customer_is_guest"
        case customerNoteNotify = "customer_note_notify"
        case customerTaxClassID = "customer_tax_class_id"
        case storeID = "store_id"
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - BillingAddressClass
struct BillingAddressClass: Codable{
    let city, countryID: String?
    var customAttributes: [BillingAddressCustomAttribute]?
    let customerID: Int?
    let email, firstname: String?
    let id: Int?
    let lastname, postcode, region, regionCode: String?
    let regionID: String?
    let sameAsBilling, saveInAddressBook: Int?
    let street: [String]?
    let telephone: String?
    
    enum CodingKeys: String, CodingKey {
        case city
        case countryID
        case customAttributes
        case customerID
        case email, firstname, id, lastname, postcode, region
        case regionCode
        case regionID
        case sameAsBilling
        case saveInAddressBook
        case street, telephone
    }
}

// MARK: - BillingAddressCustomAttribute
struct BillingAddressCustomAttribute: Codable {
    let attributeCode, value: String?

    enum CodingKeys: String, CodingKey {
        case attributeCode
        case value
    }
}

// MARK: - Currency
struct Currency: Codable {
    let baseCurrencyCode: String?
    let baseToGlobalRate, baseToQuoteRate: Int?
    let globalCurrencyCode, quoteCurrencyCode, storeCurrencyCode: String?
    let storeToBaseRate, storeToQuoteRate: Int?

    enum CodingKeys: String, CodingKey {
        case baseCurrencyCode
        case baseToGlobalRate
        case baseToQuoteRate
        case globalCurrencyCode
        case quoteCurrencyCode
        case storeCurrencyCode
        case storeToBaseRate
        case storeToQuoteRate
    }
}

// MARK: - Customer
struct Customer: Codable {
    
    let id: Int?
    let groupId: Int?
    let defaultBilling: String?
    let defaultShipping: String?
    let createdAt: String?
    let updatedAt: String?
    let createdIn: String?
    let dob: String?
    let email: String?
    let firstname: String?
    let lastname: String?
    let prefixField: String?
    let gender: Int?
    let storeId: Int?
    let websiteId: Int?
    let telephone: String?
    var addresses: [Addresses]?
    let disableAutoGroupChange: Int?
    let extensionAttributes: ExtensionAttributes?
    let customAttributes: [CustomAttributes]?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case groupId = "group_id"
        case defaultBilling = "default_billing"
        case defaultShipping = "default_shipping"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdIn = "created_in"
        case dob = "dob"
        case email = "email"
        case firstname = "firstname"
        case lastname = "lastname"
        case prefixField = "prefix"
        case gender = "gender"
        case storeId = "store_id"
        case telephone = "telephone"
        case websiteId = "website_id"
        case addresses = "addresses"
        case disableAutoGroupChange = "disable_auto_group_change"
        case extensionAttributes = "extension_attributes"
        case customAttributes = "custom_attributes"
    }
}

// MARK: - Address
struct AddressElement: Codable {
    let city, countryID, customerID, firstname: String?
    let id: Int?
    let lastname: String?
    let postcode: Int?
    let region: Region?
    let regionID: Int?
    let street: [Value]?
    let telephone: Int?

    enum CodingKeys: String, CodingKey {
        case city
        case countryID
        case customerID
        case firstname, id, lastname, postcode, region
        case regionID
        case street, telephone
    }
}

// MARK: - Region
struct Region: Codable {
    let region, regionCode: String?
    let regionID: Int?

    enum CodingKeys: String, CodingKey {
        case region
        case regionCode
        case regionID
    }
}



// MARK: - CustomAttribute
struct CustomAttribute: Codable {
    var attributeCode: String?
    var value: String?

    enum CodingKeys: String, CodingKey {
        case attributeCode = "attribute_code"
        case value
    }
}

// MARK: - CustomerExtensionAttributes
struct CustomerExtensionAttributes: Codable {
    let isSubscribed: Bool?

    enum CodingKeys: String, CodingKey {
        case isSubscribed = "is_subscribed"
    }
}

// MARK: - ExtensionAttributes
struct ExtensionAttributes: Codable {
    let shippingAssignments: [ShippingAssignment]?
    let isSubscribed: Bool?
   
    enum CodingKeys: String, CodingKey {
        case shippingAssignments = "shipping_assignments"
        case isSubscribed
        
    }
}

// MARK: - GiftCard
struct GiftCard: Codable {
    
    let i: String?
    let c: String?
    let a: Int?
    let ba: Int?

    enum CodingKeys: String, CodingKey {
        case i 
        case c
        case a
        case ba
    }
}

// MARK: - ShippingAssignment
struct ShippingAssignment: Codable {
    let shipping: Shipping?
    let items: [CartItem]?
}

// MARK: - CartItem
struct CartItem: Codable {
    
    let itemID: Int?
    let sku: String?
    let qty: Int?
    let name: String?
    let price: Double?
    let productType, quoteID: String?
    let extensionAttributes: ItemExtensionAttributes?

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case sku, qty, name, price
        case productType = "product_type"
        case quoteID = "quote_id"
        case extensionAttributes = "extension_attributes"
    }
}

// MARK: - Shipping
struct Shipping: Codable {
    let address: BillingAddressClass?
    //let method: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class WishlistModel: NSObject{
  
        var manufacturer:String = ""
        var wishlist_item_id:String = ""
        var wishlist_id:String = ""
        var product_id:String = ""
        var added_at:Date = Date()
        var qty:String = ""
        var product = WishlistProductModel()
    
    func getWishlistModel(dict:[String:AnyObject]) -> WishlistModel{
        if let manufacturer = dict["manufacturer"] as? String{
            self.manufacturer = manufacturer
        }
        if let wishlist_item_id = dict["wishlist_item_id"] as? String{
            self.wishlist_item_id = "\(wishlist_item_id)"
        }
        if let added_at = dict["added_at"] as? String{
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: Date? = dateFormatterGet.date(from: added_at)
            self.added_at = date!
        }
        
        if let wishlist_id = dict["wishlist_id"] as? String{
            self.wishlist_id = wishlist_id
        }
        if let product_id = dict["product_id"] as? String{
            self.product_id = "\(product_id)"
        }
        if let qty = dict["qty"] as? NSNumber{
            self.qty = "\(qty)"
        }
        if let productDict = dict["product"]  {
            let productModel = WishlistProductModel()
            self.product = productModel.getWishlistProductModel(dict: productDict as! [String : AnyObject])
               }
        return self
    }
}

class WishlistProductModel: NSObject{
    var row_id :    String = ""
    var  entity_id :    String = ""
    var  created_in :    String = ""
    var  updated_in :    String = ""
    var  attribute_set_id :    String = ""
    var  type_id :    String = ""
    var  sku :    String = ""
    var  has_options :    String = ""
    var  required_options :    String = ""
    var  created_at :    Date = Date()
    var  updated_at :    String = ""
    var  price :    String = ""
    var  tax_class_id :    String = ""
    var  final_price :    String = ""
    var  minimal_price :    Double = 0.0
    var  min_price :    Double = 0.0
    var  max_price :    String = ""
    var  tier_price :    String = ""
    var  name :    String = ""
    var  url_key :    String = ""
    var  msrp_display_actual_price_type :    String = ""
    var  primaryvpn :    String = ""
    var  styleoraclenumber :    String = ""
    var  short_description :    String = ""
    var  special_price :    String = ""
    var  special_from_date :    String = ""
    var  manufacturer :    String = ""
    var  color :    String = ""
    var  status :    String = ""
    var  visibility :    String = ""
    var  quantity_and_stock_status :    String = ""
    var  gender :    String = ""
    var  subcategory :    String = ""
    var  size :    String = ""
    var  lvl_concession_type :    String = ""
    var  request_path :    String = ""
    var  small_image :    String = ""
    var  thumbnail : String = ""
    var  image : String = ""
    func getWishlistProductModel(dict:[String:AnyObject]) -> WishlistProductModel{
        if let row_id = dict["row_id"] as? String{
            self.row_id = row_id
        }
        if let entity_id = dict["entity_id"] as? String{
            self.entity_id = "\(entity_id)"
        }
        
        if let created_in = dict["created_in"] as? String{
            self.created_in = created_in
        }
        if let updated_in = dict["updated_in"] as? NSNumber{
            self.updated_in = "\(updated_in)"
        }
        if let attribute_set_id = dict["attribute_set_id"] as? String{
            self.attribute_set_id = attribute_set_id
        }
        if let type_id = dict["type_id"] as? String{
            self.type_id = type_id
        }
        if let sku = dict["sku"] as? String{
            self.sku = "\(sku)"
        }
        
        if let has_options = dict["has_options"] as? String{
            self.has_options = has_options
        }
        if let required_options = dict["required_options"] as? NSNumber{
            self.required_options = "\(required_options)"
        }
        if let created_at = dict["created_at"] as? String{
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: Date? = dateFormatterGet.date(from: created_at)
            self.created_at = date!
        }
        
        if let updated_at = dict["updated_at"] as? String{
            self.updated_at = updated_at
        }
        if let price = dict["price"] as? String{
            self.price = "\(price)"
        }
        
        if let tax_class_id = dict["tax_class_id"] as? String{
            self.tax_class_id = tax_class_id
        }
        if let final_price = dict["final_price"] as? NSNumber{
            self.final_price = "\(final_price)"
        }
        if let minimal_price = dict["minimal_price"] as? Double{
            self.minimal_price = minimal_price
        }
        
        if let min_price = dict["min_price"] as? Double{
            self.min_price = min_price
        }
        if let tier_price = dict["tier_price"] as? String{
            self.tier_price = "\(tier_price)"
        }
        
        if let name = dict["name"] as? String{
            self.name = name
        }
        if let url_key = dict["url_key"] as? NSNumber{
            self.url_key = "\(url_key)"
        }
        
        
        if let msrp_display_actual_price_type = dict["msrp_display_actual_price_type"] as? String{
            self.msrp_display_actual_price_type = msrp_display_actual_price_type
        }
        if let primaryvpn = dict["primaryvpn"] as? String{
            self.primaryvpn = "\(primaryvpn)"
        }
        
        if let styleoraclenumber = dict["styleoraclenumber"] as? String{
            self.styleoraclenumber = styleoraclenumber
        }
        if let short_description = dict["short_description"] as? String{
            self.short_description = "\(short_description)"
        }
        if let special_price = dict["special_price"] as? String{
            self.special_price = special_price
        }
        
        if let special_from_date = dict["special_from_date"] as? String{
            self.special_from_date = special_from_date
        }
        if let manufacturer = dict["manufacturer"] as? String{
            self.manufacturer = "\(manufacturer)"
        }
        
        if let color = dict["color"] as? String{
            self.color = color
        }
        if let status = dict["status"] as? NSNumber{
            self.status = "\(status)"
        }
        
        if let visibility = dict["visibility"] as? String{
            self.visibility = visibility
        }
        
        
        if let quantity_and_stock_status = dict["quantity_and_stock_status"] as? String{
            self.quantity_and_stock_status = quantity_and_stock_status
        }
        if let gender = dict["gender"] as? NSNumber{
            self.gender = "\(gender)"
        }
        if let subcategory = dict["subcategory"] as? String{
            self.subcategory = subcategory
        }
        
        if let size = dict["size"] as? String{
            self.size = size
        }
        if let lvl_concession_type = dict["lvl_concession_type"] as? String{
            self.lvl_concession_type = "\(lvl_concession_type)"
        }
        
        if let request_path = dict["request_path"] as? String{
            self.request_path = request_path
        }
        if let small_image = dict["small_image"] as? String{
            self.small_image = "\(small_image)"
        }
        
        if let thumbnail = dict["thumbnail"] as? String{
            self.thumbnail = thumbnail
        }
        if let image = dict["image"] as? String{
                   self.image = image
               }
 
        return self
    }
}


