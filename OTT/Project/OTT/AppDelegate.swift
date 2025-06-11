//
//  AppDelegate.swift
//  MyStore
//
//  Created by Mohan Agadkar on 22/05/17.
//  Copyright © 2015 com.cv. All rights reserved.
//

import UIKit
import OTTSdk
//import Fabric
import Crashlytics
//import Localytics
import UserNotifications
import UserNotificationsUI
import GoogleCast
import SDWebImage
//import FBSDKCoreKits
import GoogleSignIn
//import GoogleToolboxForMac //#warning : ios 13
//import GTMOAuth2
import Firebase
import FirebaseMessaging
import FirebaseCore
import CleverTapSDK
import AVKit
import SwiftKeychainWrapper
import CoreData
import AdSupport
import AppTrackingTransparency

//import logAnalytics

var playerVC: PlayerViewController?
var otherPlayerVC: PlayerViewController?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    public var shouldRotate = false
    var showVideoAds:Bool = false
    var showBannerAds:Bool = false
    var showInterstitialAds:Bool = false
    var showNativeAds:Bool = false
    var defaultBannerAdTag:String = ""
    var defaultPlayerBannerAdTag:String = ""
    var defaultNativeAdTag:String = ""
    
    var cancelOTPFromPlayer:Bool = false
    let genericAlertStr = ""
    var deepLinkingString = ""
    var fromLaunchApp = false
    var openSharedVideo = false
    var sharedAbsoluteString = ""
    var presentLaunchURL = ""
    var notificationCA = ""
    var notificationCR = ""
    var window: UIWindow?
    var selectedLang = ""
    var presentTargetedMenu = ""
    var callingNumber = ""
    var isCallSupported = false
    var configs: Config?
    var iosAllowSignup = false
    var supportChromecast = false
    var isPlayerPage = false
    var isDetailsPage = false
    var isTabsPage = false
    var detailsTabMenuIndex = 0
    var pageNumber = 0
    var pageSize = 20
    var contentViewController:ContentViewController?
    var detailsViewController:DetailsViewController?
    var detailsViewController_old: DetailsViewController_Old?
    let availableCardTypeArr = ["pinup_poster","icon_poster","content_poster","roller_poster","info_poster","box_poster","band_poster","sheet_poster"]
    var pushNotificationPayLoad = [AnyHashable:Any]()
    var taggedScreen = String()
    static var originalAppDelegate:AppDelegate!
    var tvGuideTabSelected = 0
    var tvGuideDataNAIndex = 0
    var tvGuideSelectedTabDate:Date!
    var socialMediaLoginStr = ""
    var socialMediaLoginFrom = ""
    var isDataAvailableForSelectedTabDate:Bool = false
    var isTVGuideFirstTimeLoading:Bool = true
    var isScrollToTop:Bool = false
    var presentShowingDateTab:TVGuideTab!
    var alreadyLoadedTabDataArr = [TVGuideTab]()
    var tvGuideFilterString:String?
    var liveCouchScreenCell:UICollectionViewCell?
    var isFacebookLoginSupported:Bool = false
    var supportGoogleLogin:Bool = false
    var supportAppleLogin:Bool = false
    var getFullTVGuideData:Bool = false
    var userTimeZone:TimeZone!
    var userStateChanged:Bool = false
    var isOTPSupported = false
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    var buttonRecord = ""
    var buttonStopRecord = ""
    var recordStatusRecorded = ""
    var recordStatusRecording = ""
    var recordStatusScheduled = ""
    var isListPageReloadRequired:Bool = false
    var isContentPageHomeReloadRequired:Bool = false
    var isContentPageLiveReloadRequired:Bool = false
    var enableNdvr:Bool = false
    var isChangedToLandscapeMode:Bool = false
    var isFromPlayerPage:Bool = false
    var resendOtpLimit = 0
    var enableOTPBtnTime = 0
    var mobileRegExp = ""
    var headerEnrichmentNum = ""
    var supportLocalytics:Bool = false
    var supportFireBase:Bool = false
    var supportCleverTap:Bool = false
    var country = ""
    var city = ""
    var trueip = "-1"
    var latitude = "-1"
    var longitude = "-1"
    var sourceScreen = ""
    var aboutUsPageUrl = ""
    var contactUsPageUrl = ""
    var faqPageUrl = ""
    var privacyPolicyPageUrl = ""
    var termsConditionsPageUrl = ""
    var resSErrorNeedPaymentIos = ""
    var resSErrorNotLoggedInIos = ""
    var signinTitle = ""
    var signupTitle = ""
    var staticPagePaths = ""
    var statusBarShouldBeHidden = false
    var isPartialViewLoaded = false
    var timezoneString = TimeZone.current.identifier
    var nextVideoTimer:Timer? = nil
    var keyBoardShown:Bool = false
    
    var device_Ifa = ""
    var device_Ifv = ""
    var device_atts = -1
    var userAgent = ""
    
    var tvshowPlayerRecommendationText = ""
    var tvshowDetailsRecommendationText = ""
    var movieDetailsRecommendationText = ""
    var moviePlayerRecommendationText = ""
    var channelRecommendationText = ""
    var favouritesTargetPath = ""
    var myPurchasesTargetPath = ""
    var supportButton : UIButton = UIButton.init(type: .custom)
    var supportButtonBottomConstraint: NSLayoutConstraint?
    var isDirectDownloadsPage:Bool = false
    var offlineDownloadExpiryDays = -1
    var offlineDownloadsLimit = -1
    var offlineContentExpiryTagInHours = -1
    var showViewAll = ">"
    var parentalControlPinLength = 0
    var parentalControlPopupMessage = ""
    var siteURL = ""
    static var otpAuthenticationFields : FieldsModel!
    var uuidString = ""
    let customKeychainWrapperInstance = KeychainWrapper(serviceName:appContants.appName.rawValue+"ottservice", accessGroup:  nil)
    
    var isDobPopup_ContentPage = false
    var dynamicColorCodes = [String:Any]()
    
    lazy var activityIndicator : CustomActivityIndicatorView = {
        if UIScreen.main.screenType == .iPhone5
        {
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }
        else if UIScreen.main.screenType == .iPhone6
        {
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }else{
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }
        
    }()
    lazy var activityIndicatorPlayer : CustomActivityIndicatorView = {
        if UIScreen.main.screenType == .iPhone5
        {
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }
        else if UIScreen.main.screenType == .iPhone6
        {
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }else{
            let image : UIImage = #imageLiteral(resourceName: "loader_icon")
            return CustomActivityIndicatorView(image: image)
        }
        
    }()
    var countriesInfoArray = [Country]()
    var countryCode = ""
    var streamList: [NSManagedObject] = []
    var selectedContentStream : Stream?
    var selectedVideoQualityMaxBitrate : Int{
        set{
            UserDefaults.standard.set(newValue, forKey: "CurrentVideoQuality")
        }
        get{
            if let session = UserDefaults.standard.value(forKey: "CurrentVideoQuality") as? Int{
                return session
            }
            else{
                return 0
            }
        }
    }
    var cookiesHasAlreadyLaunched :Bool!
    static var touchCount = 0
    static var isFavouriteClicked = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        AppDelegate.originalAppDelegate = self
        
        if appContants.appName == PreferenceManager.AppName.reeldrama {
            AppTheme.instance.currentTheme = ReelDramaTheme()
        }else if appContants.appName == PreferenceManager.AppName.firstshows {
            AppTheme.instance.currentTheme = FirstShowsTheme()
        }else if appContants.appName == PreferenceManager.AppName.tsat {
            AppTheme.instance.currentTheme = TsatTheme()
        }else if appContants.appName == PreferenceManager.AppName.aastha {
            AppTheme.instance.currentTheme = AasthaDarkTheme()
        }else if appContants.appName == PreferenceManager.AppName.gac {
            AppTheme.instance.currentTheme = gacTheme()
        }else if appContants.appName == PreferenceManager.AppName.gotv {
            AppTheme.instance.currentTheme = GoTVTheme()
        }else if appContants.appName == PreferenceManager.AppName.yvs {
            AppTheme.instance.currentTheme = yvsTheme()
        }else if appContants.appName == PreferenceManager.AppName.supposetv {
            AppTheme.instance.currentTheme = supposetvTheme()
        }else if appContants.appName == PreferenceManager.AppName.mobitel {
            AppTheme.instance.currentTheme = mobitelTheme()
        }else if appContants.appName == PreferenceManager.AppName.pbns {
            AppTheme.instance.currentTheme = pbnsTheme()
        }else if appContants.appName == PreferenceManager.AppName.airtelSL {
            AppTheme.instance.currentTheme = airtelSLTheme()
        }
         
