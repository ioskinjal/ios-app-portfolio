//
//  Extension+PageViewController.swift
//  Luxongo
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension UIPageViewController {
    //https://stackoverflow.com/questions/22098493/how-do-i-disable-the-swipe-gesture-of-uipageviewcontroller
    func enableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
                break
            }
        }
    }
    
    func disableSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
                break
            }
        }
    }
}
