
import UIKit
import Foundation
import OTTSdk
import SDWebImage
import CoreTelephony

extension Foundation.Date {
     // MARK: - Date
    struct Date {
        static let formatterISO8601: DateFormatter = {
            let formatter = DateFormatter()
            // formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            // formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            // formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "YYYY"
            return formatter
        }()
        static let fullDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as! Calendar
             formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
             formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as! TimeZone
//            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "dd/MM/YYYY"
            return formatter
        }()
        static let dateWithMonthnameFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as! Calendar
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as! TimeZone
            //            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "dd MMM"
            return formatter
        }()
    }
    
    var formattedISO8601: String { return Date.formatterISO8601.string(from: self) }
    
    func getCurrentTimeStamp() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func getFullYear(_ timestamp:String) -> String {
        
        let time = (timestamp as NSString).doubleValue/1000.0
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
        return  Date.formatterISO8601.string(from: date)
    }
    
    func getTenMinutesBackTimeStamp(value:Int) -> Int64 {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: value, to: self)
        return Int64(newDate!.timeIntervalSince1970 * 1000)
    }

    func getFullDate(_ timestamp:String, inFormat : String = "dd/MM/YYYY") -> String {
        let time = (timestamp as NSString).doubleValue/1000.0
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
  
        let formatter = DateFormatter()
        formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)! as Calendar
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        //            formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = inFormat
        return formatter.string(from: date)
        
    }
    func getDateWithMonthName(_ timestamp:String) -> String {
        let time = (timestamp as NSString).doubleValue/1000.0
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
        return  Date.dateWithMonthnameFormat.string(from: date)
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds * 60 % 60
        let minutes: Int = (totalSeconds * 60 / 60) % 60
        let hours: Int = totalSeconds * 60 / 3600
        return String(format: "%02dh %02dm", hours, minutes)
    }
    func getFullDateWithFormatter(_ timestamp:String, inFormat : String = "dd/MM/YYYY") -> String {
          let time = (timestamp as NSString).doubleValue/1000.0
          let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
    
          let formatter = DateFormatter()
          formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)! as Calendar
          formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
          formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
          formatter.timeZone = NSTimeZone.local
          formatter.dateFormat = inFormat
          return formatter.string(from: date)
          
      }
}
// MARK: - UILabel
extension UILabel{
    func heightForFullTextDisplay() -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text ?? ""
        label.sizeToFit()
        return label.frame.height
    }

    func LabelCornerAndBorder(label:UILabel) -> Void {
        self.viewCornerDesignWithBorder(#colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6745098039, alpha: 1))
        self.asCircle()
    }
   
    class func labelWithFrame(withXposition:CGFloat,withYposition:CGFloat,withWidth:CGFloat,withHeight:CGFloat, andElementData:Element, withAlignment:NSTextAlignment,withSize:CGFloat,numberOfLines:Int = 1) -> UILabel {
        let label = UILabel.init()
        label.frame = CGRect.init(x: withXposition, y: withYposition, width: withWidth, height: withHeight)
        label.textAlignment = withAlignment
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.text = andElementData.data
        label.font = UIFont.ottRegularFont(withSize: withSize)
        if andElementData.isClickable {
            label.isUserInteractionEnabled = true
        }
        else {
            label.isUserInteractionEnabled = false
        }
        if numberOfLines != 1 {
            label.numberOfLines = numberOfLines
            label.sizeToFit()
        }
        return label
    }
    
    class func createDotView(withXposition:CGFloat,withYposition:CGFloat,withWidth:CGFloat,withHeight:CGFloat) -> UIView {
        let dotView = UIView.init(frame: CGRect.init(x: withXposition, y: withYposition, width: withWidth, height: withHeight))
        dotView.backgroundColor = UIColor.white
//        dotView.layer.cornerRadius = withWidth/2.0
        return dotView
    }

}

