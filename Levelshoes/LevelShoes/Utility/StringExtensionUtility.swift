//
//  StringExtension.swift
//  LevelShoes
//
//  Created by Maa on 29/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

func convertToDictionaryForString(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

extension String {
    func strikeThroughLabel() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.styleSingle.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

extension String {
    
    func replace(string:String, replacement:String) -> String {
         return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
     }

     func removeWhitespaceFromAnyString() -> String {
        return self.trimmingCharacters(in: .whitespaces)
       // return self
     }
//    //2 ENCODE EMOJI ON CHAT
//    var encodeEmoji: String{
//        
//        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
//            return encodeStr as String
//        }
//        return self
//    }
    
    //3 DECODE EMOJI ON CHAT
//    var decodeEmoji: String{
//
//        let data = self.data(using: String.Encoding.utf8);
//        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
//        if let str = decodedStr{
//            return str as String
//        }
//        return self
//    }
    
    //4 REPLACE STRING WITH ANOTHER STRING
    func replace_string_with(stringToReplace: String, withString: String) -> String {
        
        return self.replacingOccurrences(of: stringToReplace, with: withString, options: String.CompareOptions.caseInsensitive, range: nil)
        //return self.replacingOccurrences(of: stringToReplace, with: withString)
    }
    
    //5 COMPARE TWO STRINGS CASE INSENSITIVE
    func string_is_equal_to_string(compare_with:String) -> Bool {
        
        if(self.caseInsensitiveCompare(compare_with) == ComparisonResult.orderedSame) {
            
            return true
        }
        else{
            
            return false
        }
    }
    
    //6 STRING CONTAINS SUBSTRING
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    //7 GET INDEX OF PARTICULAR SUBSTRING FROM A STRING
    func indexOf(substring: String) -> Int{
        
        let range = self.range(of: substring)
        if let range = range {
            return distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return -1
        }
    }
    
    //8 CAPITALIZE WITH STRING
    func sentense_capitalizing() -> String {
        
        return prefix(1).uppercased() + dropFirst()
    }
    
    func word_capitalizing() -> String {
        
        return self.capitalized(with: NSLocale.current)
    }
    
    func upercase_capitalizing() -> String {
        
        return self.uppercased()
    }
    
    //9 BASE 64 ENCODING STRING AND DECODING STRING
    func to_base_64_encode() -> String {
        
        return Data(self.utf8).base64EncodedString()
    }
    func from_base_64_encode() -> String {
        
        guard let data = Data(base64Encoded: self) else {
            
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }
    
    //10 STRING CONTAINS EMOJI AND OTHER SPECIAL LETTERS
    public var containEmoji: Bool {
        
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    //11 STRING IS ALPHABETIC OR NOT
    public var isAlphabetic: Bool {
        
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    //12 STRING IS ALPHANUMERIC OR NOT
    public var isAlphaNumeric: Bool {
        
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    //13 STRING IS VALID EMAIL OR NOT
    public var isValidEmail: Bool {
        
        return range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    //14 STRING IS NUMERIC OR NOT
    public var isNumeric: Bool {
        
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    //15 STRING IS DIGITS OR NOT
    public var isDigits: Bool {
        
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    //16 BOOL VALUE FROM STRING
    public var bool_from_string: Bool {
        
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if(self.caseInsensitiveCompare("true") == ComparisonResult.orderedSame) || selfLowercased == "1" {
            
            return true
        }
        else if(self.caseInsensitiveCompare("false") == ComparisonResult.orderedSame) || selfLowercased == "0" {
            
            return false
        }
        return false
    }
    
    //17 REMOVE NON PRINTING CHARATERS FROM STRING
    public var trimmed: String {
        
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var trimmedNewLinesOnly: String {
        
        return self.components(separatedBy: .newlines).joined()
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    //18 URL ENCODING AND DECODING FROM STRING
    public var urlEncoded: String {
        
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    public var urlDecoded: String {
        
        return removingPercentEncoding ?? self
    }
    
    //19 REMOVE NON PRINTING CHARATERS FROM STRING
    public func float_from_string(locale: Locale = .current) -> Float? {
        
        if(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0){
            
            return 0.0
        }
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    
    public func double_from_string(locale: Locale = .current) -> Double? {
        
        if(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0){
            
            return 0.000
        }
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
    //20 STRING WORDS TO ARRAY
    public func words_array_contained_from_string() -> [String] {
        
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    //21 WORDS COUNT IN A STRING
    public func words_count_in_string() -> Int {
        
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    
    //22 RANDOM CHARACTERS LENGTH STRING
    public var charactersArray: [Character] {
        
        return Array(self)
    }
    
    public static func generateRandomString(ofLength length: Int) -> String {
        
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            
            let randomIndex = arc4random_uniform(UInt32(base.count))
            let randomCharacter = base.charactersArray[Int(randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
    
    //22 STRING ATTRIBUTES
    public func string_font_bold_with_size(size:Float) ->NSAttributedString {
        
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: CGFloat(size))])
    }
    
    public var underline: NSAttributedString {
        
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
    }
    
    public var strikethrough: NSAttributedString {
        
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)])
    }
}

extension String {
 
}
