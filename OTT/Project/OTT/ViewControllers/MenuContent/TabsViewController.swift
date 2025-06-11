//
//  TabsViewController.swift
//  sampleColView
//
//  Created by Chandrasekhar on 03/07/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
import AVFoundation
import GoogleCast

struct ToolbarTitle {
    var title : String{
        set{
            barTitle = newValue
            if barTitle.isEmpty{
                answerHeight = 40
            }
            else{
                let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 47)
                let boundingBox = barTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
                answerHeight = boundingBox.width + 10
            }
        }
        get{
            return barTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var barTitle = ""
}

struct ToolbarSubTitle {
    var title : String{
        set{
            barSubTitle = newValue
            
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 47)
            let boundingBox = barSubTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
            answerHeight = boundingBox.width + 10
        }
        get{
            return barSubTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var barSubTitle = ""
}

struct langTitle {
    var title : String{
        set{
            langTitle = newValue
            
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 47)
            let boundingBox = langTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
            answerHeight = boundingBox.width + 10
        }
        get{
            return langTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var langTitle = ""
}

protocol LanguageSelectionProtocal {
    func refreshTheContent() -> Void
}

class TabsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,iShowcaseDelegate,DefaultViewControllerDelegate,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate, PartialRenderingViewDelegate, PlayerViewControllerDelegate {
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    static var shouldHideSearchButton = true
    static var isWatchListFromMenu = false
    @IBOutlet weak var searchButtonWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var langBtn: UIButton!
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var HomeToolBarCollection: UICollectionView!
    @IBOutlet weak var menuIcon: UIButton!
    @IBOutlet weak var menuIconWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var appLogoImageView: UIImageView!

    @IBOutlet weak var HomeLangCollectionView: UICollectionView!
    @IBOutlet weak var subMenuCollectionView: UICollectionView!
    @IBOutlet weak var subMenuCollectionViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorLabel: UILabel!

    @IBOutlet weak var chromeButtonView: UIView!
    
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var testButton:UIButton!
    @IBOutlet weak var testButtonWidthConstraint : NSLayoutConstraint?
    @IBOutlet weak var subMenuCollectionViewTopConstraint: NSLayoutConstraint!
    
    /*
    private static var _partialRenderingView : PartialRenderingView?
//    static var partialRenderingView : PartialRenderingView{
//        get{
//            if partialRenderingView == nil{
//                let prv = PartialRenderingView.init(frame: AppDelegate.getDelegate().window!.bounds)
//                prv.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
//                TabsViewController.instance.view.addSubview(prv)
//                //        prv.addToView(superView: self.view)
//                return;
//
//
//
//
//            }
//            retrun _partialRenderingView!
//        }
//    }
*/
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20

    weak var currentViewController: UIViewController?
    var selectedIndexPath:IndexPath!
    var selectedLangIndexPath:IndexPath!
    var selectedMenuRow = 0
    var isLangSelected = false

    var updatingViewController: UIViewController?
    var tabsControllers = [String : UIViewController]()
    var tabsControllersRefreshStatus = [String : Bool]()
    var cCFL: CustomFlowLayout!
    var subMenuCFL: CustomFlowLayout!
    var lCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 2.0)
    let langsecInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 2.0)
    var cellSizes: CGSize = CGSize(width: 80, height: 47)
    var langcellSizes: CGSize = CGSize(width: 100, height: 47)
    let numColums: CGFloat = 2
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 2
    let langMinLineSpacing: CGFloat = 2
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    var delegate : LanguageSelectionProtocal?

    var languagesArray = [Language]()
    var languageNameArray = [langTitle]()

    var menus = [Menu]()
    var initialMenuTargeted = String()
    var toolBarTitlesArray = [ToolbarTitle]()
    var subMenuTitleArray = [SubMenu]()
    var toolBarSubTitlesArray = [ToolbarSubTitle]()
    var selectedSubMenuRow = 0
    var selectedSubMenuIndexPath:IndexPath!
    let excludedMenuCodes = ["pricing"]
    //MARK: - Life Cycle Methods
    

    public class var instance: TabsViewController {
        struct Singleton {
            static let obj = UIStoryboard(name: "Tabs", bundle:nil).instantiateViewController(withIdentifier: "TabsViewController") as! TabsViewController
        }
        return Singleton.obj
    }
    var statusBarView: UIView? {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: statusBarHeight))
        statusbarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        return statusbarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* if AppDelegate.getDelegate().supportButtonBottomConstraint == nil {
            let supportButtonTrailingAnchor =
            AppDelegate.getDelegate().supportButton.trailingAnchor.constraint(equalTo: AppDelegate.getDelegate().window!.trailingAnchor)
            supportButtonTrailingAnchor.constant = -5
            supportButtonTrailingAnchor.isActive = true
            AppDelegate.getDelegate().supportButtonBottomConstraint = AppDelegate.getDelegate().supportButton.bottomAnchor.constraint(equalTo: AppDelegate.getDelegate().window!.bottomAnchor)
            AppDelegate.getDelegate().supportButtonBottomConstraint!.isActive = true
        }*/
        
        self.view.addSubview(statusBarView!)
        if appContants.appName == .gac {
            self.view.backgroundColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        }
        else {
            self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        }
        self.ContainerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor.withAlphaComponent(0.5)
        self.seperatorLabel.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.selectedIndexPath = NSIndexPath.init(item: 0, section: 0) as IndexPath
        self.selectedLangIndexPath = NSIndexPath.init(item: 0, section: 0) as IndexPath
        self.selectedSubMenuIndexPath = NSIndexPath.init(item: 0, section: 0) as IndexPath
        self.selectedMenuRow = 0
        self.selectedSubMenuRow = 0
        self.menuNameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.menuNameLabel.font = UIFont.ottRegularFont(withSize: 17)
//        self.HomeLangCollectionView.register(UINib(nibName: "langCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "langCollectionViewCell")
        
         //appLogoImageView.image = UIImage(named: "appLogo")!
        
        if appContants.appName == .mobitel {
            appLogoImageView.contentMode = .scaleAspectFill
        }
        
        let customButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: CGFloat(40), height: CGFloat(40)))
        customButton.tintColor = AppTheme.instance.currentTheme.chromecastIconColor
        self.chromeButtonView.addSubview(customButton)
        if appContants.isChromeCastEnabled &&  AppDelegate.getDelegate().supportChromecast {
            self.chromeButtonView.isHidden = false
        }
        else {
            self.chromeButtonView.isHidden = true
        }
//        let gckDeviceScannerObserver = GCKDeviceScanner.init(filterCriteria: GCKFilterCriteria.init())
//        gckDeviceScannerObserver.add(self)
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        
        
        let castContext = GCKCastContext.sharedInstance()
        
        /*if castContext.castState == .noDevicesAvailable {
            self.chromeButtonView.isHidden = true
//            self.castbtnWidthConstraint.constant = 0.0
//            self.chromecastButtonTrailingConstraint.constant = 0.0
        }
        else{*/
            if appContants.isChromeCastEnabled &&  AppDelegate.getDelegate().supportChromecast {
                self.chromeButtonView.isHidden = false
//                self.castbtnWidthConstraint.constant = 40.0
//                self.chromecastButtonTrailingConstraint.constant = 10.0
            }
            else {
                self.chromeButtonView.isHidden = true
//                self.castbtnWidthConstraint.constant = 0.0
//                self.chromecastButtonTrailingConstraint.constant = 0.0
            }
        //}
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
        updateNavigationBarItem(menu: nil)
        
       self.getMenuDetails(isFinished: { (isFinished) in })
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.LangBtnClicked(_:)))
        singleTap.delegate = self
        self.langLbl.addGestureRecognizer(singleTap)
        
        if AppDelegate.getDelegate().isCallSupported {
            self.callBtn.isHidden = true
        }
        else {
            self.callBtn.isHidden = true
        }
        self.callBtn.setTitle("Call".localized, for: UIControl.State.normal)
        self.testButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.testButton.cornerDesignWithoutBorder()
    
        
