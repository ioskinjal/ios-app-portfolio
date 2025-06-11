//
//  AboutUs.swift
//  YuppTVSdk
//
//  Created by Muzaffar on 16/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class AboutUs: NSObject {
    public struct Info{
        public var text = ""
        
        internal init(){ }
        
        internal init(infoDic : Any?) {
            guard let _infoDic = infoDic as? [String : Any] else {
                return
            }
            text = Utility.getStringValue(value: _infoDic["text"])
        }
    }
    public struct DetailedInfo{
        public var text = ""
        public var image = ""
       
        internal init(){ }
        
        init(infoDic : Any?) {
            guard let _infoDic = infoDic as? [String : Any] else {
                return
            }
            text = Utility.getStringValue(value: _infoDic["text"])
            image = Utility.getStringValue(value: _infoDic["image"])
        }
        
        static func details(with array : Any?) -> [DetailedInfo]{
            var list = [DetailedInfo]()
            if let objJson = array as? [[String : Any]]{
                for obj in objJson {
                    list.append(DetailedInfo.init(infoDic: obj))
                }
            }
            return list
        }
    }
    
    public struct About{
        public var title = Info()
        public var description = DetailedInfo()
    }
    
    public struct PackageContent{
        public var title = Info()
        public var description = DetailedInfo()
        public var features = [DetailedInfo]()
    }
    
    public struct PackageProcess{
        public var title = Info()
        public var features = [DetailedInfo]()
    }
    
    public var about = About()
    public var packageContent = PackageContent()
    public var packageProcess = PackageProcess()
    
    internal init(withJson json: [String : Any]){
        super.init()
        if let aboutDic = json["about"] as? [String : Any]{
            let title = Info.init(infoDic: aboutDic["title"])
            let desc = DetailedInfo.init(infoDic: aboutDic["description"])
            about = About.init(title: title, description: desc)
        }
        
        if let packageContentDic = json["packageContent"] as? [String : Any]{
            let title = Info.init(infoDic: packageContentDic["title"])
            let desc = DetailedInfo.init(infoDic: packageContentDic["description"])
            let features = DetailedInfo.details(with: packageContentDic["features"])
            packageContent = PackageContent.init(title: title, description: desc, features: features)
        }
        
        if let packageProcessDic = json["packageProcess"] as? [String : Any]{
            let title = Info.init(infoDic: packageProcessDic["title"])
            let features = DetailedInfo.details(with: packageProcessDic["features"])
            packageProcess = PackageProcess.init(title: title, features: features)
        }
    }
}
