//
//  NextPage.swift
//  YuppTV
//
//  Created by Muzaffar on 10/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class NextPage: NSObject {
    
    public enum Name {
        case undefined
        case emailVerification
        case mobileVerification
        case dialog
    }
    
    public var name = Name.undefined
    public var additionalInfo = AdditionalInfo()
    internal override init() {
        super.init()
    }
    
    public init(withJson json: [String : Any]){
        super.init()
        let _name = Utility.getStringValue(value: json["name"])
        if _name == "emailverification"{
            name = .emailVerification
        }
        else if _name == "mobileverification"{
            name = .mobileVerification
        }
        else if _name == "dialog"{
            name = .dialog
        }
        
        if let info = json["additionalInfo"] as? [String : Any]{
            additionalInfo = AdditionalInfo.init(withJson: info)
        }
    }
}
