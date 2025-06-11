//
//  APIError.swift
//  YuppTV
//
//  Created by Muzaffar on 08/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class APIError: NSObject {
    public internal(set) var code = 0
    public internal(set) var message = ""
    
    public override init() {
        super.init()
    }
    
    init(withResponse response: [String : Any]) {
        code = Utility.getIntValue(value: response["code"])
        message = Utility.getStringValue(value: response["message"])
    }
    
    init(withError error: Error) {
        code = API.ErrorCode.SystemError
        message = error.localizedDescription
    }
    
    init(withMessage _message: String) {
        code = API.ErrorCode.ApiErrorInText
        message = _message
    }
    
    public static func defaultError() -> APIError{
        let error = APIError()
        error.code = API.ErrorCode.DefaultError
        error.message = APIConstants.defaultErrorMessage
        return error
    }
    
    public override var description: String{
        return "\n Code : \(code)\nMessage : \(message)"
    }
    

}
