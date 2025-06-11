//
//  StringExtension.swift
//  Molla Kuqe
//
//  Created by ETHANEMAC on 22/10/18.
//  Copyright © 2018 ETHANE TECHNOLOGIES PVT. LTD. All rights reserved.
//

import UIKit

extension String {
    
    //MARK:- Convert html string to string
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return NSAttributedString()
//        }
//    }
//
//    //MARK:-
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
    
    //MARK:- Localization
    func localizedString(value : String) -> String {
        return NSLocalizedString(value, comment: "")
    }
    
    func contains(_ string: String) -> Bool {
        return self.range(of: string) != nil
    }
    
    func substringFromIndex(_ index: Int) -> String {
        if (index < 0 || index > self.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return "\(self[self.index(self.startIndex, offsetBy: index)])"
        
        //return self.substring(from: self.index(self.startIndex, offsetBy: index))
    }
    
    func substringToIndex(_ index: Int) -> String {
        if (index < 0 || index > self.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return "\(self[self.index(self.startIndex, offsetBy: index)])"
        //return self.substring(to: self.index(self.startIndex, offsetBy: index))
    }
    func subStringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if end < 0 || end > self.count {
            //print("end index \(end) out of bounds")
            return ""
        }
        
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))
        return "\(self[range])"
        //return self.substring(with: range)
       
    }
    
    func subStringWithRange(_ start: Int, location: Int) -> String {
        if (start < 0 || start > self.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if location < 0 || start + location > self.count {
            //print("end index \(start + location) out of bounds")
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: start + location))
        return "\(self[range])"
        //return self.substring(with: range)
    }
    
    var trimWhiteSpace: String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        return trimmedString
    }
    
    var length: Int {
        return self.count
    }
    
    var extractNumber: String {
        
        let numbers = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let userNumber = numbers.joined(separator: "") // Using space as separator
        
        return userNumber
    }
    
    //>>>> removes all whitespace from a string, not just trailing whitespace <<<//
    
    var removeWhiteSpaces: String {
        return self.replaceString(" ", withString: "")
    }
    
    //>>>> Replacing String with String <<<//
    func replaceString(_ string:String, withString:String) -> String {
        return self.replacingOccurrences(of: string, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func currentDateFromString(_ format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    
    func dateFromUTC() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func heightWithConstraints(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func toJson() -> AnyObject? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                return json as AnyObject?
            } catch {
                //print("Something went wrong    \(text)")
            }
        }
        
        return nil
    }
    
    func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                //print("Something went wrong    \(text)")
            }
        }
        return nil
    }
    
    func jwtTokenInfo() -> Dictionary<String, AnyObject>? {
        
        let segments = self.components(separatedBy: ".")
        
        var base64String = segments[1] as String
        
        if base64String.count % 4 != 0 {
            let padlen = 4 - base64String.count % 4
            base64String += String(repeating: "=", count: padlen)
        }
        
        if let data = Data(base64Encoded: base64String, options: []) {
            do {
                let tokenInfo = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                return tokenInfo as? Dictionary<String, AnyObject>
            } catch {
                //Debug.log("error to generate jwtTokenInfo >>>>>>  \(error)")
            }
        }
        return nil
    }
    
    var getPathExtension: String {
        return (self as NSString).pathExtension
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return "\(self[self.index(self.startIndex, offsetBy: from)])"
        //return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Attributed String <<<<<<<<<<<<<<<<<<<<<<<<*/

    func getAttributedString(_ string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
        
        let range = (self as NSString).range(of: string_to_Attribute)
        
        let attributedString = NSMutableAttributedString(string:self)
        
        // multiple attributes declared at once
        let multipleAttributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font,
            ]
        
        attributedString.addAttributes(multipleAttributes, range: range)
        
        return attributedString.mutableCopy() as! NSAttributedString
    }
    
    func getUnderLinedAttributedString(_ string_to_Attribute:String, color : UIColor, font:UIFont) -> NSAttributedString {
        
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor : color
            ] as [NSAttributedString.Key : Any]
        
        let underlineAttributedString = NSAttributedString(string: string_to_Attribute, attributes: underlineAttribute)
        
        return underlineAttributedString
    }
    

    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        return "\(self[start..<end])"
        //return substring(with: (start ..< end))
    }
    
    func countInstances(of stringToFind: String) -> Int {
        var stringToSearch = self
        var count = 0
        while let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive) {
            stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        return count
    }
    func getPriceFromArabicPriceString(arabicPrice: String) -> String {
   
    let NumberStr: String = arabicPrice    //"٢٠١٨-٠٦-٠٤"
    let Formatter = NumberFormatter()
    Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
    if let finalPrice = Formatter.number(from: NumberStr) {
         print(finalPrice.stringValue)
        return finalPrice.stringValue
       
        }
       return NumberStr
    }
    func getPriceFromArabicPriceString() -> String {
    
     let NumberStr: String = self    //"٢٠١٨-٠٦-٠٤"
     let Formatter = NumberFormatter()
     Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
     if let finalPrice = Formatter.number(from: NumberStr) {
          print(finalPrice.stringValue)
         return finalPrice.stringValue
        
         }
        return NumberStr
     }
}

