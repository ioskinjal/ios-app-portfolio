//
//  PageEventInfo.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 16/02/18.
//  Copyright © 2018 YuppTV. All rights reserved.
//

import UIKit

public class PageEventInfo: YuppModel {

    public enum EventCode : String {
        case stream_end = "unKnown"
    }
    public enum TargetType : String {
        case page = "page"
        case api = "api"
    }

    public var eventCode = EventCode.stream_end
    public var targetType = TargetType.page
    public var targetPath = ""
    public var targetParams = TargetParams()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        if let _eventCode = EventCode(rawValue: getString(value: json["eventCode"])){
            eventCode = _eventCode
        }
        if let _targetType = TargetType(rawValue: getString(value: json["targetType"])){
            targetType = _targetType
        }
        targetPath = getString(value: json["targetPath"])
        if let _target = json["targetParams"] as? [String : Any]{
            targetParams = TargetParams.init(_target)
        }
    }
    
    public static func pageEventInfo(json : Any?) -> [PageEventInfo]{
        var list = [PageEventInfo]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(PageEventInfo(obj))
            }
        }
        return list
    }
}
public class TargetParams: YuppModel {
    public var autoRedirect = false
    public var buttonText = ""
    public var isDefault = false

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if getString(value: json["autoRedirect"]) == "true" {
            autoRedirect = true
        }
        buttonText = getString(value: json["buttonText"])
        if getString(value: json["isDefault"]) == "true" {
            isDefault = true
        }
    }
}
