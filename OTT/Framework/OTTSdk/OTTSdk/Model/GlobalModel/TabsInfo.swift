//
//  TabsInfo.swift
//  OTTSdk
//
//  Created by Muzaffar on 14/07/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TabsInfo: YuppModel {
    
    public var showTabs = false
    public var hints = ""
    public var tabs = [Tab]()
    public var selectedTab = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        showTabs = getBool(value:json["showTabs"])
        hints = getString(value: json["hints"])
        tabs = Tab.array(json: json["tabs"])
        selectedTab = getString(value:json["selectedTab"])
    }
}

public class Tab: YuppModel {
    
    public var code = ""
    public var title = ""
    public var sectionCodes = [String]()
    public var infiniteScroll  = false
    
    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        code = getString(value: json["code"])
        title = getString(value:json["title"])
        if let _sectionCodes = json["sectionCodes"] as? [String]{
           sectionCodes = _sectionCodes
        }
        infiniteScroll = getBool(value:json["infiniteScroll"])
    }
    
    public static func array(json : Any?) -> [Tab]{
        var list = [Tab]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Tab(obj))
            }
        }
        return list
    }
}
