//
//  DataModel.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

class User:Codable {
    var userid : String
    var name : String
    var email : String
    var avatar : String
    var avatar_100x_100 : String
    var device_id : String
    var slug : String
    var user_facebook_link : String
    var user_twitter_link : String
    var user_google_link : String
    var about_me : String
    var user_location : String
    var user_mobile_no : String
    var date_of_birth : String
    var gender : String
    var date_of_birth_formatted : String
    var organisation : String
    var website : String
    var address : String
    var remember_token : String
    var language : String
    var is_admin_active : String
    var is_verify : String
    var sign_up_type : String
    var activation_key : String
    var ip_address : String
    var is_reset_pass_request : String
    var reset_pass_token : String
    var created_at : String
    var created_at_formatted : String
    var paypal_email : String
    
    init(dictionary: [String:Any]) {
        userid = dictionary["userid",""]
        name = dictionary["name"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        avatar = dictionary["avatar"] as? String ?? ""
        avatar_100x_100 = dictionary["avatar_100x_100"] as? String ?? ""
        device_id = dictionary["device_id"] as? String ?? ""
        slug = dictionary["slug"] as? String ?? ""
        user_facebook_link = dictionary["user_facebook_link"] as? String ?? ""
        user_twitter_link = dictionary["user_twitter_link"] as? String ?? ""
        user_google_link = dictionary["user_google_link"] as? String ?? ""
        about_me = dictionary["about_me"] as? String ?? ""
        user_location = dictionary["user_location"] as? String ?? ""
        user_mobile_no = dictionary["user_mobile_no"] as? String ?? ""
        date_of_birth = dictionary["date_of_birth"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
        date_of_birth_formatted = dictionary["date_of_birth_formatted"] as? String ?? ""
        organisation = dictionary["organisation"] as? String ?? ""
        website = dictionary["website"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        remember_token = dictionary["remember_token"] as? String ?? ""
        language = dictionary["language"] as? String ?? ""
        is_admin_active = dictionary["is_admin_active"] as? String ?? ""
        is_verify = dictionary["is_verify"] as? String ?? ""
        sign_up_type = dictionary["sign_up_type"] as? String ?? ""
        activation_key = dictionary["activation_key"] as? String ?? ""
        ip_address = dictionary["ip_address"] as? String ?? ""
        is_reset_pass_request = dictionary["is_reset_pass_request"] as? String ?? ""
        reset_pass_token = dictionary["reset_pass_token"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        paypal_email = dictionary["paypal_email"] as? String ?? ""
    }
    
    private func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    private func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
    var convertToDictionary: [String: Any]? {
        let text = try? self.jsonString()
        if let data = text?.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}


class UserAutoLoginData {
    var password : String = ""
    var email : String = ""
    
    init(dictionary: [String:Any]) {
        password = dictionary["password"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        var dictionary:dictionary = [:]
        dictionary["email"] = self.email
        dictionary["password"] = self.password
        return dictionary
    }
    
}


//class Organizer {
//    var organizer_id:String
//    var id : Int
//    var userid : Int
//    var name : String
//    var organizer_desc : String
//    var website : String
//    var fb_link : String
//    var twitter_link : String
//    var link_in_link : String
//    var image : String
//    var created_at : String
//    var created_at_formatted : String
//    var updated_at : String
//    var updated_at_formatted : String
//    var isSelected:Bool = false  //Custom variable
//
//    init(dictionary: [String:Any]) {
//        organizer_id = dictionary["organizer_id",""]
//        id = dictionary["id"] as? Int ?? 0
//        userid = dictionary["userid"] as? Int ?? 0
//        name = dictionary["name"] as? String ?? ""
//        organizer_desc = dictionary["organizer_desc"] as? String ?? ""
//        website = dictionary["website"] as? String ?? ""
//        fb_link = dictionary["fb_link"] as? String ?? ""
//        twitter_link = dictionary["twitter_link"] as? String ?? ""
//        link_in_link = dictionary["link_in_link"] as? String ?? ""
//        image = dictionary["image"] as? String ?? ""
//        created_at = dictionary["created_at"] as? String ?? ""
//        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
//        updated_at = dictionary["updated_at"] as? String ?? ""
//        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
//
//    }
//
//    func dictionaryRepresentation() -> [String:Any] {
//        let dictionary = NSMutableDictionary()
//        dictionary.setValue(self.organizer_id, forKey: "organizer_id")
//        dictionary.setValue(self.id, forKey: "id")
//        dictionary.setValue(self.userid, forKey: "userid")
//        dictionary.setValue(self.name, forKey: "name")
//        dictionary.setValue(self.organizer_desc, forKey: "organizer_desc")
//        dictionary.setValue(self.website, forKey: "website")
//        dictionary.setValue(self.fb_link, forKey: "fb_link")
//        dictionary.setValue(self.twitter_link, forKey: "twitter_link")
//        dictionary.setValue(self.link_in_link, forKey: "link_in_link")
//        dictionary.setValue(self.image, forKey: "image")
//        dictionary.setValue(self.created_at, forKey: "created_at")
//        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
//        dictionary.setValue(self.updated_at, forKey: "updated_at")
//        dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
//
//        return dictionary as! [String:Any]
//    }
//
//}

class Language {
    var id : Int
    var language_name : String
    var lang_code : String
    var language_icon : String
    var isactive : String
    var createddate : String
    var createddate_formatted : String
    var updatedDate : String
    var updatedDate_formatted : String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        language_name = dictionary["language_name"] as? String ?? ""
        lang_code = dictionary["lang_code"] as? String ?? ""
        language_icon = dictionary["language_icon"] as? String ?? ""
        isactive = dictionary["isactive"] as? String ?? ""
        createddate = dictionary["createddate"] as? String ?? ""
        createddate_formatted = dictionary["createddate_formatted"] as? String ?? ""
        updatedDate = dictionary["updatedDate"] as? String ?? ""
        updatedDate_formatted = dictionary["updatedDate_formatted"] as? String ?? ""
    }
    
}


//class Ticket {
//    var ticket_id: String
//    var id : Int
//    var userid : Int
//    var ticket_price_type : String
//    var ticket_name : String
//    var ticket_qty : Int
//    var ticket_type : String
//    var ticket_price : String
//    var ticket_last_date : String
//    var created_at : String
//    var created_at_formatted : String
//    var updated_at : String
//    var updated_at_formatted : String
//
//    var isSelected:Bool = false //Custom variable
//
//    init(dictionary: [String:Any]) {
//        ticket_id = dictionary["ticket_id",""]
//        id = dictionary["id"] as? Int ?? 0
//        userid = dictionary["userid"] as? Int ?? 0
//        ticket_price_type = dictionary["ticket_price_type"] as? String ?? ""
//        ticket_name = dictionary["ticket_name"] as? String ?? ""
//        ticket_qty = dictionary["ticket_qty"] as? Int ?? 0
//        ticket_type = dictionary["ticket_type"] as? String ?? ""
//        ticket_price = dictionary["ticket_price","0"] //Cast dictionary value in String
//        ticket_last_date = dictionary["ticket_last_date"] as? String ?? ""
//        created_at = dictionary["created_at"] as? String ?? ""
//        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
//        updated_at = dictionary["updated_at"] as? String ?? ""
//        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
//    }
//
//    func dictionaryRepresentation() -> [String:Any] {
//        let dictionary = NSMutableDictionary()
//        dictionary.setValue(self.ticket_id, forKey: "ticket_id")
//        dictionary.setValue(self.id, forKey: "id")
//        dictionary.setValue(self.userid, forKey: "userid")
//        dictionary.setValue(self.ticket_price_type, forKey: "ticket_price_type")
//        dictionary.setValue(self.ticket_name, forKey: "ticket_name")
//        dictionary.setValue(self.ticket_qty, forKey: "ticket_qty")
//        dictionary.setValue(self.ticket_type, forKey: "ticket_type")
//        dictionary.setValue(self.ticket_price, forKey: "ticket_price")
//        dictionary.setValue(self.ticket_last_date, forKey: "ticket_last_date")
//        dictionary.setValue(self.created_at, forKey: "created_at")
//        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
//        dictionary.setValue(self.updated_at, forKey: "updated_at")
//        dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
//
//        return dictionary as! [String:Any]
//    }
//
//}


class Category {
    var id : Int
    var category_name : String
    var category_desc : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    var isChecked = false
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        category_name = dictionary["category_name"] as? String ?? ""
        category_desc = dictionary["category_desc"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
        
    }
    
}

class SubCategory {
    var id : Int
    var cat_id : Int
    var sub_category_name : String
    var sub_category_desc : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    var isChecked = false
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        cat_id = dictionary["cat_id"] as? Int ?? 0
        sub_category_name = dictionary["sub_category_name"] as? String ?? ""
        sub_category_desc = dictionary["sub_category_desc"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
    }
    
}

class EventType {
    var id : Int
    var type_name : String
    var type_desc : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    var isChecked = false
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        type_name = dictionary["type_name"] as? String ?? ""
        type_desc = dictionary["type_desc"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
    }
    
}


class Country {
    var id : Int
    var countryName : String
    var Currency : String
    var CurrencyCode : String
    var phonecode : String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        countryName = dictionary["countryName"] as? String ?? ""
        Currency = dictionary["Currency"] as? String ?? ""
        CurrencyCode = dictionary["CurrencyCode"] as? String ?? ""
        phonecode = dictionary["phonecode"] as? String ?? ""
    }
    
}


class State {
    var id : Int
    var CountryID : Int
    var stateName : String
    var Code : String
    var createdDate : String
    var createdDate_formatted : String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        CountryID = dictionary["CountryID"] as? Int ?? 0
        stateName = dictionary["stateName"] as? String ?? ""
        Code = dictionary["Code"] as? String ?? ""
        createdDate = dictionary["createdDate"] as? String ?? ""
        createdDate_formatted = dictionary["createdDate_formatted"] as? String ?? ""
    }
    
}


class City {
    var id : Int
    var CountryID : Int
    var StateID : Int
    var cityName : String
    var Latitude : String
    var Longitude : String
    var TimeZone : String
    var County : String
    var createdDate : String
    var createdDate_formatted : String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        CountryID = dictionary["CountryID"] as? Int ?? 0
        StateID = dictionary["StateID"] as? Int ?? 0
        cityName = dictionary["cityName"] as? String ?? ""
        Latitude = dictionary["Latitude","0"]
        Longitude = dictionary["Longitude","0"]
        TimeZone = dictionary["TimeZone"] as? String ?? ""
        County = dictionary["County"] as? String ?? ""
        createdDate = dictionary["createdDate"] as? String ?? ""
        createdDate_formatted = dictionary["createdDate_formatted"] as? String ?? ""
    }
    
}


class BackImages {
    var back_image : String
    var event_id : String
    var id: String
    var type : String
    
    
    var isSelected:Bool = false //Custom variable
    
    init(dictionary: [String:Any]) {
        id = dictionary["id",""]
        event_id = dictionary["event_id",""]
        back_image = dictionary["back_image"] as? String ?? ""
        type = dictionary["type"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.event_id, forKey: "event_id")
        dictionary.setValue(self.back_image, forKey: "back_image")
        dictionary.setValue(self.type, forKey: "type")
        
        
        return dictionary as! [String:Any]
    }
}


class EventInvites {
    var id : String
    var event_id : String
    var userid: String
    var email : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    
    var isSelected:Bool = false //Custom variable
    
    init(dictionary: [String:Any]) {
        id = dictionary["id",""]
        event_id = dictionary["event_id",""]
        userid = dictionary["userid",""]
        email = dictionary["email",""]
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.event_id, forKey: "event_id")
        dictionary.setValue(self.userid, forKey: "userid")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
        
        return dictionary as! [String:Any]
    }
}


class CreateEvent {
    