//        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationBar.layer.shadowOffset = CGSize.init(width: 0.8, height: 0)
//        self.navigationBar.layer.shadowOpacity = 1.0
//        self.navigationBar.layer.shadowRadius = 1.0
//        self.navigationBar.clipsToBounds = false
//        self.navigationBar.layer.masksToBounds = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSharedVideo), name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)

        self.navigationBar.cornerDesign()
        playLastWatchedChannelIfAvalilable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.subMenuCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func updateNavigationBarItem(menu:Menu?) {
        self.navigationBar.isHidden = true
        self.chromeButtonView.isHidden = true
        self.menuNameLabel.isHidden = true
        self.navigationBarHeightConstraint.constant = 0
        self.subMenuCollectionViewTopConstraint.constant = appContants.appName == .gac ? 0 : 1.0
        navigationBar.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        if (appContants.appName == .firstshows && selectedMenuRow == 0) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if appContants.appName == .aastha {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.subMenuCollectionViewTopConstraint.constant = 0.0
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .gotv && selectedMenuRow == 0) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .yvs && selectedMenuRow == 0) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .supposetv) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .mobitel) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .pbns) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if (appContants.appName == .airtelSL) {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
        }
        else if appContants.appName == .tsat {
            self.navigationBar.isHidden = false
            self.chromeButtonView.isHidden = false
            self.navigationBarHeightConstraint.constant = 50
            self.menuIconWidthConstraint?.constant = 52
        }
        else if (appContants.appName == .gac) {
            if menu != nil
            {
                if menu!.code == "home_mobile" {
                    self.navigationBar.isHidden = false
                    self.chromeButtonView.isHidden = false
                    self.navigationBarHeightConstraint.constant = 50
                    self.menuNameLabel.isHidden = true
                    self.appLogoImageView.isHidden = false
                }
                else if menu!.code == "community" ||  menu!.code == "watchlist" {
                    self.navigationBar.isHidden = false
                    self.chromeButtonView.isHidden = true
                    self.navigationBarHeightConstraint.constant = 50
                    self.menuNameLabel.isHidden = false
                    self.menuNameLabel.text = menu!.displayText
                    self.appLogoImageView.isHidden = true
                }
                else {
                    self.navigationBar.isHidden = true
                    self.chromeButtonView.isHidden = true
                    self.navigationBarHeightConstraint.constant = 0
                    self.menuNameLabel.isHidden = true
                }
            }
            else {
                self.navigationBar.isHidden = false
                self.chromeButtonView.isHidden = false
                self.navigationBarHeightConstraint.constant = 50
                self.menuNameLabel.isHidden = true
                self.appLogoImageView.isHidden = false
            }
            self.subMenuCollectionViewTopConstraint.constant = 0.0
        }
    }
    @objc func loadSharedVideo() {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        if AppDelegate.getDelegate().deepLinkingString.count <= 0 || AppDelegate.getDelegate().deepLinkingString.lowercased() == "/packages" || AppDelegate.getDelegate().deepLinkingString.lowercased() == "packages" || AppDelegate.getDelegate().deepLinkingString.lowercased() == "pricing" || AppDelegate.getDelegate().deepLinkingString.lowercased() == "/pricing" {
            return
        }
        if AppDelegate.getDelegate().deepLinkingString == AppDelegate.getDelegate().favouritesTargetPath {
            if OTTSdk.preferenceManager.user == nil {
                let defaultVC = TargetPage.defaultViewController()
                defaultVC.isFavView = true
                defaultVC.isMyLibraryView = false
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(defaultVC, animated: true)
                return
            } else {
                FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (result) in
                    self.navigationController?.pushViewController(FavouritesListViewController.instance, animated: true)
                })
                return
            }
        }
        else {
            self.startAnimating(allowInteraction: false)
            TargetPage.getTargetPageObject(path: AppDelegate.getDelegate().deepLinkingString) { (viewController, pageType) in
                
                if let vc = viewController as? PlayerViewController{
                    vc.delegate = self
                    AppDelegate.getDelegate().window?.addSubview(vc.view)
                }
                else if viewController is DefaultViewController {
                    let menuIndex = self.checkIsMenuTab()
                    if menuIndex >= 0 {
                        let scrollIndex = IndexPath(row: menuIndex, section: 0)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                            TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition:UICollectionView.ScrollPosition.right)
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
                            TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition:UICollectionView.ScrollPosition.right)
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
                            TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition:UICollectionView.ScrollPosition.right)
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
                            TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition:UICollectionView.ScrollPosition.right)
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
                self.stopAnimating()
            }
        }
    }

    func checkIsMenuTab() -> Int {
        var menuIndex = -1
        for (index,menu) in TabsViewController.instance.menus.enumerated() {
            if menu.targetPath == AppDelegate.getDelegate().deepLinkingString {
                menuIndex = index
            }
        }
        return menuIndex
    }

    func didSelectedSuggestion(card: Card) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path: card.target.path) { (viewController, pageType) in
            if let vc = viewController as? ContentViewController{
                vc.isToViewMore = true
                vc.sectionTitle = card.display.title
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = card.display.imageUrl
                vc.playingItemTitle = card.display.title
                vc.playingItemSubTitle = card.display.subtitle1
                vc.playingItemTargetPath = card.target.path
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = card.display.title
                vc.isCircularPoster = card.cardType == .circle_poster ? true : false
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if (viewController is DefaultViewController){
                let defaultViewController = viewController as! DefaultViewController
                defaultViewController.delegate = self
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            else if let vc = viewController as? ListViewController{
                vc.isToViewMore = true
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            self.stopAnimating()
        }

    }

    func playLastWatchedChannelIfAvalilable(){
        
        if AppDelegate.getDelegate().configs?.playLastChannelOnLaunch ?? false{
            if (appContants.lastWatchedContentPaths?.count ?? 0 > 0), let user = OTTSdk.preferenceManager.user, user.packages.count > 0 {
                let path = appContants.lastWatchedContentPaths!.last!
                TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
                    self.stopAnimating()
                    if let vc = viewController as? PlayerViewController{
                        //                    vc.defaultPlayingItemUrl = item.display.imageUrl
                        //                    vc.playingItemTitle = item.display.title
                        //                    vc.playingItemSubTitle = item.display.subtitle1
                        vc.playingItemTargetPath = path
//                        vc.partialRenderingViewDelegate = self
                        AppDelegate.getDelegate().window?.addSubview(vc.view)
                    }
                }
            }
        }
    }

    @objc func castDeviceDidChange(_ notification: Notification) {
        if GCKCastContext.sharedInstance().castState == .noDevicesAvailable {
            self.chromeButtonView.isHidden = true
//            self.castbtnWidthConstraint.constant = 0.0
//            self.chromecastButtonTrailingConstraint.constant = 0.0
        }
        else{
            if appContants.isChromeCastEnabled &&  AppDelegate.getDelegate().supportChromecast {
                self.chromeButtonView.isHidden = false
//                self.castbtnWidthConstraint.constant = 40.0
//                self.chromecastButtonTrailingConstraint.constant = 10.0
            }
            else {
                self.chromeButtonView.isHidden = true
//                self.castbtnWidthConstraint.constant = 0.0
//                self.chromecastButtonTrailingConstraint.constant = 0.0
            }
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().isTabsPage = true
        if playerVC != nil && (playerVC?.isMinimized)! {
            playerVC?.setScaleFactor()
            playerVC?.minimizeViews()
        }
        let showcase = iShowcase()
        showcase.delegate = self
//        showcase.setupShowcaseForView(self.HomeLangCollectionView)
        showcase.titleLabel.text = "Choose between multiple languages and watch the content of your choice"
        showcase.type = iShowcase.TYPE(rawValue: 1)
//        showcase.show()
        
        let yuppFLixUserDefaults = UserDefaults.standard
        if yuppFLixUserDefaults.object(forKey: "PlayerShowCaseView") == nil {
            yuppFLixUserDefaults.set(true, forKey: "PlayerShowCaseView")
        }
  
        self.testButton.isHidden = true
        self.testButtonWidthConstraint?.constant = 0
        
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
           ccHeight = miniMediaControlsViewController.minHeight
        }
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
        if(AppDelegate.getDelegate().cookiesHasAlreadyLaunched == false){
            if appContants.appName != .mobitel {
                self.showGDPRPrivacyPopUp()
            }
        }
    }
    func showGDPRPrivacyPopUp() {
        let popOverVC = UIStoryboard(name: "Tabs", bundle: nil).instantiateViewController(withIdentifier: "GDPRPrivacyPopupVC") as! GDPRPrivacyPopupVC
        popOverVC.type = "Cookie"
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
        AppDelegate.getDelegate().isTabsPage = false
        if playerVC != nil && (playerVC?.isMinimized)! {
            playerVC?.setScaleFactor()
            playerVC?.minimizeViews()
        }
        if let contentVC = self.currentViewController as? ContentViewController {
            AppDelegate.getDelegate().sourceScreen = "\(contentVC.targetedMenu.capitalized)_Page"
        }
        else if let listVC = self.currentViewController as? ListViewController {
            AppDelegate.getDelegate().sourceScreen = "\(listVC.pageResponse.info.path.capitalized)_Page"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.bringSubviewToFront(AppDelegate.getDelegate().supportButton)
        AppDelegate.getDelegate().window?.bringSubviewToFront(AppDelegate.getDelegate().supportButton)
        
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor

    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        AppDelegate.getDelegate().removeStatusBarView()
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            if productType.iPad {
                self.HomeToolBarCollection.collectionViewLayout.invalidateLayout()
            }
            self.HomeToolBarCollection.reloadData()
            self.HomeToolBarCollection.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.bottom)
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    //MARK: - Custom Methods
    
    func getMenuDetails(isFinished : @escaping (Bool) -> Void) {
        
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        self.startAnimating(allowInteraction: false)
        var tempTabsControllers = [String : UIViewController]()

        for key in tabsControllers.keys {
            if key == "guide" {
                tempTabsControllers[key] = tabsControllers[key]
            }
        }
        tabsControllers = tempTabsControllers
        OTTSdk.appManager.configuration(onSuccess: { (response) in
            AppDelegate.getDelegate().configs = response.configs
            AppDelegate.getDelegate().setConfigResponce(response.configs)

             
            
            self.toolBarTitlesArray = [ToolbarTitle]()
            self.languageNameArray = [langTitle]()
            self.selectedLangIndexPath = NSIndexPath.init(item: 0, section: 0) as IndexPath
            self.stopAnimating()
            //            if response.menus.count > 0 {
            //                self.titlearray = response.menus
            if self.menus.count > 0 {
                self.menus.removeAll()
            }
            
            TabsViewController.shouldHideSearchButton = false
            for menu in response.menus {
                if !self.excludedMenuCodes.contains(menu.code) {
                    self.menus.append(menu)
                }
                if menu.code == "search" {
                    TabsViewController.shouldHideSearchButton = true
//                    if appContants.appName == .aastha {
//                        TabsViewController.shouldHideSearchButton = false
//                    }
//                    else {
//
//                    }
                }
                if menu.targetPath == AppDelegate.getDelegate().favouritesTargetPath {
                    TabsViewController.isWatchListFromMenu = true
                }
            }
            self.searchButton.isHidden = TabsViewController.shouldHideSearchButton
            self.searchButtonWidthConstraint.constant = TabsViewController.shouldHideSearchButton ? 0.0 : 50.0
            
            for item in self.menus{
                if !self.excludedMenuCodes.contains(item.code) {
                    var toolBarTitleObj = ToolbarTitle()
                    toolBarTitleObj.title = item.displayText
                    self.toolBarTitlesArray.append(toolBarTitleObj)
                }
            }
            self.HomeToolBarCollection.register(UINib(nibName: "tabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tabCollectionViewCell")
            self.HomeToolBarCollection.register(UINib(nibName: "tabCollectionViewCell-iPad", bundle: nil), forCellWithReuseIdentifier:"tabCollectionViewCelliPad")
            
            self.subMenuCollectionView.register(UINib(nibName: "subMenuTabColViewCell", bundle: nil), forCellWithReuseIdentifier: "subMenuTabColViewCell")
            self.subMenuCollectionView.register(UINib(nibName: "subMenuTabColViewCell-iPad", bundle: nil), forCellWithReuseIdentifier:"subMenuTabColViewCell-iPad")
                       
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.navigationBar.isTranslucent = true
            //                let homeStoryboard = UIStoryboard(name: "Content", bundle: nil)
            
            if self.menus.count > 0 {
                let menuItem = self.menus[self.selectedMenuRow]
                if self.toolBarSubTitlesArray.count > 0{
                    self.toolBarSubTitlesArray.removeAll()
                }
                self.subMenuCollectionView.reloadData()
                self.subMenuTitleArray = menuItem.subMenus!
                for item in self.subMenuTitleArray{
                    if !self.excludedMenuCodes.contains(item.code) {
                        var toolBarTitleObj = ToolbarSubTitle()
                        toolBarTitleObj.title = item.displayText
                        self.toolBarSubTitlesArray.append(toolBarTitleObj)
                    }
                }
                
                if self.subMenuTitleArray.count > 0{
                    let subMenuItem = self.subMenuTitleArray[self.selectedSubMenuRow]
                    self.initialMenuTargeted = subMenuItem.targetPath
                    self.showSubMenuComponent(submenu: subMenuItem)
                    self.subMenuCollectionViewheightConstraint.constant = 47
                }
                else{
                    self.initialMenuTargeted = menuItem.targetPath
                    self.showComponent(menu: menuItem)
                    self.subMenuCollectionViewheightConstraint.constant = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    self.HomeToolBarCollection.selectItem(at: self.selectedIndexPath as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.bottom)
                    if self.subMenuTitleArray.count > 0 {
                        self.subMenuCollectionView.selectItem(at: self.selectedSubMenuIndexPath as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
                        
                    }
                }
            }
            
            self.languagesArray = response.contentLanguages
            var selectedLangIndex = 0
            if OTTSdk.preferenceManager.userPrefferedLanguages != nil && (OTTSdk.preferenceManager.userPrefferedLanguages?.count)! > 0 {
                for (index, langObj) in self.languagesArray.enumerated() {
                    if (OTTSdk.preferenceManager.userPrefferedLanguages)!.contains(langObj.code) {
                        self.languagesArray.remove(at: index)
                        self.languagesArray.insert(langObj, at: selectedLangIndex)
                        selectedLangIndex = selectedLangIndex + 1
                    }
                }
            }
            var index = 0
            for item in self.languagesArray{
                var langTitleObj = langTitle()
                langTitleObj.title = item.name
                if OTTSdk.preferenceManager.selectedLanguages == item.code {
                    self.selectedLangIndexPath = NSIndexPath.init(item: index, section: 0) as IndexPath
                }
                AppDelegate.getDelegate().selectedLang = OTTSdk.preferenceManager.selectedLanguages
                index = index + 1
                self.languageNameArray.append(langTitleObj)
            }
            if self.languageNameArray.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    if !self.isLangSelected {
                        //                        self.HomeLangCollectionView.selectItem(at: self.selectedLangIndexPath, animated: false, scrollPosition: .centeredHorizontally )
                    }
                    else {
                        //                        self.HomeLangCollectionView.selectItem(at: self.selectedLangIndexPath, animated: false, scrollPosition: .bottom )
                    }
                }
            }
            self.setupViews()
            isFinished(true)
        }) { (error) in
            print(error.message)
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: error.message)
            self.stopAnimating()
            if self.menus.count > 0 {
                let menuItem = self.menus[self.selectedMenuRow]
                self.subMenuTitleArray = menuItem.subMenus!
                if self.subMenuTitleArray.count > 0{
                    let subMenuItem = self.subMenuTitleArray[self.selectedSubMenuRow]
                    self.showSubMenuComponent(submenu: subMenuItem)
                }
                else{
                    self.showComponent(menu: menuItem)
                }
            }
            isFinished(true)
        }

    }

    func updateTheSelectedLanguage(langCode:String) {
        return;
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        OTTSdk.userManager.updatePreference(selectedLanguageCodes: langCode, sendEmailNotification: true, onSuccess: { (response) in
            print(response)
            self.delegate?.refreshTheContent()
        }, onFailure: { (error) in
            print(error.message)
            if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
            })
            }
            else {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                })
            }
            self.stopAnimating()
        })
    }
    
    @IBAction func LangBtnClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        storyBoardVC.fromPage = false
        storyBoardVC.Signup_Process = false
        storyBoardVC.viewControllerName = "TabsVC"
        let nav = UINavigationController.init(rootViewController: storyBoardVC)
        self.present(nav, animated: true, completion: nil)

    }
    
    @IBAction func MenuItemClicked(_ sender: Any) {
        //        let settings = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "NewRegisterController") as! NewAccountController
        //        let navigation = UINavigationController(rootViewController: settings)
        //        navigation.isNavigationBarHidden = true
        //        navigation.modalPresentationStyle = .fullScreen
        //        present(navigation, animated: true, completion: nil)
        
        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HamburgerMenuViewController")
        let nav = UINavigationController.init(rootViewController: newViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
    @IBAction func searchItemClicked(_ sender: Any) {
        print("#searchItemClicked")
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)

    }
    
    @IBAction func TestButtonClicked(_ sender: Any) {
        
    }
    @IBAction func callBtnClicked(_ sender: Any) {
        let phoneNumber = AppDelegate.getDelegate().callingNumber.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    func setupViews() {
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        self.title = "Home".localized
        self.langLbl.text = "Language".localized
        self.callBtn.setTitle("Call".localized, for: UIControl.State.normal)

        HomeToolBarCollection.delegate = self
        HomeToolBarCollection.dataSource = self
        HomeToolBarCollection.backgroundColor = AppTheme.instance.currentTheme.homeCollectionBGColor
        
        subMenuCollectionView.delegate = self
        subMenuCollectionView.dataSource = self
        subMenuCollectionView.backgroundColor = AppTheme.instance.currentTheme.submenuBgColor
             
        if cCFL == nil{
            cCFL = CustomFlowLayout()
            cCFL.secInset = secInsets
            cCFL.cellSize = cellSizes
            cCFL.interItemSpacing = interItemSpacing
            cCFL.minLineSpacing = minLineSpacing
            cCFL.numberOfColumns = numColums
            cCFL.scrollDir = scrollDir
            cCFL.setupLayout()
            HomeToolBarCollection.collectionViewLayout = cCFL
        }
        if subMenuCFL == nil{
            subMenuCFL = CustomFlowLayout()
            subMenuCFL.secInset = secInsets
            subMenuCFL.cellSize = cellSizes
            subMenuCFL.interItemSpacing = interItemSpacing
            subMenuCFL.minLineSpacing = minLineSpacing
            subMenuCFL.numberOfColumns = numColums
            subMenuCFL.scrollDir = scrollDir
            subMenuCFL.setupLayout()
            subMenuCollectionView.collectionViewLayout = subMenuCFL
        }
        if lCFL == nil{
            lCFL = CustomFlowLayout()
            lCFL.secInset = langsecInsets
            lCFL.cellSize = langcellSizes
            lCFL.interItemSpacing = interItemSpacing
            lCFL.minLineSpacing = langMinLineSpacing
            lCFL.numberOfColumns = numColums
            lCFL.scrollDir = scrollDir
            lCFL.setupLayout()
            HomeToolBarCollection.collectionViewLayout = lCFL
        }
        HomeToolBarCollection.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: HomeToolBarCollection.center.y)
        HomeToolBarCollection.reloadData()
        if appContants.appName != .gac {
            
            subMenuCollectionView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: subMenuCollectionView.center.y)
        }
        subMenuCollectionView.reloadData()
    }
   
    func selectMoviesTab() {
        self.collectionView(HomeToolBarCollection, didSelectItemAt: IndexPath(item: 4, section: 0))
        self.HomeToolBarCollection.reloadData()
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        for subView in parentView.subviews{
            subView.removeFromSuperview()
        }
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
   /* func showHardcodedMenuPage(selectedItem: [String:Any]) {
        var displayText = ""
        var targetPath = ""
//        var code = ""
        if let _displayText = selectedItem["menuDisplayName"] as? String {
            displayText = _displayText
        }
        if let _targetPath = selectedItem["menuTargetPath"] as? String {
            targetPath = _targetPath
        }
//        if let _code = selectedItem["menucode"] as? String {
//            code = _code
//        }
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path:selectedItem["menuTargetPath"] as! String) { (viewController, pageType) in
            if let vc = viewController as? ContentViewController{
                //self.pageContentResponse = vc.pageContentResponse
                vc.isToViewMore = true
                vc.targetedMenu = targetPath
                vc.sectionTitle = displayText
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = displayText
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if (viewController is DefaultViewController){
                let defaultViewController = viewController as! DefaultViewController
                defaultViewController.delegate = self
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                if let vc = viewController as? ListViewController{
                    vc.isToViewMore = true
                    vc.sectionTitle = displayText
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                    
                }
            }
            self.stopAnimating()
        }
}*/
    
    func showComponent(menu: Menu) {
        AppDelegate.getDelegate().taggedScreen = menu.displayText
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        AppAnalytics.navigatingFrom = menu.displayText
        LocalyticsEvent.tagEventWithAttributes("Menu_Clicks", ["Menu_Name":"\(menu.targetPath.capitalized)"])

        if let contentVC = self.currentViewController as? ContentViewController {
            AppDelegate.getDelegate().sourceScreen = "\(contentVC.targetedMenu.capitalized)_Page"
//            LocalyticsEvent.tagEventWithAttributes("\(menu.displayText)_menu", [String:String]())
        }
        else if let listVC = self.currentViewController as? ListViewController {
            AppDelegate.getDelegate().sourceScreen = "\(listVC.pageResponse.info.path.capitalized)_Page"
//            LocalyticsEvent.tagEventWithAttributes("\(menu.displayText)_menu", [String:String]())
        }
        else {
            AppDelegate.getDelegate().sourceScreen = "\(menu.displayText)_Page"
//            LocalyticsEvent.tagEventWithAttributes("\(menu.displayText)_menu", [String:String]())
        }
        if OTTSdk.preferenceManager.selectedLanguages == AppDelegate.getDelegate().selectedLang {
            if tabsControllers[menu.targetPath] != nil && tabsControllersRefreshStatus[menu.targetPath] == true{
                cycleFromViewController(oldViewController: self.currentViewController!, toViewController: tabsControllers[menu.targetPath]!)
                self.currentViewController = tabsControllers[menu.targetPath]!
                if let controller = self.currentViewController as? ContentViewController, menu.params?.isDarkMenu ?? false == true {
                    if OTTSdk.preferenceManager.user != nil {
                        controller.configure(item: menu)
                        self.currentViewController = controller
                    }
                    else {
                        self.getViewControllerFor(menu: menu, completion: { (viewController, pageType) in
                            var defaultVC:UIViewController? = nil
                            if (viewController is DefaultViewController) == false{
                                self.tabsControllers[menu.targetPath] = viewController
                                self.tabsControllersRefreshStatus[menu.targetPath] = true
                                defaultVC = viewController
                            }
                            else {
                                let defaultViewController = viewController as! DefaultViewController
                                defaultViewController.delegate = self
                                defaultVC = defaultViewController
                            }
                            self.currentViewController = defaultVC
                            //                    self.delegate?.refreshTheContent()
                            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                            self.addChild(self.currentViewController!)
                            self.addSubview(subView: self.currentViewController!.view, toView: self.ContainerView)
                        })
                    }
                }
                AppDelegate.getDelegate().presentTargetedMenu = menu.targetPath
            }
            else {
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
                self.startAnimating(allowInteraction: false)
                self.getViewControllerFor(menu: menu, completion: { (viewController, pageType) in
                    var defaultVC:UIViewController? = nil
                    if (viewController is DefaultViewController) == false{
                        self.tabsControllers[menu.targetPath] = viewController
                        self.tabsControllersRefreshStatus[menu.targetPath] = true
                        defaultVC = viewController
                    }
                    else {
                        let defaultViewController = viewController as! DefaultViewController
                        defaultViewController.delegate = self
                        defaultVC = defaultViewController
                    }
                    self.currentViewController = defaultVC
//                    self.delegate?.refreshTheContent()
                    self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                    self.addChild(self.currentViewController!)
                    self.addSubview(subView: self.currentViewController!.view, toView: self.ContainerView)
                })

            }
        }
        else{
            self.startAnimating(allowInteraction: false)
            AppDelegate.getDelegate().selectedLang = OTTSdk.preferenceManager.selectedLanguages
            self.getViewControllerFor(menu: menu, completion: { (viewController, pageType) in
                if (viewController is DefaultViewController) == false{
                    self.tabsControllers[menu.targetPath] = viewController
                    self.tabsControllersRefreshStatus[menu.targetPath] = true
                }
                self.currentViewController = viewController
//                self.delegate?.refreshTheContent()
                self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.addChild(self.currentViewController!)
                self.addSubview(subView: self.currentViewController!.view, toView: self.ContainerView)
            })
        }
    }
    
    func showSubMenuComponent(submenu: SubMenu) {
        AppDelegate.getDelegate().taggedScreen = submenu.displayText
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        AppAnalytics.navigatingFrom = submenu.displayText
        LocalyticsEvent.tagEventWithAttributes("Menu_Clicks", ["Menu_Name":"\(submenu.targetPath.capitalized)"])

        if OTTSdk.preferenceManager.selectedLanguages == AppDelegate.getDelegate().selectedLang {
            if tabsControllers[submenu.targetPath] != nil && tabsControllersRefreshStatus[submenu.targetPath] == true {
                cycleFromViewController(oldViewController: self.currentViewController!, toViewController: tabsControllers[submenu.targetPath]!)
                self.currentViewController = tabsControllers[submenu.targetPath]!
                if let contentViewController = self.currentViewController as? ContentViewController {
                    contentViewController.selectedSubMenuIndexPath = self.selectedSubMenuIndexPath
                    self.currentViewController = contentViewController
                }
                AppDelegate.getDelegate().presentTargetedMenu = submenu.targetPath
            }
            else {
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
                self.startAnimating(allowInteraction: false)
                self.getSubMenuViewControllerFor(submenu: submenu, completion: { (viewController, pageType) in
                    var defaultVC:UIViewController? = nil
                    if (viewController is DefaultViewController) == false{
                        self.tabsControllers[submenu.targetPath] = viewController
                        self.tabsControllersRefreshStatus[submenu.targetPath] = true
                        defaultVC = viewController
                    }
                    else {
                        let defaultViewController = viewController as! DefaultViewController
                        defaultViewController.delegate = self
                        defaultVC = defaultViewController
                    }
                    self.currentViewController = defaultVC
                    //                    self.delegate?.refreshTheContent()
                    self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                    self.addChild(self.currentViewController!)
                    self.addSubview(subView: self.currentViewController!.view, toView: self.ContainerView)
                })
                
            }
        }
        else{
            self.startAnimating(allowInteraction: false)
            AppDelegate.getDelegate().selectedLang = OTTSdk.preferenceManager.selectedLanguages
            self.getSubMenuViewControllerFor(submenu: submenu, completion: { (viewController, pageType) in
                if (viewController is DefaultViewController) == false{
                    self.tabsControllers[submenu.targetPath] = viewController
                    self.tabsControllersRefreshStatus[submenu.targetPath] = true
                }
                self.currentViewController = viewController
                //                self.delegate?.refreshTheContent()
                self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
                self.addChild(self.currentViewController!)
                self.addSubview(subView: self.currentViewController!.view, toView: self.ContainerView)
            })
        }
    }

    func replaceViewWithExistingView(identifier:String,storyBoard:String) {
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    /*
    func replaceViewWithExistingViewForHome(identifier:String,storyBoard:String,withTarget:String) {
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as! ContentViewController
        newViewController.parentVC = self
        newViewController.targetedMenu = withTarget
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }*/
    
    func getViewControllerFor(menu : Menu, completion : @escaping (UIViewController, PageInfo.PageType?) -> Void){
        if appContants.appName == .gac {
            self.subMenuCollectionViewTopConstraint.constant = 0
        }
        let path = menu.targetPath
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if appContants.appName == .gac {
            self.seperatorLabel.isHidden = false
        }
        self.startAnimating(allowInteraction: false)
        if menu.code == "guide" || menu.code == "tvguide" {
            self.stopAnimating()
            if appContants.appName == .tsat{
                completion(TargetPage.tinyGuideViewController(), PageInfo.PageType.content)
            }
            else{
                completion(TargetPage.tvGuideViewController(),PageInfo.PageType.content)
            }
        }
        else if menu.code == "monthly_planner" {
            self.stopAnimating()
            completion(TargetPage.monthlyPlannerViewController(),PageInfo.PageType.content)
        }
        else if menu.code == "search" {
            self.stopAnimating()
            completion(TargetPage.searchViewController(),PageInfo.PageType.content)
        }
        else if menu.code == "settings" || menu.code == "account" {
            self.stopAnimating()
            completion(TargetPage.accountViewController(),PageInfo.PageType.content)
        }
        else {
            TargetPage.getTargetPageObject(path: path, menu) { (viewController, pageType) in
                self.stopAnimating()
                
                //            else if menu.code == "my_recordings" {
                //            }
                //            else {
                if pageType == .content{
                    guard let newViewController = viewController as? ContentViewController else{
                        completion(TargetPage.defaultViewController(),pageType)
                        return
                    }
                    if menu.params?.isDarkMenu ?? false == true {
                        newViewController.configure(item: menu)
                    }
                    newViewController.targetedMenu = path
                    AppDelegate.getDelegate().presentTargetedMenu = path
                    newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                    //                if self.currentViewController != nil{
                    //                    self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
                    //                }
                    self.currentViewController = newViewController
                    completion(newViewController,pageType)
                }
                else{
                    completion(viewController,pageType)
                    return
                }
                //            }
            }
        }
    }
    
    func getSubMenuViewControllerFor(submenu : SubMenu, completion : @escaping (UIViewController, PageInfo.PageType?) -> Void){
        let path = submenu.targetPath
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            self.stopAnimating()
            if submenu.targetPath == "guide" || submenu.targetPath == "tvguide" {
                self.stopAnimating()
                if appContants.appName == .tsat{
                    completion(TargetPage.tinyGuideViewController(), PageInfo.PageType.content)
                }
                else{
                    completion(TargetPage.tvGuideViewController(),PageInfo.PageType.content)
                }
            }
            else if submenu.targetPath == "monthly_planner"{
                    completion(TargetPage.monthlyPlannerViewController(), PageInfo.PageType.unKnown)
            }
            else {
                if pageType == .content{
                    guard let newViewController = viewController as? ContentViewController else{
                        completion(TargetPage.defaultViewController(),pageType)
                        return
                    }
                    newViewController.selectedSubMenuIndexPath = self.selectedSubMenuIndexPath
                    newViewController.targetedMenu = path
                    AppDelegate.getDelegate().presentTargetedMenu = path
                    newViewController.view.translatesAutoresizingMaskIntoConstraints = false
                    //                if self.currentViewController != nil{
                    //                    self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
                    //                }
                    self.currentViewController = newViewController
                    completion(newViewController,pageType)
                }
                else{
                    completion(viewController,pageType)
                    return
                }
            }
        }
    }

    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        if oldViewController == newViewController {
            return
        }
        oldViewController.willMove(toParent: nil)
        self.addChild(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.ContainerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        updatingViewController = newViewController
        UIView.animate(withDuration: 0.5, animations: {
            if newViewController == self.updatingViewController{
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            }
        },
                       completion: { finished in
                        if newViewController == self.updatingViewController{
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParent()
                            newViewController.didMove(toParent: self)
                        }
        })
    }
    
    
    
    // MARK: - UICollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == HomeToolBarCollection {
            return self.toolBarTitlesArray.count
        }
        else if collectionView == subMenuCollectionView {
            return self.toolBarSubTitlesArray.count
        }
        else {
            return self.languageNameArray.count
        }
    }
    private func updateCellItems(itemcell1 : tabColViewCell?, itemcell2 : tabColViewCelliPad?, indexPath : IndexPath) {
        var tabSelectDeselectColor : UIColor!
        if let cell = itemcell1 {
            if indexPath == selectedIndexPath {
                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
                   
                    if appContants.appName == .gac {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                        
                        cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                    }
                    else {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarSelectedText
                        cell.bottomBar.backgroundColor = UIColor.clear
                    }
                }
                else {
                    if appContants.appName == .gac {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                        
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                        
                        cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                    }
                    else {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.tabBarSelectedText
                        
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarSelectedText
                        cell.bottomBar.backgroundColor = UIColor.clear

                    }
                }
            }else {
                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage {
                   
                    if appContants.appName == .gac {
                        cell.titleLabel.textColor =  AppTheme.instance.currentTheme.tabBarDimGray
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarDimGray
                    }
                    else {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                        tabSelectDeselectColor = UIColor.tabBarDimGray
                    }
                }
                else {
                    if appContants.appName == .gac {
                        cell.titleLabel.textColor =  AppTheme.instance.currentTheme.tabBarDimGray
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarDimGray
                    }
                    else {
                        cell.titleLabel.textColor =  AppTheme.instance.currentTheme.cardSubtitleColor
                        tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarDimGray
                    }
                }
                cell.bottomBar.backgroundColor = UIColor.clear
            }
            if appContants.appName == .reeldrama && (cell.tabMenuCode.lowercased() == "home" || cell.tabMenuCode.lowercased() == "home_m" || cell.tabMenuCode.lowercased() == "home_mobile") {
            }else if appContants.appName == .gotv && cell.tabMenuCode.lowercased() == "after_dark" {
            }else {
                cell.tabMenuIcon.setImageColor(color: tabSelectDeselectColor)
            }
        }else if let cell = itemcell2 {
            if indexPath == selectedIndexPath {
                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
                    tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarSelectedText
                }
                else {
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.tabBarSelectedText
                    tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarSelectedText
                }
            }else {
                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage {
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    tabSelectDeselectColor = UIColor.tabBarDimGray
                }
                else {
                    cell.titleLabel.textColor =  AppTheme.instance.currentTheme.cardSubtitleColor
                    tabSelectDeselectColor = AppTheme.instance.currentTheme.tabBarDimGray
                }
            }
            if appContants.appName == .reeldrama && (cell.tabMenuCode.lowercased() == "home" || cell.tabMenuCode.lowercased() == "home_m" || cell.tabMenuCode.lowercased() == "home_mobile") {
            }else if appContants.appName == .gotv && cell.tabMenuCode.lowercased() == "after_dark" {
            }else {
                cell.tabMenuIcon.setImageColor(color: tabSelectDeselectColor)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == HomeToolBarCollection {
            if productType.iPad {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCollectionViewCelliPad", for: indexPath) as! tabColViewCelliPad
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = self.toolBarTitlesArray[indexPath.item].title
                cell.tabMenuCode = self.menus[indexPath.item].code
                if self.menus[indexPath.item].code == "home" || self.menus[indexPath.item].code == "home_m" || self.menus[indexPath.item].code == "home_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_home")
                }
                else if self.menus[indexPath.item].code == "search" || self.menus[indexPath.item].code == "search_m" || self.menus[indexPath.item].code == "search_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_search")
                }
                else if self.menus[indexPath.item].code == "debut" || self.menus[indexPath.item].code == "debut_m" || self.menus[indexPath.item].code == "debut_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_movies")
                }
                else if self.menus[indexPath.item].code == "watch_now" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_default")
                }
                else if self.menus[indexPath.item].code == "catchup" || self.menus[indexPath.item].code == "catch_up"{
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_catchup")
                }
                else if self.menus[indexPath.item].code == "kids" || self.menus[indexPath.item].code == "kids_m" || self.menus[indexPath.item].code == "kids_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_kids")
                }
                else if self.menus[indexPath.item].code == "account" || self.menus[indexPath.item].code == "account_m" || self.menus[indexPath.item].code == "account_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_account")
                }
                else if self.menus[indexPath.item].code == "settings" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_settings")
                }
                else if self.menus[indexPath.item].code == "watchlist" || self.menus[indexPath.item].code == "watchlist_m" ||  self.menus[indexPath.item].code == "watchlist_mobile" || self.menus[indexPath.item].code == "my_watchlist" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_watchlist")
                }
                else if self.menus[indexPath.item].code == "guide" || self.menus[indexPath.item].code == "tvguide" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_guide")
                }
                else if self.menus[indexPath.item].code == "after_dark" {
                    cell.tabMenuIcon.image = UIImage.init(named: "logoFade")
                }
                else if self.menus[indexPath.item].code == "community" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_community")
                }
                else {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_default")
                }
                cell.backgroundColor = UIColor.clear
                updateCellItems(itemcell1: nil, itemcell2: cell, indexPath: indexPath)
                if appContants.appName == .gac {
                    cell.bottomBar.backgroundColor = .white
                    cell.bottomBarLeft.constant = UIScreen.main.bounds.width/30
                    cell.bottomBarRight.constant = -1 * (UIScreen.main.bounds.width/30)
                    if indexPath != selectedIndexPath {
                        cell.bottomBar.backgroundColor = .clear
                    }
                    cell.bbHeight.constant = 4.0
                }
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCollectionViewCell", for: indexPath) as! tabColViewCell
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = self.toolBarTitlesArray[indexPath.item].title
                cell.tabMenuCode = self.menus[indexPath.item].code
                if self.menus[indexPath.item].code == "home" || self.menus[indexPath.item].code == "home_m" || self.menus[indexPath.item].code == "home_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_home")
                } else if self.menus[indexPath.item].code == "search" || self.menus[indexPath.item].code == "search_m" || self.menus[indexPath.item].code == "search_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_search")
                }
                else if self.menus[indexPath.item].code == "debut" || self.menus[indexPath.item].code == "debut_m" || self.menus[indexPath.item].code == "debut_mobile"{
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_movies")
                }
                else if self.menus[indexPath.item].code == "kids" || self.menus[indexPath.item].code == "kids_m" || self.menus[indexPath.item].code == "kids_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_kids")
                }
                else if self.menus[indexPath.item].code == "catchup" || self.menus[indexPath.item].code == "catch_up" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_catchup")
                }
                else if self.menus[indexPath.item].code == "watch_now" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_default")
                }
                else if self.menus[indexPath.item].code == "account" || self.menus[indexPath.item].code == "account_m" || self.menus[indexPath.item].code == "account_mobile" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_account")
                }
                else if self.menus[indexPath.item].code == "settings" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_settings")
                }
                else if self.menus[indexPath.item].code == "watchlist" || self.menus[indexPath.item].code == "watchlist_m" || self.menus[indexPath.item].code == "watchlist_mobile" || self.menus[indexPath.item].code == "my_watchlist" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_watchlist")
                }
                else if self.menus[indexPath.item].code == "guide" || self.menus[indexPath.item].code == "tvguide" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_guide")
                }
                else if self.menus[indexPath.item].code == "guide" || self.menus[indexPath.item].code == "tvguide" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_guide")
                }
                else if self.menus[indexPath.item].code == "after_dark" {
                    cell.tabMenuIcon.image = UIImage.init(named: "logoFade")
                }
                else if self.menus[indexPath.item].code == "community" {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_community")
                }
                else {
                    cell.tabMenuIcon.image = UIImage.init(named: "tab_default")
                }
                cell.backgroundColor = UIColor.clear
                updateCellItems(itemcell1: cell, itemcell2: nil, indexPath: indexPath)
                return cell
            }
        }
        else if collectionView == subMenuCollectionView {
            if productType.iPad {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuTabColViewCell-iPad", for: indexPath) as! subMenuTabColViewCelliPad
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = self.toolBarSubTitlesArray[indexPath.item].title
                if indexPath == selectedSubMenuIndexPath {
                    cell.titleLabel.textColor = appContants.appName == .supposetv ? AppTheme.instance.currentTheme.themeColor : AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                    cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                } else {
                    
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.deSelectedTitleColor
                    cell.bottomBar.backgroundColor = UIColor.clear
                }
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuTabColViewCell", for: indexPath) as! subMenuTabColViewCell
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = self.toolBarSubTitlesArray[indexPath.item].title
                cell.backgroundColor = UIColor.clear
                if indexPath == selectedSubMenuIndexPath {
                    cell.titleLabel.textColor = appContants.appName == .supposetv ? AppTheme.instance.currentTheme.themeColor : AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                    cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                    if appContants.appName == .gac {
                        cell.backgroundColor = AppTheme.instance.currentTheme.langSelBg
                        cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                    }
                } else {
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.deSelectedTitleColor
                    cell.bottomBar.backgroundColor = UIColor.clear
                }
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "langCollectionViewCell", for: indexPath) as! langColViewCell
            print("cellForItemAt 1", indexPath.item)
            cell.titleLabel.text = self.languageNameArray[indexPath.item].title
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == HomeToolBarCollection {
//            let width = self.toolBarTitlesArray[indexPath.item].answerHeight
            let viewWidth = AppDelegate.getDelegate().window?.frame.width ?? self.view.frame.width
            let width = viewWidth / CGFloat(self.toolBarTitlesArray.count)
            if indexPath.item == toolBarTitlesArray.count - 1 {
               return CGSize(width: width - 1, height: (productType.iPad ? 62 : 47))
            }
            return CGSize(width: width, height: (productType.iPad ? 62 : 47))
        }
        else if collectionView == subMenuCollectionView {
            if appContants.appName == .gac {
                return CGSize(width: ((UIScreen.main.bounds.size.width - 1) / 2), height: 47)
            }
            else {
                let width = self.toolBarSubTitlesArray[indexPath.item].answerHeight
                if productType.iPad {
                    return CGSize(width: 130, height: 47)
                }
                return CGSize(width: width, height: 47)
                
            }
        }
        else {
            let width = self.languageNameArray[indexPath.item].answerHeight
                return CGSize(width: width, height: 47)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if collectionView == HomeToolBarCollection {
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
//            else if self.selectedMenuRow == indexPath.row {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollToTop"), object: nil)
//                return
//            }
            let menuItem = self.menus[indexPath.row]
            if let params = menuItem.params, params.targetType != "menu" {
                if menuItem.params?.isDarkMenu ?? false == true {
                    self.showComponent(menu: menuItem)
                    self.selectedIndexPath = indexPath
                    self.selectedMenuRow = indexPath.row
                    updateNavigationBarItem(menu: nil)
                    subMenuCollectionViewheightConstraint.constant = 0
                    self.subMenuCollectionViewTopConstraint.constant = 0.0
                    collectionView.reloadData()
                    return
                }else {
                    if appContants.appName == .tsat {
                        gotoBrowserForTestWith(params: params, displayText: menuItem.displayText, collectionView: collectionView)
                        return
                    }
                }
            }
            
            HomeToolBarCollection.scrollToItem(at: indexPath, at: .bottom, animated: false)
            self.selectedIndexPath = indexPath
            self.selectedMenuRow = indexPath.row
            updateNavigationBarItem(menu: menuItem)
            self.selectedSubMenuRow = 0
            self.selectedSubMenuIndexPath = NSIndexPath.init(item: 0, section: 0) as IndexPath
            
            if self.toolBarSubTitlesArray.count > 0{
                self.toolBarSubTitlesArray.removeAll()
            }
            self.subMenuTitleArray = menuItem.subMenus!
            for item in self.subMenuTitleArray{
                if !self.excludedMenuCodes.contains(item.code) {
                    var toolBarTitleObj = ToolbarSubTitle()
                    toolBarTitleObj.title = item.displayText
                    self.toolBarSubTitlesArray.append(toolBarTitleObj)
                }
            }
            if self.subMenuTitleArray.count > 0{
                let subMenuItem = self.subMenuTitleArray[self.selectedSubMenuRow]
                self.showSubMenuComponent(submenu: subMenuItem)
                self.subMenuCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.subMenuCollectionView.selectItem(at: self.selectedSubMenuIndexPath as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                    self.subMenuCollectionView.scrollToItem(at: self.selectedSubMenuIndexPath, at: .centeredHorizontally, animated: true)
                }
                subMenuCollectionViewheightConstraint.constant = 47
                
            }
            else{
                self.subMenuCollectionView.reloadData()
                subMenuCollectionViewheightConstraint.constant = 0
                self.showComponent(menu: menuItem)
            }
            collectionView.reloadData()
        }
        else if collectionView == subMenuCollectionView {
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            let subMenuItem = self.subMenuTitleArray[indexPath.row]
            if let params = subMenuItem.params, params.targetType != "menu" {
                if appContants.appName == .tsat {
                    gotoBrowserForTestWith(params: params, displayText: subMenuItem.displayText, collectionView: collectionView)
                    return
                }
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.selectedSubMenuIndexPath = indexPath
            self.selectedSubMenuRow = indexPath.row
            self.showSubMenuComponent(submenu: subMenuItem)
            subMenuCollectionView.reloadData()
        }
        else {
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.selectedLangIndexPath = indexPath
            self.isLangSelected = true
            for tabControllKey in self.tabsControllersRefreshStatus.keys {
                if tabControllKey != self.menus[self.selectedMenuRow].targetPath {
                    self.tabsControllersRefreshStatus[tabControllKey] = false
                }
            }
            self.HomeToolBarCollection.reloadData()
            self.HomeToolBarCollection.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.bottom)
            self.updateTheSelectedLanguage(langCode: self.languagesArray[indexPath.row].code)
        }
    }
    
    private func gotoBrowserForTestWith(params : Parameters, displayText : String, collectionView : UICollectionView) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Movies", bundle:nil)
        let mockTestView = storyBoard.instantiateViewController(withIdentifier: "MockTestViewController") as! MockTestViewController
        mockTestView.sectionTitle = displayText
        if params.mockTestList != nil {
            mockTestView.mockListDataArray = params.mockTestList!
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mockTestView, animated: true)
        
        
        
        /*if let url = URL(string: params.url), params.targetType == "externalbrowser".lowercased() {
            let alertController = UIAlertController(title: params.popupTitle, message: params.popupMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }else {
            let view1 = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = params.url
            view1.pageString = displayText
            view1.viewControllerName = "SetupViewController"
            UIApplication.topVC()!.navigationController?.pushViewController(view1, animated: true)
        }*/
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        
        if collectionView == HomeToolBarCollection {
            let elements_count = self.toolBarTitlesArray.count
            
            let cellCount = CGFloat(elements_count)
            
            //If the cell count is zero, there is no point in calculating anything.
            if cellCount > 0 {
                //2.00 was just extra spacing I wanted to add to my cell.
                var totalCellWidth:CGFloat = 0.0// = cellWidth*cellCount + 2.00 * (cellCount-1)
                for itemCell in self.toolBarTitlesArray {
                    totalCellWidth += itemCell.answerHeight
                }
                let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
                
                if (totalCellWidth < contentWidth) {
                    //If the number of cells that exists take up less room than the
                    //collection view width... then there is an actual point to centering them.
                    
                    //Calculate the right amount of padding to center the cells.
                    var padding = (contentWidth - totalCellWidth) / 2.0
                    print("---------padding--------",padding)
                    //                    if productType.iPad {
                    //                        padding = (contentWidth - totalCellWidth) / cellCount
                    //                        return UIEdgeInsets.init(top: 0, left: padding, bottom: 0, right: padding)
                    //                    }
                    return UIEdgeInsets.zero
                } else {
                    //Pretty much if the number of cells that exist take up
                    //more room than the actual collectionView width, there is no
                    // point in trying to center them. So we leave the default behavior.
                    return UIEdgeInsets.zero
                }
            }
            else {
                return UIEdgeInsets.zero
            }
        }
        else if collectionView == subMenuCollectionView {
            
            if appContants.appName == .gac {
                return UIEdgeInsets.zero
            }
            else {
                let elements_count = self.subMenuTitleArray.count
                
                let cellCount = CGFloat(elements_count)
                
                //If the cell count is zero, there is no point in calculating anything.
                if cellCount > 0 {
                    //2.00 was just extra spacing I wanted to add to my cell.
                    var totalCellWidth:CGFloat = 0.0// = cellWidth*cellCount + 2.00 * (cellCount-1)
                    for itemCell in self.toolBarSubTitlesArray {
                        totalCellWidth += itemCell.answerHeight
                    }
                    let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
                    
                    if (totalCellWidth < contentWidth) {
                        //If the number of cells that exists take up less room than the
                        //collection view width... then there is an actual point to centering them.
                        
                        //Calculate the right amount of padding to center the cells.
                        var padding = (contentWidth - totalCellWidth) / 2.0
                        if productType.iPad {
                            padding = (contentWidth - totalCellWidth) / cellCount
                        }
                        return UIEdgeInsets.init(top: 0, left: padding, bottom: 0, right: padding)
                    } else {
                        //Pretty much if the number of cells that exist take up
                        //more room than the actual collectionView width, there is no
                        // point in trying to center them. So we leave the default behavior.
                        return UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 2)
                    }
                    
                }
                else {
                    return UIEdgeInsets.zero
                }
            }
        }
        else {
            return UIEdgeInsets.zero
        }
    }
    
    
    func showCouchScreen() {
//        self.couchScreenView.isHidden = false
    }
    
    func hideCouchScreen() {
//        self.couchScreenView.isHidden = true
    }
    // MARK: - DefaultViewControllerDelegate
    func retryTap(){
        let menuItem = self.menus[self.selectedMenuRow]
        self.showComponent(menu: menuItem)
    }
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }

    // MARK: - Chrome Cast Device Scanner Delegates -
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            self._miniMediaControlsHeightConstraint.constant = 0
            self.view.bringSubviewToFront(_miniMediaControlsContainerView)
            if playerVC != nil {
                playerVC?.showHidePlayerView(true)
            }
        }
        else {
            self._miniMediaControlsHeightConstraint.constant = 0
//            if playerVC != nil {
//                playerVC?.showHidePlayerView(false)
////                playerVC?.player.stop()
//            }
        }
        self.view.setNeedsLayout()
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
    
    //MARK: - PlayerViewControllerDelegate Methods
    func record(confirm : Bool, content : Any?){
        if confirm{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: TVGuideCollectionCollectionViewController.reloadNotificationName), object: nil)
        }
    }
    
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        
    }

}

