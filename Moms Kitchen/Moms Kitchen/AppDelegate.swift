//
//  AppDelegate.swift
//  Moms Kitchen
//
//  Created by NCrypted on 28/08/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import CoreData
import LGSideMenuController
import IQKeyboardManagerSwift
import GoogleSignIn
import FacebookCore
import UserNotifications
import FacebookLogin
//import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
     var sideMenuController:LGSideMenuController!
    var isLogin:Bool = false
    private func configureEnviorment() {
        
        let sideMenuController = LGSideMenuController()
        
        sideMenuController.leftViewPresentationStyle = .slideBelow
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width/2+50
     //   sideMenuController.leftViewBackgroundColor = UIColor.white
        self.sideMenuController = sideMenuController
        
       GIDSignIn.sharedInstance().clientID = "31512502525-ogrh9s3v05t0pk6vgd87b2tievlmh6oi.apps.googleusercontent.com"
        
        //UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
       // window?.tintColor = Color.green.theam
        
    }
    private func redirectToVC(){
        var user = UserData.shared.getUser()
        var userLoginData: UserLoginData?
         if (user != nil) {
            if UserDefaults.standard.bool(forKey: "isSocial") == false {
            if let userData = UserData.shared.getUserLoginData(){
                Modal.shared.loginAuto(param: ["email": userData.email, "password": userData.password,"token_id":UserData.shared.deviceToken], failer: { (err) in
                    if err != "The Internet connection appears to be offline." || err != "Could not connect to the server."{
                        UserData.shared.logoutUser()
                        let navigation = self.window?.rootViewController as! UINavigationController
                        navigation.popToRootViewController(animated: false)
                    }
                }) { (dic) in
                    print(dic)
                    let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
                    _ = UserData.shared.setUser(dic: data)
                }
            }
            }else if UserDefaults.standard.bool(forKey: "isSocial") == true{
                if let userData = UserData.shared.getUserLoginData(){
                    Modal.shared.signUpAuto(param: ["email": UserData.shared.getUser()!.email_id,"token_id":UserData.shared.deviceToken,
                        "action":"social",
                        "type":UserDefaults.standard.value(forKey: "type")!,
                        "fname":UserData.shared.getUser()!.first_name,
                        "lname":UserData.shared.getUser()!.last_name,
                        "mobile_no":UserData.shared.getUser()!.phone,
                        "imageurl":UserData.shared.getUser()!.user_image
                        ], failer: { (err) in
                        if err != "The Internet connection appears to be offline." || err != "Could not connect to the server."{
                            UserData.shared.logoutUser()
                            let navigation = self.window?.rootViewController as! UINavigationController
                            navigation.popToRootViewController(animated: false)
                        }
                    }) { (dic) in
                        print(dic)
                        let data = ResponseKey.fatchData(res: dic, valueOf: .data).dic
                        _ = UserData.shared.setUser(dic: data)
                    }
                }           }
            user = UserData.shared.getUser()
            self.isLogin = true
            self.sideMenuController.rootViewController = HomeVC.storyboardInstance!
            self.sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.pushViewController(self.sideMenuController, animated: false)
         }else{
            self.window?.rootViewController = StoryBoard.main.instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
        }
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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         registerRemoteNotification(application)
        configureEnviorment()
        redirectToVC()
       // TWTRTwitter.sharedInstance().start(withConsumerKey:"rIsTG5zUY0IdrN89B3zdbFFTR", consumerSecret:"X6FRqiUUqEn65QPNEkvPPH513OzvNG1ubEck7erHLDcMDCW2JM")
        
        // TWTRTwitter.sharedInstance().start(withConsumerKey: "IzwLXakpORUKpuSTS2kdmdJcM", consumerSecret: "akBw17KBpJgQIgKy373oNcBlWwK3fkxgHrbpHBIN7Yk0G6ILUv")
       // sideMenuController.rootViewController = HomeVC.storyboardInstance!
       // sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
      //  let navigation = self.window?.rootViewController as! UINavigationController
     //   navigation.pushViewController(self.sideMenuController, animated: false)
        IQKeyboardManager.sharedManager().enable = true
       return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //return true
    
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
        self.saveContext()
        let loginManager = LoginManager()
        loginManager.logOut()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Moms_Kitchen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
        print("PUSH NOTIFICATION is coming")
        let state: UIApplicationState = UIApplication.shared.applicationState
        let inBackground = state == .background
         let apsData = userInfo["aps"]! as! [String:Any]
         let alert = apsData["alert"]! as! [String:Any]
        let body = alert["body"] as? String ?? ""
        let title = alert["title"] as! String
        if body == "Your mom's kitchen account has been deleted." || body == "Your mom's kitchen account has been deactivated by admin."{
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.popToRootViewController(animated: false)
        }
        print(body)
        print(title)
        if(!inBackground){
            print("APP IN FOREGROUND")
            //show alert view and the if user tap 'ok' show webview
        }
        else{
            print("APP IS BACKGROUND")
            //SHOW WEBVIEW
        }
    }
    
    
}
