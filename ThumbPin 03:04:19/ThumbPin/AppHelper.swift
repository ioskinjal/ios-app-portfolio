//
//  AppHelper.swift
//  AndrewsRefinishing
//
//

import UIKit

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
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
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
        let alert = UIAlertView.init(title: localizedString(key: "Alert"), message: localizedString(key: message), delegate:nil, cancelButtonTitle: localizedString(key: "Ok"))
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
            let window = UIApplication.shared.keyWindow
            let loading = MBProgressHUD.showAdded(to: window, animated: true)
            loading?.mode = MBProgressHUDModeIndeterminate
            loading?.labelText = localizedString(key: "please wait...");
            appDelegate?.isLoadingViewVisible = true
        }
    }
    
    class func hideLoadingView()
    {
        let window = UIApplication.shared.keyWindow
        MBProgressHUD.hide(for: window, animated: true)
        appDelegate?.isLoadingViewVisible = false
    }  

}
