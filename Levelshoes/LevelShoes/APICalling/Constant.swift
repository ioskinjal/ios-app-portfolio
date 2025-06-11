//
//  Constant.swift
//  chronicsouls
//
//  Created by NCT 24 on 18/01/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

typealias dictionary = [String:Any]

struct InvoiceKey {
            static let request_type = "app"
            static let invoice = "Invoice"
            static let service_start_time = "Service Start Time"
            static let service_end_time = "Service End Time"
            static let booking_id = "Booking Id"
            static let booking_details = "Booking Details"
            static let booking_amount = "Booking Amount"
            static let admin_fees = "Admin Fees"
            static let payment_type = "Payment Type"
            static let total_payable_amount = "Total Payable Amount"
            static let total_receivable_amount = "Total Receivable Amount"
            static let wallet = "Wallet"
            static let cash = "Cash"
            static let complete = "Completed"
}
struct string{
            static let currency = "currency"
            static let language = "language"
            static let en = "en"
            static let ar = "ar"
            static let ae = "ae"
            static let onboarding = "onboarding"
            static let landing = "landing"
            static let English = "English"
            static let Arabic = "Arabic"
            static let userLanguage = "userLanguage"
            static let userToken = "userToken"
            static let storecode = "storecode"
            static let category = "category"
            static let data = "data"
            static let customerId = "customerId"
            static let storeId = "storeId"
            static let isFBuserLogin = "isFBuserLogin"
            static let shopBagItemCount = "shopBagItemCount"
            static let notificationItemCount = "notificationItemCount"

    
}
var M2_baseUrl = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() +  "/V1/"
var M2_getToken = M2_baseUrl + "integration/customer/token"
var M2_getCartID = M2_baseUrl + "carts/mine/"
var M2_getCustomerInformation =  M2_baseUrl + "customers/me"
var M2_shippingAddress =  M2_baseUrl + "customers/me/shippingAddress"
var M2_billingAddress =  M2_baseUrl + "customers/me/billingAddress"
var guest_carts__item_quote_id =  UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") ?? ""
var M2_wishList =  M2_baseUrl + "wishlist/add/"
var M2_WishList_Remove =  M2_baseUrl + "wishlist/remove/"
var M2_WishList_Get = M2_baseUrl + "wishlist/items?customer_id="
var M2_addNewAddress =  M2_baseUrl + "customers/me"
var M2_inActiveCart =  M2_baseUrl + "carts/mine/"
var M2_inActiveBilling =  M2_baseUrl + "customers/me/billingAddress"
var M2_addItemInCart =  M2_baseUrl + "carts/mine/items"
var M2_getCartItems =  M2_baseUrl + "carts/mine/"
var M2_updateCartItem =  M2_baseUrl + "carts/mine/items"
var M2_deleteCartItem =  M2_baseUrl + "carts/mine/items/"
var M2_getCheckoutTotals =  M2_baseUrl + "carts/mine/totals"
var M2_generateQuateID =  M2_baseUrl + "carts/mine/"
var M2_giftcardRedeem =  M2_baseUrl + "customers/updategiftcardaccount"
var OMS_OMSOrder = CommonUsed.globalUsed.orderCreate
var M2_shippingMethod = M2_baseUrl + "carts/mine/estimate-shipping-methods"
var M2_shippingInformation = M2_baseUrl + "carts/mine/shipping-information"
var M2_Guest_Cart_To_Logged_User_Cart_Conversion =   M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id

//Giftcard Variables
var M2_giftCard =  M2_baseUrl + "carts/mine/giftCards"
var M2_GiftCard_Remove =  getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/V1/carts/mine/giftCards/"

//Coupon Variables
var M2_coupon = M2_baseUrl + "carts/mine/coupons"
var M2_Coupon_Remove =  getWebsiteBaseUrl(with: "rest") +  getM2StoreCode() + "/V1/carts/mine/coupons"
/*
 Function Name: userLoginStatus
 Params: status <Bool>
 Example Parameter: false
 Parameter Description: User Login Status Will be Passed to get the Urls
 */
func userLoginStatus(status:Bool){
    M2_baseUrl = getWebsiteBaseUrl(with: "rest") + getM2StoreCode() +  "/V1/"
    if status {
         
         M2_getCartID = M2_baseUrl + "carts/mine/"
         M2_getCustomerInformation =  M2_baseUrl + "customers/me"
         guest_carts__item_quote_id =  UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") ?? ""
         M2_wishList =  M2_baseUrl + "wishlist/add/"
         M2_WishList_Get = M2_baseUrl + "wishlist/items?customer_id="
         M2_WishList_Remove =  M2_baseUrl + "wishlist/remove/"
         M2_addNewAddress =  M2_baseUrl + "customers/me"
         M2_inActiveCart =  M2_baseUrl + "carts/mine/"
         M2_addItemInCart =  M2_baseUrl + "carts/mine/items"
         M2_getCartItems =  M2_baseUrl + "carts/mine/"
         M2_updateCartItem =  M2_baseUrl + "carts/mine/items"
         M2_deleteCartItem =  M2_baseUrl + "carts/mine/items/"
        
         M2_shippingInformation = M2_baseUrl + "carts/mine/shipping-information"
         M2_getCheckoutTotals =  M2_baseUrl + "carts/mine/totals"
         M2_generateQuateID =  M2_baseUrl + "carts/mine/"
         OMS_OMSOrder = CommonUsed.globalUsed.orderCreate
         M2_shippingMethod = M2_baseUrl + "carts/mine/estimate-shipping-methods"
         M2_Guest_Cart_To_Logged_User_Cart_Conversion =   M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id
         
         M2_giftCard =  M2_baseUrl + "carts/mine/giftCards"
         M2_GiftCard_Remove =  getWebsiteBaseUrl(with: "rest") + getM2StoreCode() + "/V1/carts/mine/giftCards/"
         //M2_GiftCard_Remove =  M2_baseUrl + "guest-carts/"+guest_carts__item_quote_id+"/giftCards/"
         
         M2_coupon = M2_baseUrl + "carts/mine/coupons"
         M2_Coupon_Remove =  getWebsiteBaseUrl(with: "rest") +  getM2StoreCode() + "/V1/carts/mine/coupons"
        
    }else{
        guest_carts__item_quote_id = UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") ?? ""
         M2_addItemInCart =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/items"
         M2_generateQuateID =  M2_baseUrl + "guest-carts"
         M2_getCartItems =  M2_baseUrl + "guest-carts/" +  guest_carts__item_quote_id
         M2_updateCartItem =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/items"
         M2_deleteCartItem =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/items/"
         M2_addItemInCart =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/items"
        
         M2_Guest_Cart_To_Logged_User_Cart_Conversion =   M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id
         M2_Guest_Cart_To_Logged_User_Cart_Conversion =   M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id
         M2_getCheckoutTotals =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/totals"
         
         M2_giftCard =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/giftCards"
         M2_coupon =  M2_baseUrl + "guest-carts/" + guest_carts__item_quote_id + "/coupons"
         M2_Coupon_Remove = M2_baseUrl + "guest-carts/"+guest_carts__item_quote_id+"/coupons/"
    }
}

