//
//  BaseViewController.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

   
    
  //  var navigationBar: NavigationBarView!
   // var statusBar: StatusBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  statusBar = StatusBarView.loadNib()
//        self.view.addSubview(self.statusBar)
//        navigationBar = NavigationBarView.loadNib()
//        self.view.addSubview(self.navigationBar)
//
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.statusBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
//        self.statusBar.bringToFront()
//
//        self.navigationBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: 60)
//        self.navigationBar.bringToFront()
//
//        self.view.layoutIfNeeded()
    }
//    //isRightBtn:Bool = false, actionRight: Selector = #selector(onClickRightBtn(_:)), btnRightImg:UIImage = #imageLiteral(resourceName: "ic_account_settings")
//    func setUpNavigation(vc:UIViewController, isBackButton:Bool = false, btnTitle:String = "", navigationTitle:String, action: Selector, isRightBtn:Bool = false, actionRight: Selector = #selector(onClickRightBtn(_:)), btnRightImg:UIImage = #imageLiteral(resourceName: "menu-ico") ){
//        if isBackButton{
//            navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "Back"), for: UIControlState())
//        }
//        else{
//            navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "menu-ico"), for: UIControlState())
//        }
//        navigationBar.btnMenu.addTarget(vc, action:action, for: UIControlEvents.touchUpInside)
//        navigationBar.btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControlState())
//        navigationBar.btnMenu.setTitleColor(Color.white, for: UIControlState())
//        navigationBar.lblTitle.text = navigationTitle
//
//        //RightButton
//        navigationBar.btnRight.setImage(btnRightImg, for: UIControlState())
//        navigationBar.btnRight.addTarget(vc, action:actionRight, for: UIControlEvents.touchUpInside)
//        navigationBar.btnRight.isHidden = !isRightBtn
//
//    }
    
    @objc func onClickRightBtn(_ sender: UIButton) {
        print("Right Click form parent")
    }
}
