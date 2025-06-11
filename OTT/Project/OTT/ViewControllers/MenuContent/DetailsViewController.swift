//
//  MovieDetailsViewController.swift
//  sampleColView
//
//  Created by Ankoos on 09/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast
import GoogleMobileAds

class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,AccontDelegate, PaymentSuccessVCDelegate, DetailsTableViewCellProtocal, CastTableViewCellProtocal, PlayerViewControllerDelegate,DefaultViewControllerDelegate,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol,ExpandableLabelDelegate,PartialRenderingViewDelegate,GADBannerViewDelegate,StartWatchPartyViewProtocol,StartWatchPartyConfirmationViewProtocol {
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    @IBOutlet weak var bgImgAspectRation: NSLayoutConstraint!
    @IBOutlet weak var newbackButton: UIButton!
    @IBOutlet weak var backBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var navViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTopConfstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var moviebackcolorView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    var termsAndConditionsArray = [TermsAndConditions]()
    struct TermsAndConditions {
        let scrBounds = UIScreen.main.bounds.size
        var totalAttributedString : NSMutableAttributedString{
            set{
                localAnswer = newValue
                
                let constraintRect = CGSize(width: scrBounds.width, height: CGFloat.greatestFiniteMagnitude)
                
                let boundingBox = localAnswer.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
                answerHeight = boundingBox.height + 20
            }
            get{
                return localAnswer
            }
        }
        
        var answerHeight : CGFloat = 0
        var localAnswer : NSMutableAttributedString = NSMutableAttributedString()
    }
    
    var buttonsArray = [HeaderMenuButton]()
    var buttonsElementArray = [Element]()
    struct HeaderMenuButton {
        let scrBounds = CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        var titleString : String {
            set{
                localAnswer = newValue
                
                let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 47)
                let boundingBox = localAnswer.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
                answerHeight = boundingBox.width + 10
            }
            get{
                return localAnswer
            }
        }
        
