//
//  Extenstions.swift
//
//  Created by Nirav Sapariya
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

enum BorderSide: Int {
    case all = 0, top, bottom, left, right, customRight, customBottom
}
extension UIView {
    //https://stackoverflow.com/questions/37903124/set-background-gradient-on-button-in-swift
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
    
    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint : CGPoint {
            return points.startPoint
        }
        
        var endPoint : CGPoint {
            return points.endPoint
        }
        
        var points : GradientPoints {
            get {
                switch(self) {
                case .topRightBottomLeft:
                    return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
                case .horizontal:
                    return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
                case .vertical:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
                }
            }
        }
    }
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func border(side: BorderSide = .all, color:UIColor = UIColor.black, borderWidth:CGFloat = 1.0) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = borderWidth
        
        switch side {
        case .all:
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = color.cgColor
        case .top:
            border.frame = CGRect(x: 0, y: 0, width:self.frame.size.width ,height: borderWidth)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:self.frame.size.width ,height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        case .customRight:
            border.frame = CGRect(x: self.frame.size.width - borderWidth - 8, y: 8, width: borderWidth, height: self.frame.size.height - 16)
        case .customBottom:
            border.frame = CGRect(x: 8, y: self.frame.size.height - borderWidth , width:self.frame.size.width - 16 ,height: borderWidth)
        }
        
        if side.rawValue != 0 {
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
        
    }
    
    
    func shadow(Offset: CGSize = CGSize(width: 0, height: 0), redius: CGFloat = 2, opacity:Float = 0.5, color:UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = Offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = redius
        layer.masksToBounds = false
    }
    
    func setRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func setRadius(_ radius: CGFloat? = nil, borderWidth:CGFloat = 1.0, color:UIColor) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = <scale> ? UIScreen.main.scale : 1
    }
    
//    func parentView<T: UIView>(of type: T.Type) -> T? {
//        guard let view = self.superview else {
//            return nil
//        }
//        return (view as? T) ?? view.parentView(of: T.self)
//    }
    
    func viewController(forView view: UIView) -> UIViewController? {
        var responder: UIResponder? = view
        repeat {
            responder = responder?.next
            if let vc = responder as? UIViewController {
                return vc
            }
        } while responder != nil
        return nil
    }
    
    func bringToFront() {
        self.superview?.bringSubview(toFront: self)
    }
    
}

enum AnimationDirection: Int {
    case topToBottom = 0, bottomToTop, rightToLeft, leftToRight
}
public extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner                 = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
extension UIView {
    func swipeAnimation(direction: AnimationDirection, duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        switch direction {
        case .topToBottom:
            leftToRightTransition.subtype =  kCATransitionFromTop
        case .bottomToTop:
            leftToRightTransition.subtype =  kCATransitionFromBottom
        case .rightToLeft:
            leftToRightTransition.subtype =  kCATransitionFromRight
        case .leftToRight:
            leftToRightTransition.subtype =  kCATransitionFromLeft
        }
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
        //print("count:\(self.layer.sublayers!.count)")
    }
    
}

