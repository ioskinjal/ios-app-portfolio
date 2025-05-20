//
//  RideUtilities.swift
//  BooknRide
//
//  Created by KASP on 16/12/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class RideUtilities: NSObject {
    
    
    class public func getDateStringFromString(date:String) -> String {
        
        
        //        27 Oct , 2017 10:15
        let dateString = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        if let dateFromString = formatter.date(from: dateString) {
            formatter.dateFormat = "dd MMM, yyyy HH:mm"
            let stringFromDate = formatter.string(from: dateFromString)
            return stringFromDate
        }
        return dateString
    }
    
    class public func getStringFromDate(format:String,date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return  dateFormatter.string(from: date)
        
    }
    
    class public func getDateFromString(format:String,date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return  dateFormatter.date(from:date)!
        
    }
    
    class public func makeCall(number:String){
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func convertToDictionary(jsonString: String) -> [String: Any]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
   class public  func localToUTC(date:String, fromFormat: String, toFormat: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = toFormat
        
    return dt! // dateFormatter.string(from: dt!)
    }
    
   class public  func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        //dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = toFormat
    
    return  dt! //dateFormatter.string(from: dt!)
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Montserrat-SemiBold", size: 16)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

func describe<T>(_ value: Optional<T>) -> String {
    switch value {
    case .some(let wrapped):
        return String(describing: wrapped)
    case .none:
        return "(null)"
    }
}

extension Optional {
    
    var stringValue: String {
        switch self {
        case .some(let wrapped):
            return String(describing: wrapped)
        case .none:
            return "(null)"
        }
    }
}

extension String {
    
    func digitsOnly() -> String{
        let newString = components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
        return newString
    }
    
} 


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
