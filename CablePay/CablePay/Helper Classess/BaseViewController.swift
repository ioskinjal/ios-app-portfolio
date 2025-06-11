//
//  BaseViewController.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    var navigationBar: NavigationBarView!
    var statusBar: StatusBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBar = StatusBarView.loadNib()
        self.view.addSubview(self.statusBar)
        navigationBar = NavigationBarView.loadNib()
        self.view.addSubview(self.navigationBar)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.statusBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        self.statusBar.bringToFront()
        
        self.navigationBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: 60)
        self.navigationBar.bringToFront()
        
        self.view.layoutIfNeeded()
    }
    //isRightBtn:Bool = false, actionRight: Selector = #selector(onClickRightBtn(_:)), btnRightImg:UIImage = #imageLiteral(resourceName: "ic_account_settings")
    func setUpNavigation(vc:UIViewController, isBackButton:Bool = false, btnTitle:String = "", navigationTitle:String, action: Selector, isRightBtn:Bool = false, actionRight: Selector = #selector(onClickRightBtn(_:)), btnRightImg:UIImage = #imageLiteral(resourceName: "ic_headphone") ){
        if isBackButton{
            navigationBar.btnMenu.setImage(UIImage(named: "Back"), for: UIControl.State())
        }
        else{
            navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "ic_user"), for: UIControl.State())
        }
        navigationBar.btnMenu.addTarget(vc, action:action, for: UIControl.Event.touchUpInside)
        navigationBar.btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControl.State())
        navigationBar.btnMenu.setTitleColor(Color.white, for: UIControl.State())
        navigationBar.lblTitle.text = navigationTitle
        
        //RightButton
        navigationBar.btnRight.setImage(btnRightImg, for: UIControl.State())
        navigationBar.btnRight.addTarget(vc, action:actionRight, for: UIControl.Event.touchUpInside)
        navigationBar.btnRight.isHidden = !isRightBtn
        
    }
    
    @objc func onClickRightBtn(_ sender: UIButton) {
        print("Right Click form parent")
    }
}