extension UIFont{
    class func ottItalicFont(withSize : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Italic", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottMediumItalicFont(withSize : CGFloat) -> UIFont {
        return UIFont(name: "Poppins-MediumItalic", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottRegularFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottLightFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Light", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottBoldFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottMediumFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    class func ottSemiBoldFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    }
    class func ottMothlyPlannerSubTitleFont(withSize:CGFloat) -> UIFont {
        return UIFont(name: "Vadelma-Medium", size: (productType.iPad ? withSize + 2 : withSize))!
    }
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
}

// MARK: - UIButton
extension UIButton {
    func needfulDesignCornerAndBorder() -> Void {
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    func cornerDesignWithoutBorder() -> Void {
        self.layer.cornerRadius = 3
        
    }
    func cornerDesignWithBorder() -> Void {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 2.0
        self.layer.borderColor = self.titleLabel?.textColor.cgColor
    }
    func buttonCornerDesignWithBorder(_ color : UIColor, borderWidth : CGFloat = 1.0) -> Void {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    func withBorder() -> Void {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = self.titleLabel?.textColor.cgColor
    }
    func setButtonBackgroundcolor() -> Void {
        self.backgroundColor = AppTheme.instance.currentTheme.themeColor
    }
    func imageRectForContentRect(contentRect:CGRect) -> CGRect {
        var frame = self.imageRect(forContentRect: contentRect)
        frame.origin.x = contentRect.maxX - frame.width - self.imageEdgeInsets.right + self.imageEdgeInsets.left
        
        return frame
    }

    func alignTextUnderImage(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image
        {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel?.text ?? "")
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font ?? UIFont.ottRegularFont(withSize: 14)])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
 
    
    class func buttonWithFrame(withXposition:CGFloat,withYposition:CGFloat,withWidth:CGFloat,withHeight:CGFloat, andElementData:Element,withSize:CGFloat,isRowBtnType:Bool) -> UIButton {
        let button = UIButton.init()
        button.frame = CGRect.init(x: withXposition, y: withYposition, width: withWidth, height: withHeight)
        button.titleLabel?.textColor = UIColor.white
        if isRowBtnType {
            button.backgroundColor = UIColor.init(hexString: "029bde")
        }
        else {
            button.backgroundColor = UIColor.clear
        }
        button.setTitle(andElementData.data, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.ottRegularFont(withSize: withSize)
        if andElementData.isClickable {
            button.isUserInteractionEnabled = true
        }
        else {
            button.isUserInteractionEnabled = false
        }
        return button
    }
    class func normalButtonWithFrame(withXposition:CGFloat,withYposition:CGFloat,withWidth:CGFloat,withHeight:CGFloat,withTitle:String,withSize:CGFloat,isRowBtnType:Bool) -> UIButton {
        let button = UIButton.init()
        button.frame = CGRect.init(x: withXposition, y: withYposition, width: withWidth, height: withHeight)
        button.setTitle(withTitle, for: UIControl.State.normal)
        if isRowBtnType {
            button.titleLabel?.textColor = UIColor.white
            button.backgroundColor = AppTheme.instance.currentTheme.themeColor
        }
        else {
            button.titleLabel?.textColor = UIColor.white
            button.backgroundColor = AppTheme.instance.currentTheme.unThemeColor
        }
        button.titleLabel?.font = UIFont.ottRegularFont(withSize: withSize)
        return button
    }

}
// MARK: - UITableViewCell
extension UITableViewCell {
    func cornerDesignForTableCell() -> Void {
        self.layer.cornerRadius = 3
//        self.setMovieCellBackgroundColor()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:3).cgPath
    }
}
// MARK: - UICollectionViewCell
extension UICollectionViewCell {
    
    func cornerDesignForCollectionCell() -> Void {
        
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.clear
//        self.layer.shadowColor = UIColor.clear.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    func langCornerDesign() -> Void {
        
        self.layer.cornerRadius = 5.0
        //        self.setMovieCellBackgroundColor()
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    func viewCornerDesign1() -> Void {
        
        self.layer.cornerRadius = 5.0
        //        self.setMovieCellBackgroundColor()
    }
    func genresCellcornerDesign() -> Void {
        self.layer.cornerRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}

extension UICollectionView {
    func reloadItems(inSection section:Int) {
        reloadItems(at: (0..<numberOfItems(inSection: section)).map {
            IndexPath(item: $0, section: section)
        })
    }
    func validate(indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections {
            return false
        }
        
        if indexPath.row >= numberOfItems(inSection: indexPath.section) {
            return false
        }
        
        return true
    }
}

// MARK: - UIImageView
extension UIImageView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
   /* func loadImageFromUrl12(_ url1: String){
        // Create Url from string
        let url = URL(string: url1)
        if url != nil {
            
            
            // Download task:
            // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (responseData, responseUrl, error) -> Void in
                // if responseData is not null...
                if let data = responseData{
                    
                    // execute in UI thread
                    DispatchQueue.global().async(execute: { () -> Void in
                        self.image = UIImage(data: data)
                    })
                }
            }) 
            
            // Run task
            task.resume()
        }
    }*/
    
//    func loadImageFromUrl(_ urlString:String)
//    {
//        guard let _ = URL(string: urlString) else {
//
//            print("Error: \(urlString) doesn't seem to be a valid URL")
//            return
//        }
//        let imgURL: URL = URL(string: urlString)!
//
//        self.sd_setImage(with: imgURL , placeholderImage: UIImage(named: "Movies_default.png"))
//
//     }
//    func loadBannerImageFromUrl(_ urlString:String)
//    {
//
//
//        guard let _ = URL(string: urlString) else {
//
//            print("Error: \(urlString) doesn't seem to be a valid URL")
//            return
//        }
//        let imgURL: NSURL = NSURL(string: urlString)!
//
////        self.sd_setImage(with: imgURL as URL!, placeholderImage: UIImage(named: "home_page_banner"))
//
//    }
    func loadingImageFromUrl(_ urlString : String, category : String) {
        var placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        switch category {
        case "banner":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "partner":
            placeHolderImage = #imageLiteral(resourceName: "partner_default")
        case "show":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "movie":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "show_background":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "movie_background":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "movie_tile":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "show_tile":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "episode_tile":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "selected_tvshow_tile":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "device":
            placeHolderImage = #imageLiteral(resourceName: "device_icon")
        case "tv":
            placeHolderImage = #imageLiteral(resourceName: "Default-TVShows")
        case "detail_page":
            placeHolderImage = #imageLiteral(resourceName: "detailspage_alsobackground")
        default:
            placeHolderImage = #imageLiteral(resourceName: "portrait-default")
        }
        guard let url = URL(string: urlString) else  {
            self.image = placeHolderImage
            return
        }
        self.sd_setImage(with: url, placeholderImage: placeHolderImage)
        
    }
    class func imageViewWithFrame(withXposition:CGFloat,withYposition:CGFloat,withWidth:CGFloat,withHeight:CGFloat, andElementData:Element,withImageType:String) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = CGRect.init(x: withXposition, y: withYposition, width: withWidth, height: withHeight)
        if andElementData.elementSubtype == "hd" {
            imageView.image = #imageLiteral(resourceName: "hd_icon")
        }
        else if andElementData.elementSubtype == "cc" {
            imageView.image = #imageLiteral(resourceName: "cc_icon")
        }
        if andElementData.isClickable {
            imageView.isUserInteractionEnabled = true
        }
        else {
            imageView.isUserInteractionEnabled = false
        }
        return imageView
    }

    
}
// MARK: - UIColor
extension UIColor {
    static let tabBarDimGray = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2941176471, alpha: 1)
    static let darkjunglegreen = #colorLiteral(red: 0.1137254902, green: 0.1215686275, blue: 0.137254902, alpha: 1)
    static let safetyOrange = #colorLiteral(red: 0.06274509804, green: 0.168627451, blue: 0.2745098039, alpha: 1)
    static let tabBarTint = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07843137255, alpha: 1)
    static let coolGrey = #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6745098039, alpha: 1)
    static let appBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let cellFocussedTransparent = #colorLiteral(red: 0.0862745098, green: 0.09803921569, blue: 0.1098039216, alpha: 0.5)
    static let textFocussed = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let textUnFocussed = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    static let brownishOrange = #colorLiteral(red: 0.7607843137, green: 0.4392156863, blue: 0.09411764706, alpha: 1)
    static let bloodOrange = #colorLiteral(red: 1, green: 0.3058823529, blue: 0, alpha: 1)
    static let brownishGrey = #colorLiteral(red: 0.3607843137, green: 0.3568627451, blue: 0.3568627451, alpha: 1)
    static let coolGrey2 = #colorLiteral(red: 0.6549019608, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
    static let whiteAlpha50 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    static let genresBackgroundColor = #colorLiteral(red: 0.1490196078, green: 0.1568627451, blue: 0.168627451, alpha: 1)
    static let channelUnselectedTextColor = UIColor(hexString: "9ea1aa")
    static let guideProgramLiveSelected = UIColor(hexString: "c4c4c4")
    static let guideProgramUnselected = UIColor(hexString: "363737")
    static let whiteWithOpacity22 = UIColor.white.withAlphaComponent(0.22)
    static let whiteWithOpacity008 = UIColor.white.withAlphaComponent(0.08)
    static func applyShadowToView(shadowView : UIView, shadowColor : UIColor){
        shadowView.layer.shadowOpacity = 5.0
        shadowView.layer.shadowRadius = 2.0
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
    }
    class func cellSeperatorBlackColor() -> UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
    class func applyGradientToView(subView : UIView){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = subView.bounds
        
        let color1 = UIColor.appBackgroundColor.withAlphaComponent(0.3).cgColor
        let color2 = UIColor.appBackgroundColor.withAlphaComponent(0.53).cgColor
        let color3 = UIColor.appBackgroundColor.cgColor
        let color4 = UIColor.appBackgroundColor.cgColor
        
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.3, 0.9, 1.0]
        subView.layer.addSublayer(gradientLayer)
    }
    
    class func applyAppColorGradientToView(subView : UIView){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = subView.bounds
        
        let color1 = UIColor.appBackgroundColor.withAlphaComponent(0.5).cgColor
        let color2 = UIColor.appBackgroundColor.withAlphaComponent(0.6).cgColor
        let color3 = UIColor.appBackgroundColor.withAlphaComponent(0.9).cgColor
        
        gradientLayer.colors = [color1, color2, color3]
        gradientLayer.locations = [0.0, 0.3, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        subView.layer.addSublayer(gradientLayer)
    }
    
    
    // MARK: -  Account menu items
    //     static let selectedTextColor = UIColor(red: 246.0/255.0, green: 140.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    static let selectedTextColor = #colorLiteral(red: 0.9568627451, green: 0.4392156863, blue: 0, alpha: 1)
    static let tabSelectedTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let tabDeSelectedTextColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.431372549, alpha: 1)
    static let normalTextColor = #colorLiteral(red: 0.6549019608, green: 0.6588235294, blue: 0.6588235294, alpha: 0.7)
    
    // MARK: - Utils
    func bd_componentsFromColor() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    func bd_hexFromColor() -> String
    {
        let components = self.bd_componentsFromColor()
        // convert into integer
        let r: Int = Int(255.0 * components.red)
        let g: Int = Int(255.0 * components.green)
        let b: Int = Int(255.0 * components.blue)
        return String(NSString(format: "%02x%02x%02x", r, g, b))
    }
    
    // MARK: - App colors
    class func activityIndicatorColor() -> UIColor {
        return UIColor.safetyOrange
    }
    
    class func subViewBackgroundColor() -> UIColor {
        return #colorLiteral(red: 0.08235294118, green: 0.1019607843, blue: 0.1294117647, alpha: 1)
    }
    class func cellFocusedTextColor() -> UIColor {
        return UIColor.black
    }
    class func cellSelectedTextColor() -> UIColor {
        return #colorLiteral(red: 0.662745098, green: 0.7568627451, blue: 0.09803921569, alpha: 1)
    }
    class func cellTextColor() -> UIColor {
        return UIColor.white
    }
    class func alertTextColor() -> UIColor {
        return UIColor.white
    }
    class func errorTextColor() -> UIColor {
        return UIColor.red
    }
    // MARK: - Flat colors
    class func selectedGreenColor() -> UIColor {
        return #colorLiteral(red: 0.6666666667, green: 0.7607843137, blue: 0.09803921569, alpha: 1)
    }
    class func turquioseColor() -> UIColor {
        return #colorLiteral(red: 0.1019607843, green: 0.737254902, blue: 0.6117647059, alpha: 1)
    }
    class func greenSeaColor() -> UIColor {
        return #colorLiteral(red: 0.0862745098, green: 0.6274509804, blue: 0.5215686275, alpha: 1)
    }
    class func emeraldColor() -> UIColor {
        return #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
    }
    class func nephritisColor() -> UIColor {
        return #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
    }
    class func peterRiverColor() -> UIColor {
        return #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
    }
    class func belizeHoleColor() -> UIColor {
        return #colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 0.7254901961, alpha: 1)
    }
    class func amethystColor() -> UIColor {
        return #colorLiteral(red: 0.6078431373, green: 0.3490196078, blue: 0.7137254902, alpha: 1)
    }
    class func wisteriaColor() -> UIColor {
        return #colorLiteral(red: 0.5568627451, green: 0.2666666667, blue: 0.6784313725, alpha: 1)
    }
    class func wetAsphaltColor() -> UIColor {
        return #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    }
    class func midnightBlueColor() -> UIColor {
        return #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3450980392, alpha: 1)
    }
    class func sunFlowerColor() -> UIColor {
        return #colorLiteral(red: 0.9450980392, green: 0.768627451, blue: 0.05882352941, alpha: 1)
    }
    class func orangeFlatColor() -> UIColor {
        return #colorLiteral(red: 0.9529411765, green: 0.6117647059, blue: 0.07058823529, alpha: 1)
    }
    class func carrotColor() -> UIColor {
        return #colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1)
    }
    class func faqsTableCellBackgroundColor() -> UIColor {
        return #colorLiteral(red: 0.1725490196, green: 0.1803921569, blue: 0.1960784314, alpha: 1)
    }
    class func faqsTableCellQuestionLabelTextColor() -> UIColor {
        return #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6745098039, alpha: 1)
    }
    class func pumpkinColor() -> UIColor {
        return #colorLiteral(red: 0.8274509804, green: 0.3294117647, blue: 0, alpha: 1)
    }
    class func alizarinColor() -> UIColor {
        return #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
    }
    class func pomegranateColor() -> UIColor {
        return #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1)
    }
    class func cloudsColor() -> UIColor {
        return #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
    }
    class func silverColor() -> UIColor {
        return #colorLiteral(red: 0.7411764706, green: 0.7647058824, blue: 0.7803921569, alpha: 1)
    }
    class func concreteColor() -> UIColor {
        return #colorLiteral(red: 0.5843137255, green: 0.6470588235, blue: 0.6509803922, alpha: 1)
    }
    
    class func asbestosColor() -> UIColor {
        return #colorLiteral(red: 0.4980392157, green: 0.5490196078, blue: 0.5529411765, alpha: 1)
    }
    class func yimPinkishRed() -> UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.1098039216, blue: 0.1411764706, alpha: 1)
    }
    
