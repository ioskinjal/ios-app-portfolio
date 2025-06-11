//
//  SeasonsInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 05/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class SeasonsInfo: NSObject {
    public struct PlayButtonInfo {
        public var status = 0
        public var text = ""
        public var episodeId = 0
        internal init(){
            
        }
        
        internal init(with json : [String : Any]) {
            if let _status = json["status"] as? Int{
                status = _status
            }
            if let _text = json["text"] as? String{
                text = _text
            }
            if let _episodeId = json["episodeId"] as? Int{
                episodeId = _episodeId
            }
        }
    }
    
    public var playButtonInfo = SeasonsInfo.PlayButtonInfo()
    public var seasonDetails = SeasonDetails()

    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        if let _playButtonInfo = json["playButtonInfo"] as? [String : Any]{
            playButtonInfo = PlayButtonInfo.init(with: _playButtonInfo)
        }
        if let _seasonDetails = json["seasonDetails"] as? [String : Any]{
            seasonDetails = SeasonDetails.init(withJSON: _seasonDetails)
        }
    }
    
    
    public static func seasonsInfoList(json : [[String : Any]]) -> [SeasonsInfo]{
        var list = [SeasonsInfo]()
        for object in json {
            list.append(SeasonsInfo.init(withJSON: object))
        }
        return list
    }

}
