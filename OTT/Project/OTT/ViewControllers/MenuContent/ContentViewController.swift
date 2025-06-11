//
//  HomeVC.swift
//  myColView
//
//  Created by Mohan Agadkar on 22/05/17.
//  Copyright © 2015 com.cv. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast
import GoogleMobileAds
import MaterialComponents

enum ButtonTags : Int {
    case buttonLive = 100
    case buttonCatchup = 101
    case buttonCatchupEpisode = 102
    case buttonMovie = 103
    case buttonTVShow = 104
    case buttonTVShowEpisode = 105
}

class MyRecordingsErrorView: UIView{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabelLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    func resetConstraints(){
        DispatchQueue.main.async {
            self.titleLabelHeightConstraint.constant = self.titleLabel.heightForFullTextDisplay()
            self.subTitleLabelLabelHeightConstraint.constant = self.subTitleLabel.heightForFullTextDisplay()
            let contentHeight = (self.subTitleLabel.frame.origin.y + self.subTitleLabelLabelHeightConstraint.constant)
            let remainingSpace = (self.frame.size.height - TabsViewController.instance.HomeToolBarCollection.frame.size.height ) - contentHeight
            self.imageViewTopConstraint.constant = (remainingSpace > 0) ? (remainingSpace / 2) : 0
        }
    }
}
class ContentViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SectionCVCProtocal,BannerCVCProtocal,PlayerViewControllerDelegate,LanguageSelectionProtocal,DefaultViewControllerDelegate,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol, PartialRenderingViewDelegate,GADBannerViewDelegate,GADAdLoaderDelegate,GADUnifiedNativeAdLoaderDelegate,UITableViewDelegate,UITableViewDataSource {
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
    @IBOutlet weak var chromeButtonView: UIView!
    @IBOutlet weak var searchButton : UIButton!
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20
    var interstitial: GADInterstitial!
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerAdView: UIView!
    
    /// The number of native ads to load (must be less than 5).
    var numAdsToLoad = 5
    var adInterval = 5
    /// The native ads.
    var nativeAds = [GADUnifiedNativeAd]()
    /// The ad loader that loads the native ads.
    var adLoader: GADAdLoader!
    
    
    
    @IBOutlet weak var noContentLbl: UILabel!
    
    @IBOutlet weak var homeCV: UICollectionView!
    
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    //Free trail view outlets
    @IBOutlet weak var freetrail_backImageView: UIImageView!
    @IBOutlet weak var freetrail_titleLabel: UILabel!
    
    @IBOutlet weak var freeTitleLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var freetrail_descLabel: UILabel!
    @IBOutlet weak var freetrail_Button: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var freeTrailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailDescLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailDescLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var freeTrailBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet var freeTrailview: UIView!
    var freeTrailViewHeight:CGFloat = 220.0
    var contentCellHeight:CGFloat = 219.0
    var pageContentResponse : PageContentResponse!
    var isToViewMore = false
    var sectionTitle = ""
    var recentlyContinueWatchIndex = 0
    var indexPath = 0
    var goGetTheData:Bool = true
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()

    @IBOutlet weak var myRecordingsErrorView: MyRecordingsErrorView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dobTextField: MDCTextField!
    var dobController: MDCTextInputControllerOutlined?

    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var toolBar : UIToolbar!
    @IBOutlet var checkBoxImageViewArray: [UIImageView]!
    @IBOutlet var genderLabelsArray: [UILabel]!
    var genderIndex = -1
    @IBOutlet var genderLabel : UILabel!
    var tempTimeInterval : TimeInterval!
    @IBOutlet weak var buttonsStackView : UIStackView!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet var cancelButton : UIButton!
    @IBOutlet var mainView : UIView!
    @IBOutlet weak var mainInnerView : UIView!
    @IBOutlet weak var mainInnerViewMiddleConstraint : NSLayoutConstraint!
    @IBOutlet var genderBgView : UIView!
    @IBOutlet var dobView : UIView!
    @IBOutlet weak var userFieldStackView : UIStackView!
    @IBOutlet var userHeadingLabel : UILabel!
    @IBOutlet var userSubHeadingLabel : UILabel!
    
    //socialmedia popup view
    @IBOutlet var socialMediaPopupBgView : UIView!
    @IBOutlet var socialMediaPopupCloseButton : UIButton!
    @IBOutlet var socialMediaTitleLabel : UILabel!
    @IBOutlet var socialMediaSubTitleLabel : UILabel!
    @IBOutlet var socialMediaBackGroundImageView : UIImageView!
    @IBOutlet var socialMediaTableView : UITableView!
    var socialMediaOptionsListArray = [[String:Any]]()
    
    //Agree View
    @IBOutlet var agreeView : UIView!
    @IBOutlet weak var agreeInnerView : UIView!
    @IBOutlet weak var agreeHeadingLabel : UILabel!
    @IBOutlet weak var agressSubHeadingLabel : UILabel!
    @IBOutlet weak var agressSubmitButton : UIButton!
    @IBOutlet var agreeCancelButton : UIButton!
    
    //Pin View
    @IBOutlet var pinView : UIView!
    @IBOutlet weak var pinInnerView : UIView!
    @IBOutlet var pinHeadingLabel : UILabel!
    @IBOutlet weak var pinSubHeadingLabel : UILabel!
    @IBOutlet weak var pinTextField : MDCTextField!
    @IBOutlet weak var pinSubmitButton : UIButton!
    @IBOutlet weak var pinCancelButton : UIButton!
    @IBOutlet var pinLogoImageView : UIImageView!
    @IBOutlet weak var pinStackView : UIStackView!
    @IBOutlet private weak var pinErrorMsgLabel : UILabel!
    @IBOutlet weak var pinForgotButton : UIButton!
    @IBOutlet var pinForgotView : UIView!
    @IBOutlet weak var pinForgotStackView : UIStackView!
    fileprivate var pinNumberController: MDCTextInputControllerOutlined?
    
    //Continue Browsing View
    @IBOutlet var continueBrowView : UIView!
    @IBOutlet var continueHeadingLabel : UILabel!
    @IBOutlet weak var continueButton : UIButton!
    
