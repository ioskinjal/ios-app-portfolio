//
//  Preference.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Preference: NSObject , NSCoding{
    public var lang = "all"
    public var genres = ""
    public var cast = ""
    
    public override init() {
        super.init()
    }
    
    public init(withJson response: [String : Any]) {
        super.init()
        lang = Utility.getStringValue(value: response["lang"])
        genres = Utility.getStringValue(value: response["genres"])
        cast = Utility.getStringValue(value: response["cast"])
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        if let lang = aDecoder.decodeObject(forKey: "lang") as? String {
            self.lang = lang
        }
        if let genres = aDecoder.decodeObject(forKey: "genres") as? String {
            self.genres = genres
        }
        if let cast = aDecoder.decodeObject(forKey: "cast") as? String {
            self.cast = cast
        }
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lang, forKey: "lang")
        aCoder.encode(genres, forKey: "genres")
        aCoder.encode(cast, forKey: "cast")
        
    }
}