//https://stackoverflow.com/questions/31232689/how-to-set-cornerradius-for-only-bottom-left-bottom-right-and-top-left-corner-te/41217791
extension UIView {
    enum CornerBorderSide {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    @available(iOS 11.0, *)
    func setCornerRadious(withRadious radius: CGFloat = 10.0, cornerBorderSides: [CornerBorderSide]){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var cornerMask: CACornerMask = [.layerMinXMaxYCorner]
        cornerMask.remove(.layerMinXMinYCorner)
        forLoop: for side in cornerBorderSides{
            switch side{
            case .bottomLeft:
                cornerMask.insert(.layerMinXMaxYCorner)
            case .bottomRight:
                cornerMask.insert(.layerMaxXMaxYCorner)
            case .topLeft:
                cornerMask.insert(.layerMinXMinYCorner)
            case .topRight:
                cornerMask.insert(.layerMaxXMinYCorner)
            }
        }
        self.layer.maskedCorners = cornerMask
    }
    //If not iOS 11 then apply below code
//    let rectShape = CAShapeLayer()
//    rectShape.bounds = self.gradientView.frame
//    rectShape.position = self.gradientView.center
//    rectShape.path = UIBezierPath(roundedRect: self.gradientView.bounds, byRoundingCorners: [.bottomRight , .topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
//    self.gradientView.layer.mask = rectShape
    
}

extension UIViewController {
    //MARK:- UIAlertController
    func alert(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            print("You've pressed OK Button")
            completion()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[String], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            let act = UIAlertAction(title: actions[i], style: .default, handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func alert(title: String, message : String, actions:[String], style: [UIAlertActionStyle], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            let act = UIAlertAction(title: actions[i], style: style[i], handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension String {
    
    //This for 
    func isOnlyDigitEntering() -> Bool{
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
        /*
         let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
         guard !s.isEmpty else { return true }
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .none
         return numberFormatter.number(from: s)?.intValue != nil
         */
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
    
    var stringWithoutWhitespaces: String {
        return self.replacingOccurrences(of: " ", with: "")
        //let isValid = string.stringWithoutWhitespaces.isNumber
    }
    
    var isValidEmailId: Bool{
        get{
            let REGEX: String
            REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
    
    var length : Int {
        return self.count
    }
    
    func contains(s: String) -> Bool {
        return self.lowercased().contains(s.lowercased()) ? true : false
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
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
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

extension NSAttributedString {
    
    func height(with width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
    
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}

extension UITextField{
    //This method used to searching methos Or Serching API call
    func writingTimeGetTextFieldString(string: String) -> String {
        let replacementString = string
        let textFieldString = self.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = textFieldString! + replacementString
        }
        else if (textFieldString?.count ?? 0) > 0{ // if it was a delete character
            finalString = String(textFieldString!.dropLast())
            if finalString.count <= 0 { //if all character are deleted..then show all values
                finalString = ""
            }
        }
        return finalString
    }
    
}

extension UITextField{
    
    func leftView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
        //view.backgroundColor = UIColor.clear
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 5, y: 5, width:15, height:15)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.leftView = view;
        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func rightView(frame:CGRect, image:UIImage?) {
        let view = UIView(frame: frame)
        //view.backgroundColor = UIColor.gray
        let imgView = UIImageView()
        imgView.frame = CGRect(x: -10, y: 5, width:15, height:15)//CGRect(x: 0, y: 0, width: 15, height: 15)
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        self.rightView = view;
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func resetTextField() {
        self.resignFirstResponder()
        self.text = nil
    }
    
    func setPlaceHolderColor(color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func setPasswordToggle(normalImage icon1: UIImage, selectedImage icon2: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0,
                                             width: ((self.frame.height) * 0.70),
                                             height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon1, for: .normal)
        btnView.setImage(icon2, for: .selected)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        self.rightViewMode = .whileEditing
        self.rightView = btnView
        btnView.tag = 10101
        btnView.addTarget(self, action: #selector(btnEyeAction(_:)), for: .touchUpInside)
        isSecureTextEntry = true
    }
    
    @objc private func btnEyeAction(_ sender: UIButton) {
        self.isSecureTextEntry = sender.isSelected
        //sender.isSelected = !sender.isSelected
        UIView.transition(
            with: (sender),
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                guard sender === self.rightView?.viewWithTag(10101) as? UIButton else {
                    return
                }
                sender.isSelected = !sender.isSelected
        })
    }
    
}

//https://finnwea.com/blog/adding-placeholders-to-uitextviews-in-swift
/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    public func resetPlaceHolder(){
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
                placeholderLabel.isHidden = self.text.count > 0
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.isHidden = self.text.count > 0
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

//Used for get the reference of ViewController from custome cell
extension UIResponder {
    var viewController: UIViewController? {
        if let vc = self as? UIViewController {
            return vc
        }
        return next?.viewController
    }
}

extension UIFont {
    class func getAllFontName() {
        for family in UIFont.familyNames {
            let familyString = family as NSString
            print("=============\(familyString)==============")
            for name in UIFont.fontNames(forFamilyName: familyString as String) {
                print(name)
            }
        }
    }
    class func printAllFontNames() {
        UIFont.familyNames.sorted().forEach({ print($0); UIFont.fontNames(forFamilyName: $0 as String).forEach({print($0)})})
    }
}

//https://stackoverflow.com/questions/24051633/how-to-remove-an-element-from-an-array-in-swift
extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
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

//TODO:  Encoding Emojis:
extension String {
    //    var encodeEmoji: String{
    //        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
    //        return String(data: data, encoding: .utf8)!
    //    }
    
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    
    //    var encodeEmoji: String {
    //        if let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
    //            return encodedStr as String
    //        }
    //        return self
    //    }
    
}
//Usage: let encodedString = yourString.encodeEmoji

//TODO: Decoding Emojis:
extension String {
    //    var decodeEmoji: String{
    //        let data = self.data(using: .utf8)!
    //        return String(data: data, encoding: .nonLossyASCII)!
    //    }
    
    //    var decode:String {
    //        let uni = self.unicodeScalars // Unicode scalar values of the string
    //        let unicode = uni[uni.startIndex].value // First element as an UInt32
    //
    //        print(String(unicode, radix: 16, uppercase: true))
    //    }
    
    var decodeEmoji: String{
        //let mainStr = self.replacingOccurrences(of: "\n", with: " ")
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return (str as String)
        }
        return self
    }
    
    //    var decodeEmoji: String {
    //        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
    //        if data != nil {
    //            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
    //            if let str = valueUniCode {//valueUniCode != nil {
    //                return str as String
    //            } else {
    //                return self
    //            }
    //        } else {
    //            return self
    //        }
    //    }
    
    //    func replaceWithEmoji(str: String) -> String {
    //        var result = str
    //
    //        let regex = try! NSRegularExpression(pattern: "(U\\+([0-9A-F]+))", options: [.caseInsensitive])
    //        let matches = regex.matches(in: result, options: [], range: NSMakeRange(0, result.characters.count))
    //
    //        for m in matches.reversed() {
    //            let range1 = m.rangeAt(1)
    //            let range2 = m.rangeAt(2)
    //
    //            if let codePoint = Int(result[range2], radix: 16) {
    //                let emoji = String(UnicodeScalar(codePoint))
    //                let startIndex = result.startIndex.advancedBy(range1.location)
    //                let endIndex = startIndex.advancedBy(range1.length)
    //
    //                result.replaceRange(startIndex..<endIndex, with: emoji)
    //            }
    //        }
    //
    //        return result
    //    }
    
}
//Usage: let decodedString = yourString.decodeEmoji

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

extension UIButton {
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                      value: NSUnderlineStyle.styleSingle.rawValue,
                                      range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


extension UIViewController {
    
    func presentAsPopUp(parentVC: UIViewController) {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        parentVC.present(self, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    //https://useyourloaf.com/blog/openurl-deprecated-in-ios10/
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
                UIApplication.shared.open(url, options: options, completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        else{
            print("Can't open given URL")
        }
    }
    
    func callOn(PhoneNumber: String) {
        
        if let url = NSURL(string: "tel://\(PhoneNumber.replacingOccurrences(of: " ", with: ""))") as URL?, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                //let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        else{
            print("Can't performe call")
        }
    }
    
    func sendMailTo(email: String) {
        if let url = NSURL(string: "mailto://\(email)") as URL?, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                //let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        else{
            print("Can't send mail")
        }
    }
    
}


import Photos

extension UIImagePickerController{
    
    enum CheckStatus:String{
       case camera
       case photo
    }
    
    func chooseImage(vc:UIViewController, isCaptureFromCamera:Bool = false, allowsEditing:Bool = false){
        
        if isCaptureFromCamera{
            let openGallery = UIAlertAction(title: "Choose Photo", style: .default) { (actions) in
                self.openGalleryOrPhotoLibrary(vc: vc, sourceType: .photoLibrary,allowsEditing:allowsEditing)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (actions) in
                self.dismiss(animated: true, completion: nil)
            }
            vc.alert(title: "", message: "Select Image", actions: [openGallery,cancel])
        }else{
            let openCamera = UIAlertAction(title: "Take Photo", style: .default) { (actions) in
                self.openGalleryOrPhotoLibrary(vc: vc, sourceType: .camera,allowsEditing:allowsEditing)
            }
            let openGallery = UIAlertAction(title: "Choose Photo", style: .default) { (actions) in
                self.openGalleryOrPhotoLibrary(vc: vc, sourceType: .photoLibrary,allowsEditing:allowsEditing)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (actions) in
                self.dismiss(animated: true, completion: nil)
            }
            vc.alert(title: "", message: "Select Image", actions: [openCamera,openGallery,cancel])
        }
    }
    
    private func openGalleryOrPhotoLibrary(vc: UIViewController,sourceType:UIImagePickerControllerSourceType,allowsEditing:Bool) {
        //            #if targetEnvironment(simulator)
        //            // Simulator
        //             self.sourceType = .photoLibrary
        //            #else
        //            // Device
        //               self.sourceType = .camera
        //            #endif
        self.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.allowsEditing = allowsEditing
        switch sourceType {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.sourceType = .camera
            }else{
                self.alert(title: "Alert", message: "Camera is not available in this device")
            }
            self.checkPhotoLibraryPermission(vc: vc, status: .camera)
        case .photoLibrary:
            self.sourceType = .photoLibrary
            self.checkPhotoLibraryPermission(vc: vc, status: .photo)
        default:
            return
        }
    }
    
    private  func checkPhotoLibraryPermission(vc: UIViewController,status:CheckStatus){
        // Get the current authorization state.
        if status == CheckStatus.photo{
            
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                // Access has been granted.
                //self.openGallary()
                vc.present(self, animated: true, completion: nil)
            case .denied, .restricted :
                // Access has been denied.
                // Restricted access - normally won't happen.
                self.openSettingForGivePermissionPhotos(vc: vc, status: .photo)
            case .notDetermined:
                // ask for permissions
                // Access has not been determined.
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        //self.openGallary()
                        vc.present(self, animated: true, completion: nil)
                    }
                    else {
                        self.openSettingForGivePermissionPhotos(vc: vc, status: .photo)
                    }
                })
            }
        }else if status == CheckStatus.camera{
            //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera
            //https://stackoverflow.com/questions/27646107/how-to-check-if-the-user-gave-permission-to-use-the-camera/27646311
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch authStatus {
            case .authorized:
                vc.present(self, animated: true, completion: nil)
            //                openCamera() // Do your stuff here i.e. callCameraMethod()
            case .denied, .restricted:
                self.openSettingForGivePermissionPhotos(vc: vc, status: .camera)
            //                openSettingForGivePermissionCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        vc.present(self, animated: true, completion: nil)
                        //                        self.openCamera()
                    } else {
                        //access denied
                        self.openSettingForGivePermissionPhotos(vc: vc, status: .camera)
                        //                        openSettingForGivePermissionCamera()
                    }
                })
            }
        }
    }
    
    private func openSettingForGivePermissionPhotos(vc: UIViewController,status:CheckStatus) {
        vc.alert(title: "", message: status == CheckStatus.photo ? "Photo Access Prohibited" : "Camera access required for capturing photos!", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                vc.open(scheme:UIApplicationOpenSettingsURLString)
            }
            else{//Cancel
            }
        })
    }
    
}

extension UIImagePickerController{
    