//        Fabric.with([Crashlytics.self])
        Localization.instance.updateLocalization()
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
//        self.showAlertWithText(message: "Did finish Launching called")
       
       
        if appContants.serviceType == PreferenceManager.SerViceType.live {
            Analytics.setAnalyticsCollectionEnabled(true)
            if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
                CleverTap.setCredentialsWithAccountID(Constants.OTTUrls.cleverTapIdAndToken.id, andToken: Constants.OTTUrls.cleverTapIdAndToken.token) //Live
            }
        }
        else{
            Analytics.setAnalyticsCollectionEnabled(false)
            if (appContants.appName != .mobitel && appContants.appName != .pbns  && appContants.appName != .airtelSL) {
                CleverTap.setCredentialsWithAccountID(Constants.OTTUrls.cleverTapIdAndToken.id, andToken: Constants.OTTUrls.cleverTapIdAndToken.token) //Test
            }
        }
        if (appContants.appName != .mobitel && appContants.appName != .pbns  && appContants.appName != .airtelSL) {
            CleverTap.autoIntegrate()
            CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
        }
        Messaging.messaging().delegate = self

      
        self.initAnalytics()
//        self.initLocalytics(launchOptions: launchOptions)
        self.initPushNotifications(application)
        
        self.loadLaunchScreen()
        
//        UIApplication.shared.isStatusBarHidden = false
        self.fromLaunchApp = true
        let calendar = NSCalendar.current
        userTimeZone = calendar.timeZone
        let options = GCKCastOptions.init(discoveryCriteria: GCKDiscoveryCriteria.init(applicationID: (appContants.serviceType == .live) ? Constants.OTTUrls.googleChromeCastId : Constants.OTTUrls.googleChromeCastId)) //live 77334CF6
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk {
            
        }
