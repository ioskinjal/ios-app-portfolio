//
//  AppDelegate.swift
//  Explore Local
//
//  Created by NCrypted on 04/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import CoreData
import LGSideMenuController
import GoogleSignIn
import FacebookCore
import FacebookLogin
import IQKeyboardManagerSwift
import GooglePlaces
import Stripe
import LinkedinSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sideMenuController:LGSideMenuController!
    var isLogin:Bool = false
    private func configureEnviorment() {
        
        let sideMenuController = LGSideMenuController()
        
        sideMenuController.leftViewPresentationStyle = .scaleFromBig;
       sideMenuController.leftViewWidth = UIScreen.main.bounds.width*0.6;
        //   sideMenuController.leftViewBackgroundColor = UIColor.white
        self.sideMenuController = sideMenuController
        sideMenuController.leftViewBackgroundImage = #imageLiteral(resourceName: "Bgimage")
         GMSPlacesClient.provideAPIKey("AIzaSyAWiP7i8NyBrWIGuDBDop0G4veZ3ZI7q9w")
        GIDSignIn.sharedInstance().clientID = "152015392056-g4tjnop8dpinnbvmir4dk3b0a9docc7j.apps.googleusercontent.com"

    }
    
    private func redirectToVC(){
     //   let user = UserData.shared.getUser()
        //if (user != nil) {
            self.isLogin = true
            self.sideMenuController.rootViewController = HomeVC.storyboardInstance!
            let leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MSSideNavigationVC") as! MSSideNavigationVC
            self.sideMenuController.leftViewController = leftViewController
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.pushViewController(self.sideMenuController, animated: false)
            self.window?.makeKeyAndVisible()
       // }else{
//            self.window?.rootViewController = StoryBoard.main.instantiateInitialViewController()
//            self.window?.makeKeyAndVisible()
       // }
    }
      
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureEnviorment()
        redirectToVC()
        IAPHelper.store.initializeProduct()
        IQKeyboardManager.sharedManager().enable = true
         registerRemoteNotification(application)
        Stripe.setDefaultPublishableKey("pk_live_dEtBGjUSxWhhgTxLYvV5mrHe008hGwi8iv")
         STPPaymentConfiguration.shared().publishableKey = "pk_live_dEtBGjUSxWhhgTxLYvV5mrHe008hGwi8iv"
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
       
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
        // Saves changes in the application's managed object context before the application terminates.
        let loginManager = LoginManager()
        loginManager.logOut()
    }

   
   
}

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
            let iV = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
//MARK: FB & Google Login
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleAuthentication = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        let facebookAuthentication =  SDKApplicationDelegate.shared.application(app, open: url)
        //let twitterAuthentication = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return facebookAuthentication || googleAuthentication //twitterAuthentication || googleAuthentication
        
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
}
}


//MARK: Remotenotification
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
    
    

