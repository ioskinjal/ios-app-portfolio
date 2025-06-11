//
//  Content.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public enum DataElement : String{
    case unknown = "unknown"
    case text = "text"
    case marker = "marker"
    case button = "button"
    case hyperlink = "hyperlink"
    case image = "image"
    case description = "description"
    case html = "html"
}

public class Content: YuppModel {
    
    public var backgroundImage = ""
    public var contentDescription = ""
    public var dataRows = [DataRow]()
    public var posterImage = ""
    public var title = ""
    
    internal override init() {
        super.init()
    }
    
    internal init(_ json : [String : Any]){
        super.init()
        
        backgroundImage = getImageUrl(value: json["backgroundImage"])
        contentDescription = getString(value: json["description"])
        dataRows = DataRow.dataRows(json:  json["dataRows"])
        posterImage = getImageUrl(value: json["posterImage"])
        title = getString(value: json["title"])
    }
}

public class DataRow: YuppModel {
    
    public var elements = [Element]()
    public var rowDataType = ""
    public var rowNumber = 0

    internal override init() {
        super.init()
    }
    
    internal init(_ json : [String : Any]){
        super.init()
        elements = Element.elements(json: json["elements"])
        rowDataType = getString(value: json["rowDataType"])
        rowNumber = getInt(value: json["rowNumber"])
    }
    
    internal static func dataRows(json : Any?) -> [DataRow]{
        var list = [DataRow]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(DataRow(obj))
            }
        }
        return list
    }
}


public class Element: YuppModel {
    
    public var elementSubtype = ""
    public var elementCode = ""
    public var contentCode = ""
    public var data = ""
    public var color = ""
    public var bgColor = ""
    public var id = -1
    public var target = ""
    public var isClickable = false
    public var elementType = DataElement.unknown

    internal override init() {
        super.init()
    }
    
    internal init(_ json : [String : Any]){
        super.init()
        
        elementSubtype = getString(value: json["elementSubtype"])
        elementCode = getString(value: json["elementCode"])
        contentCode = getString(value: json["contentCode"])
        color = getString(value: json["color"])
        bgColor = getString(value: json["bgColor"])
        id = getInt(value: json["id"])
        target = getString(value: json["target"])
        isClickable = getBool(value: json["isClickable"])
        if let dataElement = DataElement(rawValue: getString(value: json["elementType"])){
            elementType = dataElement
        }
        if elementType == .image{
            data = getImageUrl(value:  json["data"])
        }
        else{
            data = getString(value: json["data"])
        }
    }
    
    internal static func elements(json : Any?) -> [Element]{
        var list = [Element]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Element(obj))
            }
        }
        return list
    }
    
}
