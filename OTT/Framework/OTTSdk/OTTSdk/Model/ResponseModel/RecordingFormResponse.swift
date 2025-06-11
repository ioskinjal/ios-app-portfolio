//
//  RecordingFormResponse.swift
//  OTTSdk
//
//  Created by Chandra on 6/25/19.
//  Copyright © 2019 YuppTV. All rights reserved.
//

import UIKit

public class RecordingFormResponse: YuppModel {
    public var path = ""
    public var backgroundImage = ""
    public var code = ""
    public var title = ""
    public var elements = [FormElement]()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        path = getString(value: json["path"])
        backgroundImage = getImageUrl(value: json["backgroundImage"])
        code = getString(value: json["code"])
        title = getString(value: json["title"])
        elements = FormElement.array(json: json["elements"])
    }
}

public class FormElement: YuppModel {
    public var data = ""
    public var rowNumber = 0
    public var elementCode = ""
    public var columnSpan = 0
    public var id = 0
    public var formCode = ""
    public var columnNumber = 0
    public var rowSpan = 0
    public var fieldType = ""
    public var value = ""
    public var properties = Property()

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        data = getString(value: json["data"])
        rowNumber = getInt(value: json["rowNumber"])
        elementCode = getString(value: json["elementCode"])
        columnSpan = getInt(value: json["columnSpan"])
        id = getInt(value: json["id"])
        formCode = getString(value: json["formCode"])
        columnNumber = getInt(value: json["columnNumber"])
        rowSpan = getInt(value: json["rowSpan"])
        fieldType = getString(value: json["fieldType"])
        value = getString(value: json["value"])
        properties = Property.init(json["properties"] as! [String : Any])
    }

    public static func array(json : Any?) -> [FormElement]{
        var list = [FormElement]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(FormElement(obj))
            }
        }
        return list
    }

}

public class Property: YuppModel {
    public var group_id = ""
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        group_id = getString(value: json["group_id"])
    }
}