// MARK: - Tab
class tabColViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tabMenuIcon: UIImageView!
    @IBOutlet weak var bottomBar: UIView!
    var selectedText = ""
    var tabMenuCode = ""
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
        titleLabel.text = ""
        tabMenuCode = ""
        tabMenuIcon.image = nil
        bottomBar.backgroundColor = .white
        //bottomselectionBar.isHidden = true
        //titleLabel.font = UIFont.ottRegularFont(withSize: 14)
    }
}

class tabColViewCelliPad: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var bbHeight: NSLayoutConstraint!
    @IBOutlet weak var tabMenuIcon: UIImageView!
    
    @IBOutlet weak var bottomBarRight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarLeft: NSLayoutConstraint!
    var selectedText = ""
    var tabMenuCode = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        titleLabel.text = ""
        tabMenuCode = ""
        tabMenuIcon.image = nil
        bottomBar.backgroundColor = UIColor.white
    }
}

// MARK: - Sub Menu Tab
class subMenuTabColViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var cvImageView: UIImageView?
    var selectedText = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        titleLabel.text = ""
        bottomBar.backgroundColor = UIColor.clear
        cvImageView?.isHidden = true
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.titleLabel.textColor = appContants.appName == .supposetv ? AppTheme.instance.currentTheme.themeColor : AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                self.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
            } else {
                self.titleLabel.textColor = AppTheme.instance.currentTheme.deSelectedTitleColor
                self.bottomBar.backgroundColor = UIColor.clear
            }
        }
    }
    
