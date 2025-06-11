//
//  Extension.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension String {
    //This is used for shouldChangeCharactersIn() method to prevent other alphabetss entery
    var isStringContainsOnlyDigit: Bool {
        get{
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: self)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    func exclude(find:String) -> String {
        return self.replacingOccurrences(of: find, with: "", options: .caseInsensitive, range: nil)
    }
    
    func replaceAll(find:String, with:String) -> String {
        return self.replacingOccurrences(of: find, with: with, options: .caseInsensitive, range: nil)
    }
    
    mutating func removeSpecificCharFromString(find:String) {
        self = self.replacingOccurrences(of: find, with: "", options: .caseInsensitive, range: nil)
    }
    
    mutating func replaceSpecificCharFromString(find:String, with:String) {
        self = self.replacingOccurrences(of: find, with: with, options: .caseInsensitive, range: nil)
    }
    
    mutating func addSpaceTrainlingAndLeading(char: Character = " ", spaceNum: Int = 1) {
        for _ in 1...spaceNum {
            self.insert(char, at: self.endIndex)
            self.insert(char, at: self.startIndex)
        }
    }
    
    func digitsOnly() -> String{
        let newString = components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
        return newString
    }
    
    //Prevent to accept only spaces in text fields
    var isBlank: Bool {
        get{
            return self.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.stringWithoutWhitespaces.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    //^[2-9]{2}[0-9]{8}$
    //    var isphoneNumber: Bool{
    //        get{
    //            let REGEX: String
    //            REGEX = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$"
    //            //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    //            //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    //            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
    //        }
    
    var stringWithoutWhitespaces: String {
        return self.replacingOccurrences(of: " ", with: "")
        //let isValid = string.stringWithoutWhitespaces.isNumber
    }
    
    var isValidEmailId: Bool{
        get{
            //            let REGEX: String
            //            REGEX = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$"
            //            //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            //            //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            //            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
            let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
            let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
            let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
            let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
            return __emailPredicate.evaluate(with: self)
        }
    }
    
    
    var length : Int {
        return self.count
    }
    
    func contains(string: String) -> Bool {
        return self.lowercased().contains(string.lowercased()) ? true : false
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func fileNameOnly() -> String {
        let fileNameWithoutExtension = URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
        if !fileNameWithoutExtension.isEmpty{
            return fileNameWithoutExtension
        } else {
            return ""
        }
        //        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
        //            return fileNameWithoutExtension
        //        } else {
        //            return ""
        //        }
    }
    
    func fileExtensionOnly() -> String {
        let fileExtension = URL(fileURLWithPath: self).pathExtension
        if !fileExtension.isEmpty{
            return fileExtension
        } else {
            return ""
        }
        //        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
        //            return fileExtension
        //        } else {
        //            return ""
        //        }
    }
    
    func fileNameWithExtension() -> String {
        let fileNameWithoutExtension = URL(fileURLWithPath: self).lastPathComponent
        if !fileNameWithoutExtension.isEmpty {
            return fileNameWithoutExtension
        } else {
            return ""
        }
        //        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).lastPathComponent {
        //            return fileNameWithoutExtension
        //        } else {
        //            return ""
        //        }
    }
    /*
     //Usage
     let file = "image.png"
     let fileNameWithoutExtension = file.fileName()
     let fileExtension = file.fileExtension()
     */
    
    
    func caseInsensitiveCompare(string: String) -> Bool {
        if (self.caseInsensitiveCompare(string) == .orderedSame) {
            return true
        }
        else{
            return false
        }
    }
    
}

extension String {
    
    func height(with width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
    ////https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension String {
    func getStringInMutipleColor(strings : [String], colors : [UIColor]) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        if strings.count == colors.count {
            for index in 0 ..< strings.count {
                let range = (self as NSString).range(of: strings[index])
                attributeString.addAttribute(.foregroundColor, value: colors[index], range: range)
            }
        }
        return attributeString
    }
}


//MARK:- NSAttributedString
extension NSAttributedString {
    
    func height(with width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
    
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}


//TODO:  Encoding Emojis:
extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}
//Usage: let encodedString = yourString.encodeEmoji

//TODO: Decoding Emojis:
extension String {
    var decodeEmoji: String{
        //let mainStr = self.replacingOccurrences(of: "\n", with: " ")
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return (str as String)
        }
        return self
    }
}
//Usage: let decodedString = yourString.decodeEmoji


extension String{
    mutating func safelyLimitedTo(length n: Int)/*->String*/ {
        if (self.count <= n) {
            /*return self*/
        }else{
            /*return*/ self = String( Array(self).prefix(upTo: n) )
        }
    }
}
//Use:
/*txtFirstNm.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
 @objc func textFieldDidChange(_ textField: UITextField) {
 textField.text?.safelyLimitedTo(length: 20)
 }
 */


extension String{
    func convertDate(dateFormate : String) -> Date? {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = dateFormate
        return dateFormator.date(from: self)
    }
}

extension Date{
    func convertDate(dateFormate : String) -> String? {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = dateFormate
        return dateFormator.string(from: self)
    }
}

extension String {
    func convertJSONStringToDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8/*, allowLossyConversion: false*/) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: [/*.mutableContainers*/]) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension Dictionary{
    func dictionryToJsonString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self)
        return String(data: jsonData, encoding: .utf8) ?? "{}"//String.Encoding.utf8.rawValue)
    }
}

