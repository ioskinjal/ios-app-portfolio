//
//  Constant.swift
//  chronicsouls
//
//  Created by NCT 24 on 18/01/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit




struct StoryBoard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let imageCropper  = UIStoryboard(name: "ImageCropper", bundle: nil)
}

//var topSelectedMenu = 1

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum keys:String  {
    case status = "status"
    case message = "msg"
    case data = "data"
    case breakfast =  "breakfast"
     case lunch =  "lunch"
     case dinner =  "dinner"
     //case cuisineItemsList =  "cuisineItemsList"
    case recommended =  "recommended"
    case popular =  "popular"
    
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




