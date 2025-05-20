//
//  DataManager.swift
//  Talabtech
//
//  Created by NCT 24 on 19/05/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class User: NSObject {
    
    private let keys = ["user_id","first_name","last_name","user_name","user_type","email_id","country_code_id","profile_img","com_phonenum","company_address","company_name","verification_doc"/*"mobileverify","city_shipping",
         "state_shipping","postal_code","address"*/]
    
    @objc var user_id = ""
    @objc var firstName = ""
    @objc var lastName = ""
    @objc var username = ""
    @objc var email_address = ""
    @objc var user_type = ""
    @objc var store_name = ""
    @objc var gender = ""
    @objc var address = ""
    @objc var no_of_product_sold = ""
    @objc var userProfileImage = ""
    @objc var addresslatitude = ""
    @objc var addresslongitude = ""
    @objc var contact_no = ""
    @objc var selected_radius = ""
    @objc var bank_acc_holder_name = ""
    @objc var bank_acc_number = ""
    @objc var bank_address = ""
    @objc var bank_ifsc_code = ""
    @objc var bank_name = ""
    @objc var desc = ""
    @objc var email = ""
    @objc var profile_img_path = ""
    @objc var radius_id = ""
    @objc var profile_img = ""
    @objc var website = ""
    @objc var currency = "$"
    
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        self.user_id = dic["user_id"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.email_address = dic["email_address"] as? String ?? ""
        self.user_type = dic["user_type"] as? String ?? ""
        self.store_name = dic["store_name"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.no_of_product_sold = dic["no_of_product_sold"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.userProfileImage = dic["userProfileImage"] as? String ?? ""
        self.addresslatitude = dic["addresslatitude"] as? String ?? ""
        self.addresslongitude = dic["addresslongitude"] as? String ?? ""
        self.contact_no = dic["contact_no"] as? String ?? ""
        self.selected_radius = dic["selected_radius"] as? String ?? ""
        
        self.bank_acc_holder_name = dic["bank_acc_holder_name"] as? String ?? ""
        self.bank_acc_number = dic["bank_acc_number"] as? String ?? ""
        self.bank_address = dic["bank_address"] as? String ?? ""
        self.bank_ifsc_code = dic["bank_ifsc_code"] as? String ?? ""
        self.bank_name = dic["bank_name"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.desc = dic["description"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.profile_img_path = dic["profile_img_path"] as? String ?? ""
        self.radius_id = dic["radius_id"] as? String ?? ""
        self.profile_img = dic["profile_img"] as? String ?? ""
        self.website = dic["website"] as? String ?? ""
        self.currency = dic["currency"] as? String ?? "$"
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
    var user_id : String = ""
    var email_address : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var user_type : String = ""
    
    required init(dictionary: [String:Any]) {
        user_id = dictionary["user_id"] as? String ?? ""
        email_address = dictionary["email_address"] as? String ?? ""
        firstName = dictionary["firstName"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        user_type = dictionary["user_type"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.email_address, forKey: "email_address")
        dictionary.setValue(self.firstName, forKey: "firstName")
        dictionary.setValue(self.user_type, forKey: "user_type")
        return dictionary as! [String:Any]
    }
    
}




class Profile {
    var userName : String = ""
    var userProfileImage : String = ""
    var userEmail : String = ""
    var userAddress : String = ""
    var addresslatitude : String? = ""
    var addresslongitude : String = ""
    var contact_no : String = ""
    var gender : String = ""
    var selected_radius : String = ""
    
    required init(dictionary: [String:Any]) {
        userName = dictionary["userName"] as? String ?? ""
        userProfileImage = dictionary["userProfileImage"] as? String ?? ""
        userEmail = dictionary["userEmail"] as? String ?? ""
        userAddress = dictionary["userAddress"] as? String ?? ""
        addresslatitude = dictionary["addresslatitude"] as? String ?? ""
        addresslongitude = dictionary["addresslongitude"] as? String ?? ""
        contact_no = dictionary["contact_no"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
        selected_radius = dictionary["selected_radius"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.userName, forKey: "userName")
        dictionary.setValue(self.userProfileImage, forKey: "userProfileImage")
        dictionary.setValue(self.userEmail, forKey: "userEmail")
        dictionary.setValue(self.userAddress, forKey: "userAddress")
        dictionary.setValue(self.addresslatitude, forKey: "addresslatitude")
        dictionary.setValue(self.addresslongitude, forKey: "addresslongitude")
        dictionary.setValue(self.contact_no, forKey: "contact_no")
        dictionary.setValue(self.gender, forKey: "gender")
        dictionary.setValue(self.selected_radius, forKey: "selected_radius")
        return dictionary as! [String:Any]
    }
}

class CategoryList:NSObject{
    var id  = ""
    var categoryName = ""
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        categoryName = dic["categoryName"] as? String ?? ""
        
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
        var average_rating : Int?
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
            average_rating = dictionary["average_rating"] as? Int
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
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        payments = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({PaymentList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class PaymentList {
        
        var payment_id : String?
        var transaction_id : String?
        var payment_amount : String?
        var payment_date : String?
        var deal_title : String?
        var categoryName : String?
        var subcategoryName : String?
        var merchantName : String?
        
        
        
        required init(dictionary: [String:Any]) {
            payment_id = dictionary["payment_id"] as? String
            transaction_id = dictionary["transaction_id"] as? String
            payment_amount = dictionary["payment_amount"] as? String
            payment_date = dictionary["payment_date"] as? String
            deal_title = dictionary["deal_title"] as? String
            categoryName = dictionary["categoryName"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            merchantName = dictionary["merchantName"] as? String
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.payment_id, forKey: "payment_id")
            dictionary.setValue(self.transaction_id, forKey: "transaction_id")
            dictionary.setValue(self.payment_amount, forKey: "payment_amount")
            dictionary.setValue(self.payment_date, forKey: "payment_date")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.merchantName, forKey: "merchantName")
            
            
            
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
    
    init(dic:[String:Any]) {
        super.init()
        amount = dic["amount"] as? String ?? ""
        desc = dic["description"] as? String ?? ""
        membership_id = dic["membership_id"] as? String ?? ""
        plan_name = dic["plan_name"] as? String ?? ""
        duration = dic["duration"] as? String ?? ""
        isperchased = dic["isperchased"] as? String ?? ""
        renew_date = dic["renew_date"] as? String ?? ""
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

class DealCls{
    var notificationList: [DealList] = [DealList]()
    var TotalPages : Int = 0
    var TotalRecords : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .results) ).map({DealList(dictionary: $0 as! [String:Any])})
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class DealList {
        var MerchantName : String?
        var categoryName : String?
        var deal_title :String?
        var recently_view_id : String?
        var subcategoryName :String?
        var dealImages: [DealImages] = [DealImages]()
        var dealLocations: [DealLocations] = [DealLocations]()
        var dealOptions: [DealLocations] = [DealLocations]()
        required init(dictionary: [String:Any]) {
            MerchantName = dictionary["MerchantName"] as? String
            categoryName = dictionary["categoryName"] as? String
            deal_title = dictionary["deal_title"] as? String
            recently_view_id = dictionary["recently_view_id"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            //   dealImages = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .results) ).map({DealImages(dictionary: $0 as! [String:Any])})
            //dealLocations = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .results) ).map({DealLocations(dictionary: $0 as! [String:Any])})
            //  dealOptions = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .results) ).map({DealOptions(dictionary: $0 as! [String:Any])})
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.MerchantName, forKey: "MerchantName")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.recently_view_id, forKey: "recently_view_id")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            return dictionary as! [String:Any]
        }
        
        class DealImages {
            
        }
        
        class DealLocations {
            
        }
        
        class DealOptions {
            
        }
        
        
    }
    
    
}



class FolowMechantCls{
    var merchantList: [MerchantList] = [MerchantList]()
    var TotalPages : Int = 0
    var TotalRecords : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        merchantList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({MerchantList(dictionary: $0 as! [String:Any])})
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class MerchantList {
        var following_id : String?
        var merchantImage : String?
        var merchantName :String?
        var receive_notification : String?
        var start_foolowing_on :String?
        var merchant_id :String?
        
        
        required init(dictionary: [String:Any]) {
            following_id = dictionary["following_id"] as? String
            merchantImage = dictionary["merchantImage"] as? String
            merchantName = dictionary["merchantName"] as? String
            receive_notification = dictionary["receive_notification"] as? String
            start_foolowing_on = dictionary["start_foolowing_on"] as? String
            merchant_id = dictionary["merchant_id"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.following_id, forKey: "following_id")
            dictionary.setValue(self.merchantImage, forKey: "merchantImage")
            dictionary.setValue(self.merchantName, forKey: "merchantName")
            dictionary.setValue(self.receive_notification, forKey: "receive_notification")
            dictionary.setValue(self.start_foolowing_on, forKey: "start_foolowing_on")
            dictionary.setValue(self.merchant_id, forKey: "merchant_id")
            return dictionary as! [String:Any]
        }
        
        
    }
    
    
}


class FavoriteDealCls {
    var dealList: [FavDealList] = [FavDealList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({FavDealList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
}

class FavDealList {
    
    var favorite_id : String?
    var deal_title : String?
    var categoryName : String?
    var subcategoryName : String?
    var MerchantName : String?
    var dealImages  : String?
    var recently_view_id  : String?
    
    
    required init(dictionary: [String:Any]) {
        favorite_id = dictionary["favorite_id"] as? String
        deal_title = dictionary["deal_title"] as? String
        categoryName = dictionary["categoryName"] as? String
        subcategoryName = dictionary["subcategoryName"] as? String
        MerchantName = dictionary["MerchantName"] as? String
        dealImages = dictionary["dealImages"] as? String
        recently_view_id = dictionary["recently_view_id"] as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.favorite_id, forKey: "favorite_id")
        dictionary.setValue(self.deal_title, forKey: "deal_title")
        dictionary.setValue(self.categoryName, forKey: "categoryName")
        dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
        dictionary.setValue(self.MerchantName, forKey: "MerchantName")
        dictionary.setValue(self.dealImages, forKey: "dealImages")
        dictionary.setValue(self.recently_view_id, forKey: "recently_view_id")
        
        return dictionary as! [String:Any]
    }
    
}


class DealImages {
    var dealImage : String?
    
    required init(dictionary: [String:Any]) {
        dealImage = dictionary["dealImage"] as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.dealImage, forKey: "dealImage")
        
        return dictionary as! [String:Any]
        
    }
    
}



class ReviewsCls{
    var reviews: [ReviewList] = [ReviewList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        reviews = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({ReviewList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class ReviewList {
        
        var review_id : String?
        var deal_title : String?
        var categoryName : String?
        var subcategoryName : String?
        var MerchantName : String?
        var review_description : String?
        var review_rating : String?
        var reviewPostedOn : String?
         var merchant_profile : String?
        
        required init(dictionary: [String:Any]) {
            review_id = dictionary["review_id"] as? String
            deal_title = dictionary["deal_title"] as? String
            categoryName = dictionary["categoryName"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            MerchantName = dictionary["MerchantName"] as? String
            review_description = dictionary["review_description"] as? String
           reviewPostedOn = dictionary["reviewPostedOn"] as? String
             review_rating = dictionary["review_rating"] as? String
            merchant_profile = dictionary["merchant_profile"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.review_id, forKey: "review_id")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.MerchantName, forKey: "MerchantName")
            dictionary.setValue(self.review_description, forKey: "review_description")
            dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
            dictionary.setValue(self.review_rating, forKey: "review_rating")
            dictionary.setValue(self.merchant_profile, forKey: "merchant_profile")
           return dictionary as! [String:Any]
        }
        
    }
    
}


class DealList {
    var merchantName :String?
    var categoryName :String?
    var deal_discount_price :String?
    var deal_option_title :String?
    var deal_price :String?
    var deal_title :String?
    var is_gift :String?
    var merchantContact :String?
    var merchantEmail :String?
    var purchase_id :String?
    var purchased_date :String?
    var subcategoryName :String?
    
    
    required init(dictionary: [String:Any]) {
        merchantName = dictionary["merchantName"] as? String
        categoryName = dictionary["categoryName"] as? String
        deal_discount_price = dictionary["deal_discount_price"] as? String
        deal_option_title = dictionary["deal_option_title"] as? String
        deal_price = dictionary["deal_price"] as? String
        
        deal_title = dictionary["deal_title"] as? String
        is_gift = dictionary["is_gift"] as? String
        merchantContact = dictionary["merchantContact"] as? String
        merchantEmail = dictionary["merchantEmail"] as? String
        purchase_id = dictionary["purchase_id"] as? String
        purchased_date = dictionary["purchased_date"] as? String
        subcategoryName = dictionary["subcategoryName"] as? String
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.merchantName, forKey: "merchantName")
        dictionary.setValue(self.categoryName, forKey: "categoryName")
        dictionary.setValue(self.deal_discount_price, forKey: "deal_discount_price")
        dictionary.setValue(self.deal_option_title, forKey: "deal_option_title")
        dictionary.setValue(self.deal_price, forKey: "deal_price")
        
        dictionary.setValue(self.deal_title, forKey: "deal_title")
        dictionary.setValue(self.is_gift, forKey: "is_gift")
        dictionary.setValue(self.merchantContact, forKey: "merchantContact")
        dictionary.setValue(self.merchantEmail, forKey: "merchantEmail")
        dictionary.setValue(self.purchase_id, forKey: "purchase_id")
        dictionary.setValue(self.purchased_date, forKey: "purchased_date")
        dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
        return dictionary as! [String:Any]
    }
    
    
}

class PurchasedDealCls{
    var dealList: [DealList] = [DealList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({DealList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
class DealList {
    var MerchantName :String?
    var categoryName :String?
    var deal_discount_price :String?
    var deal_option_title :String?
    var deal_price :String?
    var deal_title :String?
    var is_gift :String?
    var merchantContact :String?
    var merchantEmail :String?
    var purchase_id :String?
    var purchased_date :String?
    var subcategoryName :String?
    var deal_id:String?
    
    
    required init(dictionary: [String:Any]) {
        MerchantName = dictionary["MerchantName"] as? String
        categoryName = dictionary["categoryName"] as? String
        deal_discount_price = dictionary["deal_discount_price"] as? String
        deal_option_title = dictionary["deal_option_title"] as? String
        deal_price = dictionary["deal_price"] as? String
        
        deal_title = dictionary["deal_title"] as? String
        is_gift = dictionary["is_gift"] as? String
        merchantContact = dictionary["merchantContact"] as? String
        merchantEmail = dictionary["merchantEmail"] as? String
        purchase_id = dictionary["purchase_id"] as? String
        purchased_date = dictionary["purchased_date"] as? String
        subcategoryName = dictionary["subcategoryName"] as? String
         deal_id = dictionary["deal_id"] as? String
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.MerchantName, forKey: "MerchantName")
        dictionary.setValue(self.categoryName, forKey: "categoryName")
        dictionary.setValue(self.deal_discount_price, forKey: "deal_discount_price")
        dictionary.setValue(self.deal_option_title, forKey: "deal_option_title")
        dictionary.setValue(self.deal_price, forKey: "deal_price")
        
        dictionary.setValue(self.deal_title, forKey: "deal_title")
        dictionary.setValue(self.is_gift, forKey: "is_gift")
        dictionary.setValue(self.merchantContact, forKey: "merchantContact")
        dictionary.setValue(self.merchantEmail, forKey: "merchantEmail")
        dictionary.setValue(self.purchase_id, forKey: "purchase_id")
        dictionary.setValue(self.purchased_date, forKey: "purchased_date")
        dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
        dictionary.setValue(self.deal_id, forKey: "deal_id")
        return dictionary as! [String:Any]
    }
    
    
}
}


class SubscibedCategoryCls{
    var dealList: [CategoryList] = [CategoryList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({CategoryList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    class CategoryList{
        var categoryName :String?
        var subcategoryName :String?
        var subscribeId :String?
        
        
        required init(dictionary: [String:Any]) {
            categoryName = dictionary["categoryName"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            subscribeId = dictionary["subscribeId"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.subscribeId, forKey: "subscribeId")
            return dictionary as! [String:Any]
        }
        
        
    }
}


class myFollowersCls{
    var following_customers: [CustmerList] = [CustmerList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        following_customers = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["following_customers"] as! [Any]).map({CustmerList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    class CustmerList{
        var customerFirstName :String?
        var customerLastName :String?
        var customerProfileImg :String?
        
        
        required init(dictionary: [String:Any]) {
            customerFirstName = dictionary["customerFirstName"] as? String
            customerLastName = dictionary["customerLastName"] as? String
            customerProfileImg = dictionary["customerProfileImg"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.customerFirstName, forKey: "customerFirstName")
            dictionary.setValue(self.customerLastName, forKey: "customerLastName")
            dictionary.setValue(self.customerProfileImg, forKey: "customerProfileImg")
            return dictionary as! [String:Any]
        }
        
        
    }
}


class NotificationSettings{
     var notificationList: [NotificationList] = [NotificationList]()
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["notification_preferences"] as! [Any]).map({NotificationList(dictionary: $0 as! [String:Any])})
    }
}
class NotificationList {
    var notification_type : String = ""
    var id : String = ""
    var preference_value : String = ""
    var push_or_mail : String = ""
    
    
    required init(dictionary: [String:Any]) {
        notification_type = dictionary["notification_type"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""
        preference_value = dictionary["preference_value"] as? String ?? ""
        push_or_mail = dictionary["push_or_mail"] as? String ?? ""
        
    }
    func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.notification_type, forKey: "notification_type")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.preference_value, forKey: "preference_value")
        dictionary.setValue(self.push_or_mail, forKey: "push_or_mail")
        
        return dictionary as! [String:Any]
    }
    
}

class NotificationCls{
    var notificationList: [Notifications] = [Notifications]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({Notifications(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class Notifications {
        
        var action : String?
        var createdDate : String?
        var deal_id : String?
        var from_user : String?
        var notify_string : String?
        
        
        required init(dictionary: [String:Any]) {
            action = dictionary["action"] as? String
            createdDate = dictionary["createdDate"] as? String
            deal_id = dictionary["deal_id"] as? String
            from_user = dictionary["from_user"] as? String
            notify_string = dictionary["notify_string"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.action, forKey: "action")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.from_user, forKey: "from_user")
            dictionary.setValue(self.notify_string, forKey: "notify_string")
            
            return dictionary as! [String:Any]
        }
        
    }
    
}


class MerchantReviewsCls{
    var merchantReviews: [MerchantReviewList] = [MerchantReviewList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        merchantReviews = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["reviews"] as! [Any]).map({MerchantReviewList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class MerchantReviewList {
        
        var customerFirstName : String?
        var customerLastName : String?
        var customerProfileImg : String?
        var deal_category_id : String?
        var deal_sub_category_id : String?
        var deal_title : String?
        var reviewPostedOn : String?
        var review_description : String?
        var review_rating : String?
       
        
        
        
        required init(dictionary: [String:Any]) {
            customerFirstName = dictionary["customerFirstName"] as? String
            customerLastName = dictionary["customerLastName"] as? String
            customerProfileImg = dictionary["customerProfileImg"] as? String
            deal_category_id = dictionary["deal_category_id"] as? String
            deal_sub_category_id = dictionary["deal_sub_category_id"] as? String
            deal_title = dictionary["deal_title"] as? String
            reviewPostedOn = dictionary["reviewPostedOn"] as? String
            review_description = dictionary["review_description"] as? String
            review_rating = dictionary["review_rating"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.customerFirstName, forKey: "customerFirstName")
            dictionary.setValue(self.customerLastName, forKey: "customerLastName")
            dictionary.setValue(self.customerProfileImg, forKey: "customerProfileImg")
            dictionary.setValue(self.deal_category_id, forKey: "deal_category_id")
            dictionary.setValue(self.deal_sub_category_id, forKey: "deal_sub_category_id")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
             dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
            dictionary.setValue(self.review_description, forKey: "review_description")
           
            return dictionary as! [String:Any]
        }
        
    }
    
}



//class MyDealsCls{
//    var dealList: [MyDealList] = [MyDealList]()
//    var total : Int = 0
//    var total_page : Int = 0
//    var current_page : Int = 0
//
//    required init(dictionary: [String:Any]) {
//        print(dictionary)
//
//        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["deals"] as! [Any]).map({MyDealList(dictionary: $0 as! [String:Any])})
//        total = dictionary["total"] as? Int ?? 0
//        total_page = dictionary["total_page"] as? Int ?? 0
//        current_page = dictionary["current_page"] as? Int ?? 0
//    }
//
//
//    class MyDealList {
//        
//        var categoryName : String?
//        var deal_id : String?
//        var customerProfileImg : String?
//        var deal_category_id : String?
//        var deal_sub_category_id : String?
//        var deal_title : String?
//        var reviewPostedOn : String?
//        var review_description : String?
//        var review_rating : String?
//        
//        
//        required init(dictionary: [String:Any]) {
//            customerFirstName = dictionary["customerFirstName"] as? String
//            customerLastName = dictionary["customerLastName"] as? String
//            customerProfileImg = dictionary["customerProfileImg"] as? String
//            deal_category_id = dictionary["deal_category_id"] as? String
//            deal_sub_category_id = dictionary["deal_sub_category_id"] as? String
//            deal_title = dictionary["deal_title"] as? String
//            reviewPostedOn = dictionary["reviewPostedOn"] as? String
//            review_description = dictionary["review_description"] as? String
//            review_rating = dictionary["review_rating"] as? String
//        }
//        
//        func dictionaryRepresentation() -> [String:Any] {
//            let dictionary = NSMutableDictionary()
//            dictionary.setValue(self.customerFirstName, forKey: "customerFirstName")
//            dictionary.setValue(self.customerLastName, forKey: "customerLastName")
//            dictionary.setValue(self.customerProfileImg, forKey: "customerProfileImg")
//            dictionary.setValue(self.deal_category_id, forKey: "deal_category_id")
//            dictionary.setValue(self.deal_sub_category_id, forKey: "deal_sub_category_id")
//            dictionary.setValue(self.deal_title, forKey: "deal_title")
//            dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
//            dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
//            dictionary.setValue(self.review_description, forKey: "review_description")
//            return dictionary as! [String:Any]
//        }
//        
//    }
//    
//}
class SearchResultCls{
    var searchList: [SearchList] = [SearchList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        searchList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({SearchList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class SearchList {
        var locList: [DealLocationList] = [DealLocationList]()
        var optionList: [DealOptionList] = [DealOptionList]()
        var MerchantName : String?
        var categoryName : String?
        var dealImages : String?
        var deal_avg_rating : Int?
        var deal_id : String?
        var deal_title : String?
        var isFavorite : String?
        var subcategoryName : String?
        var deal_distance : String?
        
        
        
        required init(dictionary: [String:Any]) {
            let locList = dictionary["dealLocations"] as? [Any] ?? [Any]()
          self.locList = locList.map({DealLocationList(dictionary: $0 as! [String:Any])})
            optionList = (dictionary["dealOptions"] as! [Any]).map({DealOptionList(dictionary: $0 as! [String:Any])})
            MerchantName = dictionary["MerchantName"] as? String
            categoryName = dictionary["categoryName"] as? String
            dealImages = dictionary["dealImages"] as? String
            deal_avg_rating = dictionary["deal_avg_rating"] as? Int
            deal_id = dictionary["deal_id"] as? String
            deal_title = dictionary["deal_title"] as? String
            isFavorite = dictionary["isFavorite"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            deal_distance = dictionary["deal_distance"] as? String
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.MerchantName, forKey: "MerchantName")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.dealImages, forKey: "dealImages")
            dictionary.setValue(self.deal_avg_rating, forKey: "deal_avg_rating")
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.isFavorite, forKey: "isFavorite")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.deal_distance, forKey: "subcategoryName")
            
            
            return dictionary as! [String:Any]
        }
        
        class DealLocationList {
            
            var deal_location : String?
            var id : String?
            var latitude : String?
            var logitude : String?
             var deal_title : String?
            var deal_id : String?
            
            required init(dictionary: [String:Any]) {
                deal_location = dictionary["deal_location"] as? String
                id = dictionary["id"] as? String
                latitude = dictionary["latitude"] as? String
                logitude = dictionary["logitude"] as? String
                deal_title = dictionary["deal_title"] as? String
                deal_id = dictionary["deal_id"] as? String
                
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.deal_location, forKey: "deal_location")
                dictionary.setValue(self.id, forKey: "id")
                dictionary.setValue(self.latitude, forKey: "latitude")
                dictionary.setValue(self.logitude, forKey: "logitude")
                dictionary.setValue(self.deal_title, forKey: "deal_title")
                dictionary.setValue(self.deal_id, forKey: "deal_id")
                return dictionary as! [String:Any]
            }
            
        }
        
        
        class DealOptionList {
            
            var discount_price : String?
            var id : String?
            var option_discount : String?
            var option_price : String?
            var option_title : String?
           
            
            required init(dictionary: [String:Any]) {
                discount_price = dictionary["discount_price"] as? String
                id = dictionary["id"] as? String
                option_discount = dictionary["option_discount"] as? String
                option_price = dictionary["option_price"] as? String
                option_title = dictionary["option_title"] as? String
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.discount_price, forKey: "discount_price")
                dictionary.setValue(self.id, forKey: "id")
                dictionary.setValue(self.option_discount, forKey: "option_discount")
                dictionary.setValue(self.option_price, forKey: "option_price")
                dictionary.setValue(self.option_title, forKey: "option_title")
               return dictionary as! [String:Any]
            }
            
        }
        
    }
    
}


class LatestDealList:NSObject {
    
    var deal_category : String?
    var deal_discount_percentage : String?
    var deal_discounted_price : String?
    var deal_image : String?
    var deal_location : String?
    var deal_price : String?
    var deal_slug : Bool?
    var deal_subcategory : String?
    var deal_title : String?
    var deal_id : String?
    
    
    init(dictionary:[String:Any]) {
        deal_category = dictionary["deal_category"] as? String
        deal_discount_percentage = dictionary["deal_discount_percentage"] as? String
        deal_discounted_price = dictionary["deal_discounted_price"] as? String
        deal_image = dictionary["deal_image"] as? String
        deal_location = dictionary["deal_location"] as? String
        deal_price = dictionary["deal_price"] as? String
        deal_slug = dictionary["deal_slug"] as? Bool
        deal_subcategory = dictionary["deal_subcategory"] as? String
        deal_title = dictionary["deal_title"] as? String
        deal_id = dictionary["deal_id"] as? String
        
        
    }
    
    init(dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
}


class PageList:NSObject {
    
    var pageDesc : String?
    var pageTitle : String?
    var page_or_url : String?
    var page_slug : String?
    var page_url : String?
    
    
    init(dictionary:[String:Any]) {
        pageDesc = dictionary["pageDesc"] as? String
        pageTitle = dictionary["pageTitle"] as? String
        page_or_url = dictionary["page_or_url"] as? String
        page_slug = dictionary["page_slug"] as? String
        page_url = dictionary["page_url"] as? String
        
    }
    
    init(dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
}


class MerchantDealClass{
    var dealList: [MyDealList] = [MyDealList]()
    var TotalRecords : Int = 0
    var TotalPages : Int = 0
    var currentPage : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["deals"] as! [Any]).map({MyDealList(dictionary: $0 as! [String:Any])})
        TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
        TotalPages = dictionary["TotalPages"] as? Int ?? 0
        currentPage = dictionary["currentPage"] as? Int ?? 0
    }
    
    class MyDealList {
        
        var MerchantName : String?
        var categoryName : String?
        var image_name : String?
        var deal_id : String?
        var deal_title : String?
        var subcategoryName : String?
        var deal_location : String?
        var deal_slug : String?
        var discount_price : String?
        var option_price : String?
        
        
        
        required init(dictionary: [String:Any]) {
            MerchantName = dictionary["MerchantName"] as? String
            categoryName = dictionary["categoryName"] as? String
            image_name = dictionary["image_name"] as? String
            deal_id = dictionary["deal_id"] as? String
            deal_title = dictionary["deal_title"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            deal_location = dictionary["deal_location"] as? String
            deal_slug = dictionary["deal_slug"] as? String
            discount_price = dictionary["discount_price"] as? String
            option_price = dictionary["option_price"] as? String
            
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.MerchantName, forKey: "MerchantName")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.image_name, forKey: "image_name")
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.deal_location, forKey: "deal_location")
            dictionary.setValue(self.deal_slug, forKey: "deal_slug")
            dictionary.setValue(self.discount_price, forKey: "discount_price")
            dictionary.setValue(self.option_price, forKey: "option_price")
            
            
            
            return dictionary as! [String:Any]
        }
        
    }
    
}


class DealDetailCls {
    var imageList: [DealImages] = [DealImages]()
    var locationList: [LocationList] = [LocationList]()
    var optionList: [OptionList] = [OptionList]()
     var reviewsList: [ReviewsList] = [ReviewsList]()
    var similarDealList: [SimilarDealList] = [SimilarDealList]()
    var categoryName : String = ""
    var deal_title : String = ""
    var description : String = ""
    var subcategoryName : String = ""
    var isFavotite : String = ""
    var merchantContact : String = ""
    var merchantEmail : String = ""
    var merchantName : String = ""
    var merchantWebsite : String = ""
    var posted_by : String = ""
    var deal_category_id : String = ""
    var average_rating : String = ""
    var deal_sub_category_id : String = ""
    var end_date : String = ""
    var end_time : String = ""
    var isPurchased : String = ""
   
    
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        imageList = (dictionary["deal_images"] as! [Any]).map({DealImages(dictionary: $0 as! [String:Any])})
        locationList = (dictionary["deal_location"] as! [Any]).map({LocationList(dictionary: $0 as! [String:Any])})
        optionList = (dictionary["deal_options"] as! [Any]).map({OptionList(dictionary: $0 as! [String:Any])})
        reviewsList = (dictionary["deal_reviews"] as! [Any]).map({ReviewsList(dictionary: $0 as! [String:Any])})
        similarDealList = (dictionary["similiar_deals"] as! [Any]).map({SimilarDealList(dictionary: $0 as! [String:Any])})
        categoryName = dictionary["categoryName"] as? String ?? ""
        deal_title = dictionary["deal_title"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        subcategoryName = dictionary["subcategoryName"] as? String ?? ""
        isFavotite = dictionary["isFavotite"] as? String ?? ""
        merchantContact = dictionary["merchantContact"] as? String ?? ""
        merchantEmail = dictionary["merchantEmail"] as? String ?? ""
        merchantName = dictionary["merchantName"] as? String ?? ""
        merchantWebsite = dictionary["merchantWebsite"] as? String ?? ""
        posted_by = dictionary["posted_by"] as? String ?? ""
        deal_category_id = dictionary["deal_category_id"] as? String ?? ""
        average_rating = dictionary["average_rating"] as? String ?? ""
        deal_sub_category_id = dictionary["deal_sub_category_id"] as? String ?? ""
        end_date = dictionary["end_date"] as? String ?? ""
        end_time = dictionary["end_time"] as? String ?? ""
       isPurchased = dictionary["isPurchased"] as? String ?? ""
    }
}


class LocationList {
    var deal_location : String?
    var id : String?
    var latitude : String?
    var logitude : String?
    
    
    required init(dictionary: [String:Any]) {
        deal_location = dictionary["deal_location"] as? String
        id = dictionary["id"] as? String
        latitude = dictionary["latitude"] as? String
        logitude = dictionary["logitude"] as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.deal_location, forKey: "deal_location")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.logitude, forKey: "logitude")
        
        return dictionary as! [String:Any]
        
    }
    
}

class OptionList {
    var discount_price : String?
    var option_discount : String?
    var option_id : String?
    var option_price : String?
    var option_title : String?
    
    
    required init(dictionary: [String:Any]) {
        discount_price = dictionary["discount_price"] as? String
        option_discount = dictionary["option_discount"] as? String
        option_id = dictionary["option_id"] as? String
        option_price = dictionary["option_price"] as? String
        option_title = dictionary["option_title"] as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.discount_price, forKey: "discount_price")
        dictionary.setValue(self.option_discount, forKey: "option_discount")
        dictionary.setValue(self.option_id, forKey: "option_id")
        dictionary.setValue(self.option_price, forKey: "option_price")
        dictionary.setValue(self.option_title, forKey: "option_title")
        
        return dictionary as! [String:Any]
        
    }
    
}

class ReviewsList {
    var customer_name : String?
    var customer_profile : String?
    var reviewPostedOn : String?
    var review_description : String?
    var review_id : String?
    var review_rating : String?
    
    
    required init(dictionary: [String:Any]) {
        customer_name = dictionary["customer_name"] as? String
        customer_profile = dictionary["customer_profile"] as? String
        reviewPostedOn = dictionary["reviewPostedOn"] as? String
        review_description = dictionary["review_description"] as? String
        review_id = dictionary["review_id"] as? String
        review_rating = dictionary["review_rating"] as? String
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.customer_name, forKey: "customer_name")
        dictionary.setValue(self.customer_profile, forKey: "customer_profile")
        dictionary.setValue(self.reviewPostedOn, forKey: "reviewPostedOn")
        dictionary.setValue(self.review_description, forKey: "review_description")
        dictionary.setValue(self.review_id, forKey: "review_id")
        dictionary.setValue(self.review_rating, forKey: "review_rating")
        
        return dictionary as! [String:Any]
        
    }
    
}


class SimilarDealList {
    var MerchantName : String?
    var categoryName : String?
    var dealImages : String?
    var deal_id : String?
    var deal_title : String?
    var merchantContact : String?
    var merchantEmail : String?
    var subcategoryName : String?
   
    required init(dictionary: [String:Any]) {
        MerchantName = dictionary["MerchantName"] as? String
        categoryName = dictionary["categoryName"] as? String
        dealImages = dictionary["dealImages"] as? String
        deal_id = dictionary["deal_id"] as? String
        deal_title = dictionary["deal_title"] as? String
        merchantContact = dictionary["merchantContact"] as? String
        merchantEmail = dictionary["merchantEmail"] as? String
        subcategoryName = dictionary["subcategoryName"] as? String
    }

    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.MerchantName, forKey: "MerchantName")
        dictionary.setValue(self.categoryName, forKey: "categoryName")
        dictionary.setValue(self.dealImages, forKey: "dealImages")
        dictionary.setValue(self.deal_id, forKey: "deal_id")
        dictionary.setValue(self.deal_title, forKey: "deal_title")
        dictionary.setValue(self.merchantContact, forKey: "merchantContact")
        dictionary.setValue(self.merchantEmail, forKey: "merchantEmail")
        dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")

        return dictionary as! [String:Any]
        
    }

}


class OrderCls{
    var orderList: [OrderList] = [OrderList]()
    var total : Int = 0
    var total_page : Int = 0
    var current_page : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        orderList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["deal_orders"] as! [Any]).map({OrderList(dictionary: $0 as! [String:Any])})
        total = dictionary["total"] as? Int ?? 0
        total_page = dictionary["total_page"] as? Int ?? 0
        current_page = dictionary["current_page"] as? Int ?? 0
    }
    
    class OrderList {
        
        var categoryName : String?
        var customerContactNo : String?
        var customerEmail : String?
        var customerFirstName : String?
        var customerId : String?
        var customerlastName : String?
        var dealImages : String?
        var deal_discount_price : String?
        var deal_id : String?
        var deal_option_title : String?
        var deal_order_id : String?
        var deal_price : String?
        var deal_title : String?
        var description : String?
        var payment_receipt_path : String?
        var payment_status : String?
        var purchased_date : String?
        var subcategoryName : String?
        
        
        
        required init(dictionary: [String:Any]) {
            categoryName = dictionary["categoryName"] as? String
            customerContactNo = dictionary["customerContactNo"] as? String
            customerEmail = dictionary["customerEmail"] as? String
            customerFirstName = dictionary["customerFirstName"] as? String
            customerId = dictionary["customerId"] as? String
            customerlastName = dictionary["customerlastName"] as? String
            dealImages = dictionary["dealImages"] as? String
            deal_discount_price = dictionary["deal_discount_price"] as? String
            
            deal_id = dictionary["deal_id"] as? String
            deal_option_title = dictionary["deal_option_title"] as? String
            deal_order_id = dictionary["deal_order_id"] as? String
            deal_price = dictionary["deal_price"] as? String
            deal_title = dictionary["deal_title"] as? String
            description = dictionary["description"] as? String
            payment_receipt_path = dictionary["payment_receipt_path"] as? String
            payment_status = dictionary["payment_status"] as? String
            purchased_date = dictionary["purchased_date"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.customerContactNo, forKey: "customerContactNo")
            dictionary.setValue(self.customerEmail, forKey: "customerEmail")
            dictionary.setValue(self.customerFirstName, forKey: "customerFirstName")
            dictionary.setValue(self.customerId, forKey: "customerId")
            dictionary.setValue(self.customerlastName, forKey: "customerlastName")
            dictionary.setValue(self.dealImages, forKey: "dealImages")
            dictionary.setValue(self.deal_discount_price, forKey: "deal_discount_price")
            
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.deal_option_title, forKey: "deal_option_title")
            dictionary.setValue(self.deal_order_id, forKey: "deal_order_id")
            dictionary.setValue(self.deal_price, forKey: "deal_price")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.payment_receipt_path, forKey: "payment_receipt_path")
            dictionary.setValue(self.payment_status, forKey: "payment_status")
            dictionary.setValue(self.purchased_date, forKey: "purchased_date")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            
            
            
            return dictionary as! [String:Any]
        }
        
    }
    
}


class MyDealClass{
    var dealList: [MyDealList] = [MyDealList]()
    var total : Int = 0
    var total_page : Int = 0
    var current_page : Int = 0
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["deals"] as! [Any]).map({MyDealList(dictionary: $0 as! [String:Any])})
        total = dictionary["total"] as? Int ?? 0
        total_page = dictionary["total_page"] as? Int ?? 0
        current_page = dictionary["current_page"] as? Int ?? 0
    }
    
    class MyDealList {
        
        var categoryName : String?
        var deal_id : String?
        var deal_title : String?
        var desc : String?
        var subcategoryName : String?
        var endDate : String?
        var endTime : String?
        
        
        required init(dictionary: [String:Any]) {
            categoryName = dictionary["categoryName"] as? String
            deal_id = dictionary["deal_id"] as? String
            deal_title = dictionary["deal_title"] as? String
            desc = dictionary["description"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            endDate = dictionary["endDate"] as? String
            endTime = dictionary["endTime"] as? String
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.desc, forKey: "description")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.endDate, forKey: "endDate")
            dictionary.setValue(self.endTime, forKey: "endTime")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class NearByDealCls{
    var dealList: [NearDealList] = [NearDealList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        dealList = (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .data)["results"] as! [Any]).map({NearDealList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class NearDealList {
        
        
        var deal_title : String?
        var categoryName : String?
        var subcategoryName : String?
        var merchantName : String?
        var dealImages : String?
        var deal_id : String?
        var deal_distance : String?
        
        
        required init(dictionary: [String:Any]) {
            deal_title = dictionary["deal_title"] as? String
            categoryName = dictionary["categoryName"] as? String
            subcategoryName = dictionary["subcategoryName"] as? String
            merchantName = dictionary["merchantName"] as? String
            dealImages = dictionary["dealImages"] as? String
            deal_id = dictionary["deal_id"] as? String
             deal_distance = dictionary["deal_distance"] as? String
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.deal_title, forKey: "deal_title")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.subcategoryName, forKey: "subcategoryName")
            dictionary.setValue(self.merchantName, forKey: "merchantName")
            dictionary.setValue(self.dealImages, forKey: "dealImages")
            dictionary.setValue(self.deal_id, forKey: "deal_id")
            dictionary.setValue(self.deal_distance, forKey: "deal_distance")
            
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var TotalPages : Int = 0
        var TotalRecords : Int = 0
        var currentPage : Int = 0
        
        required init(dictionary: [String:Any]) {
            TotalPages = dictionary["TotalPages"] as? Int ?? 0
            TotalRecords = dictionary["TotalRecords"] as? Int ?? 0
            currentPage = dictionary["currentPage"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.TotalPages, forKey: "TotalPages")
            dictionary.setValue(self.TotalRecords, forKey: "TotalRecords")
            dictionary.setValue(self.currentPage, forKey: "currentPage")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class ShopingCartList:NSObject{
    var cart_id  = ""
    var deal_category = ""
    var deal_id  = ""
    var deal_option_discount = ""
    var deal_option_discounted_price  = ""
    var deal_option_id = ""
    var deal_option_price  = ""
    var deal_option_title = ""
    var deal_subcategory  = ""
    var deal_title = ""
    
    
    init(dic:[String:Any]) {
        super.init()
        cart_id = dic["cart_id"] as? String ?? ""
        deal_category = dic["deal_category"] as? String ?? ""
        deal_id = dic["deal_id"] as? String ?? ""
        deal_option_discount = dic["deal_option_discount"] as? String ?? ""
        deal_option_discounted_price = dic["deal_option_discounted_price"] as? String ?? ""
        deal_option_id = dic["deal_option_id"] as? String ?? ""
        deal_option_price = dic["deal_option_price"] as? String ?? ""
        deal_option_title = dic["deal_option_title"] as? String ?? ""
        deal_title = dic["deal_title"] as? String ?? ""
        deal_subcategory = dic["deal_subcategory"] as? String ?? ""
        
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}