//        NSTimeZone.default = AppDelegate.getDelegate().userTimeZone
//        NSTimeZone.default = NSTimeZone.init(name: "IST")! as TimeZone
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = Constants.OTTUrls.googleSDKKey
        initFreshChatSDK()
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
              print("audio error \(error)")
        }
        cookiesHasAlreadyLaunched = UserDefaults.standard.bool(forKey: "cookiesHasAlreadyLaunched")

        return true
    }

    func initPushNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *), objc_getClass("UNUserNotificationCenter") != nil {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
//                Localytics.didRequestUserNotificationAuthorization(withOptions: options.rawValue, granted: granted)
            }
        } else if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        application.registerForRemoteNotifications()

        if #available(iOS 10.0, *) {
            let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: .foreground)
            let shareAction = UNNotificationAction(identifier: "share", title: "Share", options: .foreground)
            let socialCategory = UNNotificationCategory(identifier: "social", actions: [likeAction, shareAction], intentIdentifiers: [], options: [])
            var categories = Set<UNNotificationCategory>()
            categories.insert(socialCategory)
            UNUserNotificationCenter.current().setNotificationCategories(categories)
        } else {
            // Fallback on earlier versions
            let like = UIMutableUserNotificationAction()
            like.title = "Like"
            like.identifier = "like"
            like.activationMode = .foreground
            
            let share = UIMutableUserNotificationAction()
            share.title = "Share"
            share.identifier = "share"
            share.activationMode = .foreground
            
            let social = UIMutableUserNotificationCategory()
            social.identifier = "social"
            social.setActions([like, share], for:.minimal)
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:.alert, categories:[social]))
        }
    }
    func initFreshChatSDK() {
        
        /*let freshchatConfig:FreshchatConfig = FreshchatConfig.init(appID: "c500d017-994e-468b-ace0-34ac0b9a60a0", andAppKey: "07862ae6-82d0-4a04-a14f-bdd61b7d7b5d")
        Freshchat.sharedInstance().initWith(freshchatConfig)
        
        freshchatConfig.gallerySelectionEnabled = true; // set FALSE to disable picture selection for messaging via gallery
        freshchatConfig.cameraCaptureEnabled = true; // set FALSE to disable picture selection for messaging via camera
        freshchatConfig.teamMemberInfoVisible = true; // set to FALSE to turn off showing a team member avatar. To customize the avatar shown, use the theme file
        freshchatConfig.showNotificationBanner = true; // set to FALSE if you don't want to show the in-app notification banner upon receiving a new message while the app is open
        freshchatConfig.responseExpectationVisible = true; //set to FALSE if you want to hide the response expectations for the message channels
        
        supportButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        supportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        supportButton.translatesAutoresizingMaskIntoConstraints = false
        
        //window!.addConstraint(NSLayoutConstraint(item: supportButton, attribute: .trailing, relatedBy: .equal, toItem: window!, attribute: .trailing, multiplier: 1, constant: 50))
        
        
        supportButton.setImage(UIImage.init(named: "img_freshChat"), for: .normal)
        self.window?.addSubview(supportButton)
        self.supportButton.isHidden = true
        supportButton.addTarget(self, action: #selector(self.supportButtonClicked), for: UIControl.Event.touchUpInside)*/
        
    }
    func loadLaunchScreen() {
        let lauch = LauncherScreen(nibName: "LauncherScreen", bundle: nil)
        let nav = UINavigationController.init(rootViewController: lauch)
        nav.isNavigationBarHidden = true
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
    }
    func initAnalytics() {
        if appContants.isEnabledAnalytics {
            logAnalytics.shared().initWithAnalyticsKey(Constants.OTTUrls.Analyticskey, isLive: (appContants.serviceType == PreferenceManager.SerViceType.live), andSettings: ["showLogs": appContants.ViewAnalyticsLog])
            logAnalytics.shared().triggerLogEvent(eventTrigger.trigger_ad_completed, position: 0)
        }
        
    }
    
    func initLocalytics(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
//        if appContants.isEnabledLocalytics {
//            Localytics.autoIntegrate(appContants.LocalyticsKey, launchOptions: launchOptions)
//        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            OTTSdk.isSupported{ (isSupported) in
                if isSupported == false{
                }
            }
        }
        AppDelegate.getDelegate().saveAdvertisingIdentifier {
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //        OTTSdk.refresh { (isSuccess) in
        //            print("Sdk refresh : " + ( isSuccess ? "Success" : "Failured" ))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckForUpdate"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateNowLiveViewFrame"), object: nil)
        //        }
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            if self.timezoneString != TimeZone.current.identifier {
                self.timezoneString = TimeZone.current.identifier
                var languageStr = ""
                if OTTSdk.preferenceManager.selectedLanguages.isEmpty == false {
                    languageStr = OTTSdk.preferenceManager.selectedLanguages
                }
                OTTSdk.userManager.updatePreference(selectedLanguageCodes: languageStr, sendEmailNotification: false, onSuccess: { (response) in
                    AppDelegate.getDelegate().loadHomePage(toFristViewController: true)
                    
                    print(response.count)
                    
                }) { (error) in
                    print(error.message)
                }
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        if #available(iOS 11.0, *) {
            deleteContentAfterExpiryTimeReached()
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.fromLaunchApp = false
        if AppDelegate.getDelegate().isPartialViewLoaded == true{
            PartialRenderingView.instance.dismiss()
        }
    }
    
    func open(_ url: URL, options: [String : Any] = [:],
              completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
        }
        completion?(false)
    }
    func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleOpen(url as URL, sourceApplication: sourceApplication)
        }
        return true
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.absoluteString)
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
        }
        let urlStrArr = url.absoluteString.components(separatedBy: "com/")
        if  urlStrArr.count > 0{
            self.deepLinkingString = urlStrArr[1]
            if !self.fromLaunchApp {
                if urlStrArr.count > 1 {
                    if playerVC != nil {
                        playerVC?.removeViews()
                        playerVC = nil
                    }else if otherPlayerVC != nil {
                        otherPlayerVC?.removeViews()
                        otherPlayerVC = nil
                    }
                    AppDelegate.getDelegate().loadHomePage()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                }
            }
            
            return true
        }
        else {
//            if AppDelegate.getDelegate().socialMediaLoginStr == "Facebook" {
//                return FBSDKApplicationDelegate.sharedInstance().application(app,
//                                                                             open: url,
//                                                                             sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                                                             annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//            }
//            else {
            
            //#warning : ios 13 quick fix for frndlytv
            return GIDSignIn.sharedInstance()?.handle(url) ?? false
            
            /* ios <13
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
                */
//            }
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if AppDelegate.getDelegate().socialMediaLoginStr == "Facebook" {
//            let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//            return handled
//        }
//        else {
            var _: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                          UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        //#warning : ios 13
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
        /* ios <13
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: sourceApplication,
                                                     annotation: annotation)
 */
//        }
    }


    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        self.openSharedVideo = true
        self.sharedAbsoluteString = (userActivity.webpageURL?.absoluteString)!
        if !self.fromLaunchApp {
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                let clientConfig = response.configs
                AppDelegate.getDelegate().configs = response.configs
                AppDelegate.getDelegate().setConfigResponce(response.configs)

                let urlStrArr = userActivity.webpageURL?.absoluteString.components(separatedBy: "\(clientConfig.siteURL)/")
                if (urlStrArr?.count)! > 1 {
                    self.deepLinkingString = (urlStrArr?[1])!
                    if !self.fromLaunchApp {
                        if playerVC != nil {
                            playerVC?.removeViews()
                            playerVC = nil
                        }else if otherPlayerVC != nil {
                            otherPlayerVC?.removeViews()
                            otherPlayerVC = nil
                        }
                        AppDelegate.getDelegate().loadHomePage()
                        if OTTSdk.preferenceManager.user == nil {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                            }
                        }
                        else {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                            }
                        }
                    }
                }
            }, onFailure: { (error) in
                print(error.message)
                self.showAlertWithText(message: error.message)
            })
        }
        return true
    }
    
    func loadHomePage(toFristViewController : Bool = false) {
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Tabs", bundle:nil)
//        let view1 = storyBoard.instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
        let nav = UINavigationController(rootViewController: TabsViewController.instance)
        nav.isNavigationBarHidden = true
        
        // For Frndly TV redirect to TVGuide
        TabsViewController.instance.selectedIndexPath = IndexPath(row: 0, section: 0)
        if let collectionView = TabsViewController.instance.HomeToolBarCollection {
            TabsViewController.instance.collectionView(collectionView, didSelectItemAt: TabsViewController.instance.selectedIndexPath)
            collectionView.selectItem(at: TabsViewController.instance.selectedIndexPath, animated: false, scrollPosition: .left)
        }
        if toFristViewController {
            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in })
            //            if TabsViewController.instance.menus.count > 0{
            ////                TabsViewController.instance.HomeToolBarCollection.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
            //                TabsViewController.instance.tabsControllersRefreshStatus[TabsViewController.instance.menus.first!.targetPath] = false
            //                TabsViewController.instance.showComponent(menu: TabsViewController.instance.menus.first!)
            //            }
        }
        AppDelegate.getDelegate().isDirectDownloadsPage = false
        AppDelegate.getDelegate().isDobPopup_ContentPage = false
        self.window?.rootViewController = nav
        if appContants.appName == .aastha  || appContants.appName == .gac{
            UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        }
    }
    
    func loadContentLanguagePage() {
        if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gotv || appContants.appName == .yvs || appContants.appName == .supposetv || appContants.appName == .mobitel || appContants.appName == .pbns || appContants.appName == .gac || appContants.appName == .airtelSL {
            loadHomePage()
            return
        }
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        storyBoardVC.fromPage = false
        storyBoardVC.Signup_Process = false
        storyBoardVC.viewControllerName = "Intro"
        let nav = UINavigationController.init(rootViewController: storyBoardVC)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
    }
    
    class func getDelegate() -> AppDelegate
    {
        return originalAppDelegate
    }
    
    func setCastControlBarsEnabled(_ notificationsEnabled: Bool) {
        var castContainerVC: GCKUICastContainerViewController?
        castContainerVC = (self.window!.rootViewController! as! GCKUICastContainerViewController)
        castContainerVC!.miniMediaControlsItemEnabled = notificationsEnabled
    }
    
    func castControlBarsEnabled() -> Bool {
        var castContainerVC: GCKUICastContainerViewController?
        castContainerVC = (self.window!.rootViewController! as! GCKUICastContainerViewController)
        return castContainerVC!.miniMediaControlsItemEnabled
    }
    
    func handleSupportButton(isHidden:Bool,isFromTabVC:Bool,chromeCastHeight:CGFloat = 0.0) {
        //print("UIApplication.topVC() \(UIApplication.topVC()!)")
        
        /*if OTTSdk.preferenceManager.user?.userId != nil {
            self.supportButton.isHidden = isHidden
            var tempYY:CGFloat = 5.0
            if isFromTabVC == true {
                tempYY = (productType.iPad ? 52.0 : (DeviceType.IS_IPHONE_X ? 95.0 : 65.0))
            }
            tempYY = tempYY + chromeCastHeight
            if playerVC != nil {
                if playerVC!.playerHeight != nil{
                    let tempVal = playerVC!.playerHeight.constant + tempYY + 10
                    AppDelegate.getDelegate().supportButtonBottomConstraint?.constant = -tempVal
                }
                else{
                    AppDelegate.getDelegate().supportButtonBottomConstraint?.constant = -150
                }
            }
            else{
                AppDelegate.getDelegate().supportButtonBottomConstraint?.constant = -tempYY
            }
        }
        else{
            self.supportButton.isHidden = true
        }
        */
    }
    
    func checkAndUpdateClientAppVersion() {
        if OTTSdk.preferenceManager.user != nil {
            var appVersion = "1.0"
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                appVersion = currentVersion
            }
            
            if appVersion.compare(OTTSdk.preferenceManager.user!.sessionDetails.clientAppVersion, options: .numeric) == .orderedDescending {
                
                if appVersion.compare(OTTSdk.preferenceManager.user!.sessionDetails.clientAppVersion, options: .numeric) != .orderedSame {
                    var languageStr = ""
                    if OTTSdk.preferenceManager.selectedLanguages.isEmpty == false {
                        languageStr = OTTSdk.preferenceManager.selectedLanguages
                    }
                    
                    OTTSdk.userManager.updatePreference(selectedLanguageCodes: languageStr, sendEmailNotification: true,appVersion:appVersion, onSuccess: { (response) in
                        print(response)
                        
                    }, onFailure: { (error) in
                        print(error.message)
                        
                    })
                }
            }
        }
    }
    
    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OTTDownloads")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    @available(iOS 10.0, *)
    func fetchStreamList() -> [Stream] {
        
        var streamsListArr = [Stream]()
        streamList.removeAll()
        if let user = OTTSdk.preferenceManager.user {
            let managedContext = persistentContainer.viewContext
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "StreamInfo")
            fetchRequest.predicate = NSPredicate.init(format: "user_ID = %d", user.userId)
            do {
                streamList = try managedContext.fetch(fetchRequest)
                for streamObj in streamList {
                    let stream = Stream()
                    stream.name = streamObj.value(forKey: "title") as! String
                    stream.subTitle = streamObj.value(forKey: "subTitle") as! String
                    stream.playlistURL = streamObj.value(forKey: "streamURL") as! String
                    stream.imageData = (streamObj.value(forKey: "imageData") as! NSData)
                    stream.userID = (streamObj.value(forKey: "user_ID") as! Int)
                    stream.targetPath = (streamObj.value(forKey: "targetPath") as! String)
                    stream.analyticsMetaID = (streamObj.value(forKey: "analyticsMetaID") as! String)
                    stream.downloaded_end_date = (streamObj.value(forKey: "downloaded_end_date") as! Double)
                    stream.downloaded_start_date = (streamObj.value(forKey: "downloaded_start_date") as! Double)
                    if let bit_rate = streamObj.value(forKey: "bit_rate") as? String {
                        stream.bit_rate = bit_rate
                    }
                    if let download_size = streamObj.value(forKey: "download_size") as? String {
                        stream.download_size = download_size
                    }
                    if let video_duration = streamObj.value(forKey: "video_duration") as? String {
                        stream.video_duration = video_duration
                    }
                    if let video_download = streamObj.value(forKey: "video_download") as? Bool {
                        stream.video_download = video_download
                    }
                    
                    streamsListArr.append(stream)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        return streamsListArr
    }
    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveStream (_ streamDict:[String:Any]) {
        
        // 1
        let managedContext = persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "StreamInfo",
                                     in: managedContext)!
        
        let streamInfo = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        if let user = OTTSdk.preferenceManager.user {
            streamInfo.setValue(user.userId, forKeyPath: "user_ID")
        }
        if let title = streamDict["title"] as? String {
            streamInfo.setValue(title, forKeyPath: "title")
        }
        if let subTitle = streamDict["subTitle"] as? String {
            streamInfo.setValue(subTitle, forKeyPath: "subTitle")
        }
        if let imageData = streamDict["imageData"] as? NSData {
            streamInfo.setValue(imageData, forKeyPath: "imageData")
        }
        if let streamURL = streamDict["streamURL"] as? String {
            streamInfo.setValue(streamURL, forKeyPath: "streamURL")
        }
        if let targetPath = streamDict["targetPath"] as? String {
            streamInfo.setValue(targetPath, forKeyPath: "targetPath")
        }
        if let targetPath = streamDict["analyticsMetaID"] as? String {
            streamInfo.setValue(targetPath, forKeyPath: "analyticsMetaID")
        }
        if let downloaded_start_date = streamDict["downloaded_start_date"] as? Double {
            streamInfo.setValue(downloaded_start_date, forKeyPath: "downloaded_start_date")
        }
        if let downloaded_end_date = streamDict["downloaded_end_date"] as? Double {
            streamInfo.setValue(downloaded_end_date, forKeyPath: "downloaded_end_date")
        }
        if let bit_rate = streamDict["bit_rate"] as? String {
            streamInfo.setValue(bit_rate, forKeyPath: "bit_rate")
        }
        if let bit_rate = streamDict["download_size"] as? String {
            streamInfo.setValue(bit_rate, forKeyPath: "download_size")
        }
        if let video_duration = streamDict["video_duration"] as? String {
            streamInfo.setValue(video_duration, forKeyPath: "video_duration")
        }
        if let video_download = streamDict["video_download"] as? Bool {
            streamInfo.setValue(video_download, forKeyPath: "video_download")
        }
        
        // 4
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    @available(iOS 10.0, *)
    func deleteStream(_ stream:Stream) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "StreamInfo")
        do {
            let currentStreamList = try managedContext.fetch(fetchRequest)
            let predicate = NSPredicate(format: "title == %@", stream.name)
            let filteredarr = currentStreamList.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let managedObject = filteredarr[0]
                managedContext.delete(managedObject)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func sendDeleteDownloadRequest(_ asset:Asset, downloadState:Asset.DownloadState) {
        if #available(iOS 11.0, *) {
            if downloadState == .downloading {
                AssetPersistenceManager.sharedManager.cancelDownload(for: asset)
                AppDelegate.getDelegate().deleteStream(asset.stream)
                var userInfo = [String: Any]()
                userInfo[Asset.Keys.name] = asset.stream.name
                userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
                userInfo[Asset.Keys.downloadSelectionDisplayName] = displayNamesForSelectedMediaOptions(asset.urlAsset.preferredMediaSelection)
                
            } else if downloadState == .downloaded {
                AssetPersistenceManager.sharedManager.deleteAsset(asset)
                AppDelegate.getDelegate().deleteStream(asset.stream)
            }
        }
    }
    func updateExpiryDateForStream(streamName : String, download_size : String, video_download : Bool) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "StreamInfo")
        fetchRequest.predicate = NSPredicate(format: "title = %@", streamName)
        guard let results = try? persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject] else {return}
        if results.count > 0 {
            let object = results.last
            if Utilities.hasConnectivity() {
                guard let date = Calendar.current.date(byAdding: .day, value: offlineDownloadExpiryDays, to: Date()) else {return}
                object?.setValue(date.timeIntervalSince1970 * 1000, forKey: "downloaded_end_date")
                object?.setValue(download_size, forKey: "download_size")
                object?.setValue(video_download, forKey: "video_download")
            }else {
                if let offlineExpiryDays = UserDefaults.standard.value(forKey: "offlineDownloadExpiryDays") as? String, let expiryDays = Int(offlineExpiryDays) {
                    guard let date = Calendar.current.date(byAdding: .day, value: expiryDays, to: Date()) else {return}
                    object?.setValue(date.timeIntervalSince1970 * 1000, forKey: "downloaded_end_date")
                    object?.setValue(download_size, forKey: "download_size")
                    object?.setValue(video_download, forKey: "video_download")
                }
            }
            do {
                try persistentContainer.viewContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    @available(iOS 11.0, *)
    private func deleteMyDownloadsData() {
        let expiryTimeInterval = Date().timeIntervalSince1970 * 1000
        let managedContext = persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "StreamInfo")
        fetchRequest.predicate = NSPredicate(format: "downloaded_end_date < %f", expiryTimeInterval)
        guard let results = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] else {return}
        for object in results {
            deleteObject(object: object)
        }
    }
    @available(iOS 11.0, *)
    func deleteContentAfterExpiryTimeReached() {
        if offlineDownloadExpiryDays > 0 {
            deleteMyDownloadsData()
        }else {
            if let offlineExpiryDays = UserDefaults.standard.value(forKey: "offlineDownloadExpiryDays") as? String, offlineExpiryDays.count > 0 {
                deleteMyDownloadsData()
            }
        }
    }
    @available(iOS 11.0, *)
    func deleteAllData() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StreamInfo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                deleteObject(object: objectData)
            }
        } catch let error {
            print("Detele all data in \("StreamInfo") error :", error)
        }
    }
    @available(iOS 11.0, *)
    private func deleteObject(object : NSManagedObject) {
        if let titleName = object.value(forKey: "title") as? String {
            deleteLocalDownloadVideo(name: titleName)
            if let asset = AssetPersistenceManager.sharedManager.assetForStream(withName: titleName) {
                let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                self.sendDeleteDownloadRequest(asset, downloadState: downloadState)
                AssetPersistenceManager.sharedManager.deleteAsset(asset)
                AppDelegate.getDelegate().deleteStream(asset.stream)
            }
            if let asset = AssetPersistenceManager.sharedManager.localAssetForStream(withName: titleName) {
                AssetPersistenceManager.sharedManager.deleteAsset(asset)
                let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                self.sendDeleteDownloadRequest(asset, downloadState: downloadState)
                AppDelegate.getDelegate().deleteStream(asset.stream)
                
            }
            persistentContainer.viewContext.delete(object)
            do {
                try persistentContainer.viewContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    private func deleteLocalDownloadVideo(name : String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent(name)
        // Delete file in document directory
        if #available(iOS 11.0, *) {
            if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
                do {
                    try FileManager.default.removeItem(at: documentDirectoryFileUrl)
                    Log(message: "Pramod Deleted")
                } catch {
                    Log(message: "Could not delete file: \(error)")
                }
            }else if let asset = AssetPersistenceManager.sharedManager.localAssetForStream(withName: name) {
                if FileManager.default.fileExists(atPath: asset.urlAsset.url.path) {
                    do {
                        try FileManager.default.removeItem(at: asset.urlAsset.url)
                        AssetPersistenceManager.sharedManager.deleteAsset(asset)
                        let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                        self.sendDeleteDownloadRequest(asset, downloadState: downloadState)
                        AppDelegate.getDelegate().deleteStream(asset.stream)
                    } catch {
                        Log(message: "Could not delete file: \(error)")
                    }
                }
            }
        }
    }
    @objc func supportButtonClicked() {
        /*if UIApplication.topVC() != nil {
            Freshchat.sharedInstance().showConversations(UIApplication.topVC()!)
        }*/
    }
    //MARK:- Push notification delegates
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NSLog("Token :\(token)")
        Messaging.messaging().apnsToken = deviceToken
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.setPushToken(deviceToken)
        }
    }
    private func application(_ application: UIApplication, didReceiveRemoteNotification
        userInfo: [NSObject : AnyObject]) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        }
    }
    
    func application(_ application: UIApplication, didReceive
        notification: UILocalNotification) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: notification)
        }
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?,
                     for notification: UILocalNotification, completionHandler: () -> Void) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: notification)
        }
        completionHandler()
    }
    
    private func application(application: UIApplication, handleActionWithIdentifier identifier: String?,
                     forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: @escaping () -> Void) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        }
        completionHandler(.noData)
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        // Print message ID.
////        if let messageID = userInfo[gcmMessageIDKey] {
////            print("Message ID: \(messageID)")
////        }
//        
//        // Print full message.
//        print(userInfo)
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        // Print message ID.
////        if let messageID = userInfo[gcmMessageIDKey] {
////            print("Message ID: \(messageID)")
////        }
//        
//        // Print full message.
//        print(userInfo)
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //#warning disabling due to incomplete implementation of notificaton
        completionHandler([.alert, .badge, .sound])
        return;
        
        /*
        let notificationPayLoad = notification.request.content.userInfo
        self.pushNotificationPayLoad = notificationPayLoad
        if notificationPayLoad["launchurl"] != nil {
            self.deepLinkingString = notificationPayLoad["launchurl"] as! String
            if !self.fromLaunchApp {
                if playerVC != nil {
                    playerVC?.removeViews()
                    playerVC = nil
                }else if otherPlayerVC != nil {
                    otherPlayerVC?.removeViews()
                    otherPlayerVC = nil
                }
                if OTTSdk.preferenceManager.user == nil {

                    AppDelegate.getDelegate().loadHomePage()
                    let topVC = UIApplication.topVC()!
                    topVC.startAnimating(allowInteraction: true)
                    self.presentLaunchURL = self.deepLinkingString
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                        self.loadNotificationContent()
                    }
                }
                else {
                    AppDelegate.getDelegate().loadHomePage()
                    let topVC = UIApplication.topVC()!
                    topVC.startAnimating(allowInteraction: true)
                    self.presentLaunchURL = self.deepLinkingString
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                        self.loadNotificationContent()
                    }
                }
            }
        }
        Localytics.didReceiveNotificationResponse(userInfo:notification.request.content.userInfo)
        CleverTap.sharedInstance()?.handleNotification(withData:notification.request.content.userInfo)

        completionHandler([.alert, .badge, .sound])*/
    }
    
    @available(iOS 10.0, *) // if also targeting iOS versions less than 10.0
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //#warning disabling due to incomplete implementation of notificaton
        /**/
        let notificationPayLoad = response.notification.request.content.userInfo
        self.pushNotificationPayLoad = notificationPayLoad
        if notificationPayLoad["launchurl"] != nil {
            self.deepLinkingString = notificationPayLoad["launchurl"] as! String
            if !self.fromLaunchApp {
                if playerVC != nil {
                    playerVC?.removeViews()
                    playerVC = nil
                }else if otherPlayerVC != nil {
                    otherPlayerVC?.removeViews()
                    otherPlayerVC = nil
                }
                if OTTSdk.preferenceManager.user == nil {
/*
                            AppDelegate.getDelegate().loadHomePage()
                            let topVC = UIApplication.topVC()!
                            topVC.startAnimating(allowInteraction: true)
                            self.presentLaunchURL = self.deepLinkingString
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                                self.loadNotificationContent()
                            }
*/
                }
                else {
                        AppDelegate.getDelegate().loadHomePage()
                        let topVC = UIApplication.topVC()!
                        topVC.startAnimating(allowInteraction: true)
                        self.presentLaunchURL = self.deepLinkingString
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                            self.loadNotificationContent()
                        }
                }
            } else {
                if UIApplication.topVC()! is IntroViewController {
                    AppDelegate.getDelegate().loadHomePage()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                    }
                }
            }
        }
