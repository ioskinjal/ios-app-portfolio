//
//  StreamKeyResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 26/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class StreamKeyResponse: NSObject {
    public enum Status : Int{
        case unknown = 0
        case verified = 1
        case notVerified = 2
    }
    
    /**
     1 - Verified
     
     2 - Verification link sent , not verified
     */
    public var status = StreamKeyResponse.Status.unknown
    public var data = ""
    public var showTerms = false
    public var terms = StreamKeyTerms()
    
    internal override init() {
        super.init()
    }
    
    internal init(withJSON json : [String : Any]){
        super.init()
        let _status = Utility.getIntValue(value: json["status"])
        if _status == 0 ||  _status == 1 || _status == 2{
            status = StreamKeyResponse.Status(rawValue: Utility.getIntValue(value: json["status"]))!
        }
        data = Utility.getStringValue(value: json["data"])
        showTerms = Utility.getBoolValue(value: json["showTerms"])
        terms = StreamKeyTerms.init(withJSON: json["terms"])
    }
    
}