    var dob = String()
    fileprivate var menuItem : Menu!
    fileprivate var isForgotPin = false
    fileprivate var pinResponse : ParentalPinResponse!
    @IBAction func backBtnAction(_ sender: Any) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
    }
    @IBAction func Refresh(_ sender: Any) {
        
        self.myRecordingsErrorView.isHidden = true
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        //        if AppDelegate.getDelegate().presentTargetedMenu != self.targetedMenu {
        //            self.targetedMenu = AppDelegate.getDelegate().presentTargetedMenu
        //        }
        self.refreshControl.endRefreshing()
        self.recordingCardsArr.removeAll()
        AppDelegate.getDelegate().recordingCardsArr.removeAll()
        self.recordingSeriesArr.removeAll()
        AppDelegate.getDelegate().recordingSeriesArr.removeAll()
        let visibleItemIndexpath = self.homeCV.indexPathsForVisibleItems
        self.homeCV.isHidden = true
        self.startAnimating(allowInteraction: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            OTTSdk.mediaCatalogManager.pageContent(path: self.targetedMenu, onSuccess: { (response) in                
                self.pageContentResponse = response
                if self.pageData.count > 0 {
                    self.pageData.removeAll()
                }
                self.totalPageData = response.data
                self.pageData = response.data
                self.reOrderTotalPageData = response.data
                self.bannerData = response.banners
                self.getNumberOfItemsForSection()
                if self.pageData.count > 0 {
                    self.homeCV.dataSource = nil
                    self.homeCV.delegate = nil
                    self.homeCV.dataSource = self
                    self.homeCV.delegate = self
                    self.homeCV.setContentOffset(CGPoint.zero, animated: false)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                        self.homeCV.reloadData()
                        self.homeCV.isHidden = false
                    }
                    /*
                     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200) ) {
                     for indexPath in visibleItemIndexpath {
                     if self.homeCV.validate(indexPath: indexPath) {
                     self.homeCV.scrollToItem(at: indexPath, at: .bottom, animated: false)
                     }
                     }
                     }
                     */
                    self.errorView.isHidden = true
                }
                else{
                    if self.bannerData.count > 0 {
                        self.errorView.isHidden = true
                    }
                    else {
                        self.homeCV.isHidden = true
                        if self.targetedMenu == "my_recordings" {
                            self.showErrorViewForMyRecordings()
                        } else {
                            self.errorView.isHidden = false
                        }
                    }
                }
                self.getContinueWatchingList()
                self.getRecentlyWatchedList()
                self.goGetTheData = true
                self.stopAnimating()
            }) { (error) in
                self.showAlertWithText(message: error.message)
                print(error.message)
                self.stopAnimating()
            }
            self.displayNativeAds()
        }
    }
    /// For Frndly TV : Different error message UIs for different package holders
    func showErrorViewForMyRecordings(){
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.activePackages(onSuccess: { (packages) in
            self.stopAnimating()
            
            var imageName = "group_964"// "MyRecordings-upgrade-errorImage"
            var title = "Looks like you have not recorded anything yet !!!"
            var subTitle : String?
            
            if packages.count == 0 {
                //No  Plan User
                imageName = "group_964"
                title = AppDelegate.getDelegate().configs?.noPlanMessageText ?? title
                subTitle = AppDelegate.getDelegate().configs?.noPlanMessageDescription ?? title
            }
            else {
                let recordingAllowedPackageCodes = ["classic", "classic_pack", "classic_plan", "classic_1", "premium", "premium_pack", "premium_plan", "premium_1"]
                var recordingAllowed = false
                for package in packages{
                    if recordingAllowedPackageCodes.contains(package.code.lowercased()){
                        recordingAllowed = true
                        break;
                    }
                }
                
                if recordingAllowed{
                    // No recordings
                    imageName = "group_964"
                    title = "Looks like you have not recorded anything yet!"
                    subTitle = "You can record shows from guide."
                }
                else{
                    // Upgrade plan
                    imageName = "MyRecordings-upgrade-errorImage"
                    title = AppDelegate.getDelegate().configs?.basicPlanMessageText ?? title
                    subTitle = AppDelegate.getDelegate().configs?.basicPlanMessageDescription ?? ""
                }
            }
            
            self.myRecordingsErrorView.imageView.image = UIImage.init(named: imageName)
            self.myRecordingsErrorView.titleLabel.text = title
            self.myRecordingsErrorView.subTitleLabel.text = subTitle
            self.myRecordingsErrorView.subTitleLabel.isHidden = (subTitle == nil)
            self.myRecordingsErrorView.isHidden = false
            self.myRecordingsErrorView.resetConstraints()
            
            
        }) { (error) in
            self.myRecordingsErrorView.imageView.image = UIImage.init(named: "group_964")
            self.myRecordingsErrorView.titleLabel.text = error.message
            self.myRecordingsErrorView.subTitleLabel.text = "You can record shows from guide."
            self.myRecordingsErrorView.subTitleLabel.isHidden = false
            self.myRecordingsErrorView.isHidden = false
            self.myRecordingsErrorView.resetConstraints()
        }
    }
    
    func getContinueWatchingList() {
        return;
        let yuppFLixUserDefaults = UserDefaults.standard
        var continueWatchingList:NSMutableArray!
        if yuppFLixUserDefaults.object(forKey: "Continue_Watching_List") == nil {
            continueWatchingList = NSMutableArray()
        }
        else{
            let continueDict = self.getDataFromUserDefaults()
            let continueList = continueDict["Continue_Watching_List"]
            if continueList != nil {
                if continueList is NSArray {
                    continueWatchingList = NSMutableArray.init(array: continueList as! NSArray)
                }
                else{
                    continueWatchingList = continueList as! NSMutableArray
                }
            }
            else {
                continueWatchingList = NSMutableArray()
            }
        }
        if continueWatchingList.count > 0 {
            //            self.startAnimating(allowInteraction: false)
            var itemsObjList = [Card]()
            for continueWatchingObj in continueWatchingList {
                
                let card = Card()
                let analyticsInfoObj = continueWatchingObj as! [String:String]
                card.target.path = analyticsInfoObj["playingItemTargetPath"]!
                card.cardType = .common_poster
                card.display.imageUrl = analyticsInfoObj["defaultPlayingItemUrl"]!
                card.display.title = analyticsInfoObj["playingItemTitle"]!
                card.display.subtitle1 = analyticsInfoObj["playingItemSubTitle"]!
                itemsObjList.append(card)
            }
            
            for pageData in self.pageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as? Section
                    var serverCardsList = section?.sectionData.data
                    var localCardsList = [Card]()
                    if section?.sectionData.section == "continue_watching" {
                        if serverCardsList?.count == 0 {
                            section?.sectionData.data = itemsObjList
                            self.homeCV.reloadData()
                            self.errorView.isHidden = true
                            break;
                        }
                        else {
                            for cardObj in itemsObjList {
                                let index = self.checkIsContentAvailableInServer(cardObj, serverContentList: serverCardsList!)
                                if index != -1 {
                                    serverCardsList?.remove(at: index)
                                    if localCardsList.count == 0 {
                                        localCardsList.append(cardObj)
                                    }
                                    else {
                                        localCardsList.insert(cardObj, at: 0)
                                    }
                                }
                                else {
                                    if localCardsList.count == 0 {
                                        localCardsList.append(cardObj)
                                    }
                                    else {
                                        localCardsList.insert(cardObj, at: 0)
                                    }
                                }
                            }
                            section?.sectionData.data = serverCardsList!
                            section?.sectionData.data.insert(contentsOf: localCardsList, at: 0)
                            self.homeCV.reloadData()
                            self.errorView.isHidden = true
                            break;
                        }
                    }
                }
            }
        }
        else {
            for pageData in self.pageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as? Section
                    if section?.sectionData.section == "continue_watching" && section?.sectionData.data.count == 0{
                        self.pageData.remove(at: 0)
                        break;
                    }
                }
            }
        }
    }
    
    func getDataFromUserDefaults() -> [String:Any] {
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueDict = [String:Any]()
        if let userID = (OTTSdk.preferenceManager.user?.userId) {
            if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") != nil {
                let data = yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") as! Data
                let finalContinueWatchingList = NSKeyedUnarchiver.unarchiveObject(with: data)
                if finalContinueWatchingList is  [String:[String:[String:Any]]]{
                    let tempFinalContinueWatchingList = finalContinueWatchingList as! [String:[String:[String:Any]]]
                    let userIDContinueWatchingDict = tempFinalContinueWatchingList["Continue_Watching_List"]
                    if let continueWatchingDict = userIDContinueWatchingDict!["\(userID)"] {
                        continueDict = continueWatchingDict
                    }
                }
            }
        }
        return continueDict
    }
    
    func checkIsContentAvailableInServer(_ cardObj:Card, serverContentList:[Card]) -> Int {
        for (index,tempCardObj) in serverContentList.enumerated() {
            if cardObj.target.path == tempCardObj.target.path {
                return index
            }
        }
        return -1
    }
    
    func getRecentlyWatchedList() {
        return;
        let yuppFLixUserDefaults = UserDefaults.standard
        var continueWatchingList = NSMutableArray()
        if yuppFLixUserDefaults.object(forKey: "Recently_Watching_List") == nil {
            continueWatchingList = NSMutableArray()
        }
        else{
            let recentDict = self.getRecentlyWatchedDataFromUserDefaults()
            let continueList = recentDict["Recently_Watching_List"]
            if continueList != nil {
                if continueList is NSArray {
                    continueWatchingList = NSMutableArray.init(array: continueList as! NSArray)
                }
                else{
                    continueWatchingList = continueList as! NSMutableArray
                }
            }
        }
        if continueWatchingList.count > 0 {
            //            self.startAnimating(allowInteraction: false)
            var itemsObjList = [Card]()
            for continueWatchingObj in continueWatchingList {
                
                let card = Card()
                let analyticsInfoObj = continueWatchingObj as! [String:String]
                card.target.path = analyticsInfoObj["playingItemTargetPath"]!
                card.cardType = .common_poster
                card.display.imageUrl = analyticsInfoObj["defaultPlayingItemUrl"]!
                card.display.title = analyticsInfoObj["playingItemTitle"]!
                card.display.subtitle1 = analyticsInfoObj["playingItemSubTitle"]!
                itemsObjList.append(card)
            }
            
            for pageData in self.pageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as? Section
                    var serverCardsList = section?.sectionData.data
                    var localCardsList = [Card]()
                    if section?.sectionData.section == "last_watched" {
                        
                        if serverCardsList?.count == 0 {
                            section?.sectionData.data = itemsObjList
                            self.homeCV.reloadData()
                            self.errorView.isHidden = true
                            break;
                        }
                        else {
                            for cardObj in itemsObjList {
                                let index = self.checkIsContentAvailableInServer(cardObj, serverContentList: serverCardsList!)
                                if index != -1 {
                                    serverCardsList?.remove(at: index)
                                    if localCardsList.count == 0 {
                                        localCardsList.append(cardObj)
                                    }
                                    else {
                                        localCardsList.insert(cardObj, at: 0)
                                    }
                                }
                                else {
                                    if localCardsList.count == 0 {
                                        localCardsList.append(cardObj)
                                    }
                                    else {
                                        localCardsList.insert(cardObj, at: 0)
                                    }
                                }
                            }
                            section?.sectionData.data = serverCardsList!
                            section?.sectionData.data.insert(contentsOf: localCardsList, at: 0)
                            self.homeCV.reloadData()
                            self.errorView.isHidden = true
                            break;
                        }
                    }
                }
            }
        }
        else {
            for pageData in self.pageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as? Section
                    if section?.sectionData.section == "last_watched" && section?.sectionData.data.count == 0 {
                        self.pageData.remove(at: self.recentlyContinueWatchIndex)
                        break;
                    }
                }
            }
        }
    }
    
    func getRecentlyWatchedDataFromUserDefaults() -> [String:Any] {
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueDict = [String:Any]()
        if let userID = (OTTSdk.preferenceManager.user?.userId) {
            if yuppFlixUserDefaults.object(forKey: "Recently_Watching_List") != nil {
                let data = yuppFlixUserDefaults.object(forKey: "Recently_Watching_List") as! Data
                let finalContinueWatchingList = NSKeyedUnarchiver.unarchiveObject(with: data)
                if finalContinueWatchingList is  [String:[String:[String:Any]]]{
                    let tempFinalContinueWatchingList = finalContinueWatchingList as! [String:[String:[String:Any]]]
                    let userIDContinueWatchingDict = tempFinalContinueWatchingList["Recently_Watching_List"]
                    if let continueWatchingDict = userIDContinueWatchingDict!["\(userID)"] {
                        continueDict = continueWatchingDict
                    }
                }
            }
        }
        return continueDict
    }
    
    
    //    var sections_temp = [SectionMetaData]()
    var pageData = [PageData]()
    var totalPageData = [PageData]()
    var reOrderTotalPageData = [PageData]()
    var totalHasMoreDataPageData = [PageData]()
    var bannerData = [Banner]()
    let refreshControl = UIRefreshControl()
    var targetedMenu = String()
    let secInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
    var selectedSubMenuIndexPath = IndexPath()
    // vc methods
    func configure(item : Menu) {
        menuItem = item
    }
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        self.mainView.isHidden = true
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.purple
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = (productType.iPad ? true : false)
        searchButton.isHidden = TabsViewController.shouldHideSearchButton
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationBarView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        
        self.title = "Home".localized
        if isToViewMore {
            self.sectionTitleLabel.text = sectionTitle
            self.sectionTitleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
            self.collectionViewTopConstraint.constant = 67.0
            if DeviceType.IS_IPHONE_X  {
                self.collectionViewTopConstraint.constant = 95.0
            }
            self.navigationBarView.isHidden = false
            //            self.view.backgroundColor = UIColor.init(red: 23.0/255.0, green: 25.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        }
//        TabsViewController.instance.delegate = self
        self.indexPath = 0
        refreshControl.tintColor = UIColor.activityIndicatorColor()
        refreshControl.addTarget(self, action: #selector(Refresh(_:)), for: .valueChanged)
        refreshControl.alignmentRect(forFrame: homeCV.frame)
        if #available(iOS 10.0, *) {
            homeCV.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        self.noContentLbl.text = "No Content available".localized
        self.noContentLbl.textColor = AppTheme.instance.currentTheme.noContentAvailableTitleColor
        if self.targetedMenu == AppDelegate.getDelegate().favouritesTargetPath || self.targetedMenu == "mylibrary"{
            self.noContentLbl.text = "No Content Found".localized
            self.noContentLbl.textColor = UIColor.init(hexString:"37393c")
            self.noContentLbl.font = UIFont.ottBoldFont(withSize: 20.0)
        }
        
        homeCV.insertSubview(refreshControl, at: 0)
        homeCV.alwaysBounceVertical = true
        
        homeCV.setContentOffset(CGPoint.zero, animated: true)
        
        homeCV?.register(UINib(nibName: "BannerCVC", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "bannerCellId")
        homeCV.register(UINib(nibName: "LiveCVC", bundle: nil), forCellWithReuseIdentifier: "liveCellId")
        homeCV.register(UINib(nibName: "CatchupCVCEpg", bundle: nil), forCellWithReuseIdentifier: "CatchupCVCEpg")
        homeCV.register(UINib(nibName: SectionCVC.nibname, bundle: nil), forCellWithReuseIdentifier: SectionCVC.identifier)
        homeCV.register(UINib(nibName: "TVShowsCVC", bundle: nil), forCellWithReuseIdentifier: "tvShowsCellId")
        homeCV.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifier")
        homeCV.register(UINib(nibName: "UnifiedNativeAdCell", bundle: nil), forCellWithReuseIdentifier: "UnifiedNativeAdCell")

        homeCV.dataSource = self
        homeCV.delegate = self
        
        
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
        
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
        if menuItem == nil {
            self.getTargetedMenuData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(recordedNewContent(notification:)), name: PartialRenderingView.instance.recordNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollToTop), name: NSNotification.Name(rawValue: "ScrollToTop"), object: nil)
        if !isToViewMore {
            NotificationCenter.default.addObserver(self, selector: #selector(Refresh(_:)), name: NSNotification.Name(rawValue: "GetContinueWatchingList"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(Refresh(_:)), name: NSNotification.Name(rawValue: "GetRecentlyWatchedList"), object: nil)
        }
        if self.targetedMenu == "recordings" {
            NotificationCenter.default.addObserver(self, selector: #selector(self.Refresh(_:)), name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
        }
        self.homeCV.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        
        self.displayNativeAds()
        self.loadBannerAd()
        self.updateDocPlayerFrame()
        self.setUpDobAndGenderUI()
        if AppDelegate.getDelegate().isDobPopup_ContentPage == false {
            self.perform(#selector(showDobAndGenderPopUp), with: nil, afterDelay: 1.5)
            AppDelegate.getDelegate().isDobPopup_ContentPage = true
            let yuppFLixUserDefaults = UserDefaults.standard
            if yuppFLixUserDefaults.object(forKey: "socialMediaPopup") == nil {
                yuppFLixUserDefaults.set(true, forKey: "socialMediaPopup")
                self.perform(#selector(showSocialMediaPopup), with: nil, afterDelay: 1.5)
            }
        }
        else {
            AppDelegate.getDelegate().window?.bringSubviewToFront(self.mainView)
        }
        
    }
    @objc private func showSocialMediaPopup() {
        self.socialMediaPopupBgView.isHidden = true
        if let config = AppDelegate.getDelegate().configs {
            if config.interstitialStaticPopup.count > 3 {
                
                if let interstitialStaticPopupDict = config.interstitialStaticPopup.convertToJson() as? [String : Any] {
                    
                    if let _title = interstitialStaticPopupDict["title"] as? String {
                        self.socialMediaTitleLabel.text = _title
                    }
                    else {
                        self.socialMediaTitleLabel.text = ""
                    }
                    
                    if let _subtitle = interstitialStaticPopupDict["subtitle"] as? String {
                        self.socialMediaSubTitleLabel.text = _subtitle
                    }
                    else {
                        self.socialMediaSubTitleLabel.text = ""
                    }
                    
                    if let _backGroundImagePathMobile = interstitialStaticPopupDict["backGroundImagePathMobile"] as? String {
                        self.socialMediaBackGroundImageView.sd_setImage(with: URL(string: _backGroundImagePathMobile))
                    }
                    if let _buttonsArray = interstitialStaticPopupDict["buttons"] as? [[String : Any]] {
                        self.socialMediaOptionsListArray = _buttonsArray
                    }
                    self.socialMediaPopupBgView.layer.cornerRadius = 8.0
                    self.socialMediaPopupBgView.layer.masksToBounds = true
                    self.socialMediaPopupBgView.backgroundColor = .clear
                    self.socialMediaBackGroundImageView.backgroundColor = .clear
                    self.socialMediaTitleLabel.textColor = UIColor.white
                    self.socialMediaTitleLabel.backgroundColor = .clear
                    self.socialMediaTitleLabel.font = UIFont.ottSemiBoldFont(withSize: 22)
                    
                    self.socialMediaSubTitleLabel.textColor = UIColor.white
                    self.socialMediaSubTitleLabel.font = UIFont.ottMediumFont(withSize: 14)
                    
                    self.socialMediaPopupCloseButton.backgroundColor = .clear

                    self.socialMediaPopupCloseButton.setImage(UIImage.init(named: "img_close_circle.png"), for: .normal)
                    self.socialMediaTableView.backgroundColor = .clear
                    self.socialMediaTableView.separatorColor = .clear

                    
                    let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.socialMediaTableView.frame.size.width, height: 1))
                    self.socialMediaTableView.tableFooterView = footerView
                    
                    self.socialMediaTableView.delegate = self
                    self.socialMediaTableView.dataSource = self
                    
                    self.socialMediaTableView.reloadData()
                    
                    self.socialMediaPopupBgView.isHidden = false

                }
            }
        }
    }
    private func setUpDobAndGenderUI() {
        dobView.removeFromSuperview()
        genderBgView.removeFromSuperview()
        userFieldStackView.removeArrangedSubview(dobView)
        userFieldStackView.removeArrangedSubview(genderBgView)
        mainView.frame = UIScreen.main.bounds
        mainView.tag = 1100
        mainInnerView.layer.cornerRadius = 8.0
        mainInnerView.layer.masksToBounds = true
        mainInnerViewMiddleConstraint.constant = UIScreen.main.bounds.size.height
        mainInnerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        mainView.isHidden = true
        view.addSubview(mainView)
        self.mainView.removeFromSuperview()
        datePicker.maximumDate = Date()
        dobTextField?.inputView = datePicker
        dobTextField?.inputAccessoryView = toolBar
        for label in genderLabelsArray {
            label.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        genderLabel.textColor = AppTheme.instance.currentTheme.textFieldBorderColor
        userHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        userSubHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50
        dobController = MDCTextInputControllerOutlined(textInput: dobTextField)
        dobController?.activeColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.userProfileTextFieldColor
        dobController?.textInput?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        dobTextField.center = .zero
        dobTextField.clearButtonMode = .never
        submitButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        submitButton.setTitle("SUBMIT".localized, for: .normal)
        submitButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        submitButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        submitButton.layer.cornerRadius = 5.0
        submitButton.layer.masksToBounds = true
        
        cancelButton.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        cancelButton.setTitle("CANCEL".localized, for: .normal)
        cancelButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.layer.masksToBounds = true
        
        userHeadingLabel.font = UIFont.ottMediumFont(withSize: 16)
        userSubHeadingLabel.font = UIFont.ottRegularFont(withSize: 12)
    }
    private func setUpAgreeViewUI() {
        agreeView.frame = UIScreen.main.bounds
        agreeView.tag = 1200
        agreeInnerView.layer.cornerRadius = 8.0
        agreeInnerView.layer.masksToBounds = true
        agreeInnerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        agreeView.isHidden = true
        view.addSubview(agreeView)
        self.agreeView.removeFromSuperview()
        self.agreeView.removeFromSuperview()
        agressSubHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        agreeHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        
        agressSubmitButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        agressSubmitButton.setTitle("Agree".localized, for: .normal)
        agressSubmitButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        agressSubmitButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        agressSubmitButton.layer.cornerRadius = 5.0
        agressSubmitButton.layer.masksToBounds = true
        
        agreeCancelButton.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        agreeCancelButton.setTitle("Cancel".localized, for: .normal)
        agreeCancelButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        agreeCancelButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        agreeCancelButton.layer.cornerRadius = 5.0
        agreeCancelButton.layer.masksToBounds = true
        
        agreeHeadingLabel.font = UIFont.ottMediumFont(withSize: 20)
        agressSubHeadingLabel.font = UIFont.ottRegularFont(withSize: 12)
        
        pinView.frame = UIScreen.main.bounds
        pinView.tag = 1300
        pinInnerView.layer.cornerRadius = 8.0
        pinInnerView.layer.masksToBounds = true
        pinInnerView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        pinView.isHidden = true
        view.addSubview(pinView)
        self.pinView.removeFromSuperview()
        self.pinView.removeFromSuperview()
        pinSubHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        pinHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        
        pinSubmitButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        pinSubmitButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        pinSubmitButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        pinSubmitButton.layer.cornerRadius = 5.0
        pinSubmitButton.layer.masksToBounds = true
        
        pinCancelButton.backgroundColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinCancelButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        pinCancelButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        pinCancelButton.layer.cornerRadius = 5.0
        pinCancelButton.layer.masksToBounds = true
        
        pinHeadingLabel.font = UIFont.ottMediumFont(withSize: 20)
        pinSubHeadingLabel.font = UIFont.ottRegularFont(withSize: 12)
        pinErrorMsgLabel.font = UIFont.ottRegularFont(withSize: 12.0)
        
        pinNumberController = MDCTextInputControllerOutlined(textInput: pinTextField)
        pinNumberController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinTextField.center = .zero
        pinTextField.clearButtonMode = .never
        pinErrorMsgLabel.text = ""
        pinTextField.text = ""
        pinTextField.resignFirstResponder()
        pinInnerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        pinErrorMsgLabel.textColor = AppTheme.instance.currentTheme.themeColor
        pinTextField.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        pinTextField?.inputAccessoryView = toolBar
        pinTextField.font = UIFont.ottMediumFont(withSize: 20)

        pinForgotButton.setTitle("Forgot PIN ?".localized, for: .normal)
        pinForgotButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        pinForgotButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 10)
        pinForgotView.removeFromSuperview()
        pinForgotStackView.removeArrangedSubview(pinForgotView)
        
        continueBrowView.frame = UIScreen.main.bounds
        continueBrowView.tag = 1400
        continueBrowView.isHidden = true
        view.addSubview(continueBrowView)
        self.continueBrowView.removeFromSuperview()
        self.continueBrowView.removeFromSuperview()
        continueHeadingLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        
        continueButton.backgroundColor = UIColor.getButtonsBackgroundColor()
        continueButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        continueButton.titleLabel?.font = UIFont.ottMediumFont(withSize: 14)
        continueButton.layer.cornerRadius = 5.0
        continueButton.layer.masksToBounds = true
        continueButton.setTitle("Continue Browsing".localized, for: .normal)
        continueHeadingLabel.font = UIFont.ottRegularFont(withSize: 18)
        continueHeadingLabel.text = "You have successfully created your new PIN".localized
        showAgreeViewPopUp()
    }
    @IBAction private func cancelDetailsAction(_ sender : Any) {
        mainInnerViewMiddleConstraint.constant = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }completion: { (_) in
            self.mainView.removeFromSuperview()
        }
        AppDelegate.getDelegate().isDobPopup_ContentPage = false
    }
    @IBAction private func submitDetailsAction(_ sender : Any) {
        if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let user_fields = system_features.userfields as? FeatureAndFields, let fields = user_fields.fields as? Fields {
            let _dob = dobTextField?.text?.trimmingCharacters(in: .whitespaces) ?? ""
            if fields.age == 2 {
                guard _dob.count > 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please select date of birth".localized, needAction: false) { (flag) in }
                    return
                }
                dob = _dob
            }
            else if fields.age == 1 {
                if _dob.count > 0 {
                    dob = _dob
                }
            }
            if fields.gender == 2 {
                guard genderIndex >= 0 else {
                    errorAlert(forTitle: String.getAppName(), message: "Please select gender".localized, needAction: false) { (flag) in }
                    return
                }
            }
        }
        self.startAnimating(allowInteraction: true)//"\(tempTimeInterval ?? 0)"
        OTTSdk.userManager.updateUserDetails(first_name: nil, last_name: nil, email_id: nil, grade: nil, board: nil, targeted_exam: nil, email_notification: nil, date_of_birth: getDob(), iit_jee_neet_application_no: nil, gender: getGenderString(), onSuccess: { (response) in
            self.errorAlert(forTitle: String.getAppName(), message: response, needAction: true) { flag in
                self.dobTextField.text = ""
                self.genderIndex = -1
                self.updateData()
                self.cancelDetailsAction(self)
                saveUserConsentOnAgeAndDob()
                OTTSdk.userManager.userInfo { _ in
                } onFailure: { _ in
                }
            }
            self.stopAnimating()
        }) { (error) in
            self.stopAnimating()
            self.errorAlert(forTitle: String.getAppName(), message: error.description, needAction: false) { flag in}
        }
    }
    private func updateData() {
        for imageView in checkBoxImageViewArray {
            imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_normal")
        }
        if genderIndex >= 0 {
            if let imageView = checkBoxImageViewArray.first(where: {$0.tag == genderIndex}) {
                imageView.image = #imageLiteral(resourceName: "user_profile_checkbox_selected")
            }
        }
    }
    private func getDob()->String? {
        if dob.count > 0, userFieldStackView.arrangedSubviews.contains(dobView) {
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let epochDate = Int64(tempTimeInterval)
            let timezoneEpochOffset = (epochDate + Int64(timezoneOffset))
            return "\(timezoneEpochOffset)"
        }
        return nil
    }
    private func getGenderString()->String? {
        switch genderIndex {
        case 0: return "M"
        case 1: return "F"
        case 2: return "O"
        default:
            return nil
        }
    }
    private func getGenderIndex(gender : String)->Int {
        switch gender {
        case "M": return 0
        case "F": return 1
        case "O": return 2
        default:
            return -1
        }
    }
    @IBAction func doneButtonAction(_ sender : Any) {
        dobTextField?.resignFirstResponder()
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTextField?.text = tempTimeInterval.getDateOfBirth()
        pinTextField.resignFirstResponder()
    }
    @IBAction func datePickerValueChanged(_ sender : UIDatePicker) {
        tempTimeInterval = datePicker.date.timeIntervalSince1970 * 1000
        dobTextField?.text = tempTimeInterval.getDateOfBirth()
    }
    @IBAction func genderButtonAction(_ sender : UIButton) {
        genderIndex = sender.tag
        updateData()
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
        if productType.iPad {
            homeCV.reloadData()
            //            MovieCV.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    func displayNativeAds(){
        if AppDelegate.getDelegate().showNativeAds {
            let tempBannerUnitId = AppDelegate.getDelegate().defaultNativeAdTag
            //let tempBannerUnitId = "/28418187/nativeads/nativead320100"
            numAdsToLoad = 5
            adInterval = 2
            self.loadAddRequest(tempBannerUnitId)
        }
        /*if AppDelegate.getDelegate().showNativeAds {
            if self.pageContentResponse.adUrlResponse.adUrlTypes.count > 0{
                var tempBannerUnitId = ""
                for b in self.pageContentResponse.adUrlResponse.adUrlTypes{
                    if b.urlType == .native {
                        if !b.adUnitId.isEmpty{
                            tempBannerUnitId = b.adUnitId
                        }
                        if !(b.position.maxCount.isEmpty) {
                            if let textInt = Int(b.position.maxCount) {
                                numAdsToLoad = textInt
                            }
                        }
                        if !(b.position.interval.isEmpty) {
                            if let textInt = Int(b.position.interval) {
                                adInterval = textInt
                            }
                        }
                        self.loadAddRequest(tempBannerUnitId)
                    }
                }
            }
        }*/
    }
    func loadAddRequest(_ unitId : String) {
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: unitId,
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [options])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
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
        if self.adBannerViewHeightConstraint != nil {
            self.adBannerViewHeightConstraint.constant = 0.0
        }
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
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is TabsViewController ||  UIApplication.topVC() is ContentViewController {
            self.updateDocPlayerFrame()
            var ccHeight:CGFloat = 0.0
            if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
                ccHeight = miniMediaControlsViewController.minHeight
            }
            AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    @objc func recordedNewContent(notification : NSNotification) {
        if self.targetedMenu == "my_recordings"{
            self.Refresh("")
        }
        /*if let obj = (notification.object as? [String : Any]){
         let content = obj["content"]
         }*/
    }
    
    @objc func scrollToTop() {
        self.homeCV.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func getNumberOfItemsForSection() {
        var tempPageData = [PageData]()
        var tempTotalPageData = [PageData]()
        var reOrderTempTotalPageData = [PageData]()
        var tempTotalHasMoreDataPageData = [PageData]()
        var tempRecentlyWatchedData = [PageData]()
        var tempContineWatchingData = [PageData]()
        for pageData in self.pageData {
            if pageData.paneType == .section {
                let section = pageData.paneData as? Section
                tempTotalPageData.append(pageData)
                reOrderTempTotalPageData.append(pageData)
                if section?.sectionData.section == "last_watched" && (section?.sectionData.hasMoreData)! && section?.sectionData.data.count == 0 {
                    tempRecentlyWatchedData.append(pageData)
                }
                else if section?.sectionData.section == "continue_watching" && (section?.sectionData.hasMoreData)! && section?.sectionData.data.count == 0 {
                    tempContineWatchingData.append(pageData)
                }
                else {
                    
                    if (section?.sectionData.hasMoreData)! && (section?.sectionData.data.count)! == 0 {
                        tempTotalHasMoreDataPageData.append(pageData)
                    }
                    if (section?.sectionData.data.count)! > 0 {
                        if section?.sectionData.section == "last_watched"{
                            //                            if tempPageData.count == 0 {
                            tempPageData.append(pageData)
                            //                            }
                            //                            else {
                            //                                tempPageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                            //                            }
                        }
                        else if section?.sectionData.section == "continue_watching" {
                            //                            if tempPageData.count == 0 {
                            tempPageData.append(pageData)
                            //                            }
                            //                            else {
                            //                                self.recentlyContinueWatchIndex = 0
                            //                                tempPageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                            //                                self.recentlyContinueWatchIndex = self.recentlyContinueWatchIndex + 1
                            //                            }
                        }
                        else {
                            tempPageData.append(pageData)
                        }
                    }
                }
            }
            else {
                tempPageData.append(pageData)
                tempTotalPageData.append(pageData)
                /*
                 let content = pageData.paneData as? Content
                 self.contentCellHeight = CGFloat(CGFloat((content?.dataRows.count)!) * 75.0)
                 self.contentCellHeight = self.contentCellHeight + self.freetrail_titleLabel.frame.size.height
                 self.freeTrailViewHeight = self.contentCellHeight*/
            }
        }
        self.pageData = tempPageData
        self.totalPageData = tempTotalPageData
        self.totalHasMoreDataPageData = tempTotalHasMoreDataPageData
        if self.pageData.count == 0 {
            for pageData in self.totalPageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    if section.sectionData.hasMoreData {
                        self.loadNextSectionContent(section: section,pageData: pageData)
                    }
                }
            }
            self.totalPageData = self.pageData
        }
        else {
            for pageData in self.totalHasMoreDataPageData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    if section.sectionData.hasMoreData {
                        self.loadNextSectionContent(section: section,pageData: pageData)
                    }
                }
            }
        }
        if tempRecentlyWatchedData.count > 0 {
            for pageData in tempRecentlyWatchedData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(section.sectionData.dataRequestDelay)) {
                        if section.sectionData.hasMoreData {
                            self.loadNextSectionContent(section: section,pageData: pageData)
                        }
                    }
                }
            }
        }
        if tempContineWatchingData.count > 0 {
            for pageData in tempContineWatchingData {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(section.sectionData.dataRequestDelay)) {
                        if section.sectionData.hasMoreData {
                            self.loadNextSectionContent(section: section,pageData: pageData)
                        }
                    }
                }
            }
        }
    }
    /**/

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.homeCV.reloadData()
        if self.targetedMenu == "live" {
            let yuppFLixUserDefaults = UserDefaults.standard
            if yuppFLixUserDefaults.object(forKey: "LiveCardShowCaseView") == nil {
                TabsViewController.instance.showCouchScreen()
                self.homeCV.isUserInteractionEnabled = false
                //                self.liveCardCouchScreenView.isHidden = false
                //                self.liveCardCouchScreenView1.isHidden = false
                //                self.presentShowCaseView(withText: "See what is currently playing on your favourite channel.", forView: AppDelegate.getDelegate().liveCouchScreenCell!)
                yuppFLixUserDefaults.set(true, forKey: "LiveCardShowCaseView")
            }
        }
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            ccHeight = miniMediaControlsViewController.minHeight
        }
        if AppDelegate.getDelegate().countriesInfoArray.count == 0 {
            AppDelegate.getDelegate().getMyCountiesList(isUpdated: false, completion: nil)
        }
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
        if menuItem != nil, menuItem.params != nil, let user = OTTSdk.preferenceManager.user, isForgotPin == false {
            self.homeCV.isHidden = true
            self.pinTextField.text = ""
            self.pinTextField.resignFirstResponder()
            self.pinHeadingLabel.removeFromSuperview()
            self.pinLogoImageView.removeFromSuperview()
            self.pinStackView.removeArrangedSubview(self.pinHeadingLabel)
            self.pinStackView.removeArrangedSubview(self.pinLogoImageView)
            if user.profileParentalDetails.count == 0 || user.profileParentalDetails.first?.isPinAvailable == false {
                self.setUpAgreeViewUI()
                self.pinStackView.addArrangedSubview(self.pinLogoImageView)
                self.pinSubmitButton.setTitle("Confirm".localized, for: .normal)
                self.pinCancelButton.setTitle("Back".localized, for: .normal)
                self.pinSubHeadingLabel.text = "Create your 4 digit PIN for Registration".localized
            }else if user.profileParentalDetails.first?.isPinAvailable == true {
                if let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let parental_control = system_features.parentalcontrol, UserDefaults.standard.double(forKey: "SHOW_PIN_FOR_DARK_POPUP_DURATION") > 0.0 {
                    let date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "SHOW_PIN_FOR_DARK_POPUP_DURATION")/1000.0)
                    let seconds = parental_control.fields.pin_expiry_duration_in_sec_client > 0 ? parental_control.fields.pin_expiry_duration_in_sec_client : 0
                    if let append_date = Calendar.current.date(byAdding: .second, value: seconds, to: date) {
                        switch append_date.compare(Date()) {
                        case .orderedDescending:
                            self.updateTimeToDefaults()
                            self.getTargetedMenuData()
                        default:
                            self.setUpAgreeViewUI()
                            self.showPinView()
                        }
                    }else {
                        self.setUpAgreeViewUI()
                        self.showPinView()
                    }
                }else {
                    self.setUpAgreeViewUI()
                    self.showPinView()
                }
            }
        }
    }
    private func showPinView() {
        self.pinStackView.addArrangedSubview(self.pinHeadingLabel)
        self.pinSubmitButton.setTitle("Continue".localized, for: .normal)
        self.pinCancelButton.setTitle("Cancel".localized, for: .normal)
        self.pinHeadingLabel.text = "Viewing Restrictions Enabled".localized
        self.pinSubHeadingLabel.text = "Enter your PIN to watch this content".localized
        self.pinView.isHidden = false
        self.pinView.removeFromSuperview()
        self.pinForgotStackView.addArrangedSubview(self.pinForgotView)
        view.addSubview(self.pinView)
    }
    @IBAction private func agreeSelectAction(_ sender : Any) {
        self.agreeView.removeFromSuperview()
        self.pinView.isHidden = false
        self.pinView.removeFromSuperview()
        self.view.addSubview(self.pinView)
    }
    @IBAction private func forgotPinAction(_ sender : Any) {
        let forgotPinVc = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ForgotPinVC") as! ForgotPinVC
        forgotPinVc.cancelSelected = {
            self.isForgotPin = false
            self.agreeCancelAction(self)
        }
        forgotPinVc.showPinView = { pin_response in
            self.pinResponse = pin_response
            self.isForgotPin = true
            self.pinTextField.text = ""
            self.setUpAgreeViewUI()
            self.agreeView.removeFromSuperview()
            self.pinView.removeFromSuperview()
            self.pinTextField.resignFirstResponder()
            self.pinHeadingLabel.removeFromSuperview()
            self.pinLogoImageView.removeFromSuperview()
            self.pinStackView.removeArrangedSubview(self.pinHeadingLabel)
            self.pinStackView.removeArrangedSubview(self.pinLogoImageView)
            self.pinStackView.addArrangedSubview(self.pinLogoImageView)
            self.pinSubmitButton.setTitle("Confirm".localized, for: .normal)
            self.pinCancelButton.setTitle("Back".localized, for: .normal)
            self.pinSubHeadingLabel.text = "Create a new 4 digit PIN".localized
            self.agreeSelectAction(self)
        }
        if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootViewController = keyWindow.rootViewController, let navigationVC = rootViewController as? UINavigationController {
            navigationVC.pushViewController(forgotPinVc, animated: true)
        }
    }
    @IBAction private func createPinAction(_ sender : UIButton) {
        self.view.endEditing(true)
//        self.isForgotPin = false
        pinErrorMsgLabel.text = ""
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        guard let pin = pinTextField.text?.trimmingCharacters(in: .whitespaces), pin.count > 0 else {
            pinErrorMsgLabel.text = "Please enter PIN"
            return
        }
        guard pin.count == AppDelegate.getDelegate().parentalControlPinLength else {
            pinErrorMsgLabel.text = "Please enter valid PIN"
            return
        }
        self.startAnimating(allowInteraction: true)
        if let value = sender.titleLabel?.text?.lowercased(), value == "confirm" {
            if self.isForgotPin {
                var json : [String : Any] = ["addProfilePinEnable": true, "isProfileLockActive" : false, "isParentalControlEnable" : false, "profileId" : OTTSdk.preferenceManager.user!.profileId, "pin" : pin]
                if let pin_response = self.pinResponse {
                    json["token"] = pin_response.token
                    json["context"] = pin_response.context
                }
                OTTSdk.userManager.updateUsreParentalControlerPinWith(parameters: json) { message in
                    self.stopAnimating()
                    self.pinView.removeFromSuperview()
                    self.agreeView.removeFromSuperview()
                    self.isForgotPin = false
                    self.continueBrowView.isHidden = false
                    self.view.addSubview(self.continueBrowView)
                    OTTSdk.userManager.userInfo(onSuccess: { (response) in
                        self.stopAnimating()
                    }) { (error) in
                        self.stopAnimating()
                    }
                } onFailure: { error in
                    self.stopAnimating()
                    self.pinErrorMsgLabel.text = error.message
                }
                return
            }
            OTTSdk.userManager.createUsreParentalControlerPinWith(user_id: OTTSdk.preferenceManager.user!.profileId, pin: pin) { message in
                self.stopAnimating()
                self.agreeView.removeFromSuperview()
                self.pinView.removeFromSuperview()
                self.pinTextField.resignFirstResponder()
                self.errorAlert(forTitle: appContants.appName.rawValue, message: message, needAction: true) { boolValue in
                    if boolValue {
                        self.fetchContentDetails()
                        self.updateTimeToDefaults()
                    }
                }
            } onFailure: { error in
                self.stopAnimating()
                self.pinErrorMsgLabel.text = error.message
            }
        }else {
            OTTSdk.userManager.validateUsreParentalControlerPinWith(user_id: OTTSdk.preferenceManager.user!.profileId, pin: pin) { message in
                self.stopAnimating()
                self.agreeView.removeFromSuperview()
                self.pinView.removeFromSuperview()
                self.pinTextField.resignFirstResponder()
                self.updateTimeToDefaults()
                self.Refresh(self)
            } onFailure: { error in
                self.stopAnimating()
                self.pinErrorMsgLabel.text = error.message
            }
        }
    }
    private func updateTimeToDefaults() {
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = Int64(Date().timeIntervalSince1970 * 1000)
        let timezoneEpochOffset = (epochDate + Int64(timezoneOffset))
        UserDefaults.standard.set(Double(timezoneEpochOffset), forKey: "SHOW_PIN_FOR_DARK_POPUP_DURATION")
        UserDefaults.standard.synchronize()
    }
    private func fetchContentDetails() {
        let group = DispatchGroup()
        let contentGroup = DispatchQueue(label: "content")
        let userGroup = DispatchQueue(label: "user")
        group.enter()
        contentGroup.async(group: group) {
            DispatchQueue.main.async {
                self.Refresh(self)
            }
            group.leave()
        }
        group.enter()
        userGroup.async(group: group) {
            sleep(1)
            DispatchQueue.main.async {
                OTTSdk.userManager.userInfo(onSuccess: { (response) in
                    self.stopAnimating()
                }) { (error) in
                    self.stopAnimating()
                }
            }
            group.leave()
        }
        group.notify(queue: .main, execute: {})
    }
    @IBAction private func continueBrowseAction(_ sender : Any) {
        self.continueBrowView.removeFromSuperview()
        self.continueBrowView.isHidden = true
        self.Refresh(self)
    }
    @IBAction private func agreeCancelAction(_ sender : Any) {
        self.agreeView.removeFromSuperview()
        self.pinView.removeFromSuperview()
        self.pinTextField.text = ""
        self.pinTextField.resignFirstResponder()
        self.isForgotPin = false
        TabsViewController.instance.selectedIndexPath = IndexPath(row: 0, section: 0)
        if let collectionView = TabsViewController.instance.HomeToolBarCollection {
            TabsViewController.instance.collectionView(collectionView, didSelectItemAt: TabsViewController.instance.selectedIndexPath)
            collectionView.selectItem(at: TabsViewController.instance.selectedIndexPath, animated: false, scrollPosition: .left)
        }
    }
    @objc private func showAgreeViewPopUp() {
        if let params = menuItem.params, let user = OTTSdk.preferenceManager.user {
            self.agreeView.isHidden = false
            agreeHeadingLabel.text = "Hi ".localized + user.name + "!"
            if params.isPinRequired {
                agressSubHeadingLabel.text = params.pinMessage
                self.agreeView.removeFromSuperview()
                self.view.addSubview(self.agreeView)
            }else {
                agressSubHeadingLabel.text = ""
                getTargetedMenuData()
            }
        }
    }
    @objc private func showDobAndGenderPopUp() {
        self.mainView.isHidden = false
        if let user = OTTSdk.preferenceManager.user, let system_features = OTTSdk.preferenceManager.featuresResponse?.systemFeatures, let user_fields = system_features.userfields, let fields = user_fields.fields as? Fields {
            if fields.age > 0, fields.age == 2, user.dob.doubleValue == 0 {
                cancelButton.removeFromSuperview()
                buttonsStackView.removeArrangedSubview(cancelButton)
                userFieldStackView.insertArrangedSubview(dobView, at: 0)
            }
            if fields.gender > 0, fields.gender == 2, user.gender.count == 0 {
                cancelButton.removeFromSuperview()
                buttonsStackView.removeArrangedSubview(cancelButton)
                if userFieldStackView.arrangedSubviews.count == 2 {
                    userFieldStackView.insertArrangedSubview(genderBgView, at: 1)
                }else {
                    userFieldStackView.insertArrangedSubview(genderBgView, at: 0)
                }
            }
            if fields.age > 0, fields.age == 1, user.dob.doubleValue == 0 {
                userFieldStackView.insertArrangedSubview(dobView, at: 0)
            }
            if fields.gender > 0, fields.gender == 1, user.gender.count == 0 {
                if userFieldStackView.arrangedSubviews.count == 2 {
                    userFieldStackView.insertArrangedSubview(genderBgView, at: 1)
                }else {
                    userFieldStackView.insertArrangedSubview(genderBgView, at: 0)
                }
            }
            
            if user.dob.doubleValue > 0 && user.gender.count > 0 {
                return
            }
            else if fields.age <= 0 && fields.gender <= 0 {
                 return
             }
            else if fields.age == 2 && fields.gender == 1 {
                if getUserConsentOnAgeAndDob() == true {
                    return
                }
            }else if fields.age == 1 && fields.gender == 2 {
                if getUserConsentOnAgeAndDob() == true {
                    return
                }
            }
            else if fields.age == 1 && fields.gender == 1 {
                if getUserConsentOnAgeAndDob() == true {
                    return
                }
            }
            userHeadingLabel.text = "To Enjoy uninterrupted Services".localized
            if self.userFieldStackView.arrangedSubviews.count <= 1 {
                return
            }
            if user.dob.doubleValue == 0 && user.gender.count == 0 {
                userSubHeadingLabel.text = "Please select your date of birth and gender as per new laws".localized
            }else if user.dob.doubleValue == 0 {
                userSubHeadingLabel.text = "Please select your date of birth as per new laws".localized
            }else if user.gender.count == 0 {
                userSubHeadingLabel.text = "Please select your gender as per new laws".localized
            }else {
                userSubHeadingLabel.text = ""
                return
            }
            self.dobTextField.text = user.dob.stringValue
            self.genderIndex = self.getGenderIndex(gender:user.gender)
            self.updateData()
            AppDelegate.getDelegate().window?.addSubview(self.mainView)
            self.mainInnerViewMiddleConstraint.constant = 0.0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func presentShowCaseView(withText:String, forView:UIView) {
        let showcase = MaterialShowcase()
        showcase.setTargetView(view: forView) // always required to set targetView
        showcase.backgroundPromptColor = UIColor.black.withAlphaComponent(0.5)
        showcase.backgroundPromptColorAlpha = 0.96
        showcase.setDefaultProperties()
        showcase.primaryText = withText
        showcase.secondaryText = ""
        showcase.show(completion: {
            // You can save showcase state here
            // Later you can check and do not show it again
        })
    }
    
    @IBAction func couchOkBtnClicked(_ sender: Any) {
        TabsViewController.instance.hideCouchScreen()
        self.homeCV.isUserInteractionEnabled = true
        //        self.liveCardCouchScreenView.isHidden = true
        //        self.liveCardCouchScreenView1.isHidden = true
    }
    
    //    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
    //        homeCV.reloadData()
    ////        homeCV.setContentOffset(CGPoint.zero, animated: true)
    //    }
    
    //MARK: - LiveCVCProtocal delegate Methods
    //    func didSelectedLiveItem(item: Channel) {
    //        print("hi didSelectedLiveItem", item)
    //    }
    //    func live_moreClicked(sect_data:SectionMetaData)
    //    {
    //        print(sect_data.code)
    //        let storyBoard = UIStoryboard(name: "Live", bundle: nil)
    //        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "MoreLiveVC") as! MoreLiveVC
    //        storyBoardVC.secMetaData = sect_data
    //        storyBoardVC.secCodeString = sect_data.code
    //        let topVC = UIApplication.topVC()!
    //        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    //    }
    //
    //    //MARK: - banner delegate Methods
    private func gotoTargetWith(path : String, cardItem : Card?, bannerItem : Banner?, sectionData : SectionData?, sect_data : SectionInfo?, sectionControls : SectionControls?, templateElement: TemplateElement?) {
        if let item = bannerItem, item.target.path == "packages" {
            self.stopAnimating()
            showAlertWithText(message: AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ...")
            return
        }else if let item = bannerItem, !item.isInternal {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            if  playerVC != nil{
                playerVC?.isNavigatingToBrowser = true
                playerVC?.showHidePlayerView(true)
                playerVC?.player.pause()
            }
            view1.urlString = item.target.path
            view1.pageString = item.title
            view1.viewControllerName = "ListViewController"
            self.stopAnimating()
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(view1, animated: true)
            return
        }
 
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
         
            var vc : UIViewController!
            if let tempController = viewController as? PlayerViewController {
                tempController.delegate = self
                if let item = cardItem {
                    tempController.defaultPlayingItemUrl = item.display.imageUrl
                    tempController.playingItemTitle = item.display.title
                    tempController.playingItemSubTitle = item.display.subtitle1
                    tempController.playingItemTargetPath = item.target.path
                }else if let item = bannerItem {
                    tempController.defaultPlayingItemUrl = item.imageUrl
                    tempController.playingItemTitle = item.title
                    tempController.playingItemSubTitle = item.subtitle
                    tempController.playingItemTargetPath = item.target.path
                }
                if templateElement != nil {
                    tempController.templateElement = templateElement
                }
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                AppDelegate.getDelegate().window?.addSubview(tempController.view)
                return
            }else if let tempController = viewController as? ContentViewController {
                tempController.isToViewMore = true
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                }else if let item = bannerItem {
                    tempController.sectionTitle = item.title
                    tempController.targetedMenu = path
                    AppDelegate.getDelegate().presentTargetedMenu = path
                }else {
                    tempController.targetedMenu = path
                    if let data = sect_data {
                        tempController.sectionTitle = data.name
                    }
                }
                vc = tempController
            }else if let tempController = viewController as? DetailsViewController {
                if let item = cardItem {
                    tempController.navigationTitlteTxt = item.display.title
                    tempController.isCircularPoster = item.cardType == .circle_poster ? true : false
                }else if let item = bannerItem {
                    tempController.navigationTitlteTxt = item.title
                }else if let data = sect_data {
                    tempController.navigationTitlteTxt = data.name
                }
                vc = tempController
            }else if let tempController = viewController as? DefaultViewController {
                tempController.delegate = self
                vc = tempController
            }else if let tempController = viewController as? ListViewController {
                tempController.isToViewMore = true
                if let data = sect_data {
                    tempController.sectionTitle = data.name
                }
                vc = tempController
            }else {
                vc = viewController
            }
           
            guard vc != nil else {
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                return
            }
            guard let topVc = UIApplication.topVC() else {
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                return
            }
            topVc.navigationController?.pushViewController(viewController: vc, animated: true, completion: {
                
            })
            if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                rootViewController.stopAnimating()
            }
            self.stopAnimating()
        }
    }
 
    func didSelectedBannerItem(bannerItem: Banner) -> Void
    {
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        gotoTargetWith(path: bannerItem.target.path, cardItem: nil, bannerItem: bannerItem, sectionData: nil, sect_data: nil, sectionControls: nil, templateElement: nil)
    }
    //MARK: - movie custom delegate methods
    fileprivate func goToPage(_ item: Card, templateElement : TemplateElement?) {
        print("................")
        self.startAnimating(allowInteraction: false)
        var path = ""
        if templateElement != nil {
            path = templateElement!.target
        }
        else if item.target.pageAttributes != nil {
            if let _pageSubtype = item.target.pageAttributes!["pageSubtype"] as? String, _pageSubtype == "pdf" {
                gotoPdfPage(path: item.target.path,title:item.display.title)
                return
            }
            else{
                path = item.target.path
            }
        }
        else {
            path = item.target.path
        }
        gotoTargetWith(path: path, cardItem: item, bannerItem: nil, sectionData: nil, sect_data: nil, sectionControls: nil, templateElement: templateElement)
        
    }
    func gotoPdfPage(path:String,title:String) {
        self.stopAnimating()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Content", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "PdfFileViewController") as! PdfFileViewController
        view1.pdfPath = path
        view1.pageString = title
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
    }
    func didSelectedRollerPosterItem(item: Card) -> Void{
        
        self.startAnimating(allowInteraction: false)
        if item.template.count > 0{
            PartialRenderingView.instance.reloadFor(card: item, content: nil, partialRenderingViewDelegate: self)
            self.stopAnimating()
            return;
        }
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        AppDelegate.getDelegate().sourceScreen = "\(self.targetedMenu.capitalized)_Page"
        LocalyticsEvent.tagEventWithAttributes("\(self.targetedMenu.capitalized)_Page", ["Language":OTTSdk.preferenceManager.selectedLanguages, "Partners" : "", "Content Name":item.display.title])
        goToPage(item,templateElement: nil)
    }
    func rollerPoster_moreClicked(sectionData:SectionData,sect_data:SectionInfo,sectionControls:SectionControls){
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        gotoTargetWith(path: sectionControls.viewAllTargetPath, cardItem: nil, bannerItem: nil, sectionData: sectionData, sect_data: sect_data, sectionControls: sectionControls, templateElement: nil)
        
    }
    
    func programRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) {
        if OTTSdk.preferenceManager.user != nil {
            let vc = ProgramRecordConfirmationPopUp()
            vc.delegate = self
            vc.programObj = item
            vc.sectionIndex = sectionIndex
            vc.rowIndex = rowIndex
            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
            })
        } else {
            errorAlert(forTitle: String.getAppName(), message: "You are not logged in".localized, needAction: false) { (flag) in }
        }
    }
    func programStopRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) {
        if OTTSdk.preferenceManager.user != nil {
            
            let vc = ProgramStopRecordConfirmationPopUp()
            vc.delegate = self
            vc.programObj = item
            vc.sectionIndex = sectionIndex
            vc.rowIndex = rowIndex
            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
            })
        } else {
            errorAlert(forTitle: String.getAppName(), message: "You are not logged in".localized, needAction: false) { (flag) in }
        }
    }
    
    // MARK: - Program Record protocol methods
    
    func programRecordConfirmClicked(programObj:Card?, selectedPrefButtonIndex:Int, sectionIndex:Int, rowIndex:Int) {
        var optionsArr = [String]()
        var content_type = ""
        var content_id = ""
        for marker in programObj!.display.markers {
            if marker.markerType == .record || marker.markerType == .stoprecord {
                optionsArr = marker.value.components(separatedBy: ",")
            }
        }
        let strArr = optionsArr[selectedPrefButtonIndex].components(separatedBy: "&")
        if strArr.count > 2 {
            content_type = strArr[0].components(separatedBy: "=")[1]
            content_id = strArr[1].components(separatedBy: "=")[1]
        }
        
        //        self.startAnimating(allowInteraction: true)
        //
        //        OTTSdk.mediaCatalogManager.startStopRecord(content_type: content_type, content_id: content_id, action: "1", onSuccess: { (response) in
        //            self.stopAnimating()
        //            if content_type == "1" || content_type == "3"{
        //                let tempVal = self.recordingCardsArr.index(of: programObj!.display.subtitle5)
        //
        //                if tempVal == nil {
        //                    self.recordingCardsArr.append(programObj!.display.subtitle5)
        //                } else {
        //                    self.recordingCardsArr.remove(at: tempVal!)
        //                }
        //
        //                let tempVal1 = AppDelegate.getDelegate().recordingCardsArr.index(of: programObj!.display.subtitle5)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingCardsArr.append(programObj!.display.subtitle5)
        //                } else {
        //                    AppDelegate.getDelegate().recordingCardsArr.remove(at: tempVal1!)
        //                }
        //            }
        //            else if content_type == "2"{
        //                let tempVal = self.recordingSeriesArr.index(of: programObj!.display.subtitle4)
        //
        //                if tempVal == nil {
        //                    self.recordingSeriesArr.append(programObj!.display.subtitle4)
        //                } else {
        //                    self.recordingSeriesArr.remove(at: tempVal!)
        //                }
        //
        //                let tempVal1 = AppDelegate.getDelegate().recordingSeriesArr.index(of: programObj!.display.subtitle4)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingSeriesArr.append(programObj!.display.subtitle4)
        //                } else {
        //                    AppDelegate.getDelegate().recordingSeriesArr.remove(at: tempVal1!)
        //                }
        //            }
        //            else{
        //                self.Refresh(UIButton.init())
        //            }
        //
        //
        //            self.homeCV.reloadData()
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
        //
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //        }) { (error) in
        //            print(error.message)
        //            self.stopAnimating()
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //            let alert = UIAlertController(title: String.getAppName(), message: error.message, preferredStyle: UIAlertController.Style.alert)
        //            let cancelAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        //            })
        //            alert.addAction(cancelAlertAction)
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
        
    }
    
    func programRecordCancelClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
        
    }
    
    // MARK: - Program Stop Record protocol methods
    
    func programStopRecordConfirmClicked(programObj:Card?, sectionIndex:Int, rowIndex:Int) {
        var content_type = ""
        var content_id = ""
        var optionsArr = [String]()
        
        var tempID = ""
        let tempVal = self.recordingSeriesArr.firstIndex(of: programObj!.display.subtitle4)
        if tempVal != nil {
            tempID = "2"
        }
        //        else{
        //            let tempVal = self.recordingCardsArr.index(of: programObj!.display.subtitle5)
        //            if tempVal != nil {
        //                tempID = "2"
        //            }
        //        }
        
        for marker in programObj!.display.markers {
            if marker.markerType == .record || marker.markerType == .stoprecord {
                optionsArr = marker.value.components(separatedBy: ",")
            }
        }
        
        for (index,marker) in optionsArr.enumerated(){
            let strArr = marker.components(separatedBy: "&")
            if strArr.count > 2 {
                if strArr[0].components(separatedBy: "=")[1] == tempID{
                    content_type = strArr[0].components(separatedBy: "=")[1]
                    content_id = strArr[1].components(separatedBy: "=")[1]
                }
            }
            if index == optionsArr.count - 1 && content_type == ""{
                let strArr = optionsArr[0].components(separatedBy: "&")
                if strArr.count > 2 {
                    content_type = strArr[0].components(separatedBy: "=")[1]
                    content_id = strArr[1].components(separatedBy: "=")[1]
                }
            }
        }
        
        //        self.startAnimating(allowInteraction: true)
        //
        //        OTTSdk.mediaCatalogManager.startStopRecord(content_type: content_type, content_id: content_id, action: "0", onSuccess: { (response) in
        //            self.stopAnimating()
        //            if content_type == "1" || content_type == "3"{
        //                let tempVal = self.recordingCardsArr.index(of: programObj!.display.subtitle5)
        //
        //                if tempVal == nil {
        //                    self.recordingCardsArr.append(programObj!.display.subtitle5)
        //                } else {
        //                    self.recordingCardsArr.remove(at: tempVal!)
        //                }
        //                let tempVal1 = AppDelegate.getDelegate().recordingCardsArr.index(of: programObj!.display.subtitle5)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingCardsArr.append(programObj!.display.subtitle5)
        //                } else {
        //                    AppDelegate.getDelegate().recordingCardsArr.remove(at: tempVal1!)
        //                }
        //            }
        //            else if content_type == "2"{
        //                let tempVal = self.recordingSeriesArr.index(of: programObj!.display.subtitle4)
        //
        //                if tempVal == nil {
        //                    self.recordingSeriesArr.append(programObj!.display.subtitle4)
        //                } else {
        //                    self.recordingSeriesArr.remove(at: tempVal!)
        //                }
        //
        //                let tempVal1 = AppDelegate.getDelegate().recordingSeriesArr.index(of: programObj!.display.subtitle4)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingSeriesArr.append(programObj!.display.subtitle4)
        //                } else {
        //                    AppDelegate.getDelegate().recordingSeriesArr.remove(at: tempVal1!)
        //                }
        //            }
        //            else{
        //                self.Refresh(UIButton.init())
        //            }
        //            self.homeCV.reloadData()
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //        }) { (error) in
        //            print(error.message)
        //            self.stopAnimating()
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //            let alert = UIAlertController(title: String.getAppName(), message: error.message, preferredStyle: UIAlertController.Style.alert)
        //            let cancelAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        //            })
        //            alert.addAction(cancelAlertAction)
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
    }
    
    func programStopRecordCancelClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
    }
    
    //    //MARK: - tvshows episodes custom delegate methods
    //    func didSelectedTVShowsItem(item: TVShow) -> Void{
    //
    //        if !Utilities.hasConnectivity() {
    //            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
    //            return
    //        }
    //        let storyBoard : UIStoryboard = UIStoryboard(name: "TVShows", bundle:nil)
    //        let showDetailsVC  = storyBoard.instantiateViewController(withIdentifier: "TVShowDetailsVC") as! TVShowDetailsVC
    //        showDetailsVC.tvshowObj = item
    //        showDetailsVC.hidesBottomBarWhenPushed = true
    //        self.navigationController?.isNavigationBarHidden = true
    //        self.navigationController?.pushViewController(showDetailsVC, animated: true)
    //    }
    //    func didSelectedTVShowsEpisodeItem(item: Episode) -> Void{
    //        print(item)
    //    }
    //    func tvShows_moreClicked(sect_data:SectionMetaData){
    //        print(sect_data.code)
    //        let storyBoard = UIStoryboard(name: "TVShows", bundle: nil)
    //        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "MoreTVShowsVC") as! MoreTVShowsVC
    //        storyBoardVC.secMetaData = sect_data
    //        storyBoardVC.secCodeString = sect_data.code
    //        let topVC = UIApplication.topVC()!
    //        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    //    }
    //MARK: - CollectionView data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pageData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        let yuppFLixUserDefaults = UserDefaults.standard
        if yuppFLixUserDefaults.object(forKey: "LiveCardShowCaseView") == nil {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        else {
            return secInsets
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let pageDataItem = self.pageData[indexPath.item]
        if pageDataItem.paneType == .adContent {
            return CGSize(width: 350, height: 120)
        }
        else if pageDataItem.paneType == .section {
            if let section = pageDataItem.paneData as? Section {
                if section.sectionInfo.dataType == "movie" || section.sectionInfo.dataType == "hetro"{
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                        return CGSize(width: view.frame.width, height: 197)
                    }else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                        return CGSize(width: view.frame.width, height: 177)
                    }else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .roller_poster && productType.iPad {
                        return CGSize(width: view.frame.width, height: (206 * 1.3) + 40)
                    }
                    return CGSize(width: view.frame.width, height: 250)
                }
                else if section.sectionInfo.dataType == "epg" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                        return CGSize(width: view.frame.width, height: 197)
                    }
                    return CGSize(width: view.frame.width, height: (productType.iPad ? 222 : 197))
                }
                else if section.sectionInfo.dataType == "network" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                        return CGSize(width: view.frame.width, height: 145)
                    } else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .square_poster {
                        return CGSize(width: view.frame.width, height: 181)
                    }
                    else {
                        return CGSize(width: view.frame.width, height: (productType.iPad ? 166 : 159))
                    }
                }
                else if section.sectionInfo.dataType == "button" {
                    return CGSize(width: view.frame.width, height: 62)
                }
                else if section.sectionInfo.dataType == "entity" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                        return CGSize(width: view.frame.width, height: 177)
                    }
                    else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster, productType.iPad, appContants.appName == .tsat {
                        return CGSize(width: view.frame.width, height: 220)
                    }
                    if section.sectionData.data.count > 0 && appContants.appName == .gac {
                        if productType.iPad {
                            for card in section.sectionData.data {
                                if card.cardType == .sheet_poster {
                                    return CGSize(width: view.frame.width, height: 250)
                                }
                            }
                        }
                    }
                    return CGSize(width: view.frame.width, height: (productType.iPad ? 230 : 197))
                }
                else if section.sectionInfo.dataType == "artist" {
                    if section.sectionData.data.count > 0 && appContants.appName == .gac {
                        if productType.iPad {
                            for card in section.sectionData.data {
                                if card.cardType == .circle_poster {
                                    return CGSize(width: view.frame.width, height: 240)
                                }
                            }
                        } else {
                            for card in section.sectionData.data {
                                if card.cardType == .circle_poster {
                                    return CGSize(width: view.frame.width, height: 180)
                                }
                            }
                        }
                    }
                }
                else {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                        return CGSize(width: view.frame.width, height: 181)
                    }
                    return CGSize(width: view.frame.width, height: (productType.iPad ? 230 : 197)) //222
                }
            }
            return CGSize(width: view.frame.width, height: 239)
        }
        else if pageDataItem.paneType == .content {
            return CGSize(width: view.frame.width-4, height: self.contentCellHeight)
        }
        return CGSize(width: view.frame.width, height: self.contentCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pageDataItem = self.pageData[indexPath.item]
        self.indexPath = indexPath.item
        if pageDataItem.paneType == .section {
            let section = pageDataItem.paneData as? Section
            return getSectionCell(collectionView, cellForItemAt: indexPath, section: section!)
        }
        else if pageDataItem.paneType == .adContent {
            
            let nativeAd = self.nativeAds[pageDataItem.adPositionIndex]
            
            nativeAd.rootViewController = self
            
            let nativeAdCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "UnifiedNativeAdCell", for: indexPath)
            
            // Get the ad view from the Cell. The view hierarchy for this cell is defined in
            // UnifiedNativeAdCell.xib.
            let adView : GADUnifiedNativeAdView = nativeAdCell.contentView.subviews
                .first as! GADUnifiedNativeAdView
            
            // Associate the ad view with the ad object.
            // This is required to make the ad clickable.
            adView.nativeAd = nativeAd
            
            // Populate the ad view with the ad assets.
            (adView.headlineView as! UILabel).text = nativeAd.headline
            (adView.priceView as! UILabel).text = nativeAd.price
            if let starRating = nativeAd.starRating {
                (adView.starRatingView as! UILabel).text =
                    starRating.description + "\u{2605}"
            } else {
                (adView.starRatingView as! UILabel).text = nil
            }
            (adView.bodyView as! UILabel).text = nativeAd.body
            (adView.advertiserView as! UILabel).text = nativeAd.advertiser
            // The SDK automatically turns off user interaction for assets that are part of the ad, but
            // it is still good to be explicit.
            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
            (adView.callToActionView as! UIButton).setTitle(
                nativeAd.callToAction, for: UIControl.State.normal)
            
            return nativeAdCell
            
        }
        else {
            guard let content = (pageDataItem.paneData as? Content) else{
                // Should not come here
                printLog(log: "Content is empty" as AnyObject)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
                cell.backgroundColor = .clear
                return cell;
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
            let freetrailView = UIView.init(frame: CGRect(x: 2, y: 0, width: cell.frame.size.width-4, height: self.freeTrailViewHeight))
            freetrail_backImageView.loadingImageFromUrl(content.backgroundImage, category: "detail_page")
            if (content.contentDescription .isEmpty) {
                self.freetrail_titleLabel.text = content.title
            }
            else {
                self.freetrail_titleLabel.text = content.contentDescription
            }
            self.freetrail_titleLabel.font = UIFont.ottBoldFont(withSize: 18.0)
            self.freeTrailview.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: self.freeTrailViewHeight)
            self.freetrail_descLabel.isHidden = true
            let contentDataRows = content.dataRows
            //            var index = 12
            //            for _ in 1...2 {
            //                let dataRow = content.dataRows[0]
            //                dataRow?.elements[0].data = "\((dataRow?.elements[0].data)!) \(index)"
            //                contentDataRows.append(dataRow!)
            //                index = index + 12
            //            }
            self.freeTitleLblTopConstraint.constant = self.freeTrailViewHeight/CGFloat(4.0 * Double((contentDataRows.count)))
            var yPosition = self.freetrail_titleLabel.frame.origin.y + 20.0
            if (contentDataRows.count) > 1 {
                yPosition = self.freetrail_titleLabel.frame.origin.y - 10.0
            }
            for contentDataRow in contentDataRows {
                let dataElements = contentDataRow.elements
                var xPosition:CGFloat = 0.0
                let width = cell.frame.size.width/CGFloat(dataElements.count)
                var tempYPosition:CGFloat = 0.0
                for dataElement in dataElements {
                    if dataElement.elementType == .text && contentDataRow.rowDataType == "content" {
                        let elementLbl = UILabel.labelWithFrame(withXposition: xPosition, withYposition: yPosition, withWidth: width, withHeight: 50.0, andElementData: dataElement, withAlignment: NSTextAlignment.center, withSize: 13.3,numberOfLines:1)
                        //                        self.removeViewIfAlreadyExistsIn(self.freeTrailview, withSubView: elementLbl)
                        //                        elementLbl.sizeToFit()
                        elementLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
                        elementLbl.numberOfLines = 0
                        elementLbl.textColor = self.freetrail_titleLabel.textColor
                        self.freeTrailview.addSubview(elementLbl)
                        xPosition = xPosition + width
                        tempYPosition = yPosition + elementLbl.frame.size.height + 10.0
                    }
                    else if dataElement.elementType == .button && contentDataRow.rowDataType == "content"{
                        let elementLbl = UIButton.buttonWithFrame(withXposition: xPosition, withYposition: yPosition, withWidth: width, withHeight: 50.0, andElementData: dataElement, withSize: 13.3, isRowBtnType: false)
                        self.removeViewIfAlreadyExistsIn(self.freeTrailview, withSubView: elementLbl)
                        self.freeTrailview.addSubview(elementLbl)
                        xPosition = xPosition + width
                        tempYPosition = yPosition + elementLbl.frame.size.height + 10.0
                    }
                }
                yPosition = tempYPosition
            }
            self.freetrail_Button.cornerDesign()
            self.freetrail_Button.isHidden = true
            freetrailView.addSubview(self.freeTrailview)
            
            cell.addSubview(freetrailView)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.bannerData.count == 0 {
            return CGSize.zero
        }
        else if productType.iPad {
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width/2)
        }
        return CGSize(width: view.frame.width, height: view.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: productType.iPad ? 150.0 :  80.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (productType.iPad ? 20 : 10)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "bannerCellId", for: indexPath) as! BannerCVC
            header.banners = self.bannerData
            //header.scrollTheBanners(true)
            header.bannerDelegate = self
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
            
            footerView.backgroundColor = UIColor.clear
            return footerView
        default:
            return UICollectionReusableView()
            assert(false, "Unexpected element kind")
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.pageData.count
        {
            if self.totalPageData.count > self.pageData.count {
                if self.goGetTheData {
                    self.goGetTheData = false
                    let nextPageData = self.totalPageData[self.pageData.count]
                    if nextPageData.paneType == .section {
                        let nextSection = nextPageData.paneData as? Section
                        if (nextSection?.sectionData.hasMoreData)! && nextSection?.sectionData.data.count == 0 {
                            self.loadNextSectionContent(section: nextSection!,pageData: nextPageData)
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.updateControlBarsVisibility()
        self.view.bringSubviewToFront(AppDelegate.getDelegate().supportButton)
        AppDelegate.getDelegate().window?.bringSubviewToFront(AppDelegate.getDelegate().supportButton)
        for tempStr in AppDelegate.getDelegate().recordingCardsArr{
            let tempVal = self.recordingCardsArr.firstIndex(of: tempStr)
            if tempVal == nil {
                self.recordingCardsArr.append(tempStr)
            } else {
                self.recordingCardsArr.remove(at: tempVal!)
            }
        }
        AppDelegate.getDelegate().recordingCardsArr.removeAll()
        
        for tempStr in AppDelegate.getDelegate().recordingSeriesArr{
            let tempVal = self.recordingSeriesArr.firstIndex(of: tempStr)
            if tempVal == nil {
                self.recordingSeriesArr.append(tempStr)
            } else {
                self.recordingSeriesArr.remove(at: tempVal!)
            }
        }
        AppDelegate.getDelegate().recordingSeriesArr.removeAll()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            self.homeCV.reloadData()
        }
        if self.targetedMenu.lowercased() == "home" {
            if AppDelegate.getDelegate().isContentPageHomeReloadRequired == true{
                AppDelegate.getDelegate().isContentPageHomeReloadRequired = false
                self.Refresh(UIButton.init())
            }
        }
        if AppDelegate.isFavouriteClicked, selectedSubMenuIndexPath.count > 0,  selectedSubMenuIndexPath.row == 0 {
            AppDelegate.isFavouriteClicked = false
            self.Refresh(UIButton.init())
        }
        if self.targetedMenu.lowercased() == "live" {
            if AppDelegate.getDelegate().isContentPageLiveReloadRequired == true{
                AppDelegate.getDelegate().isContentPageLiveReloadRequired = false
                self.Refresh(UIButton.init())
            }
        }
        if playerVC == nil {
            UIApplication.shared.showSB()
            UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationBarColor
        } else {
            if playerVC?.isMinimized == true {
                UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationBarColor
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.homeCV.collectionViewLayout.invalidateLayout()
            if AppDelegate.getDelegate().isPartialViewLoaded == true{
                PartialRenderingView.instance.reloadDataWithFrameUpdate()
            }
            self.homeCV.reloadData()
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func redirectTo(_ section: Int) -> Void {
        
    }
    
    //cv delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("home VC", indexPath)
        //self.redirectTo(indexPath.item)
    }
    
    func getBanCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCellId", for: indexPath) as! BannerCVC
        return cell
    }
    
    func getSectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, section:Section) -> UICollectionViewCell {
        
        let sectionData = section.sectionData
        let sectionInfo = section.sectionInfo
        let sectionControls = section.sectionControls
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCVC.identifier, for: indexPath) as! SectionCVC
        cell.sectionIndex = indexPath.row
        cell.recordingsProgramArr = self.recordingCardsArr
        cell.recordingSeriesArr = self.recordingSeriesArr
        cell.cCV.setContentOffset(CGPoint.zero, animated: false)
        if sectionInfo.dataType == "movie" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = 210.0
            }
            cell.isMovieCell = true
        }
        else if sectionInfo.dataType == "epg" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 157.0)
            }
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "network" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                cell.collectionViewHeightConstraint.constant = 99.0
            } else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .square_poster {
                cell.collectionViewHeightConstraint.constant = 134.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 119.0)
            }
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "artist" {
            if appContants.appName == .gac {
                cell.collectionViewHeightConstraint.constant = 199.0
                cell.isMovieCell = false
            }
        }
        else if sectionInfo.dataType == "button" {
            cell.collectionViewHeightConstraint.constant = 42.0
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "entity" {
            cell.collectionViewHeightConstraint.constant = 142.0
            cell.isMovieCell = false
        }
        else {
            cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 157.0)
            cell.isMovieCell = false
        }
        cell.myLbl.text = sectionInfo.name
        if sectionInfo.iconUrl.count > 0 {
            cell.channelImageView.contentMode = .scaleAspectFit
            cell.channelImageView.loadingImageFromUrl(sectionInfo.iconUrl, category: "partner")
            cell.channelImageView.isHidden = false
            cell.channelImageViewWidthConstraint.constant = 36.0
            cell.channelImageView.viewBorderWithOne(cornersRequired: true)
            cell.channelImageView.layer.borderColor = AppTheme.instance.currentTheme.cardSubtitleColor.cgColor
            cell.myLblLeftConstraint.constant = 40.0
        }
        else{
            cell.channelImageViewWidthConstraint.constant = 0.0
            cell.myLblLeftConstraint.constant = 10.0
            cell.channelImageView.isHidden = true
        }
        if self.targetedMenu == "live" {
            if indexPath.row == 0 {
                cell.isIndexZero = true
            }
            else {
                cell.isIndexZero = false
            }
            cell.isLivePath = true
        }
        else {
            cell.isLivePath = false
        }
        cell.isViewMore = true
        cell.setUpData(sectionData: sectionData, sectionInfo: sectionInfo,sectionControls: sectionControls, pageData: self.pageContentResponse)
        cell.delegate = self
        return cell
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
    
    // api methods
    
    func getTargetedMenuData() {
        /* let pageInfo = pageContentResponse.info
         
         if pageInfo.pageType == .details {
         let moviesStoryboard = UIStoryboard(name: "Movies", bundle: nil)
         let vc = moviesStoryboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
         vc.contentDetailResponse = response
         let topVC = UIApplication.topVC()!
         topVC.navigationController?.pushViewController(vc, animated: true)
         }
         else {*/
        
        self.myRecordingsErrorView.isHidden = true
        if pageContentResponse != nil {
            self.pageData = pageContentResponse.data
            self.reOrderTotalPageData = pageContentResponse.data
            self.bannerData = pageContentResponse.banners
            self.getNumberOfItemsForSection()
            
            self.homeCV.isHidden = true
            if self.pageData.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                    self.homeCV.reloadData()
                    self.homeCV.isHidden = false
                    self.errorView.isHidden = true
                }
            }
            else{
                self.homeCV.isHidden = false
                if self.bannerData.count > 0 {
                    self.errorView.isHidden = true
                }
                else {
                    self.homeCV.isHidden = true
                    if self.targetedMenu == "my_recordings" {
                        self.showErrorViewForMyRecordings()
                    } else {
                        self.errorView.isHidden = false
                    }
                }
            }
            self.getContinueWatchingList()
            self.getRecentlyWatchedList()
        }
        for pageDataItem in self.pageData {
            if pageDataItem.paneType == .section {
                if let section = pageDataItem.paneData as? Section {
                    
                    if section.sectionInfo.dataType == "movie" {
                        //                        self.liveCardCouchScreenTopConstraint.constant = 239.0 - 100.0
                    }
                    else{
                        if productType.iPad {
                            //                            self.liveCardCouchScreenTopConstraint.constant = 222.0 - 100.0
                        }
                        //                        self.liveCardCouchScreenTopConstraint.constant = 172.0 - 50.0
                    }
                    if section.sectionData.data.first?.cardType == .roller_poster {
                        //                        self.liveCardCouchScreenView1LeadingConstraint.constant = 116.0
                    }
                        //        else if sectionCard.cardType == .band_poster || sectionCard.cardType == .sheet_poster || sectionCard.cardType == .box_poster {
                        //            return CGSize(width: 179, height: 132)
                        //        }
                        //        else if sectionCard.cardType == .pinup_poster{
                        //            return CGSize(width: 230, height: 130)
                        //        }
                    else {
                        if productType.iPad {
                            //                            self.liveCardCouchScreenView1LeadingConstraint.constant = 229.0
                        }
                        //                        self.liveCardCouchScreenView1LeadingConstraint.constant = 177.0
                    }
                    
                }
                //                self.liveCardCouchScreenTopConstraint.constant = 239.0 - 65.0
            }
        }
        //}
        
    }
    
    // common methods
    
    func removeViewIfAlreadyExistsIn(_ view:UIView, withSubView:Any) {
        for subView in view.subviews {
            if subView is UILabel {
                let label = subView as? UILabel
                let withLabel = withSubView as? UILabel
                if label?.text == withLabel?.text {
                    label?.removeFromSuperview()
                    break
                }
            }
            else if subView is UIButton {
                let button = subView as? UIButton
                let withButton = withSubView as? UIButton
                if button?.titleLabel?.text == withButton?.titleLabel?.text {
                    button?.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    func loadNextSectionContent(section:Section,pageData:PageData) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        //        self.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.sectionContent(path: self.pageContentResponse.info.path, code: section.sectionInfo.code, offset: section.sectionData.lastIndex, count: nil, filter: nil, onSuccess: { (response) in
            self.stopAnimating()
            if response.count > 0 {
                if (response.first?.data.count)! > 0 {
                    section.sectionData = response.first!
                    pageData.paneData = section
                    //                    if section.sectionData.section == "last_watched" {
                    //                        if OTTSdk.preferenceManager.user != nil {
                    //                            self.pageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                    ////                            self.getRecentlyWatchedList()
                    //                        }
                    //                    }
                    //                    else if section.sectionData.section == "continue_watching" {
                    //                        if OTTSdk.preferenceManager.user != nil {
                    //                            self.recentlyContinueWatchIndex = 0
                    //                            self.pageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                    //                            self.recentlyContinueWatchIndex = self.recentlyContinueWatchIndex + 1
                    ////                            self.getContinueWatchingList()
                    //                        }
                    //                    }
                    //                    else {
                    self.pageData.append(pageData)
                    //                    }
                    self.goGetTheData = true
                }
                //                else if section.sectionData.section == "last_watched" {
                //                    if OTTSdk.preferenceManager.user != nil {
                //                        self.pageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                //                        self.getRecentlyWatchedList()
                //                        self.goGetTheData = true
                //                    } else {
                //                        self.goGetTheData = false
                //                    }
                //                }
                //                else if section.sectionData.section == "continue_watching" {
                //                    if OTTSdk.preferenceManager.user != nil {
                //                        self.recentlyContinueWatchIndex = 0
                //                        self.pageData.insert(pageData, at: self.recentlyContinueWatchIndex)
                //                        self.recentlyContinueWatchIndex = self.recentlyContinueWatchIndex + 1
                //                        self.getContinueWatchingList()
                //                    } else {
                //                        self.goGetTheData = false
                //                    }
                //                }
                //                else {
                if self.totalPageData.indices.contains(self.pageData.count) {
                    self.totalPageData.remove(at: self.pageData.count)
                } else {
                    self.goGetTheData = false
                }
                //                }
                self.homeCV.reloadData()
            }
            else {
                if self.totalPageData.indices.contains(self.pageData.count) {
                    self.totalPageData.remove(at: self.pageData.count)
                }
            }
            self.reorderTheData()
        }) { (error) in
            self.stopAnimating()
            print(error.message)
        }
    }
    
    
    func reorderTheData() {
        var tempPageData = [PageData]()
        for pageData in self.reOrderTotalPageData {
            if pageData.paneType == .section {
                let section = pageData.paneData as? Section
                for nPageData in self.pageData {
                    let nSection = nPageData.paneData as? Section
                    if section?.sectionInfo.code == nSection?.sectionInfo.code {
                        tempPageData.append(pageData)
                        break;
                    }
                }
            }
        }
        self.pageData = tempPageData
        self.homeCV.reloadData()
    }
    
    // MARK: - Chrome Cast Device Scanner Delegates -
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            self._miniMediaControlsHeightConstraint.constant = miniMediaControlsViewController.minHeight
            self.view.bringSubviewToFront(_miniMediaControlsContainerView)
            let appDelegate = AppDelegate.getDelegate()
            appDelegate.shouldRotate = false
            if productType.iPhone {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            if playerVC != nil {
                playerVC?.showHidePlayerView(true)
            }
        }
        else {
            self._miniMediaControlsHeightConstraint.constant = 0
            if playerVC != nil {
                playerVC?.showHidePlayerView(false)
            }
        }
        self.view.setNeedsLayout()
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
    
    //MARK: - PlayerSuggestionsViewControllerDelegate
    func didSelectedSuggestion(card: Card) {
        didSelectedRollerPosterItem(item: card)
    }
    
    //MARK: - Language Selection Delegate
    func refreshTheContent() {
        if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                
            })
        }
        else {
            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
            })
        }
    }
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    // MARK: - DefaultViewControllerDelegate
    func retryTap(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GobackFromErrorPage"), object: nil)
    }
    
    //MARK: - PartialRenderingViewDelegate
    
    func didSelected(card : Card?, content : Any?, templateElement : TemplateElement? ){
        if card != nil && templateElement != nil{
            print(templateElement!.data)
            self.goToPage(card!, templateElement: templateElement!)
        }
    }
    
    func record(confirm : Bool, content : Any?){
        if confirm == true{
            
        }
    }
    
    // MARK: - GADAdLoaderDelegate
    
    func addNativeAds() {
        
        if nativeAds.count <= 0 {
            return
        }
        var index = adInterval
        var rowVal = 0
        for _ in nativeAds {
            if index < self.pageData.count {
                let adPageData = PageData()
                adPageData.paneType = .adContent
                adPageData.adPositionIndex = rowVal
                self.pageData.insert(adPageData, at: index)
                index += 1
                rowVal = rowVal + 1
                index += adInterval
            } else {
                break
            }
        }
        
        if pageData.count > 0 {
            self.errorView.isHidden = true
        }
        else {
            if self.bannerData.count > 0 {
                self.errorView.isHidden = true
            }
            else {
                self.errorView.isHidden = false
            }
        }
        self.homeCV.reloadData()
    }
    
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        
        // Add the native ad to the list of native ads.
        nativeAds.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        addNativeAds()
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

