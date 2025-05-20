//
//  AppDelegate.swift
//  BookNRide
//
//  Created by NCrypted on 27/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FacebookCore
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import CoreLocation
import Alamofire
import UserNotifications
import Firebase
import FirebaseInstanceID
import FacebookLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    public var currentUser:User?
    public var currentLocaton:CLLocationCoordinate2D?
    public var locationManager:CLLocationManager?
    public var locationTimer:Timer?
    public var notification: NotificationManager?
    
    public var isDriverOnline:Bool = false
    public var appIsStarting:Bool = false
    
    var isFirstTime:Bool = false
    //    var indicator = UIActivityIndicatorView()
    // var loaderView:UIView
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let data = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
        
        
        if data != nil {
            appIsStarting = true
        }
        
        //        LoginButton.superclass()
        // add network reachability observer on app start
        NetworkManager.shared.startNetworkReachabilityObserver()
        
        GIDSignIn.sharedInstance().clientID = ParamConstants.Google.clientID
        // Initialize Maps and Places
        GMSServices.provideAPIKey(ParamConstants.Google.mapKey)
        GMSPlacesClient.provideAPIKey(ParamConstants.Google.placeKey)
        
        
        findMyLocation()
        //splashAnimation()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        
        //        if #available(iOS 10.0, *) {
        //            //iOS 10 or above version
        //            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        //            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
        //                if (granted)
        //                {
        //                    DispatchQueue.main.async {
        //                    UIApplication.shared.registerForRemoteNotifications()
        //                    }
        //                }
        //                else{
        //                    //Do stuff if unsuccessful...
        //                }
        //            })
        //        }
        //        else{
        //            //iOS 9
        //            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
        //            let setting = UIUserNotificationSettings(types: type, categories: nil)
        //            UIApplication.shared.registerUserNotificationSettings(setting)
        //            DispatchQueue.main.async{
        //            UIApplication.shared.registerForRemoteNotifications()
        //            }
        //        }
        //       // FirebaseApp.configure()
        
        //        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //
        //        var configureError: NSError?
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        //        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.appIsStarting = false;
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.appIsStarting = false;
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // self.appIsStarting = true;
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                print("No access")
                self.displayLocationAlert()
            case .authorizedAlways, .authorizedWhenInUse:do {
                print("Access")
                }
            case .notDetermined: break
            }
            
        } else {
            print("Location services are not enabled")
            self.displayLocationAlert()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.appIsStarting = false
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    // Notifications
    //        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //
    //            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    //            print(token)
    //
    //            //CustomerDefaults.saveDeviceToken(token: token)
    //            Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
    //
    //
    //        }
    //
    //        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //            print(error)
    //            CustomerDefaults.saveDeviceToken(token: "123456")
    //
    //
    //        }
    
    // MARK: - Home setup methods
    func findMyLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.requestAlwaysAuthorization()
        // Here we start locating
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        if  locations.count > 0{
            
            currentLocaton = locations.first?.coordinate
            
            
        }
    }
    
    //    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //
    //        if let _ = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String {
    //            return SDKApplicationDelegate.shared.application(application,
    //                                                             open: url,
    //                                                             sourceApplication: sourceApplication,
    //                                                             annotation: annotation)
    //        }
    //
    //        return false
    //    }
    
    
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    //
    //        if (url.scheme?.hasPrefix("fb"))!{
    //
    //          return  SDKApplicationDelegate.shared.application(app)
    //        }
    //        else{
    //                    return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    //
    //        }
    //
    //    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.scheme?.hasPrefix("fb"))!{
            
            return  SDKApplicationDelegate.shared.application(application,
                                                              open: url,
                                                              sourceApplication: sourceApplication,
                                                              annotation: annotation)
        }
        else{
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            
        }
    }
    
    //@available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        if (url.scheme?.hasPrefix("fb"))!{
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        else{
            //        return GIDSignIn.sharedInstance().handle(url,
            //                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            //        }                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any)
            
        }
    }
    
    
    public func rootToHome(){
        
        let leftController = MenuVC(nibName: "MenuVC", bundle: nil)
        let mainViewController = HomeVC(nibName: "HomeVC", bundle: nil)
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        nvc.setNavigationBarHidden(true, animated: false)
        //nvc.setToolbarHidden(true, animated: false)
        
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftController)
        slideMenuController.changeLeftViewWidth((UIScreen.main.bounds.size.width)-70)
        SlideMenuOptions.contentViewScale = 1.0
        
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        
        // Updating Partener Lat long
        self.updatePartnerLatLong()
        
        if ((locationTimer) != nil){
            locationTimer?.invalidate()
            locationTimer = nil
        }
        locationTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updatePartnerLatLong), userInfo: nil, repeats: true)
        RunLoop.current.add(locationTimer!, forMode: RunLoopMode.commonModes)
        
        
    }
    
    //   public func rootToLogin(){
    //
    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //        let nvc: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
    //        nvc.setNavigationBarHidden(true, animated: false)
    //        nvc.setToolbarHidden(true, animated: false)
    //
    //        self.window?.rootViewController = nvc
    //        self.window?.makeKeyAndVisible()
    //    }
    public func rootToLogin(){
        User.setUserLoginStatus(isLogin: false)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        let nvc: UINavigationController = UINavigationController(rootViewController: loginVC)
        nvc.setNavigationBarHidden(true, animated: false)
        // nvc.setToolbarHidden(true, animated: false)
        
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    public func splashAnimation(){
        
        let splashVC = SplashAnimationVC(nibName: "SplashAnimationVC", bundle: nil)
        
        self.window?.rootViewController?.view.addSubview(splashVC.view)
    }
    
    public func removeSplashAndNavigateToRoot(){
        
        let isLoggedin:Bool = User.isUserLoggedIn()
        
        if isLoggedin{
            
            self.currentUser = User.getUser()
            self.autoLogin()
            
        }
        else{
            
            rootToLogin()
        }
        
        
        //        if let nav = self.window?.rootViewController?.navigationController, let loginVC = nav.topViewController as? LoginVC {
        //
        //            if loginVC.childViewControllers.count>0{
        //                DispatchQueue.main.async {
        //                    let forgotPasswordVC =  loginVC.childViewControllers[0]
        //                    forgotPasswordVC.view.removeFromSuperview()
        //                    forgotPasswordVC.removeFromParentViewController()
        //                }
        //            }
        //        }
    }
    
    @objc func updatePartnerLatLong(){
        let isOnline = UserDefaults.standard.bool(forKey: ParamConstants.Defaults.isOnline)
        
        if isOnline == false{
            return
        }
        
        let isUnderRide = UserDefaults.standard.bool(forKey: ParamConstants.Defaults.isUnderRide)
        let isRideAccepted = UserDefaults.standard.bool(forKey: ParamConstants.Defaults.isRideAccepted)
        
        var apiUrl = ""
        let params: Parameters
        
        let rideId = UserDefaults.standard.string(forKey: ParamConstants.Defaults.rideId)
        let valid = Validator()
        
        if isUnderRide && isRideAccepted && rideId != nil && valid.isNotNSNull(object: rideId as AnyObject) && !(rideId?.isEmpty)!{
            
            // Lat Long with ride Id
            apiUrl = URLConstants.Domains.ServiceUrl+URLConstants.Partener.updatePartnerLatLongWithRide
            params = [
                "driverId": currentUser?.uId ?? "",
                "rideId":rideId!,
                "driverLat": describe(currentLocaton?.latitude) ,
                "driverLong": describe(currentLocaton?.longitude) ,
                "lId":Language.getLanguage().id
            ]
        }
        else{
            
            apiUrl = URLConstants.Domains.ServiceUrl+URLConstants.Partener.updatePartnerLatLong
            params = [
                "driverId": currentUser?.uId ?? "",
                "driverLat": describe(currentLocaton?.latitude) ,
                "driverLong": describe(currentLocaton?.longitude) ,
                "lId":Language.getLanguage().id
            ]
            
        }
        
        
        
        // let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: apiUrl, parameters: params, successBlock: { (json, urlResponse) in
            
            if  json != nil {
                print("Request: \(String(describing: urlResponse?.request))")   // original url request
                print("Response: \(String(describing: urlResponse?.response))") // http url response
                print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
                
                let jsonDict = json as NSDictionary?
                
                let status = jsonDict?.object(forKey: "status") as! Bool
                _ = jsonDict?.object(forKey: "message") as? String
                
                if status == true{
                    
                    
                }
                else{
                    DispatchQueue.main.async {
                        
                        // alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                        //self.rootToLogin()
                        
                    }
                }
            }
            
            
        }) { (error) in
            DispatchQueue.main.async {
                //self.rootToLogin()
                
                // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                // self.window?.rootViewController?.navigationController?.present(oopsVC, animated: true, completion: nil)
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
        
        
    }
    
    func autoLogin(){
    
        //showLoader(title: "")
        
        let params: Parameters = [
            "email": currentUser?.email ?? "",
            "password": currentUser?.password ?? "",
            "lId":Language.getLanguage().id
            ]
        
        // let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.User.login, parameters: params, successBlock: { (json, urlResponse) in
            
            // self.hideLoader()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            _ = jsonDict?.object(forKey: "message") as? String
            
            if status == true{
                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print("Items \(dataAns)")
                
                let person = User.initWithResponse(dictionary: userDict as? [String : Any])
                
                if person.isActive == "y"{
                    
                    self.registerDeviceToken()
                    
                    DispatchQueue.main.async {
                        
                        self.isDriverOnline = true
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        User.saveUser(loggedUser: person)
                        User.setUserLoginStatus(isLogin: true)
                        self.currentUser = person
                        
                        appDelegate.rootToHome()
                        
                    }
                }
                else{
                    DispatchQueue.main.async {
                        // alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                        self.rootToLogin()
                        
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    // alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                    self.rootToLogin()
                    
                }
            }
            
            
        }) { (error) in
            DispatchQueue.main.async {
                self.rootToLogin()
                
                // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                // self.window?.rootViewController?.navigationController?.present(oopsVC, animated: true, completion: nil)
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
        
        
    }
    
    public func registerDeviceToken(){
        
        let params: Parameters = [
            "deviceId": CustomerDefaults.getDeviceToken() ,
            "userId": currentUser?.uId ?? "",
            "userType": "d",
            "deviceType":"i",
            "lId":Language.getLanguage().id
            ]
        
        //        showLoader(title: "")
        
        //        let alert = Alert()
        
        WSManager.getResponseFrom(serviceUrl: URLConstants.Domains.ServiceUrl+URLConstants.Device.registerDevice, parameters: params, successBlock: { (json, urlResponse) in
            
            // self.stopIndicator()
            
            print("Request: \(String(describing: urlResponse?.request))")   // original url request
            print("Response: \(String(describing: urlResponse?.response))") // http url response
            print("Result: \(String(describing: urlResponse?.result))")                         // response serialization result
            
            let jsonDict = json as NSDictionary?
            
            let status = jsonDict?.object(forKey: "status") as! Bool
            let message = jsonDict?.object(forKey: "message") as! String
            
            if status == true{
                //                let dataAns = (jsonDict!["dataAns"]! as! NSArray).mutableCopy() as! NSMutableArray
                //                let userDict = (dataAns.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                //                print("Items \(dataAns)")
                
                
            }
            else{
                DispatchQueue.main.async {
                    
                    // alert.showAlert(titleStr: "Alert", messageStr: message, buttonTitleStr: "OK")
                }
            }
            
            
        }) { (error) in
            DispatchQueue.main.async {
                
                // let oopsVC = OopsVC(nibName: "OopsVC", bundle: nil)
                //self.window?.rootViewController?.navigationController?.present(oopsVC, animated: true, completion: nil)
                //alert.showAlert(titleStr: "Alert", messageStr: error.localizedDescription, buttonTitleStr: "OK")
            }
        }
    }
    
    public func showLoader(title:String){
        
        DispatchQueue.main.async {

            var loaderView = self.window?.viewWithTag(99)
            
            if loaderView != nil{
                self.hideLoader()
            }
            
            loaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: (self.window?.bounds.width)!, height: (self.window?.bounds.height)!))
            loaderView?.backgroundColor = UIColor.clear
            loaderView?.tag = 99
            
            let alphaView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: (loaderView?.frame.size.width)!, height:  (loaderView?.frame.size.height)!))
            alphaView.backgroundColor = UIColor.black
            alphaView.alpha = 0.7
            
            
            let indicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
            indicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            indicator.center = alphaView.center
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            
            let lblTitle:UILabel = UILabel.init(frame: CGRect(x: 0, y: alphaView.center.y+20, width: (loaderView?.frame.size.width)!, height: 21))
            lblTitle.text = title
            lblTitle.textAlignment = .center
            lblTitle.textColor = UIColor.white
            lblTitle.font = UIFont.init(name: "Roboto-Regular", size: 14.0)
            
            alphaView.addSubview(indicator)
            alphaView.addSubview(lblTitle)
            loaderView?.addSubview(alphaView)
            self.window?.addSubview(loaderView!)
            
        }
    }
    
    public func hideLoader(){
        
        DispatchQueue.main.async {
            
            if let view = self.window?.viewWithTag(99){
                
                view.removeFromSuperview()
            }
        }
    }
    
    func displayLocationAlert(){
        
        let alert = Alert()
        
        alert.showAlertWithLeftAndRightCompletionHandler(titleStr: "", messageStr: appConts.const.LBL_LOCATION_SERVICE_DISABLED, leftButtonTitle: appConts.const.bTN_OK, rightButtonTitle: appConts.const.sETTING, leftCompletionBlock: {
            
        }) {
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            
        }
    }
    
}

