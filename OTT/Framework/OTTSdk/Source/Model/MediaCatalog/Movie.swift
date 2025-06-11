//
//  Movie.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Movie: NSObject {

    public var duration = 0
    public var releaseDate : NSNumber = 0
    public var name = ""
    public var genre = ""
    public var castCrew = CastCrew()
    public var movieType = ""
    public var backgroundImage = ""
    public var movieDescription = ""
    public var tag = ""
    public var code = ""
    public var langCode = ""
    public var movieId = 0
    public var uploadDate : NSNumber = 0
    public var language = ""
    public var rating = 0
    public var views = 0
    public var subtitles = 0
    public var hd = 0
    public var action = ""
    public var iconUrl = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        
        guard let jsonObj = json as? [String : Any] else {
            return
        }
       
        duration = Utility.getIntValue(value: jsonObj["duration"])
        releaseDate = Utility.getNSNumberValue(value: jsonObj["releaseDate"])
        name = Utility.getStringValue(value: jsonObj["name"])
        genre = Utility.getStringValue(value: jsonObj["genre"])
        castCrew = CastCrew.init(withJSON: jsonObj["castCrew"])
        movieType = Utility.getStringValue(value: jsonObj["movieType"])
        backgroundImage = Utility.getStringValue(value: jsonObj["backgroundImage"])
        movieDescription = Utility.getStringValue(value: jsonObj["description"])
        tag = Utility.getStringValue(value: jsonObj["tag"])
        code = Utility.getStringValue(value: jsonObj["code"])
        langCode = Utility.getStringValue(value: jsonObj["langCode"])
        movieId = Utility.getIntValue(value: jsonObj["id"])
        uploadDate = Utility.getNSNumberValue(value: jsonObj["uploadDate"])
        language = Utility.getStringValue(value: jsonObj["language"])
        rating = Utility.getIntValue(value: jsonObj["rating"])
        views = Utility.getIntValue(value: jsonObj["views"])
        subtitles = Utility.getIntValue(value: jsonObj["subtitles"])
        hd = Utility.getIntValue(value: jsonObj["hd"])
        action = Utility.getStringValue(value: jsonObj["action"])
        iconUrl = Utility.getStringValue(value: jsonObj["iconUrl"])
    }
    
    public static func movieList(json : [[String : Any]]) -> [Movie]{
        var list = [Movie]()
        for object in json {
            list.append(Movie.init(withJSON: object))
        }
        return list
    }
    
    
}
