//
//  FreeTrial.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 17/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class FreeTrial: NSObject {
    public var freeTrialId = 0
    public var title = ""
    public var freeTrialDescription = ""
    
    internal init(withJson json: [String : Any]){
        super.init()
        freeTrialId = Utility.getIntValue(value: json["id"])
        title = Utility.getStringValue(value: json["title"])
        freeTrialDescription = Utility.getStringValue(value: json["description"])
    }
    
    public static func freeTrialList(json : Any?) -> [FreeTrial]{
        var list = [FreeTrial]()
        if let objJson = json as? [[String : Any]]{
            for obj in objJson {
                list.append(FreeTrial.init(withJson: obj))
            }
        }
        return list
    }
}
