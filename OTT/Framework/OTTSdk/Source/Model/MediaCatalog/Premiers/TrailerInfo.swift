//
//  TrailerInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class TrailerInfo: NSObject {
    
    public var showTrailer = false
    public var trailers = [Trailer]()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        showTrailer = Utility.getBoolValue(value: json["showTrailer"])
        trailers = Trailer.trailers(withJSON: json["trailers"])
    }
    
}
