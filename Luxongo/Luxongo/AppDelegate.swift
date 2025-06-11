//
//  AppDelegate.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootNavigation: UINavigationController?{
        return self.window?.rootViewController as? UINavigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserData.shared.setLanguageDirestion()
        
        registerRemoteNotification(application)
        configureSocialData(application, launchOptions)
        IQKeyboardManager.shared.enable = true
        window?.setTheamColor(color: Color.Orange.theme)
        AppLoader.activityBackgroundColor = UIColor.clear
        AppLoader.activityColor = Color.Orange.theme
        
//        self.window?.rootViewController = StoryBoard.main.instantiateInitialViewController()
//        self.window?.makeKeyAndVisible()
        
        rootNavigation?.pushViewController(SplashScreenVC.storyboardInstance, animated: false)
        
        return true
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

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = Settings.appID //FacebookAppID
        let facebookHandler = (url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" ? ApplicationDelegate.shared.application(app, open: url, options: options) : false)
        if(facebookHandler) {
            return facebookHandler
        }
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
    }
}


//MARK: Custom functions
extension AppDelegate{
    private func configureSocialData(_ application: UIApplication,_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = Google.cliedtId
        GMSPlacesClient.provideAPIKey(Google.palceId)
        GMSServices.provideAPIKey(Google.mapsId)
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
    
}
/*
extension AppDelegate {
    // MARK: - Loader
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
*/

// MARK: - Loader
extension AppDelegate {
    func startLoader(loaderText:String = "", isDisableUI : Bool = true) {
        DispatchQueue.main.async {
            AppLoader.showLoading(loaderText, disableUI: isDisableUI)
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            AppLoader.hide()
        }
    }
}

//MARK: Remotenotification
import UserNotifications
extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString: \(deviceTokenString)")
        //Set device token
        UserData.shared.setDeviceToken(deviceTkn: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo: \(userInfo)")
        print("PUSH NOTIFICATION is coming")
        let state: UIApplication.State = UIApplication.shared.applicationState
        print("state:\(state)")
    }
}

