//
//  SectionData.swift
//  YuppTV
//
//  Created by Muzaffar on 11/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SectionData: NSObject {

    public enum DataType {
        case unspecified
        case channel
        case movie
        case tvShow
        case tvShowEpisode
        case epg
    }
    
    public var name = ""
    public var count = 0
    public var code = ""
    public var lastIndex = 0
    public var lang = ""
    public var dataType = DataType.unspecified
    
    /// data can be [Channel],  or [Movie], based on dataType
    public var data = [Any]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        name = Utility.getStringValue(value: json["name"])
        code = Utility.getStringValue(value: json["code"])
        lang = Utility.getStringValue(value: json["lang"])
        
        if Utility.getStringValue(value: json["dataType"]) == "movie"{
            dataType = .movie
            if let _data =  json["data"] as? [[String : Any]]{
                data = Movie.movieList(json: _data)
            }
        }
        else if Utility.getStringValue(value: json["dataType"]) == "channel"{
            dataType = .channel
            if let _data =  json["data"] as? [[String : Any]]{
                data = Channel.channelList(json: _data)
            }
        }
        else if Utility.getStringValue(value: json["dataType"]) == "tvshow"{
            dataType = .tvShow
            if let _data =  json["data"] as? [[String : Any]]{
                data = TVShow.tvShowList(json:_data)
            }
        }
        else if Utility.getStringValue(value: json["dataType"]) == "tvshowepisode"{
            dataType = .tvShowEpisode
            if let _data =  json["data"] as? [[String : Any]]{
                data = Episode.episodesList(json: _data)
            }
        }
        else if Utility.getStringValue(value: json["dataType"]) == "epg"{
            dataType = .epg
            if let _data =  json["data"] as? [[String : Any]]{
                data =  Epg.channelList(json: _data)
            }
        }
        
        count = Utility.getIntValue(value: json["count"])
        lastIndex = Utility.getIntValue(value: json["lastIndex"])
        
    }
    
    public static func sectionDataList(json : [[String : Any]]) -> [SectionData]{
        var list = [SectionData]()
        for data in json {
            list.append(SectionData.init(withJSON: data))
        }
        return list
    }
    
   
}
