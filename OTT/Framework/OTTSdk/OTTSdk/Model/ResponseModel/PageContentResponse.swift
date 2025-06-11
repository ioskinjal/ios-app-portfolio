//
//  PageContentResponse.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PageContentResponse: YuppModel {
    public var info = PageInfo()
    public var banners = [Banner]()
    public var pageEventInfo = [PageEventInfo]()
    public var promoBanners : Any?
    public var data = [PageData]()
    public var filters = [Filter]()
    public var tabsInfo = TabsInfo()
    public var shareInfo = ShareInfo()
    public var streamStatus = StreamStatus()
    public var pageButtons = PageButtons()
    public var adUrlResponse = AdUrlResponse()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _info = json["info"] as? [String : Any]{
            info = PageInfo.init(_info)
        }
        if let _pageButtons = json["pageButtons"] as? [String : Any]{
            pageButtons = PageButtons.init(_pageButtons)
        }
        banners = Banner.banners(json: json["banners"])
        pageEventInfo = PageEventInfo.pageEventInfo(json: json["pageEventInfo"])
        promoBanners = json["promoBanners"]
        data = PageData.data(json: json["data"])
        if let _shareInfo = json["shareInfo"] as? [String : Any]{
            shareInfo = ShareInfo.init(_shareInfo)
        }
        if let _streamStatus = json["streamStatus"] as? [String : Any]{
            streamStatus = StreamStatus.init(_streamStatus)
        }
        filters = Filter.array(json: json["filters"])
        if let _tabsInfo = json["tabsInfo"] as? [String : Any]{
            tabsInfo = TabsInfo(_tabsInfo)
        }
        if let _adUrlResponse = json["adUrlResponse"] as? [String : Any]{
            adUrlResponse = AdUrlResponse.init(_adUrlResponse)
        }
    }
}

public class AdUrlResponse: YuppModel {
    public var adConfigName = ""
    public var adUrlTypes = [AdUrlTypes]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        adConfigName = getString(value: json["adConfigName"])
        adUrlTypes = AdUrlTypes.array(json: json["adUrlTypes"])
    }
}
public class AdUrlTypes: YuppModel{
    
    public enum UrlType : String {
        case banner = "banner"
        case interstitial = "interstitial"
        case native = "native"
        case preUrl = "preUrl"
        case midUrl = "midUrl"
        case postUrl = "postUrl"
        case overlay = "overlay"
        case unknown = "unknown"
    }
    public var urlType = UrlType.unknown
    public var url = ""
    public var adUnitId = ""
    public var position = Position()
    
    internal override init() {
        super.init()
    }
    public init(_ json : [String : Any]){
        super.init()
        url = getString(value: json["url"])
        adUnitId = getString(value: json["adUnitId"])
        if let _urlType = UrlType(rawValue: getString(value: json["urlType"])){
            urlType = _urlType
        }
        if let _position = json["position"] as? [String : Any] {
            position = Position.init(_position)
        }
    }
    public static func array(json : Any?) -> [AdUrlTypes]{
        var list = [AdUrlTypes]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(AdUrlTypes(obj))
            }
        }
        return list
    }
}
public class Position: YuppModel{
    
    public var interval = ""
    public var maxCount = ""
    public var show = ""
    public var offset = ""
    
    internal override init() {
        super.init()
    }
    public init(_ json : [String : Any]){
        super.init()
        if let _interval = json["interval"] as? String {
            interval = _interval
        }
        if let _maxCount = json["maxCount"] as? String {
            maxCount = _maxCount
        }
        if let _show = json["show"] as? String {
            show = _show
        }
        if let _offset = json["offset"] as? String {
            offset = _offset
        }
    }
}
