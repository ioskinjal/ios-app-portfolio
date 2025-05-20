//
//  Constant.swift
//  chronicsouls
//
//  Created by NCT 24 on 18/01/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

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


struct StoryBoard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let deals = UIStoryboard(name: "Deals", bundle: nil)
    static let imageCropper  = UIStoryboard(name: "ImageCropper", bundle: nil)
    static let accountsettings  = UIStoryboard(name: "AccountSettings", bundle: nil)
    static let search  = UIStoryboard(name: "Search", bundle: nil)
    static let profile  = UIStoryboard(name: "Profile", bundle: nil)
    static let reviews  = UIStoryboard(name: "Reviews", bundle: nil)
    static let dealOrder  = UIStoryboard(name: "DealOrder", bundle: nil)
    static let shoppingCart  = UIStoryboard(name: "ShoppingCart", bundle: nil)
    static let dealDetail  = UIStoryboard(name: "DealDetail", bundle: nil)
    
}

//var topSelectedMenu = 1

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum keys:String  {
    case status = "status"
    case message = "message"
    case user = "user"
    case data = "data"
    case date = "date"
    case category =  "Category list"
    case pagination = "pagination"
     case subcategory =  "subcategory"
     case dinner =  "dinner"
    case business = "business"
     case related_business = "related_business"
    case results = "results"
     //case cuisineItemsList =  "cuisineItemsList"
    case review =  "review"
    case popular =  "popular"
    case advertisements =  "advertisements"
    case payments = "payments"
    case plans = "plans"
    case messages = "messages"
    case deal_images = "deal_images"
    case profile_data = "profile_data"
    case deal_cats = "deal_cats"
    case deals = "deal"
    case deal_location = "deal_location"
    case deal_options = "deal_options"
    case deal_reviews = "deal_reviews"
    case notification_preferences = "notification_preferences"
    case total_amount = "total_amount"
     case dealLocations = "dealLocations"
    
}



struct ResponseKey{
    
    static func fatchDataAsDictionary(res: dictionary, valueOf key: keys) -> [String:Any] {
        if res[key.rawValue] as? [String:Any] != nil{
            print("Dictionary as a response")
            return res[key.rawValue] as! [String:Any]
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                print("Response is different: Array as a response")
                return [:]
            }
            else if res[key.rawValue] as? String != nil{
                print("Response is different: String as a response")
                return [:]
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return [:]
            }
        }
    }
    
    static func fatchDataAsArray(res: dictionary, valueOf key: keys) -> [Any] {
        if res[key.rawValue] as? [Any] != nil{
            print("Array as a response")
            return res[key.rawValue] as! [Any]
        }
        else{
            if res[key.rawValue] as? [String:Any] != nil{
                print("Response is different: Dictionary as a response")
                return []
            }
            else if res[key.rawValue] as? String != nil{
                print("Response is different: String as a response")
                return []
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return []
            }
        }
    }
    
    static func fatchDataAsString(res: dictionary, valueOf key: keys) -> String {
        if res[key.rawValue] as? String != nil{
            print("String as a response")
            return res[key.rawValue] as! String
        }
        else{
            if res[key.rawValue] as? [Any] != nil{
                print("Response is different: Array as a response")
                return ""
            }
            else if res[key.rawValue] as? [String:Any] != nil{
                print("Response is different: Dictionary as a response")
                return ""
            }else{
                print("Response is different: Response type not a Dictionary nore Array or String")
                return ""
            }
        }
    }
    
    static func fatchData(res: dictionary, valueOf key: keys) -> (dic: [String:Any], ary: [Any], str: String){
        if res[key.rawValue] as? [String:Any] != nil{
            print("Dictionary as a response")
            return (dic: res[key.rawValue] as! [String:Any], ary: [], str: "")
        }
        else if res[key.rawValue] as? [Any] != nil{
            print("Array as a response")
            return (dic: [:], ary: res[key.rawValue] as! [Any], str: "")
        }
        else if res[key.rawValue] as? String != nil{
            print("String as a response")
            return (dic: [:], ary: [], str: res[key.rawValue] as! String)
        }else{
            print("Response type not a Dictionary nore Array or String")
            return (dic: [:], ary:[], str: "")
        }
    }
    
    static func fatchDataAsArrayOfArray(res: NSObject, valueOf key: keys) -> [Any] {
        print("Array as a response")
        return [res as! [Any]]
    }

}