//    override var isHighlighted: Bool {
//        willSet {
//            if newValue {
//                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
//                    self.titleLabel.textColor = UIColor.init(hexString: "0f1214")
//                    self.bottomBar.backgroundColor = UIColor.init(hexString: "d90738")
//                }
//                else {
//                    self.titleLabel.textColor = UIColor.white
//                    self.bottomBar.backgroundColor = UIColor.white
//                }
//            } else {
//                if AppDelegate.getDelegate().isPlayerPage {
//                    self.titleLabel.textColor = UIColor.tabBarDimGray
//                    self.bottomBar.backgroundColor = UIColor.clear
//                } else if AppDelegate.getDelegate().isDetailsPage {
//                    self.titleLabel.textColor = UIColor.white.withAlphaComponent(0.4)
//                    self.bottomBar.backgroundColor = UIColor.clear
//                }
//                else {
//                    self.titleLabel.textColor = UIColor.tabBarDimGray
//                    self.bottomBar.backgroundColor = UIColor.clear
//                }
//            }
//        }
//    }
}

class subMenuTabColViewCelliPad: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    var selectedText = ""
    @IBOutlet weak var cvImageView: UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        titleLabel.text = ""
        bottomBar.backgroundColor = UIColor.clear
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.titleLabel.textColor =  AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                self.bottomBar.backgroundColor = .white
            } else {
                self.titleLabel.textColor = AppTheme.instance.currentTheme.deSelectedTitleColor
                self.bottomBar.backgroundColor = UIColor.clear
            }
        }
    }
    
