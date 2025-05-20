//
//  BaseViewController.swift
//  BistroStays
//
//  Created by NCT109 on 27/08/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var sharedAppdelegate:AppDelegate {
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
//    var navigationBar: NavigationBarView!
    var statusBar: StatusBarView!
    
    var isSetUpStatusBar: Bool = true {
        didSet {
            if isSetUpStatusBar {
                statusBar = StatusBarView.loadNib()
                self.view.addSubview(self.statusBar)
            }
        }
    }
/*    var isSetUpNavigationBar: Bool = false {
        didSet {
            if isSetUpNavigationBar {
                navigationBar = NavigationBarView.loadNib()
                self.view.addSubview(self.navigationBar)
            }
        }
    }   */
    var notificationManager = NotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isSetUpStatusBar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // NotificationCenter.default.addObserver(self, selector: #selector(handlePushNotification(notification:)), name: .pushHandleNotifi, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
      /*  if isSetUpNavigationBar {
            self.navigationBar.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: 50)
            self.navigationBar.bringToFront()
        }  */
        if isSetUpStatusBar {
            self.statusBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
            self.statusBar.bringToFront()
        }else {
            self.statusBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        self.view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // NotificationCenter.default.removeObserver(self)
    }
    
 /*   func setUpNavigation(vc:UIViewController, isBackButton:Bool = false, btnTitle:String = "", navigationTitle:String, action: Selector) {
        if isBackButton{
            navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "ic_back"), for: UIControlState())
        }
        else{
            navigationBar.btnMenu.setImage(#imageLiteral(resourceName: "hamburger-icon"), for: UIControlState())
        }
        navigationBar.btnMenu.addTarget(vc, action:action, for: UIControlEvents.touchUpInside)
        navigationBar.btnMenu.setTitle((btnTitle.isEmpty ? nil : btnTitle), for: UIControlState())
        navigationBar.btnMenu.setTitleColor(Color.white, for: UIControlState())
        navigationBar.lblTitle.text = navigationTitle
    }   */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handlePushNotification(notification: Notification) {
        //print(viewc)
        if let userInfo = notification.object as? NSDictionary {
            notificationManager = NotificationManager(notification: userInfo)
            print(notificationManager.serviceId)
            print(notificationManager.quoteId)
            print(notificationManager.customerId)
            print(notificationManager.serviceIdService)
            if notificationManager.key == "Message" {
                if checkCurrentVC(type: "Message") {
                    print("Current view is loaded")
                    NotificationCenter.default.post(name: .chatReloadNotifi, object: userInfo as NSDictionary)
                }else {
                    let vc = ChatVC.storyboardInstance!
                    vc.quotesId = "\(notificationManager.quoteId!)"
                    vc.serviceID = notificationManager.serviceId!
                    vc.customerId = "\(notificationManager.customerId!)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if notificationManager.key == "Service" {
                if checkCurrentVC(type: "Service") {
                    print("Current view is loaded")
                    //NotificationCenter.default.post(name: .requestDetailReloadNotifi, object: userInfo as NSDictionary)
                }else {
                    let vc = ServiceNotificationsVC.storyboardInstance!
                    vc.serviceId = notificationManager.serviceIdService!
                    vc.isPush = "1"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if notificationManager.key == "Quote" {
                if checkCurrentVC(type: "Quote") {
                    print("Current view is loaded")
                    //NotificationCenter.default.post(name: .requestDetailReloadNotifi, object: userInfo as NSDictionary)
                }else {
                    let vc = MyRequestVC.storyboardInstance!
                    vc.serviceId = notificationManager.serviceId!
                    vc.isPush = "1"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    func checkCurrentVC(type: String) -> Bool {
        if let wd = UIApplication.shared.delegate?.window {
            var vc = wd!.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
            }
            print(vc)
            if type == "Message" {
                if(vc is ChatVC){
                    //your code
                    print("View is visible")
                    return true
                }
            }
            else if type == "Service" {
                if(vc is RequestDetailVC){
                    //your code
                    print("View is visible")
                    return true
                }
            }
            else if type == "Quote" {
                if(vc is RequestDetailVC){
                    //your code
                    print("View is visible")
                    return true
                }
            }
            
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
