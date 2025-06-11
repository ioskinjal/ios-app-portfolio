//
//  ActivateFreeTrialResponse.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 18/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class ActivateFreeTrialResponse: NSObject {
    //    public var additionalInfo = AdditionalInfo()
    public var nextPage = NextPage()
    public var message = ""
    
    internal init(withJson json: [String : Any]){
        super.init()
        message = Utility.getStringValue(value: json["message"])
        if let _nextPage = json["nextPage"] as? [String : Any]{
            nextPage = NextPage.init(withJson: _nextPage)
        }
    }
}
