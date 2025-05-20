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
    @objc var name = ""
    @objc var email = ""
    @objc var  image = ""
    @objc var user_type = ""
    @objc var contact_no = ""
    @objc var about_description = ""
    @objc var isEmailVerify = ""
    @objc var location = ""
    @objc var member_since = ""
    @objc var total_bookmark = 0
    @objc var total_friends = 0
    @objc var  total_reviews = 0
    @objc var type_selection = ""
    @objc var address = ""
     @objc var fax = ""
    @objc var total_business = ""
    
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
         self.email = dic["email"] as? String ?? ""
        self.first_name = dic["first_name"] as? String ?? ""
        self.last_name = dic["last_name"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.image = dic["image"] as? String ?? ""
        self.user_type = dic["user_type"] as? String ?? ""
        self.contact_no = dic["contact_no"] as? String ?? ""
        self.about_description = dic["about_description"] as? String ?? ""
        self.isEmailVerify = dic["isEmailVerify"] as? String ?? ""
        self.location = dic["location"] as? String ?? ""
        self.member_since = dic["member_since"] as? String ?? ""
        self.total_bookmark = dic["total_bookmark"] as? Int ?? 0
        self.total_friends = dic["total_friends"] as? Int ?? 0
        self.total_reviews = dic["total_reviews"] as? Int ?? 0
         self.type_selection = dic["type_selection"] as? String ?? ""
         self.address = dic["address"] as? String ?? ""
        self.total_business = dic["total_business"] as? String ?? ""
        self.fax = dic["fax"] as? String ?? ""
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


class UserLoginData {
    @objc var user_id = ""
    @objc var first_name = ""
    @objc var last_name = ""
    @objc var name = ""
    @objc var email = ""
    @objc var  image = ""
    @objc var user_type = ""
    @objc var phone = ""
    @objc var about_description = ""
    @objc var isEmailVerify = ""
    @objc var location = ""
    @objc var member_since = ""
    @objc var total_bookmark = 0
    @objc var total_friends = 0
    @objc var  total_reviews = 0
    @objc var type_selection = ""
    @objc var address = ""
    @objc var fax = ""
    @objc var total_business = ""
    
    required init(dic: [String:Any]) {
        self.user_id = dic["user_id"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.first_name = dic["first_name"] as? String ?? ""
        self.last_name = dic["last_name"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.image = dic["image"] as? String ?? ""
        self.user_type = dic["user_type"] as? String ?? ""
        self.phone = dic["phone"] as? String ?? ""
        
        self.about_description = dic["about_description"] as? String ?? ""
        self.isEmailVerify = dic["isEmailVerify"] as? String ?? ""
        self.location = dic["location"] as? String ?? ""
        self.member_since = dic["member_since"] as? String ?? ""
        self.total_bookmark = dic["total_bookmark"] as? Int ?? 0
        self.total_friends = dic["total_friends"] as? Int ?? 0
        self.total_reviews = dic["total_reviews"] as? Int ?? 0
        self.type_selection = dic["type_selection"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.total_business = dic["total_business"] as? String ?? ""
        self.fax = dic["fax"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.phone, forKey: "phone")
        dictionary.setValue(self.about_description, forKey: "about_description")
        dictionary.setValue(self.isEmailVerify, forKey: "isEmailVerify")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.member_since, forKey: "member_since")
        dictionary.setValue(self.total_bookmark, forKey: "total_bookmark")
        dictionary.setValue(self.total_friends, forKey: "total_friends")
        dictionary.setValue(self.total_reviews, forKey: "total_reviews")
        dictionary.setValue(self.type_selection, forKey: "type_selection")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.fax, forKey: "fax")
        dictionary.setValue(self.total_business, forKey: "total_business")
        return dictionary as! [String:Any]
    }
    
}




class Profile {
    var user_id = ""
    var first_name = ""
     var last_name = ""
     var name = ""
     var email = ""
    var  image = ""
     var user_type = ""
     var contact_no = ""
   var about_description = ""
    var isEmailVerify = ""
     var location = ""
     var member_since = ""
     var total_bookmark = 0
     var total_friends = 0
     var  total_reviews = 0
     var type_selection = ""
    var address = ""
     var fax = ""
     var total_business = ""
    
    required init(dic: [String:Any]) {
        self.user_id = dic["user_id"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.first_name = dic["first_name"] as? String ?? ""
        self.last_name = dic["last_name"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.image = dic["image"] as? String ?? ""
        self.user_type = dic["user_type"] as? String ?? ""
        self.contact_no = dic["contact_no"] as? String ?? ""
        self.about_description = dic["about_description"] as? String ?? ""
        self.isEmailVerify = dic["isEmailVerify"] as? String ?? ""
        self.location = dic["location"] as? String ?? ""
        self.member_since = dic["member_since"] as? String ?? ""
        self.total_bookmark = dic["total_bookmark"] as? Int ?? 0
        self.total_friends = dic["total_friends"] as? Int ?? 0
        self.total_reviews = dic["total_reviews"] as? Int ?? 0
        self.type_selection = dic["type_selection"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.total_business = dic["total_business"] as? String ?? ""
        self.fax = dic["fax"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.user_type, forKey: "user_type")
        dictionary.setValue(self.contact_no, forKey: "contact_no")
        dictionary.setValue(self.about_description, forKey: "about_description")
        dictionary.setValue(self.isEmailVerify, forKey: "isEmailVerify")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.member_since, forKey: "member_since")
        dictionary.setValue(self.total_bookmark, forKey: "total_bookmark")
        dictionary.setValue(self.total_friends, forKey: "total_friends")
        dictionary.setValue(self.total_reviews, forKey: "total_reviews")
        dictionary.setValue(self.type_selection, forKey: "type_selection")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.fax, forKey: "fax")
        dictionary.setValue(self.total_business, forKey: "total_business")
        
       
        return dictionary as! [String:Any]
    }
}

class CategoryList:NSObject{
    var id  = ""
    var name = ""
    var image = ""
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        name = dic["name"] as? String ?? ""
        image = dic["image"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

class FavouriteBusinessCls{
    var businessList: [BusinessList] = [BusinessList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        businessList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .business) ).map({BusinessList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class BusinessList {
        var total_reviews : String?
        var average_rating : String?
        var business_id : String?
        var business_name : String?
        var category : String?
        var description : String?
        var image : String?
        var location : String?
        var subcategory : String?
       // var size:CGSize?
        var height:Int?
        var width:Int?
    
        
        required init(dictionary: [String:Any]) {
            total_reviews = dictionary["total_reviews"] as? String
            average_rating = dictionary["average_rating"] as? String
            business_id = dictionary["business_id"] as? String
            business_name = dictionary["business_name"] as? String
            category = dictionary["category"] as? String
            description = dictionary["description"] as? String
            image = dictionary["image"] as? String
            location = dictionary["location"] as? String
            subcategory = dictionary["subcategory"] as? String
            height = dictionary["height"] as? Int
            width = dictionary["width"] as? Int
           
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total_reviews, forKey: "total_reviews")
            dictionary.setValue(self.average_rating, forKey: "average_rating")
            dictionary.setValue(self.business_id, forKey: "business_id")
            dictionary.setValue(self.business_name, forKey: "business_name")
            dictionary.setValue(self.category, forKey: "category")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.subcategory, forKey: "subcategory")
            dictionary.setValue(height, forKey: "height")
            dictionary.setValue(width, forKey: "width")
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



class PostedReviewsCls{
    var reviewList: [ReviewList] = [ReviewList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        reviewList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .review) ).map({ReviewList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class ReviewList {
        var review_id : String?
        var average_rating : String?
        var business_id : String?
        var business_name : String?
        var category : String?
        var review_description : String?
        var image : String?
        var location : String?
        var subcategory : String?
        var posted_date : String?
        var total_reviews : String?
        var cool : String?
        var funny : String?
        var usefull : String?
        var is_replied:String?
        var rating:String?
        var reviewer_id:String?
        var reviewer_image:String?
        var reviewer_name:String?
        var merchant_reply_message:String?
        var is_active:String?
        var is_approved:String?
        
        required init(dictionary: [String:Any]) {
            review_id = dictionary["review_id"] as? String
            average_rating = dictionary["average_rating"] as? String
            business_id = dictionary["business_id"] as? String
            business_name = dictionary["business_name"] as? String
            category = dictionary["category"] as? String
            review_description = dictionary["review_description"] as? String
            image = dictionary["image"] as? String
            location = dictionary["location"] as? String
            subcategory = dictionary["subcategory"] as? String
            posted_date = dictionary["posted_date"] as? String
            total_reviews = dictionary["total_reviews"] as? String
            cool = dictionary["cool"] as? String
            funny = dictionary["funny"] as? String
            usefull = dictionary["usefull"] as? String
            is_replied = dictionary["is_replied"] as? String
            rating = dictionary["rating"] as? String
            reviewer_id = dictionary["reviewer_id"] as? String
            reviewer_image = dictionary["reviewer_image"] as? String
            reviewer_name = dictionary["reviewer_name"] as? String
            merchant_reply_message = dictionary["merchant_reply_message"] as? String
            is_active = dictionary["is_active"] as? String
            is_approved = dictionary["is_approved"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.review_id, forKey: "review_id")
            dictionary.setValue(self.average_rating, forKey: "average_rating")
            dictionary.setValue(self.business_id, forKey: "business_id")
            dictionary.setValue(self.business_name, forKey: "business_name")
            dictionary.setValue(self.category, forKey: "category")
            dictionary.setValue(self.review_description, forKey: "review_description")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.subcategory, forKey: "subcategory")
           dictionary.setValue(self.posted_date, forKey: "posted_date")
            dictionary.setValue(self.total_reviews, forKey: "total_reviews")
            dictionary.setValue(self.cool, forKey: "cool")
            dictionary.setValue(self.funny, forKey: "funny")
            dictionary.setValue(self.usefull, forKey: "usefull")
            dictionary.setValue(self.is_replied, forKey: "is_replied")
            dictionary.setValue(self.rating, forKey: "rating")
            dictionary.setValue(self.reviewer_id, forKey: "reviewer_id")
            dictionary.setValue(self.reviewer_image, forKey: "reviewer_image")
             dictionary.setValue(self.reviewer_name, forKey: "reviewer_name")
            dictionary.setValue(self.merchant_reply_message, forKey: "merchant_reply_message")
            dictionary.setValue(self.is_active, forKey: "is_active")
            dictionary.setValue(self.is_approved, forKey: "is_approved")
            
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

class
Operating_Hours{
    var mon: String?
    var tue: String?
    var wed: String?
    var thu: String?
    var fri: String?
    var sat: String?
    var sun: String?
    var start_time : String?
    var end_time : String?
    
    required init(dictionary: [String:Any]) {
        mon = dictionary["mon"]as? String
        tue = dictionary["tue"]as? String
        wed = dictionary["wed"]as? String
        thu = dictionary["thu"]as? String
        fri = dictionary["fri"]as? String
        sat = dictionary["sat"]as? String
        sun = dictionary["sun"]as? String
        start_time = dictionary["start_time"]as? String
        end_time = dictionary["end_time"]as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.mon, forKey: "mon")
        dictionary.setValue(self.tue, forKey: "tue")
        dictionary.setValue(self.wed, forKey: "wed")
        dictionary.setValue(self.thu, forKey: "thu")
        dictionary.setValue(self.fri, forKey: "fri")
        dictionary.setValue(self.sat, forKey: "sat")
        dictionary.setValue(self.sun, forKey: "sun")
        dictionary.setValue(self.start_time, forKey: "start_time")
        dictionary.setValue(self.end_time, forKey: "end_time")
         return dictionary as! [String:Any]
    }
}



class BusinessDetail {
    var add_info : String = ""
    var address : String = ""
    var addressLat : String = ""
    var addressLng : String = ""
    var category_name : String? = ""
    var description : String = ""
    var detail_url : String = ""
    var facility : String = ""
    var images : String = ""
    var merchant_contact_no : String = ""
    var merchant_email : String = ""
    var merchant_fax : String = ""
    var merchant_id : String = ""
    var merchant_name:String = ""
    var name:String = ""
    var operating_hours:String = ""
    var sub_category_name:String = ""
    var url:String = ""
    var isFav:String = ""
    var desc:String = ""
     var ispaid:String = ""
    var fb_link:String = ""
    var tw_link:String = ""
    var gp_link:String = ""
    var isAddReview:String = ""
    var inst_link:String = ""
    
    
    required init(dictionary: [String:Any]) {
        add_info = dictionary["add_info"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        addressLat = dictionary["addressLat"] as? String ?? ""
        addressLng = dictionary["addressLng"] as? String ?? ""
        category_name = dictionary["category_name"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        detail_url = dictionary["detail_url"] as? String ?? ""
        facility = dictionary["facility"] as? String ?? ""
        images = dictionary["images"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        merchant_contact_no = dictionary["merchant_contact_no"] as? String ?? ""
        merchant_email = dictionary["merchant_email"] as? String ?? ""
        merchant_fax = dictionary["merchant_fax"] as? String ?? ""
        merchant_id = dictionary["merchant_id"] as? String ?? ""
        merchant_name = dictionary["merchant_name"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        operating_hours = dictionary["operating_hours"] as? String ?? ""
        sub_category_name = dictionary["sub_category_name"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
        isFav = dictionary["isFav"] as? String ?? ""
        desc = dictionary["description"] as? String ?? ""
        ispaid = dictionary["ispaid"] as? String ?? ""
        
        fb_link = dictionary["fb_link"] as? String ?? ""
        tw_link = dictionary["tw_link"] as? String ?? ""
        gp_link = dictionary["gp_link"] as? String ?? ""
        isAddReview = dictionary["isAddReview"] as? String ?? ""
        inst_link = dictionary["inst_link"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.add_info, forKey: "add_info")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.addressLat, forKey: "addressLat")
        dictionary.setValue(self.addressLng, forKey: "addressLng")
        dictionary.setValue(self.category_name, forKey: "category_name")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.detail_url, forKey: "detail_url")
        dictionary.setValue(self.facility, forKey: "facility")
        dictionary.setValue(self.merchant_fax, forKey: "merchant_fax")
        dictionary.setValue(self.images, forKey: "images")
        dictionary.setValue(self.merchant_contact_no, forKey: "merchant_contact_no")
        dictionary.setValue(self.merchant_email, forKey: "merchant_email")
        dictionary.setValue(self.merchant_id, forKey: "merchant_id")
        dictionary.setValue(self.merchant_name, forKey: "merchant_name")
        dictionary.setValue(self.operating_hours, forKey: "operating_hours")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.sub_category_name, forKey: "sub_category_name")
        dictionary.setValue(self.url, forKey: "isFav")
        dictionary.setValue(self.isFav, forKey: "url")
        dictionary.setValue(self.desc, forKey: "description")
        dictionary.setValue(self.ispaid, forKey: "ispaid")
        dictionary.setValue(self.isAddReview, forKey: "isAddReview")
        dictionary.setValue(self.fb_link, forKey: "fb_link")
        dictionary.setValue(self.tw_link, forKey: "tw_link")
        dictionary.setValue(self.gp_link, forKey: "gp_link")
        dictionary.setValue(self.inst_link, forKey: "inst_link")
        return dictionary as! [String:Any]
    }
}

class PostedAdvertiseCls{
    var advertiseList: [AdvertiseList] = [AdvertiseList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        advertiseList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .advertisements) ).map({AdvertiseList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class AdvertiseList {
        
        var id : String?
        var target : String?
        var start : String?
        var end : String?
        var page : String?
        var status : String?
        var image : String?
        var rejected_reason : String?
        
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String
            target = dictionary["target"] as? String
            start = dictionary["start"] as? String
            end = dictionary["end"] as? String
            page = dictionary["page"] as? String
            status = dictionary["status"] as? String
            image = dictionary["image"] as? String
            rejected_reason = dictionary["rejected_reason"] as? String
           
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.target, forKey: "target")
            dictionary.setValue(self.start, forKey: "start")
            dictionary.setValue(self.end, forKey: "end")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.rejected_reason, forKey: "rejected_reason")
            
            
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


class PaymentHistoryCls{
    var payments: [PaymentList] = [PaymentList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        payments = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .payments) ).map({PaymentList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class PaymentList {
        
        var id : String?
        var txn_id : String?
        var payment_date : String?
        var price : String?
        var plan_name : String?
        
        
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String
            txn_id = dictionary["txn_id"] as? String
            payment_date = dictionary["payment_date"] as? String
            price = dictionary["price"] as? String
            plan_name = dictionary["plan_name"] as? String
           
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.txn_id, forKey: "txn_id")
            dictionary.setValue(self.payment_date, forKey: "payment_date")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(self.plan_name, forKey: "plan_name")
           
            
            
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


class MemberShipList:NSObject{
    var amount  = ""
    var desc = ""
    var membership_id = ""
    var plan_name = ""
    var duration = ""
    var isperchased = ""
    var renew_date = ""
    var identifier = ""
    
    init(dic:[String:Any]) {
        super.init()
        amount = dic["amount"] as? String ?? ""
        desc = dic["description"] as? String ?? ""
        membership_id = dic["membership_id"] as? String ?? ""
        plan_name = dic["plan_name"] as? String ?? ""
        duration = dic["duration"] as? String ?? ""
        isperchased = dic["isperchased"] as? String ?? ""
        renew_date = dic["renew_date"] as? String ?? ""
        identifier = dic["identifier"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

class MessageList {
    var id : String = ""
    var user_id : String = ""
    var user_name : String = ""
    var user_profile : String = ""
    var date : String = ""
    var message : String = ""
    
    
    required init(dictionary: [String:Any]) {
        id = dictionary["id"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
        user_name = dictionary["user_name"] as? String ?? ""
        user_profile = dictionary["user_profile"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
        message = dictionary["message"] as? String ?? ""
        
    }
   func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.user_name, forKey: "user_name")
        dictionary.setValue(self.user_profile, forKey: "user_profile")
        dictionary.setValue(self.date, forKey: "date")
        dictionary.setValue(self.message, forKey: "message")
        
        return dictionary as! [String:Any]
    }
    
}


class CommentCls{
    var reviewsList: [ReviewList] = [ReviewList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        reviewsList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .review) ).map({ReviewList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class ReviewList {
        
        var review_id : String?
        var user_name : String?
        var user_image : String?
        var rating : String?
        var review_description : String?
        var posted_date : String?
        var reported : String?
        var comment : String?
        
        
        
        required init(dictionary: [String:Any]) {
            review_id = dictionary["review_id"] as? String
            user_name = dictionary["user_name"] as? String
            user_image = dictionary["user_image"] as? String
            rating = dictionary["rating"] as? String
            review_description = dictionary["review_description"] as? String
            posted_date = dictionary["posted_date"] as? String
            reported = dictionary["reported"] as? String
            comment = dictionary["comment"] as? String
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.review_id, forKey: "review_id")
            dictionary.setValue(self.user_name, forKey: "user_name")
            dictionary.setValue(self.user_image, forKey: "user_image")
            dictionary.setValue(self.rating, forKey: "rating")
            dictionary.setValue(self.review_description, forKey: "review_description")
            dictionary.setValue(self.posted_date, forKey: "posted_date")
            dictionary.setValue(self.reported, forKey: "reported")
            dictionary.setValue(self.comment, forKey: "comment")
            
            
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

class Message {
    var id : String = ""
    var user_name : String = ""
    var user_image : String = ""
    var message : String = ""
    var date : String = ""
   
    
    required init(dictionary: [String:Any]) {
        id = dictionary["id"] as? String ?? ""
        user_name = dictionary["user_name"] as? String ?? ""
        user_image = dictionary["user_image"] as? String ?? ""
        message = dictionary["message"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
    }
    public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.user_name, forKey: "user_name")
        dictionary.setValue(self.user_image, forKey: "user_image")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.date, forKey: "date")
        
        return dictionary as! [String:Any]
    }
    
}


class MessageCls{
    var msgList: [MessagesList] = [MessagesList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        msgList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .messages) ).map({MessagesList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class MessagesList {
        
        var date : String?
        var message : String?
        var id : String?
        var user_name : String?
        var user_image : String?
        var user_profile :String?
        var user_id :String?
        
       required init(dictionary: [String:Any]) {
            date = dictionary["date"] as? String
            message = dictionary["message"] as? String
            id = dictionary["id"] as? String
            user_name = dictionary["user_name"] as? String
            user_image = dictionary["user_image"] as? String
            user_profile = dictionary["user_profile"] as? String
           user_id = dictionary["user_id"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.date, forKey: "date")
            dictionary.setValue(self.message, forKey: "message")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.user_name, forKey: "user_name")
            dictionary.setValue(self.user_image, forKey: "user_image")
            dictionary.setValue(self.user_profile, forKey: "user_profile")
            dictionary.setValue(self.user_id, forKey: "user_id")
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

class RelatedBusinessCls{
    var businessList: [RelatedBusinessList] = [RelatedBusinessList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        businessList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .related_business) ).map({RelatedBusinessList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class RelatedBusinessList {
        var total_reviews : String?
        var average_rating : String?
        var business_id : String?
        var business_name : String?
        var category : String?
        var description : String?
        var image : String?
        var location : String?
        var subcategory : String?
        // var size:CGSize?
        var height:Int?
        var width:Int?
        
        required init(dictionary: [String:Any]) {
            total_reviews = dictionary["total_reviews"] as? String
            average_rating = dictionary["averageReview"] as? String
            business_id = dictionary["business_id"] as? String
            business_name = dictionary["business_name"] as? String
            category = dictionary["category"] as? String
            description = dictionary["description"] as? String
            image = dictionary["businessImage"] as? String
            location = dictionary["location"] as? String
            subcategory = dictionary["subcategory"] as? String
            height = dictionary["height"] as? Int
            width = dictionary["width"] as? Int
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total_reviews, forKey: "total_reviews")
            dictionary.setValue(self.average_rating, forKey: "averageReview")
            dictionary.setValue(self.business_id, forKey: "business_id")
            dictionary.setValue(self.business_name, forKey: "business_name")
            dictionary.setValue(self.category, forKey: "category")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.image, forKey: "businessImage")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.subcategory, forKey: "subcategory")
            dictionary.setValue(height, forKey: "height")
            dictionary.setValue(width, forKey: "width")
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
class NotificationCls{
    var notificationList: [NotificationList] = [NotificationList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .list) ).map({NotificationList(dictionary: $0 as! [String:Any])})
       pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class NotificationList {
        var id : String?
        var text : String?
        var date :String?
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String
            text = dictionary["text"] as? String
            date = dictionary["date"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.text, forKey: "text")
            dictionary.setValue(self.date, forKey: "date")
            return dictionary as! [String:Any]
        }
        
    }
    
    class Pagination {
        var total : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total = dictionary["total"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total, forKey: "total")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
    
}

class SearchBusinessCls{
    var businessList: [SearchBusinessList] = [SearchBusinessList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        businessList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .business) ).map({SearchBusinessList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
class SearchBusinessList {
    
    var average_rating : String?
    var business_id : String?
    var business_name : String?
    var category : String?
    var desc : String?
    var image : String?
    var location : String?
    var subcategory : String?
    var total_reviews : String?
    
    
    init(dictionary:[String:Any]) {
        average_rating = dictionary["average_rating"] as? String
        business_id = dictionary["business_id"] as? String
        business_name = dictionary["business_name"] as? String
        category = dictionary["category"] as? String
        desc = dictionary["description"] as? String
        image = dictionary["image"] as? String
        location = dictionary["location"] as? String
        subcategory = dictionary["subcategory"] as? String
        total_reviews = dictionary["total_reviews"] as? String
        
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.average_rating, forKey: "average_rating")
        dictionary.setValue(self.business_id, forKey: "business_id")
        dictionary.setValue(self.business_name, forKey: "business_name")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.desc, forKey: "description")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.subcategory, forKey: "subcategory")
        dictionary.setValue(self.total_reviews, forKey: "total_reviews")
        
        
        
        return dictionary as! [String:Any]
    }
    
}
    
    class Pagination {
        var total : Int = 0
        var total_pages : Int = 0
        var current_page : Int = 0
        
        required init(dictionary: [String:Any]) {
            total = dictionary["total"] as? Int ?? 0
            total_pages = dictionary["total_pages"] as? Int ?? 0
            current_page = dictionary["current_page"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.total, forKey: "total")
            dictionary.setValue(self.total_pages, forKey: "total_pages")
            dictionary.setValue(self.current_page, forKey: "current_page")
            return dictionary as! [String:Any]
        }
        
    }
}
