//
//  Extension+Other.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

//Used for get the reference of ViewController from custome cell
extension UIResponder {
    var viewController: UIViewController? {
        if let vc = self as? UIViewController {
            return vc
        }
        return next?.viewController
    }
}

//https://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift
extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

//https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
extension UIDevice {
    static func isiPhone5() -> Bool {
        var flag:Bool = false
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                flag = true
            case 1334:
                break
            //print("iPhone 6/6S/7/8")
            case 2208:
                break
            //print("iPhone 6+/6S+/7+/8+")
            case 2436:
                break
            //print("iPhone X")
            default:
                print("unknown")
            }
        }
        return flag
    }
}


//extension Bool{
//    mutating func toggal() {
//        self = !self
//    }
//}


extension CGFloat {
    init?(string: String) {
        guard let number = NumberFormatter().number(from: string) else {
            return nil
        }
        self.init(number.floatValue)
    }
}
//let x = CGFloat(xString)

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
/*
 let roundedValue1 = 0.6844.roundToDecimal(3)
 let roundedValue2 = 0.6849.roundToDecimal(3)
 print(roundedValue1) // returns 0.684
 print(roundedValue2) // returns 0.685
 */

extension UIApplication {
    //https://stackoverflow.com/questions/17678881/how-to-change-status-bar-text-color-in-ios-7
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}


//https://stackoverflow.com/questions/26519248/how-to-set-the-full-width-of-separator-in-uitableview
extension UITableViewCell {
    func setFullWidthSeparator() {
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
}


//MARK:- Very Important Extention for developer purpose
extension UITableViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UIWindow {
    func setTheamColor(color: UIColor) {
        self.tintColor = color
    }
}

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(item(), separator:separator, terminator: terminator)
    #endif
}


//https://stackoverflow.com/questions/24132399/how-does-one-make-random-number-between-range-for-arc4random-uniform
extension Collection {
    private func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    func randomItem() -> Self.Iterator.Element {
        let count = distance(from: startIndex, to: endIndex)
        let roll = randomNumber(inRange: 0...count-1)
        return self[index(startIndex, offsetBy: roll)]
    }
    
}

extension HTTPCookieStorage{
    static func clearCookieof(name:String = "linkedin"){
        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                print("cookie.domain:\(cookie.domain)")
                if cookie.domain.contains(name) {
                    cookieStorage.deleteCookie(cookie)
                }
            }
        }
    }
}


extension Data{
    //https://stackoverflow.com/questions/37580015/how-to-access-file-included-in-app-bundle-in-swift
    func createFileInDocumentDirectory(name: String) {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent(name/*"YourFile.extension"*/)
            do {
                let fileExists = try fileURL.checkResourceIsReachable()
                if fileExists {
                    fileURL.removeFile()
                    writeFile(fileURL: fileURL)
                    print("File exists")
                } else {
                    print("File does not exist, create it")
                    writeFile(fileURL: fileURL)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func writeFile(fileURL: URL) {
        do {
            try self.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension DispatchQueue{
    static func updateUI_InMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
    
    static func updateUI_WithDelay(_ closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: closure)
    }
}

//https://stackoverflow.com/questions/42432731/increase-the-size-of-the-indicator-in-uipageviewcontrollers-uipagecontrol
extension UIPageControl{
    func increaseSize(by val: CGFloat = 2) {
        self.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: val, y: val)
        }
    }
}


//https://medium.com/@johnsundell/building-a-declarative-animation-framework-in-swift-part-1-26e83a2b0819
public struct Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
}
public extension Animation {
    static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.alpha = 1 })
    }
    static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.bounds.size = size })
    }
}

public extension UIView {
    func animate(inParallel animations: [Animation]) {
        for animation in animations {
            UIView.animate(withDuration: animation.duration) {
                animation.closure(self)
            }
        }
    }
}
/*
//EX:
animationView.animate(inParallel: [
    .move(to: CGPoint(x: 300, y: 300), duration: 5),
    .resize(to: CGSize(width: 200, height: 200), duration: 5)
    ])
*/

