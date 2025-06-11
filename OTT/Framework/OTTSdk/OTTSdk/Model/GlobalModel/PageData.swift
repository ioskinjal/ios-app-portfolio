//
//  PageData.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class PageData: YuppModel {
    
    public enum PaneType : String {
        case unknown = "unknown"
        
        /// contains set of cards
        case section = "section"
        
        /// has set of rows, whereas each row can have multiple elements
        case content = "content"
        
        
        case adContent = "adContent"
    }
    
    public var paneType = PaneType.unknown
    public var paneData : Any?
    public var adPositionIndex:Int = 0
    
    
    public override init() {
        super.init()
    }
    
    public init(_ json : [String : Any], isMultiRow: Bool = false, firstRowCount:Int = -1, isFirstRow:Bool = true){
        super.init()
        
        if let _paneType = PaneType(rawValue: getString(value: json["paneType"])){
            paneType = _paneType
        }
        
        switch paneType {
        case .section:
            if let _sec = json["section"] as? [String : Any]{
                paneData = Section(_sec, isMultiRow: isMultiRow, firstRowCount: firstRowCount,isFirstRow: isFirstRow)
            }
            break
        case .content:
            if let _content = json["content"] as? [String : Any]{
                paneData = Content(_content)
            }
            break
        default:
            if let _sec = json["section"] as? [String : Any]{
                paneData = Section(_sec)
            }
            break
        }
    }
    
    public static func data(json : Any?) -> [PageData]{
        var list = [PageData]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                var isMultiRow = false
                var firstRowCount = -1
                if let tempPageType =  obj["paneType"] as? String, tempPageType == "section" {
                    if let _sec = obj["section"] as? [String : Any]{
                        if let _sectionData = (_sec["sectionData"] as? [String:Any]) {
                            if let _params = (_sectionData["params"] as? [String:Any]) {
                                if let _isMultiRow = (_params["isMultiRow"] as? String) {
                                    isMultiRow = (_isMultiRow == "true" ? true : false)
                                    if let _firstRowCount = (_params["firstRowCount"] as? String) {
                                        firstRowCount = Int(_firstRowCount) ?? -1
                                    }
                                }
                            }
                        }
                    }
                    if isMultiRow == true {
                        list.append(PageData(obj, isMultiRow: isMultiRow, firstRowCount: firstRowCount, isFirstRow: true))
                        list.append(PageData(obj, isMultiRow: isMultiRow, firstRowCount: firstRowCount, isFirstRow: false))
                    }
                    else {
                        list.append(PageData(obj))
                    }
                }
                else {
                    list.append(PageData(obj))
                }
            }
        }
        return list
    }
}
