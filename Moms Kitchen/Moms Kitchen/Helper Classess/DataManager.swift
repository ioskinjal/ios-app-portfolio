//
//  DataManager.swift
//  Talabtech
//
//  Created by NCT 24 on 19/05/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class User: NSObject {
    
    //    "user_id": "81",
    //    "first_name": "Me",
    //    "last_name": "Ns",
    //    "user_name": "Me Ns",
    //    "user_type": "c",
    //    "email_id": "ns@mailinator.com",
    //    "country_code_id": "91"
    
    private let keys = ["user_id","first_name","last_name","user_name","user_type","email_id","country_code_id","profile_img","com_phonenum","company_address","company_name","verification_doc"/*"mobileverify","city_shipping",
         "state_shipping","postal_code","address"*/]
    
    @objc var user_id = ""
    @objc var first_name = ""
    @objc var last_name = ""
    @objc var user_name = ""
    @objc var email_id = ""
    @objc var  user_image = ""
    @objc var cart_items_count = 0
    @objc var phone = ""
    
    //    @objc var mobileverify = ""
    //    @objc var city_shipping = ""
    //    @objc var state_shipping = ""
    //    @objc var postal_code = ""
    //    @objc var address = ""
    //    @objc var isProvider = false
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        self.user_id = dic["user_id"] as? String ?? ""
        self.first_name = dic["first_name"] as? String ?? ""
        self.last_name = dic["last_name"] as? String ?? ""
        self.user_name = dic["user_name"] as? String ?? ""
        self.email_id = dic["email"] as? String ?? ""
        self.user_image = dic["user_image"] as? String ?? ""
        self.cart_items_count = dic["cart_items_count"] as? Int ?? 0
        self.phone = dic["phone"] as? String ?? ""
    }
    
    init(userData dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
        //self.isProvider = ( (dic["user_type"] as? String ?? "") == "p" ? true : false )
    }
    
    //This variable use for Convert Any Class type object into Dictionary type (Class properties become a Key in Dictionry and same for values also)
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}

class UserSocialData {
    var cart_items_count : Int?
    var first_name : String?
    var last_name : String?
    var user_id : String?
    var user_image : String?
    var email_id : String?
    var phone: String?
    
    required public init?(dictionary: [String:Any]) {
        first_name = dictionary["first_name"] as? String ?? ""
        last_name = dictionary["last_name"] as? String ?? ""
        email_id = dictionary["email_id"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
        phone = dictionary["phone"] as? String ?? ""
        cart_items_count = dictionary["cart_items_count"] as? Int ?? 0
    }
    
}

class UserLoginData {
    var user_id : String = ""
     var email : String = ""
     var first_name : String = ""
     var last_name : String = ""
     var user_image : String = ""
     var cart_items_count : Int = 0
    var password : String = ""
    
    required init(dictionary: [String:Any]) {
        
        password = dictionary["password"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        first_name = dictionary["first_name"] as? String ?? ""
        last_name = dictionary["last_name"] as? String ?? ""
        user_image = dictionary["user_image"] as? String ?? ""
        cart_items_count = dictionary["cart_items_count"] as? Int ?? 0
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
         dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.user_image, forKey: "user_image")
        dictionary.setValue(self.cart_items_count, forKey: "cart_items_count")
        return dictionary as! [String:Any]
    }
    
}


class BreakFastList:NSObject {
    
     @objc var cuisineID = ""
     @objc var cuisineName  = ""
  
    @objc var isItemCustomizable:Bool = false
    @objc var itemID  = ""
    @objc var itemImage = ""
    @objc var itemName  = ""
    @objc var itemPrice = ""
    @objc var cartItemId = ""
    @objc var qty = ""
    @objc var delivery_date = ""
    @objc var order_status = ""
    @objc var isCancelable = false
    
