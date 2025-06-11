//
//  TVGuideTemplateResponse.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 06/05/19.
//  Copyright © 2019 YuppTV. All rights reserved.
//

import UIKit

public class TemplateResponse: YuppModel {
    
    public var code = ""
    public var title = ""
    public var backgroundImage = ""
    public var rows = [Row]()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        code = getString(value: json["code"])
        title = getString(value: json["title"])
        backgroundImage = getImageUrl(value: json["backgroundImage"])
        rows = Row.array(json: json["rows"])
    }
    
    public static func array(json : Any?) -> [TemplateResponse]{
        var list = [TemplateResponse]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(TemplateResponse(obj))
            }
        }
        return list
    }

}

public class Row: YuppModel {
    public var rowDataType = ""
    public var rowNumber = 0
    public var templateElements = [TemplateElement]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        rowDataType = getString(value: json["rowDataType"])
        rowNumber = getInt(value: json["rowNumber"])
        templateElements = TemplateElement.array(json: json["templateElements"])
    }
    
    public static func array(json : Any?) -> [Row]{
        var list = [Row]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Row(obj))
            }
        }
        return list
    }

}

@objcMembers public class TemplateElement: YuppModel {
    public var elementSubtype = ""
    public var contentCode = ""
    public var data = ""
    public var rowNumber = 0
    public var elementCode = ""
    public var columnSpan = 0
    public var displayCondition = ""
    public var id = 0
    public var columnNumber = 0
    public var rowSpan = 0
    public var target = ""
    public var elementType = ""
    public var value = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        elementSubtype = getString(value: json["elementSubtype"])
        contentCode = getString(value: json["contentCode"])
        data = getString(value: json["data"])
        rowNumber = getInt(value: json["rowNumber"])
        elementCode = getString(value: json["elementCode"])
        columnSpan = getInt(value: json["columnSpan"])
        id = getInt(value: json["id"])
        columnNumber = getInt(value: json["columnNumber"])
        displayCondition = getString(value: json["displayCondition"])
        rowSpan = getInt(value: json["rowSpan"])
        target = getString(value: json["target"])
        elementType = getString(value: json["elementType"])
        value = getString(value: json["value"])
    }

    public static func array(json : Any?) -> [TemplateElement]{
        var list = [TemplateElement]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(TemplateElement(obj))
            }
        }
        return list
    }

}

public class TemplateData: YuppModel {
    public var templateCode = ""
    public var data = TemplateDataObj()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        templateCode = getString(value: json["templateCode"])
        data = TemplateDataObj.init(json["data"] as! [String : Any])
    }
}

public class TemplateDataObj: YuppModel {
   
    public var target_description = ""
    public var description_property = ""
    public var name = ""
    public var show_description = ""
    public var show_name = ""
    public var description_ = ""
    public var name_property = ""
    public var target_name = ""
    public var value_name = ""
    public var value_description = ""
    public var target_watch_latest_episode = ""
    public var duration = ""
    public var resume = ""
    public var image = ""
    public var target_resume = ""
    public var target_browse_episodes = ""
    public var show_watch_latest_episode = false
    public var show_image = false
    public var show_duration = false
    public var show_resume = false
    public var show_browse_episodes = false
    public var watchedPosition : Float = 0.0
    public var target_watchnow = ""
    public var cast = ""
    public var show_watchnow = false
    public var show_subtitle = false
    public var show_cast = false
    public var subtitle = ""
    public var show_startover = ""
    public var target_startover = ""
    public var rawData = [String : Any]()
    
    
    public var show_startover_live = false
    public var show_delete_record = false
    public var show_expires = false
    public var show_watchlive = false
    public var show_stop_record = false
    public var show_available_soon = false
    public var show_expiry = false
    public var show_startover_past = false
    public var show_record_upgrade = false
    public var show_record = false
    public var target_startover_past = ""
    public var expires = ""
    public var target_watchlive = ""
    public var target_startover_live = ""
    public var expiryTime = NSNumber()
    
    public var show_expires_today = false
    public var show_stream_not_available = false
    public var show_available_soon_label = false
    public var show_expires_day = false
    public var expires_day = ""
    public var show_subscribe = false
    public var show_available_soon_record = ""

    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        self.rawData = json
        target_description = getString(value: json["target_description"])
        description_property = getString(value: json["description_property"])
        name = getString(value: json["name"])
        show_description = getString(value: json["show_description"])
        show_name = getString(value: json["show_name"])
        description_ = getString(value: json["description"])
        name_property = getString(value: json["name_property"])
        target_name = getString(value: json["target_name"])
        value_name = getString(value: json["value_name"])
        value_description = getString(value: json["value_description"])
        target_watch_latest_episode = getString(value: json["target_watch_latest_episode"])
        duration = getString(value: json["duration"])
        resume = getString(value: json["resume"])
        image = getImageUrl(value: json["image"])
        target_resume = getString(value: json["target_resume"])
        target_browse_episodes = getString(value: json["target_browse_episodes"])
        show_watch_latest_episode = getBool(value: json["show_watch_latest_episode"])
        show_image = getBool(value: json["show_image"])
        show_duration = getBool(value: json["show_duration"])
        show_resume = getBool(value: json["show_resume"])
        show_browse_episodes = getBool(value: json["show_browse_episodes"])
        watchedPosition = getFloat(value: json["watchedPosition"])
        
        target_watchnow = getString(value: json["target_watchnow"])
        cast = getString(value: json["cast"])
        show_watchnow = getBool(value: json["show_watchnow"])
        show_subtitle = getBool(value: json["show_subtitle"])
        show_cast = getBool(value: json["show_cast"])
        
        subtitle = getString(value: json["subtitle"])
        show_startover = getString(value: json["show_startover"])
        target_startover = getString(value: json["target_startover"])
        
        show_startover_live = getBool(value: json["show_startover_live"])
        show_delete_record = getBool(value: json["show_delete_record"])
        show_expires = getBool(value: json["show_expires"])
        show_watchlive = getBool(value: json["show_watchlive"])
        show_stop_record = getBool(value: json["show_stop_record"])
        show_available_soon = getBool(value: json["show_available_soon"])
        show_expiry = getBool(value: json["show_expiry"])
        show_startover_past = getBool(value: json["show_startover_past"])
        show_record_upgrade = getBool(value: json["show_record_upgrade"])
        show_record = getBool(value: json["show_record"])
        target_startover_past = getString(value: json["target_startover_past"])
        expires = getString(value: json["expires"])
        target_watchlive = getString(value: json["target_watchlive"])
        target_startover_live = getString(value: json["target_startover_live"])
        expiryTime = getNSNumber(value:json["expiryTime"])
        
        show_expires_today = getBool(value: json["show_expires_today"])
        show_stream_not_available = getBool(value: json["show_stream_not_available"])
        show_available_soon_label = getBool(value: json["show_available_soon_label"])
        show_expires_day = getBool(value: json["show_expires_day"])
        expires_day = getString(value: json["expires_day"])
        show_subscribe = getBool(value: json["show_subscribe"])
        show_available_soon_record = getString(value: json["show_available_soon_record"])
    }
}
