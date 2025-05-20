//
//  BaseViewController.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController
{
    var sharedAppdelegate:AppDelegate
    {
        get
        {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var navigationBar: NavigationBarView!
    var statusBar: StatusBarView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        statusBar = StatusBarView.loadNib()
        self.view.addSubview(self.statusBar)
        navigationBar = NavigationBarView.loadNib()
        self.view.addSubview(self.navigationBar)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        self.statusBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        self.statusBar.bringToFront()
        
        self.navigationBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? 64 : 50)
        self.navigationBar.bringToFront()
        
        self.view.layoutIfNeeded()
    }
    
    func setUpNavigation(vc:UIViewController, isBackButton:Bool = false, btnTitle:String = "", navigationTitle:String, action: Selector) {
        
        if isBackButton
        {
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "BackArrowIPAD"), for: UIControlState())}
            else{navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "ic_back"), for: UIControlState())}
            
        }
        else{
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "MenuIconIPAD"), for: UIControlState())}
            else{navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "AboutUs"), for: UIControlState())}
        }
        
        self.navigationBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? 64 : 50)
        self.navigationBar.bringToFront()
        
        navigationBar.btnMenu.removeTarget(nil, action: nil, for: .allEvents)
        
        navigationBar.btnMenu.addTarget(vc, action:action, for: UIControlEvents.touchUpInside)
        navigationBar.btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControlState())
        navigationBar.btnMenu.setTitleColor(UIColor.white, for: UIControlState())
        navigationBar.lblTitle.text = navigationTitle
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{navigationBar.lblTitle.textColor = .black}
        else{navigationBar.lblTitle.textColor = .white}
        
    }
}
extension UIView
{
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func bringToFront() {
        self.superview?.bringSubview(toFront: self)
    }
    
}

