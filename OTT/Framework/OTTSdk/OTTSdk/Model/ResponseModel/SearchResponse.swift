//
//  SearchResponse.swift
//  OTTSdk
//
//  Created by Chandra on 6/17/19.
//  Copyright © 2019 YuppTV. All rights reserved.
//

import UIKit

public class SearchResponse: YuppModel {
    public var sourceType = ""
    public var displayName = ""
    public var count = 0
    public var data = [Card]()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        sourceType = getString(value: json["sourceType"])
        displayName = getString(value: json["displayName"])
        count = getInt(value: json["count"])
        data = Card.cards(json: json["data"])
    }

    public static func searchArray(json : Any?) -> [SearchResponse]{
        var list = [SearchResponse]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(SearchResponse(obj))
            }
        }
        return list
    }

}
