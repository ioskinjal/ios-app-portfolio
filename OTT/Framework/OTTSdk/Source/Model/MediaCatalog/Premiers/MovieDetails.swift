//
//  MovieDetails.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class MovieDetails: NSObject {
  
    ///’Y’ or ‘P’ , Y=payPerView P=FDFS movie
    public enum MovieType : String{
        case payPerView = "Y"
        case fdfsMovie = "P"
    }
    
    public var duration = 0
    public var releaseDate : NSNumber = 0
    public var name = ""
    public var genre = ""
    public var castCrew = CastCrew()
    public var movieType = MovieType.payPerView
    public var backgroundImage = ""
    public var movieDetailsDescription = ""
    public var tag = ""
    public var code = ""
    public var langCode = ""
    public var movieId = 0
    public var uploadDate : NSNumber = 0
    public var language = ""
    public var rating = 0
    public var views = 0
    public var newCastCrew = [NewCastCrew]()
    public var subtitles = false
    public var hd = false
    public var iconUrl = ""
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        duration = Utility.getIntValue(value: json["duration"])
        releaseDate = Utility.getNSNumberValue(value: json["releaseDate"])
        name = Utility.getStringValue(value: json["name"])
        genre = Utility.getStringValue(value: json["genre"])
        castCrew = CastCrew.init(withJSON: json["castCrew"])
        movieType = (Utility.getStringValue(value: json["movieType"]) == "Y") ? .payPerView : .fdfsMovie
        backgroundImage = Utility.getStringValue(value: json["backgroundImage"])
        movieDetailsDescription = Utility.getStringValue(value: json["description"])
        tag = Utility.getStringValue(value: json["tag"])
        code = Utility.getStringValue(value: json["code"])
        langCode = Utility.getStringValue(value: json["langCode"])
        movieId = Utility.getIntValue(value: json["id"])
        uploadDate = Utility.getNSNumberValue(value: json["uploadDate"])
        language = Utility.getStringValue(value: json["language"])
        rating = Utility.getIntValue(value: json["rating"])
        views = Utility.getIntValue(value: json["views"])
        newCastCrew = NewCastCrew.newCastCrewList(withJSON: json["newCastCrew"])
        subtitles = Utility.getBoolValue(value: json["subtitles"])
        hd = Utility.getBoolValue(value: json["hd"])
        iconUrl = Utility.getStringValue(value: json["iconUrl"])
    }
}
