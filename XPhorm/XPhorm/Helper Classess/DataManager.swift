//
//  DataManager.swift
//  Talabtech
//
//  Created by NCT 24 on 19/05/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var address = "";
    var birthDate = "";
    var contactNumber = "";
    var createdDate = "";
    var creditAmount = 0;
    var desc = "";
    var email = "";
    var email_verified = "";
    var emergencyContactName = "";
    var emergencyContactNumber = "";
    var facebook_verify = "";
    var firstName = "";
    var gender = "";
    var google_verify = "";
    var holdAmount = 0;
    var id = "";
    var isActive = "y";
    var lastName = "";
    var linkedin_verify = "";
    var paypalId = "";
    var profileImg = "";
    var redeemAmount = 0;
    var responseRate = 0;
    var responseTime = 0;
    var isCertificate = 0;
     var insta_verify = "n";
    
    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        super.init()
        self.address = dic["address"] as? String ?? ""
        self.birthDate = dic["birthDate"] as? String ?? ""
        self.contactNumber = dic["contactNumber"] as? String ?? ""
        self.createdDate = dic["createdDate"] as? String ?? ""
        self.creditAmount = dic["creditAmount"] as? Int ?? 0
        self.desc = dic["desc"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.email_verified = dic["email_verified"] as? String ?? ""
        self.emergencyContactName = dic["emergencyContactName"] as? String ?? ""
        self.emergencyContactNumber = dic["emergencyContactNumber"] as? String ?? ""
        self.facebook_verify = dic["facebook_verify"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? ""
        self.google_verify = dic["google_verify"] as? String ?? ""
        self.holdAmount = dic["holdAmount"] as? Int ?? 0
        self.id = dic["id"] as? String ?? ""
        self.isActive = dic["isActive"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.linkedin_verify = dic["linkedin_verify"] as? String ?? ""
        self.paypalId = dic["paypalId"] as? String ?? ""
        self.profileImg = dic["profileImg"] as? String ?? ""
        self.redeemAmount = dic["redeemAmount"] as? Int ?? 0
        self.responseRate = dic["responseRate"] as? Int ?? 0
        self.responseTime = dic["responseTime"] as? Int ?? 0
        self.isCertificate = dic["isCertificate"] as? Int ?? 0
        self.insta_verify = dic["insta_verify"] as? String ?? ""
    }
    
    init(userData dic:[String:Any]) {
        super.init()
        self.setValuesForKeys(dic)
        //self.isProvider = ( (dic["user_type"] as? String ?? "") == "p" ? true : false )
    }
}

class Profile {
    
    var activationExpire = "n";
    var activation_key = "";
    var address = "";
    var birthDate = "";
    var contactNumber = "";
    var createdDate = "";
    var creditAmount = 0;
    var desc = "";
    var email = "";
    var email_verified = "";
    var emergencyContactName = "";
    var emergencyContactNumber = "";
    var facebook_verify = "";
    var firstName = "";
    var gender = "";
    var google_verify = "";
    var holdAmount = 0;
    var id = "";
    var insta_verify = "n";
    var ipAddress = "";
    var isActive = "";
    var lastName = "";
    var linkedin_verify = "";
    var password = "";
    var paypalId = "";
    var profileImg = "";
    var redeemAmount = 0;
    var responseRate = 0;
    var responseTime = 0;
    var statistics:Statistics?
    var certificates: [Certificates] = [Certificates]()
    var givenReviews: [GivenReviews] = [GivenReviews]()
    var receivedReviews: [ReceivedReviews] = [ReceivedReviews]()
    
    required init(dic: [String:Any]) {
        self.statistics = Statistics(dic: (ResponseKey.fatchDataAsDictionary(res: dic["statistics"] as! dictionary, valueOf: .statistics)))
        certificates = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .userCertificates) ).map({Certificates(dic: $0 as! [String:Any])})
        givenReviews = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .givenReviews) ).map({GivenReviews(dic: $0 as! [String:Any])})
         receivedReviews = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .receivedReviews) ).map({ReceivedReviews(dic: $0 as! [String:Any])})
        self.activationExpire = dic["activationExpire"] as? String ?? ""
        self.activation_key = dic["activation_key"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.birthDate = dic["birthDate"] as? String ?? ""
        self.contactNumber = dic["contactNumber"] as? String ?? ""
        self.createdDate = dic["createdDate"] as? String ?? ""
        self.creditAmount = dic["creditAmount"] as? Int ?? 0
        self.desc = dic["description"] as? String ?? ""
        self.emergencyContactName = dic["emergencyContactName"] as? String ?? ""
        self.emergencyContactNumber = dic["emergencyContactNumber"] as? String ?? ""
        self.facebook_verify = dic["facebook_verify"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? ""
        self.google_verify = dic["google_verify"] as? String ?? ""
        self.holdAmount = dic["holdAmount"] as? Int ?? 0
        self.email = dic["email"] as? String ?? ""
        self.isActive = dic["isActive"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.linkedin_verify = dic["linkedin_verify"] as? String ?? ""
        self.paypalId = dic["paypalId"] as? String ?? ""
        self.profileImg = dic["profileImg"] as? String ?? ""
        self.redeemAmount = dic["redeemAmount"] as? Int ?? 0
        self.responseRate = dic["responseRate"] as? Int ?? 0
        self.responseTime = dic["responseTime"] as? Int ?? 0
        self.email_verified = dic["email_verified"] as? String ?? ""
        self.id = dic["id"] as? String ?? ""
        self.insta_verify = dic["insta_verify"] as? String ?? ""
        self.ipAddress = dic["ipAddress"] as? String ?? ""
        self.password = dic["password"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.activationExpire, forKey: "activationExpire")
        dictionary.setValue(self.activation_key, forKey: "activation_key")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.birthDate, forKey: "birthDate")
        dictionary.setValue(self.contactNumber, forKey: "contactNumber")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.creditAmount, forKey: "creditAmount")
        dictionary.setValue(self.desc, forKey: "description")
        dictionary.setValue(self.emergencyContactName, forKey: "emergencyContactName")
        dictionary.setValue(self.emergencyContactNumber, forKey: "emergencyContactNumber")
        dictionary.setValue(self.facebook_verify, forKey: "facebook_verify")
        dictionary.setValue(self.firstName, forKey: "firstName")
        dictionary.setValue(self.gender, forKey: "gender")
        dictionary.setValue(self.google_verify, forKey: "google_verify")
        dictionary.setValue(self.holdAmount, forKey: "holdAmount")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.isActive, forKey: "isActive")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.linkedin_verify, forKey: "linkedin_verify")
        dictionary.setValue(self.paypalId, forKey: "paypalId")
        dictionary.setValue(self.profileImg, forKey: "profileImg")
        dictionary.setValue(self.redeemAmount, forKey: "redeemAmount")
        dictionary.setValue(self.responseRate, forKey: "responseRate")
        dictionary.setValue(self.responseTime, forKey: "responseTime")
        dictionary.setValue(self.email_verified, forKey: "email_verified")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.insta_verify, forKey: "insta_verify")
        dictionary.setValue(self.ipAddress, forKey: "ipAddress")
        dictionary.setValue(self.password, forKey: "password")
        
        return dictionary as! [String:Any]
    }
    
    class Statistics {
        var totalDogs = 0
        var totalEarned = 0
        var totalGivenReviews = 0
        var totalReceivedReviews = 0
        var totalServices = 0
        
        init(dic:[String:Any]) {
            self.totalDogs = dic["totalDogs"] as? Int ?? 0
            self.totalEarned = dic["totalEarned"] as? Int ?? 0
            self.totalGivenReviews = dic["totalGivenReviews"] as? Int ?? 0
            self.totalReceivedReviews = dic["totalReceivedReviews"] as? Int ?? 0
            self.totalServices = dic["totalServices"] as? Int ?? 0
        }
        
    }
    
    class Certificates
    {
        var certificate = ""
        var certificatePath = ""
        var id = ""
        
        required init(dic: [String:Any]) {
            self.certificate = dic["certificate"] as? String ?? ""
            self.certificatePath = dic["certificatePath"] as? String ?? ""
            self.id = dic["id"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.certificate, forKey: "certificate")
            dictionary.setValue(self.certificatePath, forKey: "certificatePath")
            dictionary.setValue(self.id, forKey: "id")
            return dictionary as! [String:Any]
        }
    }
    
    class GivenReviews
    {
        var createdDate = ""
        var description = ""
        var id = ""
        var profileImg = ""
        var ratting = ""
        var userName = ""
        
        required init(dic: [String:Any]) {
            self.createdDate = dic["createdDate"] as? String ?? ""
            self.description = dic["description"] as? String ?? ""
            self.id = dic["id"] as? String ?? ""
            self.profileImg = dic["profileImg"] as? String ?? ""
            self.ratting = dic["ratting"] as? String ?? ""
            self.userName = dic["userName"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.profileImg, forKey: "profileImg")
            dictionary.setValue(self.ratting, forKey: "ratting")
            dictionary.setValue(self.userName, forKey: "userName")
            return dictionary as! [String:Any]
        }
    }
    
    
    class ReceivedReviews
    {
        var createdDate = ""
        var description = ""
        var id = ""
        var profileImg = ""
        var ratting = ""
        var userName = ""
        
        required init(dic: [String:Any]) {
            self.createdDate = dic["createdDate"] as? String ?? ""
            self.description = dic["description"] as? String ?? ""
            self.id = dic["id"] as? String ?? ""
            self.profileImg = dic["profileImg"] as? String ?? ""
            self.ratting = dic["ratting"] as? String ?? ""
            self.userName = dic["userName"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.profileImg, forKey: "profileImg")
            dictionary.setValue(self.ratting, forKey: "ratting")
            dictionary.setValue(self.userName, forKey: "userName")
            return dictionary as! [String:Any]
        }
    }
    
}

