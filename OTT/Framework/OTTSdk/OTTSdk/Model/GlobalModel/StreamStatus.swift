//
//  StreamStatus.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 11/09/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StreamStatus: YuppModel {

    public var hasAccess = true
    public var message = ""
    public var seekPositionInMillis = 0
    public var totalDurationInMillis = 0
    public var errorCode = 0
    public var trailerStreamStatus = false
    public var previewStreamStatus = false

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        hasAccess = getBool(value:json["hasAccess"])
        message = getString(value: json["message"])
        seekPositionInMillis = Int(getFloat(value: json["seekPositionInMillis"]))
        totalDurationInMillis = Int(getFloat(value: json["totalDurationInMillis"]))
        errorCode = Int(getFloat(value: json["errorCode"]))
        trailerStreamStatus = getBool(value: json["trailerStreamStatus"])
        previewStreamStatus = getBool(value: json["previewStreamStatus"])
    }

}

public class Question: YuppModel {

    public var question = ""
    public var postedTime = NSNumber()
    public var contentType = ""
    public var contentId = ""
    public var userId = 0
    public var userName = ""
    public var status = 0
    public var attachmentPath = ""
    public var hasAttachment = false

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        question = getString(value:json["question"])
        postedTime = getNSNumber(value: json["postedTime"])
        contentType = getString(value: json["contentType"])
        contentId = getString(value: json["contentId"])
        userId = getInt(value: json["userId"])
        userName = getString(value: json["userName"])
        status = getInt(value: json["status"])
        attachmentPath = getImageUrl(value: json["attachmentPath"])
        hasAttachment = getBool(value: json["hasAttachment"])
    }

    public static func questions(json : Any?) -> [Question]{
        var list = [Question]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Question(obj))
            }
        }
        return list
    }

}
