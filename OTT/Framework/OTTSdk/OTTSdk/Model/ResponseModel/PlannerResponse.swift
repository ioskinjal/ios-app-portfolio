//
//  PlannerResponse.swift
//  OTTSdk
//
//  Created by YuppTV Ent on 19/08/22.
//  Copyright © 2022 YuppTV. All rights reserved.
//

import UIKit

public class PlannerResponse : YuppModel {
    public var monthlyPlannerData : [MonthlyPlannerData]?
    public var featuredTitle: String?
    public var seasonTitle: String?
    public var comingUpTitle: String?
     

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        var tempFeaturedArray = [[String:Any]]()
        var tempSeasonArray = [[String:Any]]()
        var tempComingupArray = [[String:Any]]()
        if let _table = json["table"] as? [[String : Any]] {
            for item in _table {
                if let _header = item["header"] as? [String : Any] {
                    if let _headerTitle = _header["code"] as? String {
                        if _headerTitle == "featured" {
                            if let _title = _header["title"] as? String {
                                featuredTitle = _title
                            }
                            
                            if let _dataArray = item["rows"] as? [[String : Any]] {
                                tempFeaturedArray = _dataArray
                            }
                        }
                        else if _headerTitle == "seasonal_checklist" {
                            if let _title = _header["title"] as? String {
                                seasonTitle = _title
                            }
                            
                            if let _dataArray = item["rows"] as? [[String : Any]] {
                                tempSeasonArray = _dataArray
                            }
                        }
                        else if _headerTitle == "coming_up_on_gac_family" {
                            if let _title = _header["title"] as? String {
                                comingUpTitle = _title
                            }
                            
                            if let _dataArray = item["rows"] as? [[String : Any]] {
                                tempComingupArray = _dataArray
                            }
                        }
                    }
                }
            }
        }
        monthlyPlannerData = MonthlyPlannerData.monthlyPlannerData(json: json["weeks"], featureArray: tempFeaturedArray,seasonArray: tempSeasonArray, comingupArray: tempComingupArray)
    }
    
}

public class MonthlyPlannerData: YuppModel {
    
    public var subtitle : String?
    public var weeksDescription : String?
    public var code : String?
    public var title : String?
    public var imageUrl : String?
    
    public var featureInfoArray = [Card]()
    public var seasonInfoArray = [SeasonInfo]()
    public var comingUpInfoArray = [Card]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any],  featureArray : [[String:Any]], seasonArray : [[String:Any]], comingupArray : [[String:Any]]) {
        super.init()
        subtitle = getString(value: json["subtitle"])
        weeksDescription = getString(value: json["description"])
        code = getString(value: json["code"])
        title = getString(value: json["title"])
        imageUrl = getImageUrl(value: json["imageUrl"])
       
        for item in featureArray {
            if let _key = item["key"] as? String {
                if _key == code {
                    featureInfoArray = Card.cards(json: item["data"])
                    break;
                }
            }
        }
        
         for item in seasonArray {
             if let _key = item["key"] as? String {
                 if _key == code {
                     seasonInfoArray = SeasonInfo.seasons(json: item["data"])
                     break;
                 }
             }
         }
        
        for item in comingupArray {
            if let _key = item["key"] as? String {
                if _key == code {
                    comingUpInfoArray = Card.cards(json: item["data"])
                    break;
                }
            }
        }
         
    }
    
    public static func monthlyPlannerData(json : Any?, featureArray : [[String:Any]], seasonArray : [[String:Any]], comingupArray : [[String:Any]]   ) -> [MonthlyPlannerData]{
        var list = [MonthlyPlannerData]()

        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(MonthlyPlannerData(obj,featureArray: featureArray,seasonArray: seasonArray,comingupArray: comingupArray))
            }
        }
        return list
    }
}

public class SeasonInfo: YuppModel {

    public var value = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        value = getString(value: json["value"])
    }
    
    public static func seasons(json : Any?) -> [SeasonInfo]{
        var list = [SeasonInfo]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(SeasonInfo(obj))
            }
        }
        return list
    }
}



public class MonthsDataResponse: YuppModel {
    public var monthsData = [MonthsData]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        monthsData = MonthsData.monthsData(json: json["data"])
    }
}

public class MonthsData: YuppModel {
    
   
    public var key = ""
    public var value = ""
    public var params = Params()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        key = getString(value: json["key"])
        value = getString(value: json["value"])
       
        if let _json = json["params"] as? [String : Any]{
            params = Params.init(_json)
        }
    }
    
    public static func monthsData(json : Any?) -> [MonthsData]{
        var list = [MonthsData]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(MonthsData(obj))
            }
        }
        return list
    }
    
    public class Params: YuppModel {
        public var year = ""
        public var isDefault = false

        internal override init() {
            super.init()
        }
        
        public init(_ json : [String : Any]){
            super.init()
            year = getString(value: json["year"])
            isDefault = getBool(value: json["isDefault"])
        }
    }
}
 