public class CollectionViewFooterClass: UICollectionReusableView {
    static var identifier = "CollectionViewFooterClassReuseIdentifier"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}



extension ContentViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pinErrorMsgLabel.text = ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return false
        }
        return range.location < AppDelegate.getDelegate().parentalControlPinLength
    }
}
extension ContentViewController
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.socialMediaOptionsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "socialMediaCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        let platformImageView:UIImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        let platformBtn:UIButton = cell?.contentView.viewWithTag(2) as! UIButton
        platformBtn.setTitle("", for: .normal)
        platformBtn.titleLabel?.font = UIFont.ottMediumFont(withSize: 15)
        platformBtn.cornerDesignWithoutBorder()
        platformBtn.isUserInteractionEnabled = false
        
        let item = self.socialMediaOptionsListArray[indexPath.row]
        if let _imagePath = item["imagePath"] as? String {
            platformImageView.sd_setImage(with: URL(string: _imagePath))
        }
        
        if let _title = item["title"] as? String {
            platformBtn.setTitle(_title, for: .normal)
        }
        
        if let _titleColor = item["titleColor"] as? String {
            platformBtn.setTitleColor(UIColor.init(hexString: _titleColor), for: .normal)
        }
        
        if let _backgroundColor = item["backgroundColor"] as? String {
            platformBtn.backgroundColor = UIColor.init(hexString: _backgroundColor)
        }

        
        cell?.accessoryType = .none
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.backgroundColor = .clear

        return cell!
    }
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.socialMediaOptionsListArray.count - 1 {
            return 119
        }
        else {
            return 149
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.socialMediaOptionsListArray[indexPath.row]
        if let _targetPath = item["targetPath"] as? String {
            var isInternal = false
            if let _isInternal = item["isInternal"] as? Bool {
                isInternal = _isInternal
            }
            if isInternal == true {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
                let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
                view1.urlString = _targetPath
                view1.pageString = ""
                view1.viewControllerName = "ContentViewController"
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(view1, animated: true)
            }
            else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: _targetPath)!, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(URL(string: _targetPath)!)
                }
            }
        }
        //hideSocialMediaPopup()
    }
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    @IBAction private func closeSocialMediaPopup(_ sender : Any) {
        hideSocialMediaPopup()
    }
    func hideSocialMediaPopup() {
        self.socialMediaPopupBgView.isHidden = true
        self.socialMediaPopupCloseButton.isHidden = true
        self.socialMediaTitleLabel.isHidden = true
        self.socialMediaSubTitleLabel.isHidden = true
        self.socialMediaBackGroundImageView.isHidden = true
        self.socialMediaTableView.isHidden = true
        self.socialMediaPopupBgView.removeFromSuperview()
    }
}