    @objc var cuisineItemsList : [CuisineItemList]?
    @objc var customizationList = [CustomizationList]()
    //@objc var customizationItemList : [CustomizationItemList]?
    init(dic:[String:Any]) {
        super.init()
        cuisineID = dic["cuisineID"] as? String ?? ""
        cuisineName = dic["cuisineName"] as? String ?? ""
       
        let cuisine = dic["cuisineItemsList"] as? [Any] ?? [Any]()
        self.cuisineItemsList = cuisine.map({CuisineItemList(dic: $0 as! [String:Any])})
        let customize = dic["customizationList"] as? [Any] ?? [Any]()
        self.customizationList = customize.map({CustomizationList(dic: $0 as! [String:Any])})
        isItemCustomizable = dic["isItemCustomizable"] as? Bool ?? false
        isCancelable = dic["isCancelable"] as? Bool ?? false
        itemID = dic["itemID"] as? String ?? ""
        itemImage = dic["itemImage"] as? String ?? ""
        itemName = dic["itemName"] as? String ?? ""
        itemPrice = dic["itemPrice"] as? String ?? ""
        cartItemId = dic["cartItemId"] as? String ?? ""
        delivery_date = dic["delivery_date"] as? String ?? ""
        qty = dic["qty"] as? String ?? "0"
        order_status = dic["order_status"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}
@objcMembers class CuisineItemList:NSObject {
     var isItemCustomizable:Bool = false
     var itemID  = ""
     var qty = 1
     var itemImage = ""
     var itemName  = ""
     var itemPrice = ""
     var cartItemId = ""
    var delivery_date = ""
    var customizationList : [CustomizationList]?
    
  //  @objc var cuisineItemsList : [CuisineItemList]?
    
    init(dic:[String:Any]) {
        super.init()
        let customize = dic["customizationList"] as? [Any] ?? [Any]()
        self.customizationList = customize.map({CustomizationList(dic: $0 as! [String:Any])})
        isItemCustomizable = dic["isItemCustomizable"] as? Bool ?? false
        itemID = dic["itemID"] as? String ?? ""
        itemImage = dic["itemImage"] as? String ?? ""
        itemName = dic["itemName"] as? String ?? ""
        itemPrice = dic["itemPrice"] as? String ?? ""
        cartItemId = dic["cartItemId"] as? String ?? ""
        delivery_date = dic["delivery_date"] as? String ?? ""
        qty = dic["qty"] as? Int ?? 1
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

@objcMembers class CustomizationList:NSObject {
    var customizationID  = ""
    var customizationName = ""
    var customizationType  = ""
    
    @objc var customizationItemName = ""
    @objc var customizationItemPrice  = ""
    
  // @objc var cuisineItemList = [CuisineItemList]()
    @objc var customizationItemList = [CustomizationItemList]()
    
    init(dic:[String:Any]) {
        super.init()
        let customizeItem = dic["customizationItemList"] as? [Any] ?? [Any]()
        self.customizationItemList = customizeItem.map({CustomizationItemList(dic: $0 as! [String:Any])})
        customizationID = dic["customizationID"] as? String ?? ""
        customizationName = dic["customizationName"] as? String ?? ""
        customizationType = dic["customizationType"] as? String ?? ""
        customizationItemName = dic["customizationItemName"] as? String ?? ""
        customizationItemPrice = dic["customizationItemPrice"] as? String ?? ""
        
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}
@objcMembers class CustomizationItemList:NSObject {
    var customizationItemID  = ""
    var customizationItemName = ""
    var customizationItemPrice  = ""
    var is_checked = false
    var isSelected = false
    //@objc var customizationItemList = [CustomizationItemList]()
    
    init(dic:[String:Any]) {
        super.init()
        customizationItemID = dic["customizationItemID"] as? String ?? ""
        customizationItemName = dic["customizationItemName"] as? String ?? ""
        customizationItemPrice = dic["customizationItemPrice"] as? String ?? ""
        is_checked = dic["is_checked"] as? Bool ?? false
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

class CuisineMenu{
    var breakfast = [BreakFastList]()
    var lunch = [BreakFastList]()
    var dinner = [BreakFastList]()
    
    init(data:[String:Any]) {
        self.breakfast = (data["breakfast"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.lunch = (data["lunch"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.dinner = (data["dinner"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
    }
}

class CartData{
    var total_order_price : Float = 0.0
    var sgst_percentage : Float = 0.0
    var cgst_percentage : Float = 0.0
    var sgst_charge : Double = 0.0
    var cgst_charge :Double = 0.00
    var total_price : Double = 0.00
    var breakfast = [BreakFastList]()
    var lunch = [BreakFastList]()
    var dinner = [BreakFastList]()
    var payable_paytm_amt : Double = 0.0
    var credits : Double = 0.0
    var cart_items_count : Int = 0
    
    
    init(data:[String:Any]) {
        self.breakfast = (data["breakfast"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.lunch = (data["lunch"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.dinner = (data["dinner"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.total_order_price = data["total_order_price"] as? Float ?? 0.0
        self.sgst_percentage = data["sgst_percentage"] as? Float ?? 0.0
        self.cgst_percentage = data["cgst_percentage"] as? Float ?? 0.0
        self.sgst_charge = data["sgst_charge"] as? Double ?? 0.0
        self.cgst_charge = data["cgst_charge"] as? Double ?? 0.0
        self.total_price = data["total_price"] as? Double ?? 0.0
        self.payable_paytm_amt = data["payable_paytm_amt"] as? Double ?? 0.0
        self.credits = data["credits"] as? Double ?? 0.0
        self.cart_items_count = data["cart_items_count"] as? Int ?? 0
    }
}

class Profile {
    var credits : String = ""
    var email : String = ""
    var fname : String = ""
    var lname : String = ""
    var phone : String = ""
    var user_image : String = ""
    
    required init(dictionary: [String:Any]) {
        credits = dictionary["credits"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        fname = dictionary["fname"] as? String ?? ""
        lname = dictionary["lname"] as? String ?? ""
        phone = dictionary["phone"] as? String ?? ""
        user_image = dictionary["user_image"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.credits, forKey: "credits")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.fname, forKey: "fname")
        dictionary.setValue(self.lname, forKey: "lname")
        dictionary.setValue(self.phone, forKey: "phone")
        dictionary.setValue(self.user_image, forKey: "user_image")
        return dictionary as! [String:Any]
    }
}

//class PlaceOrder {
//    var ORDER_ID : String = ""
//    var CHECKSUMHASH : String = ""
//
//    required init(dictionary: [String:Any]) {
//        order_id = dictionary["ORDER_ID"] as? String ?? ""
//        CHECKSUMHASH = dictionary["CHECKSUMHASH"] as? String ?? ""
//    }
//
//    func dictionaryRepresentation() -> [String:Any] {
//        let dictionary = NSMutableDictionary()
//        dictionary.setValue(self.ORDER_ID, forKey: "ORDER_ID")
//        dictionary.setValue(self.CHECKSUMHASH, forKey: "CHECKSUMHASH")
//        return dictionary as! [String:Any]
//    }
//}

class CheckSum {
    var ORDER_ID : String = ""
    var CHECKSUMHASH : String = ""
    
    required init(dictionary: [String:Any]) {
        ORDER_ID = dictionary["ORDER_ID"] as? String ?? ""
        CHECKSUMHASH = dictionary["CHECKSUMHASH"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.ORDER_ID, forKey: "ORDER_ID")
        dictionary.setValue(self.CHECKSUMHASH, forKey: "CHECKSUMHASH")
        return dictionary as! [String:Any]
    }
}

class NotificationSetting {
    var orderPlaced : Bool = false
    var orderPacked :  Bool = false
    var orderDispatched :  Bool = false
    var orderDelivered :  Bool = false
    var orderCancelled :  Bool = false
   
    
    required init(dictionary: [String:Any]) {
        orderPlaced = dictionary["orderPlaced"] as? Bool ?? false
        orderPacked = dictionary["orderPacked"] as? Bool ?? false
        orderDispatched = dictionary["orderDispatched"] as? Bool ?? false
        orderDelivered = dictionary["orderDelivered"] as? Bool ?? false
        orderCancelled = dictionary["orderCancelled"] as? Bool ?? false
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.orderPlaced, forKey: "orderPlaced")
        dictionary.setValue(self.orderPacked, forKey: "orderPacked")
        dictionary.setValue(self.orderDispatched, forKey: "orderDispatched")
        dictionary.setValue(self.orderDelivered, forKey: "orderDelivered")
        dictionary.setValue(self.orderCancelled, forKey: "orderCancelled")
        return dictionary as! [String:Any]
    }
    
}

class AddressList:NSObject {
    var address_line1:String = ""
    var address_line2:String = ""
    var address_line3:String = ""
    var address_type_id:String = ""
    var area_name:String = ""
    var area_nick_name:String = ""
    var city:String = ""
    var id:String = ""
    var pincode:String = ""
    var state:String = ""
    var landmark:String = ""
    
    init(dic:[String:Any]) {
        super.init()
        address_line1 = dic["address_line1"] as? String ?? ""
        landmark = dic["landmark"] as? String ?? ""
        address_line2 = dic["address_line2"] as? String ?? ""
        address_line3 = dic["address_line3"] as? String ?? ""
        address_type_id = dic["address_type_id"] as? String ?? ""
        area_name = dic["area_name"] as? String ?? ""
        area_nick_name = dic["area_nick_name"] as? String ?? ""
        city = dic["city"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        pincode = dic["pincode"] as? String ?? ""
        state = dic["state"] as? String ?? ""
        
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

class AddressData {
    var address_line1:String = ""
    var address_line2:String = ""
    var address_line3:String = ""
    var address_type_id:String = ""
    var area_name:String = ""
    var area_nick_name:String = ""
    var city:String = ""
    var id:String = ""
    var pincode:String = ""
    var state:String = ""
    var landmark:String = ""
    var areas = [AreaList]()
    
    required init(dictionary: [String:Any]) {
          self.areas = (dictionary["areas"] as? [Any] ?? [Any]()).map({AreaList(dic: $0 as! [String:Any])})
        address_line1 = dictionary["address_line1"] as? String ?? ""
        address_line2 = dictionary["address_line2"] as? String ?? ""
        address_line3 = dictionary["address_line3"] as? String ?? ""
        address_type_id = dictionary["address_type_id"] as? String ?? ""
        area_name = dictionary["area_name"] as? String ?? ""
        area_nick_name = dictionary["area_nick_name"] as? String ?? ""
        city = dictionary["city"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""
        pincode = dictionary["pincode"] as? String ?? ""
        state = dictionary["state"] as? String ?? ""
        landmark = dictionary["landmark"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.address_line1, forKey: "address_line1")
        dictionary.setValue(self.address_line2, forKey: "address_line2")
        dictionary.setValue(self.address_line3, forKey: "address_line3")
        dictionary.setValue(self.address_type_id, forKey: "address_type_id")
        dictionary.setValue(self.area_name, forKey: "area_name")
        dictionary.setValue(self.area_nick_name, forKey: "area_nick_name")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.pincode, forKey: "pincode")
        dictionary.setValue(self.state, forKey: "state")
        dictionary.setValue(self.landmark, forKey: "landmark")
        return dictionary as! [String:Any]
    }
    
    class AreaList: NSObject {
        
        var area_name : String?
        
        init(dic:[String:Any]) {
            super.init()
            area_name = dic["area_name"] as? String
            
        }
        
        init(dictionary:[String:Any]) {
            super.init()
            self.setValuesForKeys(dictionary)
        }
    }
}


class NotificationData {
    var id : String = ""
    var notification : String = ""
    var date : String = ""
    
    required init(dictionary: [String:Any]) {
        id = dictionary["id"] as? String ?? ""
        notification = dictionary["notification"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.notification, forKey: "notification")
        dictionary.setValue(self.date, forKey: "date")
        return dictionary as! [String:Any]
    }
    
}

class NotificationCls{
    var notificationList: [NotificationList] = [NotificationList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["notificationsList"] as! [Any]).map({NotificationList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["pagination"] as! [String:Any]))
    }
    
    class NotificationList {
        var notification : String?
        var date : String?
        
        required init(dictionary: [String:Any]) {
            notification = dictionary["notification"] as? String
            date = dictionary["date"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.notification, forKey: "notification")
            dictionary.setValue(self.date, forKey: "date")
            return dictionary as! [String:Any]
        }
        
    }
    
    class Pagination {
        var total_records : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total_records = dictionary["total_records"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total_records, forKey: "total_records")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
    
}

class RecommendedList:NSObject {
    var cuisineType : String?
    var itemID : String?
    var itemImage : String?
    var itemName : String?
    var itemPrice : String?
    var cuisineId : String?
    var mealType : String?
    var isItemCustomizable:Bool?
    @objc var customizationList = [CustomizationList]()
    
   
    
    init(dic:[String:Any]) {
        super.init()
        let customize = dic["customizationList"] as? [Any] ?? [Any]()
        self.customizationList = customize.map({CustomizationList(dic: $0 as! [String:Any])})
        cuisineType = dic["cuisineType"] as? String ?? ""
        itemID = dic["itemID"] as? String ?? ""
        itemImage = dic["itemImage"] as? String ?? ""
        itemName = dic["itemName"] as? String ?? ""
        itemPrice = dic["itemPrice"] as? String ?? ""
        cuisineId = dic["cuisineId"] as? String ?? ""
        mealType = dic["mealType"] as? String ?? ""
        isItemCustomizable = dic["isItemCustomizable"] as? Bool ?? false
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
}

class MyOrdersCls{
    var orderListItem: [OrderList] = [OrderList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        orderListItem = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["ordered_items_list"] as! [Any]).map({OrderList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["pagination"] as! [String:Any]))
    }
    
    class OrderList {
        var id : String?
        var mealType : String?
        var orderId : String?
        var order_date : String?
        var delivery_date : String?
        var order_status : String?
        var order_prefix : String?
        
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String
            mealType = dictionary["mealType"] as? String
            orderId = dictionary["orderId"] as? String
            order_date = dictionary["order_date"] as? String
            delivery_date = dictionary["delivery_date"] as? String
            order_status = dictionary["order_status"] as? String
            order_prefix = dictionary["order_prefix"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.mealType, forKey: "mealType")
            dictionary.setValue(self.orderId, forKey: "orderId")
            dictionary.setValue(self.order_date, forKey: "order_date")
            dictionary.setValue(self.delivery_date, forKey: "delivery_date")
            dictionary.setValue(self.order_status, forKey: "order_status")
            dictionary.setValue(self.order_prefix, forKey: "order_prefix")
            return dictionary as! [String:Any]
        }
        
    }
    
    class Pagination {
        var total_records : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total_records = dictionary["total_records"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total_records, forKey: "total_records")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class OrderDetail{
    var total_order_price : Float = 0.0
    var sgst_percentage : Double = 0.0
    var cgst_percentage : Double = 0.0
    var sgst_charge : Double = 0.0
    var cgst_charge :Double = 0.0
    var total_price : Double = 0.0
    var order_items = [BreakFastList]()
    var invoice: String = ""
    
    init(data:[String:Any]) {
        self.order_items = (data["order_items"] as? [Any] ?? [Any]()).map({BreakFastList(dic: $0 as! [String:Any])})
        self.total_order_price = data["total_order_price"] as? Float ?? 0.0
        self.sgst_percentage = data["sgst_percentage"] as? Double ?? 0.0
        self.cgst_percentage = data["cgst_percentage"] as? Double ?? 0.0
        self.sgst_charge = data["sgst_charge"] as? Double ?? 0.0
        self.cgst_charge = data["cgst_charge"] as? Double ?? 0.0
        self.total_price = data["total_price"] as? Double ?? 0.0
        self.invoice = data["invoice"] as? String ?? ""
    }
}




class InfoList: NSObject{
    
    private let keys = ["pId", "pageTitle","pageDesc","linkType","url"]
    
   @objc var pId = ""
   @objc var pageTitle = ""
   @objc var pageDesc = ""
   @objc var linkType = ""
   @objc var url = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        pId = dic["pId"] as? String ?? ""
        pageTitle = dic["pageTitle"] as? String ?? ""
        pageDesc = dic["pageDesc"] as? String ?? ""
        linkType = dic["linkType"] as? String ?? ""
        url = dic["url"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
}
}

