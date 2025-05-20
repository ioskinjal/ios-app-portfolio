//
//  extension.swift
//  ConnectIn
//
//  Created by NCrypted on 19/04/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Photos

enum BorderSide: Int

{
    case all = 0, top, bottom, left, right, customRight, customBottom
}

extension UIView
{
    func setRadius(_ radius: CGFloat? = nil)
    {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func setRadiusWithShadow(_ radius: CGFloat? = nil)
    {
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius ?? self.frame.width / 2).cgPath
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    func setBorder(_ radius:CGFloat? = nil, _ color:UIColor? = nil)
    {
        self.layer.borderWidth = radius ?? 1
        self.layer.borderColor = color?.cgColor ?? UIColor.black.cgColor
    }
    func parentView<T: UIView>(of type: T.Type) -> T?
    {
        guard let view = self.superview else
        {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    //Border 
    
    func border(side: BorderSide = .all, color:UIColor = UIColor.black, borderWidth:CGFloat = 1.0)
    {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = borderWidth
        
        switch side
        {
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
        if side.rawValue != 0
        {
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    //Gradient Color
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
    
    enum GradientOrientation
    {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint : CGPoint
        {
            return points.startPoint
        }
        
        var endPoint : CGPoint
        {
            return points.endPoint
        }
        
        var points : GradientPoints
        {
            get {
                switch(self)
                {
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
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) -> Void
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void
    {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
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



extension String
{
    var isValidEmail: Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}


extension UIViewController
{
    //MARK:- UIAlertController
    func alert(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message : String, completion:@escaping () -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        {
            (action: UIAlertAction) in
            print("Youve pressed OK Button")
            completion()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func alert(title: String, message : String, actions:[String], completion:@escaping (_ index:Int) -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for i in 0..<actions.count
        {
            let act = UIAlertAction(title: actions[i], style: .default, handler: { (actionn) in
                let indexx = actions.index(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func alert(title: String, message : String, actions:[UIAlertAction])
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions
        {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIColor
{
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
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


extension UIImage
{
    func resizeImage1(_ dimension: CGFloat, opaque: Bool, contentMode: UIViewContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        //let size = self.size
        //let aspectRatio =  size.width/size.height
        
        switch contentMode
        {
        case .scaleAspectFit:
            //            if aspectRatio > 1 {                            // Landscape image
            //                width = dimension
            //                height = dimension / aspectRatio
            //            } else {                                        // Portrait image
            //                height = dimension
            //                width = dimension * aspectRatio
            //            }
            width = dimension
            height = dimension
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *)
        {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}


extension UIView
{
    func addConstarinWithFormat(format:String,views:UIView...)
    {
        var viewDictinary  = [String:UIView]()
        for (index , view) in views.enumerated()
        {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDictinary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictinary))
    }
}

extension UIView
{
    
    @IBInspectable var shadow: Bool
        {
        get
        {
            return layer.shadowOpacity > 0.0
        }
        set
        {
            if newValue == true
            {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat
        {
        get
        {
            return self.layer.cornerRadius
        }
        set
        {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false
            {
                self.layer.masksToBounds = true
            }
        }
    }
    
    private func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                           shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                           shadowOpacity: Float = 0.4,
                           shadowRadius: CGFloat = 2.0)
    {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

extension UIViewController
{
    class var storyboardID:String
    {
        return "\(self)"
    }
    static func instantiate(appStorybord:AppStoryboard) -> Self
    {
        return appStorybord.viewController(viewControllerClass: self)
    }
}
//MARK:- Very Important Extention for developer purpose
extension UITableViewCell
{
    class var identifier:String
    {
        return"\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}


extension UICollectionViewCell
{
    class var identifier:String
    {
        return"\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}





//https://stackoverflow.com/questions/26018302/draw-dotted-not-dashed-line-with-ibdesignable-in-2017/39752397
extension UIView
{
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat)
    {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [6,3] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension Bool
{
    mutating func toggal()
    {
        self = !self
    }
}

extension UIViewController
{
    //https://useyourloaf.com/blog/openurl-deprecated-in-ios10/
    func open(scheme: String)
    {
        if let url = URL(string: scheme)
        {
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            }
            else
            {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    func open(url: URL)
    {
        if UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *)
            {
                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
                UIApplication.shared.open(url, options: options, completionHandler: nil)
            }
            else
            {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        else
        {
            print("Can't open given URL")
        }
    }
}

extension UITextField{
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

extension UIResponder
{
    var viewController: UIViewController?
    {
        if let vc = self as? UIViewController
        {
            return vc
        }
        return next?.viewController
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
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
    
    struct DocumentsDirectory
    {
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
    
    func isCloudEnabled() -> Bool
    {
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
    
    func copyFileToCloud()
    {
        if isCloudEnabled()
        {
            //UIApplication.shared.isNetworkActivityIndicatorVisible = true
            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear all files in iCloud Doc Dir
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
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
    
    func copyFileToLocal()
    {
        if isCloudEnabled()
        {
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


extension UIViewController{
    
    static var identifier: String {
        return String(describing: self)
    }
}