extension String{
    func getUnderLineText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: (self.count)))
        return attributedString
    }
}



//https://stackoverflow.com/questions/45562662/how-can-i-use-string-slicing-subscripts-in-swift-4

extension String {
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

//let text = "Hello world"
//text[...3] // "Hell"
//text[6..<text.count] // world
//text[NSRange(location: 6, length: 3)] // wor


extension String{
    func allowCharacterSets(with str:String) -> Bool {
        guard self != "" else { return true }
        let hexSet = CharacterSet(charactersIn: str)
        let newSet = CharacterSet(charactersIn: self)
        return hexSet.isSuperset(of: newSet)
    }
    
    func repeatCharacterCount(char: Character = " ") -> Int  {
        return self.filter({$0 == char}).count
    }
    
    var isValidPhoneNo: Bool{
        get{
            let REGEX: String
            REGEX = "(^((\\+)|(00))[0-9]+|[0-9]+)"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
    
    var isValidNumber: Bool{
        get{
            let REGEX: String
            REGEX = "[0-9]+"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
    
    var isValidFloatNumber: Bool{
        get{
            let REGEX: String
            REGEX = "[0-9]+|.[0-9]+|([0-9]+).([0-9]+)"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
    
    var isValidPrice: Bool{
        get{
            let REGEX: String
            REGEX = "[0-9]+|.[0-9]+|([0-9]+).([0-9]+)"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
    
    var isValidURL: Bool {
        if self.isBlank { return false }
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
}


//
extension String{
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    // 幅を計算する
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension String {
    func modify(sth: (String)->String)->String{
        return sth(self)
    }


func firstLetter(a: String) -> String {
    return String(a[a.startIndex])
}
}

extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}
 

extension StringProtocol where Self: RangeReplaceableCollection {
    var removingAllWhitespacesAndNewlines: Self {
        return filter { !$0.isNewline && !$0.isWhitespace }
    }
    mutating func removeAllWhitespacesAndNewlines() {
        removeAll { $0.isNewline || $0.isWhitespace }
    }
}
/*
//Usage:
let textInput = "Line 1 \n Line 2 \n\r"
let result = textInput.removingAllWhitespacesAndNewlines   //"Line1Line2"

var test = "Line 1 \n Line 2 \n\r"
test.removeAllWhitespacesAndNewlines()
print(test)  // "Line1Line2"
*/
