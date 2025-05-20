//
//  AppDelegate.swift
//  Happenings
//
//  Created by admin on 1/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import IQKeyboardManager
import LGSideMenuController
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

     var sideMenuController:LGSideMenuController!
    var isLogin:Bool = false
    
    private func configureEnviorment() {
        
        let sideMenuController = LGSideMenuController()
        
        sideMenuController.leftViewPresentationStyle = .slideAbove;
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width;
           sideMenuController.leftViewBackgroundColor = UIColor.white
        self.sideMenuController = sideMenuController
      //  sideMenuController.leftViewBackgroundImage = #imageLiteral(resourceName: "Bgimage")
        GMSPlacesClient.provideAPIKey("AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss")
       
        
    }
    
    

    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        configureEnviorment()
        
        
        let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigationController?.pushViewController(storyboard.instantiateViewController(withIdentifier: "SplashVC"), animated: false)
        
        IQKeyboardManager.shared().isEnabled = true
         registerRemoteNotification(application)
        return true 
    }

    private func registerRemoteNotification(_ application: UIApplication) {
        // REMOT NOTIFICATION SETTING
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
                print(error?.localizedDescription ?? "")
                // Enable or disable features based on authorization.
            }
            application.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            
            application.registerUserNotificationSettings(notificationSettings)
            application.registerForRemoteNotifications()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate {
    // MARK: - Loader
    
    @available(iOS 9.0, *)
    func startLoader(loaderText:String = ""){
        
        let balackView:UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            view.tag = 420
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let indicator:UIActivityIndicatorView = {
            let iV = UIActivityIndicatorView(style: .whiteLarge)
            iV.startAnimating()
            iV.hidesWhenStopped = true
            iV.translatesAutoresizingMaskIntoConstraints = false
            return iV
        }()
        
        let label:UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
            label.textAlignment = .center
            label.textColor = .white
            label.text = loaderText
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let stackView :UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.addArrangedSubview(indicator)
            stack.addArrangedSubview(label)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 8
            return stack
        }()
        
        DispatchQueue.main.async {
            if let window = self.window{
                let view = window.viewWithTag(420)
                if view != nil{
                    self.stoapLoader()
                } else{
                    self.window?.addSubview(balackView)
                    NSLayoutConstraint.activate([
                        balackView.topAnchor.constraint(equalTo: window.topAnchor),
                        balackView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
                        balackView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                        balackView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
                        ])
                    balackView.addSubview(stackView)
                    NSLayoutConstraint.activate([
                        stackView.centerXAnchor.constraint(equalTo: balackView.centerXAnchor),
                        stackView.centerYAnchor.constraint(equalTo: balackView.centerYAnchor),
                        stackView.leadingAnchor.constraint(equalTo: balackView.leadingAnchor),
                        stackView.trailingAnchor.constraint(equalTo: balackView.trailingAnchor)
                        ])
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            }
        }
    }
    
    func stoapLoader(){
        DispatchQueue.main.async {
            if let view = self.window?.viewWithTag(420){
                view.removeFromSuperview()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString: \(deviceTokenString)")
        UserData.shared.setDeviceToken(deviceToken: deviceTokenString)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo: \(userInfo)")
        //        print("PUSH NOTIFICATION is coming")
        //        let state: UIApplicationState = UIApplication.shared.applicationState
        //        let inBackground = state == .background
        //        // let apsData = userInfo["aps"]! as! [String:Any]
        //        // let alert = apsData["alert"]! as! [String:Any]
        //        //  let body = alert["body"]! as! [String:Any]
        //        if(!inBackground){
        //            print("APP IN FOREGROUND")
        //            //show alert view and the if user tap 'ok' show webview
        //        }
        //        else{
        //            print("APP IS BACKGROUND")
        //            //SHOW WEBVIEW
    }
}
