//
//  Alert.swift
//  BooknRide
//
//  Created by NCrypted on 02/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class Alert: NSObject {

    typealias completitionBlock = () -> Void

    public func showAlert(titleStr:String, messageStr:String, buttonTitleStr:String){
      
        let alertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitleStr, style: UIAlertActionStyle.default, handler: { (action) in
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func showAlertAndPopVC(titleStr:String, messageStr:String, buttonTitleStr:String) {
        
        let alertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitleStr, style: UIAlertActionStyle.default, handler: { (action) in
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let navController = appDelegate.window!.rootViewController as! UINavigationController
            navController.popViewController(animated: true)
            
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func showAlertWithCompletionHandler(titleStr:String, messageStr:String, buttonTitleStr:String,completionBlock:@escaping completitionBlock){
        
        let alertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitleStr, style: UIAlertActionStyle.default, handler: { (action) in
    
            completionBlock()
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func showAlertWithLeftAndRightCompletionHandler(titleStr:String, messageStr:String, leftButtonTitle:String,rightButtonTitle:String,leftCompletionBlock:@escaping completitionBlock,rightCompletionBlock:@escaping completitionBlock){
        
        let alertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: leftButtonTitle, style: UIAlertActionStyle.default, handler: { (action) in
            
            leftCompletionBlock()
        }))
        alertController.addAction(UIAlertAction(title: rightButtonTitle, style: UIAlertActionStyle.default, handler: { (action) in
            
            rightCompletionBlock()
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
