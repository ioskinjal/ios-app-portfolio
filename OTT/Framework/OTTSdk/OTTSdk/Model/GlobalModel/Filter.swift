//
//  Filter.swift
//  OTTSdk
//
//  Created by Muzaffar on 19/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

/*
 "selectableSortDirection": false,
 "items": [
     {
     "title": "Genge and Kapouka",
     "code": "Genge and Kapouka",
     "image": ""
     }],
 "code": "subgenre",
 "multiSelectable": false,
 "isSort": false,
 "title": "Subgenre"
 */
public class Filter: YuppModel {
    public var selectableSortDirection = false
    public var items = [FilterItem]()
    public var code = ""
    public var multiSelectable = false
    public var isSort = false
    public var title = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        selectableSortDirection = getBool(value: json["selectableSortDirection"])
        items = FilterItem.array(json: json["items"])
        code = getString(value:json["code"])
        multiSelectable = getBool(value:json["multiSelectable"])
        isSort = getBool(value:json["isSort"])
        title = getString(value: json["title"])
    }
    
    public static func array(json : Any?) -> [Filter]{
        var list = [Filter]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Filter(obj))
            }
        }
        return list
    }
}

public class FilterItem: YuppModel {
    public var title = ""
    public var code = ""
    public var image = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        title = getString(value: json["title"])
        code = getString(value:json["code"])
        image = getImageUrl(value:json["image"])
    }
    
    public static func array(json : Any?) -> [FilterItem]{
        var list = [FilterItem]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(FilterItem(obj))
            }
        }
        return list
    }
}
