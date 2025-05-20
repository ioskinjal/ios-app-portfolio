//
//  Constant.swift
//  BistroStays
//
//  Created by NCT109 on 27/08/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import Alamofire

let appDelegate = UIApplication.shared.delegate as? AppDelegate
let serviceNotificationsKey = "serviceNotificationsKey"
let quotePlacedKey = "quotePlacedKey"
let dispTextKey = "dispTextKey"

struct StoryBoard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let home = UIStoryboard(name: "Home", bundle: nil)
    static let profile = UIStoryboard(name: "Profile", bundle: nil)
    static let browsecategory = UIStoryboard(name: "BrowseCategory", bundle: nil)
    static let askQuestionList = UIStoryboard(name: "AskQuestionList", bundle: nil)
    static let otherSideMenu = UIStoryboard(name: "OtherSideMenu", bundle: nil)
    static let profileProvider = UIStoryboard(name: "ProfileProvider", bundle: nil)
    static let serviceNotifications = UIStoryboard(name: "ServiceNotifications", bundle: nil)
    static let chat = UIStoryboard(name: "Chat", bundle: nil)
}

enum keys:String  {
    case status = "status"
    case message = "message"
    case data = "data"
    case result = "result"
    case service_list = "service_list"
    case specialdates = "special_dates"
    case pages = "pages"
    case categoryList = "category_list"
    case subCategoryList = "sub_category_list"
    case plans = "plans"
    case user_review = "user_review"
    case service_notification = "service_notification"
    case quotes_placed = "quotes_placed"
    case site_notification = "site_notification"
    case portfolio = "portfolio"
    case my_request = "my_request"
    case pagination = "pagination"
}

public enum Result<T> {
    case success(T)
    case failure(Error)
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
}

func localizedString(key: String) -> String {
    let isLang: String? = UserDefaults.standard.string(forKey: "IS_Lang")
    
    if isLang == "2" {
        let path = Bundle.main.path(forResource: "fa", ofType: "lproj")
        let bundal = Bundle.init(path: path!)! as Bundle
        return bundal.localizedString(forKey: key, value: nil, table: nil)
    }else {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundal = Bundle.init(path: path!)! as Bundle
        return bundal.localizedString(forKey: key, value: nil, table: nil)
    }
}
func retrieveFromJsonFile() -> [String:Any] {
    // Get the url of Persons.json in document directory
    let documentsDirectoryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
    let fileUrl = documentsDirectoryUrl?.appendingPathComponent("offlineData.json")
    
    // Read data from .json file and transform data into an array
    do {
        let data = try Data(contentsOf: fileUrl!, options: [])
        let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        //print(personArray)
        return personArray!
    } catch {
        print(error)
    }
    return [String:Any]()
}

var isConnectedToInternet:Bool {
    return NetworkReachabilityManager()!.isReachable
}

