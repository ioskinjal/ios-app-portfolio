//
//  Section.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Section: YuppModel {
    
    public var sectionInfo = SectionInfo()
    public var sectionData = SectionData()
    public var sectionControls = SectionControls()
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any], isMultiRow: Bool = false, firstRowCount:Int = -1, isFirstRow:Bool = true){
        super.init()
        
        if let _info = json["sectionInfo"] as? [String : Any]{
            sectionInfo = SectionInfo(_info, isMultiRow: isMultiRow, firstRowCount: firstRowCount, isFirstRow: isFirstRow)
        }
        if let _data = json["sectionData"] as? [String : Any]{
            sectionData = SectionData(_data, isMultiRow: isMultiRow, firstRowCount: firstRowCount, isFirstRow: isFirstRow)
        }
        if let _controls = json["sectionControls"] as? [String : Any]{
            sectionControls = SectionControls(_controls, isMultiRow: isMultiRow, firstRowCount: firstRowCount, isFirstRow: isFirstRow)
        }
    }
    
}

public class SectionInfo: YuppModel {
    
    public var name = ""
    public var sectionDescription = ""
    public var dataSubType = ""
    public var bannerImage = ""
    public var showLanguageFilter = false
    public var code = ""
    public var id = -1
    public var showGenreFilter = false
    public var dataType = ""
    public var iconUrl = ""
    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any],isMultiRow: Bool = false, firstRowCount:Int = -1, isFirstRow:Bool = true){
        super.init()
        if isMultiRow == true && isFirstRow == false {
            name = ""
            sectionDescription = ""
            dataSubType = ""
            bannerImage = getImageUrl(value: json["bannerImage"])
            showLanguageFilter = getBool(value: json["showLanguageFilter"])
            code = getString(value: json["code"])
            id = getInt(value: json["id"])
            showGenreFilter = getBool(value: json["showGenreFilter"])
            dataType = getString(value: json["dataType"])
            iconUrl = getImageUrl(value: json["iconUrl"])
        }
        else {
            name = getString(value: json["name"])
            sectionDescription = getString(value: json["description"])
            dataSubType = getString(value: json["dataSubType"])
            bannerImage = getImageUrl(value: json["bannerImage"])
            showLanguageFilter = getBool(value: json["showLanguageFilter"])
            code = getString(value: json["code"])
            id = getInt(value: json["id"])
            showGenreFilter = getBool(value: json["showGenreFilter"])
            dataType = getString(value: json["dataType"])
            iconUrl = getImageUrl(value: json["iconUrl"])
        }
    }
}

public class SectionData: YuppModel {
    
    public var section = ""
    public var data = [Card]()
    public var lastIndex = -1
    public var hasMoreData = false
    public var dataRequestDelay = 0
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any], isMultiRow: Bool = false, firstRowCount:Int = -1, isFirstRow:Bool = true){
        super.init()
        
        if isMultiRow == true {
            
            if isFirstRow == false {
                section = getString(value: json["section"])
                if let _data = json["data"] as? [[String : Any]]{
                    data = Card.cards(json: _data,limit: (_data.count - firstRowCount), startIndex : firstRowCount)
                }
                lastIndex = getInt(value: json["lastIndex"])
                dataRequestDelay = getCLong(value: json["dataRequestDelay"], defaultValue: 0)
                hasMoreData = false
            }
            else {
                section = getString(value: json["section"])
                if let _data = json["data"] as? [[String : Any]]{
                    data = Card.cards(json: _data,limit:firstRowCount, startIndex : 0)
                }
                lastIndex = getInt(value: json["lastIndex"])
                dataRequestDelay = getCLong(value: json["dataRequestDelay"], defaultValue: 0)
                hasMoreData = getBool(value: json["hasMoreData"])
            }
        }
        else {
            section = getString(value: json["section"])
            if let _data = json["data"] as? [[String : Any]]{
                data = Card.cards(json: _data)
            }
            lastIndex = getInt(value: json["lastIndex"])
            dataRequestDelay = getCLong(value: json["dataRequestDelay"], defaultValue: 0)
            hasMoreData = getBool(value: json["hasMoreData"])
        }
    }
    
    public static func sectionsDataList(json : Any?) -> [SectionData]{
        var list = [SectionData]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(SectionData(obj))
            }
        }
        return list
    }
}

public class SectionControls: YuppModel {
    

    public var showViewAll = false
    public var viewAllTargetPath = ""
    public var infiniteScroll = false
    
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any],isMultiRow: Bool = false, firstRowCount:Int = -1, isFirstRow:Bool = true){
        super.init()
        
        if isMultiRow == true && isFirstRow == false {
            showViewAll = false
            viewAllTargetPath = ""
            infiniteScroll = getBool(value: json["infiniteScroll"])
        }
        else {
            showViewAll = getBool(value: json["showViewAll"])
            viewAllTargetPath = getString(value: json["viewAllTargetPath"])
            infiniteScroll = getBool(value: json["infiniteScroll"])
        }
    }
}