//        Localytics.didReceiveNotificationResponse(userInfo: response.notification.request.content.userInfo)
        switch response.actionIdentifier {
        case "like": break // handle like button
        case "share": break // handle share button
        case UNNotificationDefaultActionIdentifier: break // handle default open
        case UNNotificationDismissActionIdentifier: break // handle dismiss
        default: break // handle other cases
        }
        if (appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL) {
            CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        }
        completionHandler()
        
       /* print("APPDELEGATE: didReceiveResponseWithCompletionHandler \(response.notification.request.content.userInfo)")
        
        // if you wish CleverTap to record the notification click and fire any deep links contained in the payload
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo, openDeepLinksInForeground: true)
        
        completionHandler()*/
    }
    
   
    
    func loadNotificationContent() {
        //#warning disabling due to incomplete implementation of notificaton
        /**/
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        let topVC = UIApplication.topVC()!
        
        topVC.startAnimating(allowInteraction: true)
        //        self.showAlertWithText(message: "Notitfication Content Called")
        
        TargetPage.getTargetPageObject(path: AppDelegate.getDelegate().deepLinkingString) { (viewController, pageType) in
            
            if let vc = viewController as? PlayerViewController{
                vc.delegate = AppDelegate.getDelegate().contentViewController
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if viewController is DefaultViewController {
                let menuIndex = self.checkIsMenuTab()
                if menuIndex >= 0 {
                    let scrollIndex = IndexPath(row: menuIndex, section: 0)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                    }
                    
                    let menu = TabsViewController.instance.menus[menuIndex]
                    TabsViewController.instance.showComponent(menu: menu)
                } else {
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else if let vc = viewController as? ContentViewController{
                let menuIndex = self.checkIsMenuTab()
                if menuIndex >= 0 {
                    let scrollIndex = IndexPath(row: menuIndex, section: 0)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                    }
                    
                    let menu = TabsViewController.instance.menus[menuIndex]
                    TabsViewController.instance.showComponent(menu: menu)
                } else {
                    vc.isToViewMore = true
                    vc.targetedMenu = AppDelegate.getDelegate().deepLinkingString
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if let vc = viewController as? ListViewController{
                let menuIndex = self.checkIsMenuTab()
                if menuIndex >= 0 {
                    let scrollIndex = IndexPath(row: menuIndex, section: 0)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                    }
                    
                    let menu = TabsViewController.instance.menus[menuIndex]
                    TabsViewController.instance.showComponent(menu: menu)
                } else {
                    vc.isToViewMore = true
                    vc.sectionTitle = "Section"
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if let vc = viewController as? DetailsViewController{
                let menuIndex = self.checkIsMenuTab()
                if menuIndex >= 0 {
                    let scrollIndex = IndexPath(row: menuIndex, section: 0)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                    }
                    
                    let menu = TabsViewController.instance.menus[menuIndex]
                    TabsViewController.instance.showComponent(menu: menu)
                } else {
                    let topVC = UIApplication.topVC()!
                    for pageData in (vc.contentDetailResponse?.data)! {
                        if let content = pageData.paneData as? Content {
                            vc.navigationTitlteTxt = content.title
                        }
                    }
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
            let topVC = UIApplication.topVC()!
            topVC.stopAnimating()
        }
    }

   /* func getStaticPagePathFrom(_ config:Config?, forStr:String) -> String {
        var targetPath = ""
        let targetPathsArr = config?.staticPagePaths.components(separatedBy: ",")
        for targetPathStr in targetPathsArr! {
            let targetPathStrArr = targetPathStr.components(separatedBy: ":")
            if targetPathStrArr.count > 0 && targetPathStrArr[0] == forStr {
                targetPath = targetPathStrArr[1]
                break;
            }
        }
        return targetPath
    }*/
    
    func checkIsMenuTab() -> Int {
        var menuIndex = -1
        for (index,menu) in TabsViewController.instance.menus.enumerated() {
            if menu.targetPath == AppDelegate.getDelegate().deepLinkingString {
                menuIndex = index
            }
        }
        return menuIndex
    }

    
    func gotoHelpPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "HelpOptionsViewController") as! HelpOptionsViewController
        
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.isNavigationBarHidden = true
        topVC.navigationController?.pushViewController(view1, animated: true)
        
        /*
         let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
         let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
         view1.urlString = Constants.OTTUrls.helpPageUrl
         
         view1.pageString = "About us".localized
         view1.viewControllerName = "AccountViewController"
         let topVC = UIApplication.topVC()!
         topVC.navigationController?.isNavigationBarHidden = true
         topVC.navigationController?.pushViewController(view1, animated: true)
         
         */
    }
    
    func loadNoPackagesPage() {
        
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "NoPackagesBlockerViewController") as! NoPackagesBlockerViewController
        let nav = UINavigationController.init(rootViewController: storyBoardVC)
        nav.isNavigationBarHidden = true
        AppDelegate.getDelegate().window?.rootViewController = nav
    }

    //MARK:- keychain Wrapper
    func saveDataInKeychain(keyName: String, keyValue: String) -> Bool{
        if keyName != "" && keyValue != "" {
            let saveSuccessful: Bool = self.customKeychainWrapperInstance.set(keyValue, forKey: keyName)
            return saveSuccessful
        }
        else if keyName != "" {
            let saveSuccessful: Bool = self.customKeychainWrapperInstance.set("", forKey: keyName)
            return saveSuccessful
        }
        else{
            return false
        }
    }
    
    func getDataFromKeychain(keyName: String) -> String{
        if keyName != ""  {
            let retrievedString: String? = self.customKeychainWrapperInstance.string(forKey: keyName)
            return retrievedString ?? ""
        }
        else{
            return ""
        }
    }
    func removeDataFromKeychain(keyName: String) -> Bool{
        if keyName != "" {
            let removeSuccessful: Bool = self.customKeychainWrapperInstance.removeObject(forKey: keyName)
            return removeSuccessful
        }
        else{
            return false
        }
    }
    
    
    
    
    //MARK:- keychain Methods
    let keychain = UserDefaults.standard
    
    func onSaveKeychain(keyName: String, keyValue: String) {
        if keyName != "" && keyValue != "" {
            keychain.set(keyValue, forKey: keyName)
        }
    }
    func onSaveKeychainAny(keyName: String, keyValue: Any) {
        if keyName != "" {
            keychain.set(keyValue, forKey: keyName)
        }
    }
    func onGetKeychain(keyName: String) -> String {
        
        if let value = keychain.value(forKey: keyName)
        {
            return value as! String
        } else {
            return ""
        }
    }
    func keyExists(keyName: String) -> Bool {
        
        if (keychain.object(forKey: keyName) != nil) {
            return true
        }else{
            return false
        }
        
        
    }
    func onSaveKeychainBool(keyName: String, keyValue: Bool) {
        keychain.set(keyValue, forKey: keyName)
        
    }
    
    func onGetKeychainBool(keyName: String) -> Bool {
        
        if let value :Bool = keychain.value(forKey: keyName) as? Bool {
            return value
        } else {
            return false
        }
    }
    func onDeleteKeychain(keyName: String) {
        if let value = keychain.value(forKey: keyName) {
            print("deleting key value\(value)")
            keychain.removeObject(forKey: keyName)
        }
    }
    func onClearAllKeychains() {
        if let bundle = Bundle.main.bundleIdentifier {
            keychain.removePersistentDomain(forName: bundle)
        }
    }
    func showAlertWithText ( message : String) {
        
        let alertViewController = UIViewController.init()
        
        let alert = UIAlertController(title: String.getAppName(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: nil))
        
        self.window?.rootViewController = alertViewController
        self.window?.windowLevel = UIWindow.Level.alert + 1
        self.window!.makeKeyAndVisible()
        alertViewController.present(alert, animated: true, completion: nil)
        
        
    }
    func showAlertWithTextAfterWindowPresented ( message : String) {
        UIViewController().errorAlert(forTitle: String.getAppName(), message: message, needAction: false) { (flag) in }
//        let alert = UIAlertController(title: String.getAppName(), message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: nil))
//        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func printLog(log: AnyObject?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        if log == nil {
            print("nil")
        }
        else {
            print(log!)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if shouldRotate {
            return UIInterfaceOrientationMask.all
        }
        else {
            if productType.iPad {
                 return UIInterfaceOrientationMask.all
            }
            return UIInterfaceOrientationMask.portrait
        }
    }
    
 
    // MARK: - Core Data stack
    
    lazy var searchPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchHistory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext {
        return AppDelegate.getDelegate().searchPersistentContainer.viewContext
    }
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = searchPersistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func removeStatusBarView() {
        UIApplication.shared.keyWindow?.viewWithTag(6877)?.removeFromSuperview()
    }
}
extension UIApplication {
    private var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.tag = 6877
//            statusbarView.backgroundColor = UIColor.green
            if let w = app.keyWindow {
                w.addSubview(statusbarView)
                statusbarView.translatesAutoresizingMaskIntoConstraints = false
                statusbarView.heightAnchor
                    .constraint(equalToConstant: statusBarHeight).isActive = true
                statusbarView.widthAnchor
                    .constraint(equalTo: w.widthAnchor, multiplier: 1.0).isActive = true
                statusbarView.topAnchor
                    .constraint(equalTo: w.topAnchor).isActive = true
                statusbarView.centerXAnchor
                    .constraint(equalTo: w.centerXAnchor).isActive = true
            }
            return statusbarView
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.tag = 6877
            statusBar?.backgroundColor = UIColor.red
            return statusBar
        }
        return nil
        /*let tag = 384824585
        if let statusBar = keyWindowInConnectedScenes?.viewWithTag(tag) {
            statusBar.removeFromSuperview()
        }
        if #available(iOS 13.0, *) {
            if let windowScene = keyWindowInConnectedScenes?.windowScene, let statusBarManager = windowScene.statusBarManager, statusBarManager.isStatusBarHidden {
                return UIView()
            }else if let windowScene = keyWindowInConnectedScenes?.windowScene, let statusBarManager = windowScene.statusBarManager {
                let statusBarView = UIView(frame: statusBarManager.statusBarFrame)
                statusBarView.tag = tag
                keyWindowInConnectedScenes?.addSubview(statusBarView)
                keyWindowInConnectedScenes?.bringSubviewToFront(statusBarView)
                if appContants.appName == .aastha {
                    statusBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
                }else {
                    statusBarView.backgroundColor = .clear
                }
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil*/
    }
}