    func getPickedFileName(info: [String:Any]) -> String? {
        if #available(iOS 11.0, *) {
            if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
                if let fileName = (asset.value(forKey: "filename")) as? String {
                    print("\(fileName)")
                    return fileName
                }
                else{return nil}
            }
            else{return nil}
        } else {
            // Fallback on earlier versions
            if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                if let asset = result.firstObject {
                    print(asset.value(forKey: "filename")!)
                    return asset.value(forKey: "filename") as? String ?? ""
                }
                else{return nil}
            }
            else{return nil}
        }
        
    }
    
    func openGallery(vc: UIViewController) {
        self.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.allowsEditing = false
        self.sourceType = .photoLibrary
        self.checkPhotoLibraryPermission(vc: vc)
    }
    
    private func checkPhotoLibraryPermission(vc: UIViewController){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Access has been granted.
            //self.openGallary()
            vc.present(self, animated: true, completion: nil)
        case .denied, .restricted :
            // Access has been denied.
            // Restricted access - normally won't happen.
            self.openSettingForGivePermissionPhotos(vc: vc)
        case .notDetermined:
            // ask for permissions
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    //self.openGallary()
                    vc.present(self, animated: true, completion: nil)
                }
                else {
                    self.openSettingForGivePermissionPhotos(vc: vc)
                }
            })
        }
    }
    
    private func openSettingForGivePermissionPhotos(vc: UIViewController) {
        vc.alert(title: "", message: "Photo Access Prohibited", actions: ["Cancel","Settings"], completion: { (flag) in
            if flag == 1{ //Setting
                vc.open(scheme:UIApplicationOpenSettingsURLString)
            }
            else{//Cancel
            }
        })
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

extension UIViewController{
    
    static var identifier: String {
        return String(describing: self)
    }

//    static private func storyboardInstance <T:UIViewController>(viewControllerClass : T.Type, storyBoard: StoryBoardName = .none) -> T{
//        let nibName = (storyBoard == .none ? String(describing: self) : storyBoard.rawValue)
//        return UIStoryboard(name: nibName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
//    }
//
//    static func storyboardInstance(storyBoard: StoryBoardName) -> Self{
//        return storyboardInstance(viewControllerClass: self, storyBoard: storyBoard)
//    }
    
    //enum StoryBoardName:String {
    //    case main = "Main"
    //    case slideMenu = "SlideMenu"
    //    case singleViews = "SingleViews"
    //    case profiles = "Profiles"
    //    case popUp = "PopUp"
    //    case wallet = "Wallet"
    //    case messages = "Messages"
    //    case notification = "Notifications"
    //    case searchProvide = "SearchProvider"
    //    case provider = "Provider"
    //    case serviceDetail = "ServiceDetail"
    //    case none = "none"
    //}

    
}

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}

