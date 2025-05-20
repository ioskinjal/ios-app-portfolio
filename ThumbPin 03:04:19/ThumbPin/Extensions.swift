//
//  Extensions.swift
//  BistroStays
//
//  Created by NCT109 on 27/08/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let pushHandleNotifi = Notification.Name("pushHandleNotifi")
    static let chatReloadNotifi = Notification.Name("chatReloadNotifi")
    static let requestDetailReloadNotifi = Notification.Name("requestDetailReloadNotifi")
    static let changeLangNotifi = Notification.Name("changeLangNotifi")
    static let sideMenuBadgegNotifi = Notification.Name("sideMenuBadgegNotifi")
}

extension UIViewController {
    
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

//MARK:- Very Important Extention for developer purpose
extension UITableViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
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
extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func bringToFront() {
        self.superview?.bringSubview(toFront: self)
    }
}

extension String {
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

extension UIButton {
    func createCorenerRadiusButton() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
}
extension UIImageView {
    func createCorenerRadiuss() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UIView {
    func createCorenerRadius() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
    func roundCornersWithLayerMask(cornerRadii: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
extension UIAlertController {
    
    func isValidEmail(_ email: String) -> Bool {
        return email.characters.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.characters.count > 4 && password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }
    
    @objc func textDidChangeInLoginAlert() {
        if let email = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isValidEmail(email)
        }
    }
    
    @objc func textFieldCheckLenght() {
        if let text = textFields?[0].text,
            let action = actions.last {
            if text.isEmpty {
                action.isEnabled = false
            }else {
                action.isEnabled = true
            }
        }
    }
}
extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    
}
extension String {
    static func getFormattedDate(string: String , formatterPass:String, formatterGet:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatterPass
       // dateFormatterGet.calendar = Calendar(identifier: .gregorian)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatterGet
        //dateFormatterPrint.calendar = Calendar(identifier: .persian)
        let isLang: String? = UserDefaults.standard.string(forKey: "IS_Lang")
        if isLang == "2" {
           dateFormatterPrint.locale = Locale(identifier: "fa")
        }else {
            dateFormatterPrint.locale = Locale(identifier: "en")
        }
        let date: Date? = dateFormatterGet.date(from: string)
        var stDate = String ()
        //print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        if let check = date {
            stDate = dateFormatterPrint.string(from: check)
        }
        return stDate
    }
}
extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"-Bd") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of:"-Bd") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = Color.Custom.blackColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero //CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
