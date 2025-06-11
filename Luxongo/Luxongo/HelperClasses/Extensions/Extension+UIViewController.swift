//
//  Extension+UIViewController.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
//    func presentAsPopUp(parentVC: UIViewController) {
//        self.modalPresentationStyle = .overCurrentContext
//        self.modalTransitionStyle = .crossDissolve
//        parentVC.present(self, animated: true, completion: nil)
//    }
    
    func present(asPopUpView vc: UIViewController, completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: completion)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIApplicationOpenExternalURLOptionsKey(_ input: UIApplication.OpenExternalURLOptionsKey) -> String {
    return input.rawValue
}


extension UIViewController {
    //https://useyourloaf.com/blog/openurl-deprecated-in-ios10/
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
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
                let options = [convertFromUIApplicationOpenExternalURLOptionsKey(UIApplication.OpenExternalURLOptionsKey.universalLinksOnly) : true]
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary(options), completionHandler: nil)
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
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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




extension UIViewController{
    func displayPopUp(presentView view: UIView, isPresent:Bool = true) {
        if isPresent{
            self.view.addSubview(view)
            //sceneDockView.didMoveToSuperview()
            view.bringSubviewToFront(self.view)
            
            view.center = self.view.center
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
            view.addWidthConstraint(toView: nil, relation: .equal, constant: ScreenSize.SCREEN_WIDTH)
            view.addHeightConstraint(toView: nil, relation: .equal, constant: 230)
        }else{
            view.removeFromSuperview()
        }
    }
}
