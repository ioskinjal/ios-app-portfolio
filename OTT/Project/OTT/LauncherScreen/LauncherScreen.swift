//
//  LauncherScreen.swift
//  YuppFlix
//
//  Created by Chandra Sekhar on 12/6/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import AVKit
import AVFoundation
import WebKit

class LauncherScreen: UIViewController,AVPlayerViewControllerDelegate, DefaultViewControllerDelegate {

    @IBOutlet weak var splashScreenImgView: UIImageView!
    @IBOutlet weak var checkInternetConectionBtn: UIButton!
    @IBOutlet weak var internetStatusLbl: UILabel!
    
    var WKwebView: WKWebView!
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    var isSupportedToUser:Bool!
    weak var currentViewController: UIViewController?
    weak var updatingViewController: UIViewController?

    @IBOutlet weak var videoSkipBtn: UIButton!

    @IBAction func skipVideoCkicked(_ sender: Any) {
        self.playerItemDidPlayToEndTime(Notification.init(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime))
    }
    @IBAction func checkInternetConnectionAction(_ sender: Any) {
        if Utilities.hasConnectivity() {
            self.checkInternetConectionBtn.isHidden = true
            self.internetStatusLbl.isHidden = true
            self.startAnimating(allowInteraction: true)
            self.initializeSDK(isSkipBtn: true)
        }
        else{
            self.videoSkipBtn.isHidden = true
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserAgent()
        splashScreenImgView.image = UIImage(named: "spalshScreen")!
        if appContants.appName == .gac {
            self.view.backgroundColor = UIColor.white
            self.splashScreenImgView.isHidden = false
        }
        else {
            self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        }
        self.videoSkipBtn.setTitle("Skip".localized, for: .normal)
        self.videoSkipBtn.cornerDesign()
        internetStatusLbl.text = "Please Check your Connection".localized
        checkInternetConectionBtn.setTitle("Tap to retry".localized, for: .normal)
//        self.startAnimating(allowInteraction: true)
        internetStatusLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        checkInternetConectionBtn.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkForUpdateNotify), name: NSNotification.Name(rawValue: "CheckForUpdate"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAnimating()
        AppDelegate.getDelegate().sourceScreen = "Launcher_Page"
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        if String.welcomeVideoStatus .isEmpty {
            self.videoSkipBtn.isHidden = true
        }
        else {
            self.videoSkipBtn.isHidden = true
        }
    }
    
    internal func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name:UIApplication.willResignActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name:UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name:UIApplication.didBecomeActiveNotification, object: UIApplication.shared)
    }
    
    @objc internal func applicationWillResignActive(_ aNotification: Notification) {
        if self.player != nil {
            self.player.pause()
        }
    }

    @objc internal func applicationDidEnterBackground(_ aNotification: Notification) {
        if self.player != nil {
            self.player.pause()
        }
    }
    @objc internal func applicationDidBecomeActive(_ aNoticiation: Notification) {
        if self.player != nil {
            self.player.play()
        }
    }
    
    func playVideo() {
        
        var playUrl = ""
        if appContants.appName == .reeldrama {
            if let path = Bundle.main.url(forResource: "reeldramaIntro", withExtension: ".mp4")?.path {
                playUrl = path
            }
        }
        else if appContants.appName == .aastha {
            if productType.iPad {
                if let path = Bundle.main.url(forResource: "aasthaIntro_iPad", withExtension: ".mp4")?.path {
                    playUrl = path
                }
            }
            else {
                if let path = Bundle.main.url(forResource: "aasthaIntro_iPhone", withExtension: ".mp4")?.path {
                    playUrl = path
                }
            }
        }
        else if appContants.appName == .mobitel {
            if let path = Bundle.main.url(forResource: "mobitelIntro", withExtension: ".mp4")?.path {
                playUrl = path
            }
            
        }
        
        if playUrl.count > 0 {
            self.addApplicationObservers()
            let playerItem = AVPlayerItem.init(url: URL.init(fileURLWithPath: playUrl))
            player = AVPlayer.init(playerItem: playerItem)
            avPlayerLayer = AVPlayerLayer.init(player: player)
            avPlayerLayer.frame = self.view.frame
            if appContants.appName == .aastha && productType.iPhone {
                avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
            }
            self.view.layer.addSublayer(avPlayerLayer)
            self.view.bringSubviewToFront(self.videoSkipBtn)
            player.play()
            player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidPlayToEndTime(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        else {
            print("Oops, something wrong when playing video.mp4")
        }
    }

    @objc internal func playerItemDidPlayToEndTime(_ aNotification: Notification) {
        if isSupportedToUser == nil {
            self.initializeSDK(isSkipBtn: true)
        }
        else {
            self.moveToNextPage()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Utilities.hasConnectivity() {
                AppDelegate.getDelegate().isDirectDownloadsPage = false
                self.checkInternetConectionBtn.isHidden = true
                self.internetStatusLbl.isHidden = true
                //#warning commenting welcome video temporarily
                if appContants.appName == .reeldrama || appContants.appName == .aastha || appContants.appName == .mobitel {
                    self.splashScreenImgView.isHidden = true
                    self.playVideo()
                    String.welcomeVideoStatus = "YES"
                    self.videoSkipBtn.isHidden = true
                    self.initializeSDK(isSkipBtn: false)
                }else {
                    self.videoSkipBtn.isHidden = true
                    self.splashScreenImgView.isHidden = false
                    self.initializeSDK(isSkipBtn: true)
                }
                /*if (String.welcomeVideoStatus .isEmpty) {
                 /*
                 self.splashScreenImgView.isHidden = true
                 self.playVideo()
                 String.welcomeVideoStatus = "YES"
                 self.initializeSDK(isSkipBtn: false)
                 */
                 self.videoSkipBtn.isHidden = true
                 self.splashScreenImgView.isHidden = true
                 self.initializeSDK(isSkipBtn: true)
                 }
                 else {
                 self.splashScreenImgView.isHidden = true
                 self.initializeSDK(isSkipBtn: true)
                 }*/
        }
        else{
            if #available(iOS 10.0, *), AppDelegate.getDelegate().fetchStreamList().count > 0 {
                self.moveToDownloadPage()
                AppDelegate.getDelegate().initAnalytics()
            } else {
                AppDelegate.getDelegate().isDirectDownloadsPage = false
                self.stopAnimating()
                self.checkInternetConectionBtn.isHidden = false
                self.internetStatusLbl.isHidden = false
                self.videoSkipBtn.isHidden = true
                self.splashScreenImgView.isHidden = true
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            }
        }
    }
    
    func initializeSDK(isSkipBtn:Bool) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()) {
                self.startAnimating(allowInteraction: true)
                self.initializeSDK(isSkipBtn: isSkipBtn)
            }
            return
        }
        var appVersion = "1.0"
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = currentVersion
        }
        
        let setttings = ["serviceType": appContants.serviceType , "logType" : appContants.logType ,"requestTimeout" : 60, "appName" : appContants.appName, "clientAppVersion": appVersion] as [String : Any]
        _ = OTTSdk.init(settings: setttings) { (isSupported, error) in
            self.isSupportedToUser = isSupported
            
            if (error != nil){
                self.stopAnimating()
                self.showAlertWithText(message: error!.message) {
                    self.startAnimating(allowInteraction: true)
                    self.initializeSDK(isSkipBtn: isSkipBtn)
                }
            }
            else{
                self.checkForUpdate(proceed: { (shouldProceed) in
                    var languageStr = ""
                    if OTTSdk.preferenceManager.selectedLanguages.isEmpty == false {
                        languageStr = OTTSdk.preferenceManager.selectedLanguages
                    }
                    OTTSdk.userManager.updatePreference(selectedLanguageCodes: languageStr, sendEmailNotification: false, onSuccess: { (successMessage) in
                        if shouldProceed{
                            if isSkipBtn {
                                self.moveToNextPage()
                            }
                        }
                    }) { (error) in
                        if shouldProceed{
                            if isSkipBtn {
                                self.moveToNextPage()
                            }
                        }
                    }
                })
            }
        }
    }

    func checkForUpdate(proceed : @escaping (Bool) -> Void){
        /*
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let latestVersion = "2.0"
            let clientInfoDescription = "update available"
            let updateType = 1
           
            }
            else{
                print("no need")
            }
        }
        */
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                self.checkInternetConectionBtn.isHidden = false
                self.internetStatusLbl.isHidden = false
                return
            }

            OTTSdk.checkForUpdate(onSuccess: { (locationResponse) in
                if locationResponse.clientInfo.versionNumber.compare(currentVersion, options: .numeric) == .orderedDescending {
                    self.stopAnimating()
                    let alert = UIAlertController(title: String.getAppName(), message: locationResponse.clientInfo.clientInfoDescription, preferredStyle: .alert)
                    
                    let messageAlertAction = UIAlertAction(title: "Update".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        print("Redirect to appstore link")
                        if let url = URL(string: Constants.OTTUrls.appStoreLink ),//"itms-apps://itunes.apple.com/app/id1024941703"
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    })
                    
                    let cancelAlertAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                        print("Cancel")
                        proceed(true)
                    })
                    
                    if locationResponse.clientInfo.updateType == 1{
                        alert.addAction(messageAlertAction)
                    }
                    else{
                        alert.addAction(messageAlertAction)
                        alert.addAction(cancelAlertAction)
                    }
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    proceed(true)
                }
            }) { (error) in
                proceed(true)
            }
        }
    }
    
    @objc func checkForUpdateNotify(){
        /*
         if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
         let latestVersion = "2.0"
         let clientInfoDescription = "update available"
         let updateType = 1
         
         }
         else{
         print("no need")
         }
         }
         */
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            
            OTTSdk.checkForUpdate(onSuccess: { (locationResponse) in
                if locationResponse.clientInfo.versionNumber.compare(currentVersion, options: .numeric) == .orderedDescending {
                    
                    let alert = UIAlertController(title: String.getAppName(), message: locationResponse.clientInfo.clientInfoDescription, preferredStyle: .alert)
                    
                    let messageAlertAction = UIAlertAction(title: "Update".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        print("Redirect to appstore link")
                        if let url = URL(string: Constants.OTTUrls.appStoreLink ),//"itms-apps://itunes.apple.com/app/id1024941703"
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    })
                    
                    let cancelAlertAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                        print("Cancel")
                        self.moveToNextPage()
                    })
                    
                    if locationResponse.clientInfo.updateType == 1{
                        alert.addAction(messageAlertAction)
                    }
                    else{
                        alert.addAction(messageAlertAction)
                        alert.addAction(cancelAlertAction)
                    }
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                }
            }) { (error) in
            }
        }
    }
    
    func moveToNextPage() {
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = false
        if productType.iPhone {
            let value1 = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value1, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        if isSupportedToUser == false{
            
            let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
            let vc = homeStoryboard.instantiateViewController(withIdentifier: "DefaultViewController") as! DefaultViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: {
            })
        }
        else {
            self.stopAnimating()
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                AppDelegate.getDelegate().configs = response.configs
                AppDelegate.getDelegate().setConfigResponce(response.configs)

                OTTSdk.appManager.updateLocation(onSuccess: { (response) in
                    AppDelegate.getDelegate().country = response.ipInfo.country
                    AppDelegate.getDelegate().city = response.ipInfo.city
                    AppDelegate.getDelegate().trueip = response.ipInfo.trueIP
                    AppDelegate.getDelegate().latitude = response.ipInfo.latitude
                    AppDelegate.getDelegate().longitude = response.ipInfo.longitude
                    let countryCode = response.ipInfo.countryCode
                    let countryList = (AppDelegate.getDelegate().configs?.allowedCountriesList)!.components(separatedBy: ",")
                    if countryList.contains(countryCode) || (AppDelegate.getDelegate().configs?.allowedCountriesList)! .isEmpty {
                        if OTTSdk.preferenceManager.user == nil {
                            if AppDelegate.getDelegate().openSharedVideo {
                                let urlStrArr = AppDelegate.getDelegate().sharedAbsoluteString.components(separatedBy: "\(String(describing: AppDelegate.getDelegate().configs?.siteURL))/")
                                if (urlStrArr.count) > 1 {
                                    AppDelegate.getDelegate().deepLinkingString = (urlStrArr[1])
                                    if AppDelegate.getDelegate().fromLaunchApp {
                                        AppDelegate.getDelegate().fromLaunchApp = false
                                        if playerVC != nil {
                                            playerVC?.removeViews()
                                            playerVC = nil
                                        }else if otherPlayerVC != nil {
                                            otherPlayerVC?.removeViews()
                                            otherPlayerVC = nil
                                        }
                                        AppDelegate.getDelegate().loadHomePage()
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                                        }
                                    }
                                }
                                
                            }
                            else {
                                if OTTSdk.preferenceManager.selectedDisplayLanguage == nil {
                                    OTTSdk.appManager.configuration(onSuccess: { (response) in
                                        AppDelegate.getDelegate().configs = response.configs
                                        AppDelegate.getDelegate().setConfigResponce(response.configs)
                                        
                                        self.checkForIntroScreenAndProceed()
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
                                        
                                    }, onFailure: { (error) in
                                        self.showAlertWithText(message: error.message)
                                        print(error.message)
                                        
                                    })
                                }
                                else {
                                    if AppDelegate.getDelegate().pushNotificationPayLoad.count > 0 {
                                        let notificationPayLoad = AppDelegate.getDelegate().pushNotificationPayLoad
                                        if notificationPayLoad["launchurl"] != nil {
                                            AppDelegate.getDelegate().deepLinkingString = notificationPayLoad["launchurl"] as! String
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
                                        else {
                                            self.checkForIntroScreenAndProceed()
                                        }
                                    }
                                    else {
                                        OTTSdk.appManager.configuration(onSuccess: { (response) in
                                            AppDelegate.getDelegate().configs = response.configs
                                            AppDelegate.getDelegate().setConfigResponce(response.configs)
                                            self.checkForIntroScreenAndProceed()
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
                                            
                                        }, onFailure: { (error) in
                                            self.showAlertWithText(message: error.message)
                                            print(error.message)
                                            
                                        })
                                    }
                                }
                            }
                        }
                        else {
                            let userAttributes = OTTSdk.preferenceManager.user?.attributes
                            if !(userAttributes?.timezone .isEmpty)! {
                                NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
                            }
                            let actionCode = -1
                            TargetPage.userNavigationPage(fromViewController: self, shouldUpdateUserObj: true,actionCode: actionCode) { (pageType) in
                                switch pageType {
                                case .home :
                                    AppDelegate.getDelegate().loadHomePage()
                                    self.handleDeepLinking()
                                    break;
                                case .packages:
                                    AppDelegate.getDelegate().loadNoPackagesPage()
                                    break;
                                case .userProfile:
                                    let userProfileVC = TargetPage.userProfileViewController()
                                    let nav = UINavigationController.init(rootViewController: userProfileVC)
                                    nav.isNavigationBarHidden = true
                                    AppDelegate.getDelegate().window?.rootViewController = nav
                                    break;
                                case .OTP:
                                    let otpVC = TargetPage.otpViewController()
                                    otpVC.actionCode = actionCode
                                    let nav = UINavigationController.init(rootViewController: otpVC)
                                    nav.isNavigationBarHidden = true
                                    AppDelegate.getDelegate().window?.rootViewController = nav
                                    break;
                                case .unKnown:
                                    self.showAlertWithText(message: "Something went wrong")
                                    break;
                                }
                            }
                            
                            
                        }
                    } else {
                        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
                        let vc = homeStoryboard.instantiateViewController(withIdentifier: "DefaultViewController") as! DefaultViewController
                        vc.delegate = self
                        vc.isNoContentForCountryView = true
                        self.present(vc, animated: true, completion: {
                        })
                    }
                    
                }) { (error) in
                    
                }
                
            }) { (error) in
                
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            OTTSdk.appManager.otpFeaturesAPI { (optFeatures) in
                Log(message: "\(optFeatures)")
                AppDelegate.otpAuthenticationFields = optFeatures.otpauthentication.fields
                AppDelegate.getDelegate().resendOtpLimit = optFeatures.otpauthentication.fields.max_otp_resend_attempts
            } onFailure: { (otpError) in
                Log(message: "\(otpError)")
            }
            AppDelegate.getDelegate().checkAndUpdateClientAppVersion()
        }
    }
    func handleDeepLinking(){
        if AppDelegate.getDelegate().pushNotificationPayLoad.count > 0 {
            let notificationPayLoad = AppDelegate.getDelegate().pushNotificationPayLoad
            if notificationPayLoad["launchurl"] != nil {
                AppDelegate.getDelegate().deepLinkingString = notificationPayLoad["launchurl"] as! String
                if playerVC != nil {
                    playerVC?.removeViews()
                    playerVC = nil
                }else if otherPlayerVC != nil {
                    otherPlayerVC?.removeViews()
                    otherPlayerVC = nil
                }
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
        else {
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                let clientConfig = response.configs
                AppDelegate.getDelegate().configs = response.configs
                AppDelegate.getDelegate().setConfigResponce(response.configs)
                let urlStrArr = AppDelegate.getDelegate().sharedAbsoluteString.components(separatedBy: "\(clientConfig.siteURL)/")
                if (urlStrArr.count) > 1 {
                    AppDelegate.getDelegate().deepLinkingString = (urlStrArr[1])
                    if AppDelegate.getDelegate().fromLaunchApp {
                        AppDelegate.getDelegate().fromLaunchApp = false
                        if playerVC != nil {
                            playerVC?.removeViews()
                            playerVC = nil
                        }else if otherPlayerVC != nil {
                            otherPlayerVC?.removeViews()
                            otherPlayerVC = nil
                        }
                        AppDelegate.getDelegate().loadHomePage()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                        }
                    }
                }
            }, onFailure: { (error) in
                self.showAlertWithText(message: error.message)
                print(error.message)
            })
        }
    }
    func checkForIntroScreenAndProceed() {
        let userDefaults = UserDefaults.standard
        //#warning("by passing intro page as per requirement")
//        userDefaults.set(true, forKey: "ShowIntroScreen")
//        userDefaults.removeObject(forKey: "ShowIntroScreen")
        if userDefaults.object(forKey: "ShowIntroScreen") == nil {
            userDefaults.set(true, forKey: "ShowIntroScreen")
            userDefaults.synchronize()
            let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
            let vc = homeStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
            let nav = UINavigationController.init(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            AppDelegate.getDelegate().window?.rootViewController = nav
            AppDelegate.getDelegate().loadContentLanguagePage()
        } else {
//            if OTTSdk.preferenceManager.user != nil {
                AppDelegate.getDelegate().loadHomePage()
            /* } else {
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                storyBoardVC.viewControllerName = "SignInVC"
                let nav = UINavigationController.init(rootViewController: storyBoardVC)
                nav.isNavigationBarHidden = true
                AppDelegate.getDelegate().window?.rootViewController = nav
            } */
        }
    }
    public func moveToDownloadPage() {
        let listVC = TargetPage.moviesViewController()
        listVC.isToViewMore = true
        listVC.sectionTitle = "My Downloads"
        listVC.isMyDownloadsSection = true
        let nav = UINavigationController.init(rootViewController: listVC)
        nav.isNavigationBarHidden = true
        AppDelegate.getDelegate().isDirectDownloadsPage = true
        AppDelegate.getDelegate().window?.rootViewController = nav
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if (coordinator as UIViewControllerTransitionCoordinator?) != nil {
            if avPlayerLayer != nil{
                avPlayerLayer.frame.size = size
            }
        }
    }

     // MARK: - DefaultViewControllerDelegate
    func retryTap(){
        
        self.startAnimating(allowInteraction: false)
        OTTSdk.forceReset { (isSupported, error) in
            self.stopAnimating()
            if isSupported == false{
            }
            else {
                self.stopAnimating()
                AppDelegate.getDelegate().loadHomePage()
            }
        }
    }

    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }

    func showAlertWithText (_ header : String = String.getAppName(), message : String, finished : @escaping() -> Void) {
        self.stopAnimating()
        let alert = UIAlertController(title: String.getAppName() , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok".localized, style: UIAlertAction.Style.default) { (alertAction) in
            finished()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getUserAgent() {
        //if #available(iOS 12.0, *) {
            let webConfiguration = WKWebViewConfiguration()
            WKwebView = WKWebView(frame: .zero, configuration: webConfiguration)
            WKwebView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
                debugPrint(result as Any)
                debugPrint(error as Any)
                
                if let unwrappedUserAgent = result as? String {
                    print("userAgent: \(unwrappedUserAgent)")
                    AppDelegate.getDelegate().userAgent = unwrappedUserAgent
                } else {
                    print("failed to get the user agent")
                }
            })
        //}
        //else{
          //  AppDelegate.getDelegate().userAgent = ""
        //}
    }

}