    var logo: String = ""//no_image
    var event_logo: UIImage?
    var event_logo_name: String = "image.jpg"
    
    var userid: String
    var event_title: String
    var event_type_id: String
    var category_id: String
    var sub_cat_id: String
    var event_desc: String
    var is_online: String
    var event_privacy: String
    var event_start_datetime: String
    var event_end_datetime: String
    var website: String
    var event_addr_1: String
    var event_addr_2: String
    var event_country_id: String
    var event_state_id: String
    var event_city_id: String
    var event_pincode: String
    var event_lat: String
    var event_long: String
    var ticketsArray: [MyTicketsCls.List]
    var organizersArray: [MyOrgenizersCls.List]
    var getEventInvites: [EventInvites]
    
    var organizer_ids: String
    var ticket_ids: String
    var invite_user_emails: String
    
    var event_type: String = ""
    var category: String = ""
    var sub_cat: String = ""
    
    var event_country = ""
    var event_state = ""
    var event_city = ""
    
    var event_slug = ""
    
    init(with responseData: [String:Any] = [:]) {
        userid = responseData["userid",""]
        event_title = responseData["title"] as? String ?? ""
        event_type_id = responseData["event_type_id",""]
        category_id = responseData["category_id",""]
        sub_cat_id = responseData["sub_cat_id",""]
        event_desc = responseData["event_desc"] as? String ?? ""
        is_online = responseData["is_online"] as? String ?? ""
        event_privacy = responseData["event_privacy"] as? String ?? ""
        event_start_datetime = responseData["event_start_time"] as? String ?? ""
        event_end_datetime = responseData["event_end_time"] as? String ?? ""
        website = responseData["website"] as? String ?? ""
        event_addr_1 = responseData["add_line_1"] as? String ?? ""
        event_addr_2 = responseData["add_line_2"] as? String ?? ""
        event_country_id = responseData["country_id",""]
        event_state_id = responseData["state_id",""]
        event_city_id = responseData["city_id",""]
        event_pincode = responseData["zipcode",""]
        event_lat = responseData["event_lat"] as? String ?? ""
        event_long = responseData["event_long"] as? String ?? ""
        //ticketsArray = (responseData["ticketsArray"] as? [dictionary] ?? []).map({ Ticket(dictionary: $0 as [String:Any]) })
        //organizersArray = (responseData["organizersArray"] as? [dictionary] ?? []).map({ Organizer(dictionary: $0 as [String:Any]) })
        ticketsArray = (responseData["ticketsArray"] as? [dictionary] ?? []).map({
            let ticket = MyTicketsCls.List(dictionary: $0); ticket.isSelected = true; return ticket
        })
        organizersArray = (responseData["organizersArray"] as? [dictionary] ?? []).map({
            let org = MyOrgenizersCls.List(dictionary: $0); org.isSelected = true; return org
        })
        getEventInvites = (responseData["getEventInvites"] as? [dictionary] ?? []).map({
            let invitee = EventInvites(dictionary: $0); invitee.isSelected = true; return invitee
        })
        
//        ticket_ids = (ticketsArray.map({String($0.id)})).joined(separator: ",")
//        organizer_ids = (organizersArray.map({String($0.id)})).joined(separator: ",")
        ticket_ids = (ticketsArray.map({String($0.ticket_id)})).joined(separator: ",")
        organizer_ids = (organizersArray.map({String($0.organizer_id)})).joined(separator: ",")
        invite_user_emails = (getEventInvites.map({String($0.email)})).joined(separator: ",")
        
        event_slug = responseData["event_slug",""]
        
        event_country = responseData["countryName",""]
        event_state = responseData["stateName",""]
        event_city = responseData["cityName",""]
        
        event_type = responseData["event_type_name",""]
        category = responseData["category_name",""]
        sub_cat = responseData["sub_category_name",""]
        
        logo = responseData["logo",""]
    }
    
    init(dictionary: [String:Any]) {
        userid = dictionary["userid"] as? String ?? ""
        event_title = dictionary["event_title"] as? String ?? ""
        event_type_id = dictionary["event_type_id"] as? String ?? ""
        category_id = dictionary["category_id"] as? String ?? ""
        sub_cat_id = dictionary["sub_cat_id"] as? String ?? ""
        event_desc = dictionary["event_desc"] as? String ?? ""
        is_online = dictionary["is_online"] as? String ?? ""
        event_privacy = dictionary["event_privacy"] as? String ?? ""
        event_start_datetime = dictionary["event_start_datetime"] as? String ?? ""
        event_end_datetime = dictionary["event_end_datetime"] as? String ?? ""
        website = dictionary["website"] as? String ?? ""
        event_addr_1 = dictionary["event_addr_1"] as? String ?? ""
        event_addr_2 = dictionary["event_addr_2"] as? String ?? ""
        event_country_id = dictionary["event_country_id"] as? String ?? ""
        event_state_id = dictionary["event_state_id"] as? String ?? ""
        event_city_id = dictionary["event_city_id"] as? String ?? ""
        event_pincode = dictionary["event_pincode"] as? String ?? ""
        event_lat = dictionary["event_lat"] as? String ?? ""
        event_long = dictionary["event_long"] as? String ?? ""
        
        ticket_ids = dictionary["ticket_ids"] as? String ?? ""
        organizer_ids = dictionary["organizer_ids"] as? String ?? ""
        invite_user_emails = dictionary["invite_user_emails"] as? String ?? ""
        
        ticketsArray = []
        organizersArray = []
        getEventInvites = []
    }
    
