//
//  YuppViewController.swift
//  Yuppflix
//
//  Created by Ankoos on 09/12/16.
//  Copyright © 2016 YuppTV. All rights reserved.
//

import UIKit

extension UIViewController {
   
    func startAnimating(allowInteraction:Bool) {
//        print(#function)
        self.view.isUserInteractionEnabled = allowInteraction
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = allowInteraction
//        UIApplication.shared.beginIgnoringInteractionEvents()
        AppDelegate.getDelegate().activityIndicator.startAnimating()
    }
    func stopAnimating() {
//        print(#function)
        
        self.view.isUserInteractionEnabled = true
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = true
//        UIApplication.shared.endIgnoringInteractionEvents()
        
        AppDelegate.getDelegate().activityIndicator.stopAnimating()
    }
    func stopAnimatingPlayer(_ isMinimized:Bool) {
//        print(#function)
        self.view.isUserInteractionEnabled = true
        if isMinimized  == false {
            AppDelegate.getDelegate().activityIndicator.stopAnimating()
        }
    }
    
    
}

extension UICollectionViewController {
    func startAnimating2(_ allowInteraction:Bool) {
        //        print(#function)
        self.view.isUserInteractionEnabled = allowInteraction
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = false
        //        UIApplication.shared.beginIgnoringInteractionEvents()
        AppDelegate.getDelegate().activityIndicator.startAnimating()
    }
    func stopAnimating2() {
        //        print(#function)
        self.view.isUserInteractionEnabled = true
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = true
        //        UIApplication.shared.endIgnoringInteractionEvents()
        
        AppDelegate.getDelegate().activityIndicator.stopAnimating()
    }
    func stopAnimatingPlayer2(_ isMinimized:Bool) {
        //        print(#function)
        self.view.isUserInteractionEnabled = true
        if isMinimized  == false {
            AppDelegate.getDelegate().activityIndicator.stopAnimating()
        }
    }
}
