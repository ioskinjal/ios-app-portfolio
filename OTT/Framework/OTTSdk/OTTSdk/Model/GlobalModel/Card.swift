//
//  Card.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Card: YuppModel {
    public struct Target {
        public var path = ""
        public var pageType = ""
        public var pageAttributes : [String:Any]?
    }
    
    public enum CardType : String {
        case unknown = "unknown"
        case pinup_poster = "pinup_poster"
        case icon_poster = "icon_poster"
        case content_poster = "content_poster"
        case roller_poster = "roller_poster"
        case info_poster = "info_poster"
        case box_poster = "box_poster"
        case band_poster = "band_poster"
        case sheet_poster = "sheet_poster"
        case common_poster = "common_poster"
        case live_poster = "live_poster"
        case circle_poster = "circle_poster"
        case square_poster = "square_poster"
        case channel_poster = "channel_poster"
        case overlay_poster = "overlay_poster"
        case network_poster = "network_poster"
        case ad_content = "ad_content"
        case shortvideo_poster = "shortvideo_poster"
        case rectangle_poster = "rectangle_poster"
    }
    
    public var cardType = CardType.unknown
    public var display = Display()
    public var hover : [String : Any]?
    public var metadata = Metadata()
    public var target = Target()
    public var template = ""
    public var templateData = TemplateData()
    public var adPositionIndex = 0

    
    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        if let _cardType = CardType(rawValue: getString(value:json["cardType"])){
            cardType = _cardType
        }
        
        if let dic = json["display"] as? [String : Any]{
            display = Display(dic)
        }
        
        hover = json["hover"] as? [String : Any]
        
        if let _target = json["target"] as? [String : Any]{
            target = Target.init(path: getString(value: _target["path"]), pageType: getString(value: _target["pageType"]), pageAttributes: _target["pageAttributes"] as? [String : Any])
        }
        if let _metadata = json["metadata"] as? [String : Any]{
            metadata = Metadata.init(_metadata)
        }
        template = getString(value: json["template"])
        if let temp = json["templateData"] as? [String : Any]{
            templateData = TemplateData.init(temp)
        }
    }
    
    
    public static func cards(json : Any?, limit : Int = -1, startIndex : Int = 0) -> [Card]{
        var list = [Card]()
        if let _json = json as? [[String : Any]]{
            var tempVal = 0
            for (index,obj) in _json.enumerated() {
                if limit > 0 {
                    if index >= startIndex {
                        tempVal = tempVal + 1
                        if tempVal <= limit {
                            list.append(Card(obj))
                        }
                    }
                }
                else {
                    list.append(Card(obj))
                }
            }
        }
        return list
    }
}

public class Display: YuppModel {
    
    public enum MarkerType : String {
        /// display given text on top left
        case tag = "tag"
        
        /// start time of program
        case startTime = "startTime"
        
        /// end time of program
        case endTime = "endTime"
        
        /// display given text on bottom right
        case badge = "badge"
        
        /// limited set of predefined types (Ex: live_dot, now_playing, playable)
        case special = "special"
        
        /// display clock symbol along with given text
        case duration = "duration"
        
        /// display stars based on given value
        case rating = "rating"
        
        /// display progress view based on given value
        case seek = "seek"
        
        case record = "record"
        
        case stoprecord = "stoprecord"
        
        case backgroundImage = "backgroundImage"
        
        case available_soon = "available_soon"
        
        case exipiryDays = "exipiryDays"
        case exipiryInfo = "exipiryInfo"
        case recordingLabel = "recordingLabel"
        case expiryInfo = "expiryInfo"
        case leftOverTime = "leftOverTime"
        case comingSoon = "coming_soon"
        /// Not defined
        case unKnown = "unKnown"
    }
    
    public struct Markers{
        public var markerType = MarkerType.unKnown
        public var value = ""
        public var bgColor = ""
        public var textColor = ""
    }
    
    public var subtitle1 = ""
    public var subtitle2 = ""
    public var subtitle3 = ""
    public var subtitle4 = ""
    public var subtitle5 = ""
    public var parentIcon = ""
    public var parentName = ""
    public var layout = ""
    public var title = ""
    public var imageUrl = ""
    public var markers = [Markers]()
    public var isRecording = false

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        subtitle1 = getString(value: json["subtitle1"])
        subtitle2 = getString(value: json["subtitle2"])
        subtitle3 = getString(value: json["subtitle3"])
        subtitle4 = getString(value: json["subtitle4"])
        subtitle5 = getString(value: json["subtitle5"])
        parentIcon = getImageUrl(value: json["parentIcon"])
        parentName = getString(value: json["parentName"])
        layout = getString(value: json["layout"])
        title = getString(value: json["title"])
        imageUrl = getImageUrl(value: json["imageUrl"])
        
        if let _markers = json["markers"] as? [[String : Any]]{
            for _marker in _markers {
                var markerType = MarkerType.unKnown
                if let _markerType = MarkerType(rawValue: getString(value:_marker["markerType"])){
                    markerType = _markerType
                }
                
                markers.append(Markers(markerType: markerType,
                                       value: getString(value:_marker["value"]),
                                       bgColor: getMarketColorString(value:_marker["bgColor"]),
                                       textColor: getMarketColorString(value:_marker["textColor"])))
            }
        }
    }
}
public class Metadata: YuppModel {
    public var id = "0"
    public var previewUrl = ""
    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        id = getString(value: json["id"])
        if let _previewUrl = json["previewUrl"] as? [String : Any]{
            previewUrl = _previewUrl["value"] as! String
        }
    }
}
