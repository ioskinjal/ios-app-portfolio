//
//  AppHelper.swift
//  AndrewsRefinishing
//
//


import UIKit
import MBProgressHUD

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class AppHelper: NSObject {
    
    struct Platform
    {
        static var isSimulator: Bool
        {
            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
        }
    } 
    
    class func showAlert(_ title:String, message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(defaultAction)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertMsg(_ title:String, message:String)
    {
        let alert = UIAlertView.init(title: "Alert".localized, message: message.localized, delegate:nil, cancelButtonTitle: "Ok".localized)
        alert.show()
    }
    
    class func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func showLoadingView()
    {
        
        
        if appDelegate?.isLoadingViewVisible == false{
            let window = UIApplication.shared.keyWindow!
            let loading = MBProgressHUD.showAdded(to: window, animated: true)
            loading.mode =  MBProgressHUDMode.indeterminate
            loading.label.text = "please wait...".localized
            appDelegate?.isLoadingViewVisible = true
        }
    }
    
    class func hideLoadingView()
    {
        let window = UIApplication.shared.keyWindow
        MBProgressHUD.hide(for: window!, animated: true)
        appDelegate?.isLoadingViewVisible = false
    }  

}