struct notificationName {
    static let changeTabBar = "CHANGE_TAB_BAR"
    static let changeCategory = "CHANGE_CATEGORY"
    static let LetGO_LOGIN_TO_HOME = "LetGO_LOGIN_TO_HOME"
     static let CHANGE_SHOP_BAG_COUNT = "CHANGE_SHOP_BAG_COUNT"
    static let CHANGE_NOTIFICATION_COUNT = "CHANGE_NOTIFICATION_COUNT"
}

struct StoryBoard {
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let Loginregistration  = UIStoryboard(name: "Loginregistration", bundle: nil)
    static let Registration  = UIStoryboard(name: "Registration", bundle: nil)

    static let ForgotPW  = UIStoryboard(name: "ForgotPW", bundle: nil)
    static let plp  = UIStoryboard(name: "PLP", bundle: nil)
     static let pdp  = UIStoryboard(name: "PDP", bundle: nil)
    static let myOrder = UIStoryboard(name: "MyOrders", bundle: nil)
    
}


//var topSelectedMenu = 1

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum keys:String  {
    
    case _shards = "_shards"
    case hits = "hits"
    case _source = "_source"
    case intro = "intro"
    case onboarding = "onboarding"
    case country = "country"
    case language = "language"
    case categories = "categories"
    case data = "data"
    case elements = "elements"
    case hype = "hype"
    case newin = "newin"
    case collections = "collections"
    case names = "names"
    case meta = "meta"
    case result = "result"
    case options = "options"
    case swatch = "swatch"
    case media_gallery = "media_gallery"
    case category = "category"
    case exclusives = "exclusives"
    case accessories = "accessories"
    case extra_products = "extra_products"
    case products = "products"
    case aws = "aws"
    case ios = "ios"
    case filter_en = "filter_en"
    case filter_ar = "filter_ar"
    case sortby = "sortby"
    case filterby = "filterby"
    case content = "content"
    
    //Aggregations
    case aggregations = "aggregations"
    case ColorFilter = "colorFilter"
    case PriceFilter = "PriceFilter"
    case DesignerFilter = "manufacturerFilter"
    case CategoryFilter = "lvl_categoryFilter"
    case SizeFilter = "sizeFilter"
    case GenderFilter = "genderFilter"
    case max_price = "max_price"
    case min_price = "min_price"
    case configurable_children = "configurable_children"
    /**************************************/
    
    case buckets = "buckets"
    
}

struct ResponseKey{
    
    static func fatchDataAsDictionary(res: dictionary, valueOf key: keys) -> [String:Any] {
        if res[key.rawValue] as? [String:Any] != nil{
            return res[key.rawValue] as! [String:Any]
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                return [:]
            }
            else if res[key.rawValue] as? String != nil{
                return [:]
            }else{
                return [:]
            }
        }
    }
    
    static func fatchDataAsArray(res: dictionary, valueOf key: keys) -> [Any] {
        if res[key.rawValue] as? [Any] != nil{
            return res[key.rawValue] as! [Any]
        }
        else{
            if res[key.rawValue] as? [String:Any] != nil{
                return []
            }
            else if res[key.rawValue] as? String != nil{
                return []
            }else{
                return []
            }
        }
    }
    
    static func fatchDataAsString(res: dictionary, valueOf key: keys) -> String {
        if res[key.rawValue] as? String != nil{
            return res[key.rawValue] as! String
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                return ""
            }
            else if res[key.rawValue] as? [String:Any] != nil{
                return ""
            }else{
                return ""
            }
        }
    }
    
    static func fatchData(res: dictionary, valueOf key: keys) -> (dic: [String:Any], ary: [Any], str: String){
        if res[key.rawValue] as? [String:Any] != nil{
            return (dic: res[key.rawValue] as! [String:Any], ary: [], str: "")
        }
        else if res[key.rawValue] as? [Any] != nil{
            return (dic: [:], ary: res[key.rawValue] as! [Any], str: "")
        }
        else if res[key.rawValue] as? String != nil{
            return (dic: [:], ary: [], str: res[key.rawValue] as! String)
        }else{
            return (dic: [:], ary:[], str: "")
        }
    }
    
    static func fatchDataAsArrayOfArray(res: NSObject, valueOf key: keys) -> [Any] {
        return [res as! [Any]]
    }

}




