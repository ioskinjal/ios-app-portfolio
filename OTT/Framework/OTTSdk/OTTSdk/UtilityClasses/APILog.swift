//
//  APILog.swift
//  YuppTV
//
//  Created by Muzaffar on 08/05/17.
//  Copyright © 2017 YuppTV. All rights reserved.
//

import UIKit

public class APILog: NSObject {
    public static let logNotifcation = NSNotification.Name(rawValue: "logNotifcation")
    public static var attributedTextLog = NSMutableAttributedString()
    public static var lastApiCallLog = NSMutableAttributedString()

    internal enum LogType {
        case request
        case response
        case header
        case error
        case undefined
    } 
    
    public static func defaultHeaders() -> NSString{
        
        return "box-id : \(PreferenceManager.boxId)" + "\n" + "session-id : \(PreferenceManager.sessionId)" + "\n" + "tenant-code : \(OTTSdk.preferenceManager.tenantCode)"  as NSString
    }
    
    public static func printMessage(message : Any){
        print(message)
    }
    
    internal static func printMessage(message :  String, logType : LogType){
        if PreferenceManager.logType != .none{
            let attrib = attributedText(message: message , logType: logType)
            APILog.attributedTextLog.append(attrib)
            lastApiCallLog.append(attrib)
            let info = ["message" : message, "logType" : logType, "attributedText" : lastApiCallLog, "completeText" : APILog.attributedTextLog] as [String : Any]
            NotificationCenter.default.post(name: logNotifcation, object: info)
            
            if (logType == LogType.error) || (logType == .undefined){
                print(message)
            }
            else{
                switch PreferenceManager.logType {
                case .complete:
                    print(message)
                case .requestsOnly:
                    if (logType == .request){
                        print(message)
                    }
                case .requestAndHeaders:
                    if (logType == .request) || (logType == .header){
                        print(message)
                    }
                default: break
                }
            }
        }
    }
    
    internal static func attributedText(message : String, logType : LogType) -> NSMutableAttributedString{
        var color = UIColor.black
        var font = UIFont.systemFont(ofSize: 15)
        switch logType {
        case .header:
            color = UIColor.lightGray
        case .request:
            color = UIColor.darkGray
            font = UIFont.systemFont(ofSize: 17)
            lastApiCallLog = NSMutableAttributedString()
        case .response:
            color = UIColor.blue
            font = UIFont.systemFont(ofSize: 14)
        case .error:
            color = UIColor.red
        default:
            color = UIColor.brown
        }
        
        let yourAttributes = [NSAttributedString.Key.foregroundColor.rawValue: color, NSAttributedString.Key.font: font] as? [NSAttributedString.Key : Any]
        let attrib =  NSMutableAttributedString(string: message, attributes: yourAttributes)
        
        return attrib
    }
    
    
    
}
