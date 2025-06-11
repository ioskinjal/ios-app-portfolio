//
//  AppLoader.swift
//


import UIKit
import QuartzCore

public struct AppLoader {
    
    //MARK: - Change the variables values here for Custom uses
    
    public static var activityColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //UIColor.black
    public static var activityBackgroundColor: UIColor = UIColor.clear
    public static var activityTextFontName: UIFont = UIFont.systemFont(ofSize: 14)
    
    fileprivate static var activityTextColor: UIColor = activityColor
    fileprivate static var activityWidth : CGFloat = (UIScreen.screenWidth / widthDivision) / 2
    fileprivate static var activityHeight = activityWidth
    public static var widthDivision: CGFloat {
        get {
            guard UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad else {
                return 1.7
            }
            return 3.6
        }
    }
    public static var loadOverApplicationWindow: Bool = false
    
    
    //MARK: - Loading View
    fileprivate static var instance: LoadingResource?
    fileprivate static var backgroundView: UIView!
    
    
    public static func showLoading(_ text: String = "", disableUI: Bool = false) {
        AppLoader().startLoadingActivity(text, with: disableUI)
    }
    
    public static func hide(){
        DispatchQueue.main.async {
            instance?.hideActivity()
        }
    }
    
    //MARK: - Main Loading View creating here
    public class LoadingResource: UIView {
        fileprivate var textLabel: UILabel!
        fileprivate var activityView: UIActivityIndicatorView!
        fileprivate var disableUIIntraction = false
        
        convenience init(text: String, disableUI: Bool) {
            self.init(frame: CGRect(x: 0, y: 0, width: activityWidth, height: activityHeight))
            center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            backgroundColor = activityBackgroundColor
            alpha = 1
            layer.cornerRadius = 16 //activityHeight / 2
            
            let yPosition = frame.height/2 - 20
            
            addActivityView(yPosition)
            
            addTextLabel(yPosition + activityView.frame.size.height + 4, text: text)
            
            //Apply here Border & Shadow
            checkActivityBackgroundColor()
            
            guard disableUI else {
                return
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
            disableUIIntraction = true
        }
        
        private func checkActivityBackgroundColor(){
            guard activityBackgroundColor != .clear else {
                return
            }
            self.dropShadow()
        }
        
        fileprivate func addActivityView(_ yPosition: CGFloat){
            activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            //activityView.frame = CGRect(x: (frame.width/2) - 20, y: yPosition, width: 40, height: 40)
            activityView.frame = CGRect(x: (frame.width/2) - 20, y: (frame.height/2) - 20, width: 40, height: 40)
            activityView.color = activityColor
            activityView.startAnimating()
        }
        
        fileprivate func addTextLabel(_ yPosition: CGFloat, text: String){
            textLabel = UILabel(frame: CGRect(x: 5, y: yPosition - 10, width: activityWidth - 10, height: 40))
            textLabel.textColor = activityTextColor
            textLabel.font = activityTextFontName
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.text = text
        }
        
        fileprivate func showLoadingActivity() {
            addSubview(activityView)
            addSubview(textLabel)
            
            guard loadOverApplicationWindow else {
                topMostViewController!.view.addSubview(self)
                return
            }
            UIApplication.shared.windows.first?.addSubview(self)
        }
        
        fileprivate func hideActivity(){
            checkBackgoundWasClear()
            clearView()
        }
        
        
        fileprivate func checkBackgoundWasClear(){
            guard activityBackgroundColor != .clear else {
                return
            }
            textLabel.alpha = 0
            activityView.alpha = 0
        }
        
        fileprivate func clearView(){
            activityView.stopAnimating()
            self.removeFromSuperview()
            instance = nil
            
            if backgroundView != nil {
                UIView.animate(withDuration: 0.1, animations: {
                    backgroundView.backgroundColor = backgroundView.backgroundColor?.withAlphaComponent(0)
                }, completion: { _ in
                    backgroundView.removeFromSuperview()
                })
            }
            
            guard disableUIIntraction else {
                return
            }
            disableUIIntraction = false
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

fileprivate extension AppLoader {
    
    func startLoadingActivity(_ text: String,with disableUI: Bool){
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
        guard AppLoader.instance == nil else {
            print("\n ==========* AppLoader *==========")
            print("Error: Loadering already active now, please stop that before creating a new one.")
            return
        }
        
        guard topMostViewController != nil else {
            print("\n ==========* AppLoader *==========")
            print("Error: You don't have any views set. You may be calling in viewDidLoad or try inside main thread.")
            return
        }
        
        // Separate creation from showing
        AppLoader.instance = LoadingResource(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            AppLoader.instance?.showLoadingActivity()
        }
        //}
    }
}

fileprivate extension UIView {
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

fileprivate extension UIScreen {
    
    class var screenWidth: CGFloat {
        get {
            if UIInterfaceOrientation.portrait.isPortrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    
    class var screenHeight: CGFloat {
        get {
            if UIInterfaceOrientation.portrait.isPortrait {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}

fileprivate var topMostViewController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let controller = presentedVC?.presentedViewController {
        presentedVC = controller
    }
    return presentedVC
}
