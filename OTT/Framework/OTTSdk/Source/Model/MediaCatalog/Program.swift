//
//  Program.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 18/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Program: NSObject {
    
    public var day = 0
    public var title = ""
    public var data = [ProgramEPG]()
    
    internal override init() {
        super.init()
    }
    
    public init(withJSON json : [String : Any]){
        super.init()
        
        day = Utility.getIntValue(value: json["day"])
        title = Utility.getStringValue(value: json["title"])
        if let _epgs = json["data"] as? [[String : Any]]{
            data =  ProgramEPG.epgList(json: _epgs)
        }
    }
    
    public static func programEpgList(json : [[String : Any]]) -> [Program]{
        var list = [Program]()
        for obj in json {
            list.append(Program.init(withJSON: obj))
        }
        return list
    }
}
