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
    
    @objc  var password : String = ""
    @objc var email : String = ""
    @objc var activationCode : String = ""
    @objc var firstName : String = ""
    @objc var isActive : String = ""
    @objc var isBlocked : String = ""
    @objc var lastName : String = ""
    @objc var uId : String = ""
    @objc var userName : String = ""
    
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
        self.uId = dic["uId"] as? String ?? ""
        self.password = dic["password"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.activationCode = dic["activationCode"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.isActive = dic["isActive"] as? String ?? ""
        self.isBlocked = dic["isBlocked"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
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
    var password : String = ""
    var email : String = ""
    var activationCode : String = ""
    var firstName : String = ""
    var isActive : String = ""
    var isBlocked : String = ""
    var lastName : String = ""
    var uId : String = ""
    var userName : String = ""
    
    required init(dictionary: [String:Any]) {
        password = dictionary["password"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        activationCode = dictionary["activationCode"] as? String ?? ""
        firstName = dictionary["firstName"] as? String ?? ""
        isActive = dictionary["isActive"] as? String ?? ""
        isBlocked = dictionary["isBlocked"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        uId = dictionary["uId"] as? String ?? ""
        userName = dictionary["userName"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.password, forKey: "password")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.activationCode, forKey: "activationCode")
        dictionary.setValue(self.firstName, forKey: "firstName")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.isBlocked, forKey: "isBlocked")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.uId, forKey: "uId")
        dictionary.setValue(self.userName, forKey: "userName")
        return dictionary as! [String:Any]
    }
    
}
class CountryList: NSObject{
    
    private let keys = ["id", "country"];
    
    @objc var id = ""
    @objc var country = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        country = dic["country"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}

class StateList: NSObject{
    
    private let keys = ["StateID", "stateName","CountryID"];
    
    @objc var StateID = ""
    @objc var stateName = ""
    @objc var CountryID = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        StateID = dic["StateID"] as? String ?? ""
        stateName = dic["stateName"] as? String ?? ""
        CountryID = dic["CountryID"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}
class bidList: NSObject{
    
    private let keys = ["amount", "created_date","id","productName","product_id","productimage","quantity"]
    
    @objc var amount = ""
    @objc var created_date = ""
    @objc var id = ""
    @objc var productName = ""
    @objc var product_id = ""
    @objc var productimage = ""
    @objc var quantity = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        amount = dic["amount"] as? String ?? ""
        created_date = dic["created_date"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        productName = dic["productName"] as? String ?? ""
        product_id = dic["product_id"] as? String ?? ""
        productimage = dic["productimage"] as? String ?? ""
        quantity = dic["quantity"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}

class PartyList: NSObject{
    
    private let keys = ["id", "img","partyDate","partyName","userName"]
    
    @objc var id = ""
    @objc var img = ""
    @objc var partyDate = ""
    @objc var partyName = ""
    @objc var userName = ""
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        img = dic["img"] as? String ?? ""
        partyDate = dic["partyDate"] as? String ?? ""
        partyName = dic["partyName"] as? String ?? ""
        userName = dic["userName"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    var dictionary:[String:Any] {
        return self.dictionaryWithValues(forKeys: keys)
    }
    
}


class MyProfile:NSObject {
    
    @objc var StateID: String = "";
    @objc var aboutMe: String = "";
    @objc var accountType: String = "";
    @objc var activationCode: String = "";
    @objc var address: String = "";
    @objc var address2: String = "";
    @objc var bannerImg: String = "";
    @objc var birthDate: String = "";
    @objc var businessName: String = "";
    @objc var city: String = "";
    @objc var country: String = "";
    @objc var createdDate: String = "";
    @objc var creditAmount: String = "";
    @objc var derssId: String = "";
    @objc var email: String = "";
    @objc var fbStatus: String = "";
    @objc var firstName: String = "";
    @objc var ipAddress: String = "";
    @objc var isActive: String = "";
    @objc var isBlocked: String = "";
    @objc var isOnhomepage: String = "";
    @objc var lastName: String = "";
    @objc var loc_country: String = "";
    @objc var name: String = "";
    @objc var pId: String = "";
    @objc var password: String = "";
    @objc var paymentType: String = "";
    @objc var pendingAmount: String = "";
    @objc var phone: String = "";
    @objc var profileImg: String = "";
    @objc var redeemableAmount: String = "";
    @objc var resetPasswordToken: String = "";
    @objc var resetPasswordTokenExpiry: String = "";
    @objc var settings_Comment: String = "";
    @objc var settings_Follow: String = "";
    @objc var settings_likeOrshare: String = "";
    @objc var settings_partyInvite: String = "";
    @objc var shipping_apartment: String = "";
    @objc var shipping_city: String = "";
    @objc var shipping_state: String = "";
    @objc var shipping_street: String = "";
    @objc var shipping_zip: String = "";
    @objc var shoeId: String = "";
    @objc var state: String = "";
    @objc var stateName: String = "";
    @objc var uId: String = "";
    @objc var userName: String = "";
    @objc var website: String = "";
    @objc var zipCode: String = "";
    
    init(dic:[String:Any]) {
        
        StateID = dic["StateID"] as? String ?? ""
        aboutMe = dic["aboutMe"] as? String ?? ""
        activationCode = dic["activationCode"] as? String ?? ""
        address = dic["address"] as? String ?? ""
        address2 = dic["address2"] as? String ?? ""
        bannerImg = dic["bannerImg"] as? String ?? ""
        birthDate = dic["birthDate"] as? String ?? ""
        businessName = dic["businessName"] as? String ?? ""
        city = dic["city"] as? String ?? ""
        country = dic["country"] as? String ?? ""
        createdDate = dic["createdDate"] as? String ?? ""
        creditAmount = dic["creditAmount"] as? String ?? ""
        derssId = dic["derssId"] as? String ?? ""
        email = dic["email"] as? String ?? ""
        fbStatus = dic["fbStatus"] as? String ?? ""
        firstName = dic["firstName"] as? String ?? ""
        ipAddress = dic["ipAddress"] as? String ?? ""
        isActive = dic["isActive"] as? String ?? ""
        isBlocked = dic["isBlocked"] as? String ?? ""
        isOnhomepage = dic["isOnhomepage"] as? String ?? ""
        lastName = dic["lastName"] as? String ?? ""
        loc_country = dic["loc_country"] as? String ?? ""
        name = dic["name"] as? String ?? ""
        address = dic["address"] as? String ?? ""
        pId = dic["pId"] as? String ?? ""
        password = dic["password"] as? String ?? ""
        paymentType = dic["paymentType"] as? String ?? ""
        pendingAmount = dic["pendingAmount"] as? String ?? ""
        phone = dic["phone"] as? String ?? ""
        profileImg = dic["profileImg"] as? String ?? ""
        redeemableAmount = dic["redeemableAmount"] as? String ?? ""
        resetPasswordToken = dic["resetPasswordToken"] as? String ?? ""
        resetPasswordTokenExpiry = dic["resetPasswordTokenExpiry"] as? String ?? ""
        settings_Comment = dic["settings_Comment"] as? String ?? ""
        settings_Follow = dic["settings_Follow"] as? String ?? ""
        settings_likeOrshare = dic["settings_likeOrshare"] as? String ?? ""
        settings_partyInvite = dic["settings_partyInvite"] as? String ?? ""
        shipping_apartment = dic["shipping_apartment"] as? String ?? ""
        shipping_city = dic["shipping_city"] as? String ?? ""
        shipping_state = dic["shipping_state"] as? String ?? ""
        shipping_street = dic["shipping_street"] as? String ?? ""
        shipping_zip = dic["shipping_zip"] as? String ?? ""
        shoeId = dic["shoeId"] as? String ?? ""
        state = dic["state"] as? String ?? ""
        stateName = dic["stateName"] as? String ?? ""
        uId = dic["uId"] as? String ?? ""
        userName = dic["userName"] as? String ?? ""
        website = dic["website"] as? String ?? ""
        zipCode = dic["zipCode"] as? String ?? ""
    }
    
}

class AboutUs {
    var pageDesc : String = ""
    
    required init(dictionary: [String:Any]) {
        pageDesc = dictionary["pageDesc"] as? String ?? ""
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: Dictionary.
     */
    public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.pageDesc, forKey: "pageDesc")
        return dictionary as! [String:Any]
    }
    
}

class MyShop {
    var address : String = ""
    var bannerImg : String = ""
    var email : String = ""
    var followers : Int = 0
    var following :  Int = 0
    var followstatus : String = ""
    var listing :  Int = 0
    var location : String = ""
    var profileImg : String = ""
    var profileimg : String = ""
    var user_id : String = ""
    var username : String = ""
    
    required init(dictionary: [String:Any]) {
        address = dictionary["address"] as? String ?? ""
        bannerImg = dictionary["bannerImg"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        followers = dictionary["followers"] as? Int ?? 0
        following = dictionary["following"] as? Int ?? 0
        listing = dictionary["listing"] as? Int ?? 0
        followstatus = dictionary["followstatus"] as? String ?? ""
        location = dictionary["location"] as? String ?? ""
        profileImg = dictionary["profileImg"] as? String ?? ""
        profileimg = dictionary["profileimg"] as? String ?? ""
        user_id = dictionary["user_id"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
    }
    
    public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.bannerImg, forKey: "bannerImg")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.followers, forKey: "followers")
        dictionary.setValue(self.following, forKey: "following")
        dictionary.setValue(self.followstatus, forKey: "followstatus")
        dictionary.setValue(self.listing, forKey: "listing")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.profileImg, forKey: "profileImg")
        dictionary.setValue(self.profileimg, forKey: "profileimg")
        dictionary.setValue(self.user_id, forKey: "user_id")
        dictionary.setValue(self.username, forKey: "username")
        return dictionary as! [String:Any]
    }
    class Products: NSObject {
        @objc var aboutProduct = "";
        @objc var address = "";
        @objc var amount = "";
        @objc var auction = "";
        @objc var bidding_deadline = "";
        @objc var brand = "";
        @objc var brandId = "";
        @objc var category = "";
        @objc var categoryId = "";
        @objc var comments = "";
        @objc var condition = "";
        @objc var createdDate = "";
        @objc var id = "";
        @objc var isActive = "";
        @objc var isPopular = "";
        @objc var isSold = "";
        @objc var likes = "";
        @objc var orgAmount = "";
        @objc var productDesc = "";
        @objc var productName = "";
        @objc var productimg = "";
        @objc var profileImg = "";
        @objc var quantity = "";
        @objc var size = "";
        @objc var sizeId = "";
        @objc var userId = "";
        @objc var userName = "";
        @objc var winner = "";
        
        init(dic:[String:Any]) {
            
            aboutProduct = dic["aboutProduct"] as? String ?? ""
            address = dic["address"] as? String ?? ""
            amount = dic["amount"] as? String ?? ""
            address = dic["address"] as? String ?? ""
            auction = dic["auction"] as? String ?? ""
            bidding_deadline = dic["bidding_deadline"] as? String ?? ""
            brand = dic["brand"] as? String ?? ""
            brandId = dic["brandId"] as? String ?? ""
            category = dic["category"] as? String ?? ""
            categoryId = dic["categoryId"] as? String ?? ""
            createdDate = dic["createdDate"] as? String ?? ""
            comments = dic["comments"] as? String ?? ""
            condition = dic["condition"] as? String ?? ""
            createdDate = dic["createdDate"] as? String ?? ""
            id = dic["id"] as? String ?? ""
            isActive = dic["isActive"] as? String ?? ""
            isPopular = dic["isPopular"] as? String ?? ""
            isActive = dic["isActive"] as? String ?? ""
            isSold = dic["isSold"] as? String ?? ""
            likes = dic["likes"] as? String ?? ""
            orgAmount = dic["orgAmount"] as? String ?? ""
            productDesc = dic["productDesc"] as? String ?? ""
            productName = dic["productName"] as? String ?? ""
            address = dic["address"] as? String ?? ""
            productimg = dic["productimg"] as? String ?? ""
            profileImg = dic["profileImg"] as? String ?? ""
            quantity = dic["quantity"] as? String ?? ""
            size = dic["size"] as? String ?? ""
            userId = dic["userId"] as? String ?? ""
            userName = dic["userName"] as? String ?? ""
            winner = dic["winner"] as? String ?? ""
        }
    }
}


class Follower {
    var numPages : Int = 0
    var pageno : Int = 0
    var total_records : Int = 0
    var username : String = ""
    var fullname : String = ""
    var userid : String = ""
    var userimg : String = ""
    
    required init(dictionary: [String:Any]) {
        numPages = dictionary["numPages"] as? Int ?? 0
        pageno = dictionary["pageno"] as? Int ?? 0
        total_records = dictionary["total_records"] as? Int ?? 0
        username = dictionary["username"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        userid = dictionary["userid"] as?  String ?? ""
        userimg = dictionary["userimg"] as?  String ?? ""
    }
    public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.numPages, forKey: "numPages")
        dictionary.setValue(self.pageno, forKey: "pageno")
        dictionary.setValue(self.total_records, forKey: "total_records")
        dictionary.setValue(self.username, forKey: "username")
        dictionary.setValue(self.fullname, forKey: "fullname")
        dictionary.setValue(self.userid, forKey: "userid")
        dictionary.setValue(self.userimg, forKey: "userimg")
        return dictionary as! [String:Any]
    }
    
    class FollowerList: NSObject {
        @objc var followfullname = "";
        @objc var followid = "";
        @objc var followimg = "";
        @objc var followname = "";
        @objc var followstatus = "";
        @objc var id = "";
        
        init(dic:[String:Any]) {
            
            followfullname = dic["followfullname"] as? String ?? ""
            followid = dic["followid"] as? String ?? ""
            followimg = dic["followimg"] as? String ?? ""
            followname = dic["followname"] as? String ?? ""
            followstatus = dic["followstatus"] as? String ?? ""
            id = dic["id"] as? String ?? ""
        }
    }
}


class CategoryList: NSObject {
    @objc var categoryname = "";
    @objc var id = "";
    @objc var image = "";
    
    init(dic:[String:Any]) {
        
        categoryname = dic["categoryname"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        image = dic["image"] as? String ?? ""
    }
}

class SizeList: NSObject {
    @objc var sizeCode = "";
    @objc var id = "";
    @objc var sizeName = "";
    
    init(dic:[String:Any]) {
        
        sizeCode = dic["sizeCode"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        sizeName = dic["sizeName"] as? String ?? ""
    }
}

class BrandList: NSObject {
    @objc var brand_name = "";
    @objc var id = "";
    
    init(dic:[String:Any]) {
        
        brand_name = dic["brand_name"] as? String ?? ""
        id = dic["id"] as? String ?? ""
    }
}

class ProductDetail{
    
    var amount = "";
    var auction = "";
    var brand = "";
    var brandid = "";
    var category = "";
    var profileImg = "";
    var quantity = "";
    var size = "";
    var condition = "";
    var desc = "";
    var favourite = "";
    var isSold = "";
    var likes = "";
    var orgAmount = "";
    var ownerid = "";
    var ownername = "";
    var productName = "";
    var productid = "";
    
    required init(dictionary: [String:Any]) {
        amount = dictionary["amount"] as? String ?? ""
        auction = dictionary["auction"] as? String ?? ""
        brand = dictionary["brand"] as? String ?? ""
        brandid = dictionary["brandid"] as? String ?? ""
        category = dictionary["category"] as? String ?? ""
        profileImg = dictionary["profileImg"] as?  String ?? ""
        quantity = dictionary["quantity"] as?  String ?? ""
        size = dictionary["size"] as?  String ?? ""
        condition = dictionary["condition"] as?  String ?? ""
        desc = dictionary["desc"] as? String ?? ""
        favourite = dictionary["favourite"] as? String ?? ""
        isSold = dictionary["isSold"] as?  String ?? ""
        likes = dictionary["likes"] as?  String ?? ""
        orgAmount = dictionary["orgAmount"] as?  String ?? ""
        ownerid = dictionary["ownerid"] as? String ?? ""
        ownername = dictionary["ownername"] as?  String ?? ""
        productName = dictionary["productName"] as?  String ?? ""
        productid = dictionary["productid"] as?  String ?? ""
    }
    public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.amount, forKey: "amount")
        dictionary.setValue(self.auction, forKey: "auction")
        dictionary.setValue(self.brand, forKey: "brand")
        dictionary.setValue(self.brandid, forKey: "brandid")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.profileImg, forKey: "profileImg")
        dictionary.setValue(self.quantity, forKey: "quantity")
        dictionary.setValue(self.size, forKey: "size")
        dictionary.setValue(self.condition, forKey: "condition")
        dictionary.setValue(self.desc, forKey: "desc")
        dictionary.setValue(self.favourite, forKey: "favourite")
        dictionary.setValue(self.isSold, forKey: "isSold")
        dictionary.setValue(self.likes, forKey: "likes")
        dictionary.setValue(self.orgAmount, forKey: "orgAmount")
        dictionary.setValue(self.ownerid, forKey: "ownerid")
        dictionary.setValue(self.ownername, forKey: "ownername")
        dictionary.setValue(self.productName, forKey: "productName")
        dictionary.setValue(self.productid, forKey: "productid")
        return dictionary as! [String:Any]
    }
    
    class ProductList:NSObject{
        
        @objc var imgid = "";
        @objc var productimage = "";
        
        init(dic:[String:Any]) {
            
            imgid = dic["imgid"] as? String ?? ""
            productimage = dic["productimage"] as? String ?? ""
        }
    }
}