    var dictionaryRepresent:dictionary{
        var dic: dictionary = [:]
        
        dic["userid"] = self.userid
        dic["event_title"] = self.event_title
        dic["event_type_id"] = self.event_type_id
        dic["category_id"] = self.category_id
        dic["sub_cat_id"] = self.sub_cat_id
        dic["event_desc"] = self.event_desc
        dic["is_online"]  = self.is_online
        dic["event_privacy"]  = self.event_privacy
        dic["event_start_datetime"]  = self.event_start_datetime
        dic["event_end_datetime"]  = self.event_end_datetime
        dic["website"]  = self.website
        dic["event_addr_1"]  = self.event_addr_1
        dic["event_addr_2"]  = self.event_addr_2
        dic["event_country_id"]  = self.event_country_id
        dic["event_state_id"]  = self.event_state_id
        dic["event_city_id"]  = self.event_city_id
        dic["event_pincode"]  = self.event_pincode
        dic["event_lat"]  = self.event_lat
        dic["event_long"]  = self.event_long
        dic["ticket_ids"]  = self.ticket_ids
        dic["organizer_ids"]  = self.organizer_ids
        
        dic["event_slug"]  = self.event_slug
        dic["invite_user_emails"] = self.invite_user_emails
        return dic
    }
    
}

class EventList:NSObject {
    var event_slug = ""
    var event_detail_share_url:  String
    var id : String
    var userid : String
    var title : String
    var slug : String
    var event_desc : String
    var logo : String
    var logo_100x_100 : String
    var logo_300x_300 : String
    var logo_500x_500 : String
    var back_image : String
    var back_image_100x_100 : String
    var back_image_300x_300 : String
    var back_image_500x_500 : String
    var category_id : Int
    var category_name : String
    var category_desc : String
    var sub_cat_id : Int
    var sub_category_name : String
    var sub_category_desc : String
    var event_start_time : String
    var event_start_time_formatted : String
    var event_end_time : String
    var event_end_time_formatted : String
    var website : String
    var add_line_1 : String
    var add_line_2 : String
    var country_id : Int
    var countryName : String
    var state_id : Int
    var stateName : String
    var city_id : Int
    var cityName : String
    var zipcode : String
    var event_lat : String
    var event_long : String
    var is_online : String
    var event_privacy : String
    var is_admin_approved : String
    var is_active : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    var event_type_id : Int
    var event_type_name : String
    var event_type_desc : String
    var user_name : String
    var userslug : String
    var avatar : String
    var avatar_100x_100 : String
    var avatar_200x_200 : String
    var avatar_350x_350 : String
    var is_user_like : String
    var minticketamount: String
    var ticketsArray: [MyTicketsCls.List] = []
    var organizersArray: [MyOrgenizersCls.List] = []
    var getEventInvites: [EventInvites] = []
    var getAllBackImages: [BackImages] = []
    var checkLoggedUserFollow : String
    var event_csv_download_link : String
    var totaleventbooked : String
    var ticket_price_type : String
    var currency_sign_symbol: String
    var is_past: String
    var totaltickets: String
    var totalBookedTickets: String
    
    init(dictionary: [String:Any]) {
        
        totaltickets = dictionary["totaltickets","0"]
        totalBookedTickets = dictionary["totalBookedTickets","0"]
        
        ticketsArray = (Response.fatchDataAsArray(res: dictionary, valueOf: .ticketsArray) ).map({MyTicketsCls.List(dictionary: $0 as! [String:Any])})
        organizersArray = (Response.fatchDataAsArray(res: dictionary, valueOf: .organizersArray) ).map({MyOrgenizersCls.List(dictionary: $0 as! [String:Any])})
        getEventInvites = (dictionary["getEventInvites"] as? [dictionary] ?? []).map({
            let invitee = EventInvites(dictionary: $0); invitee.isSelected = true; return invitee
        })
        getAllBackImages = (Response.fatchDataAsArray(res: dictionary, valueOf: .getAllBackImages) ).map({BackImages(dictionary: $0 as! [String:Any])})
    
        event_detail_share_url = dictionary["event_detail_share_url",""]
        id = dictionary["id",""]
        userid = dictionary["userid",""]
        title = dictionary["title"] as? String ?? ""
        slug = dictionary["slug"] as? String ?? ""
        event_slug = dictionary["slug",""]
        event_desc = dictionary["event_desc"] as? String ?? ""
        logo = dictionary["logo"] as? String ?? ""
        logo_100x_100 = dictionary["logo_100x_100"] as? String ?? ""
        logo_300x_300 = dictionary["logo_300x_300"] as? String ?? ""
        logo_500x_500 = dictionary["logo_500x_500"] as? String ?? ""
        back_image = dictionary["back_image"] as? String ?? ""
        back_image_100x_100 = dictionary["back_image_100x_100"] as? String ?? ""
        back_image_300x_300 = dictionary["back_image_300x_300"] as? String  ?? ""
        back_image_500x_500 = dictionary["back_image_500x_500"] as? String  ?? ""
        category_id = dictionary["category_id"] as? Int ?? 0
        category_name = dictionary["category_name"] as? String ?? ""
        category_desc = dictionary["category_desc"] as? String ?? ""
        sub_cat_id = dictionary["sub_cat_id"] as? Int ?? 0
        sub_category_name = dictionary["sub_category_name"] as? String ?? ""
        sub_category_desc = dictionary["sub_category_desc"] as? String ?? ""
        event_start_time = dictionary["event_start_time"] as? String ?? ""
        event_start_time_formatted = dictionary["event_start_time_formatted"] as? String ?? ""
        event_end_time = dictionary["event_end_time"] as? String ?? ""
        event_end_time_formatted = dictionary["event_end_time_formatted"] as? String ?? ""
        website = dictionary["website"] as? String ?? ""
        add_line_1 = dictionary["add_line_1"] as? String ?? ""
        add_line_2 = dictionary["add_line_2"] as? String ?? ""
        country_id = dictionary["country_id"] as? Int ?? 0
        countryName = dictionary["countryName"] as? String ?? ""
        state_id = dictionary["state_id"] as? Int ?? 0
        stateName = dictionary["stateName"] as? String ?? ""
        city_id = dictionary["city_id"] as? Int ?? 0
        cityName = dictionary["cityName"] as? String ?? ""
        zipcode = dictionary["zipcode"] as? String ?? ""
        event_lat = dictionary["event_lat"] as? String ?? ""
        event_long = dictionary["event_long"] as? String ?? ""
        is_online = dictionary["is_online"] as? String ?? ""
        event_privacy = dictionary["event_privacy"] as? String ?? ""
        is_admin_approved = dictionary["is_admin_approved"] as? String ?? ""
        is_active = dictionary["is_active"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
        event_type_id = dictionary["event_type_id"] as? Int ?? 0
        event_type_name = dictionary["event_type_name"] as? String ?? ""
        event_type_desc = dictionary["event_type_desc"] as? String ?? ""
        user_name = dictionary["user_name"] as? String ?? ""
        userslug = dictionary["userslug"] as? String ?? ""
        avatar = dictionary["avatar"] as? String ?? ""
        avatar_100x_100 = dictionary["avatar_100x_100"] as? String ?? ""
        avatar_200x_200 = dictionary["avatar_200x_200"] as? String ?? ""
        avatar_350x_350 = dictionary["avatar_350x_350"] as? String ?? ""
        is_user_like = (dictionary["is_user_like"] as? String ?? "").lowercased()
        minticketamount = dictionary["minticketamount"] as? String ?? ""
        checkLoggedUserFollow = dictionary["checkLoggedUserFollow"] as? String ?? ""
        event_csv_download_link = dictionary["event_csv_download_link"] as? String ?? ""
        totaleventbooked = dictionary["totaleventbooked",""]
        ticket_price_type = dictionary["ticket_price_type"] as? String ?? ""
        currency_sign_symbol = dictionary["currency_sign_symbol"] as? String ?? ""
        is_past = dictionary["is_past"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.is_past, forKey: "is_past")
        dictionary.setValue(self.currency_sign_symbol, forKey: "currency_sign_symbol")
        dictionary.setValue(self.ticketsArray.map({ $0.dictionaryRepresentation() }), forKey: "ticketsArray")
        dictionary.setValue(self.organizersArray.map({ $0.dictionaryRepresentation() }), forKey: "organizersArray")
        dictionary.setValue(self.getEventInvites.map({ $0.dictionaryRepresentation() }), forKey: "getEventInvites")
        dictionary.setValue(self.event_detail_share_url, forKey: "event_detail_share_url")
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.userid, forKey: "userid")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.slug, forKey: "slug")
        dictionary.setValue(self.event_slug, forKey: "event_slug")
        dictionary.setValue(self.event_desc, forKey: "event_desc")
        dictionary.setValue(self.logo, forKey: "logo")
        dictionary.setValue(self.logo_100x_100, forKey: "logo_100x_100")
        dictionary.setValue(self.logo_300x_300, forKey: "logo_300x_300")
        dictionary.setValue(self.logo_500x_500, forKey: "logo_500x_500")
        dictionary.setValue(self.back_image, forKey: "back_image")
        dictionary.setValue(self.back_image_100x_100, forKey: "back_image_100x_100")
        dictionary.setValue(self.back_image_300x_300, forKey: "back_image_300x_300")
        dictionary.setValue(self.back_image_500x_500, forKey: "back_image_500x_500")
        dictionary.setValue(self.category_id, forKey: "category_id")
        dictionary.setValue(self.category_name, forKey: "category_name")
        dictionary.setValue(self.category_desc, forKey: "category_desc")
        dictionary.setValue(self.sub_cat_id, forKey: "sub_cat_id")
        dictionary.setValue(self.sub_category_name, forKey: "sub_category_name")
        dictionary.setValue(self.sub_category_desc, forKey: "sub_category_desc")
        dictionary.setValue(self.event_start_time, forKey: "event_start_time")
        dictionary.setValue(self.event_start_time_formatted, forKey: "event_start_time_formatted")
        dictionary.setValue(self.event_end_time, forKey: "event_end_time")
        dictionary.setValue(self.event_end_time_formatted, forKey: "event_end_time_formatted")
        dictionary.setValue(self.website, forKey: "website")
        dictionary.setValue(self.add_line_1, forKey: "add_line_1")
        dictionary.setValue(self.add_line_2, forKey: "add_line_2")
        dictionary.setValue(self.country_id, forKey: "country_id")
        dictionary.setValue(self.countryName, forKey: "countryName")
        dictionary.setValue(self.state_id, forKey: "state_id")
        dictionary.setValue(self.stateName, forKey: "stateName")
        dictionary.setValue(self.city_id, forKey: "city_id")
        dictionary.setValue(self.cityName, forKey: "cityName")
        dictionary.setValue(self.zipcode, forKey: "zipcode")
        dictionary.setValue(self.event_lat, forKey: "event_lat")
        dictionary.setValue(self.event_long, forKey: "event_long")
        dictionary.setValue(self.is_online, forKey: "is_online")
        dictionary.setValue(self.event_privacy, forKey: "event_privacy")
        dictionary.setValue(self.is_admin_approved, forKey: "is_admin_approved")
        dictionary.setValue(self.is_active, forKey: "is_active")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
        dictionary.setValue(self.event_type_id, forKey: "event_type_id")
        dictionary.setValue(self.event_type_name, forKey: "event_type_name")
        dictionary.setValue(self.event_type_desc, forKey: "event_type_desc")
        dictionary.setValue(self.user_name, forKey: "user_name")
        dictionary.setValue(self.userslug, forKey: "userslug")
        dictionary.setValue(self.avatar, forKey: "avatar")
        dictionary.setValue(self.avatar_100x_100, forKey: "avatar_100x_100")
        dictionary.setValue(self.avatar_200x_200, forKey: "avatar_200x_200")
        dictionary.setValue(self.avatar_350x_350, forKey: "avatar_350x_350")
        dictionary.setValue(self.is_user_like, forKey: "is_user_like")
        dictionary.setValue(self.minticketamount, forKey: "minticketamount")
        dictionary.setValue(self.checkLoggedUserFollow, forKey: "checkLoggedUserFollow")
        dictionary.setValue(self.event_csv_download_link, forKey: "event_csv_download_link")
        dictionary.setValue(self.totaleventbooked, forKey: "totaleventbooked")
        dictionary.setValue(self.ticket_price_type, forKey: "ticket_price_type")
        return dictionary as! [String:Any]
    }
}