public extension UIView {
    func animate(_ animations: [Animation]) {
        // Exit condition: once all animations have been performed, we can return
        guard !animations.isEmpty else {
            return
        }
        // Remove the first animation from the queue
        var animations = animations
        let animation = animations.removeFirst()
        // Perform the animation by calling its closure
        UIView.animate(withDuration: animation.duration, animations: {
            animation.closure(self)
        }, completion: { _ in
            // Recursively call the method, to perform each animation in sequence
            self.animate(animations)
        })
    }
}
/*
//Ex:
animationView.animate([
    .fadeIn(duration: 3),
    .resize(to: CGSize(width: 200, height: 200), duration: 3)
    ])
*/


extension UITableViewCell
{
    func removeSeparatorLeftPadding() -> Void
    {
        if self.responds(to: #selector(setter: separatorInset)) // Safety check
        {
            self.separatorInset = UIEdgeInsets.zero
        }
        if self.responds(to: #selector(setter: layoutMargins)) // Safety check
        {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
}


//https://stackoverflow.com/questions/10348869/change-color-of-uiswitch-in-off-state
extension UISwitch {
    
    func set(offTint color: UIColor ) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
    
}


extension UISearchBar{
    static func setPlaceHolderFont(font:UIFont){
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = font
        //UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.red
    }
    static func setSerachTextFont(font:UIFont){
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = font
    }
}

extension UISearchBar{
    func addRightView(icon: UIImage, selector: Selector) {
        if let textField:UITextField = self.subviews[0].subviews.last as? UITextField,let vc = textField.viewController{
            let button:UIButton = {
                let button = UIButton()
                button.setImage(icon, for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: (textField.frame.height) * 0.70, height: (textField.frame.height) * 0.70)
                button.backgroundColor = .clear
                button.tintColor = UIColor.gray
                button.addTarget(vc, action: selector, for: .touchUpInside)
                return button
            }()
            textField.rightView = button
            textField.rightViewMode = .always
        }
    }
}



//https://stackoverflow.com/questions/36043006/swift-tap-on-a-part-of-text-of-uilabel
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}



//Usage
/*
@IBAction func tapLabel(gesture: UITapGestureRecognizer) {
    let termsRange = (text as NSString).range(of: "Terms & Conditions")
    // comment for now
    //let privacyRange = (text as NSString).range(of: "Privacy Policy")
    
    if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
        print("Tapped terms")
    } else if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
        print("Tapped privacy")
    } else {
        print("Tapped none")
    }
}
*/


//https://stackoverflow.com/questions/37935548/ios-get-displayed-image-size-in-pixels/37935942
extension UIImage{
    func getSizeInPixel() -> (width: CGFloat, height: CGFloat){
        let widthInPixels = self.size.width * self.scale
        let heightInPixels = self.size.height * self.scale
        return (widthInPixels, heightInPixels)
    }
}

extension UIImageView{
    func getSizeInPixel() -> (width: CGFloat, height: CGFloat){
        let widthInPixels = self.frame.width * UIScreen.main.scale
        let heightInPixels = self.frame.height * UIScreen.main.scale
        return (widthInPixels, heightInPixels)
    }
}




extension Dictionary where Key == String, Value == Any{
    subscript(Key: String, default:String) -> String {
        get {
            return self.parseValue(value: self[Key], default: `default`)
        }
    }
    private func parseValue(value : Any?, default:String) -> String {
        if let val = value as? Int {
            return "\(val)"
        } else if let val = value as? Double {
            return "\(val)"
        } else if let val = value as? String {
            return val
        }
        return `default`
    }
}



extension dictionary{
    func printDic() {
        for val in self.sorted(by: { $0.0 < $1.0 }){
            print("\(val.key):\(val.value)")
        }
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