//https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        //contentMode = mode
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                //self.image = images
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                UIImageWriteToSavedPhotosAlbum(image/*imgThumb.image!*/, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    @objc fileprivate func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController?.present(ac, animated: true, completion: nil)
            print("Save Photo")
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController?.present(ac, animated: true, completion: nil)
            print("Error in Save Photo")
        }
    }
    
}

class Downloader {

    //https://stackoverflow.com/questions/28219848/how-to-download-file-in-swift
    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path){
            completion(destinationUrl.path, nil)
        }
        else{
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:{
                data, response, error in
                if error == nil{
                    if let response = response as? HTTPURLResponse{
                        if response.statusCode == 200{
                            if let data = data{
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic){
                                    completion(destinationUrl.path, error)
                                }
                                else{
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else{
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else{
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}

//https://stackoverflow.com/questions/33886846/best-way-to-use-icloud-documents-storage
class CloudDataManager {
    
    static let sharedInstance = CloudDataManager() // Singleton
    
    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL!
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    // Delete All files at URL
    
    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    // Copy local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging
    
    func copyFileToCloud() {
        if isCloudEnabled() {
            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear all files in iCloud Doc Dir
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                let _file = DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file)
                _file.removeFile()
                do {
                    try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    print("Copied to iCloud")
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    // Copy iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    func copyFileToLocal() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL)
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
            while let file = enumerator?.nextObject() as? String {
                
                do {
                    try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))
                    
                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }
    
    
    
}

/*
import CommonCrypto

//https://stackoverflow.com/questions/32163848/how-to-convert-string-to-md5-hash-using-ios-swift
func MD5(string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    
    return digestData
}
/*
 //Test:
 let md5Data = MD5(string:"Hello")
 
 let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
 print("md5Hex: \(md5Hex)")
 
 let md5Base64 = md5Data.base64EncodedString()
 print("md5Base64: \(md5Base64)")
 */

*/

extension CGFloat {
    
    init?(string: String) {
        
        guard let number = NumberFormatter().number(from: string) else {
            return nil
        }
        
        self.init(number.floatValue)
    }
    
}
//let x = CGFloat(xString)


extension UIDatePicker {
//https://stackoverflow.com/questions/10494174/minimum-and-maximum-date-in-uidatepicker
    func setLimit(forCalendarComponent component:Calendar.Component, minimumUnit min: Int, maximumUnit max: Int) {
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        guard let timeZone = TimeZone(identifier: "UTC") else { return }
        calendar.timeZone = timeZone
        
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        
        components.setValue(-min, for: component)
        if let maxDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.maximumDate = maxDate
        }
        
        components.setValue(-max, for: component)
        if let minDate: Date = calendar.date(byAdding: components, to: currentDate) {
            self.minimumDate = minDate
        }
    }
    
}
//self.datePicker.setLimit(forCalendarComponent: .year, minimumUnit: 13, maximumUnit: 100)

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}
import MapKit
extension CLGeocoder{
    static func getCoordinate(_ addressString : String,
                              completionHandler: @escaping(CLLocationCoordinate2D) -> Void ) {
        //completionHandler: @escaping(CLLocationCoordinate2D, Error?) -> Void )
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else{
                        // handle no location found
                        print(error?.localizedDescription ?? "ERROR in get lat long")
                        completionHandler(kCLLocationCoordinate2DInvalid)
                        return
                }
                completionHandler(location.coordinate)
                return
            }
            else{
                print(error?.localizedDescription ?? "ERROR in get lat long")
                completionHandler(kCLLocationCoordinate2DInvalid)
            }
        }
    }
    
    static func openMapFromAddress(_ addressString : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else{
                        // handle no location found
                        print(error?.localizedDescription ?? "ERROR in get lat long")
                        return
                }
                let latitude: CLLocationDegrees = location.coordinate.latitude
                let longitude: CLLocationDegrees = location.coordinate.longitude
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = addressString //customerSide_ProviderDetails?.address
                mapItem.openInMaps(launchOptions: options)
                UIApplication.shared.openURL(NSURL.init(string: "http://maps.apple.com/?ll=\(String(describing: location.coordinate.latitude)),\(String(describing: location.coordinate.longitude))")! as URL)
            }
            else{
                print(error?.localizedDescription ?? "ERROR in get lat long")
            }
        }
    }
    
}

extension URL {
    func removeFile() {
        if FileManager.default.fileExists(atPath: self.path){
            do {
                try FileManager.default.removeItem(at: self)
                print("file deleted at: \(self.path)")
            }
            catch(let error) {
                print("file Can't deleate at: \(self.path)")
                print(error.localizedDescription)
            }
        }
    }
}

