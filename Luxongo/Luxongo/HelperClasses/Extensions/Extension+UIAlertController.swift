//
//  Extension+UIAlertController.swift
//  Luxongo
//
//  Created by admin on 7/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    private struct AssociatedKeys {
        static var blurStyleKey = "UIAlertController.blurStyleKey"
    }
    
    public var blurStyle: UIBlurEffect.Style {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurStyleKey) as? UIBlurEffect.Style ?? .light
        } set (style) {
            objc_setAssociatedObject(self, &AssociatedKeys.blurStyleKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    public var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0) : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController, presentationController.responds(to: Selector(("popoverView"))), let view = presentationController.value(forKey: "popoverView") as? UIView // We're on an iPad and visual effect view is in a different place.
        {
            return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
        }
        
        return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
    }
    
    private var cancelActionView: UIView? {
        return view.recursiveSubviews.compactMap({
            $0 as? UILabel}
            ).first(where: {
                $0.text == actions.first(where: { $0.style == .cancel })?.title
            })?.superview?.superview
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, blurStyle: UIBlurEffect.Style) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
}

extension UIView {
    
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}



extension UIApplication{
    
    static var rootVC: UIViewController?{
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static func alert(title: String, message : String, style: UIAlertAction.Style = .default){
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)//, blurStyle: .light)
        let OKAction = UIAlertAction(title: "Ok".localized, style: style, handler: nil)
        alertController.addAction(OKAction)
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    static func alert(title: String, message : String, completion:@escaping () -> Void) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)//, blurStyle: .light)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default) {
            (action: UIAlertAction) in
            //print("You've pressed OK Button")
            completion()
        }
        alertController.addAction(OKAction)
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    static func alert(title: String, message : String, actions:[String], style: [UIAlertAction.Style], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)//, blurStyle: .light)
        for i in 0..<actions.count {
            let act = UIAlertAction(title: actions[i].localized, style: style[i], handler: { (actionn) in
                let index = actions.firstIndex(of: actionn.title!)
                completion(index!)
            })
            alertController.addAction(act)
        }
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    static func alert(title: String, message : String, actions:[String], completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)//, blurStyle: .light)
        for i in 0..<actions.count {
            let act = UIAlertAction(title: actions[i].localized, style: .default, handler: { (actionn) in
                let indexx = actions.firstIndex(of: actionn.title!)
                completion(indexx!)
            })
            alertController.addAction(act)
        }
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    static func alert(title: String, message : String, actions:[UIAlertAction]) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)//, blurStyle: .light)
        for action in actions {
            alertController.addAction(action)
        }
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    static func alert(title: String, message : String, actions:[String], style: [UIAlertAction.Style], type: UIAlertController.Style, completion:@escaping (_ index:Int) -> Void) {
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: type)//, blurStyle: .light)
        for i in 0..<actions.count {
            let act = UIAlertAction(title: actions[i].localized, style: style[i], handler: { (actionn) in
                let index = actions.firstIndex(of: actionn.title!)
                completion(index!)
            })
            alertController.addAction(act)
        }
        UIApplication.rootVC?.present(alertController, animated: true, completion: nil)
    }
    
}