        var answerHeight : CGFloat = 0
        var localAnswer = ""
    }
    
    var contentDetailResponse:PageContentResponse?
    var sectionDetailsObjArr = [Any]()
    
    @IBOutlet weak var navBagImgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarImgView: UIImageView!
    @IBOutlet weak var castbtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBtnWidthConstraint: NSLayoutConstraint!
    /*var movieObj : Movie!
     var movieDetailsObj :MovieDetails!
     var termsArray : [Term]!
     */
    @IBOutlet weak var chromeButtonView: UIView!
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var chromecastButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20
    var reload = 0
    var pageLoaded = false
    @IBOutlet weak var navigationTitleLbl: UILabel!
    var shouldProcessPayment = false
    var castCrewArray = [CastCrewModel]()
    @IBOutlet weak var movieBGImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    var scrollViewAlpha = 0.0
    var contentCellHeight:CGFloat = 430.0
    var playButtonElement:Element!
    var startOverButtonElement:Element!
    var trailerButtonElement:Element!
    var descLableHeight:CGFloat = 0
    var isReadBtnAdded:Bool = false
    var isReadMoreClicked:Bool = false
    var readMoreBtn:UIButton!
    var tvShowSummaryHeight:CGFloat = 0
    var tvShowCellHeight:CGFloat = 0
    var descContentLbl:UITextView!
    var descHeightConstraint:NSLayoutConstraint!
    var isButtonVisisble:Bool = false
    var isSubscriptionBtn:Bool = false
    var isDescriptionNA:Bool = true
    var contentType:String = ""
    var navigationTitlteTxt:String = ""
    var myTimer: Timer? = nil
    var detailCell:UITableViewCell!
    var noOfTimesIndicator = 1
    var showTime = 1
    var channelID = ""
    var targetPath = ""
    var movieDescriptionText = ""
    var isCircularPoster:Bool = false
    var states : Array<Bool>!
    var isFavourite:Bool = false
    var showWatchPartyMenuInPlayer:Bool = false
    var isFromErrorFlow:Bool = false
    fileprivate var isTrailerButtonTapped = false
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerAdView: UIView!
    
    @IBOutlet weak var channelInfoView : UIView?
    @IBOutlet weak var channelImageView : UIImageView?
    @IBOutlet weak var channelTitleLabel : UILabel?
    @IBOutlet weak var channelSubTitleLabel : UILabel?
    @IBOutlet weak var buttonsCollectionView : UICollectionView?
    @IBOutlet weak var seperatorlabel : UILabel?
    @IBOutlet weak var channelInfoViewHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var cCFL: CustomFlowLayout! = CustomFlowLayout()
    let secInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    var cellSizes: CGSize = CGSize(width: 80, height: 35)
    let numColums: CGFloat = 2
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 10
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    var movieImage: UIImageView!
   

    //MARK: - View Life cycle methods
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        states = [Bool](repeating: true, count: 1)
        if productType.iPad {
            if currentOrientation().landscape {
                self.contentCellHeight = 550
            }
            else {
                self.contentCellHeight = 630
            }
        }
        else {
            self.contentCellHeight = 430
        }
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        shouldProcessPayment = false
        
        
        
        
        if appContants.appName != .gac {
            scrollview?.delegate = self
            self.channelInfoView?.backgroundColor = .clear
            self.channelTitleLabel?.backgroundColor = .clear
            self.channelTitleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
            self.channelTitleLabel?.font = UIFont.ottRegularFont(withSize: 14)
            
            self.channelSubTitleLabel?.backgroundColor = .clear
            self.channelSubTitleLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
            self.channelSubTitleLabel?.font = UIFont.ottRegularFont(withSize: 11)
            self.channelInfoViewHeightConstraint?.constant = 0
            self.seperatorlabel?.alpha = 0.1
            self.seperatorlabel?.backgroundColor = AppTheme.instance.currentTheme.cardSubtitleColor
            self.buttonsCollectionView?.delegate = self
            self.buttonsCollectionView?.dataSource = self
            self.buttonsCollectionView?.collectionViewLayout = cCFL
            self.buttonsCollectionView?.setContentOffset(CGPoint.zero, animated: true)
            self.buttonsCollectionView?.register(UINib(nibName: "detailsPageHeaderButtonsCell", bundle: nil), forCellWithReuseIdentifier: "detailsPageHeaderButtonsCell")
            
                        
        } else {
            
        }

        
        
        
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        
        movieImage = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshFavoriteContent), name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)
        self.setGradientBackground()
        self.detailsTableView.register(UINib.init(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        self.detailsTableView.register(UINib.init(nibName: "MovieDetailsCell", bundle: nil), forCellReuseIdentifier: "MovieDetailsCell")
        
        self.detailsTableView.register(UINib.init(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        
        self.detailsTableView.register(UINib.init(nibName: DetailsTableViewCell.nibname, bundle: nil), forCellReuseIdentifier: DetailsTableViewCell.identifier)
        AppDelegate.getDelegate().taggedScreen = "Show Details"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        
        if self.contentDetailResponse?.info.path != nil{
            self.targetPath = self.contentDetailResponse?.info.path ?? ""
        }
        self.isFavourite = self.contentDetailResponse?.pageButtons.isFavourite ?? false
        self.contentType = (self.contentDetailResponse?.info.attributes.contentType)!
        if appContants.appName != .gac {
        if self.contentDetailResponse?.pageButtons.record != nil {
            self.recordBtn.isHidden = false
            if ((self.contentDetailResponse?.pageButtons.record!.isRecorded)!) {
                self.recordBtn.tag = 2
                self.recordBtn.setTitle("Stop REC", for: .normal)
                self.recordButtonWidthConstraint.constant = 100
                self.recordBtn.backgroundColor = UIColor.init(hexString: "6f6f6f")
            } else {
                self.recordBtn.setTitle("REC", for: .normal)
                self.recordButtonWidthConstraint.constant = 70
                self.recordBtn.backgroundColor = UIColor.init(hexString: "e00d0d")
                self.recordBtn.tag = 1
            }
            self.channelID = (self.contentDetailResponse?.pageButtons.record!.channelId)!
        }
        }
        else{
            if appContants.appName != .gac { self.recordButtonWidthConstraint.constant = 0 }
        }
        //        if self.contentType == "movie" || self.contentType == "channel"{
        
//        if appContants.appName == .aastha {
//            navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
//            searchButton.isHidden = true
//        }
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(hexString: "232326")
        //        }
        if appContants.appName == .gac {
//            self.navigationTitleLbl.text = ""
        } else {
        self.navigationTitleLbl?.text = self.navigationTitlteTxt
        }
        let customButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: CGFloat(40), height: CGFloat(40)))
        customButton.tintColor = AppTheme.instance.currentTheme.chromecastIconColor
        if appContants.appName != .gac { self.chromeButtonView?.addSubview(customButton) }
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        
        
        let castContext = GCKCastContext.sharedInstance()
        
        /*if castContext.castState == .noDevicesAvailable {
            self.chromeButtonView.isHidden = true
            self.castbtnWidthConstraint.constant = 0.0
            self.chromecastButtonTrailingConstraint.constant = 0.0
        }
        else{*/
        if appContants.appName != .gac {
            if appContants.isChromeCastEnabled &&  AppDelegate.getDelegate().supportChromecast {
                self.chromeButtonView?.isHidden = false
                self.castbtnWidthConstraint.constant = 40.0
                self.chromecastButtonTrailingConstraint.constant = 10.0
            }
            else {
                self.chromeButtonView?.isHidden = true
                self.castbtnWidthConstraint?.constant = 0.0
                self.chromecastButtonTrailingConstraint?.constant = 0.0
            }
//        }
    }
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
        
        /* if self.contentType == "tvshowdetails"{
         self.backBtnWidthConstraint.constant = 52
         self.searchBtnWidthConstraint.constant = 40.0
         } else if self.contentType == "network" {
         self.backBtnWidthConstraint.constant = 52.0
         self.searchBtnWidthConstraint.constant = 0.0
         } */
        if appContants.appName == .gac {
            //navigationView.backgroundColor = .clear
            if let yourBackImage = UIImage(named: "group_3988") {
            self.newbackButton.setImage(yourBackImage, for: .normal)
                
                self.newbackButton.imageView?.contentMode = .scaleAspectFit
            self.newbackButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 3, right: 8)
            } else {
//            self.bgImgAspectRation.constant = 1
//            self.movieBGImageView.frame
//                navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
            }
            
        } else {
        
        }
        self.reloadData()
        self.detailsTableView.isScrollEnabled = false
        self.scrollview?.contentSize = CGSize(width: self.view.bounds.width, height: CGFloat(800))
        self.loadBannerAd()
        self.updateDocPlayerFrame()
        
        //        self.detailsTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        //        self.detailsTableView.rowHeight = UITableViewAutomaticDimension
        self.detailsTableView.estimatedRowHeight = 44
        self.detailsTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.tableViewHeight.constant = 1200
    }
    
    @objc func castDeviceDidChange(_ notification: Notification) {
        /*if GCKCastContext.sharedInstance().castState == .noDevicesAvailable {
            self.chromeButtonView.isHidden = true
            self.castbtnWidthConstraint.constant = 0.0
            self.chromecastButtonTrailingConstraint.constant = 0.0
        }
        else{*/
        if appContants.appName != .gac {
            if appContants.isChromeCastEnabled &&  AppDelegate.getDelegate().supportChromecast {
                self.chromeButtonView?.isHidden = false
                self.castbtnWidthConstraint.constant = 40.0
                self.chromecastButtonTrailingConstraint.constant = 10.0
            }
            else {
                self.chromeButtonView?.isHidden = true
                self.castbtnWidthConstraint.constant = 0.0
                self.chromecastButtonTrailingConstraint.constant = 0.0
            }
        }
//        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if appContants.appName != .gac {
        if TabsViewController.shouldHideSearchButton == true {
            self.searchButton?.isHidden = true
            self.searchBtnWidthConstraint?.constant = 0
        }
        else{
            self.searchButton.isHidden = false
            self.searchBtnWidthConstraint.constant = 52
        }
        if appContants.appName != .aastha {
            self.searchButton.isHidden = TabsViewController.shouldHideSearchButton
        }
    }
        AppDelegate.getDelegate().isDetailsPage = true
        self.showWatchPartyMenuInPlayer = false
        if playerVC == nil {
            UIApplication.shared.showSB()
        }
        if isFromErrorFlow {
            self.isFromErrorFlow = false
            self.sectionDetailsObjArr.removeAll()
            self.refreshData()
        }
        else {
            self.detailsTableView.reloadData()
        }
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        DispatchQueue.main.async {
            self.detailsTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().isDetailsPage = true
        var contentName = ""
        for obj in self.sectionDetailsObjArr {
            if let content = obj as? Content {
                contentName = content.title
            }
        }
        
        if self.contentType == "channel" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Catchup":contentName])
        } else if self.contentType == "movie" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Movies":contentName])
        } else if self.contentType == "tvshowdetails" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "TV_Show":contentName])
        }
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            ccHeight = miniMediaControlsViewController.minHeight
        }
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
        self.pageLoaded = true
    }
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is DetailsViewController {
            self.updateDocPlayerFrame()
            var ccHeight:CGFloat = 0.0
            if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
                ccHeight = miniMediaControlsViewController.minHeight
            }
            AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
            if productType.iPad {
                self.detailsTableView.reloadData()
            }
            if playerVC == nil {
                self.showWatchPartyMenuInPlayer = false
            }
        }
    }
    func refreshData() {
        self.startAnimating(allowInteraction: true)
        
        OTTSdk.mediaCatalogManager.pageContent(path: self.targetPath, onSuccess: { (response) in
            self.stopAnimating()
            self.contentDetailResponse = response
            if self.contentDetailResponse?.info.path != nil{
                self.targetPath = self.contentDetailResponse?.info.path ?? ""
            }
            self.isFavourite = self.contentDetailResponse?.pageButtons.isFavourite ?? false
            self.contentType = (self.contentDetailResponse?.info.attributes.contentType)!
            self.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.detailsTableView.reloadData()
            }
        }) { (error) in
            self.stopAnimating()
        }
    }
    
    func reloadData() {
        /*if self.contentType == "network" || self.contentType == "tvshowdetails" {
         self.navBarImgView.isHidden = false
         self.navigationTitleLbl.isHidden = true
         if self.isCircularPoster {
         self.navBarImgView.contentMode = .scaleToFill
         self.navBagImgViewWidthConstraint.constant = 47.0
         self.navBarImgView.layer.cornerRadius = self.navBagImgViewWidthConstraint.constant / 2.0
         self.navBarImgView.clipsToBounds = true
         } else {
         self.navBarImgView.contentMode = .scaleAspectFit
         self.navBagImgViewWidthConstraint.constant = 83.0
         }
         self.navBagImgViewWidthConstraint.constant = 0.0
         self.navBarImgView.isHidden = true
         self.navigationTitleLbl.isHidden = false
         } else {
         self.navBarImgView.isHidden = true
         self.navigationTitleLbl.isHidden = false
         }*/
        if self.contentType != "channel" /*&& self.contentType != "network" && self.contentType != "tvshowdetails"*/ {
            for pageData in (self.contentDetailResponse?.data)! {
                if let section = pageData.paneData as? Section {
                    if (self.contentDetailResponse?.tabsInfo.tabs.count)! > 0 {
                        if section.sectionInfo.dataType == "actor" {
                            if section.sectionData.data.count > 0 {
                                self.sectionDetailsObjArr.append(pageData.paneData!)
                            }
                        }
                    }
                    else {
                        if section.sectionData.data.count > 0 {
                            self.sectionDetailsObjArr.append(pageData.paneData!)
                        }
                    }
                }
                else {
                    if let content = pageData.paneData as? Content {
                        for pageData in content.dataRows {
                            for element in pageData.elements {
                                if element.elementType == .description && pageData.rowDataType == "content" {
                                    self.isDescriptionNA = false
                                    let paragraphStyle = NSMutableParagraphStyle()
                                    paragraphStyle.lineSpacing = 1.5
                                    /* let summaryAttributes = [NSAttributedString.Key.font:
                                     UIFont.ottBoldFont(withSize: 17.0),
                                     NSAttributedString.Key.foregroundColor: AppTheme.instance.currentTheme.cardSubtitleColor ,NSAttributedString.Key.paragraphStyle : paragraphStyle] */
                                    
                                    let descriptionAttributes = [NSAttributedString.Key.font:
                                        UIFont.ottRegularFont(withSize: 12.0),
                                                                 NSAttributedString.Key.foregroundColor: AppTheme.instance.currentTheme.cardSubtitleColor,NSAttributedString.Key.paragraphStyle : paragraphStyle]
                                    
                                    
                                    
                                    /*let summarAttributedString = NSMutableAttributedString(
                                     string: "Summary".localized,
                                     attributes: summaryAttributes as [NSAttributedString.Key : Any])*/
                                    
                                    let descriptionAttributedString = NSMutableAttributedString(
                                        string: element.data,
                                        attributes: descriptionAttributes as [NSAttributedString.Key : Any])
                                    
                                    let attrString = NSMutableAttributedString()
                                    //attrString.append(summarAttributedString)
                                    //attrString.append(NSAttributedString.init(string: "\n"))
                                    //attrString.append(NSAttributedString.init(string: "\n"))
                                    attrString.append(descriptionAttributedString)
                                    
                                    self.movieDescriptionText = attrString.string
                                    if element.data .isEmpty {
                                        self.contentCellHeight = 280.0
                                    }
                                }
                            }
                        }
                        if content.contentDescription .isEmpty && self.contentCellHeight == 400.0 {
                            self.contentCellHeight = 280.0
                        }
                    }
                    var isButtonsAvailable:Bool = false
                    if let content = pageData.paneData as? Content {
                        for pageData in content.dataRows {
                            for element in pageData.elements {
                                if element.elementType == .button && pageData.rowDataType == "button" {
                                    self.isButtonVisisble = true
                                    if element.elementSubtype.lowercased() == "subscribe" {
                                        self.isSubscriptionBtn = true
                                    }
                                    if !isDescriptionNA {
                                        //                                        self.contentCellHeight = self.contentCellHeight + 80.0
                                        isButtonsAvailable = true
                                    }
                                }
                            }
                        }
                        
                        if appContants.appName == .gac{
                            if !isButtonsAvailable && pageLoaded == false {
                                self.contentCellHeight = self.contentCellHeight - 50.0
                            }
                        } else {
                            if !isButtonsAvailable {
                                self.contentCellHeight = self.contentCellHeight - 50.0
                            }
                        }
                    }
                    if let content = pageData.paneData as? Content {
                        if content.dataRows.count > 0 {
                            self.sectionDetailsObjArr.insert(pageData.paneData!, at: 0)
                        }
                    }
                }
            }
        }
        else {
            self.movieBGImageView.isHidden = true
        }
        if /*self.contentType == "network" || self.contentType == "tvshowdetails" || */ (self.contentType == "channel" && (self.contentDetailResponse?.tabsInfo.tabs.count)! == 0) {
            for pageData in (self.contentDetailResponse?.data)! {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    //                    if section.sectionInfo.dataType == "button" {
                    self.sectionDetailsObjArr.append(section)
                    //                    }
                } else {
                    let content = pageData.paneData as! Content
                    if appContants.appName != .gac {
                    self.channelInfoViewHeightConstraint?.constant = 117
                    }
                    for dataRow in content.dataRows {
                        let elements = dataRow.elements
                        if appContants.appName != .gac {
                        for elementData in elements {
                            if elementData.elementType == .image {
                                self.navBarImgView.loadingImageFromUrl(elementData.data, category: "potrait")
                                self.channelImageView?.loadingImageFromUrl(elementData.data, category: "potrait")
                                self.channelImageView?.backgroundColor = AppTheme.instance.currentTheme.tvGuideContentCellBorderColor
                                self.channelImageView?.layer.borderWidth = 1.0
                                self.channelImageView?.layer.borderColor = AppTheme.instance.currentTheme.detailspageChannelBorderColor.cgColor
                            }
                            else if elementData.elementType == .text && elementData.elementSubtype == "title" {
                                self.navigationTitleLbl.isHidden = false
                                self.navigationTitleLbl.text = elementData.data
                                self.channelTitleLabel?.text = elementData.data
                            }
                            else if elementData.elementType == .text && elementData.elementSubtype == "subtitle" {
                                self.channelSubTitleLabel?.text = elementData.data
                            }
                        }
                        }
                    }
                }
            }
        }
        else if (self.contentDetailResponse?.tabsInfo.tabs.count)! > 0 {
            if (self.contentType == "channel") {
                
                for pageData in (self.contentDetailResponse?.data)! {
                    if pageData.paneType == .content {
                        let content = pageData.paneData as! Content
                        
                        if appContants.appName != .gac {
                            self.channelTitleLabel?.text = content.title
                        self.channelInfoViewHeightConstraint?.constant = 117
                        }
                        for dataRow in content.dataRows {
                            let elements = dataRow.elements
                            if appContants.appName != .gac {
                                self.navigationTitleLbl.text = ""
                                
                            
                            for elementData in elements {
                                if elementData.elementType == .image {
                                    self.channelImageView?.loadingImageFromUrl(elementData.data, category: "potrait")
                                    self.channelImageView?.layer.borderWidth = 1.0
                                    self.channelImageView?.layer.borderColor = AppTheme.instance.currentTheme.cardSubtitleColor.cgColor

                                }
                                else if elementData.elementType == .text && elementData.elementSubtype == "title" {
                                    self.channelTitleLabel?.text = elementData.data
                                }
                                else if elementData.elementType == .text && elementData.elementSubtype == "subtitle" {
                                    self.channelSubTitleLabel?.text = elementData.data
                                }
                                else if elementData.elementType == .button {
                                    var headerMenu = HeaderMenuButton()
                                    headerMenu.titleString = elementData.data
                                    self.buttonsArray.append(headerMenu)
                                    self.buttonsElementArray.append(elementData)
                                }
                            }
                            }
                        }
                    }
                }
            }
            if appContants.appName != .gac {
            if self.buttonsArray.count > 0 {
                self.buttonsCollectionView?.reloadData()
                self.buttonsCollectionView?.isHidden = false
            }
            else {
                
                
                self.buttonsCollectionView?.isHidden = true
            }
            if self.buttonsArray.count == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    self.buttonsCollectionView?.center = CGPoint(x: ((UIScreen.main.bounds.size.width) / 2) - 25, y: self.buttonsCollectionView?.center.y ?? 0)
                }
            }
        }
            self.sectionDetailsObjArr.append(self.contentDetailResponse?.tabsInfo as Any)
        }
                self.detailsTableView.reloadData()
    }
    
    func checkIsPartnerWithTabs() -> Bool {
        var status:Bool = false
        for pageData in (self.contentDetailResponse?.data)! {
            if pageData.paneType == .section {
                let section = pageData.paneData as! Section
                if section.sectionInfo.dataType == "button" {
                    status = true
                    break;
                }
            }
        }
        return status
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom Methods
    
    func getMovieDetails() {/*
         self.startAnimating(allowInteraction: false)
         YuppTVSDK.mediaCatalogManager.premiumMovieDetails(code: self.movieObj!.code, onSuccess: { (response) in
         print(response)
         self.stopAnimating()
         self.movieDetailResponse = response
         self.movieDetailsObj = self.movieDetailResponse?.movieDetails
         self.termsArray = response.terms
         
         for term in response.terms{
         var termObj = TermsAndConditions()
         termObj.totalAttributedString = self.getTermsText(termObj: term)
         
         self.termsAndConditionsArray.append(termObj)
         }
         
         
         self.detailsTableView.reloadData()
         }) { (error) in
         print(error.message)
         self.stopAnimating()
         self.showAlertWithText(message: error.message)
         
         }*/
    }
    
    
    func sendStreamKey()  {/*
         if let movieId = self.movieDetailResponse?.movieDetails.movieId{
         self.startAnimating(allowInteraction: false)
         YuppTVSDK.statusManager.sendVerificationLink(movieId: String(movieId), onSuccess: { (streamKeyResponse) in
         self.stopAnimating()
         if streamKeyResponse.status == .verified{
         // Geo Verified
         self.playMovie(streamKeyResponse: streamKeyResponse)
         }
         else if streamKeyResponse.status == .notVerified{
         // Geo not Verified : Show send link verification screen : A verification URL is sent to your mobile
         self.showLinkVerificationView(streamKeyResponse: streamKeyResponse)
         }
         
         }, onFailure: { (error) in
         self.stopAnimating()
         })
         }
         
         
         FDFSServices.instance.sendOrGetStreamKey(self.movie.movieId,verify : "false") { (isSuccess, message, response) in
         self.loadingActivityView.hidden = true
         if isSuccess{
         
         if let terms = (response!["response"] as? [String : AnyObject])!["terms"] as? [String : AnyObject]{
         self.movie.piracyPolicyTerm.header = Utilities.getStringValue(terms["header"])
         self.movie.piracyPolicyTerm.confirmText = Utilities.getStringValue(terms["confirmText"])
         self.movie.piracyPolicyTerm.buttonText = Utilities.getStringValue(terms["buttonText"])
         self.movie.piracyPolicyTerm.description = terms["description"] as! [String]
         }
         
         if status == 1{
         if let showTerms = (response!["response"] as? [String : AnyObject])!["showTerms"] as? Bool{
         self.movie.showTerms = showTerms
         }
         if let data = (response!["response"] as? [String : AnyObject])!["data"] as? String{
         // Already Link is verified
         self.movie.streams.streamsKey = data
         self.movieStreamRequest()
         return
         }
         }
         else if status == 2{
         // Link not verified
         if (FDFSServices.user.mobile.count > 0){
         let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FDFSSendVerificationLinkViewController") as! FDFSSendVerificationLinkViewController
         controller.movie = self.movie
         controller.delegate = self
         self.presentViewController(controller, animated: true, completion:nil)
         }
         }
         }
         
         }*/
    }
    @IBAction func newback(_ sender: Any) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        if self.contentType == "movie"{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func BackAction(_ sender: Any) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        if self.contentType == "movie"{
            //            let navArray = self.navigationController!.viewControllers as Array
            //            if navArray.count > 2{
            //                if navArray[1].isKind(of: DetailsViewController.self) {
            //                    self.navigationController?.popToRootViewController(animated: true)
            //                }
            //                else{
            //                    self.navigationController!.popToViewController(navArray[1] as UIViewController, animated: true)
            //                }
            //            }
            //            else{
            self.navigationController?.popViewController(animated: true)
            //            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    /*
     func showZipCodeView() {
     if let movieId = self.movieDetailResponse?.movieDetails.movieId{
     let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     let zipCodeVC = accStoryBoard.instantiateViewController(withIdentifier: "ZipcodeViewController") as! ZipcodeViewController
     zipCodeVC.delegate = self
     zipCodeVC.movieId = String(movieId)
     self.navigationController?.isNavigationBarHidden = true
     self.navigationController?.pushViewController(zipCodeVC, animated: true)
     }
     }
     func showOTPView() {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
     nextViewController.mobileNumber = YuppTVSDK.preferenceManager.user?.mobile
     nextViewController.otpSent = false
     nextViewController.viewControllerName = "MovieDetailsViewController"
     nextViewController.targetVC = self
     nextViewController.accountDelegate = self
     self.navigationController?.isNavigationBarHidden = true
     self.navigationController?.pushViewController(nextViewController, animated: true)
     }
     
     func showLinkVerificationView(streamKeyResponse : StreamKeyResponse) {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Movies", bundle:nil)
     let geoVerificationVC = storyBoard.instantiateViewController(withIdentifier: "GeoVerificationViewController") as? GeoVerificationViewController
     geoVerificationVC?.delegate = self
     geoVerificationVC?.movieId = String(self.movieDetailResponse!.movieDetails.movieId)
     geoVerificationVC?.streamKeyResponse = streamKeyResponse
     self.presentpopupViewController(geoVerificationVC!, animationType: .bottomTop) {
     
     }
     }
     func showTermsAndPiracyPolicyView() {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Movies", bundle:nil)
     let termsAndPiracyPolicyVC = storyBoard.instantiateViewController(withIdentifier: "TermsAndPiracyPolicyViewController") as? TermsAndPiracyPolicyViewController
     termsAndPiracyPolicyVC?.delegate = self
     termsAndPiracyPolicyVC?.movieId = String(self.movieDetailResponse!.movieDetails.movieId)
     self.navigationController?.present(termsAndPiracyPolicyVC!, animated: true, completion: {
     
     })
     //        self.presentpopupViewController(termsAndPiracyPolicyVC!, animationType: .bottomTop) {
     //
     //        }
     }
     
     func showInAppSuccess() {
     let storyBoard : UIStoryboard = UIStoryboard(name: "Movies", bundle:nil)
     let paymentSuccessVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as? PaymentSuccessViewController
     paymentSuccessVC?.delegate = self
     self.presentpopupViewController(paymentSuccessVC!, animationType: .bottomTop) {
     
     }
     }
     
     func playMovie(streamKeyResponse : StreamKeyResponse) {
     YuppTVSDK.mediaCatalogManager.stream(streamKey: streamKeyResponse.data, onSuccess: { (movieStreamResponse) in
     if movieStreamResponse.streams.count > 0{
     //TODO: Play or block in mobile as requirement
     print(movieStreamResponse.streams[0].url)
     }
     else{
     print(movieStreamResponse.streams)
     }
     
     }) { (error) in
     let alert = UIAlertController(title: String.getAppName(), message: error.message, preferredStyle: UIAlertController.Style.alert)
     let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
     })
     alert.addAction(messageAlertAction)
     self.present(alert, animated: true, completion: nil)
     }
     }*/
    
    //    func payForMovie(){
    //        if let movieId = self.movieDetailResponse?.movieDetails.movieId{
    //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InAppPurchaceVC") as! InAppPurchaceVC
    //            nextViewController.delegate = self
    //            nextViewController.movieId = String(movieId)
    //            self.navigationController?.isNavigationBarHidden = true
    //            self.navigationController?.pushViewController(nextViewController, animated: true)
    //        }
    //        else{
    //            //TODO: show alert.. not happens
    //        }
    //    }
    @objc func trailerButtonTap() {
        if isTrailerButtonTapped { return }
        isTrailerButtonTapped = true
        self.navigateToPlayer(isFromStartOver: false, isTrailer: true)
    }
    @objc func startOverButtonTap() {
        self.navigateToPlayer(isFromStartOver: true)
    }
    
    @objc func watchPartyButtonTap(sender: AnyObject)
    {
        //        let vc = StartWatchPartyConfirmationView()
        //        vc.contentData = self.contentDetailResponse
        //        vc.delegate = self
        //        self.presentpopupViewController(vc, animationType: .bottomTop, completion: { () -> Void in
        //        })
        self.shareContent(sender: sender)
    }
    
    func shareContent(sender: AnyObject) {
        // Enable for sharing feature
        
        //Set the default sharing message.
        let title = self.contentDetailResponse?.shareInfo.name
        //Set the link to share.
        var linkString = ""
        if let path = self.contentDetailResponse?.info.path {
            if AppDelegate.getDelegate().configs?.siteURL.last == "/" {
                linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")\(path)"
            } else {
                linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")/\(path)"
            }
        }
        if let link = NSURL(string: linkString)
        {
            let objectsToShare = [title ?? "",link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            if  productType.iPad   {
                activityVC.excludedActivityTypes = []
                activityVC.popoverPresentationController?.sourceView = self.view
                let tempShareBtn:UIButton = sender as! UIButton
                activityVC.popoverPresentationController?.sourceRect = tempShareBtn.frame
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func showWatchPartyView() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            let vc = StartWatchParty()
            vc.contentData = self.contentDetailResponse
            vc.delegate = self
            self.parent?.presentpopupViewController(vc, animationType: .bottomTop, completion: { () -> Void in
            })
        }
    }
    
    @objc func RefreshFavoriteContent() {
//        self.isFavourite = !self.isFavourite
//        self.detailsTableView.reloadData()
        
        self.sectionDetailsObjArr.removeAll()
        self.refreshData()
    }
    
    @objc func watchlistButtonTap() {
        
        if OTTSdk.preferenceManager.user != nil {
            AppDelegate.isFavouriteClicked = true
            if self.isFavourite {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Removed"])
                OTTSdk.userManager.deleteUserFavouriteItem(pagePath: (self.contentDetailResponse?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = false
                    AppDelegate.getDelegate().isListPageReloadRequired = true
                    self.detailsTableView.reloadData()
                    if playerVC != nil {
                        playerVC?.isFavourite = self.isFavourite
                        playerVC?.setFavUI()
                    }
                    self.showAlert(message: "Removed from Watchlist")
                }, onFailure: { (error) in
                    print(error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message)
                })
            }
            else {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Added"])
                OTTSdk.userManager.AddUserFavouriteItem(pagePath: (self.contentDetailResponse?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = true
                    AppDelegate.getDelegate().isListPageReloadRequired = true
                    self.detailsTableView.reloadData()
                    if playerVC != nil {
                        playerVC?.isFavourite = self.isFavourite
                        playerVC?.setFavUI()
                    }
                    self.showAlert(message: "Added to Watchlist")
                }, onFailure: { (error) in
                    print(error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message)
                })
            }
            
        }
        else {
            self.showAlertSignInWithText(message: "Please sign in to add your videos to Favorite".localized)
        }
    }
    
    @objc func rentButtonTap(){
        let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
        self.showAlert(message: alertMessage)
        
    }
    @objc func playButtonTap(){
        if self.playButtonElement.elementSubtype == "subscribe" {
            if let _ = OTTSdk.preferenceManager.user?.userId {
                let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
                self.showAlert(message: alertMessage)
                
            }
            else{
                self.startAnimating(allowInteraction: false)
                self.navigateToPlayer(isFromStartOver: false)
            }
        }
        else{
            self.startAnimating(allowInteraction: false)
            self.navigateToPlayer(isFromStartOver: false)
        }
    }
    
    func navigateToPlayerFromHeaderMenu(buttonElement : Element) {
        let contentName = self.channelTitleLabel?.text ?? ""
        
        var tempElement = [String:Any]()
        tempElement["elementSubtype"] = buttonElement.elementSubtype
        tempElement["contentCode"] = buttonElement.contentCode
        tempElement["data"] = buttonElement.data
        tempElement["rowNumber"] = 0
        tempElement["elementCode"] = buttonElement.elementSubtype
        tempElement["columnSpan"] = 0
        tempElement["displayCondition"] = ""
        tempElement["id"] = buttonElement.id
        tempElement["columnNumber"] = 0
        tempElement["rowSpan"] = 0
        tempElement["target"] = buttonElement.target
        tempElement["elementType"] = buttonElement.elementType
        tempElement["value"] = ""
        
        let templateElement = TemplateElement.init(tempElement)
        
        if self.contentType == "network"{
            if appContants.appName == .gac { LocalyticsEvent.tagEventWithAttributes("\(self.navigationTitleLbl.text!)_Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages]) }
        } else if self.contentType == "channel" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Catchup":contentName, "Controls":buttonElement.data])
        } else if self.contentType == "movie" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Movies":contentName, "Controls":buttonElement.data])
        } else if self.contentType == "tvshowdetails" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "TV_Show":contentName, "Controls":buttonElement.data])
        }
        
        if (buttonElement.elementSubtype == "subscribe" || buttonElement.elementSubtype == "rent") {
            self.stopAnimating()
            if OTTSdk.preferenceManager.user == nil {
                self.showAlertSignInWithText("To get access to watch the content", message: "Sign in to enjoy uninterrupted services")
                
                //self.showAlertSignInWithText(message: "Please login and subscribe to continue".localized)
            }
            else{
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Please subscribe to continue".localized)
            }
        }
        else {
            
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                self.stopAnimating()
                return
            }
            self.startAnimating(allowInteraction: false)
            /*self.samplePage()*/
            TargetPage.getTargetPageObject(path: buttonElement.target) { (viewController, type) in
                
                if type == .player{
                    guard let playerVC = viewController as? PlayerViewController else{
                        self.stopAnimating()
                        return
                    }
                    playerVC.delegate = self
                    for data in self.sectionDetailsObjArr {
                        if data is Content {
                            let pageData = data as? Content
                            playerVC.defaultPlayingItemUrl = (pageData?.backgroundImage)!
                            playerVC.playingItemTitle = (pageData?.title)!
                            playerVC.playingItemTargetPath = buttonElement.target
                            playerVC.templateElement = templateElement
                            playerVC.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
                        }
                    }
                    
                    AppDelegate.getDelegate().window?.addSubview(playerVC.view)
                }
                else{
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
                self.stopAnimating()
            }
        }
    }
    
    
    
    
    
    
    func navigateToPlayer(isFromStartOver:Bool, isTrailer:Bool = false) {
        var contentName = ""
        for obj in self.sectionDetailsObjArr {
            if let content = obj as? Content {
                contentName = content.title
                break
            }
        }
        var buttonElement : Element?
        
        if isTrailer == true {
            buttonElement = trailerButtonElement
        }
        else {
            buttonElement = (isFromStartOver == true ? self.startOverButtonElement : self.playButtonElement)
        }
        
        var tempElement = [String:Any]()
        tempElement["elementSubtype"] = buttonElement?.elementSubtype
        tempElement["contentCode"] = buttonElement?.contentCode
        tempElement["data"] = buttonElement?.data
        tempElement["rowNumber"] = 0
        tempElement["elementCode"] = buttonElement?.elementSubtype
        tempElement["columnSpan"] = 0
        tempElement["displayCondition"] = ""
        tempElement["id"] = buttonElement?.id
        tempElement["columnNumber"] = 0
        tempElement["rowSpan"] = 0
        tempElement["target"] = buttonElement?.target
        tempElement["elementType"] = buttonElement?.elementType
        tempElement["value"] = ""
        
        let templateElement = TemplateElement.init(tempElement)
        
        if self.contentType == "network"{
            if appContants.appName == .gac { LocalyticsEvent.tagEventWithAttributes("\(self.navigationTitleLbl.text!)_Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages]) }
        } else if self.contentType == "channel" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Catchup":contentName, "Controls":buttonElement!.data])
        } else if self.contentType == "movie" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Movies":contentName, "Controls":buttonElement!.data])
        } else if self.contentType == "tvshowdetails" {
            LocalyticsEvent.tagEventWithAttributes("Details_page", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "TV_Show":contentName, "Controls":buttonElement!.data])
        }
        
        if (buttonElement?.elementSubtype == "subscribe" || buttonElement?.elementSubtype == "rent") {
            self.stopAnimating()
            if OTTSdk.preferenceManager.user == nil {
                self.showAlertSignInWithText("To get access to watch the content", message: "Sign in to enjoy uninterrupted services")
                
                //self.showAlertSignInWithText(message: "Please login and subscribe to continue".localized)
            }
            else{
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Please subscribe to continue".localized)
            }
        }
        else {
            
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                self.stopAnimating()
                return
            }
            self.startAnimating(allowInteraction: false)
            /*self.samplePage()*/
            TargetPage.getTargetPageObject(path: buttonElement!.target) { (viewController, type) in
                
                if type == .player{
                    guard let playerVC = viewController as? PlayerViewController else{
                        self.stopAnimating()
                        return
                    }
                    playerVC.delegate = self
                    for data in self.sectionDetailsObjArr {
                        if data is Content {
                            let pageData = data as? Content
                            playerVC.defaultPlayingItemUrl = (pageData?.backgroundImage)!
                            playerVC.playingItemTitle = (pageData?.title)!
                            playerVC.playingItemTargetPath = buttonElement!.target
                            playerVC.templateElement = templateElement
                            playerVC.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
                        }
                    }
                   
                    AppDelegate.getDelegate().window?.addSubview(playerVC.view)
                }
                else{
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
                self.stopAnimating()
            }
        }
        /**/
        
        
        
        //self.samplePage()
        /*
         if self.movieDetailResponse?.playButtonInfo.status == .beforeLogin{
         //SignInVC
         let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
         let view1 = accStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
         view1.viewControllerName = "MovieDetailsViewController"
         view1.targetVC = self
         view1.accountDelegate = self
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(view1, animated: true)
         }
         else if self.movieDetailResponse?.playButtonInfo.status == .afterLogin{
         shouldProcessPayment = true
         
         // Check mobileStatus, zipCode (optional) then proceed for payment
         if YuppTVSDK.preferenceManager.user?.mobileStatus == true{
         //Check zipcode
         if self.movieDetailResponse?.isZipCodeNeeded == true{
         // show zipcode
         showZipCodeView()
         }
         else{
         // payment
         //                    payForMovie()
         }
         }
         else{
         if YuppTVSDK.preferenceManager.user!.mobile.isEmpty{
         let aStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
         
         let verifyMobileView = aStoryBoard.instantiateViewController(withIdentifier: "VerifyMobileViewController") as! VerifyMobileViewController
         verifyMobileView.viewControllerName = "MovieDetailsViewController"
         verifyMobileView.accountDelegate = self
         verifyMobileView.targetVC = self
         
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(verifyMobileView, animated: true)
         }
         else{
         //Otp page
         self.showOTPView()
         }
         }
         }
         else if self.movieDetailResponse?.playButtonInfo.status == .afterSubscribe{
         if YuppTVSDK.preferenceManager.user?.mobileStatus == false{
         if YuppTVSDK.preferenceManager.user!.mobile.isEmpty{
         //TODO: Add mobile
         }
         else{
         //Otp page
         self.showOTPView()
         }
         }
         else {
         self.sendStreamKey()
         }
         }*/
    }
    
    //MARK:- Watch Party view delegate methods
    func StartThePartySelected() {
        if self.parent?.popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        self.showWatchPartyMenuInPlayer = true
        self.playButtonTap()
    }
    
    func watchPartyCloseButtonSelected() {
        if self.parent?.popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
    }
    
    func StartThePartyConfirmSelected() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        self.showWatchPartyView()
    }
    func MaybeLaterButtonSelected() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
    }
    
    /**/
    public func page(onSuccess : @escaping (PageContentResponse)-> Void, onFailure : @escaping(APIError) -> Void){
        
        if let path = Bundle.main.path(forResource: "player", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
                    print(jsonResult)
                    let response = PageContentResponse(jsonResult["response"] as! [String : Any])
                    
                    onSuccess(response)
                } catch {
                    onFailure(APIError.defaultError())
                }
            } catch let error {
                print(error.localizedDescription)
                onFailure(APIError.defaultError())
            }
        } else {
            print("Invalid filename/path.")
            onFailure(APIError.defaultError())
        }
    }
    // MARK: - AccountDelegate methods
    
    func didFinishSignIn(finished: Bool) {
        getMovieDetails()
        /*
         if finished{
         // back to current view controller
         print("didFinishSignIn")
         }
         else{
         //still process is going on.. like OTP verification
         }
         */
    }
    
    func didFinishSignUp(){
        getMovieDetails()
        print("didFinishSignUp")
    }
    
    func didFinishOTPValidation(){
        getMovieDetails()
        print("didFinishOTPValidation")
    }
    
    //MARK: - ZipcodeVCDelegate Methods
    
    func didFinishZipcodeValidationSuccessfully() {
        if shouldProcessPayment{
            //            payForMovie()
            print("Show payment")
        }
    }
    //MARK:  InAppPurchaceVCDelegate Methods
    func didBuyProduct(movieId: String) {
        // self.showInAppSuccess()
    }
    
    //MARK: - PopUp Delegates
    //MARK:  PaymentSuccessViewControllerDelegate Methods
    func didSelectedDoneForPaymentSuccessPopup() {
        // dismissing popup
        self.dismissPopupViewController(.topBottom)
        
        //TODO: jun19 : getting new session after inapp purchase from backend. need to check later and uncomment sendStreamKey()
        //        sendStreamKey()
    }
    
    //MARK:  GeoVerificationViewControllerDelegate method
    /*  func dismissedGeoPopover(streamKeyResponse : StreamKeyResponse?, verified : Bool){
     // dismissing popup
     self.dismissPopupViewController(.topBottom)
     
     //        showTermsAndPiracyPolicyView()
     //        return;
     
     
     if verified{
     if streamKeyResponse?.showTerms == true{
     showTermsAndPiracyPolicyView()
     }
     else{
     self.termsAndConditionsArray.removeAll()
     self.movieDetailResponse = nil
     self.getMovieDetails()
     }
     }
     }
     
     //MARK:  TermsAndPiracyPolicyViewControllerDelegate method
     func didAcceptedTermsAndPiracyPolicy(accepted : Bool) {
     // dismissing popup
     //        self.dismissPopupViewController(.topBottom)
     self.termsAndConditionsArray.removeAll()
     self.movieDetailResponse = nil
     self.getMovieDetails()
     
     }
     
     */
    
    // MARK: - ExpandableLabel methods
    func willExpandLabel(_ label: ExpandableLabel) {
        self.detailsTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.detailsTableView)
        if (self.detailsTableView.indexPathForRow(at: point) as IndexPath?) != nil {
            states[0] = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            
            self.currentScrollPos = self.detailsTableView.contentOffset.y
            self.view.layoutIfNeeded()
            self.detailsTableView.endUpdates()
            self.currentScrollPos = nil
        }, completion: nil)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.detailsTableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.detailsTableView)
        if (self.detailsTableView.indexPathForRow(at: point) as IndexPath?) != nil {
            states[0] = true
        }
        UIView.animate(withDuration: 0.01, animations: {
            
            self.currentScrollPos = self.detailsTableView.contentOffset.y
            self.view.layoutIfNeeded()
            self.detailsTableView.endUpdates()
            self.currentScrollPos = nil
        }, completion: nil)
    }
    var currentScrollPos : CGFloat?
    
    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionDetailsObjArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.movieDescriptionText .isEmpty {
                return 1
            }
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier:String!;
        
        if self.sectionDetailsObjArr[indexPath.section] is Content {
            if indexPath.row == 0 {
                let contentDetailsObj = self.sectionDetailsObjArr[indexPath.section] as? Content
                identifier = "DetailsCell"
                
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! DetailsCell
                cell.expiryTitleLabelHeightConstraint?.constant = 0
                cell.rentInfoHeightConstraint?.constant = 0
                if self.contentDetailResponse != nil {
                    
                    //                cell.watchButton.cornerDesign()
                    //                if self.contentType != "movie" {
                    
                    //                    cell.gr_overlayImageView.setDetailsPageGradientForView()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                        // gac not imp
                        if appContants.appName != .gac {
                            self.movieBGImageView.setDetailsPageGradientForView()
                        }
                    }
                    //                    cell.gr_overlayImageView.applyGradientToView(cell.gr_overlayImageView, numberOfColors: 3)
                    //self.movieBGImageView.applyGradientToView(self.movieBGImageView, numberOfColors: 4)
                    //                }
                    
                    if  contentDetailsObj != nil && !(contentDetailsObj?.title .isEmpty)!
                    {
                        cell.movieTitleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                        cell.movieTitleLabel.font = UIFont.ottRegularFont(withSize: 20)
                        cell.movieTitleLabel.text = contentDetailsObj?.title
                        cell.movieTitleLabel.textAlignment = .center
                        //                        var userID = OTTSdk.preferenceManager.user?.email
                        //                        if userID != nil && (userID? .isEmpty)! {
                        //                            userID = OTTSdk.preferenceManager.user?.phoneNumber
                        //                        }
                        //                        else {
                        //                            userID = "NA"
                        //                        }
                        //                        let attributes = ["User_ID":userID,"TimeStamp":"\(Int64(Date().timeIntervalSince1970 * 1000))","Show_Name":cell.movieTitleLabel.text]
                        //                        LocalyticsEvent.tagEventWithAttributes("\(AppDelegate.getDelegate().taggedScreen)", attributes as! [String : String])
                    }
                    if  contentDetailsObj != nil && contentDetailsObj?.backgroundImage .isEmpty == false || appContants.appName == .gac
                    {
                        self.movieBGImageView.isHidden = false
                        if self.reload == 0 {
                        self.movieBGImageView.loadingImageFromUrl((contentDetailsObj?.backgroundImage)! , category: "movie_background")
                        self.movieBGImageView.loadingImageFromUrl((contentDetailsObj!.dataRows.first?.elements.first?.data)! , category: "movie_background")
                        if movieImage == nil {
                            self.movieImage = movieBGImageView
                        }
                        self.movieBGImageView = movieImage
                            self.reload = 1
                        }
                        self.moviebackcolorView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                        
                    }
                    else {
                        self.movieBGImageView.loadingImageFromUrl(("") , category: "movie_background")

                        self.movieBGImageView.isHidden = false
                    }
                    let lblView = cell.viewWithTag(1)
                    let lblSubView = lblView?.viewWithTag(11)
                    let btnView = cell.viewWithTag(100)
                    let btnSubView = btnView?.viewWithTag(1001)
                    let contentDataRows = contentDetailsObj?.dataRows
                    var yPosition:CGFloat = 5.0
                    var buttonElements = [Element]()
                    
                    if lblSubView?.subviews != nil{
                        for sub in (lblSubView?.subviews)!{
                            sub.removeFromSuperview()
                        }
                    }
                    var elementTag = 1
                    var labelBtnsDataRows = [DataRow]()
                    var dataRow : DataRow?
                    for contentDataRow in contentDataRows! {
                        var labelBtnsElements = [Element]()
                        dataRow = contentDataRow
                        let dataElements = contentDataRow.elements
                        for dataElement in dataElements {
                            if ((dataElement.elementType == .text || dataElement.elementType == .button || dataElement.elementType == .marker) && contentDataRow.rowDataType == "content"){
                                print("...elementSubtype:\(dataElement.elementSubtype)")
                                labelBtnsElements.append(dataElement)
                            }
                            else if dataElement.elementType == .button && contentDataRow.rowDataType == "button"{
                                buttonElements.append(dataElement)
                            }
                        }
                        if labelBtnsElements.count > 0 {
                            dataRow?.elements = labelBtnsElements
                            labelBtnsDataRows.append(dataRow!)
                        }
                    }
                    
                    for lblBtnDataRow in labelBtnsDataRows {
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                            cell.rentInfoLabel?.text = ""
                            let dataElements = lblBtnDataRow.elements
                            var xPosition:CGFloat = 0.0
                            var tempYPosition:CGFloat = 0.0
                            var width = appContants.appName == .gac ? 124 : (lblSubView?.frame.size.width)!/CGFloat(dataElements.count)
                            for dataElement in dataElements {
                                if dataElement.elementType == .text && lblBtnDataRow.rowDataType == "content" {
                                    
                                    if dataElement.elementSubtype == "rentalinfo" {
                                        cell.rentInfoLabel?.text =  dataElement.data
                                        cell.rentInfoLabel?.textColor = AppTheme.instance.currentTheme.rentInfoTextLabelColor
                                        cell.rentInfoLabel?.font = UIFont.ottSemiBoldFont(withSize: 12)
                                        cell.rentInfoLabel?.textAlignment = .center
                                        cell.rentInfoLabel?.numberOfLines = 0
                                        cell.rentInfoLabel?.sizeToFit()
                                        cell.rentInfoHeightConstraint?.constant = 40
                                    }
                                    else if dataElement.elementSubtype == "expiryInfo" {
                                        cell.expiryTitleLabelHeightConstraint?.constant = 21
                                        cell.expiryTitleLabel?.text =  dataElement.data
                                        cell.expiryTitleLabel?.textColor = AppTheme.instance.currentTheme.expireTextColor
                                        cell.expiryTitleLabel?.font = UIFont.ottMediumItalicFont(withSize: 14)
                                        cell.expiryTitleLabel?.textAlignment = .center
                                    }
                                    else if dataElement.elementSubtype == "subtitle" {
                                        cell.movieSubTitleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50
                                        cell.movieSubTitleLabel.font = UIFont.ottRegularFont(withSize: 12)
                                        cell.movieSubTitleLabel.text = dataElement.data
                                        cell.movieSubTitleLabel.textAlignment = .center
                                        cell.movieSubTitleLabel.numberOfLines = 0
                                        cell.movieSubTitleLabel.sizeToFit()
                                    }
                                    /* let elementLbl = UILabel.labelWithFrame(withXposition: xPosition, withYposition: yPosition, withWidth: width, withHeight: 60.0, andElementData: dataElement,withAlignment: NSTextAlignment.center,withSize: 13.0,numberOfLines:0)
                                     elementLbl.tag = elementTag
                                     self.removeViewIfAlreadyExistsIn(lblSubView!, withSubView: elementLbl)
                                     //height = elementLbl.frame.size.height
                                     elementLbl.numberOfLines = 0
                                     elementLbl.sizeToFit()
                                     
                                     tempYPosition = elementLbl.frame.origin.y + elementLbl.frame.size.height + 10.0
                                     width = elementLbl.frame.size.width
                                     elementLbl.backgroundColor = .green
                                     lblSubView?.addSubview(elementLbl)
                                     lblSubView?.frame.size.height = tempYPosition
                                     lblSubView?.frame.origin.y = (lblSubView?.frame.origin.y ?? 20) - tempYPosition
                                     xPosition = xPosition + width + 5.0*/
                                }
                                else if dataElement.elementType == .button && lblBtnDataRow.rowDataType == "content"{
                                    
                                    
                                    
                                    let elementLbl = UIButton.buttonWithFrame(withXposition: xPosition, withYposition: yPosition, withWidth: width, withHeight: appContants.appName == .gac ? 35.0 : 21.0 , andElementData: dataElement, withSize: 13.0, isRowBtnType: false)
                                    elementLbl.tag = elementTag
                                    self.removeViewIfAlreadyExistsIn(lblSubView!, withSubView: elementLbl)
                                    elementLbl.sizeToFit()
                                    tempYPosition = elementLbl.frame.origin.y + elementLbl.frame.size.height + 10.0
                                    elementLbl.contentEdgeInsets = UIEdgeInsets.init(top: -12.0, left: 0, bottom: 0, right: 0)
                                    width = elementLbl.frame.size.width
                                    lblSubView?.addSubview(elementLbl)
                                    xPosition = xPosition + width + 5.0
                                    
                                }
                                else if dataElement.elementType == .marker && lblBtnDataRow.rowDataType == "content"{
                                    if dataElement.elementSubtype == "duration" || dataElement.elementSubtype == "rating"{
                                        let elementLbl = UILabel.labelWithFrame(withXposition: xPosition, withYposition: yPosition, withWidth: width, withHeight: 21.0, andElementData: dataElement,withAlignment: NSTextAlignment.left,withSize: 13.0,numberOfLines:1)
                                        elementLbl.tag = elementTag
                                        self.removeViewIfAlreadyExistsIn(lblSubView!, withSubView: elementLbl)
                                        elementLbl.sizeToFit()
                                        tempYPosition = elementLbl.frame.origin.y + elementLbl.frame.size.height + 10.0
                                        width = elementLbl.frame.size.width
                                        lblSubView?.addSubview(elementLbl)
                                        xPosition = xPosition + width + 5.0
                                    }
                                    else {
                                        let elementImgView = UIImageView.imageViewWithFrame(withXposition: xPosition, withYposition: yPosition + 2.0, withWidth: 19, withHeight: 12, andElementData: dataElement, withImageType: dataElement.elementSubtype)
                                        elementImgView.tag = elementTag
                                        self.removeViewIfAlreadyExistsIn(lblSubView!, withSubView: elementImgView)
                                        tempYPosition = elementImgView.frame.origin.y + elementImgView.frame.size.height + 10.0
                                        width = elementImgView.frame.size.width
                                        lblSubView?.addSubview(elementImgView)
                                        xPosition = xPosition + width + 5.0
                                    }
                                }
                                let dotView = UILabel.createDotView(withXposition: xPosition, withYposition: yPosition + 1.0, withWidth: 1.0, withHeight: 15.0)
                                dotView.tag = elementTag
                                self.removeViewIfAlreadyExistsIn(lblSubView!, withSubView: dotView)
                                elementTag = elementTag + 1
                                width = dotView.frame.size.width
                                //                        lblSubView?.addSubview(dotView)
                                //                        xPosition = xPosition + width + 5.0
                                //                        elementTag = elementTag + 1
                            }
                            yPosition = tempYPosition
                            if cell.expiryTitleLabel?.text?.count ?? 0 > 0 {
                                
                                var splitArray = cell.expiryTitleLabel!.text!.components(separatedBy: "@")
                                
                                if splitArray.count > 1 {
                                    let string1 = splitArray[0]
                                    splitArray.remove(at: 0)
                                    let string2 = splitArray.joined(separator:" ")
                                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (string1 + string2))
                                    let range1: NSRange = attributedString.mutableString.range(of: string1, options: .caseInsensitive)
                                    let range2: NSRange = attributedString.mutableString.range(of: string2, options: .caseInsensitive)
                                    attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.expireTextColor!, range: range1)
                                    attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.cardTitleColor!, range: range2)
                                    cell.expiryTitleLabel.attributedText = attributedString
                                }
                                
                                
                                cell.expiryTitleLabel?.isHidden = false
                                cell.expiryTitleLabelHeightConstraint?.constant = 21
                            }
                            else{
                                cell.expiryTitleLabel?.isHidden = true
                                cell.expiryTitleLabelHeightConstraint?.constant = 0
                            }
                            
                            if cell.rentInfoLabel?.text?.count ?? 0 > 0 {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                    cell.rentInfoLabel?.sizeToFit()
                                    if cell.rentInfoLabel?.frame.size.height ?? 40 > 40 {
                                        cell.rentInfoHeightConstraint?.constant = cell.rentInfoLabel?.frame.size.height ?? 40
                                    }
                                    else{
                                        cell.rentInfoHeightConstraint?.constant = 40
                                    }
                                    
                                    let tempHeight = cell.rentInfoLabel?.frame.size.height ?? 0 + 5
                                    
                                    
                                    cell.rentInfoHeightConstraint?.constant = tempHeight
                            //        cell.buttonsBgViewHeightConstraint?.constant = 140 + tempHeight
                                    
                                    cell.rentInfoIcon?.isHidden = false
                                    cell.rentInfoLabel?.isHidden = false
                                }
                                
                            }
                            else {
                                cell.rentInfoIcon?.isHidden = true
                                cell.rentInfoLabel?.isHidden = true
                                cell.rentInfoHeightConstraint?.constant = 0
                                if appContants.appName != .gac { cell.buttonsBgViewHeightConstraint?.constant = 140 }
                            }
                        }
                    }
                    
                    cell.separatorLabel?.isHidden = true
                    cell.trailerButton?.isHidden = true
                    cell.separatorLabel1?.isHidden = true
                    cell.startOverButton?.isHidden = true
                    cell.buttonsStackViewWidthConstraint.constant = self.view.frame.width/3.6
                    cell.progressBar?.isHidden = true
                    
                    cell.rentButton?.isHidden = true
                    cell.rentButtonWidthConstraint?.constant = 0
                    cell.rentButtonTrailingConstraint?.constant = 0
                    
                    for btnElement in buttonElements {
                        if btnElement.elementSubtype == "startover" {
                            cell.separatorLabel1?.isHidden = false
                            cell.startOverButton?.isHidden = false
                            self.startOverButtonElement = btnElement
                        }
                        else{
                            if btnElement.elementSubtype == "resume" {
                                cell.progressBar?.frame.size.height = 3
                                cell.progressBar?.progressTintColor = AppTheme.instance.currentTheme.cardTitleColor
                                cell.progressBar?.trackTintColor = AppTheme.instance.currentTheme.progressBarTrackColor
                                
                                cell.progressBar?.isHidden = false
                                cell.progressBar?.progress = Float(self.contentDetailResponse?.info.attributes.watchedPosition ?? 0.0)
                                self.playButtonElement = btnElement
                                cell.watchButton.setTitle(btnElement.data, for: .normal)
                                cell.watchButton.setImage(UIImage.init(named: "img_play_circle"), for: .normal)
                                
                            }
                            else if btnElement.elementSubtype == "subscribe" {
                                self.playButtonElement = btnElement
                                cell.watchButton.setTitle(btnElement.data, for: .normal)
                                cell.watchButton.setImage(UIImage.init(named: ""), for: .normal)
                            }
                            else if btnElement.elementSubtype == "rent" {
                                cell.rentButton?.setTitle(btnElement.data, for: .normal)
                                cell.rentButton?.isHidden = false
                            }
                            else if btnElement.elementSubtype == "trailer" {
                                cell.separatorLabel?.isHidden = false
                                cell.trailerButton?.isHidden = false
                                self.trailerButtonElement = btnElement
                                cell.trailerButton?.setTitle(btnElement.data, for: .normal)
                            }
                            else{
                                self.playButtonElement = btnElement
                                cell.watchButton.setTitle(btnElement.data, for: .normal)
                                cell.watchButton.setImage(UIImage.init(named: "img_play_circle"), for: .normal)
                            }
                        }
                    }
                    
                    if buttonElements.count == 0 || cell.watchButton.titleLabel?.text?.count ?? 0 == 0 {
                        cell.watchButton.isHidden = true
                    }
                    
                    if cell.startOverButton?.isHidden == false && cell.trailerButton?.isHidden == false {
                        cell.buttonsStackViewWidthConstraint.constant = UIScreen.main.bounds.size.width > 414.0 ? 430 : UIScreen.main.bounds.size.width  - 30
                    }
                    else if (cell.startOverButton?.isHidden == false || cell.trailerButton?.isHidden == false) {
                        cell.buttonsStackViewWidthConstraint.constant = 320
                    }
                    
                    cell.watchButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
                    cell.watchButton.titleLabel?.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
                    cell.watchButton.backgroundColor = AppTheme.instance.currentTheme.themeColor
                    cell.watchButton.addTarget(self, action: #selector(DetailsViewController.playButtonTap), for: UIControl.Event.touchUpInside)
                    cell.watchButton.cornerDesignWithoutBorder()
                    
                    cell.rentButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
                    cell.rentButton?.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
                    cell.rentButton?.addTarget(self, action: #selector(DetailsViewController.rentButtonTap), for: UIControl.Event.touchUpInside)
                    cell.rentButton?.cornerDesignWithoutBorder()
                    
                    
                    if cell.rentButton?.isHidden == false {
                        if cell.watchButton.titleLabel?.text?.count ?? 0 > 0 {
                            cell.watchButton.isHidden = false
                            cell.rentButtonTrailingConstraint?.constant = 15
                            cell.rentButtonWidthConstraint?.constant = (tableView.frame.size.width - 80) / 2
                            cell.rentButton?.backgroundColor = AppTheme.instance.currentTheme.themeColor
                            
                        }
                        else {
                            cell.rentButton?.backgroundColor = AppTheme.instance.currentTheme.themeColor
                            cell.rentButtonTrailingConstraint?.constant = 0
                            cell.rentButtonWidthConstraint?.constant = tableView.frame.size.width - 60
                            cell.watchButton.isHidden = true
                        }
                    }
                    cell.separatorLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    cell.separatorLabel1?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    cell.separatorLabel2?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    
                    cell.trailerButton?.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
                    cell.trailerButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 10)
                    cell.trailerButton?.alignTextUnderImage(spacing: 5)
                    cell.trailerButton?.addTarget(self, action: #selector(DetailsViewController.trailerButtonTap), for: UIControl.Event.touchUpInside)
                    
                    
                    cell.startOverButton?.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
                    cell.startOverButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 10)
                    cell.startOverButton?.setTitle("Start over", for: .normal)
                    cell.startOverButton?.alignTextUnderImage(spacing: 5)
                    cell.startOverButton?.addTarget(self, action: #selector(DetailsViewController.startOverButtonTap), for: UIControl.Event.touchUpInside)
                    if cell.rentButton?.isHidden ?? true == true && cell.watchButton.isHidden == true {
                        cell.rentButtonHeightConstraint?.constant = 0
                        cell.watchButtonHeightConstraint?.constant = 0
                    }
                    else {
                        cell.rentButtonHeightConstraint?.constant = 44
                        cell.watchButtonHeightConstraint?.constant = 47
                    }
                    if self.isFavourite {
                        cell.watchlistButton?.setImage(UIImage.init(named:"img_remove_watchlist_circle"), for: .normal)
                    }
                    else {
                        cell.watchlistButton?.setImage(UIImage.init(named: "img_watchlist_circle"), for: .normal)
                    }
                    if appContants.appName == .gac {
                        cell.buttonsStackView?.alignment = .fill
                        cell.buttonsStackViewHeightConstraint?.constant = 36
                        cell.watchlistButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 13)
                        cell.watchlistButton?.imageView?.contentMode = .scaleAspectFit
                        cell.watchlistButton?.tintColor = AppTheme.instance.currentTheme.cardSubtitleColor
                        cell.watchlistButton?.setTitle("Favorite", for: .normal)
                        cell.watchlistButton?.titleLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                        cell.watchlistButton?.imageEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 15);
                        cell.watchlistButton?.titleEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 10);
                        cell.watchlistButton?.buttonCornerDesignWithBorder(AppTheme.instance.currentTheme.cardSubtitleColor, borderWidth: 0.7)
                        cell.separatorLabel2?.isHidden = true
                        cell.buttonsBgViewHeightConstraint?.constant = 80

                    } else {
                    cell.watchlistButton?.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
                    cell.watchlistButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 10)
                    cell.watchlistButton?.setTitle("Watchlist", for: .normal)
                    cell.watchlistButton?.alignTextUnderImage(spacing: 5)
                    }
                    cell.watchlistButton?.addTarget(self, action: #selector(DetailsViewController.watchlistButtonTap), for: UIControl.Event.touchUpInside)
                    if (self.contentDetailResponse?.pageButtons.showFavouriteButton ?? false) == true {
                        cell.watchlistButton?.isHidden = false
                    }
                    else {
                        cell.watchlistButton?.isHidden = true
                    }
                    
                    if self.contentDetailResponse?.shareInfo.isSharingAllowed == true && appContants.appName != .gac{
                        cell.watchPartyButton?.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
                        cell.watchPartyButton?.titleLabel?.font = UIFont.ottRegularFont(withSize: 10)
                        cell.watchPartyButton?.setTitle("Share", for: .normal)
                        cell.watchPartyButton?.alignTextUnderImage(spacing: 5)
                        cell.watchPartyButton?.addTarget(self, action: #selector(DetailsViewController.watchPartyButtonTap(sender:)), for: UIControl.Event.touchUpInside)
                        cell.watchPartyButton?.isHidden = false
                        cell.separatorLabel2?.isHidden = false
                        
                    }
                    else {
                        cell.watchPartyButton?.isHidden = true
                        cell.buttonsStackViewWidthConstraint.constant = cell.buttonsStackViewWidthConstraint.constant > UIScreen.main.bounds.size.width ? cell.buttonsStackViewWidthConstraint.constant : cell.buttonsStackViewWidthConstraint.constant
                        cell.contentMode = .top
                        return cell
                    }
                }
                cell.backgroundColor = UIColor.clear
                return cell
            } else {
                self.detailsTableView.estimatedRowHeight = 44
                self.detailsTableView.rowHeight = UITableView.automaticDimension
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as! ExpandableCell
                cell.expandableLabel.delegate = self
                cell.layoutIfNeeded()
                cell.contentView.layoutIfNeeded()
                cell.setNeedsLayout()
                cell.contentView.setNeedsLayout()
                if(cell.expandableLabel.preferredMaxLayoutWidth != cell.expandableLabel.bounds.size.width) {
                    cell.expandableLabel.preferredMaxLayoutWidth = cell.expandableLabel.bounds.size.width
                }
                cell.expandableLabel.font = UIFont.ottRegularFont(withSize: 12.0)
                cell.expandableLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                cell.expandableLabel.shouldCollapse = true
                cell.expandableLabel.textReplacementType = .word
                cell.expandableLabel.numberOfLines = 5
                
                
                if appContants.appName == .gac {
                    var heading = "About\n\n "
                    var content = "\(movieDescriptionText)"
        
                    let attributedText = NSMutableAttributedString(string: heading, attributes: [NSAttributedString.Key.font: UIFont.ottSemiBoldFont(withSize: 14)])
                    attributedText.append(NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.ottLightFont(withSize: 12)]))
                    cell.expandableLabel.attributedText = attributedText
                    cell.expandableLabel.collapsed = true
                    cell.expandableLabel.shouldExpand = true
                    cell.expandableLabel.shouldCollapse = true
                    cell.expandableLabel.collapsedAttributedLink = NSAttributedString(string: "Read More", attributes: [.font: UIFont.ottRegularFont(withSize: 12), .foregroundColor: AppTheme.instance.currentTheme.navigationBarColor])
                    cell.expandableLabel.expandedAttributedLink = NSAttributedString(string: "Read Less", attributes: [.font: UIFont.ottRegularFont(withSize: 12), .foregroundColor: AppTheme.instance.currentTheme.navigationBarColor])
                    cell.expandableLabel.ellipsis = NSAttributedString(string: "...", attributes: [.font: UIFont.ottRegularFont(withSize: 12), .foregroundColor: AppTheme.instance.currentTheme.cardSubtitleColor])
                } else {              
                    cell.expandableLabel.collapsed = false
                    cell.expandableLabel.text = movieDescriptionText
                }
                cell.backgroundColor = UIColor.clear
                return cell
            }
        }
        else {
            let section = self.sectionDetailsObjArr[indexPath.section] as? Section
            if section?.sectionInfo.dataType == "actor" {
                identifier = "CastTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CastTableViewCell
                if self.castCrewArray.count > 0 {
                    self.castCrewArray.removeAll()
                }
                for card in (section?.sectionData.data)! {
                    let display = card.display
                    let castCrewObj = CastCrewModel.init(withImageUrl: display.imageUrl, castName: display.title, castType: display.subtitle1, castCode: card.target.path)
                    self.castCrewArray.append(castCrewObj)
                }
                cell.setUpData(cast: self.castCrewArray)
                cell.backgroundColor = UIColor.clear
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier) as! DetailsTableViewCell
                cell.targetPath = self.targetPath
                cell.setUpData(section: section,pageContent: contentDetailResponse!)
                cell.delegate = self
                cell.viewController = self
                if self.contentType == "network" {
                    cell.isPartnerWithTabs = self.checkIsPartnerWithTabs()
                    if appContants.appName != .gac {
                    cell.partnerName = self.navigationTitleLbl.text!
                    }
                }
                //            cell.termsLabel.attributedText = obj.totalAttributedString
                cell.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.sectionDetailsObjArr[indexPath.section] is Content {
            if indexPath.row == 0 {
                return self.contentCellHeight + self.tvShowCellHeight + 20
            } else {
                self.detailsTableView.rowHeight = UITableView.automaticDimension
                return UITableView.automaticDimension
                
            }
        }
        else {
            let section = self.sectionDetailsObjArr[indexPath.section] as? Section
            if section?.sectionInfo.dataType == "actor" {
                return 75
            }
            else {
                if (self.contentDetailResponse?.tabsInfo.tabs.count)! > 0 {
                    if productType.iPad {
                        if self.contentType == "channel" /* || self.contentType == "network" || self.contentType == "tvshowdetails"*/ {
                            return self.view.frame.size.height - 67
                        }
                        return 670.0
                    }
                    else if isButtonVisisble {
                        if UIScreen.main.bounds.size.height >= 812 {
                           return 320.0
                        }
                        return 240.0
                    }
                    else if self.contentType == "channel" /*|| self.contentType == "network" || self.contentType == "tvshowdetails"*/ {
                        return self.view.frame.size.height - 67
                    }
                    if (self.view.frame.size.height - self.contentCellHeight) > 0 {
                        return (self.view.frame.size.height - self.contentCellHeight)
                    }
                    else{
                        return UITableView.automaticDimension
                    }
                }
                else if /*self.contentType == "network"  || self.contentType == "tvshowdetails" || */ self.contentType == "channel" {
                    return self.sectionDetailsObjArr.count > 0 ? (productType.iPad ? 220.0 : 190.0) :  self.view.frame.size.height - 67
                }
                else {
                    if section?.sectionInfo.dataType == "movie" || section?.sectionInfo.dataType == "network" || section?.sectionInfo.dataType == "tvshowdetails" {
                        if (section?.sectionData.data.count)! > 0 && (section?.sectionData.data.first)!.cardType == .sheet_poster {
                            //                            return (AppDelegate.getDelegate().window?.frame.size.height)! - self.contentCellHeight - 120.0
                            return 250.0
                        }else if (section?.sectionData.data.count)! > 0 && (section?.sectionData.data.first)!.cardType == .roller_poster, productType.iPad {
                            //                            return (AppDelegate.getDelegate().window?.frame.size.height)! - self.contentCellHeight - 120.0
                            return 206 * 1.6
                        }
                        return 250.0
                    }else if (section?.sectionData.data.first)!.cardType == .sheet_poster {
                        if productType.iPad {
                            return 230.0
                        }
                        if appContants.appName == .gac {
                            
                        }
                        return 200
                    }
                    else {
                        if productType.iPad {
                            return 220.0
                        }
                        //                        return (AppDelegate.getDelegate().window?.frame.size.height)! - self.contentCellHeight - 120.0
                        return 250.0
                    }
                }
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath
//    }
    
    // MARK: - UIScrollView Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if appContants.appName != .gac {
        if scrollView == self.detailsTableView {
            if self.contentType != "movie" && self.contentType != "network" && self.contentType != "tvshowdetails" {
                if scrollView.contentOffset.y > 50 {
                    if !(scrollViewAlpha > 1.0) {
                        scrollViewAlpha = scrollViewAlpha + 0.1
                    }
                }
                else {
                    if scrollViewAlpha <= 0 {
                        scrollViewAlpha = 0.0
                    }
                    scrollViewAlpha = scrollViewAlpha - 0.1
                }
            }
        }
            
        } else {
            print(scrollView.contentOffset.y)
          //  self.moviebackcolorView.contentOffset.y = scrollView.contentOffset.y
        }
        
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if appContants.appName != .gac {
        if scrollView == self.detailsTableView {
            scrollViewAlpha = 0.0
        }
        }
    }
    
    //MARK:  -  preparing attributed text for terms and conditions
    /*  func getTermsText(termObj:Term) -> NSMutableAttributedString {
     let color_204 =  UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
     
     let attrString = NSMutableAttributedString()
     
     let paragraphStyle = NSMutableParagraphStyle()
     paragraphStyle.alignment = NSTextAlignment.left
     
     let subTitleParagraphStyle = NSMutableParagraphStyle()
     subTitleParagraphStyle.alignment = NSTextAlignment.left
     
     let descParagraphStyle = NSMutableParagraphStyle()
     descParagraphStyle.alignment = NSTextAlignment.left
     
     //term title
     let termTitle = termObj.title
     //attr
     var font = UIFont.systemFont(ofSize: 14)
     if #available(iOS 8.2, *) {
     font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
     } else {
     // Fallback on earlier versions
     }
     let termTitleTextAttribute : [String : Any] = [NSFontAttributeName:
     font,
     NSForegroundColorAttributeName:color_204, NSParagraphStyleAttributeName : paragraphStyle]
     
     let termTitleTextAttributedString = NSMutableAttributedString(
     string: termTitle,
     attributes: termTitleTextAttribute)
     //        attrString.append(NSAttributedString.init(string: "\n"))
     attrString.append(termTitleTextAttributedString)
     attrString.append(NSAttributedString.init(string: "\n"))
     
     //inside title
     font = UIFont.systemFont(ofSize: 10)
     if #available(iOS 8.2, *) {
     font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightMedium)
     
     } else {
     // Fallback on earlier versions
     }
     
     let mainTitleAttribute : [String : Any] = [NSFontAttributeName:
     font,
     NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName : subTitleParagraphStyle]
     
     
     //desc text
     font = UIFont.systemFont(ofSize: 10)
     
     if #available(iOS 8.2, *) {
     font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight)
     } else {
     // Fallback on earlier versions
     }
     let descTitleAttribute : [String : Any] = [NSFontAttributeName:
     font,
     NSForegroundColorAttributeName: color_204, NSParagraphStyleAttributeName : descParagraphStyle]
     
     
     
     for cond in termObj.conditions{
     
     //condition title
     
     let mainTitleAttributedString = NSMutableAttributedString(
     string: cond.title,
     attributes: mainTitleAttribute)
     attrString.append(mainTitleAttributedString)
     attrString.append(NSAttributedString.init(string: "\n"))
     
     
     //condition description
     var cond_desc_string = String()
     
     for cond_desc_item in cond.conditionDescription{
     
     cond_desc_string.append(cond_desc_item)
     }
     
     let descTitleAttributedString = NSMutableAttributedString(string: cond_desc_string,
     attributes: descTitleAttribute)
     attrString.append(descTitleAttributedString)
     attrString.append(NSAttributedString.init(string: "\n\n"))
     
     }
     
     return attrString
     }*/
    
    func getTextViewHeight(_ textView: UITextView) -> CGFloat {
        let constraintRect = CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = textView.text?.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 12.0)], context: nil)
        
        return boundingBox!.height
    }
    
    func addReadMoreBtn(textView:UITextView)  {
        let xValue:CGFloat
        if UIScreen.main.screenType == .iPhone5
        {
            xValue = 280.0 - 70
        }else{
            xValue = 335.0 - 70
        }
        readMoreBtn = UIButton.init(frame: CGRect.init(x: xValue, y: 65, width: 75, height: 15))
        readMoreBtn.titleLabel?.textColor = UIColor.white
        readMoreBtn.setTitle("..read more", for: UIControl.State.normal)
        readMoreBtn.titleLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        readMoreBtn.addTarget(self, action: #selector(readMoreClicked), for: UIControl.Event.touchUpInside)
        readMoreBtn.tag = 1
        for case let readBtn as UIButton in textView.subviews {
            readBtn.removeFromSuperview()
        }
        textView.addSubview(readMoreBtn)
    }
    
    @objc public func readMoreClicked() {
        /**/
        self.isReadBtnAdded = true
        if readMoreBtn.tag == 1 {
            isReadMoreClicked = true
            readMoreBtn.setTitle("..read less", for: UIControl.State.normal)
            self.tvShowSummaryHeight = (self.getTextViewHeight(self.descContentLbl) )
            //            self.tvShowSummaryHeight = self.tvShowSummaryHeight * 2.5
            let tempSeasonsYOrigin = self.descHeightConstraint.constant
            self.descHeightConstraint.constant = self.descHeightConstraint.constant + self.tvShowSummaryHeight
            self.descContentLbl.isScrollEnabled = true
            self.descContentLbl.sizeToFit()
            self.descContentLbl.isScrollEnabled = false
            tvShowCellHeight = self.descHeightConstraint.constant - tempSeasonsYOrigin
            //            self.summaryViewHeightConstraint.constant = self.summaryViewHeightConstraint.constant+tvShowCellHeight
            readMoreBtn.frame.origin.y = self.descHeightConstraint.constant - 15.0
            readMoreBtn.tag = 2
        }
        else {
            readMoreBtn.tag = 1
            isReadMoreClicked = false
            readMoreBtn.setTitle("..read more", for: UIControl.State.normal)
            self.descHeightConstraint.constant = 80.0
            self.descContentLbl.isScrollEnabled = false
            //            self.summaryViewHeightConstraint.constant = self.summaryViewHeightConstraint.constant-tvShowCellHeight
            readMoreBtn.frame.origin.y = self.descHeightConstraint.constant - 15.0
            self.tvShowSummaryHeight = 0.0
            self.tvShowCellHeight = 0.0
        }
        self.isReadBtnAdded = true
        self.detailsTableView.reloadData()
    }
    

    
    func addReadMoreBtn2(textView:UITableViewCell)  {
        let xValue:CGFloat
        if UIScreen.main.screenType == .iPhone5
        {
            xValue = 280.0 - 70
        }else{
            xValue = 335.0 - 70
        }
        readMoreBtn = UIButton.init(frame: CGRect.init(x: textView.frame.maxX - 65 - 16, y: textView.frame.maxY - 17 , width: 65, height: 17))
        readMoreBtn.titleLabel?.textColor = UIColor.yellow
        readMoreBtn.setTitle("... Read more", for: UIControl.State.normal)
        readMoreBtn.titleLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
        readMoreBtn.addTarget(self, action: #selector(readMoreClicked2), for: UIControl.Event.touchUpInside)
        readMoreBtn.tag = 1
        for case let readBtn as UIButton in textView.subviews {
            readBtn.removeFromSuperview()
        }
        textView.addSubview(readMoreBtn)
    }
    
    @objc public func readMoreClicked2() {
        /**/
        self.isReadBtnAdded = true
        if readMoreBtn.tag == 1 {
            isReadMoreClicked = true
            readMoreBtn.setTitle("... Read less", for: UIControl.State.normal)
            self.tvShowSummaryHeight = (self.getTextViewHeight(self.descContentLbl) )
            //            self.tvShowSummaryHeight = self.tvShowSummaryHeight * 2.5
            let tempSeasonsYOrigin = self.descHeightConstraint.constant
            self.descHeightConstraint.constant = self.descHeightConstraint.constant + self.tvShowSummaryHeight
            self.descContentLbl.isScrollEnabled = true
            self.descContentLbl.sizeToFit()
            self.descContentLbl.isScrollEnabled = false
            tvShowCellHeight = self.descHeightConstraint.constant - tempSeasonsYOrigin
            //            self.summaryViewHeightConstraint.constant = self.summaryViewHeightConstraint.constant+tvShowCellHeight
            readMoreBtn.frame.origin.y = self.descHeightConstraint.constant - 15.0
            readMoreBtn.tag = 2
        }
        else {
            readMoreBtn.tag = 1
            isReadMoreClicked = false
            readMoreBtn.setTitle("... Read more", for: UIControl.State.normal)
            self.descHeightConstraint.constant = 80.0
            self.descContentLbl.isScrollEnabled = false
            //            self.summaryViewHeightConstraint.constant = self.summaryViewHeightConstraint.constant-tvShowCellHeight
            readMoreBtn.frame.origin.y = self.descHeightConstraint.constant - 15.0
            self.tvShowSummaryHeight = 0.0
            self.tvShowCellHeight = 0.0
        }
        self.isReadBtnAdded = true
        self.detailsTableView.reloadData()
    }
    
    
    func showAlert(_ header : String = String.getAppName(),  message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    func showAlertWithText (_ header : String = String.getAppName(),  message : String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let messageAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.backToDetailPage()
        })
        alert.addAction(messageAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertSignInWithText (_ header : String = String.getAppName(),  message : String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let messageAlertAction = UIAlertAction(title: "Sign in", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            
            let signinView = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            signinView.viewControllerName = "DetailsVC"
            signinView.isFromSignUpPage = true
            self.isFromErrorFlow = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(signinView, animated: true)
        })
        alert.addAction(messageAlertAction)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        alert.addAction(cancelAlertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func backToDetailPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectedRollerPosterItem(item: Card){
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        //        self.detailsTableView.reloadData()
        //        self.detailsTableView.isHidden = true
        //        self.movieBGImageView.isHidden = true
        //        self.navigationView.isHidden = true
       
        self.startAnimating(allowInteraction: false)
        if item.template.count > 0{
            PartialRenderingView.instance.reloadFor(card: item, content: nil, partialRenderingViewDelegate: self)
            self.stopAnimating()
            return;
        }
        
        TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
            self.stopAnimating()
            self.detailsTableView.isHidden = false
            if self.contentType != "network" {
                self.movieBGImageView.isHidden = false
            }
            if appContants.appName != .gac {
                self.navigationView?.isHidden = false
                
            }
            if let vc = viewController as? DetailsViewController{
                if playerVC != nil{
                    playerVC?.removeViews()
                    playerVC = nil
                }
                vc.navigationTitlteTxt = item.display.title
                vc.isCircularPoster = item.cardType == .circle_poster ? true : false
                self.contentDetailResponse = vc.contentDetailResponse
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
                self.detailsTableView.setContentOffset(CGPoint.zero, animated: false)
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = item.display.imageUrl
                vc.playingItemTitle = item.display.title
                vc.playingItemSubTitle = item.display.subtitle1
                vc.playingItemTargetPath = item.target.path
                vc.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
               
                AppDelegate.getDelegate().window?.addSubview(vc.view)
                return
            }
            else{
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    func bannerSelected(item: Banner) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.detailsTableView.isHidden = true
        self.movieBGImageView.isHidden = true
        if appContants.appName != .gac {
        self.navigationView.isHidden = true
        }
        if item.isInternal {
            if (item.target.path == "packages") {
                let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
                self.showAlert(message: alertMessage)
            }
            else{
                self.startAnimating(allowInteraction: false)
                TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
                    self.stopAnimating()
                    self.detailsTableView.isHidden = false
                    self.movieBGImageView.isHidden = false
                    if appContants.appName != .gac {
                    self.navigationView.isHidden = true
                    }
                    if let vc = viewController as? DetailsViewController{
                        vc.navigationTitlteTxt = item.title
                        self.contentDetailResponse = vc.contentDetailResponse
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(vc, animated: true)
                        self.detailsTableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    else if let vc = viewController as? PlayerViewController{
                        vc.delegate = self
                        vc.defaultPlayingItemUrl = item.imageUrl
                        vc.playingItemTitle = item.title
                        vc.playingItemSubTitle = item.subtitle
                        vc.playingItemTargetPath = item.target.path
                        vc.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
                        AppDelegate.getDelegate().window?.addSubview(vc.view)
                    }
                    else{
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            if  playerVC != nil{
                playerVC?.isNavigatingToBrowser = true
                playerVC?.showHidePlayerView(true)
                playerVC?.player.pause()
            }
            view1.urlString = item.target.path
            view1.pageString = item.title
            view1.viewControllerName = "DetailsViewController"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
    }
    func selectedCast(castModel: CastCrewModel) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if !(castModel.code .isEmpty) {
            self.startAnimating(allowInteraction: false)
            TargetPage.getTargetPageObject(path: castModel.code) { (viewController, pageType) in
                self.stopAnimating()
                if let vc = viewController as? DetailsViewController{
                    self.castCrewArray.removeAll()
                    self.sectionDetailsObjArr.removeAll()
                    self.contentDetailResponse = vc.contentDetailResponse
                    self.reloadData()
                    self.detailsTableView.setContentOffset(CGPoint.zero, animated: true)
                    let deadlineTime = DispatchTime.now() + .seconds(1)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        //self.scrollViewAlpha = 0.0
                        //self.navigationView.backgroundColor = UIColor.clear
                    }
                }
                else if let vc = viewController as? PlayerViewController{
                    vc.delegate = self
                    vc.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
                    AppDelegate.getDelegate().window?.addSubview(vc.view)
                }
                else if (viewController is DefaultViewController){
                    let defaultViewController = viewController as! DefaultViewController
                    defaultViewController.delegate = self
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
                else{
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func removeViewIfAlreadyExistsIn(_ view:UIView, withSubView:Any) {
        for subView in view.subviews {
            if subView is UILabel {
                let label = subView as? UILabel
                let withLabel = withSubView as? UILabel
                if label?.tag == withLabel?.tag {
                    label?.removeFromSuperview()
                    break
                }
            }
            else if subView is UIButton {
                let button = subView as? UIButton
                let withButton = withSubView as? UIButton
                if button?.tag == withButton?.tag {
                    button?.removeFromSuperview()
                    break
                }
            }
            else if subView is UIImageView {
                let imageView = subView as? UIImageView
                let withImgView = withSubView as? UIImageView
                if imageView?.tag == withImgView?.tag {
                    imageView?.removeFromSuperview()
                    break
                }
            }
            else {
                let withImgView = withSubView as? UIView
                if subView.tag == withImgView?.tag {
                    subView.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    @IBAction func recordBtnClicked(_ sender: Any) {
        
        if self.recordBtn.tag == 1 {
            let vc = ProgramRecordConfirmationPopUp()
            vc.delegate = self
            if appContants.appName != .gac {
            vc.titleStr = self.navigationTitleLbl.text!
            }
            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
            })
        }
        else if self.recordBtn.tag == 2 {
            let vc = ProgramStopRecordConfirmationPopUp()
            vc.delegate = self
            if appContants.appName != .gac {
            vc.titleStr = self.navigationTitleLbl.text!
            }
            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
            })
        }
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        //self.BackAction(UIButton())
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
    }
    
    // MARK: - Chrome Cast Device Scanner Delegates -
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            self._miniMediaControlsHeightConstraint.constant = miniMediaControlsViewController.minHeight
            self.view.bringSubviewToFront(_miniMediaControlsContainerView)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if productType.iPad {
            if currentOrientation().landscape {
                self.contentCellHeight = 550
            }
            else {
                self.contentCellHeight = 630
            }
        }
        else {
            self.contentCellHeight = 430
        }
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.detailsTableView.reloadData()
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func showScrollIndicator()
    {
        if showTime <= self.noOfTimesIndicator {
            if self.detailCell is MovieDetailsCell {
                let cell = self.detailCell as! MovieDetailsCell
                cell.movieDiscriptionLabel.flashScrollIndicators()
            }
            else if self.detailCell is DetailsCell {
                let cell = self.detailCell as! DetailsCell
                cell.movieDiscriptionLabel.flashScrollIndicators()
            }
            showTime = showTime + 1
        }
        else {
            showTime = 1
            self.myTimer?.invalidate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().detailsTabMenuIndex = 0
        AppDelegate.getDelegate().isDetailsPage = false
        AppDelegate.getDelegate().sourceScreen = "Details_Page"
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    func programRecordSelected(item: Card) {
        let vc = ProgramRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = item
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }
    
    // MARK: - Program Record protocol methods
    func programRecordConfirmClicked(programObj:Card?, selectedPrefButtonIndex:Int, sectionIndex:Int, rowIndex:Int) {
        self.startAnimating(allowInteraction: true)
        
        //        OTTSdk.mediaCatalogManager.startStopRecord(content_type: "3", content_id: "\(self.channelID)", action: "1", onSuccess: { (response) in
        //            self.stopAnimating()
        //            self.recordBtn.setTitle("Stop REC", for: .normal)
        //            self.recordBtn.backgroundColor = UIColor.init(hexString: "6f6f6f")
        //            self.recordBtn.tag = 2
        //            self.recordButtonWidthConstraint.constant = 100
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
        //
        //
        //            if self.targetPath.count > 0{
        //                let tempVal1 = AppDelegate.getDelegate().recordingCardsArr.index(of: self.targetPath)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingCardsArr.append(self.targetPath)
        //                } else {
        //                    AppDelegate.getDelegate().recordingCardsArr.remove(at: tempVal1!)
        //                }
        //                let tempVal2 = AppDelegate.getDelegate().recordingSeriesArr.index(of: self.targetPath)
        //
        //                if tempVal2 == nil {
        //                    AppDelegate.getDelegate().recordingSeriesArr.append(self.targetPath)
        //                } else {
        //                    AppDelegate.getDelegate().recordingSeriesArr.remove(at: tempVal2!)
        //                }
        //                NotificationCenter.default.post(name: Notification.Name("detailPageRecordButtonStatusChanged"), object: nil, userInfo: ["targetPath": self.targetPath])
        //
        //            }
        //            AppDelegate.getDelegate().isListPageReloadRequired = true
        //            AppDelegate.getDelegate().isContentPageHomeReloadRequired = true
        //            AppDelegate.getDelegate().isContentPageLiveReloadRequired = true
        //
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
        self.startAnimating(allowInteraction: true)
        
        //        OTTSdk.mediaCatalogManager.startStopRecord(content_type: "3", content_id: "\(self.channelID)", action: "0", onSuccess: { (response) in
        //            self.stopAnimating()
        //            self.recordBtn.setTitle("REC", for: .normal)
        //            self.recordBtn.backgroundColor = UIColor.init(hexString: "e00d0d")
        //            self.recordBtn.tag = 1
        //            self.recordButtonWidthConstraint.constant = 70
        //            if self.popupViewController != nil {
        //                self.dismissPopupViewController(.bottomBottom)
        //            }
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
        //
        //            AppDelegate.getDelegate().isListPageReloadRequired = true
        //            AppDelegate.getDelegate().isContentPageHomeReloadRequired = true
        //            AppDelegate.getDelegate().isContentPageLiveReloadRequired = true
        //
        //            if self.targetPath.count > 0{
        //                let tempVal1 = AppDelegate.getDelegate().recordingCardsArr.index(of: self.targetPath)
        //
        //                if tempVal1 == nil {
        //                    AppDelegate.getDelegate().recordingCardsArr.append(self.targetPath)
        //                } else {
        //                    AppDelegate.getDelegate().recordingCardsArr.remove(at: tempVal1!)
        //                }
        //                let tempVal2 = AppDelegate.getDelegate().recordingSeriesArr.index(of: self.targetPath)
        //
        //                if tempVal2 == nil {
        //                    AppDelegate.getDelegate().recordingSeriesArr.append(self.targetPath)
        //                } else {
        //                    AppDelegate.getDelegate().recordingSeriesArr.remove(at: tempVal2!)
        //                }
        //                NotificationCenter.default.post(name: Notification.Name("detailPageRecordButtonStatusChanged"), object: nil, userInfo: ["targetPath": self.targetPath])
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
    
    // MARK: - DefaultViewControllerDelegate
    func retryTap(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GobackFromErrorPage"), object: nil)
    }
    
    //MARK: - PlayerSuggestionsViewControllerDelegate
    func didSelectedSuggestion(card: Card) {
        self.detailsTableView.setContentOffset(CGPoint.zero, animated: false)
        selectedRollerPosterItem(item: card)
    }
    
    // MARK: - Partial Rendering protocol methods
    func record(confirm: Bool, content: Any?) {
        if confirm {
            
        }
    }
    
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        if card != nil && templateElement != nil{
            self.goToPage(card!, path: templateElement!.target)
        }
    }
    
    fileprivate func goToPage(_ item: Card, path : String) {
        TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
            self.stopAnimating()
            self.detailsTableView.isHidden = false
            if self.contentType != "network" {
                self.movieBGImageView.isHidden = false
            }
            if appContants.appName != .gac {
            self.navigationView.isHidden = true
            }
            if let vc = viewController as? DetailsViewController{
                if playerVC != nil{
                    playerVC?.removeViews()
                    playerVC = nil
                }
                vc.navigationTitlteTxt = item.display.title
                vc.isCircularPoster = item.cardType == .circle_poster ? true : false
                self.contentDetailResponse = vc.contentDetailResponse
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
                self.detailsTableView.setContentOffset(CGPoint.zero, animated: false)
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = item.display.imageUrl
                vc.playingItemTitle = item.display.title
                vc.playingItemSubTitle = item.display.subtitle1
                vc.playingItemTargetPath = item.target.path
                vc.showWatchPartyMenu = self.showWatchPartyMenuInPlayer
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else{
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    //MARK:- banner ad
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
    //MARK :- banner ads delegate methods
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.hideBannerAd()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.adBannerViewHeightConstraint.constant = 50.0
        self.collectionViewbottomConstarint?.constant = 5.0
        self.updateDocPlayerFrame()
    }
    
    
}
        
extension DetailsViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsArray.count
    }
    

    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsPageHeaderButtonsCell", for: indexPath) as! detailsPageHeaderButtonsCell
        cell.backgroundColor = AppTheme.instance.currentTheme.themeColor
        cell.titleLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        cell.titleLabel.text = self.buttonsArray[indexPath.item].titleString
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.buttonsArray[indexPath.item].answerHeight + 5
        return CGSize(width: width, height: 35)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { 
        
        self.navigateToPlayerFromHeaderMenu(buttonElement: self.buttonsElementArray[indexPath.row])
    }
     
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let elements_count = self.buttonsArray.count
        
        let cellCount = CGFloat(elements_count)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            //2.00 was just extra spacing I wanted to add to my cell.
            var totalCellWidth:CGFloat = 0.0// = cellWidth*cellCount + 2.00 * (cellCount-1)
            for itemCell in self.buttonsArray {
                totalCellWidth += itemCell.answerHeight
            }
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 2)
            }
        }
        if buttonsArray.count > 0 || buttonsArray.count > 0{
            // Tab s
            return secInsets
        }
        return UIEdgeInsets.zero
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.clear.cgColor
        let colorBottom = AppTheme.instance.currentTheme.applicationBGColor.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: self.view.frame.width/2, width: self.view.frame.width, height: self.view.frame.width/2)
        self.movieBGImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