extension UIApplication {
//    var statusBarView: UIView? {
//        if #available(iOS 13.0, *) {
//            return UIStatusBarManager.self as? UIView
//        } else {
//            // Fallback on earlier versions
//            return value(forKey: "statusBar") as? UIView
//        }
//    }
    
    func hideSB() {
        AppDelegate.getDelegate().statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            UIApplication.topVC()?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func showSB() {
        AppDelegate.getDelegate().statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            UIApplication.topVC()?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    class func topVC(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topVC(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topVC(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topVC(base: presented)
        }
        return base
    }
    func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "json/banners", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    Log(message: "\(object)")
                } else if let object = json as? [Any] {
                    // json is an array
                    Log(message: "\(object)")
                } else {
                    Log(message: "JSON is invalid")
                }
            } else {
                Log(message: "no file")
            }
        } catch {
            Log(message: error.localizedDescription)
        }
    }
}
extension AppDelegate {
    func setConfigResponce(_ clientConfig:Config) {
        
        /*showVideoAds
        resendOtpLimit
        MAXDVRDISPLAYTEXT
        takeAtestButtonText
        staticPagePaths
        */
        
         AppDelegate.getDelegate().isCallSupported = clientConfig.isCallSupported
         AppDelegate.getDelegate().isFacebookLoginSupported = clientConfig.isFacebookLoginSupported
         AppDelegate.getDelegate().supportGoogleLogin = clientConfig.supportGoogleLogin
         AppDelegate.getDelegate().supportAppleLogin = clientConfig.supportAppleLogin
         AppDelegate.getDelegate().callingNumber = clientConfig.callingNumber
         AppDelegate.getDelegate().iosAllowSignup = clientConfig.iosAllowSignup
         AppDelegate.getDelegate().supportChromecast = clientConfig.supportChromecast
         AppDelegate.getDelegate().isOTPSupported = clientConfig.isOTPSupported
         AppDelegate.getDelegate().buttonRecord = clientConfig.buttonRecord
         AppDelegate.getDelegate().buttonStopRecord = clientConfig.buttonStopRecord
         AppDelegate.getDelegate().recordStatusRecorded = clientConfig.recordStatusRecorded
         AppDelegate.getDelegate().recordStatusRecording = clientConfig.recordStatusRecording
         AppDelegate.getDelegate().recordStatusScheduled = clientConfig.recordStatusScheduled
         AppDelegate.getDelegate().enableNdvr = clientConfig.enableNdvr

        AppDelegate.getDelegate().showVideoAds = clientConfig.supportVideoAds
        AppDelegate.getDelegate().showBannerAds = clientConfig.supportBannerAds
         AppDelegate.getDelegate().showInterstitialAds = clientConfig.supportInterstitialAds
         AppDelegate.getDelegate().showNativeAds = clientConfig.supportNativeAds
        AppDelegate.getDelegate().defaultBannerAdTag = clientConfig.BannerAdUnitIdIos
        AppDelegate.getDelegate().defaultPlayerBannerAdTag = clientConfig.BannerAdUnitIdPlayerIos
         AppDelegate.getDelegate().defaultNativeAdTag = clientConfig.NativeAdUnitId
         AppDelegate.getDelegate().supportLocalytics = clientConfig.supportLocalytics
         AppDelegate.getDelegate().supportFireBase = clientConfig.supportFirebase
         AppDelegate.getDelegate().supportCleverTap = clientConfig.supportCleverTap
         AppDelegate.getDelegate().mobileRegExp = clientConfig.validMobileRegex
         AppDelegate.getDelegate().aboutUsPageUrl = clientConfig.aboutUsPageUrl
         AppDelegate.getDelegate().contactUsPageUrl = clientConfig.contactUsPageUrl
         AppDelegate.getDelegate().faqPageUrl = clientConfig.faqPageUrl
         AppDelegate.getDelegate().privacyPolicyPageUrl = clientConfig.privacyPolicyPageUrl
         AppDelegate.getDelegate().termsConditionsPageUrl = clientConfig.termsConditionsPageUrl
         AppDelegate.getDelegate().resSErrorNeedPaymentIos = clientConfig.resSErrorNeedPaymentIos
         AppDelegate.getDelegate().resSErrorNotLoggedInIos = clientConfig.resSErrorNotLoggedInIos
         AppDelegate.getDelegate().signinTitle = clientConfig.signinTitle
         AppDelegate.getDelegate().signupTitle = clientConfig.signupTitle
         
         AppDelegate.getDelegate().tvshowPlayerRecommendationText = clientConfig.tvshowPlayerRecommendationText
         AppDelegate.getDelegate().tvshowDetailsRecommendationText = clientConfig.tvshowDetailsRecommendationText
         AppDelegate.getDelegate().movieDetailsRecommendationText = clientConfig.movieDetailsRecommendationText
         AppDelegate.getDelegate().moviePlayerRecommendationText = clientConfig.moviePlayerRecommendationText
         AppDelegate.getDelegate().channelRecommendationText = clientConfig.channelRecommendationText
        AppDelegate.getDelegate().favouritesTargetPath = clientConfig.favouritesTargetPath
        AppDelegate.getDelegate().myPurchasesTargetPath = clientConfig.myPurchasesTargetPathMobiles
        AppDelegate.getDelegate().offlineDownloadExpiryDays = clientConfig.offlineDownloadExpiryDays
        AppDelegate.getDelegate().offlineDownloadsLimit = clientConfig.offlineDownloadsLimit
        AppDelegate.getDelegate().offlineContentExpiryTagInHours = clientConfig.offlineContentExpiryTagInHours
        if clientConfig.offlineContentExpiryTagInHours > 0 {
            UserDefaults.standard.setValue("\(clientConfig.offlineContentExpiryTagInHours)", forKey: "offlineContentExpiryTagInHours")
        }
        if clientConfig.offlineDownloadsLimit > 0 {
            UserDefaults.standard.setValue("\(clientConfig.offlineDownloadsLimit)", forKey: "offlineDownloadsLimit")
        }
        if clientConfig.offlineDownloadExpiryDays > 0 {
            UserDefaults.standard.setValue("\(clientConfig.offlineDownloadExpiryDays)", forKey: "offlineDownloadExpiryDays")
        }
        AppDelegate.getDelegate().showViewAll = clientConfig.viewAllText
        AppDelegate.getDelegate().parentalControlPinLength = clientConfig.parentalControlPinLength
        AppDelegate.getDelegate().parentalControlPopupMessage = clientConfig.parentalControlPopupMessage
        AppDelegate.getDelegate().siteURL = configs?.siteURL ?? ""
        UserDefaults.standard.synchronize()
        
        if let _themeColoursList = AppDelegate.getDelegate().configs?.themeColoursList.convertToJson() as? [String : Any] {
            if let _selectedThemeName = _themeColoursList["themeName"] as? String {
                if let _selectedThemeColors = _themeColoursList[_selectedThemeName] as? [String:Any] {
                    AppDelegate.getDelegate().dynamicColorCodes = _selectedThemeColors
                    if appContants.appName == PreferenceManager.AppName.gac {
                        AppTheme.instance.currentTheme = gacTheme()
                    }
                }
                
            }
        }
        
     }
    