class EventCls{
    var eventList: [EventList] = [EventList]()
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        eventList = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({EventList(dictionary: $0 as! [String:Any])})
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    
}

//TODO: Onother dev//===

class UpcomingEventCls{
    var eventList: [EventList] = [EventList]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        
        eventList = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({EventList(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    /*
     class EventList:NSObject {
     var event_slug = ""
     var id : Int?
     var userid : Int?
     var title : String?
     var slug : String?
     var event_desc : String?
     var logo : String?
     var logo_100x_100 : String?
     var logo_300x_300 : String?
     var logo_500x_500 : String?
     var back_image : String?
     var back_image_100x_100 : String?
     var back_image_300x_300 : String?
     var back_image_500x_500 : String?
     var category_id : Int?
     var category_name : String?
     var category_desc : String?
     var sub_cat_id : Int?
     var sub_category_name : String?
     var sub_category_desc : String?
     var event_start_time : String?
     var event_start_time_formatted : String?
     var event_end_time : String?
     var event_end_time_formatted : String?
     var website : String?
     var add_line_1 : String?
     var add_line_2 : String?
     var country_id : Int?
     var countryName : String?
     var state_id : Int?
     var stateName : String?
     var city_id : Int?
     var cityName : String?
     var zipcode : String?
     var event_lat : String?
     var event_long : String?
     var is_online : String?
     var event_privacy : String?
     var is_admin_approved : String?
     var is_active : String?
     var created_at : String?
     var created_at_formatted : String?
     var updated_at : String?
     var updated_at_formatted : String?
     var event_type_id : Int?
     var event_type_name : String?
     var event_type_desc : String?
     var user_name : String?
     var userslug : String?
     var avatar : String?
     var avatar_100x_100 : String?
     var avatar_200x_200 : String?
     var avatar_350x_350 : String?
     var is_user_like : String?
     var minticketamount: String?
     var ticketsArray: [Ticket] = [Ticket]()
     var organizersArray: [Organizer] = [Organizer]()
     
     init(dictionary: [String:Any]) {
     ticketsArray = (Response.fatchDataAsArray(res: dictionary, valueOf: .ticketsArray) ).map({Ticket(dictionary: $0 as! [String:Any])})
     organizersArray = (Response.fatchDataAsArray(res: dictionary, valueOf: .organizersArray) ).map({Organizer(dictionary: $0 as! [String:Any])})
     id = dictionary["id"] as? Int ?? 0
     userid = dictionary["userid"] as? Int ?? 0
     title = dictionary["title"] as? String ?? ""
     slug = dictionary["slug"] as? String ?? ""
     event_slug = dictionary["slug",""]
     event_desc = dictionary["event_desc"] as? String ?? ""
     logo = dictionary["logo"] as? String ?? ""
     logo_100x_100 = dictionary["logo_100x_100"] as? String ?? ""
     logo_300x_300 = dictionary["logo_300x_300"] as? String ?? ""
     logo_500x_500 = dictionary["logo_500x_500"] as? String ?? ""
     back_image = dictionary["back_image"] as? String ?? ""
     back_image_100x_100 = dictionary["back_image_100x_100"] as? String ?? ""
     back_image_300x_300 = dictionary["back_image_300x_300"] as? String  ?? ""
     back_image_500x_500 = dictionary["back_image_500x_500"] as? String  ?? ""
     category_id = dictionary["category_id"] as? Int ?? 0
     category_name = dictionary["category_name"] as? String ?? ""
     category_desc = dictionary["category_desc"] as? String ?? ""
     sub_cat_id = dictionary["sub_cat_id"] as? Int ?? 0
     sub_category_name = dictionary["sub_category_name"] as? String ?? ""
     sub_category_desc = dictionary["sub_category_desc"] as? String ?? ""
     event_start_time = dictionary["event_start_time"] as? String ?? ""
     event_start_time_formatted = dictionary["event_start_time_formatted"] as? String ?? ""
     event_end_time = dictionary["event_end_time"] as? String ?? ""
     event_end_time_formatted = dictionary["event_end_time_formatted"] as? String ?? ""
     website = dictionary["website"] as? String ?? ""
     add_line_1 = dictionary["add_line_1"] as? String ?? ""
     add_line_2 = dictionary["add_line_2"] as? String ?? ""
     country_id = dictionary["country_id"] as? Int ?? 0
     countryName = dictionary["countryName"] as? String ?? ""
     state_id = dictionary["state_id"] as? Int ?? 0
     stateName = dictionary["stateName"] as? String ?? ""
     city_id = dictionary["city_id"] as? Int ?? 0
     cityName = dictionary["cityName"] as? String ?? ""
     zipcode = dictionary["zipcode"] as? String ?? ""
     event_lat = dictionary["event_lat"] as? String ?? ""
     event_long = dictionary["event_long"] as? String ?? ""
     is_online = dictionary["is_online"] as? String ?? ""
     event_privacy = dictionary["event_privacy"] as? String ?? ""
     is_admin_approved = dictionary["is_admin_approved"] as? String ?? ""
     is_active = dictionary["is_active"] as? String ?? ""
     created_at = dictionary["created_at"] as? String ?? ""
     created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
     updated_at = dictionary["updated_at"] as? String ?? ""
     updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
     event_type_id = dictionary["event_type_id"] as? Int ?? 0
     event_type_name = dictionary["event_type_name"] as? String ?? ""
     event_type_desc = dictionary["event_type_desc"] as? String ?? ""
     user_name = dictionary["user_name"] as? String ?? ""
     userslug = dictionary["userslug"] as? String ?? ""
     avatar = dictionary["avatar"] as? String ?? ""
     avatar_100x_100 = dictionary["avatar_100x_100"] as? String ?? ""
     avatar_200x_200 = dictionary["avatar_200x_200"] as? String ?? ""
     avatar_350x_350 = dictionary["avatar_350x_350"] as? String ?? ""
     is_user_like = dictionary["is_user_like"] as? String ?? ""
     minticketamount = dictionary["minticketamount"] as? String ?? ""
     
     }
     
     func dictionaryRepresentation() -> [String:Any] {
     let dictionary = NSMutableDictionary()
     dictionary.setValue(self.ticketsArray.map({ $0.dictionaryRepresentation() }), forKey: "ticketsArray")
     dictionary.setValue(self.organizersArray.map({ $0.dictionaryRepresentation() }), forKey: "organizersArray")
     dictionary.setValue(self.id, forKey: "id")
     dictionary.setValue(self.userid, forKey: "userid")
     dictionary.setValue(self.title, forKey: "title")
     dictionary.setValue(self.slug, forKey: "slug")
     dictionary.setValue(self.event_slug, forKey: "event_slug")
     dictionary.setValue(self.event_desc, forKey: "event_desc")
     dictionary.setValue(self.logo, forKey: "logo")
     dictionary.setValue(self.logo_100x_100, forKey: "logo_100x_100")
     dictionary.setValue(self.logo_300x_300, forKey: "logo_300x_300")
     dictionary.setValue(self.logo_500x_500, forKey: "logo_500x_500")
     dictionary.setValue(self.back_image, forKey: "back_image")
     dictionary.setValue(self.back_image_100x_100, forKey: "back_image_100x_100")
     dictionary.setValue(self.back_image_300x_300, forKey: "back_image_300x_300")
     dictionary.setValue(self.back_image_500x_500, forKey: "back_image_500x_500")
     dictionary.setValue(self.category_id, forKey: "category_id")
     dictionary.setValue(self.category_name, forKey: "category_name")
     dictionary.setValue(self.category_desc, forKey: "category_desc")
     dictionary.setValue(self.sub_cat_id, forKey: "sub_cat_id")
     dictionary.setValue(self.sub_category_name, forKey: "sub_category_name")
     dictionary.setValue(self.sub_category_desc, forKey: "sub_category_desc")
     dictionary.setValue(self.event_start_time, forKey: "event_start_time")
     dictionary.setValue(self.event_start_time_formatted, forKey: "event_start_time_formatted")
     dictionary.setValue(self.event_end_time, forKey: "event_end_time")
     dictionary.setValue(self.event_end_time_formatted, forKey: "event_end_time_formatted")
     dictionary.setValue(self.website, forKey: "website")
     dictionary.setValue(self.add_line_1, forKey: "add_line_1")
     dictionary.setValue(self.add_line_2, forKey: "add_line_2")
     dictionary.setValue(self.country_id, forKey: "country_id")
     dictionary.setValue(self.countryName, forKey: "countryName")
     dictionary.setValue(self.state_id, forKey: "state_id")
     dictionary.setValue(self.stateName, forKey: "stateName")
     dictionary.setValue(self.city_id, forKey: "city_id")
     dictionary.setValue(self.cityName, forKey: "cityName")
     dictionary.setValue(self.zipcode, forKey: "zipcode")
     dictionary.setValue(self.event_lat, forKey: "event_lat")
     dictionary.setValue(self.event_long, forKey: "event_long")
     dictionary.setValue(self.is_online, forKey: "is_online")
     dictionary.setValue(self.event_privacy, forKey: "event_privacy")
     dictionary.setValue(self.is_admin_approved, forKey: "is_admin_approved")
     dictionary.setValue(self.is_active, forKey: "is_active")
     dictionary.setValue(self.created_at, forKey: "created_at")
     dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
     dictionary.setValue(self.updated_at, forKey: "updated_at")
     dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
     dictionary.setValue(self.event_type_id, forKey: "event_type_id")
     dictionary.setValue(self.event_type_name, forKey: "event_type_name")
     dictionary.setValue(self.event_type_desc, forKey: "event_type_desc")
     dictionary.setValue(self.user_name, forKey: "user_name")
     dictionary.setValue(self.userslug, forKey: "userslug")
     dictionary.setValue(self.avatar, forKey: "avatar")
     dictionary.setValue(self.avatar_100x_100, forKey: "avatar_100x_100")
     dictionary.setValue(self.avatar_200x_200, forKey: "avatar_200x_200")
     dictionary.setValue(self.avatar_350x_350, forKey: "avatar_350x_350")
     dictionary.setValue(self.is_user_like, forKey: "is_user_like")
     dictionary.setValue(self.minticketamount, forKey: "minticketamount")
     
     return dictionary as! [String:Any]
     }
     
     /*
     
     class Ticket {
     var id : Int
     var userid : Int
     var ticket_price_type : String
     var ticket_name : String
     var ticket_qty : Int
     var ticket_type : String
     var ticket_price : String
     var ticket_last_date : String
     var created_at : String
     var created_at_formatted : String
     var updated_at : String
     var updated_at_formatted : String
     
     var isSelected:Bool = false //Custom variable
     
     init(dictionary: [String:Any]) {
     id = dictionary["id"] as? Int ?? 0
     userid = dictionary["userid"] as? Int ?? 0
     ticket_price_type = dictionary["ticket_price_type"] as? String ?? ""
     ticket_name = dictionary["ticket_name"] as? String ?? ""
     ticket_qty = dictionary["ticket_qty"] as? Int ?? 0
     ticket_type = dictionary["ticket_type"] as? String ?? ""
     ticket_price = dictionary["ticket_price","0"] //Cast dictionary value in String
     ticket_last_date = dictionary["ticket_last_date"] as? String ?? ""
     created_at = dictionary["created_at"] as? String ?? ""
     created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
     updated_at = dictionary["updated_at"] as? String ?? ""
     updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
     }
     
     func dictionaryRepresentation() -> [String:Any] {
     let dictionary = NSMutableDictionary()
     dictionary.setValue(self.id, forKey: "id")
     dictionary.setValue(self.userid, forKey: "userid")
     dictionary.setValue(self.ticket_price_type, forKey: "ticket_price_type")
     dictionary.setValue(self.ticket_name, forKey: "ticket_name")
     dictionary.setValue(self.ticket_qty, forKey: "ticket_qty")
     dictionary.setValue(self.ticket_type, forKey: "ticket_type")
     dictionary.setValue(self.ticket_price, forKey: "ticket_price")
     dictionary.setValue(self.ticket_last_date, forKey: "ticket_last_date")
     dictionary.setValue(self.created_at, forKey: "created_at")
     dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
     dictionary.setValue(self.updated_at, forKey: "updated_at")
     dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
     
     return dictionary as! [String:Any]
     }
     
     }
     
     class Organizer {
     var id : Int
     var userid : Int
     var name : String
     var organizer_desc : String
     var website : String
     var fb_link : String
     var twitter_link : String
     var link_in_link : String
     var image : String
     var created_at : String
     var created_at_formatted : String
     var updated_at : String
     var updated_at_formatted : String
     var isSelected:Bool = false  //Custom variable
     
     init(dictionary: [String:Any]) {
     id = dictionary["id"] as? Int ?? 0
     userid = dictionary["userid"] as? Int ?? 0
     name = dictionary["name"] as? String ?? ""
     organizer_desc = dictionary["organizer_desc"] as? String ?? ""
     website = dictionary["website"] as? String ?? ""
     fb_link = dictionary["fb_link"] as? String ?? ""
     twitter_link = dictionary["twitter_link"] as? String ?? ""
     link_in_link = dictionary["link_in_link"] as? String ?? ""
     image = dictionary["image"] as? String ?? ""
     created_at = dictionary["created_at"] as? String ?? ""
     created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
     updated_at = dictionary["updated_at"] as? String ?? ""
     updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
     }
     
     func dictionaryRepresentation() -> [String:Any] {
     let dictionary = NSMutableDictionary()
     dictionary.setValue(self.id, forKey: "id")
     dictionary.setValue(self.userid, forKey: "userid")
     dictionary.setValue(self.name, forKey: "name")
     dictionary.setValue(self.organizer_desc, forKey: "organizer_desc")
     dictionary.setValue(self.website, forKey: "website")
     dictionary.setValue(self.fb_link, forKey: "fb_link")
     dictionary.setValue(self.twitter_link, forKey: "twitter_link")
     dictionary.setValue(self.link_in_link, forKey: "link_in_link")
     dictionary.setValue(self.image, forKey: "image")
     dictionary.setValue(self.created_at, forKey: "created_at")
     dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
     dictionary.setValue(self.updated_at, forKey: "updated_at")
     dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
     
     return dictionary as! [String:Any]
     }
     
     }
     
     */
     
     }
     */
}


class MyOrgenizersCls{
    
    var list: [List] = [List]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        
        list = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({List(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    
    class List {
        
        var id : String
        var organizer_id: String
        var name : String
        var organizer_desc : String
        var created_at : String
        var created_at_formatted : String
        var updated_at : String
        var updated_at_formatted : String
        var userid : String
        var website : String
        var fb_link : String
        var twitter_link : String
        var link_in_link : String
        var image : String
        var isSelected : Bool
        var paypal_email : String
        
        init(dictionary: [String:Any]) {
            id = dictionary["id",""]
            organizer_id = dictionary["organizer_id",""]
            name = dictionary["name"] as? String ?? ""
            organizer_desc = dictionary["organizer_desc"] as? String ?? ""
            created_at = dictionary["created_at"] as? String ?? ""
            created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
            updated_at = dictionary["updated_at"] as? String ?? ""
            updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
            userid = dictionary["userid"] as? String ?? ""
            website = dictionary["website"] as? String ?? ""
            fb_link = dictionary["fb_link"] as? String ?? ""
            twitter_link = dictionary["twitter_link"] as? String ?? ""
            link_in_link = dictionary["link_in_link"] as? String ?? ""
            image = dictionary["image"] as? String ?? ""
            isSelected = dictionary["isSelected"] as? Bool ?? false
            paypal_email = dictionary["paypal_email"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.organizer_id, forKey: "organizer_id")
            dictionary.setValue(self.name, forKey: "name")
            dictionary.setValue(self.organizer_desc, forKey: "organizer_desc")
            dictionary.setValue(self.created_at, forKey: "created_at")
            dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
            dictionary.setValue(self.updated_at, forKey: "updated_at")
            dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
            dictionary.setValue(self.userid, forKey: "userid")
            dictionary.setValue(self.website, forKey: "website")
            dictionary.setValue(self.fb_link, forKey: "fb_link")
            dictionary.setValue(self.twitter_link, forKey: "twitter_link")
            dictionary.setValue(self.link_in_link, forKey: "link_in_link")
            dictionary.setValue(self.image, forKey: "image")
            dictionary.setValue(self.paypal_email, forKey: "paypal_email")
            return dictionary as! [String:Any]
        }
        
    }
}


class MyTicketsCls{
    
    var list: [List] = [List]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        
        list = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({List(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    
    class List {
        
        var id : String
        var ticket_id: String
        var ticket_name : String
        var ticket_price_type : String
        var created_at : String
        var created_at_formatted : String
        var updated_at : String
        var updated_at_formatted : String
        var userid : String
        var ticket_qty : Int
        var ticket_type : String
        var ticket_price : String
        var ticket_last_date : String
        var isSelected : Bool
        
        init(dictionary: [String:Any]) {
            id = dictionary["id",""]
            ticket_id = dictionary["ticket_id",""]
            ticket_name = dictionary["ticket_name"] as? String ?? ""
            ticket_price_type = dictionary["ticket_price_type"] as? String ?? ""
            created_at = dictionary["created_at"] as? String ?? ""
            created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
            updated_at = dictionary["updated_at"] as? String ?? ""
            updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
            userid = dictionary["userid"] as? String ?? ""
            ticket_qty = dictionary["ticket_qty"] as? Int ?? 0
            ticket_type = dictionary["ticket_type"] as? String ?? ""
            ticket_price = dictionary["ticket_price","0"]
            ticket_last_date = dictionary["ticket_last_date"] as? String ?? ""
            isSelected = dictionary["isSelected"] as? Bool ?? false
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.ticket_id, forKey: "ticket_id")
            dictionary.setValue(self.ticket_name, forKey: "ticket_name")
            dictionary.setValue(self.ticket_price_type, forKey: "ticket_price_type")
            dictionary.setValue(self.created_at, forKey: "created_at")
            dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
            dictionary.setValue(self.updated_at, forKey: "updated_at")
            dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
            dictionary.setValue(self.userid, forKey: "userid")
            dictionary.setValue(self.ticket_qty, forKey: "ticket_qty")
            dictionary.setValue(self.ticket_type, forKey: "ticket_type")
            dictionary.setValue(self.ticket_price, forKey: "ticket_price")
            dictionary.setValue(self.ticket_last_date, forKey: "ticket_last_date")
            
            
            return dictionary as! [String:Any]
        }
        
    }
}

class NotificationSettings {
    
    var noti_label : String
    var noti_flag : String
    
    init(dictionary: [String:Any]) {
        noti_label = dictionary["noti_label"] as? String ?? ""
        noti_flag = dictionary["noti_flag"] as? String ?? ""
        
    }
    
}



class PaymentHistoryCls {
    
    var list: [HistoryList] = [HistoryList]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    
    init(dictionary: [String:Any]) {
        
        list = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({HistoryList(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    
    
    class HistoryList{
        
        let id : Int
        let userid : Int
        let event_id : Int
        let txt_id : String
        let total_paid_amount : Int
        let ticket_booked_qty : Int
        let is_complete_trans : String
        let ticket_id : Int
        let ticket_name : String
        let ticket_type : String
        let ticket_price_type : String
        let ticket_price : String
        let ticket_last_date : String
        let ticket_last_date_formatted : String
        let created_at : String
        let created_at_formatted : String
        let ticket_download_link: String
        let title : String
        let slug : String
        let event_desc : String
        let logo : String
        let logo_100x_100 : String
        let logo_300x_300 : String
        let logo_500x_500 : String
        let back_image : String
        let back_image_100x_100 : String
        let back_image_300x_300 : String
        let back_image_500x_500 : String
        let category_id : Int
        let category_name : String
        let category_desc : String
        let sub_cat_id : Int?
        let sub_category_name : String
        let sub_category_desc : String
        let event_start_time : String
        let event_start_time_formatted : String
        let event_end_time : String
        let event_end_time_formatted : String
        let website : String
        let add_line_1 : String
        let add_line_2 : String
        let user_name : String
        let userslug : String
        let avatar : String
        let avatar_100x_100 : String
        let avatar_200x_200 : String
        let avatar_350x_350 : String
        let checkUserLike : String
        let buyer_user_name : String
        let buyer_userslug : String
        let buyer_avatar : String
        let buyer_avatar_100x_100 : String
        let buyer_avatar_200x_200 : String
        let buyer_avatar_350x_350 : String
        let buyer_checkUserLike : String
        
        
        init(dictionary: [String:Any]) {
            id = dictionary["id"] as? Int ?? 0
            userid = dictionary["userid"] as? Int ?? 0
            event_id = dictionary["event_id"] as? Int ?? 0
            txt_id = dictionary["txt_id"] as? String ?? ""
            total_paid_amount = dictionary["total_paid_amount"] as? Int ?? 0
            ticket_booked_qty = dictionary["ticket_booked_qty"] as? Int ?? 0
            is_complete_trans = dictionary["is_complete_trans"] as? String ?? ""
            ticket_id = dictionary["ticket_id"] as? Int ?? 0
            ticket_name = dictionary["ticket_name"] as? String ?? ""
            ticket_type = dictionary["ticket_type"] as? String ?? ""
            ticket_price_type = dictionary["ticket_price_type"] as? String ?? ""
            ticket_price = dictionary["ticket_price"] as? String ?? ""
            ticket_last_date = dictionary["ticket_last_date"] as? String ?? ""
            ticket_last_date_formatted = dictionary["ticket_last_date_formatted"] as? String ?? ""
            created_at = dictionary["created_at"] as? String ?? ""
            created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
            ticket_download_link = dictionary["ticket_download_link"] as? String ?? ""
            title = dictionary["title"] as? String ?? ""
            slug = dictionary["slug"] as? String ?? ""
            event_desc = dictionary["event_desc"] as? String ?? ""
            logo = dictionary["logo"] as? String ?? ""
            logo_100x_100 = dictionary["logo_100x_100"] as? String ?? ""
            logo_300x_300 = dictionary["logo_300x_300"] as? String ?? ""
            logo_500x_500 = dictionary["logo_500x_500"] as? String ?? ""
            back_image = dictionary["back_image"] as? String ?? ""
            back_image_100x_100 = dictionary["back_image_100x_100"] as? String ?? ""
            back_image_300x_300 = dictionary["back_image_300x_300"] as? String ?? ""
            back_image_500x_500 = dictionary["back_image_500x_500"] as? String ?? ""
            category_id = dictionary["category_id"] as? Int ?? 0
            category_name = dictionary["category_name"] as? String ?? ""
            category_desc = dictionary["category_desc"] as? String ?? ""
            sub_cat_id = dictionary["sub_cat_id"] as? Int ?? 0
            sub_category_name = dictionary["sub_category_name"] as? String ?? ""
            sub_category_desc = dictionary["sub_category_desc"] as? String ?? ""
            event_start_time = dictionary["event_start_time"] as? String ?? ""
            event_start_time_formatted = dictionary["event_start_time_formatted"] as? String ?? ""
            event_end_time = dictionary["event_end_time"] as? String ?? ""
            event_end_time_formatted = dictionary["event_end_time_formatted"] as? String ?? ""
            website = dictionary["website"] as? String ?? ""
            add_line_1 = dictionary["add_line_1"] as? String ?? ""
            add_line_2 = dictionary["add_line_2"] as? String ?? ""
            user_name = dictionary["user_name"] as? String ?? ""
            userslug = dictionary["userslug"] as? String ?? ""
            avatar = dictionary["avatar"] as? String ?? ""
            avatar_100x_100 = dictionary["avatar_100x_100"] as? String ?? ""
            avatar_200x_200 = dictionary["avatar_200x_200"] as? String ?? ""
            avatar_350x_350 = dictionary["avatar_350x_350"] as? String ?? ""
            checkUserLike = dictionary["checkUserLike"] as? String ?? ""
            buyer_user_name = dictionary["buyer_user_name"] as? String ?? ""
            buyer_userslug = dictionary["buyer_userslug"] as? String ?? ""
            buyer_avatar = dictionary["buyer_avatar"] as? String ?? ""
            buyer_avatar_100x_100 = dictionary["buyer_avatar_100x_100"] as? String ?? ""
            buyer_avatar_200x_200 = dictionary["buyer_avatar_200x_200"] as? String ?? ""
            buyer_avatar_350x_350 = dictionary["buyer_avatar_350x_350"] as? String ?? ""
            buyer_checkUserLike = dictionary["buyer_checkUserLike"] as? String ?? ""
        }
        
        func dictionaryRepresentation() -> NSDictionary {
            
            let dictionary = NSMutableDictionary()
            
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.userid, forKey: "userid")
            dictionary.setValue(self.event_id, forKey: "event_id")
            dictionary.setValue(self.txt_id, forKey: "txt_id")
            dictionary.setValue(self.total_paid_amount, forKey: "total_paid_amount")
            dictionary.setValue(self.ticket_booked_qty, forKey: "ticket_booked_qty")
            dictionary.setValue(self.is_complete_trans, forKey: "is_complete_trans")
            dictionary.setValue(self.ticket_id, forKey: "ticket_id")
            dictionary.setValue(self.ticket_name, forKey: "ticket_name")
            dictionary.setValue(self.ticket_type, forKey: "ticket_type")
            dictionary.setValue(self.ticket_price_type, forKey: "ticket_price_type")
            dictionary.setValue(self.ticket_price, forKey: "ticket_price")
            dictionary.setValue(self.ticket_last_date, forKey: "ticket_last_date")
            dictionary.setValue(self.ticket_last_date_formatted, forKey: "ticket_last_date_formatted")
            dictionary.setValue(self.created_at, forKey: "created_at")
            dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
            dictionary.setValue(self.title, forKey: "title")
            dictionary.setValue(self.ticket_download_link, forKey: "ticket_download_link")
            dictionary.setValue(self.slug, forKey: "slug")
            dictionary.setValue(self.event_desc, forKey: "event_desc")
            dictionary.setValue(self.logo, forKey: "logo")
            dictionary.setValue(self.logo_100x_100, forKey: "logo_100x_100")
            dictionary.setValue(self.logo_300x_300, forKey: "logo_300x_300")
            dictionary.setValue(self.logo_500x_500, forKey: "logo_500x_500")
            dictionary.setValue(self.back_image, forKey: "back_image")
            dictionary.setValue(self.back_image_100x_100, forKey: "back_image_100x_100")
            dictionary.setValue(self.back_image_300x_300, forKey: "back_image_300x_300")
            dictionary.setValue(self.back_image_500x_500, forKey: "back_image_500x_500")
            dictionary.setValue(self.category_id, forKey: "category_id")
            dictionary.setValue(self.category_name, forKey: "category_name")
            dictionary.setValue(self.category_desc, forKey: "category_desc")
            dictionary.setValue(self.sub_cat_id, forKey: "sub_cat_id")
            dictionary.setValue(self.sub_category_name, forKey: "sub_category_name")
            dictionary.setValue(self.sub_category_desc, forKey: "sub_category_desc")
            dictionary.setValue(self.event_start_time, forKey: "event_start_time")
            dictionary.setValue(self.event_start_time_formatted, forKey: "event_start_time_formatted")
            dictionary.setValue(self.event_end_time, forKey: "event_end_time")
            dictionary.setValue(self.event_end_time_formatted, forKey: "event_end_time_formatted")
            dictionary.setValue(self.website, forKey: "website")
            dictionary.setValue(self.add_line_1, forKey: "add_line_1")
            dictionary.setValue(self.add_line_2, forKey: "add_line_2")
            dictionary.setValue(self.user_name, forKey: "user_name")
            dictionary.setValue(self.userslug, forKey: "userslug")
            dictionary.setValue(self.avatar, forKey: "avatar")
            dictionary.setValue(self.avatar_100x_100, forKey: "avatar_100x_100")
            dictionary.setValue(self.avatar_200x_200, forKey: "avatar_200x_200")
            dictionary.setValue(self.avatar_350x_350, forKey: "avatar_350x_350")
            dictionary.setValue(self.checkUserLike, forKey: "checkUserLike")
            dictionary.setValue(self.buyer_user_name, forKey: "buyer_user_name")
            dictionary.setValue(self.buyer_userslug, forKey: "buyer_userslug")
            dictionary.setValue(self.buyer_avatar, forKey: "buyer_avatar")
            dictionary.setValue(self.buyer_avatar_100x_100, forKey: "buyer_avatar_100x_100")
            dictionary.setValue(self.buyer_avatar_200x_200, forKey: "buyer_avatar_200x_200")
            dictionary.setValue(self.buyer_avatar_350x_350, forKey: "buyer_avatar_350x_350")
            dictionary.setValue(self.buyer_checkUserLike, forKey: "buyer_checkUserLike")
            
            return dictionary
        }
    }
}


class FollowList {
    
    var id : String
    var userid : String
    var requester_userid : String
    var extra_notes : String
    var created_at : String
    var created_at_formatted : String
    var is_logged_user_follow : String
    var user_name : String
    var userslug : String
    var avatar : String
    
    var email: String
    var avatar_100x_100:String
    var avatar_200x_200:String
    var avatar_350x_350:String
    var isSelected = false
    
    var event_id:String = ""
    
    
    init(dictionary: [String:Any]) {
        id = dictionary["id",""]
        userid = dictionary["userid",""]
        requester_userid = dictionary["requester_userid",""]
        extra_notes = dictionary["extra_notes"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        is_logged_user_follow = dictionary["is_logged_user_follow"] as? String ?? ""
        user_name = dictionary["user_name"] as? String ?? ""
        userslug = dictionary["userslug"] as? String ?? ""
        avatar = dictionary["avatar"] as? String ?? ""
        
        email = dictionary["email"] as? String ?? ""
        avatar_100x_100 = dictionary["avatar_100x_100"] as? String ?? ""
        avatar_200x_200 = dictionary["avatar_200x_200"] as? String ?? ""
        avatar_350x_350 = dictionary["avatar_350x_350"] as? String ?? ""
    }
    
    init(inviteeDic: [String:Any]) {
        id = inviteeDic["id",""]
        userid = inviteeDic["userid",""]
        email = inviteeDic["email"] as? String ?? ""
        created_at = inviteeDic["created_at"] as? String ?? ""
        created_at_formatted = inviteeDic["created_at_formatted"] as? String ?? ""
        
        //Below field are always empty because from create event only above data is come
        requester_userid = inviteeDic["requester_userid",""]
        extra_notes = inviteeDic["extra_notes"] as? String ?? ""
        is_logged_user_follow = inviteeDic["is_logged_user_follow"] as? String ?? ""
        user_name = inviteeDic["user_name"] as? String ?? ""
        userslug = inviteeDic["userslug"] as? String ?? ""
        avatar = inviteeDic["avatar"] as? String ?? ""
        avatar_100x_100 = inviteeDic["avatar_100x_100"] as? String ?? ""
        avatar_200x_200 = inviteeDic["avatar_200x_200"] as? String ?? ""
        avatar_350x_350 = inviteeDic["avatar_350x_350"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.userid, forKey: "userid")
        dictionary.setValue(self.requester_userid, forKey: "requester_userid")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
        dictionary.setValue(self.is_logged_user_follow, forKey: "is_logged_user_follow")
        dictionary.setValue(self.user_name, forKey: "user_name")
        dictionary.setValue(self.userslug, forKey: "userslug")
        dictionary.setValue(self.avatar, forKey: "avatar")
        dictionary.setValue(self.extra_notes, forKey: "extra_notes")
        
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.avatar_100x_100, forKey: "avatar_100x_100")
        dictionary.setValue(self.avatar_200x_200, forKey: "avatar_200x_200")
        dictionary.setValue(self.avatar_350x_350, forKey: "avatar_350x_350")
        
        return dictionary as! [String:Any]
    }
}

class FollowersCls{
    
    //var list: [List] = [List]()
    var list: [FollowList] = [FollowList]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        
        list = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({FollowList(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
}


class MyContactCls{
    
    var list: [List] = [List]()
    var status_code:String
    var total_err_no :Int
    var lan_code: String
    var totalRecords:Int
    var thisPageTotalRecords:Int
    var page:Int
    var lastPage:Int
    var limit:Int
    
    init(dictionary: [String:Any]) {
        
        list = (Response.fatchDataAsArray(res: dictionary, valueOf: .data) ).map({List(dictionary: $0 as! [String:Any])})
        status_code = dictionary["status_code"] as? String ?? ""
        total_err_no = dictionary["total_err_no"] as? Int ?? 0
        lan_code = dictionary["lan_code"] as? String ?? ""
        totalRecords = dictionary["totalRecords"] as? Int ?? 0
        thisPageTotalRecords = dictionary["thisPageTotalRecords"] as? Int ?? 0
        page = dictionary["page"] as? Int ?? 0
        lastPage = dictionary["lastPage"] as? Int ?? 0
        limit = dictionary["limit"] as? Int ?? 0
        
    }
    
    class List {
        
        var detailList: [DetailList] = [DetailList]()
        var id : Int
        var userid : String
        var contact_list_name : String
        var is_active : String
        var created_at : String
        var created_at_formatted : String
        var updated_at : String
        var updated_at_formatted : String
        var isSelected : Bool
        
        
        init(dictionary: [String:Any]) {
            detailList = (Response.fatchDataAsArray(res: dictionary, valueOf: .getContactListNameDetails) ).map({DetailList(dictionary: $0 as! [String:Any])})
            id = dictionary["id"] as? Int ?? 0
            userid = dictionary["userid"] as? String ?? ""
            contact_list_name = dictionary["contact_list_name"] as? String ?? ""
            is_active = dictionary["is_active"] as? String ?? ""
            created_at = dictionary["created_at"] as? String ?? ""
            created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
            updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
            updated_at = dictionary["updated_at"] as? String ?? ""
            isSelected = dictionary["isSelected"] as? Bool ?? false
            
        }
        
        func dictionaryRepresentation() -> [String:Any] {
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.id, forKey: "id")
            dictionary.setValue(self.userid, forKey: "userid")
            dictionary.setValue(self.contact_list_name, forKey: "contact_list_name")
            dictionary.setValue(self.is_active, forKey: "is_active")
            dictionary.setValue(self.created_at, forKey: "created_at")
            dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
            dictionary.setValue(self.updated_at, forKey: "updated_at")
            dictionary.setValue(self.userid, forKey: "userid")
            
            
            return dictionary as! [String:Any]
        }
        
        class DetailList {
            
            var id : Int
            var contact_id : String
            var contact_name : String
            var contact_email : String
            var created_at : String
            var created_at_formatted : String
            var updated_at : String
            var updated_at_formatted : String
            
            
            init(dictionary: [String:Any]) {
                id = dictionary["id"] as? Int ?? 0
                contact_id = dictionary["contact_id",""]
                contact_name = dictionary["contact_name"] as? String ?? ""
                contact_email = dictionary["contact_email"] as? String ?? ""
                created_at = dictionary["created_at"] as? String ?? ""
                created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
                updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
                updated_at = dictionary["updated_at"] as? String ?? ""
                
                
            }
            
            func dictionaryRepresentation() -> [String:Any] {
                let dictionary = NSMutableDictionary()
                dictionary.setValue(self.id, forKey: "id")
                dictionary.setValue(self.contact_id, forKey: "contact_id")
                dictionary.setValue(self.contact_name, forKey: "contact_name")
                dictionary.setValue(self.contact_email, forKey: "contact_email")
                dictionary.setValue(self.created_at, forKey: "created_at")
                dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
                dictionary.setValue(self.updated_at, forKey: "updated_at")
                
                
                
                return dictionary as! [String:Any]
            }
            
        }
        
    }
    
    
}


class ContactDetailList {
    
    var id : Int
    var contact_id : String
    var contact_name : String
    var contact_email : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    var userid: String
    var userslug: String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id"] as? Int ?? 0
        contact_id = dictionary["contact_id",""]
        contact_name = dictionary["contact_name"] as? String ?? ""
        contact_email = dictionary["contact_email"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
        userid = dictionary["userid",""]
        userslug = dictionary["userslug"] as? String ?? ""
        
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.contact_id, forKey: "contact_id")
        dictionary.setValue(self.contact_name, forKey: "contact_name")
        dictionary.setValue(self.contact_email, forKey: "contact_email")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.userid, forKey: "userid")
        dictionary.setValue(self.userslug, forKey: "userslug")
        
        
        
        return dictionary as! [String:Any]
    }
    
}

class PopularCategory {
    var id : String
    var category_name : String
    var category_avatar: String
    var category_avatar_100x_100 : String
    var category_avatar_400x_400 : String
    var category_desc : String
    var is_popular : String
    var created_at : String
    var created_at_formatted : String
    var updated_at : String
    var updated_at_formatted : String
    
    init(dictionary: [String:Any]) {
        id = dictionary["id",""]
        category_name = dictionary["category_name",""]
        category_avatar = dictionary["category_avatar",""]
        category_avatar_100x_100 = dictionary["category_avatar_100x_100",""]
        category_avatar_400x_400 = dictionary["category_avatar_400x_400"] as? String ?? ""
        category_desc = dictionary["category_desc"] as? String ?? ""
        is_popular = dictionary["is_popular"] as? String ?? ""
        created_at = dictionary["created_at"] as? String ?? ""
        created_at_formatted = dictionary["created_at_formatted"] as? String ?? ""
        updated_at_formatted = dictionary["updated_at_formatted"] as? String ?? ""
        updated_at = dictionary["updated_at"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.category_name, forKey: "event_id")
        dictionary.setValue(self.category_avatar, forKey: "userid")
        dictionary.setValue(self.category_avatar_100x_100, forKey: "email")
        dictionary.setValue(self.category_avatar_400x_400, forKey: "created_at")
        dictionary.setValue(self.category_desc, forKey: "created_at_formatted")
        dictionary.setValue(self.is_popular, forKey: "updated_at")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.created_at_formatted, forKey: "created_at_formatted")
        dictionary.setValue(self.updated_at, forKey: "updated_at")
        dictionary.setValue(self.updated_at_formatted, forKey: "updated_at_formatted")
        
        return dictionary as! [String:Any]
    }
}


class PayPalData {
    
    var paypalURL : String
    var paypalSuccess : String
    var paypalError : String
        
    init(dictionary: [String:Any]) {
        paypalURL = dictionary["paypalURL",""]
        paypalSuccess = dictionary["paypalSuccess",""]
        paypalError = dictionary["paypalError",""]
    }
    
    func dictionaryRepresentation() -> [String:Any] {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.paypalURL, forKey: "paypalURL")
        dictionary.setValue(self.paypalSuccess, forKey: "paypalSuccess")
        dictionary.setValue(self.paypalError, forKey: "paypalError")
        return dictionary as! [String:Any]
    }
    
}


class ContentPage:NSObject{
    var id  = ""
    var page_name = ""
    var page_title = ""
    var meta_keyword = ""
    var meta_desc = ""
    var page_desc = ""
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as? String ?? ""
        page_name = dic["page_name"] as? String ?? ""
        page_title = dic["page_title"] as? String ?? ""
        meta_keyword = dic["meta_keyword"] as? String ?? ""
        meta_desc = dic["meta_desc"] as? String ?? ""
        page_desc = dic["page_desc"] as? String ?? ""
    }
    
    init(dictionary:[String:Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
}
