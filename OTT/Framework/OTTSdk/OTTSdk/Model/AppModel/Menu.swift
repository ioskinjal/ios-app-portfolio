//
//  Menu.swift
//  OTTSdk
//
//  Created by Muzaffar on 30/06/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class Menu: YuppModel {
    
    public var menuDescription = ""
    public var subMenus : [SubMenu]?
    public var displayText = ""
    public var isClickable = true
    public var targetPath  = ""
    public var code  = ""
    public var params : Parameters?
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        menuDescription = getString(value: json["description"])
        subMenus = SubMenu.submenus(json: json["subMenus"] as? [Any])
        displayText = getString(value: json["displayText"])
        isClickable = getBool(value: json["isClickable"])
        targetPath = getString(value: json["targetPath"])
        code = getString(value: json["code"])
        if let parameters = json["params"] as? [String: Any], parameters.count > 0 {
            params = Parameters(parameters)
        }
    }
    
    public static func menus(json : Any?) -> [Menu]{
        var list = [Menu]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(Menu(obj))
            }
        }
        return list
    }
}
public class SubMenu: YuppModel {
    
    public var menuDescription = ""
    public var subMenus : [Any]?
    public var displayText = ""
    public var isClickable = true
    public var targetPath  = ""
    public var code  = ""
    public var params : Parameters?
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        menuDescription = getString(value: json["description"])
        subMenus = json["subMenus"] as? [Any]
        displayText = getString(value: json["displayText"])
        isClickable = getBool(value: json["isClickable"])
        targetPath = getString(value: json["targetPath"])
        code = getString(value: json["code"])
        if let parameters = json["params"] as? [String: Any], parameters.count > 0 {
            params = Parameters(parameters)
        }
    }
    
    public static func submenus(json : Any?) -> [SubMenu]{
        var list = [SubMenu]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(SubMenu(obj))
            }
        }
        return list
    }
}
public class Parameters : YuppModel {
    public var targetType = "menu"
    public var mockTestList : [MockTestList]?
    public var isLoginRequired = false
    public var loginMessage = ""
    public var isPinRequired = false
    public var pinMessage = ""
    public var isDarkMenu = false
    
    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        targetType = getString(value: json["targetType"]).lowercased()
        if targetType.trimmingCharacters(in: .whitespaces) == "" {
            //targetType = "menu".lowercased()
        }
        
        if let _mockTestString = json["mockTestList"] as? String {
            let _mockTestList = Parameters.getConvertedDictionary(text: _mockTestString)
            mockTestList = MockTestList.mockTestListArray(json: _mockTestList?["mockTestList"] as? [Any])
        }
        if let _isLoginRequired = json["isLoginRequired"] as? String {
            isLoginRequired = getBool(value: _isLoginRequired)
        }
        if let _loginMessage = json["loginMessage"] as? String {
            loginMessage = _loginMessage
        }
        if let _isPinRequired = json["isPinRequired"] as? String {
            isPinRequired = getBool(value: _isPinRequired)
        }
        if let _pinMessage = json["pinMessage"] as? String {
            pinMessage = _pinMessage
        }
        if let _isDarkMenu = json["isDarkMenu"] as? String {
            isDarkMenu = getBool(value: _isDarkMenu)
        }
    }
    static func getConvertedDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
   
}
public class MockTestList: YuppModel {
    
    public var title = ""
    public var subTitle = ""
    public var redirectionUrl = ""
    public var imageUrl = ""
    public var popupTitle  = ""
    public var popupMessage  = ""
    public var isInternal = false
    public var mockTestListArray : [Any]?

    internal override init() {
        super.init()
    }
    
    public init(_ json : [String : Any]){
        super.init()
        title = getString(value: json["title"])
        subTitle = getString(value: json["subTitle"])
        redirectionUrl = getString(value: json["redirectionUrl"])
        imageUrl = getString(value: json["imageUrl"])
        popupTitle = getString(value: json["popupTitle"])
        popupMessage = getString(value: json["popupMessage"])
        isInternal = getBool(value: json["isInternal"])
    }
    
    public static func mockTestListArray(json : Any?) -> [MockTestList]{
        var list = [MockTestList]()
        if let _json = json as? [[String : Any]]{
            for obj in _json {
                list.append(MockTestList(obj))
            }
        }
        return list
    }
}