//MARK:- Validation regular expressions
extension String {
    
    
    func containsCaseInsec(_ string: String) -> Bool {
        return self.lowercased().range(of: string.lowercased()) != nil
    }
    //((\\+)|(00))
    var isPersian: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@",
                                    "([-.]*\\s*[-.]*\\p{Arabic}*[-.]*\\s*)*[-.]*")
        return predicate.evaluate(with: self)
    }
   func isValidMobileNumber() -> Bool {
        let mobileNoRegEx = "^[0-9]{8,16}$"
//        let mobileNoRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
//        let mobileNoRegEx = "^[0-9+]{0,1}+[0-9]{5,16}$"
    
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
    let texts = mobileNoTest.evaluate(with: self)
    print("Number",texts)
        return texts
    }
     func isArabicValidMobileNumber() -> Bool {
            let mobileNoRegEx = "^[٠-٩]{8,16}$"
            let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        let texts = mobileNoTest.evaluate(with: self)
        print("Number",texts)
            return texts
        }
    /*
    func isValidMobileNumber() -> Bool {
//        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let PHONE_REGEX = "^(\\+)(?:[0-9] ?){6,14}[0-9]$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }*/
    
    func isContainsAllZeros() -> Bool {
        let mobileNoRegEx = "^0*$";
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    func isArabicContainsAllZeros() -> Bool {
        let mobileNoRegEx = "^٠*$";
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    func isValidUserName() -> Bool {
        let nameRegEx = "^[a-zA-Z0-9\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
//      let passwordRegEx =  "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
//        let regex = try? NSRegularExpression(pattern: "^(\\w[.|-]?)*\\w+[@](\\w[.]?)*\\w+[.][a-zء-ي]{2,4}$", options: .caseInsensitive)
//        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    func isArabicValidEmail() -> Bool {   

//        let emailRegex = "[ء-ي٠-٩._%+-]+@[ء-ي٠-٩.-]+\\.[ء-ي]{2,}"
//        let emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
//        let emailRegex = "^([a-z0-9]+)@([a-z0-9]+)\\.([a-zA-Z0-9]+)$" // working in english
//        let emailRegex = "^((([!#$%&'*+\\-/=?^_`{|}~\\w])|([!#$%&'*+\\-/=?^_`{|}~\\w][!#$%&'*+\\-/=?^_`{|}~\\.\\w]{0,}[!#$%&'*+\\-/=?^_`{|}~\\w]))[@]\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)$"
//
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
//        let result = emailTest.evaluate(with: self)
//        print(result)
        let charSet = CharacterSet.init(charactersIn: "@.)(")
               var result : Bool = false
               if (self.rangeOfCharacter(from: charSet) != nil)
               {
                  result = true
               }
        return result

    }
    var isArabicEmail: Bool{
//        ^(\\w[.|-]?)*\\w+[@](\\w[.]?)*\\w+[.][ء-ي]{2,4}$
//        let emailRegex = "(?s).*\\\\p{Arabic}.*"
//        let emailRegex = "^(\\w[.|-]?)*\\w+[@](\\w[.]?)*\\w+[.][ء-ي]{2,4}$"
//         let emailRegex = "[ء-ي٠-٩._%+-]+@[ء-ي٠-٩.-]+\\.[ء-ي]{2,64}"
//         let emailRegex = "^(\\p{L}\\p{N}[.|-]?)*\\p{L}\\p{N}+[@](\\p{L}\\p{N}[.]?)*\\p{L}\\p{N}+[.][ء-ي]{2,4}$"
        let emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"
        let regex = try? NSRegularExpression(pattern: emailRegex, options: .caseInsensitive)
               return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    func isContainsAtleastOneSpecialCharacters() -> Bool{
//        let passwordRegEx = "^(?=.*?[$@$!%*#?&^)(]).{8,}$"
//        let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
        let passwordRegEx = "^(?=.*[$@$#!%*?&]).{9,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    func isContainLowerCase()->Bool{
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    func isContainUpperCase()->Bool{
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
           return texttest.evaluate(with: self)
       }
    func containsAlphaNumericOnly() -> Bool {
        let nameRegEx = "^[a-zA-Z0-9\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    func containsNumberOnly() -> Bool {
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        let test = nameTest.evaluate(with: self)
        print(test)
        return test
    }
    func isArabicContainsNumberOnly() -> Bool {
           let nameRegEx = "^[٠-٩]+$"
           let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
           let test = nameTest.evaluate(with: self)
           print(test)
           return test
       }
    func containsAlphabetsOnly() -> Bool {
        let nameRegEx = "^[a-zA-Z]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    func isArabicContainsAlphabetsOnly() -> Bool {
        let nameRegEx = "^[ء-ي]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    func isValidName() -> Bool {
        
        let nameRegEx = "^[a-zA-Z\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func checkTextSufficientComplexityUpperCase() -> Bool{

//        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalLetterRegEx  = "(?=.*[A-Z]).{6,}$"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        print("\(capitalresult)")
        
        return capitalresult
    }
    func isArabicCheckTextSufficientComplexityUpperCaseNumber() -> Bool{
//            let capitalLetterRegEx  = "(?=.*[ء-ي٠-٩]).{8,}$"
//        ^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$
        let charSpecialSet = CharacterSet.init(charactersIn: "@#$%^&*_!-)(")
        let numSet = CharacterSet.init(charactersIn: "1234567890٠-٩)(")
        let charSet = CharacterSet.init(charactersIn: "abcdefghizklmnopqrstuvwxyzء-ي)(")
        let charCapitalSet = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZء-ي)(")
       // let uppercharCapitalSet = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var result : Bool = false
        if (self.rangeOfCharacter(from: charSpecialSet) != nil) && (self.rangeOfCharacter(from: numSet) != nil) && (self.rangeOfCharacter(from: charSet) != nil) && (self.rangeOfCharacter(from: charCapitalSet) != nil)
        {
           result = true
        }
        
//        let passwordRegex = "^(?=.*[\\p{L}&&[\\p{script=Arabic}A-Za-z]])(?=.*[\\p{N}&&[\\p{script=Arabic}0-9]])[\\p{L}\\p{N}&&[\\p{script=Arabic}a-zA-Z0-9]]{8,}$"// working except special char
        
//        let passwordRegex = "^(?=\\P{Ll}*\\p{Ll})(?=\\P{Lu}*\\p{Lu})(?=\\P{N}*\\p{N})(?=[\\p{L}\\p{N}]*[^\\p{L}\\p{N}])[\\s\\S]{8,}"
//        let passwordRegex = "^(?=.*[\\p{L}&&[\\p{script=Arabic}A-Za-z]])(?=.*[\\p{N}&&[\\p{script=Arabic}0-9]])(?=.*[\\p{N}&&[\\p{script=Arabic}#?!@$%^&*-]])[\\p{L}\\p{N}&&[\\p{script=Arabic}a-zA-Z0-9#?!@$%^&*-]]{8,}$"

//            let texttest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
//            let result = texttest.evaluate(with: self)
//            print("\(result)")
            
            return result
        }
    func checkTextSufficientComplexityNumber() -> Bool{
//        let numberRegEx  = ".*[0-9]+.*"
       let numberRegEx  = "(?=.*[0-9]).{8,}$"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        print("\(numberresult)")
        return numberresult
    }
    
    func checkTextRepetedTextNumber(string : String) -> Int
    {
        
        // To keep track of processed symbols
        var uniqueCharacters = ""
        
        // To hold record in memory
        var maxCount = 0
        var maxOccurringCharacter = ""
        
        for char in string.characters {
            
            let alphabet = String(char)
            
            // If this is already counted, skip it
            if (uniqueCharacters.contains(alphabet))
            {
                continue
            }
            
            // Otherwise, add it to processed symbols
            uniqueCharacters += alphabet
            
            let count =  consectiveCountOf(letter: alphabet, inString: string)
            
            if count > maxCount
            {
                maxCount = count
                maxOccurringCharacter = alphabet
            }
        }
        
        return maxCount
    }
    func consectiveCountOf(letter alphabet : String, inString source : String) -> Int
    {
        var occurance = 0
        for character in source.characters
        {
            let value = String(character)
            
            if value == alphabet
            {
                occurance += 1
            }
            else if occurance > 0   // For there would at least be one occurance
            {
                break
            }
        }
        
        if occurance == 1 {
            return 0    // For Single Occurance, Repeat Count is Zero
        }
        return occurance
    }
    func isArabicCheckTextSufficientComplexityNumber() -> Bool{
    //        let numberRegEx  = ".*[0-9]+.*"
           let numberRegEx  = "(?=.*[٠-٩]).{8,}$"
            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let numberresult = texttest1.evaluate(with: self)
            print("\(numberresult)")
            return numberresult
        }
    func isValidPasswordATleastUpperLowerandSpecial() -> Bool {
        //let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~])[A-Za-z\\d !\"\\\\#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]{8,}"
        //safe to escape all regex chars
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func checkTextSufficientComplexity(text : String) -> Bool{


        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        print("\(capitalresult)")


        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")


        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)

        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")

        return capitalresult || numberresult || specialresult

    }
    //MARK:- >>>> removes all whitespace from a string, not just trailing whitespace <<<//
    func removeWhitespace() -> String {
        return self.replaceString(" ", withString: "")
    }
    
    
}

