//
//  PremiumMoviesListResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 22/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PremiumMoviesListResponse: NSObject {
    
    public var count = 0
    public var lastIndex = 0
    public var movies = [Movie]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        count = Utility.getIntValue(value: json["count"])
        lastIndex = Utility.getIntValue(value: json["lastIndex"])
        if let _movies =  json["movies"] as? [[String : Any]]{
            movies = Movie.movieList(json: _movies)
        }
    }
    
}
