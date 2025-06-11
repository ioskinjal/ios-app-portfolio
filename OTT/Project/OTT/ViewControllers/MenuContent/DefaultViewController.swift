//
//  DefaultViewController.swift
//  OTT
//
//  Created by Muzaffar on 05/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol DefaultViewControllerDelegate {
    func retryTap()
}
class DefaultViewController: UIViewController,GADBannerViewDelegate {
    @IBOutlet weak var noContentForCountry: UIView!
    
    @IBOutlet weak var pageNotFoundLblMsg: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet var favSignInLbl: UILabel!
    @IBOutlet weak var pageNotFoundView: UIView!
    @IBOutlet weak var favouriteSignInView: UIView!
    var delegate : DefaultViewControllerDelegate?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var pageDoesntExistLbl: UILabel!
    @IBOutlet weak var pageNotFoundLbl: UILabel!
    @IBOutlet weak var watchlistLbl : UILabel!
    @IBOutlet weak var signinErrorLabel : UILabel!
    var isFavView : Bool = false
    var isMyLibraryView : Bool = false
    var isNoContentForCountryView : Bool = false
    var isAfterDarkView : Bool = false
    var menuItem : Menu!
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerAdView: UIView!
    @IBOutlet weak var defaultStackView : UIStackView!
    @IBOutlet var logoView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        watchlistLbl.isHidden = true
        signInBtn.setTitle("Sign in".localized, for: .normal)
        signInBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        signInBtn.cornerDesignWithoutBorder()
        signUpBtn.cornerDesignWithoutBorder()
        signUpBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        signUpBtn.setTitle("Signup".localized, for: .normal)
        signUpBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        signUpBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        signUpBtn.titleLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        signInBtn.titleLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        favSignInLbl.font = UIFont.ottRegularFont(withSize: 16.0)
        favSignInLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.pageNotFoundLbl.text = "Page not found".uppercased().localized
        self.tryAgainBtn.setTitle("Back to Home".uppercased().localized, for: UIControl.State.normal)
        
        signinErrorLabel.text = "Sign in or Join \(String.getAppName()) to enjoy uninterrupted services"
        signinErrorLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.backButtonTap(_:)), name: NSNotification.Name(rawValue: "GobackFromErrorPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        logoView.removeFromSuperview()
        favSignInLbl.removeFromSuperview()
        defaultStackView.removeArrangedSubview(logoView)
        defaultStackView.removeArrangedSubview(favSignInLbl)
        if appContants.appName == .gotv {
            defaultStackView.addArrangedSubview(logoView)
        }else {
            defaultStackView.addArrangedSubview(favSignInLbl)
        }
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        if self.isFavView {
            self.favouriteSignInView.isHidden = false
            self.pageNotFoundView.isHidden = true
            self.noContentForCountry.isHidden = true
            self.favSignInLbl.text = "To get access to watch the content"
        }else if self.isAfterDarkView {
            self.favouriteSignInView.isHidden = false
            self.pageNotFoundView.isHidden = true
            self.noContentForCountry.isHidden = true
            self.favSignInLbl.text = ""
            signinErrorLabel.text = "\(String.getAppName()) After Dark content only visible when you are signed-In. If you are New User you need to Sign-Up & register  for this content.".localized
            if let menu = menuItem, let params = menu.params, params.isLoginRequired == true, params.loginMessage.count > 0 {
                signinErrorLabel.text = params.loginMessage
            }
        }else if self.isMyLibraryView {
            self.favouriteSignInView.isHidden = false
            self.pageNotFoundView.isHidden = true
            self.noContentForCountry.isHidden = true
            self.favSignInLbl.text = "Please Sign In to view ‘My Library’."
        }else if self.isNoContentForCountryView {
            self.favouriteSignInView.isHidden = true
            self.pageNotFoundView.isHidden = true
            self.noContentForCountry.isHidden = false
        }
        else {
            self.favouriteSignInView.isHidden = true
            self.noContentForCountry.isHidden = true
            self.pageNotFoundView.isHidden = false
        }
        if self.navigationController == nil{
            self.backButton.isHidden = true
            if OTTSdk.preferenceManager.user == nil && appContants.appName == .firstshows {
                watchlistLbl.isHidden = false
            }
        }
        self.pageNotFoundLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.tryAgainBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        
        if AppDelegate.getDelegate().isTabsPage {
            self.tryAgainBtn.isHidden = true
        } else {
            self.tryAgainBtn.isHidden = false
        }
        self.loadBannerAd()
        self.updateDocPlayerFrame()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppDelegate.getDelegate().isTabsPage {
            self.navBarHeightConstraint.constant = 0.0
        } else {
            self.navBarHeightConstraint.constant = 60.0
            self.navigationBarView.cornerDesign()
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is DefaultViewController {
            self.updateDocPlayerFrame()
        }
    }
    @IBAction func tryAgainTap(_ sender: UIButton) {
        AppDelegate.getDelegate().loadHomePage()
    }

    @IBAction func backButtonTap(_ sender: UIButton) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signInBtnCLicked(_ sender: Any) {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Sign in")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "SignInVC"
        storyBoardVC.isFromFavLibTab = true
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        storyBoardVC.viewControllerName = "SignUpVC"
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadBannerAd(){
        
        var tempBannerUnitId = ""
        tempBannerUnitId = AppDelegate.getDelegate().defaultBannerAdTag
        
        if AppDelegate.getDelegate().showBannerAds && !tempBannerUnitId.isEmpty{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                let bannerView = DFPBannerView(adSize:kGADAdSizeBanner)
                let request = DFPRequest()
                //#warning("comment test devices")
                //                request.testDevices = [kGADSimulatorID,"46805d24bda9feaa573e40056cd97b73"]
                bannerView.adUnitID = tempBannerUnitId
                bannerView.rootViewController = self
                bannerView.delegate = self
                bannerView.load(request)
                self.bannerAdView.addSubview(bannerView)
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                
                // Layout constraints that align the banner view to the bottom center of the screen.
                self.bannerAdView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal,
                                                                   toItem: self.bannerAdView, attribute: .top, multiplier: 1, constant: 0))
                self.bannerAdView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal,
                                                                   toItem: self.bannerAdView, attribute: .centerX, multiplier: 1, constant: 0))
                
            })
        }
        else{
            self.hideBannerAd()
        }
        
    }
    func hideBannerAd(){
        self.adBannerViewHeightConstraint.constant = 0.0
        self.collectionViewbottomConstarint?.constant = 5.0
        self.updateDocPlayerFrame()

    }
    func updateDocPlayerFrame() {
        if playerVC != nil {
            playerVC!.bannerAdFoundExceptPlayer = (self.adBannerViewHeightConstraint.constant == 0 ? false : true)
            if playerVC!.isMinimized {
                playerVC?.updateMinViewFrame()
            }
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.hideBannerAd()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.adBannerViewHeightConstraint.constant = 50.0
        self.collectionViewbottomConstarint?.constant = 5.0
        self.updateDocPlayerFrame()
    }
}
