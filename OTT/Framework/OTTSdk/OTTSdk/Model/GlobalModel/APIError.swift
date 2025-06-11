//
//  APIError.swift
//  YuppTV
//
//  Created by Muzaffar on 08/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class APIError: YuppModel {
    public internal(set) var code = 0
    public internal(set) var message = ""
    public internal(set) var type = ""
    public internal(set) var details : Details?
    public internal(set) var actionCode = -1
    
    public override init() {
        super.init()
    }
    
    init(withResponse response: [String : Any]) {
        super.init()
        code = getInt(value: response["code"])
        actionCode = getInt(value: response["actionCode"])
        message = getString(value: response["message"])
        type = getString(value: response["type"])
        if let _details = response["details"] as? [String : Any]{
            details = Details.init(_details)
        }
    }
    
    init(withError error: Error) {
        super.init()
        code = API.ErrorCode.SystemError
        message = error.localizedDescription
    }
    
    init(withMessage _message: String) {
        super.init()
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
public class Details: YuppModel {
    public var identifier = ""
    public var referenceId = ""
    public var phoneNumber = ""
    public var errorDescription = ""

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        referenceId = getString(value: json["referenceId"])
        phoneNumber = getString(value: json["phoneNumber"])
        errorDescription = getString(value: json["description"])
        identifier = getString(value: json["identifier"])
    }
}