//    override var isHighlighted: Bool {
//        willSet {
//            if newValue {
//                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
//                    self.titleLabel.textColor = UIColor.init(hexString: "029bde")
//                    self.bottomBar.backgroundColor = UIColor.black
//                }
//                else {
//                    self.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
//                    self.bottomBar.backgroundColor = UIColor.white
//                }
//            } else {
//                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
//                    self.titleLabel.textColor = UIColor.init(hexString: "999999")
//                    self.bottomBar.backgroundColor = UIColor.clear
//                }
//                else {
//                    self.titleLabel.textColor = UIColor.tabBarDimGray
//                    self.bottomBar.backgroundColor = UIColor.clear
//                }
//            }
//        }
//    }
}

// MARK: - Language Tab
class langColViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    var selectedText = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        titleLabel.text = ""
        bottomBar.backgroundColor = UIColor.clear
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.titleLabel.textColor = UIColor.white
                self.bottomBar.backgroundColor = UIColor.white
            } else {
                self.titleLabel.textColor = UIColor.tabBarDimGray
                self.bottomBar.backgroundColor = UIColor.clear
            }
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                self.titleLabel.textColor = UIColor.white
                self.bottomBar.backgroundColor = UIColor.white
            } else {
                self.titleLabel.textColor = UIColor.tabBarDimGray
                self.bottomBar.backgroundColor = UIColor.clear
            }
        }
    }
}
