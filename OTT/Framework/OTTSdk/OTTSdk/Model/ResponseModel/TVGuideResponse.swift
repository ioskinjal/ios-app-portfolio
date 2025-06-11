//
//  TVGuideResponse.swift
//  OTTSdk
//
//  Created by Chandra Sekhar on 08/03/18.
//  Copyright © 2018 YuppTV. All rights reserved.
//

import UIKit

public class TVGuideResponse: YuppModel {
    public var tiltle = ""
    public var tabs = [TVGuideTab]()
    public var data = [ChannelObj]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        tiltle = getString(value: json["tiltle"])
        tabs = TVGuideTab.array(json: json["tabs"])
        data = ChannelObj.channelObjs(json: json["data"])
    }
}

public class TVGuideTab: YuppModel {
    
    public var subtitle = ""
    public var startTime = NSNumber()
    public var endTime = NSNumber()
    public var isSelected  = false
    public var title = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        subtitle = getString(value: json["subtitle"])
        startTime = getNSNumber(value:json["startTime"])
        endTime = getNSNumber(value: json["endTime"])
        isSelected = getBool(value:json["isSelected"])
        title = getString(value: json["title"])
    }
    
    public static func array(json : Any?) -> [TVGuideTab]{
        var list = [TVGuideTab]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(TVGuideTab(obj))
            }
        }
        return list
    }
}

public class ChannelObj: YuppModel, NSCopying  {
    
    public struct Target {
        public var path = ""
    }
    public var display = TVGuideDisplay()
    public var target = Target()
    public var metadata = Metadata()
    public var channelID = 0
    public var programs = [Program]()

    public func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init()
    }

    public required override init() {
        super.init()
    }

    public init(_ json : [String : Any]){
        super.init()
        
        channelID = getNSNumber(value: json["id"]).intValue
        
        if let dic = json["display"] as? [String : Any]{
            display = TVGuideDisplay(dic)
        }
                
        if let _target = json["target"] as? [String : Any]{
            target = Target.init(path: getString(value: _target["path"]))
        }
        if let _metadata = json["metadata"] as? [String : Any]{
            metadata = Metadata.init(_metadata)
        }
        if let _data = json["programs"] as? [[String : Any]]{
            programs = Program.programs(json: _data)
        }
    }
    
    
    public static func channelObjs(json : Any?) -> [ChannelObj]{
        var list = [ChannelObj]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(ChannelObj(obj))
            }
        }
        return list
    }

}

public class TVGuideDisplay: YuppModel {
    public var title = ""
    public var imageUrl = ""
    public var subtitle1 = ""
    public var subtitle2 = ""

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        title = getString(value: json["title"])
        imageUrl = getImageUrl(value: json["imageUrl"])
        subtitle1 = getString(value: json["subtitle1"])
        subtitle2 = getString(value: json["subtitle2"])
    }
}

public class ProgramTarget: YuppModel {
    public var path = ""
    public var pageAttributes = PageAttributes()
    
    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        path = getString(value: json["path"])
        pageAttributes = PageAttributes.init(json["pageAttributes"] as! [String : Any])
    }
}

public class Program: YuppModel {
    public var display = TVGuideDisplay()
    public var target = ProgramTarget()
    public var metadata = Metadata()
    public var programID = 0
    public var template = ""

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        programID = getInt(value: json["id"])
        template = getString(value: json["template"])

        if let dic = json["display"] as? [String : Any]{
            display = TVGuideDisplay(dic)
        }
                
        if let _target = json["target"] as? [String : Any]{
            target = ProgramTarget.init(_target)
        }
        if let _metadata = json["metadata"] as? [String : Any]{
            metadata = Metadata.init(_metadata)
        }
    }
    
    
    public static func programs(json : Any?) -> [Program]{
        var list = [Program]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Program(obj))
            }
        }
        return list
    }
}

public class PageAttributes: YuppModel {
    public var startTime = ""
    public var endTime = ""
    public var contentType = ""
    public var recordingForm = ""
    public var isRecordingAllowed = false
    public var isRecorded = false

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        startTime = getString(value: json["startTime"])
        endTime = getString(value: json["endTime"])
        contentType = getString(value: json["contentType"])
        recordingForm = getString(value: json["recordingForm"])
        isRecordingAllowed = (getString(value: json["isRecordingAllowed"]) != "false")
        isRecorded = (getString(value: json["isRecorded"]) != "false")
    }
}

public class ChannelProgramsResponse: YuppModel {
    public var channelId = 0
    public var programs = [Program]()

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        channelId = getInt(value: json["channelId"])
        programs = Program.programs(json: json["programs"])
    }
    
    public static func channelPrograms(json : Any?) -> [ChannelProgramsResponse]{
        var list = [ChannelProgramsResponse]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(ChannelProgramsResponse(obj))
            }
        }
        return list
    }

}

public class UserProgramResponse: YuppModel {
    public var channelId = 0
    public var programs = [UserProgram]()

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        channelId = getInt(value: json["channelId"])
        programs = UserProgram.userPrograms(json: json["programs"])
    }
    
    public static func userChannelPrograms(json : Any?) -> [UserProgramResponse]{
        var list = [UserProgramResponse]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(UserProgramResponse(obj))
            }
        }
        return list
    }

}

public class UserProgram: YuppModel {
    public var programId = 0

    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        
        programId = getInt(value: json["id"])
    }
    
    public static func userPrograms(json : Any?) -> [UserProgram]{
        var list = [UserProgram]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(UserProgram(obj))
            }
        }
        return list
    }

}