class UserLoginData {
    var address = "";
    var birthDate = "";
    var contactNumber = "";
    var createdDate = "";
    var creditAmount = 0;
    var desc = "";
    var email = "";
    var email_verified = "";
    var emergencyContactName = "";
    var emergencyContactNumber = "";
    var facebook_verify = "";
    var firstName = "";
    var gender = "";
    var google_verify = "";
    var holdAmount = 0;
    var id = "";
    var isActive = "y";
    var lastName = "";
    var linkedin_verify = "";
    var paypalId = "";
    var profileImg = "";
    var redeemAmount = 0;
    var responseRate = 0;
    var responseTime = 0;
    
    required init(dic: [String:Any]) {
        self.address = dic["address"] as? String ?? ""
        self.birthDate = dic["birthDate"] as? String ?? ""
        self.contactNumber = dic["contactNumber"] as? String ?? ""
        self.createdDate = dic["createdDate"] as? String ?? ""
        self.creditAmount = dic["creditAmount"] as? Int ?? 0
        self.desc = dic["description"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.email_verified = dic["email_verified"] as? String ?? ""
        self.emergencyContactName = dic["emergencyContactName"] as? String ?? ""
        self.emergencyContactNumber = dic["emergencyContactNumber"] as? String ?? ""
        self.facebook_verify = dic["facebook_verify"] as? String ?? ""
        self.firstName = dic["firstName"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? ""
        self.google_verify = dic["google_verify"] as? String ?? ""
        self.holdAmount = dic["holdAmount"] as? Int ?? 0
        self.id = dic["id"] as? String ?? ""
        self.isActive = dic["isActive"] as? String ?? ""
        self.lastName = dic["lastName"] as? String ?? ""
        self.linkedin_verify = dic["linkedin_verify"] as? String ?? ""
        self.paypalId = dic["paypalId"] as? String ?? ""
        self.profileImg = dic["profileImg"] as? String ?? ""
        self.redeemAmount = dic["redeemAmount"] as? Int ?? 0
        self.responseRate = dic["responseRate"] as? Int ?? 0
        self.responseTime = dic["responseTime"] as? Int ?? 0
    }
}


class ServiceTypeList:NSObject{
    var categoryName  = ""
    var desc = ""
    var id = ""
    
    init(dic:[String:Any]) {
        super.init()
        categoryName = dic["categoryName"] as? String ?? ""
        desc = dic["description"] as? String ?? ""
        id = dic["id"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class LanguageList:NSObject {
    var id = ""
    var languageName = ""
    var default_lan = ""
    var url_constant = ""
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        languageName = dic["languageName"] as? String ?? ""
        default_lan = dic["default_lan"] as? String ?? ""
        url_constant = dic["url_constant"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}

class SearchResultCls{
    var searchList: [SearchList] = [SearchList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        searchList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({SearchList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class SearchList:NSObject {
        var avgRating = ""
        var categoryName = ""
        var distance = 0
        var favStatus = ""
        var id  = ""
        var latitude = ""
        var location = ""
        var longitude = ""
        var price = ""
        var totalReview = 0
        var totalService = 0
        var userId = ""
        var userImg = ""
        var userName = ""
        
        
        required init(dictionary: [String:Any]) {
            avgRating = dictionary["avgRating"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            distance = dictionary["distance"] as? Int ?? 0
            favStatus = dictionary["favStatus"] as? String ?? ""
            id = dictionary["id"] as? String ?? ""
            latitude = dictionary["latitude"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            longitude = dictionary["longitude"] as? String ?? ""
            price = dictionary["price"] as? String ?? ""
            totalReview = dictionary["totalReview"] as? Int ?? 0
            totalService = dictionary["totalService"] as? Int ?? 0
            userId = dictionary["userId"] as? String ?? ""
            userImg = dictionary["userImg"] as? String ?? ""
            userName = dictionary["userName"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.avgRating, forKey: "avgRating")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.distance, forKey: "distance")
            dictionary.setValue(self.favStatus, forKey: "favStatus")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.latitude, forKey: "latitude")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.longitude, forKey: "longitude")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(totalReview, forKey: "totalReview")
            dictionary.setValue(totalService, forKey: "totalService")
            
            dictionary.setValue(self.userId, forKey: "userId")
            dictionary.setValue(self.userImg, forKey: "userImg")
            dictionary.setValue(userName, forKey: "userName")
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : String = ""
        var totalRecords : String = ""
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? String ?? ""
            totalRecords = dictionary["totalRecords"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class ReceivedReviewCls{
    var reviewList: [ReviewList] = [ReviewList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        reviewList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({ReviewList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class ReviewList:NSObject {
        var createdDate = ""
        var desc = ""
        var id = ""
        var profileImg = ""
        var ratting  = ""
        var userName = ""
        var bookingId = ""
        
        required init(dictionary: [String:Any]) {
            createdDate = dictionary["createdDate"] as? String ?? ""
            desc = dictionary["description"] as? String ?? ""
            id = dictionary["id"] as? String ?? ""
            profileImg = dictionary["profileImg"] as? String ?? ""
            ratting = dictionary["ratting"] as? String ?? ""
            userName = dictionary["userName"] as? String ?? ""
            bookingId = dictionary["bookingId"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.desc, forKey: "description")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.profileImg, forKey: "profileImg")
            dictionary.setValue(self.userName, forKey: "userName")
            dictionary.setValue(self.ratting, forKey: "ratting")
            dictionary.setValue(self.bookingId, forKey: "bookingId")
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}

class DurationList:NSObject{
    var id  = ""
    var duration = ""
    var isActive = ""
    
    init(dic:[String:Any]) {
        super.init()
        duration = dic["duration"] as? String ?? ""
        isActive = dic["isActive"] as? String ?? ""
        id = dic["id"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class AgeList:NSObject{
    var id  = ""
    var age = ""
    var isActive = ""
    
    init(dic:[String:Any]) {
        super.init()
        age = dic["age"] as? String ?? ""
        isActive = dic["isActive"] as? String ?? ""
        id = dic["id"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class TimeList:NSObject{
    var status  = ""
    var date = ""
    var isTempBooked = ""
    var isHoliday = ""
    var isAvailable = false
    
    init(dic:[String:Any]) {
        super.init()
        status = dic["status"] as? String ?? ""
        date = dic["date"] as? String ?? ""
        isTempBooked = dic["isTempBooked"] as? String ?? ""
        isHoliday = dic["isHoliday"] as? String ?? ""
        isAvailable = dic["isAvailable"] as? Bool ?? false
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class QuestionList:NSObject{
    var id  = ""
    var question = ""
    var queStatus = ""
    var isChecked = false
    var answer = ""
    
    init(dic:[String:Any]) {
        super.init()
        question = dic["question"] as? String ?? ""
        queStatus = dic["queStatus"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        isChecked = dic["isChecked"] as? Bool ?? false
        answer = dic["answer"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class MyServiceCls{
    var serviceList: [ServiceList] = [ServiceList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        serviceList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({ServiceList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class ServiceList:NSObject {
        var id = ""
        var serviceType = ""
        var holidayRate = ""
        var additionalRate = ""
        var latitude = ""
        var longitude = ""
        var dogAgeId = ""
        var cancellationPolicyId = ""
        var desc = ""
        var location = ""
        var price = ""
        var categoryName = ""
        var duration = ""
        var age = ""
        var serviceImagePath = ""
        var serviceImage = ""
        var totalReview = ""
        
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            serviceType = dictionary["serviceType"] as? String ?? ""
            holidayRate = dictionary["holidayRate"] as? String ?? ""
            additionalRate = dictionary["additionalRate"] as? String ?? ""
            latitude = dictionary["latitude"] as? String ?? ""
            longitude = dictionary["longitude"] as? String ?? ""
            dogAgeId = dictionary["dogAgeId"] as? String ?? ""
            cancellationPolicyId = dictionary["cancellationPolicyId"] as? String ?? ""
            desc = dictionary["description"] as? String ?? ""
            price = dictionary["price"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            duration = dictionary["duration"] as? String ?? ""
            age = dictionary["age"] as? String ?? ""
            serviceImagePath = dictionary["serviceImagePath"] as? String ?? ""
            serviceImage = dictionary["serviceImage"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            totalReview = dictionary["totalReview"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.serviceType, forKey: "serviceType")
            dictionary.setValue(self.holidayRate, forKey: "holidayRate")
            dictionary.setValue(self.additionalRate, forKey: "additionalRate")
            dictionary.setValue(self.latitude, forKey: "latitude")
            dictionary.setValue(self.longitude, forKey: "longitude")
            dictionary.setValue(self.dogAgeId, forKey: "dogAgeId")
            dictionary.setValue(self.cancellationPolicyId, forKey: "cancellationPolicyId")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.desc, forKey: "description")
            dictionary.setValue(self.age, forKey: "age")
            dictionary.setValue(self.serviceImagePath, forKey: "serviceImagePath")
            dictionary.setValue(self.serviceImage, forKey: "serviceImage")
            dictionary.setValue(self.totalReview, forKey: "totalReview")
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class ServiceDetail {
    
    var serviceId = "n";
    var profileImg = "";
    var userId = "";
    var serviceType  = "";
    var durationId = "";
    var userName = "";
    var address = "";
    var title = "";
    var description = "";
    var holidayRate = "";
    var additionalRate = "";
    var location = "";
    var longitude = "";
    var latitude = "";
    var pincode = "";
    var cancellationPolicyId = "";
    var createdDate = "";
    var dogAgeId = "";
    var price = "";
    var supervisionTime = "";
    var age = "";
    var cancellationPolicy = "";
    var userProfileImg = "";
    var responseRate = "";
    var responseTime = "";
    var policyURL = "";
    var avgRating = "";
    var duration = "";
    var favStatus = "";
    var userDescription = "";
    var serviceURL = "";
    var serviceImages: [ServiceImages] = [ServiceImages]()
    
    required init(dic: [String:Any]) {
        
        serviceImages = (ResponseKey.fatchDataAsArray(res: dic, valueOf: .serviceImages) ).map({ServiceImages(dic: $0 as! [String:Any])})
        self.serviceId = dic["serviceId"] as? String ?? ""
        self.profileImg = dic["profileImg"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.serviceType = dic["serviceType"] as? String ?? ""
        self.durationId = dic["durationId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.address = dic["address"] as? String ?? ""
        self.title = dic["title"] as? String ?? ""
        self.description = dic["description"] as? String ?? ""
        self.holidayRate = dic["holidayRate"] as? String ?? ""
        self.additionalRate = dic["additionalRate"] as? String ?? ""
        self.location = dic["location"] as? String ?? ""
        self.longitude = dic["longitude"] as? String ?? ""
        self.latitude = dic["latitude"] as? String ?? ""
        self.pincode = dic["pincode"] as? String ?? ""
        self.cancellationPolicyId = dic["cancellationPolicyId"] as? String ?? ""
        self.createdDate = dic["createdDate"] as? String ?? ""
        self.dogAgeId = dic["dogAgeId"] as? String ?? ""
        self.price = dic["price"] as? String ?? ""
        self.supervisionTime = dic["supervisionTime"] as? String ?? ""
        self.age = dic["age"] as? String ?? ""
        self.cancellationPolicy = dic["cancellationPolicy"] as? String ?? ""
        self.userProfileImg = dic["userProfileImg"] as? String ?? ""
        self.responseRate = dic["responseRate"] as? String ?? ""
        self.responseTime = dic["responseTime"] as? String ?? ""
        self.policyURL = dic["policyURL"] as? String ?? ""
        self.avgRating = dic["avgRating"] as? String ?? ""
        self.duration = dic["duration"] as? String ?? ""
        self.favStatus = dic["favStatus"] as? String ?? ""
        self.serviceURL = dic["serviceURL"] as? String ?? ""
        self.userDescription = dic["userDescription"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.serviceId, forKey: "serviceId")
        dictionary.setValue(self.profileImg, forKey: "profileImg")
        dictionary.setValue(self.userId, forKey: "userId")
        dictionary.setValue(self.serviceType, forKey: "serviceType")
        dictionary.setValue(self.durationId, forKey: "durationId")
        dictionary.setValue(self.userName, forKey: "userName")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.holidayRate, forKey: "holidayRate")
        dictionary.setValue(self.additionalRate, forKey: "additionalRate")
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.pincode, forKey: "pincode")
        dictionary.setValue(self.cancellationPolicyId, forKey: "cancellationPolicyId")
        dictionary.setValue(self.createdDate, forKey: "createdDate")
        dictionary.setValue(self.dogAgeId, forKey: "dogAgeId")
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.supervisionTime, forKey: "supervisionTime")
        dictionary.setValue(self.age, forKey: "age")
        dictionary.setValue(self.cancellationPolicy, forKey: "cancellationPolicy")
        dictionary.setValue(self.userProfileImg, forKey: "userProfileImg")
        dictionary.setValue(self.responseRate, forKey: "responseRate")
        dictionary.setValue(self.responseTime, forKey: "responseTime")
        dictionary.setValue(self.policyURL, forKey: "policyURL")
        dictionary.setValue(self.avgRating, forKey: "avgRating")
        dictionary.setValue(self.duration, forKey: "duration")
        dictionary.setValue(self.favStatus, forKey: "favStatus")
        dictionary.setValue(self.serviceURL, forKey: "serviceURL")
        dictionary.setValue(self.userDescription, forKey: "userDescription")
        return dictionary as! [String:Any]
    }
    
    class ServiceImages
    {
        var id = ""
        var serviceId = ""
        var photo = ""
        var imagePath = ""
        
        required init(dic: [String:Any]) {
            self.id = dic["id"] as? String ?? ""
            self.serviceId = dic["serviceId"] as? String ?? ""
            self.photo = dic["photo"] as? String ?? ""
            self.imagePath = dic["imagePath"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.serviceId, forKey: "serviceId")
            dictionary.setValue(self.photo, forKey: "photo")
            dictionary.setValue(self.imagePath, forKey: "imagePath")
            return dictionary as! [String:Any]
        }
    }
    
}


class FavoriteCLS{
    var favList: [FavList] = [FavList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        favList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({FavList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class FavList:NSObject {
        var serviceId = ""
        var serviceType = ""
        var holidayRate = ""
        var additionalRate = ""
        var latitude = ""
        var longitude = ""
        var dogAgeId = ""
        var cancellationPolicyId = ""
        var desc = ""
        var location = ""
        var price = ""
        var categoryName = ""
        var duration = ""
        var age = ""
        var serviceImagePath = ""
        var serviceImage = ""
        var fsid = ""
        var isActive = ""
        var sid = ""
        var stid = ""
        var userId = ""
        
        required init(dictionary: [String:Any]) {
            serviceId = dictionary["serviceId"] as? String ?? ""
            serviceType = dictionary["serviceType"] as? String ?? ""
            holidayRate = dictionary["holidayRate"] as? String ?? ""
            additionalRate = dictionary["additionalRate"] as? String ?? ""
            latitude = dictionary["latitude"] as? String ?? ""
            longitude = dictionary["longitude"] as? String ?? ""
            dogAgeId = dictionary["dogAgeId"] as? String ?? ""
            cancellationPolicyId = dictionary["cancellationPolicyId"] as? String ?? ""
            desc = dictionary["description"] as? String ?? ""
            price = dictionary["price"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            duration = dictionary["duration"] as? String ?? ""
            age = dictionary["age"] as? String ?? ""
            serviceImagePath = dictionary["serviceImagePath"] as? String ?? ""
            serviceImage = dictionary["serviceImage"] as? String ?? ""
            fsid = dictionary["fsid"] as? String ?? ""
            isActive = dictionary["isActive"] as? String ?? ""
            sid = dictionary["sid"] as? String ?? ""
            stid = dictionary["stid"] as? String ?? ""
            userId = dictionary["userId"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.serviceId, forKey: "serviceId")
            dictionary.setValue(self.serviceType, forKey: "serviceType")
            dictionary.setValue(self.holidayRate, forKey: "holidayRate")
            dictionary.setValue(self.additionalRate, forKey: "additionalRate")
            dictionary.setValue(self.latitude, forKey: "latitude")
            dictionary.setValue(self.longitude, forKey: "longitude")
            dictionary.setValue(self.dogAgeId, forKey: "dogAgeId")
            dictionary.setValue(self.cancellationPolicyId, forKey: "cancellationPolicyId")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.price, forKey: "price")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.desc, forKey: "description")
            dictionary.setValue(self.age, forKey: "age")
            dictionary.setValue(self.serviceImagePath, forKey: "serviceImagePath")
            dictionary.setValue(self.serviceImage, forKey: "serviceImage")
            dictionary.setValue(self.fsid, forKey: "fsid")
            dictionary.setValue(self.isActive, forKey: "isActive")
            dictionary.setValue(self.sid, forKey: "sid")
            dictionary.setValue(self.stid, forKey: "stid")
            dictionary.setValue(self.userId, forKey: "userId")
            
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}

class WalletCls{
    var creditAmount : String = ""
    var holdAmount : String = ""
    var redeemAmount : String = ""
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        creditAmount = dictionary["creditAmount"] as? String ?? ""
        holdAmount = dictionary["holdAmount"] as? String ?? ""
        redeemAmount = dictionary["redeemAmount"] as? String ?? ""
    }
}


class RedeemHistoryCLS{
    var redeemList: [RedeemList] = [RedeemList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        redeemList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({RedeemList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class RedeemList:NSObject {
        var id = ""
        var userId = ""
        var amount = ""
        var adminFee = ""
        var status  = ""
        var createdDate = ""
        var redeemDate = ""
        var redeemAmount = ""
    
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            userId = dictionary["userId"] as? String ?? ""
            amount = dictionary["amount"] as? String ?? ""
            adminFee = dictionary["adminFee"] as? String ?? ""
            status = dictionary["status"] as? String ?? ""
            createdDate = dictionary["createdDate"] as? String ?? ""
            redeemDate = dictionary["redeemDate"] as? String ?? ""
            redeemAmount = dictionary["redeemAmount"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.userId, forKey: "userId")
            dictionary.setValue(self.amount, forKey: "amount")
            dictionary.setValue(self.adminFee, forKey: "adminFee")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.redeemDate, forKey: "redeemDate")
            dictionary.setValue(self.redeemAmount, forKey: "redeemAmount")
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}



class PaymentHistoryCLS{
    var paymentList: [PaymentList] = [PaymentList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        paymentList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({PaymentList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class PaymentList:NSObject {
        var id = ""
        var userId = ""
        var amount = ""
        var adminFee = ""
        var status  = ""
        var createdDate = ""
        var bookingId = ""
        var transactionType = ""
        var serviceId = ""
        var transactionId = ""
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            userId = dictionary["userId"] as? String ?? ""
            amount = dictionary["amount"] as? String ?? ""
            adminFee = dictionary["adminFee"] as? String ?? ""
            status = dictionary["status"] as? String ?? ""
            createdDate = dictionary["createdDate"] as? String ?? ""
            bookingId = dictionary["bookingId"] as? String ?? ""
            transactionType = dictionary["transactionType"] as? String ?? ""
            serviceId = dictionary["serviceId"] as? String ?? ""
            transactionId = dictionary["transactionId"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.userId, forKey: "userId")
            dictionary.setValue(self.amount, forKey: "amount")
            dictionary.setValue(self.adminFee, forKey: "adminFee")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.bookingId, forKey: "bookingId")
            dictionary.setValue(self.transactionType, forKey: "transactionType")
            dictionary.setValue(self.serviceId, forKey: "serviceId")
            dictionary.setValue(self.transactionId, forKey: "transactionId")
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class FinancialInfoCls{
    var infoList: [InfoList] = [InfoList]()
    var pagination: Pagination?
    var summary: Summary?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        infoList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({InfoList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
        summary = Summary(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .summary) ))
    }
    
    class InfoList:NSObject {
        var transactionId = ""
        var location = ""
        var categoryName = ""
        var firstName = ""
        var lastName  = ""
        var endDate = ""
        var totalAmount = ""
        var status = ""
         var adminFee = ""
         var adminProviderFee = ""
        
        
        required init(dictionary: [String:Any]) {
            transactionId = dictionary["transactionId"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            firstName = dictionary["firstName"] as? String ?? ""
            lastName = dictionary["lastName"] as? String ?? ""
            endDate = dictionary["endDate"] as? String ?? ""
            totalAmount = dictionary["totalAmount"] as? String ?? ""
            status = dictionary["status"] as? String ?? ""
            adminFee = dictionary["adminFee"] as? String ?? ""
            adminProviderFee = dictionary["adminProviderFee"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.transactionId, forKey: "transactionId")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.firstName, forKey: "firstName")
            dictionary.setValue(self.lastName, forKey: "lastName")
            dictionary.setValue(self.endDate, forKey: "endDate")
            dictionary.setValue(self.totalAmount, forKey: "totalAmount")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.adminFee, forKey: "adminFee")
            dictionary.setValue(self.adminProviderFee, forKey: "adminProviderFee")
            
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : String = ""
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? String ?? ""
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
    class Summary {
         var customer: Customer?
         var trainer: Trainer?
        
        required init(dictionary: [String:Any]) {
            customer = Customer(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .customerData) ))
            trainer = Trainer(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .trainerData) ))
        }
        
    }
    
    class Customer {
        var totalCustCompletedService : String = "0"
        var totalCustomerCommission : String = "0"
        var totalNetPaid : Double = 0
        var totalPaid : String = "0"
        
        
        required init(dictionary: [String:Any]) {
            totalCustCompletedService = dictionary["totalCustCompletedService"] as? String ?? "0"
            totalCustomerCommission = dictionary["totalCustomerCommission"] as? String ?? "0"
            totalNetPaid = dictionary["totalNetPaid"] as? Double ?? 0
            totalPaid = dictionary["totalPaid"] as? String ?? "0"
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.totalCustCompletedService, forKey: "totalCustCompletedService")
            dictionary.setValue(self.totalCustomerCommission, forKey: "totalCustomerCommission")
            dictionary.setValue(self.totalNetPaid, forKey: "totalNetPaid")
            dictionary.setValue(self.totalPaid, forKey: "totalPaid")
            
            return dictionary as! [String:Any]
        }
    }
        
        class Trainer {
            var totalCompletedService : String = ""
            var totalEarned : String = ""
            var totalCommission : String = "0"
            var totalNetEarned : Double = 0
            
            
            required init(dictionary: [String:Any]) {
                totalCompletedService = dictionary["totalCompletedService"] as? String ?? "0"
                totalEarned = dictionary["totalEarned"] as? String ?? "0"
                totalCommission = dictionary["totalCommission"] as? String ?? "0"
                totalNetEarned = dictionary["totalNetEarned"] as? Double ?? 0
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.totalCompletedService, forKey: "totalCompletedService")
                dictionary.setValue(self.totalEarned, forKey: "totalEarned")
                dictionary.setValue(self.totalCommission, forKey: "totalCommission")
                dictionary.setValue(self.totalNetEarned, forKey: "totalNetEarned")
                
                return dictionary as! [String:Any]
            }
    }
    
}


class InboxList:NSObject{
    var userId  = ""
    var userPhoto = ""
    var fullName = ""
    var totUnread = ""
    var lastMsg = ""
    var msgDate = ""
    
    init(dic:[String:Any]) {
        super.init()
        userId = dic["userId"] as? String ?? ""
        userPhoto = dic["userPhoto"] as? String ?? ""
        fullName = dic["fullName"] as? String ?? ""
        totUnread = dic["totUnread"] as? String ?? ""
        lastMsg = dic["lastMsg"] as? String ?? ""
        msgDate = dic["msgDate"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class InboxConversationCls{
    var chatList: [ChatList] = [ChatList]()
    var pagination: Pagination?
    
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        chatList = (ResponseKey.fatchDataAsArray(res: dictionary["data"] as! dictionary, valueOf: .messages) ).map({ChatList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
        
    }
    
    class ChatList:NSObject {
        var senderId = ""
        var receiverId = ""
        var msgId = ""
        var msgDate = ""
        var msgType  = ""
        var message = ""
        var isSender = ""
        var downloadUrl = ""
        var senderInfo: SenderInfo?
        var receiverInfo: ReceiverInfo?
        
        required init(dictionary: [String:Any]) {
            senderInfo = SenderInfo(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .senderInfo) ))
            receiverInfo = ReceiverInfo(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .receiverInfo) ))
            senderId = dictionary["senderId"] as? String ?? ""
            receiverId = dictionary["receiverId"] as? String ?? ""
            msgId = dictionary["msgId"] as? String ?? ""
            msgDate = dictionary["msgDate"] as? String ?? ""
            msgType = dictionary["msgType"] as? String ?? ""
            message = dictionary["message"] as? String ?? ""
            isSender = dictionary["isSender"] as? String ?? ""
            downloadUrl = dictionary["downloadUrl"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.senderId, forKey: "senderId")
            dictionary.setValue(self.receiverId, forKey: "receiverId")
            dictionary.setValue(self.msgId, forKey: "msgId")
            dictionary.setValue(self.msgDate, forKey: "msgDate")
            dictionary.setValue(self.msgType, forKey: "msgType")
            dictionary.setValue(self.message, forKey: "message")
            dictionary.setValue(self.isSender, forKey: "isSender")
            dictionary.setValue(self.downloadUrl, forKey: "downloadUrl")
            
            
            return dictionary as! [String:Any]
        }
        
        class SenderInfo {
            var senderId : String = ""
            var fullName : String = ""
            var profileImg : String = ""
            
            required init(dictionary: [String:Any]) {
                senderId = dictionary["senderId"] as? String ?? ""
                fullName = dictionary["fullName"] as? String ?? ""
                profileImg = dictionary["profileImg"] as? String ?? ""
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.senderId, forKey: "senderId")
                dictionary.setValue(self.fullName, forKey: "fullName")
                dictionary.setValue(self.profileImg, forKey: "profileImg")
                return dictionary as! [String:Any]
            }
            
        }
        
        class ReceiverInfo {
            var receiverId : String = ""
            var fullName : String = ""
            var profileImg : String = ""
            
            required init(dictionary: [String:Any]) {
                receiverId = dictionary["receiverId"] as? String ?? ""
                fullName = dictionary["fullName"] as? String ?? ""
                profileImg = dictionary["profileImg"] as? String ?? ""
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.receiverId, forKey: "receiverId")
                dictionary.setValue(self.fullName, forKey: "fullName")
                dictionary.setValue(self.profileImg, forKey: "profileImg")
                return dictionary as! [String:Any]
            }
            
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
    
    
}



class SentRequestCls{
    var requestList: [RequestList] = [RequestList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        requestList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({RequestList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class RequestList:NSObject {
        var paymentURL = ""
        var requestId = ""
        var serviceId = ""
        var categoryName = ""
        var userId = ""
        var location = ""
        var extraStatus = ""
        var profileImg = ""
        var firstName = ""
        var id = ""
        var serviceCharge = ""
        var totalAmount = ""
        var adminFee = ""
        var additionalDogRate = ""
        var fromDate = ""
        var fromTime = ""
        var toDate = ""
        var toTime = ""
        var status = ""
        var isPaid = ""
        var isCompleteByDogsitter = ""
        var userProfileImg = ""
        var isAnswers = ""
        var isReview = ""
        
        required init(dictionary: [String:Any]) {
            paymentURL = dictionary["paymentURL"] as? String ?? ""
            serviceId = dictionary["serviceId"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            userId = dictionary["userId"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            
            profileImg = dictionary["profileImg"] as? String ?? ""
            firstName = dictionary["firstName"] as? String ?? ""
            id = dictionary["id"] as? String ?? ""
            serviceCharge = dictionary["serviceCharge"] as? String ?? ""
            totalAmount = dictionary["totalAmount"] as? String ?? ""
            adminFee = dictionary["adminFee"] as? String ?? ""
            additionalDogRate = dictionary["additionalDogRate"] as? String ?? ""
            fromDate = dictionary["fromDate"] as? String ?? ""
            fromTime = dictionary["fromTime"] as? String ?? ""
            toDate = dictionary["toDate"] as? String ?? ""
            toTime = dictionary["toTime"] as? String ?? ""
            status = dictionary["status"] as? String ?? ""
            isPaid = dictionary["isPaid"] as? String ?? ""
            isCompleteByDogsitter = dictionary["isCompleteByDogsitter"] as? String ?? ""
            userProfileImg = dictionary["userProfileImg"] as? String ?? ""
            requestId = dictionary["requestId"] as? String ?? ""
            extraStatus = dictionary["extraStatus"] as? String ?? ""
            isReview = dictionary["isReview"] as? String ?? ""
            isAnswers = dictionary["isAnswers"] as? String ?? ""
           
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.paymentURL, forKey: "paymentURL")
            dictionary.setValue(self.serviceId, forKey: "serviceId")
            dictionary.setValue(self.firstName, forKey: "firstName")
            dictionary.setValue(self.location, forKey: "location")
            dictionary.setValue(self.userId, forKey: "userId")
            
            dictionary.setValue(self.profileImg, forKey: "profileImg")
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.serviceCharge, forKey: "serviceCharge")
            dictionary.setValue(self.totalAmount, forKey: "totalAmount")
            dictionary.setValue(self.adminFee, forKey: "adminFee")
            dictionary.setValue(self.additionalDogRate, forKey: "additionalDogRate")
            dictionary.setValue(self.fromDate, forKey: "fromDate")
            dictionary.setValue(self.fromTime, forKey: "fromTime")
            dictionary.setValue(self.toDate, forKey: "toDate")
            dictionary.setValue(self.toTime, forKey: "toTime")
            dictionary.setValue(self.status, forKey: "status")
            dictionary.setValue(self.isPaid, forKey: "isPaid")
            dictionary.setValue(self.isCompleteByDogsitter, forKey: "isCompleteByDogsitter")
            dictionary.setValue(self.userProfileImg, forKey: "userProfileImg")
           dictionary.setValue(self.requestId, forKey: "requestId")
            dictionary.setValue(self.extraStatus, forKey: "extraStatus")
            dictionary.setValue(self.isReview, forKey: "isReview")
            dictionary.setValue(self.isAnswers, forKey: "isAnswers")
            
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class NotificationTypeList:NSObject{
    var id  = ""
    var userType = ""
    var notiType = ""
    var notiTitle = ""
    var isVisible = ""
    var createdDate = ""
    var isEnabled = ""
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        userType = dic["userType"] as? String ?? ""
        notiType = dic["notiType"] as? String ?? ""
        notiTitle = dic["notiTitle"] as? String ?? ""
        isVisible = dic["isVisible"] as? String ?? ""
        createdDate = dic["createdDate"] as? String ?? ""
        isEnabled = dic["isEnabled"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}


class NotificationCls{
    var notificationList: [NotificationList] = [NotificationList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        notificationList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({NotificationList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class NotificationList:NSObject {
        var id = ""
        var toUserId = ""
        var fromUserId = ""
        var notiTypeId = ""
        var referenceId = ""
        var notification = ""
        var isReaded = ""
        var createdDate = ""
        var readedDate = ""
        var ipAddress = ""
        var fullName = ""
        var time_ago = ""
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            toUserId = dictionary["toUserId"] as? String ?? ""
            fromUserId = dictionary["fromUserId"] as? String ?? ""
            notiTypeId = dictionary["notiTypeId"] as? String ?? ""
            referenceId = dictionary["referenceId"] as? String ?? ""
            
            notification = dictionary["notification"] as? String ?? ""
            isReaded = dictionary["isReaded"] as? String ?? ""
            createdDate = dictionary["createdDate"] as? String ?? ""
            readedDate = dictionary["readedDate"] as? String ?? ""
            ipAddress = dictionary["ipAddress"] as? String ?? ""
            fullName = dictionary["fullName"] as? String ?? ""
            time_ago = dictionary["time_ago"] as? String ?? ""
        
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.toUserId, forKey: "toUserId")
            dictionary.setValue(self.fromUserId, forKey: "fromUserId")
            dictionary.setValue(self.notiTypeId, forKey: "notiTypeId")
            dictionary.setValue(self.referenceId, forKey: "referenceId")
            
            dictionary.setValue(self.notification, forKey: "notification")
            dictionary.setValue(self.isReaded, forKey: "isReaded")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.readedDate, forKey: "readedDate")
            dictionary.setValue(self.ipAddress, forKey: "ipAddress")
            dictionary.setValue(self.fullName, forKey: "fullName")
             dictionary.setValue(self.time_ago, forKey: "time_ago")
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}


class TestiMonialList:NSObject{
    var id  = ""
    var userName = ""
    var desc = ""
    var ratting = ""
    var serviceId = ""
    var categoryName = ""
    var profileImg = ""
    var createdDate = ""
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        userName = dic["userName"] as? String ?? ""
        desc = dic["description"] as? String ?? ""
        ratting = dic["ratting"] as? String ?? ""
        serviceId = dic["serviceId"] as? String ?? ""
        categoryName = dic["categoryName"] as? String ?? ""
        profileImg = dic["profileImg"] as? String ?? ""
        createdDate = dic["createdDate"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}




class ServiceDetailReviewCls{
    var detailReviewList: [DetailReviewList] = [DetailReviewList]()
    var pagination: Pagination?
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        detailReviewList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({DetailReviewList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
    }
    
    class DetailReviewList:NSObject {
        var id  = ""
        var userName = ""
        var desc = ""
        var ratting = ""
        var serviceId = ""
        var categoryName = ""
        var profileImg = ""
        var createdDate = ""
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            userName = dictionary["userName"] as? String ?? ""
            desc = dictionary["description"] as? String ?? ""
            ratting = dictionary["ratting"] as? String ?? ""
            serviceId = dictionary["serviceId"] as? String ?? ""
            categoryName = dictionary["categoryName"] as? String ?? ""
            profileImg = dictionary["profileImg"] as? String ?? ""
            createdDate = dictionary["createdDate"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.userName, forKey: "userName")
            dictionary.setValue(self.description, forKey: "description")
            dictionary.setValue(self.ratting, forKey: "ratting")
            dictionary.setValue(self.serviceId, forKey: "serviceId")
            
            dictionary.setValue(self.categoryName, forKey: "categoryName")
            dictionary.setValue(self.profileImg, forKey: "profileImg")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
         
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
}



class ContentPage:NSObject{
    var pageURL  = ""
    var pId = ""
    var pageName = ""
    var pageTitle = ""
    var metaKeyword = ""
    var pageDesc = ""
    var page_slug = ""
    
    init(dic:[String:Any]) {
        super.init()
        pageURL = dic["pageURL"] as? String ?? ""
        pId = dic["pId"] as? String ?? ""
        pageName = dic["pageName"] as? String ?? ""
        pageTitle = dic["pageTitle"] as? String ?? ""
        metaKeyword = dic["metaKeyword"] as? String ?? ""
        pageDesc = dic["pageDesc"] as? String ?? ""
        page_slug = dic["page_slug"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}



class TestimonialClass{
    var testList: [TestList] = [TestList]()
    var pagination: Pagination?
   
    
    required init(dictionary: [String:Any]) {
        print(dictionary)
        
        testList = (ResponseKey.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({TestList(dictionary: $0 as! [String:Any])})
        pagination = Pagination(dictionary: (ResponseKey.fatchDataAsDictionary(res: dictionary, valueOf: .pagination) ))
      
    }
    
    class TestList:NSObject {
        var id = ""
        var message = ""
        var createdDate = ""
        var userName = ""
        var email  = ""
        
        required init(dictionary: [String:Any]) {
            id = dictionary["id"] as? String ?? ""
            message = dictionary["message"] as? String ?? ""
            createdDate = dictionary["createdDate"] as? String ?? ""
            userName = dictionary["userName"] as? String ?? ""
            email = dictionary["email"] as? String ?? ""
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.message, forKey: "message")
            dictionary.setValue(self.createdDate, forKey: "createdDate")
            dictionary.setValue(self.userName, forKey: "userName")
            dictionary.setValue(self.email, forKey: "email")
            
            return dictionary as! [String:Any]
        }
        
    }
    class Pagination {
        var numPages : Int = 0
        var page : Int = 0
        var totalRecords : Int = 0
        
        required init(dictionary: [String:Any]) {
            numPages = dictionary["numPages"] as? Int ?? 0
            page = dictionary["page"] as? Int ?? 0
            totalRecords = dictionary["totalRecords"] as? Int ?? 0
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.numPages, forKey: "numPages")
            dictionary.setValue(self.page, forKey: "page")
            dictionary.setValue(self.totalRecords, forKey: "totalRecords")
            return dictionary as! [String:Any]
        }
        
    }
    
    
}
