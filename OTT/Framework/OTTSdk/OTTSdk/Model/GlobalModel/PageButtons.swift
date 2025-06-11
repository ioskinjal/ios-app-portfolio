//
//  PageButtons.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 18/09/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PageButtons: YuppModel {
    public var isFavourite = false
    public var showFavouriteButton = false
    public var record : Record?
    public var feedback : Feedback?
    public var downloadOptions = DownloadOptions()
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        isFavourite = getBool(value: json["isFavourite"])
        showFavouriteButton = getBool(value: json["showFavouriteButton"])
        if let _record = json["record"] as? [String : Any]{
            record = Record.init(_record)
        }
        if let _feedback = json["feedback"] as? [String : Any]{
            feedback = Feedback.init(_feedback)
        }
        if let _download = json["download"] as? [String:Any] {
            downloadOptions = DownloadOptions.init(_download)
        }
    }

}

public class Record: YuppModel {
    
    public var buttonText = ""
    public var channelId = ""
    public var isRecorded = false

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        buttonText = getString(value: json["buttonText"])
        channelId = getString(value: json["channelId"])
        isRecorded = getBool(value: json["isRecorded"])
    }
    
}

public class Feedback: YuppModel {
    public var feedbackAllowed = false
    public var showFeedback = false
    public var userFeedbackRecord : UserFeedbackRecord?
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        showFeedback = getBool(value: json["showFeedback"])
        feedbackAllowed = getBool(value: json["feedbackAllowed"])
        if let _userFeedbackRecord = json["userFeedbackRecord"] as? [String : Any]{
            userFeedbackRecord = UserFeedbackRecord.init(_userFeedbackRecord)
        }
    }
    
}

public class UserFeedbackRecord: YuppModel {
    public var rating = 0
    public var feedBackDescription = ""
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        rating = getInt(value: json["rating"])
        feedBackDescription = getString(value: json["description"])
    }
    
} 
public class DownloadOptions: YuppModel {
    public var message = ""
    public var showDownload = false

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        message = getString(value: json["message"])
        showDownload = getBool(value: json["showDownload"])
    }

}