extension AppDelegate:UNUserNotificationCenterDelegate,MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        CustomerDefaults.saveDeviceToken(token: fcmToken)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print full message.
        print(userInfo)
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        self.ProcessNotification(userInfo: userInfo as NSDictionary)
        
        // Print message ID.
        //if let messageID = userInfo[gcmMessageIDKey] {
        //     print("Message ID: \(messageID)")
        //}
        
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print("Remote data printing for firebase notificaiton",remoteMessage.appData)
        
        let d : [String : Any] = remoteMessage.appData["notification"] as! [String : Any]
        let body : String = d["body"] as! String
        print(body)
        
        self.ProcessNotification(userInfo: remoteMessage.appData as NSDictionary)
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        print(userInfo)
        
        let state: UIApplicationState = application.applicationState
        
        if (state == .background || (state == .inactive && !self.appIsStarting)){
            
            // perform the background fetch and
            // call completion handler
            self.ProcessNotification(userInfo: userInfo as NSDictionary)
            self.checkDeepLink()
            
        }
        else if (state == .inactive && self.appIsStarting){
            
            // user tapped notification
            completionHandler(.newData)
            self.ProcessNotification(userInfo: userInfo as NSDictionary)
            
        }
        else{
            // app is active
            completionHandler(.noData);
            self.ProcessNotification(userInfo: userInfo as NSDictionary)
            self.checkDeepLink()
        }
        
        
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        // if let messageID = userInfo[gcmMessageIDKey] {
        //     print("Message ID: \(messageID)")
        // }
        
        // Print full message.
        
    }
    
    func ProcessNotification(userInfo:NSDictionary){
        self.notification = NotificationManager()
        self.notification = NotificationManager.processDeepLink(notification: userInfo as NSDictionary)
        
    }
    
    func checkDeepLink(){
        
        if User.isUserLoggedIn(){
            
            DispatchQueue.main.async {
                
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                let navController = appDelegate.window!.rootViewController?.slideMenuController()?.mainViewController as! UINavigationController
                let alert = Alert()
                self.hideLoader()
                
                if self.notification != nil {
                    if self.notification?.deeplinkType == DeepLinkType.data{
                        switch self.notification?.actionType {
                            
                        case .rideAcceptOrReject?:do {
                            if !(navController.topViewController?.isKind(of: RideAcceptRejectVC.self))! {
                                
                                // Ride Complted - Navigating to Fare Summary
                                let acceptRejectVC = RideAcceptRejectVC(nibName: "RideAcceptRejectVC", bundle: nil)
                                
                                if (!(self.notification?.rideId?.isEmpty)! && self.notification?.rideId != nil)  {
                                    acceptRejectVC.rideId = (self.notification?.rideId)!
                                }
                                if (!(self.notification?.carTypeId?.isEmpty)! && self.notification?.carTypeId != nil)  {
                                    acceptRejectVC.carId = (self.notification?.carTypeId)!
                                }
                                //                            if (!(self.notification?.isUrgent?.isEmpty)! && self.notification?.isUrgent != nil)  {
                                //                                acceptRejectVC.isUrgent = (self.notification?.isUrgent)!
                                //                            }
                                if (!(self.notification?.customerId?.isEmpty)! && self.notification?.customerId != nil)  {
                                    acceptRejectVC.customerId = (self.notification?.customerId)!
                                }
                                if (!(self.notification?.pickUpLocation?.isEmpty)! && self.notification?.pickUpLocation != nil)  {
                                    acceptRejectVC.pickUpLocation = (self.notification?.pickUpLocation)!
                                }
                                if (!(self.notification?.pickUpLat?.isEmpty)! && self.notification?.pickUpLat != nil)  {
                                    acceptRejectVC.pickUpLat = (self.notification?.pickUpLat)!
                                }
                                if (!(self.notification?.pickUpLong?.isEmpty)! && self.notification?.pickUpLong != nil)  {
                                    acceptRejectVC.pickUpLong = (self.notification?.pickUpLong)!
                                }
                                if (!(self.notification?.dropOffLocation?.isEmpty)! && self.notification?.dropOffLocation != nil)  {
                                    acceptRejectVC.dropOffLocation = (self.notification?.dropOffLocation)!
                                }
                                if (!(self.notification?.dropOffLat?.isEmpty)! && self.notification?.dropOffLat != nil)  {
                                    acceptRejectVC.dropOffLat = (self.notification?.dropOffLat)!
                                }
                                if (!(self.notification?.dropOffLong?.isEmpty)! && self.notification?.dropOffLong != nil)  {
                                    acceptRejectVC.dropOffLong = (self.notification?.dropOffLong)!
                                }
                                if (!(self.notification?.timerLimit?.isEmpty)! && self.notification?.timerLimit != nil)  {
                                    acceptRejectVC.timerLimit = (self.notification?.timerLimit)!
                                }
                                //                            if (!(self.notification?.dropOffLong?.isEmpty)! && self.notification?.tripDateTime != nil)  {
                                //                                acceptRejectVC.tripDateTime = (self.notification?.tripDateTime)!
                                //                            }
                                navController.pushViewController(acceptRejectVC, animated: true)
                            }
                            
                            }
                        case .cancelRide?:do{
                            // Ride Cancelled - Navigating to Home screen
                            alert.showAlertWithCompletionHandler(titleStr: "", messageStr: appConts.const.rIDE_CANCELLED_SUCCESSFULLY, buttonTitleStr: appConts.const.bTN_OK, completionBlock: {
                                UserDefaults.standard.set("", forKey: ParamConstants.Defaults.rideId)
                                UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isRideAccepted)
                                UserDefaults.standard.set(false, forKey: ParamConstants.Defaults.isUnderRide)
                                UserDefaults.standard.synchronize()
                                navController.popToRootViewController(animated: true)
                            })
                            }
                        case .startUpdateLatLongWithRideId?:do{
                            // Removed
                            
                            if self.notification != nil {
                           // DispatchQueue.main.async {
                                
                                if ((self.notification?.rideId) != nil) {
                                UserDefaults.standard.set(self.notification?.rideId, forKey: ParamConstants.Defaults.rideId)
                                UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isRideAccepted)
                                UserDefaults.standard.set(true, forKey: ParamConstants.Defaults.isUnderRide)
                                UserDefaults.standard.synchronize()
                                
                                self.updatePartnerLatLong()
                            }
                            }
                            }
                            
                        default:
                            print(self.notification?.actionType.rawValue ?? "")
                        }
                    }
                        
                    else if self.notification?.deeplinkType == DeepLinkType.notification{
                        self.hideLoader()
                        alert.showAlert(titleStr: "", messageStr: (self.notification?.message)!, buttonTitleStr: appConts.const.bTN_OK)
                        
                    }
                    self.notification = nil
                }
            }
        }
    }
    
    // MARK: - Navigaiton methods
    //    func navigateToNewRideRequest(){
    //
    //        let rideAcceptVc = RideAcceptRejectVC(nibName: "RideAcceptRejectVC", bundle: nil)
    //        self.navigationController?.pushViewController(rideAcceptVc, animated: true)
    //    }
}


