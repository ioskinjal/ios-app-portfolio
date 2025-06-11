//
//  AppDelegate.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 21/04/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Firebase
import FirebaseCore
import Adjust
import MarketingCloudSDK

var M2_isUserLogin = false
var isUserChangedPasswordInWebsite = false
var adjustDeviceId = ""
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,AdjustDelegate {
    
    
    let appID = "d0297fdf-a284-4578-9afd-07d6ae6bc312"
    let accessToken = "EgdZAF3G1taLRRaonzNV3eoX"
    let appEndpoint = "https://mcfvtclspl1gysdklj1vmd0n48r4.device.marketingcloudapis.com/"
    let mid = "500008980"
    var currentNavCtrl:UINavigationController?
    
    @discardableResult
    func configureMarketingCloudSDK() -> Bool {
        // Use the builder method to configure the SDK for usage. This gives you the maximum flexibility in SDK configuration.
        // The builder lets you configure the SDK parameters at runtime.
        let builder = MarketingCloudSDKConfigBuilder()
            .sfmc_setApplicationId(appID)
            .sfmc_setAccessToken(accessToken)
            .sfmc_setMarketingCloudServerUrl(appEndpoint)
            .sfmc_setMid(mid)
            .sfmc_setInboxEnabled(true)
            .sfmc_setLocationEnabled(false)
            .sfmc_setAnalyticsEnabled(false)
            .sfmc_build()!
        
        var success = false
        
        // Once you've created the builder, pass it to the sfmc_configure method.
        do {
            try MarketingCloudSDK.sharedInstance().sfmc_configure(with:builder)
            success = true
        } catch let error as NSError {
            // Errors returned from configuration will be in the NSError parameter and can be used to determine
            // if you've implemented the SDK correctly.
            
            let configErrorString = String(format: "MarketingCloudSDK sfmc_configure failed with error = %@", error)
            print(configErrorString)
            
            DispatchQueue.main.async {
                let configError = "confirg_error".localized
                let alert = UIAlertController(title: configError, message: configErrorString, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
                
                self.window?.topMostViewController()?.present(alert, animated: true)
            }
        }
        
        if success == true {
            
            #if DEBUG
            MarketingCloudSDK.sharedInstance().sfmc_setDebugLoggingEnabled(true)
            #endif
            
            MarketingCloudSDK.sharedInstance().sfmc_setURLHandlingDelegate(self)
            
            MarketingCloudSDK.sharedInstance().sfmc_setEventDelegate(self)
            
            MarketingCloudSDK.sharedInstance().sfmc_startWatchingLocation()
            //print("Nitikesh dev id: " + MarketingCloudSDK.sharedInstance().sfmc_deviceIdentifier()!)
            adjustDeviceId = MarketingCloudSDK.sharedInstance().sfmc_deviceIdentifier()!
            //print("Nitikesh dev id: " + MarketingCloudSDK.sharedInstance().sfmc_deviceToken()!)
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().delegate = self
                
                // Request authorization from the user for push notification alerts.
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                    if error == nil {
                        if granted == true {
                        }
                    }
                })
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return success
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let appToken = CommonUsed.globalUsed.adjustToken
        var adjustConfig = ADJConfig.init(
            appToken: appToken,
            environment: ADJEnvironmentSandbox
        )
        if(CommonUsed.globalUsed.environment == "production"){
            adjustConfig = ADJConfig.init(
                appToken: appToken,
                environment: ADJEnvironmentProduction
            )
        }
        else{
            adjustConfig = ADJConfig.init(
                appToken: appToken,
                environment: ADJEnvironmentSandbox
            )
        }
        // Change the log level.
        adjustConfig?.logLevel = ADJLogLevelVerbose
        // Set delegate object.
        adjustConfig?.delegate = self
        Adjust.appDidLaunch(adjustConfig)
        
        UserDefaults.standard.setValue(false, forKey: "isPLPLoadedForDeepLinking")
        UserDefaults.standard.setValue(false, forKey: "isPDPLoadedForDeepLinking")
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        // LSLocationManager.shared.configLocationManager()
        //Default Cache Schenarios
        UserDefaults.standard.set(true, forKey: "offerNotification")
        UserDefaults.standard.set(true, forKey: "isLoadingFirstTime")
        //If no Toogle selected
        if( UserDefaults.standard.value(forKey: string.userLanguage) == nil){
            let languageStr  = Locale.current.languageCode
            
            /*
             if languageStr != UserDefaults.standard.setValue(string.en, forKey: string.language)as? String{
             isLanguageCodeChanged = true
             }
             */
            
            if languageStr == string.en {
                UserDefaults.standard.setValue(string.English, forKey: string.userLanguage)
                UserDefaults.standard.setValue(string.en, forKey: string.language)
            }
            else
            {
                UserDefaults.standard.setValue(string.Arabic, forKey: string.userLanguage)
                UserDefaults.standard.setValue(string.ar, forKey: string.language)
            }
        }
        isLanguageCodeChanged = true
        //        else{
        //            let languageStr  = Locale.current.languageCode
        //            if languageStr != UserDefaults.standard.value(forKey: string.language) as? String{
        //                isLanguageCodeChanged = true
        //            }
        //        }
        
        //Analytics: Set user properties
        let selectedCountryName = UserDefaults.standard.value(forKey: "countryName")
        let selectedLanguage = UserDefaults.standard.value(forKey: string.userLanguage)
        Analytics.setUserProperty("\(selectedCountryName ?? "")", forName: "Country")
        Analytics.setUserProperty("\(selectedLanguage ?? "")", forName: "Language")
        
        let userToken = UserDefaults.standard.value(forKey: string.userToken) as? String
        let storeCode = UserDefaults.standard.value(forKey: string.storecode) as? String
        if userToken == nil {
            //User is Not Loggedin case Handle
            M2_isUserLogin = false
            userLoginStatus(status: false)
            getQuoteId()
            
            
            if  (UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") != nil){
                guest_carts__item_quote_id = UserDefaults.standard.value(forKey: "guest_carts__item_quote_id") as! String
            }
            
        }else{
            M2_isUserLogin = true
            userLoginStatus(status: true)
            UserDefaults.standard.set(nil, forKey: "guest_carts__item_quote_id")
        }
        
        //Nitikes to look into this
        
        if userToken == nil && storeCode == nil || UserDefaults.standard.value(forKey: string.category) == nil {
            
            callApi()
        }
        else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! UITabBarController
            // nextViewController.tabBar.isHidden = true
            // nextViewController.tabBar.frame.size.height = 85
            
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        
        getDesigner()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 30

        UserDefaults.standard.set(nil, forKey: "colorNm")
        UserDefaults.standard.set(nil, forKey: "categoryNm")
        UserDefaults.standard.set(nil, forKey: "designNm")
        UserDefaults.standard.set(nil, forKey: "genderNm")
        UserDefaults.standard.set(nil, forKey: "sizeNm")
        UserDefaults.standard.set(nil, forKey: "sortby")
        UserDefaults.standard.setValue(0, forKey: "filtercount")
        UserDefaults.standard.set(0, forKey: string.notificationItemCount)
        NotificationCenter.default.post(name: Notification.Name(notificationName.CHANGE_NOTIFICATION_COUNT), object: 0)
        
        return self.configureMarketingCloudSDK()
    }
    
    func getDesigner() {
        var dictMatch = [String:Any]()
        let dictParam = ["attribute_code":"manufacturer"]
        dictMatch["match"] = dictParam
        var arrMust = [[String:Any]]()
        arrMust = [dictMatch]
        let dictMust = ["must":arrMust]
        let dictBool = ["bool":dictMust]
        
        let param = ["_source":"options",
                     "query":dictBool] as [String : Any]
        let storeCode = CommonUsed.globalUsed.storeCodePrefix
            + "_\(UserDefaults.standard.value(forKey: "storecode") ?? "ae")_\(UserDefaults.standard.value(forKey: "language") ?? "en")/"
        
        
        let url = CommonUsed.globalUsed.main + "/" + storeCode + CommonUsed.globalUsed.attributeSearch
        ApiManager.apiPost(url: url, params: param) { (response, error) in
            
            if let error = error{
                print(error)
                if error.localizedDescription.contains(s: "offline"){
                    
                }
                return
            }
            if response != nil{
                var dict = [String:Any]()
                dict["data"] = response?.dictionaryObject
                
                if response != nil{
                    var dict = [String:Any]()
                    dict["data"] = response?.dictionaryObject
                    
                    let user = UserData.shared.getDesignData()
                    if  user == nil{
                        _ =  UserData.shared.setDesignData(dic: dict)
                        
                        
                    }
                }
            }
        }
        
    }
    
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        if(MarketingCloudSDK.sharedInstance().sfmc_isReady() == false)
        {
            self.configureMarketingCloudSDK()
        }
    }
    
    func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        forRemoteNotification notification: [AnyHashable : Any],
        completionHandler: @escaping () -> Void
    ) {
        print("Received push notification: \(notification), identifier: \(identifier ?? "")") // iOS 8
        completionHandler()
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification notification: [AnyHashable : Any]
    ) {
        print("Received push notification: \(notification)") // iOS 7 and earlier
    }
    
    
    // MARK: - Adjust delegate
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        NSLog("Attribution callback called!")
        NSLog("Attribution: %@", attribution ?? "")
    }
    
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
        NSLog("Event success callback called!")
        NSLog("Event success data: %@", eventSuccessResponseData ?? "")
    }
    
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
        NSLog("Event failure callback called!")
        NSLog("Event failure data: %@", eventFailureResponseData ?? "")
    }
    
    func adjustSessionTrackingSucceeded(_ sessionSuccessResponseData: ADJSessionSuccess?) {
        NSLog("Session success callback called!")
        NSLog("Session success data: %@", sessionSuccessResponseData ?? "")
    }
    
    func adjustSessionTrackingFailed(_ sessionFailureResponseData: ADJSessionFailure?) {
        NSLog("Session failure callback called!");
        NSLog("Session failure data: %@", sessionFailureResponseData ?? "")
    }
    
    func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
        NSLog("Deferred deep link callback called!")
        NSLog("Deferred deep link URL: %@", deeplink?.absoluteString ?? "")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("terminated")
        UserDefaults.standard.set(false, forKey: "isLoadingFirstTime")
    }
    
    
    func callApi(){
        let strCode = "\(UserDefaults.standard.value(forKey: string.language) ?? string.en)"
        let url = CommonUsed.globalUsed.configEndPoint   + strCode + CommonUsed.globalUsed.onBoarding
        ApiManager.apiGet(url: url, params: [:]) { (response, error) in
            
            if let error = error{
                print(error)
                return
            }
            if response != nil{
                var dict = [String:Any]()
                dict[string.data] = response?.dictionaryObject
                let user = UserData.shared.getData()
                _ =  UserData.shared.setData(dic: dict)
                if UserDefaults.standard.value(forKey: string.category) == nil && UserDefaults.standard.value(forKey: string.storecode) != nil || UserDefaults.standard.value(forKey: string.storecode) == nil {
                    let viewController = SkipIntroViewController.storyboardInstance!
                    
                    let nav = UINavigationController()
                    nav.setNavigationBarHidden(true, animated: true)
                    nav.pushViewController(viewController, animated: true)
                    self.window?.rootViewController = nav
                    self.window?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    func getQuoteId(){
        if !M2_isUserLogin && (UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == "" ||  UserDefaults.standard.string(forKey: "guest_carts__item_quote_id") == nil) {
            ApiManager.getQuoteID(params: [:], success: { (resp) in
                
                UserDefaults.standard.set(resp, forKey: "guest_carts__item_quote_id")
                UserDefaults.standard.synchronize()
                userLoginStatus(status: false)
            })  {
            }
        }
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
        
        MarketingCloudSDK.sharedInstance().sfmc_setDeviceToken(deviceToken)
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        
        let token = tokenParts.joined()
        
        print("Device Token: \(token)") }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("devie registration fail: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationUserInfo(userInfo)
        completionHandler(.newData)
    }
    
}


extension AppDelegate {
    
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

extension AppDelegate: MarketingCloudSDKURLHandlingDelegate {
    
    func sfmc_handle(_ url: URL, type: String) {
        UIApplication.shared.open(url, options: [:],
                                  completionHandler: {
                                    (success) in
                                    print("Open \(url): \(success)")
        })
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(response.notification.request)
        
        print("Coming from Push Notification ")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Coming from Push Notification ")
        completionHandler(.alert)
    }
}

extension UIWindow {
    
    func topMostViewController() -> UIViewController? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        return topViewController(for: rootViewController)
    }
    
    func topViewController(for rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        guard let presentedViewController = rootViewController.presentedViewController else {
            return rootViewController
        }
        switch presentedViewController {
        case is UINavigationController:
            let navigationController = presentedViewController as! UINavigationController
            return topViewController(for: navigationController.viewControllers.last)
        case is UITabBarController:
            let tabBarController = presentedViewController as! UITabBarController
            return topViewController(for: tabBarController.selectedViewController)
        default:
            return topViewController(for: presentedViewController)
        }
    }
    
}


extension AppDelegate: MarketingCloudSDKEventDelegate {

    func sfmc_shouldShow(inAppMessage message: [AnyHashable : Any]) -> Bool {
        print("message should show")
        return true
    }

    func sfmc_didShow(inAppMessage message: [AnyHashable : Any]) {
        // message shown
        print("message was shown")
    }
    
    func sfmc_didClose(inAppMessage message: [AnyHashable : Any]) {
        // message closed
        print("message was closed")
    }
}
