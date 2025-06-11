//
//  APIConstants.swift
//  YuppTV
//
//  Created by Muzaffar on 04/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

class APIConstants: NSObject {
    ///manufacturer is used in APIs like signIn and signUp.
    static internal let manufacturer = "Apple"
    
    /// Default error message used when unable to findout any error message from API calls
    static internal let defaultErrorMessage = "Unable to process your request. Please try after some time."
    
    struct Key {
        static let boxId = "key-boxId"
        static let sessionKey = "key-sessionKey"
        static let countryKey = "key-countryKey"
        static let user = "key-user"
        static let countryCodeKey = "key-countryCodeKey"
        static let isLive = "isLive"
        static let isEncryptionEnabled = "isEncryptionEnabled"
        static let logType = "logType"
        static let requestTimeout = "requestTimeout"
        static let localLanguages = "key-localLanguages"
        
    }
}
