//
//  MovieStreamResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 31/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class MovieStreamResponse: NSObject {
    
    public var streams = [Stream]()
    public var sendPing = false
    public var pingIntervalInMillis : NSNumber = 0
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : Any?){
        super.init()
        guard let _json = json as? [String : Any] else {
            return
        }
        
        if let _streams = (_json["streams"]  as? [String : Any])?["streams"] as? [[String : Any]]{
            streams = Stream.streamList(json: _streams)
        }
        sendPing = Utility.getBoolValue(value: _json["sendPing"])
        pingIntervalInMillis = Utility.getNSNumberValue(value: _json["pingIntervalInMillis"])
    }
}
