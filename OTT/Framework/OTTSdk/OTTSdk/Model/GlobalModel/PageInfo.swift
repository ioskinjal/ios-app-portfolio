//
//  PageInfo.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PageInfo: YuppModel {
    public enum PageType : String {
        case unKnown = "unKnown"
        case content = "content"
        case details = "details"
        case list = "list"
        case player = "player"
    }
    
    public var pageType = PageType.unKnown
    public var code = ""
    public var path = ""
    public var attributes = InfoAttributes()
    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        if let _pageType = PageType.init(rawValue: getString(value: json["pageType"])){
            pageType = _pageType
        }
        attributes = InfoAttributes.init(json["attributes"] as! [String : Any])
        code = getString(value: json["code"])
        path = getString(value: json["path"])
    }
}

public class InfoAttributes: YuppModel {
    public var contentType = ""
    public var endTime = NSNumber()
    public var isLive = false
    public var startTime = NSNumber()
    public var isRecorded = false
    public var recordingForm = ""
    public var isRecordingAllowed = false
    public var takeaTestStartTime = NSNumber()
    public var takeaTestURL = ""
    public var watchedPosition = 0.0
    public var playerType = ""
    public var nextButtonTitle = ""
    public var showNextButton = ""
    public var recommendationText = ""
    public var introEndTime = 0
    public var introStartTime = 0
    public var contentId = ""
    public var SignAndSignupErrorMessage = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        contentType = getString(value: json["contentType"])
        endTime = getNSNumber(value: json["endTime"])
        isLive = getBool(value: json["isLive"])
        startTime = getNSNumber(value: json["startTime"])
        isRecorded = getBool(value: json["isRecorded"])
        recordingForm = getString(value: json["recordingForm"])
        isRecordingAllowed = getBool(value: json["isRecordingAllowed"])
        takeaTestStartTime = getNSNumber(value: json["takeaTestStartTime"])
        takeaTestURL = getString(value: json["takeaTestURL"])
        watchedPosition = Double(getFloat(value:  json["watchedPosition"]))
        playerType = getString(value: json["playerType"])
        nextButtonTitle = getString(value : json["nextButtonTitle"])
        showNextButton = getString(value : json["showNextButton"])
        recommendationText = getString(value : json["recommendationText"])
        introEndTime = getInt(value : json["introEndTime"])
        introStartTime = getInt(value : json["introStartTime"])
        contentId = getString(value : json["contentId"])
        SignAndSignupErrorMessage = getString(value: json["SignAndSignupErrorMessage"])
    }

}
