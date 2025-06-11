//
//  PlayButtonInfo.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 24/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PlayButtonInfo: NSObject {
    public enum Status : Int{
        case beforeLogin = 0
        case afterSubscribe = 1
        case afterLogin = 2
    }

    /**
     - Before login - Status :0 & text: Login to Watch
     - After login – Status: 2 & text: Subscribe
     - After Subscribe – Status: 1 & text: Watch
     */
    public var status = Status.beforeLogin
    public var text = ""
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        switch Utility.getIntValue(value: json["status"]) {
        case 0:
            status = .beforeLogin
            break
        case 1:
            status = .afterSubscribe
            break
        case 2:
            status = .afterLogin
            break
        default:
            status = .beforeLogin
        }
        
        
        text = Utility.getStringValue(value: json["text"])
    }
}
