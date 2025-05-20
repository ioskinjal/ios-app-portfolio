//
//  AppDelegate.swift
//  ThumbPin
//
//  Created by NCT109 on 17/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit
import GooglePlaces
import LGSideMenuController
import GoogleMaps
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMobileAds
import GoogleSignIn
import FacebookCore
import FacebookLogin
import LinkedinSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isLoadingViewVisible:Bool = false
    var sideMenuController:LGSideMenuController!
    var isLoadMyRequestView = ""
    var isCallGetProfileApi = "0"
    
    
    private func configureEnviorment() {
        
        let sideMenuController = LGSideMenuController()
        //sideMenuController.rootViewController = HomeVC.storyboardInstance!
        //sideMenuController.leftViewController = LeftSideMenu.storyboardInstance!
        sideMenuController.leftViewPresentationStyle = .slideAbove
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width * 0.8
        sideMenuController.leftViewBackgroundColor = UIColor.white
        self.sideMenuController = sideMenuController
         GIDSignIn.sharedInstance().clientID = "611381219361-1573v3ah108dr7d0i1ueih8cvo91le58.apps.googleusercontent.com"
    }
    func redirectToVC() {
        if UserData.shared.getUser()?.user_type == "1" {
            
            sideMenuController.rootViewController = HomeCustomerVC.storyboardInstance!
            sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.pushViewController(sideMenuController, animated: false)
        }
        else if UserData.shared.getUser()?.user_type == "2" {
            
            sideMenuController.rootViewController = HomeProfileVC.storyboardInstance!
            sideMenuController.leftViewController = SideMenuVC.storyboardInstance!
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.pushViewController(sideMenuController, animated: false)
        }else{
            window?.rootViewController = StoryBoard.main.instantiateInitialViewController()
            window?.makeKeyAndVisible()
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
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSPlacesClient.provideAPIKey(CredentialConstants.Google.placeKey)
        GMSServices.provideAPIKey(CredentialConstants.Google.mapKey)
        configureEnviorment()
        redirectToVC()
        registerRemoteNotification(application)
        IQKeyboardManager.sharedManager().enable = true
        application.statusBarStyle = .lightContent // .default
        if let isLogin = UserData.shared.getUser()?.user_id {
            if !isLogin.isEmpty {
                getOfflineData()
            }
        }
       // getApplicationData()
        return true
    }
    func getApplicationData() {
        let dictParam = [
            "action": Action.getAppData,
            "lId": UserData.shared.getLanguage
            ] as [String : Any]
        ApiCaller.shared.getApplicationData(param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
             AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print("appdata: \(dict)")
            let appVal = AppData(dic: dict["data"] as? [String : Any] ?? [String : Any]())
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            let appVer = Float(appVersion ?? "0") ?? 0
            let appVerApi = Float(appVal.app_version ) ?? 0
            print(appVer)
            if appVal.forced_update == "y" {
                if appVer == appVerApi {
                    self.shoWMessage(localizedString(key: "New version of app is available.Please update now"))
                }
            }
        }
    }
    func shoWMessage(_ message: String) {
        let alert = UIAlertController(title: localizedString(key: "Alert"), message: message, preferredStyle: .alert)
        //  alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: localizedString(key: "Ok"), style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1024941703"),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func getOfflineData() {
        let dictParam = [
            "action": Action.get_offline_data,
            "user_id": UserData.shared.getUser()!.user_id,
            "user_type": UserData.shared.getUser()!.user_type,
            "page": "1",
            "lId": UserData.shared.getLanguage
            ] as [String : Any]
        ApiCaller.shared.getOfflineData(param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
           // AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print("offline: \(dict)")
            self.stroreJsonFile(dict)
        }
    }
    func stroreJsonFile(_ dict: [String : Any]) {
        clearAllFile()
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        let url = documentsDirectoryPathString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let documentsDirectoryPath = NSURL(string: url)!
        print(documentsDirectoryPathString)
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("offlineData.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath?.absoluteString)!, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }
        
        // creating JSON out of the above array
        var jsonData: Data!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            //print(jsonString)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        // Write that JSON to the file created earlier
        let jsonFilePath1 = documentsDirectoryPath.appendingPathComponent("offlineData.json")
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath1!)
            file.write(jsonData)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("offlineData.json")
        do {
            try fileManager.removeItem(at: diskCacheStorageBaseUrl)
        } catch  { print(error) }
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString: \(deviceTokenString)")
        UserData.shared.setDeviceToken(deviceToken: deviceTokenString)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }

    func callApiLogOut() {
        let dictParam = [
            "action": Action.logout,
            "lId": UserData.shared.getLanguage,
            "device_id": UserData.shared.deviceToken,
            "user_id": UserData.shared.getUser()!.user_id
            ] as [String : Any]
        ApiCaller.shared.logout(vc: self, param: dictParam, failer: { (eroorMsg) in
            print(eroorMsg)
            AppHelper.showAlertMsg(StringConstants.alert, message: eroorMsg)
        }) { (dict) in
            print(dict)
            UserData.shared.logoutUser()
            isSocialLogin = false
            UserData.shared.setGuideValue(language: "1")
            let navigation = self.window?.rootViewController as! UINavigationController
            navigation.popToRootViewController(animated: false)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo: \(userInfo)")
        let apsData = userInfo["aps"]! as! [String:Any]
        let alert = apsData["alert"]! as! [String:Any]
        let body = alert["body"] as? String ?? ""
       // let title = alert["title"] as! String
        if body == "You are successfully logged out" {
            callApiLogOut()
        }
        if application.applicationState == .background || application.applicationState == .inactive {
            //self.notificationManager = NotificationManager(notification: userInfo as NSDictionary)
            NotificationCenter.default.post(name: .pushHandleNotifi, object: userInfo as NSDictionary)
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            
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