    func getMyCountiesList(isUpdated : Bool, completion :(()->Void)?) {
        OTTSdk.appManager.updateLocation(onSuccess: { (response) in
            if response.ipInfo.countryCode.count > 0 {
                self.countryCode = response.ipInfo.countryCode
            }
            OTTSdk.appManager.getCountries(onSuccess: { (response) in
                self.countriesInfoArray = response
                if isUpdated {
                    completion!()
                }
            }) { (error) in
                Log(message: error.message)
            }
        }) { (error) in
            Log(message: error.message)
        }

    }
}
extension AppDelegate {
    
    func saveAdvertisingIdentifier(completion : @escaping() -> Void) {
        if appContants.appName == .tsat || appContants.appName == .firstshows || appContants.appName == .aastha  || appContants.appName == .gac || appContants.appName == .supposetv {
            if #available(iOS 14, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    
                    
                    ATTrackingManager.requestTrackingAuthorization { (status) in
                        
                        switch status {
                        case .authorized:
                            
                            // Tracking authorization dialog was shown
                            
                            // and we are authorized
                            
                            print("Authorized")
                            
                            // Now that we are authorized we can get the IDFA
                            
                            print(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
                            
                            self.device_atts = 3
                            self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            
                            completion()
                            
                        case .denied:
                            
                            // Tracking authorization dialog was
                            
                            // shown and permission is denied
                            
                            print("Denied")
                            
                            self.device_atts = 2
                            self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            self.device_Ifv = PreferenceManager.boxId
                            
                            completion()
                            
                        case .notDetermined:
                            
                            // Tracking authorization dialog has not been shown
                            
                            print("Not Determined")
                            self.device_atts = 0
                            self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            self.device_Ifv = PreferenceManager.boxId
                            completion()
                            
                        case .restricted:
                            
                            print("Restricted")
                            self.device_atts = 1
                            self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            self.device_Ifv = PreferenceManager.boxId
                            completion()
                            
                        @unknown default:
                            
                            print("Unknown")
                            self.device_atts = 0
                            self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            self.device_Ifv = PreferenceManager.boxId
                            completion()
                            
                        }
                    }
                })
            }
            else {
                if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == true {
                    self.device_atts = 3
                    self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
                else{
                    self.device_atts = 2
                    self.device_Ifa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    self.device_Ifv = PreferenceManager.boxId
                }
                completion()
            }
        }
        else {
            completion()
        }
    }
}


extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Log(message: "Firebase registration token: \(fcmToken)")
        if let token = fcmToken {
            let dataDict:[String: String] = ["token": token]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        Log(message: "Received data message: \(remoteMessage.appData)")
//    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        Log(message: "Received data message: \(remoteMessage.appData)")
//    }
    // [END ios_10_data_message]
}
