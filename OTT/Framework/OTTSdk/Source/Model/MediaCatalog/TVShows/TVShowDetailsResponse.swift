//
//  TVShowDetailsResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 05/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TVShowDetailsResponse: NSObject {
    public struct SelectedSeasonEpisodes {
        public var count = 0
        public var lastIndex = -1
        public var episodes = [Episode]()
        internal init(){
            
        }
        internal init(with json : [String : Any]) {
            if let _count = json["count"] as? Int{
                count = _count
            }
            if let _lastIndex = json["lastIndex"] as? Int{
                lastIndex = _lastIndex
            }
            if let _episodes = json["episodes"] as? [[String : Any]]{
                episodes = Episode.episodesList(json: _episodes)
            }
        }
    }
    public struct Recommendations {
        public var count = 0
        public var lastIndex = -1
        public var shows = [TVShow]()
        internal init(){
            
        }
        internal init(with json : [String : Any]) {
            if let _count = json["count"] as? Int{
                count = _count
            }
            if let _lastIndex = json["lastIndex"] as? Int{
                lastIndex = _lastIndex
            }
            if let _shows = json["shows"] as? [[String : Any]]{
                shows = TVShow.tvShowList(json: _shows)
            }
        }
    }

    public var seasonsInfo = [SeasonsInfo]()
    public var info = TVShowInfo()
    public var selectedSeasonId = 0
    public var selectedSeasonEpisodes = SelectedSeasonEpisodes()
    public var recommendations = Recommendations()
    
    
    public init(withJSON json : [String : Any]){
        super.init()
        if let _seasonsInfo = json["seasonsInfo"] as? [[String : Any]]{
            seasonsInfo = SeasonsInfo.seasonsInfoList(json: _seasonsInfo)
        }
        if let _info = json["info"] as? [String : Any]{
            info = TVShowInfo.init(withJSON: _info)
        }
        selectedSeasonId = Utility.getIntValue(value: json["selectedSeasonId"])
        if let _selectedSeasonEpisodes = json["selectedSeasonEpisodes"] as? [String : Any]{
            selectedSeasonEpisodes = SelectedSeasonEpisodes.init(with: _selectedSeasonEpisodes)
        }
        if let _recommendations = json["recommendations"] as? [String : Any]{
            recommendations = Recommendations.init(with: _recommendations)
        }
    }
    
}