    class func yimDarkGreyTwo() -> UIColor {
        return #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1450980392, alpha: 1)
    }
    
   
    class func applyGradientToView(_ subView : UIView){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = subView.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.09019607843, green: 0.09803921569, blue: 0.1098039216, alpha: 0.45).cgColor, #colorLiteral(red: 0.09019607843, green: 0.09803921569, blue: 0.1098039216, alpha: 0.88).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0.09019607843, green: 0.09803921569, blue: 0.1098039216, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.5, 0.9, 1.0]
        subView.layer.addSublayer(gradientLayer)
    }
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public convenience init(hexString: String) {
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
    

    class func getButtonsBackgroundColor()-> UIColor{
        return  AppTheme.instance.currentTheme.themeColor
    }
}

// MARK: - UIView
extension UIView {
    func zeroBorderWidth() {
        layer.borderWidth = 0.0
    }
    func changeBorderWidthWith(factor : CGFloat) {
        layer.borderWidth = factor
    }
    func changeBorder(color : UIColor) {
        self.layer.borderColor = color.cgColor
    }
    func viewCornerRediusWithTen(color : UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.cornerRadius = 10
    }
    private func viewBorderWidthTwo() {
        layer.borderWidth = 2.0
    }
    func viewCornersWithFive() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    func viewBorderWidthWithTwo(color : UIColor, isWidthOne : Bool) {
        layer.cornerRadius = 5
        layer.borderColor = color.cgColor
        viewBorderWidthTwo()
        if !isWidthOne {
           layer.borderWidth = 1
        }
    }
    func viewCornerDesignWithBorder(_ color:UIColor) -> Void {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = appContants.appName == .gac ? 1.0 : 2.0
        self.layer.borderColor = color.cgColor
    }
    func viewCornerDesign() -> Void {
        self.layer.cornerRadius = 4
    }
    func viewCornerRadiusWithTwo() {
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
    func viewBorderWithOne(cornersRequired : Bool) {
        layer.borderWidth = 1
        if cornersRequired { viewCornerDesign() }
    }
    func setGradientForView() -> Void {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    func setDetailsPageGradientForView() -> Void {
        let color8 = UIColor.init(hexString: "0d0d15").withAlphaComponent(1.0).cgColor
        let color9 = UIColor.init(hexString: "0d0d15").withAlphaComponent(0).cgColor
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [color9, color8]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    func applyGradientToView(_ view : UIView, numberOfColors : Int){
        let layer : CAGradientLayer = CAGradientLayer()
        layer.name = "grad"
        layer.frame.size = view.frame.size
        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
        
        let color5 = UIColor.init(hexString: "232326").withAlphaComponent(0.25).cgColor
        let color6 = UIColor.init(hexString: "232326").withAlphaComponent(0).cgColor
        let color7 = UIColor.init(hexString: "232326").withAlphaComponent(1.0).cgColor
        let color4 = UIColor.init(hexString: "232326").withAlphaComponent(0.8).cgColor
        
        let color0 = UIColor.clear.cgColor
        let color2 = UIColor.init(hexString: "232326").withAlphaComponent(0.5).cgColor
        let color3 = UIColor.init(hexString: "232326").withAlphaComponent(0.8).cgColor
        
        
        
        // 4 for details page background and 3 for detailspage gradient view
        if numberOfColors == 1{
            layer.colors = [color0,color2,color3]
            layer.locations = [0.0, 0.8,0.95, 1.0]
        }else if numberOfColors == 4{
            layer.locations = [0.0, 0.8,0.95, 1.0]
            layer.colors = [color5,color4,color7]
        }
        else{
            layer.locations = [0.0, 0.8,0.95, 1.0]
            layer.colors = [color6,color5,color7]
        }
        
        if (view.layer.sublayers != nil)
        {
            
            for layer:CALayer in view.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
            
            
        }
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
        
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
    
    
    func redDotDesign() -> Void {
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.yimPinkishRed().cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
    func cornerDesign() -> Void {
        self.layer.cornerRadius = 0
        //        self.setMovieCellBackgroundColor()
//        self.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
    func tvShowCornerDesign() -> Void {
        self.layer.cornerRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
    func getRandomColor() -> Void{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
// MARK: - Bundle
extension Bundle {
    
    class var applicationVersionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    class var applicationBuildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
    
}
public extension String {
    
    // MARK: - getting JsonString From Dictionary
    func getDateOfBirth() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.date(from: self) ?? Date()
    }
    static func getJsonStringForDictionary(dictionary : [String : String]) -> String? {
        do {
            let jsonData : NSData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            return String(data: jsonData as Data, encoding: String.Encoding.utf8)
        } catch{
            return nil
        }
    }
    func validateEmail() -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func convertToJson() -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getChromeCastConnectAlert() -> String {
        return "Please check chrome cast device is switched on and connected to same WiFi network"
    }
    static func getAppName() -> String {
        var appName = ""
        switch appContants.appName {
        case .firstshows:
            appName = "FirstShows"
        case .reeldrama:
            appName = "ReelDrama"
        case .tsat:
            appName = "T-SAT"
        case .aastha:
            appName = "Aastha"
        case .gotv:
            appName = "GoTV"
        case .yvs:
            appName = "YVS"
        case .supposetv:
            appName = "Level News"
        case .mobitel:
            appName = "PEOTVGO"
        case .pbns:
            appName = "PBNS"
        case .airtelSL:
            appName = "Airtel SL"
        case .gac:
            appName = "GACommunity"
        }
        return appName
    }
    func getInternetMsgStr() -> String {
        return "The Internet connection appears to be offline.".localized
    }
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    func getNetworkType()->String {
        
        let reachability = Reachability.forInternetConnection()
        reachability?.startNotifier()
        let networkStatus = reachability?.currentReachabilityStatus()
        if networkStatus == ReachableViaWiFi {
            return "Wifi"
        }
        else if networkStatus == ReachableViaWWAN {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?: return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?: return "3G"
            case CTRadioAccessTechnologyLTE?: return "4G"
            default: return ""
            }
        }
        else {
            return "none"
        }
    }
    
    public static var welcomeVideoStatus : String{
        set{
            UserDefaults.standard.set(newValue, forKey: "WelcomeVideoStatus")
        }
        get{
            if let session = UserDefaults.standard.value(forKey: "WelcomeVideoStatus") as? String{
                return session
            }
            else{
                return ""
            }
        }
    }

    public static var appliedFilter : String{
        set{
            UserDefaults.standard.set(newValue, forKey: "AppliedFilter")
        }
        get{
            if let session = UserDefaults.standard.value(forKey: "AppliedFilter") as? String{
                return session
            }
            else{
                return ""
            }
        }
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            if productType.iPad {
                border.frame = CGRect.init(x: frame.width - (thickness/2), y: 10, width: thickness, height: (frame.height - 20.0))
            }
            else {
                border.frame = CGRect.init(x: frame.width - (thickness/4), y: 10, width: thickness, height: (frame.height - 20.0))
            }
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

// MARK: - UIScreen
public extension UIScreen {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus_OLD
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .Unknown}
        //print("---------------",UIScreen.main.nativeBounds)
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920:
            return .iPhone6Plus_OLD
        case 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
}
public extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
func Log(message : String) {
    #if DEBUG
    print(message)
    #endif
}
extension UIViewController{
    func errorAlert(forTitle title : String, message : String, needAction : Bool, reslt :@escaping((Bool)->Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            reslt(needAction)
        }))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if presentedViewController != nil {
                topController.dismiss(animated: true, completion: {
                    topController.present(alertController, animated: true, completion: nil)
                })
            }else {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
//        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else { return }
//        if presentedViewController == nil {
//            rootViewController.present(alertController, animated: true, completion: nil)
//        }else {
//            dismiss(animated: true, completion: {
//                rootViewController.present(alertController, animated: true, completion: nil)
//            })
//        }
    }
    func printLog(log: AnyObject?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print(formatter.string(from: NSDate() as Date), terminator: "")
        if log == nil {
            print("nil")
        }
        else {
            print(log!)
        }
    }
    func className() -> String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    func getStaticSection(code : String,contentType:String) -> Section {
        var tempSectionInfo = [String:Any]()
        if code == "chatroom" {
            if (contentType == "live" || contentType == "epg") {
                tempSectionInfo["name"] = "Chat Room"
            }
            else{
                tempSectionInfo["name"] = "Watch Party"
            }
            tempSectionInfo["iconUrl"] = ""
        }
        else{
            tempSectionInfo["name"] = ""
            tempSectionInfo["iconUrl"] = ""
        }
        tempSectionInfo["description"] = ""
        tempSectionInfo["dataSubType"] = ""
        tempSectionInfo["bannerImage"] = ""
        tempSectionInfo["code"] = code
        tempSectionInfo["dataType"] = ""
        
        var tempSectionControls = [String:Any]()
        tempSectionControls["showViewAll"] = false
        tempSectionControls["viewAllTargetPath"] = ""
        tempSectionControls["infiniteScroll"] = false
        
        var tempSectionData = [String:Any]()
        let tempData = [Any]()
        tempSectionData["data"] = tempData
        
        
        var tempVal = [String : Any]()
        tempVal["sectionInfo"] = tempSectionInfo
        tempVal["sectionControls"] = tempSectionControls
        tempVal["sectionData"] = tempSectionData
        
        return (Section(tempVal))
    }
}
extension UIStackView {
    func addHorizontalSeparators(color : UIColor) {
        var i = self.arrangedSubviews.count
        while i >= 1 {
            let separator = createSeparator(color: color)
            insertArrangedSubview(separator, at: i)
            separator.heightAnchor.constraint(equalTo: self.self.heightAnchor, multiplier: 1).isActive = true
            i -= 1
        }
    }

    private func createSeparator(color : UIColor) -> UIView {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = color
        return separator
    }
}
//extension UIAlertController {
//    open override func viewWillDisappear(_ animated: Bool) {
//        self.view.isHidden = true
//    }
//}
extension Double {
    func getDateStringFromTimeInterval() -> String {
        let date = Date(timeIntervalSince1970: self/1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        return dateFormatter.string(from: date)
    }
    func getDateStringFromTimeIntervalWithMonth() -> String {
        let date = Date(timeIntervalSince1970: self/1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: date)
    }
    func getDateOfBirth() -> String {
        let date = Date(timeIntervalSince1970: self/1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: date)
    }
    func convertToDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}
extension UINavigationController {
  public func pushViewController(viewController: UIViewController,
                                 animated: Bool,
                                 completion:(() -> Void)?) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    pushViewController(viewController, animated: animated)
    CATransaction.commit()
  }
    func popBackViewController(animated:Bool = false, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%dhr %02dmins %02dsecs", hour, minute, second)
    }
    var minuteSecondMS: String {
        String(format:"%02dmins %02dsecs", minute, second)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
extension Int {
    var msToSeconds: Double { Double(self) / 1000 }
}
