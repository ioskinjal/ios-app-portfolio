//
//  MoviesVC.swift
//  sampleColView
//
//  Created by Ankoos on 30/05/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast
import GoogleMobileAds

class ListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PlayerViewControllerDelegate,FilterSelectionProtocol,BannerCVCProtocal,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol, PartialRenderingViewDelegate,GADBannerViewDelegate,GADUnifiedNativeAdLoaderDelegate {
    
    @IBOutlet weak var collectionViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var navigationBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var filterCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var noContentLbl: UILabel!
    @IBOutlet weak var noFavoritesImageView: UIImageView?
    @IBOutlet weak var noFavoritesTitleLabel: UILabel?
    @IBOutlet weak var noFavoritesSubTitleLabel: UILabel?
    
    
    @IBOutlet weak var favoriteBackGroundView:UIView?
    @IBOutlet weak var favoriteLabel:UILabel?
    @IBOutlet weak var selectAllButton:UIButton?
    @IBOutlet weak var selectAllButtonHeightConstraint:NSLayoutConstraint?
    @IBOutlet weak var favoriteBackGroundViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deleteFavoriteButton:UIButton?
    @IBOutlet weak var deleteFavoriteButtonHeightConstraint:NSLayoutConstraint?
    @IBOutlet weak var deleteFavoriteButtonBottomConstraint:NSLayoutConstraint?
    
    var deleteFavotiteItemslist = [String]()
    
    var goGetTheData:Bool = true
    var noContentFlag:Bool = false
    var sections = [Card]()
    var section:Section?
    var pageFilters = [Filter]()
    var isToViewMore = false
    var sectionTitle = ""
    var bannerData = [Banner]()
    var lastIndex = -1
    var secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    var numColums: CGFloat = (productType.iPad ? 2 : 1)
    var interItemSpacing: CGFloat = (productType.iPad ? 20 : 10)
    var cellSizes: CGSize = CGSize(width: 120, height: (productType.iPad ? 93  : 73))
    var minLineSpacing: CGFloat = (productType.iPad ? 20 : 13)
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var cCFL: CustomFlowLayout!
    var pageResponse : PageContentResponse!
    var targetPath = ""
    var filterDic = [String : Any]()
    var filterCFL: CustomFlowLayout!
    let filterSecInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 5.0)
    var filterCellSizes: CGSize = CGSize(width: 120, height: 27)
    var filterNumColums: CGFloat = 2
    let filterInterItemSpacing: CGFloat = 0
    let filterMinLineSpacing: CGFloat = 10
    let filterScrollDir: UICollectionView.ScrollDirection = .horizontal
    var currentWatchedTimeArr = NSMutableArray()
    @IBOutlet weak var chromeButtonView: UIView!
    
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    
    var favoritesStr:String = ""
    
    /// The number of native ads to load (must be less than 5).
    var numAdsToLoad = 5
    var adInterval = 5
    /// The native ads.
    var nativeAds = [GADUnifiedNativeAd]()
    /// The ad loader that loads the native ads.
    var adLoader: GADAdLoader!
    
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var myDownloadview: UIView!
    @IBOutlet weak var myDownloadButton: UIButton!
    @IBOutlet weak var mydownloadSelectedCountLable: UILabel!
    @IBOutlet weak var mySelectAllCheckmarkImageView: UIImageView!
    @IBOutlet weak var myDownloadSelectAllLabel: UILabel!
    @IBOutlet weak var myDownloadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myDownloadButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectAllDownloadImageView : UIImageView!
    @IBOutlet weak var bannerAdView: UIView!
    var interstitial: GADInterstitial!
    var isMyDownloadsSection = false
    var downloadStreamsArr = [Stream]()
    fileprivate var selectedObjectsForDelete = [Stream]()
    var asset:Asset?
    var enteredOnce:Bool = false
    fileprivate var selectAllDownloads = false
    @IBAction func Refresh(_ sender: Any) {
        /**/
        if self.isMyDownloadsSection {
            if #available(iOS 11.0, *) {
                AppDelegate.getDelegate().deleteContentAfterExpiryTimeReached()
            }
            self.setResponseData()
            self.refreshControl.endRefreshing()
            return
        }
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.lastIndex = -1
        self.recordingCardsArr.removeAll()
        AppDelegate.getDelegate().recordingCardsArr.removeAll()
        self.recordingSeriesArr.removeAll()
        AppDelegate.getDelegate().recordingSeriesArr.removeAll()
        if self.filterDic.count > 0 {
            var filterString = ""
            for (key, value) in self.filterDic {
                let filterCodeList = value as! NSMutableArray
                if filterCodeList.count > 0 {
                    filterString = filterString + (filterString.count > 0 ? ";" : "") + key + ":"
                    for filterCode in filterCodeList {
                        if filterCodeList.lastObject as! String == filterCode as! String {
                            filterString = "\(filterString)\(filterCode)"
                        }
                        else {
                            filterString = "\(filterString)\(filterCode),"
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                self.startAnimating(allowInteraction: false)
                OTTSdk.mediaCatalogManager.sectionContent(path: self.pageResponse.info.path, code: (self.section?.sectionInfo.code)!, offset: self.lastIndex, count: nil, filter: filterString, onSuccess: { (response) in
                    self.sections.removeAll()
                    
                    if response.count > 0 {
                        if let cardsResponse = response.first{
                            self.lastIndex =  cardsResponse.lastIndex
                            if cardsResponse.data.count > 0{
                                self.goGetTheData = true
                                self.sections.append(contentsOf: cardsResponse.data)
                                self.moviesCollection.reloadData()
                                self.filtersCollectionView.reloadData()
                            }
                        }
                        
                        if self.sections.count > 0 {
                            self.showHideErrorView(true)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                                self.moviesCollection.reloadData()
                                self.moviesCollection.isHidden = false
                            }
                        }
                        else {
                            self.showHideErrorView(false)
                            self.moviesCollection.isHidden = true
                        }
                    }
                    else {
                        self.showHideErrorView(false)
                        self.moviesCollection.isHidden = true
                    }
                    self.refreshControl.endRefreshing()
                    self.stopAnimating()
                }) { (error) in
                    self.refreshControl.endRefreshing()
                    self.stopAnimating()
                }
            }
        }
        else {
            self.startAnimating(allowInteraction: false)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                OTTSdk.mediaCatalogManager.pageContent(path: self.targetPath, onSuccess: { (response) in
                    self.pageResponse = response
                    self.sections.removeAll()
                    self.bannerData.removeAll()
                    if self.nativeAds.count > 0 {
                        self.nativeAds.removeAll()
                    }
                    self.stopAnimating()
                    
                    self.setResponseData()
                    self.refreshControl.endRefreshing()
                    self.moviesCollection.reloadData()
                }) { (error) in
                    self.stopAnimating()
                    self.refreshControl.endRefreshing()
                    print(error.message)
                }
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        if TabsViewController.shouldHideSearchButton == true {
            self.searchButton.isHidden = true
            self.searchButtonWidthConstraint.constant = 0
        }
        else{
            self.searchButton.isHidden = false
            self.searchButtonWidthConstraint.constant = 52
        }
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
        moviesCollection.reloadData()
        
        if AppDelegate.getDelegate().isListPageReloadRequired == true{
            AppDelegate.getDelegate().isListPageReloadRequired = false
            self.Refresh(UIButton.init())
        }
        if playerVC == nil {
            UIApplication.shared.showSB()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.filterDic)
        if self.sections.count > 0 {
            self.startAnimating(allowInteraction: true)
            moviesCollection.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                self.moviesCollection.reloadData()
                self.moviesCollection.isHidden = false
                self.stopAnimating()
            }
            self.showHideErrorView(true)
        }
        else {
            if self.bannerData.count > 0 {
                // self.moviesCollection.reloadSections(IndexSet.init(integer: 0))
                self.showHideErrorView(true)
            }
            else {
                self.showHideErrorView(false)
            }
        }
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            ccHeight = miniMediaControlsViewController.minHeight
        }
        if self.targetPath == self.favoritesStr {
            AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
        }
        else{
            AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
        }
        if isMyDownloadsSection {
            Refresh(self)
        }
    }
    @IBAction private func selectAllDownloadAction(_ sender : Any) {
        if selectAllDownloads {
            selectAllDownloads = false
            selectedObjectsForDelete.removeAll()
            selectAllDownloadImageView.image = #imageLiteral(resourceName: "ic_mydownload_not_selected")
        }else {
//            if let objects = downloadStreamsArr.filter({$0.video_download == true}) as? [Stream], objects.count != downloadStreamsArr.count {
//                self.errorAlert(forTitle: String.getAppName(), message: "Please wait untill the donwload(s) complete", needAction: false) { _ in }
//                return
//            }
            selectAllDownloads = true
            selectAllDownloadImageView.image = #imageLiteral(resourceName: "ic_mydownload_selected")
            selectedObjectsForDelete = downloadStreamsArr//.filter({$0.video_download == true})
        }
        mydownloadSelectedCountLable.text = "\(selectedObjectsForDelete.count)/\(downloadStreamsArr.count) Selected"
        if selectedObjectsForDelete.count > 0 {
            myDownloadButton.isUserInteractionEnabled = true
            myDownloadButton.isEnabled = true
        }else {
            myDownloadButton.isUserInteractionEnabled = false
            myDownloadButton.isEnabled = false
        }
        moviesCollection.reloadData()
    }
    @IBAction func deleteSelectedObjectsAction(_ sender : Any) {
        if let stream = AppDelegate.getDelegate().selectedContentStream, selectedObjectsForDelete.firstIndex(where: {$0.targetPath == stream.targetPath}) != nil {
            self.showAlert(message: "Cannot delete the content as it currenlty playing")
        } else {
            delteOfflineData()
        }
    }
    private func delteOfflineData() {
        let alert = UIAlertController(title: "Confirm".localized, message: "Do you want to delete selected content from My Downloads?", preferredStyle: UIAlertController.Style.alert)
        let resumeAlertAction = UIAlertAction(title: "No".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        let startOverAlertAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if #available(iOS 11.0, *) {
                for stream in self.selectedObjectsForDelete {
                    let asset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: URL.init(string: stream.playlistURL)!))
                    self.sendDeleteDownloadRequest(asset, stream)
                }
            } else {
                // Fallback on earlier versions
            }
        })
        alert.addAction(resumeAlertAction)
        alert.addAction(startOverAlertAction)
        //        alert.view.tintColor = UIColor.redColor()
        self.present(alert, animated: true, completion: nil)
    }
    func showHideErrorView(_ showHideVal:Bool = true) {
        if isMyDownloadsSection {
            return
        }
        self.noContentLbl.isHidden = true
        self.noFavoritesImageView?.isHidden = true
        self.noFavoritesTitleLabel?.isHidden = true
        self.noFavoritesSubTitleLabel?.isHidden = true
        self.errorView.isHidden = showHideVal
        if showHideVal == false {
            if self.targetPath == self.favoritesStr {
                self.noFavoritesImageView?.isHidden = false
                self.noFavoritesTitleLabel?.isHidden = false
                self.noFavoritesSubTitleLabel?.isHidden = false
            }
            else{
                if self.sectionTitle == "Purchased Items" || self.sectionTitle == "Purchased Movies" {
                    self.noContentLbl.text = "There are no purchased items"
                    self.errorView.isHidden = false
                    self.noContentLbl.isHidden = false
                }
                else {
                    self.noContentLbl.text = "No Content available".localized
                }
            }
        }
    }
    func setResponseData() {
        if self.isMyDownloadsSection {
            if #available(iOS 11.0, *) {
                self.downloadStreamsArr = AppDelegate.getDelegate().fetchStreamList()
                var paths = [String]()
                for streamObj in self.downloadStreamsArr {
                    paths.append(streamObj.targetPath)
                }
                if Utilities.hasConnectivity(), paths.count > 0 {
                    self.checkWithServerForDownloadedContentAvailability(paths)
                }else if Utilities.hasConnectivity() == false {
                }
                if self.downloadStreamsArr.count == 0 {
                    self.errorView.isHidden  = false
                    myDownloadview.isHidden = true
                    myDownloadButton.isHidden = true
                    deleteFavoriteButton?.isHidden = false
                    deleteFavoriteButtonHeightConstraint?.constant = 40.0
                    myDownloadButtonWidthConstraint.constant = 0.0
                    myDownloadViewHeightConstraint.constant = 0.0
                    mydownloadSelectedCountLable.text = ""
                    deleteFavoriteButton?.setButtonBackgroundcolor()
                    deleteFavoriteButton?.setTitle("Find Content To Download", for: .normal)
                    deleteFavoriteButton?.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
                } else {
                    deleteFavoriteButton?.isHidden = true
                    myDownloadview.isHidden = false
                    myDownloadButton.isHidden = false
                    myDownloadButtonWidthConstraint.constant = 46.0
                    myDownloadViewHeightConstraint.constant = 48.0
                    self.errorView.isHidden = true
                    mydownloadSelectedCountLable.text = "\(selectedObjectsForDelete.count)/\(downloadStreamsArr.count) Selected"
                }
                self.moviesCollection.reloadData()
                self.stopAnimating()
            } else {
                self.errorView.isHidden = true
            }
            return
        }
        if pageResponse == nil {
            return
        }
        if pageResponse.data.count == 0{
            return
        }
        guard let _section = pageResponse.data[0].paneData as? Section else{
            return
        }
        if pageResponse.banners != nil {
            self.bannerData = pageResponse.banners
        }
        sections = _section.sectionData.data
        sectionTitle = _section.sectionInfo.name
        self.lastIndex = _section.sectionData.lastIndex
        self.section = _section
        if sectionTitle == "Continue Watching" {
            self.getContinueWatchingList()
        }
        else if sectionTitle == "Recently Watched" {
            self.getRecentlyWatchedList()
        }
        if sections.count > 0 {
            self.showHideErrorView(true)
            if self.targetPath == self.favoritesStr {
                self.selectAllButtonHeightConstraint?.constant = 40
                selectAllButton?.isHidden = false
                if playerVC != nil {
                    var isItemFound = false
                    for cardItem in sections {
                        if cardItem.target.path == playerVC?.pageDataResponse?.info.path {
                            isItemFound = true
                            break;
                        }
                    }
                    if isItemFound == true {
                        playerVC?.isFavourite = true
                        if playerVC?.favInPlayer != nil {
                            playerVC?.favInPlayer.setImage( UIImage.init(named: "img_remove_watchlist_circle_player"), for:UIControl.State.normal)
                        }
                    }
                    else if isItemFound == false {
                        playerVC?.isFavourite = false
                        if playerVC?.favInPlayer != nil {
                            playerVC?.favInPlayer.setImage( UIImage.init(named: "img_watchlist_circle_player"), for:UIControl.State.normal)
                        }
                    }
                    self.checkDeleteButtonStatus()
                }
            }
        }
        else {
            if self.bannerData.count > 0 {
                self.showHideErrorView(true)
                if self.targetPath == self.favoritesStr {
                    self.selectAllButtonHeightConstraint?.constant = 40
                    selectAllButton?.isHidden = false
                }
            }
            else {
                self.showHideErrorView(false)
                if self.targetPath == self.favoritesStr {
                    self.selectAllButtonHeightConstraint?.constant = 0
                    selectAllButton?.isHidden = true
                }
            }
        }
        self.displayNativeAds()
        
    }
    func deleteFromLocalDB(_ asset:Asset, _ stream:Stream) {
        if #available(iOS 11.0, *) {
            AssetPersistenceManager.sharedManager.deleteAsset(asset)
            AppDelegate.getDelegate().deleteStream(stream)
            self.downloadStreamsArr.removeAll()
            self.selectedObjectsForDelete = self.selectedObjectsForDelete.filter({$0.targetPath != stream.targetPath})
            self.selectAllDownloads = false
            mydownloadSelectedCountLable.text = "\(selectedObjectsForDelete.count)/\(downloadStreamsArr.count) Selected"
            self.moviesCollection.reloadData()
            self.downloadStreamsArr.append(contentsOf: AppDelegate.getDelegate().fetchStreamList())
            self.moviesCollection.reloadData()
            //if self.downloadStreamsArr.count == 0 {
                self.setResponseData()
            //}
            var userInfo = [String: Any]()
            userInfo[Asset.Keys.name] = asset.stream.name
            userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
            userInfo[Asset.Keys.downloadSelectionDisplayName] = displayNamesForSelectedMediaOptions(asset.urlAsset.preferredMediaSelection)

            NotificationCenter.default.post(name: .AssetDownloadStateChanged, object: nil, userInfo: userInfo)
            self.stopAnimating()
        }
    }
    func checkWithServerForDownloadedContentAvailability(_ paths:[String]) {
        /*self.startAnimating(allowInteraction: true)
        OTTSdk.mediaCatalogManager.deleteDownloadVideoRequest(paths: paths, onSuccess: { (message) in
            if #available(iOS 11.0, *) {
                let streams = AppDelegate.getDelegate().fetchStreamList()
                for path in message {
                    let predicate = NSPredicate(format: "targetPath == %@", path)
                    let filteredarr = streams.filter { predicate.evaluate(with: $0) };
                    if filteredarr.count > 0 {
                        let streamObj = filteredarr[0]
                        let asset = Asset.init(stream: streamObj, urlAsset: AVURLAsset.init(url: URL.init(string: streamObj.playlistURL)!))
                        self.deleteFromLocalDB(asset, streamObj)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }) { (error) in
            self.stopAnimating()
        }*/
    }
    func displayNativeAds(){
        if AppDelegate.getDelegate().showNativeAds {
            let tempBannerUnitId = AppDelegate.getDelegate().defaultNativeAdTag
            numAdsToLoad = 5
            adInterval = 2
            self.loadAddRequest(tempBannerUnitId)
        }
        /*if AppDelegate.getDelegate().showNativeAds {
         if self.pageResponse.adUrlResponse.adUrlTypes.count > 0{
         var tempBannerUnitId = ""
         for b in self.pageResponse.adUrlResponse.adUrlTypes{
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
                    continueWatchingList = continueList as? NSMutableArray
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
            
            var localCardsList = [Card]()
            if sections.count == 0 {
                sections = itemsObjList
            }
            else {
                for cardObj in itemsObjList {
                    let index = self.checkIsContentAvailableInServer(cardObj, serverContentList: sections)
                    if index != -1 {
                        sections.remove(at: index)
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
                sections.insert(contentsOf: localCardsList, at: 0)
            }
        }
    }
    
    func getDataFromUserDefaults() -> [String:Any] {
        return [String:Any]();
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
            
            var localCardsList = [Card]()
            
            if sections.count == 0 {
                sections = itemsObjList
            }
            else {
                for cardObj in itemsObjList {
                    let index = self.checkIsContentAvailableInServer(cardObj, serverContentList: sections)
                    if index != -1 {
                        sections.remove(at: index)
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
                sections.insert(contentsOf: localCardsList, at: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = AppDelegate.getDelegate()
        myDownloadview.isHidden = true
        myDownloadButton.isHidden = true
        myDownloadButtonWidthConstraint.constant = 0.0
        myDownloadViewHeightConstraint.constant = 0.0
        
        appDelegate.shouldRotate = (productType.iPad ? true : false)
        self.sectionLabel.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        self.favoriteLabel?.text = ""
        self.noFavoritesTitleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.noFavoritesSubTitleLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.noFavoritesTitleLabel?.font = UIFont.ottSemiBoldFont(withSize: 18)
        self.noFavoritesSubTitleLabel?.font = UIFont.ottRegularFont(withSize:15)
        self.noFavoritesTitleLabel?.text = "Looks like you don’t have any Watchlist yet!"
        self.noFavoritesSubTitleLabel?.text = "Your Watchlist content will be listed here."
        selectAllButton?.isHidden = false
        selectAllButtonHeightConstraint?.constant = 40
        selectAllButton?.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        if #available(iOS 10.0, *) {
            AssetPlaybackManager.sharedManager.delegate = self
        }
        if #available(iOS 11.0, *) {
            AssetPersistenceManager.sharedManager.restorePersistenceManager()
        }
        self.noContentLbl.isHidden = true
        if (appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .reeldrama), isMyDownloadsSection {
//            self.noFavoritesTitleLabel?.text = "No Content available".localized
//            self.noFavoritesSubTitleLabel?.text = "Please try again later".localized
            self.noFavoritesTitleLabel?.text = "Content that you download will appear here".localized
            self.noFavoritesSubTitleLabel?.text = "".localized
            self.noFavoritesTitleLabel?.font = UIFont.ottMediumFont(withSize: 16)
            selectAllButtonHeightConstraint?.constant = 0
            selectAllButton?.isHidden = true
            noFavoritesImageView?.image = #imageLiteral(resourceName: "ic_mydownloads").withRenderingMode(.alwaysTemplate)
            noFavoritesImageView?.tintColor = AppTheme.instance.currentTheme.cardTitleColor
            myDownloadButton.isUserInteractionEnabled = false
            myDownloadButton.isEnabled = false
            myDownloadSelectAllLabel.text = "Select All"
            myDownloadSelectAllLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
            myDownloadSelectAllLabel.font = UIFont.ottRegularFont(withSize: 16.0)
            mydownloadSelectedCountLable.text = ""
            mydownloadSelectedCountLable.textColor = AppTheme.instance.currentTheme.cardTitleColor
            mydownloadSelectedCountLable.font = UIFont.ottRegularFont(withSize: 16.0)
        }
        
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if appContants.appName == .gac {
            self.filtersCollectionView.backgroundColor = AppTheme.instance.currentTheme.themeColor
        }
        else {
            self.filtersCollectionView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }
        self.navigationBarView.cornerDesign()
        self.collectionViewRightConstraint.constant = 5.0
        self.collectionViewLeftConstraint.constant = 5.0
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
        
        if self.targetPath == AppDelegate.getDelegate().favouritesTargetPath, !isMyDownloadsSection  {
            if TabsViewController.isWatchListFromMenu {
                self.backButton.isHidden = true
            }
            else {
                self.backButton.isHidden = false
            }
            self.sectionLabel.text = "Watchlist".localized
            self.sectionLabel.textAlignment = .center
            self.favoritesStr = self.targetPath
            favoriteBackGroundViewHeightConstraint?.constant = 40
            deleteFavoriteButtonHeightConstraint?.constant = 0
            deleteFavoriteButton?.isHidden = true
            if !isMyDownloadsSection {
                selectAllButton?.isHidden = false
                selectAllButtonHeightConstraint?.constant = 40
            }
            deleteFavoriteButton?.setButtonBackgroundcolor()
            deleteFavoriteButton?.setTitle("Remove from Watchlist", for: .normal)
            deleteFavoriteButton?.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        }
        else{
            self.sectionLabel.textAlignment = .left
            self.backButton.isHidden = false
            self.favoritesStr = ""
            selectAllButtonHeightConstraint?.constant = 0
            selectAllButton?.isHidden = true
            favoriteBackGroundViewHeightConstraint?.constant = 0
            deleteFavoriteButtonHeightConstraint?.constant = 0
            deleteFavoriteButton?.isHidden = true
        }
        if targetPath == AppDelegate.getDelegate().favouritesTargetPath && OTTSdk.preferenceManager.user == nil && appContants.appName == .firstshows {
            self.noContentLbl.isHidden = true
        }
        else {
            #warning("Hide sign in signup view")
            //        self.view.backgroundColor = UIColor.appBackgroundColor
            self.noContentLbl.text = "No Content available".localized
            self.noContentLbl.textColor = AppTheme.instance.currentTheme.noContentAvailableTitleColor
            
            if self.targetPath == self.favoritesStr || self.targetPath == "mylibrary"{
                self.noContentLbl.text = "No Content Found".localized
                self.noContentLbl.textColor = UIColor.init(hexString:"37393c")
                self.noContentLbl.font = UIFont.ottBoldFont(withSize: 20.0)
            }
            self.setResponseData()
        }
        if isToViewMore {
            self.sectionLabel.text = sectionTitle
            self.filterCollectionViewHeightConstraint.constant = 0
            self.navigationBarView.isHidden = false
            if pageResponse != nil, !isMyDownloadsSection {
                self.pageFilters = pageResponse.filters
                if self.pageFilters.count > 0 {
                    if appContants.appName == .gac {
                        self.filterCollectionViewHeightConstraint.constant = 35
                    }else {
                        self.filterCollectionViewHeightConstraint.constant = 60
                    }
                    self.filtersCollectionView.isHidden = false
                }
            }
        }
        else {
            self.filterCollectionViewHeightConstraint.constant = 0
            if appContants.appName == .reeldrama || appContants.appName == .firstshows || appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gac || appContants.appName == .mobitel || appContants.appName == .pbns || appContants.appName == .airtelSL {
                self.navigationBarViewHeightConstraint.constant = 0
            }
            else {
                self.navigationBarViewHeightConstraint.constant = 50
                self.navigationBarView.isHidden = false
            }
            if !self.isMyDownloadsSection {
                self.pageFilters = pageResponse.filters
                if self.pageFilters.count > 0 {
                    if appContants.appName == .gac {
                        self.filterCollectionViewHeightConstraint.constant = 35
                    }else {
                        self.filterCollectionViewHeightConstraint.constant = 60
                    }
                    self.filtersCollectionView.isHidden = false
                }
            }
        }
        refreshControl.tintColor = UIColor.activityIndicatorColor()
        refreshControl.addTarget(self, action: #selector(Refresh(_:)), for: .valueChanged)
        moviesCollection.addSubview(refreshControl)
        
        
        moviesCollection.register(UINib(nibName: RollerPosterGV.nibname, bundle: nil), forCellWithReuseIdentifier: RollerPosterGV.identifier)
        if pageResponse != nil {
            let section = (self.pageResponse.data.first)!.paneData as! Section
            if section.sectionData.data.count > 0 && section.sectionData.data[0].cardType == .network_poster{
                cellSizes = CGSize(width: 120, height: (productType.iPad ? 173 : 93))
            }else {
                
            }
        }
        cCFL = CustomFlowLayout()
        cCFL.interItemSpacing = interItemSpacing
        cCFL.secInset = secInsets
        cCFL.cellRatio = false
        cCFL.cellSize = cellSizes
        cCFL.minLineSpacing = minLineSpacing
        self.calculateNumCols()
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        moviesCollection.collectionViewLayout = cCFL
        
        self.title = "Home".localized
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        if filterCFL == nil{
            filterCFL = CustomFlowLayout()
            filterCFL.secInset = filterSecInsets
            filterCFL.cellSize = filterCellSizes
            filterCFL.interItemSpacing = filterInterItemSpacing
            filterCFL.minLineSpacing = filterMinLineSpacing
            self.calculateNumColsForFilters()
            filterCFL.numberOfColumns = filterNumColums
            filterCFL.scrollDir = filterScrollDir
            filterCFL.setupLayout()
            filtersCollectionView.collectionViewLayout = filterCFL
        }
        filtersCollectionView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: filtersCollectionView.center.y)
        
        self.filtersCollectionView.register(UINib(nibName: "filterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCollectionViewCell")
        self.filtersCollectionView.register(UINib(nibName: "filterCollectionViewCell-iPad", bundle: nil), forCellWithReuseIdentifier: "filterCollectionViewCelliPad")
        
        self.stopAnimating()
        if !isMyDownloadsSection, downloadStreamsArr.count == 0 {
            self.moviesCollection.isHidden = true
        }
        self.moviesCollection.reloadData()
        self.filtersCollectionView.reloadData()
        if productType.iPad {
            secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        } else {
            secInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
            numColums = 2
            if sections.count > 0 && ((sections.first)!.cardType == .circle_poster || (sections.first)!.cardType == .square_poster) {
                numColums = 3
            }
            interItemSpacing = 10
            minLineSpacing = 10
            if self.section?.sectionInfo.dataType == "network"{
                numColums = 3
                secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                interItemSpacing = 20
                minLineSpacing = 20
            }
        }
        
        if self.targetPath == self.favoritesStr {
            NotificationCenter.default.addObserver(self, selector: #selector(self.Refresh(_:)), name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(recordedNewContent(notification:)), name: PartialRenderingView.instance.recordNotificationName, object: nil)
        }
        if self.isMyDownloadsSection {
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(setOfflineContentEvents(_:)),
                                           name: Notification.Name(rawValue: "SetOfflineContentEvents"), object: nil)
            notificationCenter.addObserver(self, selector: #selector(handleAssetPersistenceManagerDidRestoreState(_:)),
                                           name: .AssetPersistenceManagerDidRestoreState, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        
        self.moviesCollection.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
        moviesCollection.register(UINib(nibName: "UnifiedNativeAdCell", bundle: nil), forCellWithReuseIdentifier: "UnifiedNativeAdCell")
        
        //        self.getBannerData()
        if productType.iPad  && self.section?.sectionInfo.dataType != "network", !isMyDownloadsSection {
            self.loadMoreData(filterString:nil)
        }
        if isMyDownloadsSection {
            Refresh(self)
        }
        self.loadBannerAd()
        self.updateDocPlayerFrame()

    }
    @objc
    func handleAssetPersistenceManagerDidRestoreState(_ notification: Notification) {
        DispatchQueue.main.async {
            self.downloadStreamsArr.removeAll()
            // Iterate over each dictionary in the array.
            for stream in StreamListManager.shared.streams {
                
                // To ensure that we are reusing AVURLAssets we first find out if there is one available for an already active download.
                if #available(iOS 11.0, *) {
                    if AssetPersistenceManager.sharedManager.assetForStream(withName: stream.name) != nil {
                        self.downloadStreamsArr.append(stream)
                    } else {
                        /*
                         If an existing `AVURLAsset` is not available for an active
                         download we then see if there is a file URL available to
                         create an asset from.
                         */
                        if AssetPersistenceManager.sharedManager.localAssetForStream(withName: stream.name) != nil {
                            self.downloadStreamsArr.append(stream)
                        } else {
                            let urlAsset = AVURLAsset(url: URL(string: stream.playlistURL)!)
                            
                            _ = Asset(stream: stream, urlAsset: urlAsset)
                            
                            self.downloadStreamsArr.append(stream)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
            NotificationCenter.default.post(name: .AssetListManagerDidLoad, object: self)
        }
    }
    @objc
    func setOfflineContentEvents(_ notification: NSNotification) {
        guard let offlineEventDict = notification.userInfo!["EventDict"] as? [String:Any] else { return }
//        var userEventsArr = String.getEventsForOfflineContentOfLoggedInUser
//        userEventsArr.append(offlineEventDict)
//        String.getEventsForOfflineContentOfLoggedInUser = userEventsArr
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
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is ListViewController {
            var ccHeight:CGFloat = 0.0
            if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
                ccHeight = miniMediaControlsViewController.minHeight
            }
            self.updateDocPlayerFrame()

            if self.targetPath == self.favoritesStr {
                if playerVC != nil {
                    if playerVC?.playerHeight != nil {
                        self.deleteFavoriteButtonBottomConstraint?.constant = (playerVC?.playerHeight.constant)! + 15
                    }
                    else{
                        self.deleteFavoriteButtonBottomConstraint?.constant = 85
                    }
                }
                else{
                    self.deleteFavoriteButtonBottomConstraint?.constant = 0
                }
                AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
            }
            else{
                AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
            }
        }
    }
    @objc func recordedNewContent(notification : NSNotification) {
        if self.targetPath == self.favoritesStr {
            AppDelegate.getDelegate().isListPageReloadRequired = false
            self.Refresh("")
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
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
    func calculateNumCols() {
        if self.isMyDownloadsSection {
            if productType.iPad {
                if currentOrientation().portrait {
                    numColums = 2
                } else if currentOrientation().landscape {
                    numColums = 2
                }
            }
            else{
                numColums = 1
            }
        }
        else {
             if productType.iPad {
                print("=====ori=====",UIDevice.current.orientation)
                for card in sections {
                    if card.cardType == .roller_poster {
                        if currentOrientation().portrait {
                            numColums = 5
                        } else if currentOrientation().landscape {
                            numColums = 7
                        }else {
                            numColums = 5
                        }
                    }else  if card.cardType == .overlay_poster {
                        if currentOrientation().portrait {
                            numColums = 2
                        } else if currentOrientation().landscape {
                            numColums = 2
                        }
                    }
                    else  if card.cardType == .live_poster || card.cardType == .content_poster {
                        if currentOrientation().portrait {
                            numColums = 2
                        } else if currentOrientation().landscape {
                            numColums = 3
                        }else{
                            switch UIDevice.current.orientation {
                            case .portrait, .portraitUpsideDown:
                                numColums = 2
                            case .landscapeLeft, .landscapeRight:
                                numColums = 3
                            default:
                                numColums = 2
                            }
                        }
                        
                    }
                    else  if card.cardType == .common_poster {
                        if currentOrientation().portrait {
                            numColums = 2
                        } else if currentOrientation().landscape {
                            numColums = 3
                        }else{
                            switch UIDevice.current.orientation {
                            case .portrait, .portraitUpsideDown:
                                numColums = 2
                            default:
                                numColums = 3
                            }
                        }
                    }
                    else  if self.targetPath == self.favoritesStr {
                        if currentOrientation().portrait {
                            numColums = 2
                        } else if currentOrientation().landscape {
                            numColums = 2
                        }else {
                            switch UIDevice.current.orientation {
                            case .portrait, .portraitUpsideDown:
                                numColums = 2
                            case .landscapeLeft, .landscapeRight:
                                numColums = 3
                            default:
                                numColums = 2
                            }
                        }
                    }
                    else if card.cardType == .circle_poster && productType.iPad {
                        numColums = appContants.appName == .gac ? 6 : 3
                    }
                    else {
                        if currentOrientation().portrait {
                            numColums = 3
                        } else if currentOrientation().landscape {
                            numColums = 4
                        }else {
                            switch UIDevice.current.orientation {
                            case .portrait, .portraitUpsideDown:
                                numColums = 3
                            case .landscapeLeft, .landscapeRight:
                                numColums = 4
                            default:
                                numColums = 3
                            }
                        }
                    }
                }
            }else {
                if currentOrientation().portrait {
                    numColums = 2
                } else if currentOrientation().landscape {
                    numColums = 5
                }
                for card in sections {
                    if card.cardType == .roller_poster {
                        //                    if currentOrientation().portrait {
                        numColums = 3
                        //                    } else if currentOrientation().landscape {
                        //                        numColums = 5
                        //                    }
                    } else  if self.section?.sectionInfo.dataType == "network" || card.cardType == .network_poster {
                        numColums = 2
                    }
                    else if card.cardType == .sheet_poster {
                        numColums = 2
                    }else if card.cardType == .circle_poster || card.cardType == .square_poster{
                        numColums = 3
                    }
                    else {
                        numColums = 1
                    }
                    if self.targetPath == self.favoritesStr {
                        numColums = 1
                    }
                }
            }
        }
        if appContants.appName == .gac && productType.iPad {
            numColums = numColums - 1
        }
        cCFL.numberOfColumns = numColums
        print("numColums: iPad ", self.numColums)
    }
    
    func calculateNumColsForFilters() {
        if productType.iPad {
            if currentOrientation().portrait {
                filterNumColums = 5
            } else if currentOrientation().landscape {
                filterNumColums = 7
            }
        } else {
            if currentOrientation().portrait {
                filterNumColums = 2
            } else if currentOrientation().landscape {
                filterNumColums = 5
            }
        }
        
        filterCFL.numberOfColumns = filterNumColums
        print("numColums: f ", self.filterNumColums)
    }
    
    /*
     
     override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
     if productType.iPad {
     self.calculateNumCols()
     moviesCollection.reloadData()
     //            CatchupCV.setContentOffset(CGPoint.zero, animated: true)
     }
     }
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    //MARK: - CollectionView data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtersCollectionView {
            return self.pageFilters.count
        }
        else if self.isMyDownloadsSection {
            if #available(iOS 11.0, *) {
                return self.downloadStreamsArr.count
            } else {
                return 0
            }
        }
        return self.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == filtersCollectionView {
            let elements_count = self.pageFilters.count
            
            let cellCount = CGFloat(elements_count)
            
            //If the cell count is zero, there is no point in calculating anything.
            if cellCount > 0 {
                //2.00 was just extra spacing I wanted to add to my cell.
                var totalCellWidth:CGFloat = 0.0// = cellWidth*cellCount + 2.00 * (cellCount-1)
                for _ in self.pageFilters {
                    totalCellWidth += 120.0
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
            return UIEdgeInsets.zero
        }
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == filtersCollectionView {
            filterCellSizes = self.updateCellSizes(collectionView: filtersCollectionView, indexPath: indexPath)
            filterCFL.cellSize = filterCellSizes
            self.calculateNumColsForFilters()
            filterCFL.setupLayout()
            filtersCollectionView.collectionViewLayout = filterCFL
            
            if productType.iPad {
                let filterObj = self.pageFilters[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCelliPad", for: indexPath)
                cell.changeBorder(color: UIColor(hexString: "b3ffffff"))
                cell.changeBorderWidthWith(factor: 1)
                let filterImgView = cell.viewWithTag(1) as! UIImageView
                let title = cell.viewWithTag(2) as! UILabel
                let subTitle = cell.viewWithTag(3) as! UILabel
                filterImgView.image = filterObj.multiSelectable ? #imageLiteral(resourceName: "filterIcon") : #imageLiteral(resourceName: "sortIcon")
                //            filterImgView.sd_setImage(with: URL.init(string: ""), placeholderImage: #imageLiteral(resourceName: "genre"))
                if self.filterDic[self.pageFilters[indexPath.item].code] != nil {
                    let filterList = self.filterDic[self.pageFilters[indexPath.item].code] as! NSMutableArray
                    if filterList.count > 0 {
                        subTitle.text = filterList.componentsJoined(by: ",")
                    }
                    else {
                        subTitle.text = "Apply \(filterObj.title)"
                    }
                }
                else {
                    subTitle.text = "Apply \(filterObj.title)"
                }
                title.text = filterObj.title
                cell.backgroundColor = UIColor.clear
                return cell
            }
            else {
                
                let filterObj = self.pageFilters[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath)
                cell.changeBorder(color: UIColor(hexString: "b3ffffff"))
                cell.changeBorderWidthWith(factor: 1)
//                let filterImgView = cell.viewWithTag(1) as! UIImageView
                let subTitle = cell.viewWithTag(1) as! UILabel
//                let subTitle = cell.viewWithTag(3) as! UILabel
//                filterImgView.image = filterObj.multiSelectable ? #imageLiteral(resourceName: "filterIcon") : #imageLiteral(resourceName: "sortIcon")
                //            filterImgView.sd_setImage(with: URL.init(string: ""), placeholderImage: #imageLiteral(resourceName: "genre"))
                
                
                if appContants.appName != .gac && self.filterDic[self.pageFilters[indexPath.item].code] != nil {
                    let filterList = self.filterDic[self.pageFilters[indexPath.item].code] as! NSMutableArray
                    if filterList.count > 0 {
                        subTitle.text = filterList.componentsJoined(by: ",")
                    }
                    else {
                        subTitle.text = "\(filterObj.title)"
                    }
                }
                else {
                    subTitle.text = "\(filterObj.title)"
                }
                title = "\(filterObj.title)"
                cell.backgroundColor = UIColor.clear
                return cell
            }
        }
        else {
            cellSizes = self.updateCellSizes(collectionView: moviesCollection, indexPath: indexPath)
            self.calculateNumCols()
            cCFL.cellSize = cellSizes
            cCFL.scrollDir = scrollDir
            cCFL.setupLayout()
            moviesCollection.collectionViewLayout = cCFL
            if self.isMyDownloadsSection {
                collectionView.register(UINib(nibName: "MyDownloadsCell", bundle: nil), forCellWithReuseIdentifier: "MyDownloadsCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDownloadsCell", for: indexPath) as! MyDownloadsCell
                if #available(iOS 11.0, *) {
                    let stream = self.downloadStreamsArr[indexPath.row]
                    let asset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: URL.init(string: stream.playlistURL)!))
                    let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                    if downloadState == .notDownloaded {
                        if Utilities.hasConnectivity() {
                            AssetPersistenceManager.sharedManager.downloadStream(for: asset)
                        }
                    }
                    cell.asset = asset
                    cell.nameLbl.text = stream.name
                    cell.descLbl.text = stream.download_size
                    cell.durationLabel.text = stream.video_duration
                    let expiryHoursAndMinutes = getExpiryDate(endDate: stream.downloaded_end_date)
                    let minuteText = (expiryHoursAndMinutes.minute ?? -1) <= 1 ? "min" : "mins"
                    if expiryHoursAndMinutes.hour == 0 && expiryHoursAndMinutes.minute ?? -1 <= 0 {
                        cell.downloadHoursLbl.isHidden = true
                    }
                    else if expiryHoursAndMinutes.hour ?? 0 < AppDelegate.getDelegate().offlineContentExpiryTagInHours, (expiryHoursAndMinutes.hour ?? -1) >= 0 {
                        cell.downloadHoursLbl.isHidden = false
                        if (expiryHoursAndMinutes.hour ?? -1) == 0 {
                            cell.downloadHoursLbl.text = "  Expires in \((expiryHoursAndMinutes.minute ?? -1)) " + minuteText + "  "
                        }else {
                            cell.downloadHoursLbl.text = "  Expires in \((expiryHoursAndMinutes.hour ?? -1)) hr \((expiryHoursAndMinutes.minute ?? -1)) " + minuteText + "  "
                        }
                    }else {
                        if !Utilities.hasConnectivity() {
                            if let offlineContentExpiryTagInHours = UserDefaults.standard.value(forKey: "offlineContentExpiryTagInHours") as? String, let expiryTagHours = Int(offlineContentExpiryTagInHours) {
                                if expiryHoursAndMinutes.hour ?? 0 < expiryTagHours, (expiryHoursAndMinutes.hour ?? -1) >= 0 {
                                    cell.downloadHoursLbl.isHidden = false
                                    if (expiryHoursAndMinutes.hour ?? -1) == 0 {
                                        cell.downloadHoursLbl.text = "  Expires in \((expiryHoursAndMinutes.minute ?? -1)) " + minuteText + "  "
                                    }else {
                                        cell.downloadHoursLbl.text = "  Expires in \((expiryHoursAndMinutes.hour ?? -1)) hr \((expiryHoursAndMinutes.minute ?? -1)) " + minuteText + "  "
                                    }
                                }else {
                                    cell.downloadHoursLbl.isHidden = true
                                }
                            }else {
                                cell.downloadHoursLbl.isHidden = true
                            }
                        }else{
                            cell.downloadHoursLbl.isHidden = true
                        }
                    }
                    cell.downloadedImageView.image = UIImage.init(data: stream.imageData! as Data)
                    cell.checkBoxButton.tag = indexPath.row
                    cell.checkBoxButton.addTarget(self, action: #selector(self.deleteCheckmarkSelectAction(_:)), for: .touchUpInside)
                    cell.downloadHoursLbl.viewCornerRadiusWithTwo()
                    if productType.iPad {
                        cell.downloadImageviewHeightConstraint.constant = 105.0
                    }
                    if selectedObjectsForDelete.contains(where: {$0.name == downloadStreamsArr[indexPath.row].name && $0.analyticsMetaID == downloadStreamsArr[indexPath.row].analyticsMetaID}) {
                        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "ic_mydownload_selected"), for: .normal)
                    }else {
                        cell.checkBoxButton.setImage(#imageLiteral(resourceName: "ic_mydownload_not_selected"), for: .normal)
                    }
                } else {
                    // Fallback on earlier versions
                }
                cell.fetchDetails = {
                    self.downloadStreamsArr.removeAll()
                    self.setResponseData()
                }
                return cell
            }
            let channelObj = self.sections[indexPath.item]
            if self.targetPath == self.favoritesStr  || channelObj.cardType == .overlay_poster || channelObj.cardType == .network_poster || sectionTitle == "Continue Watching" {
                
                if self.section?.sectionInfo.dataType == "network" || channelObj.cardType == .network_poster {
                    // need to add partner cell here
                    
                    let cardDisplay = channelObj.display
                    
                    collectionView.register(UINib(nibName: "PartnerCell", bundle: nil), forCellWithReuseIdentifier: "PartnerCell")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as! PartnerCell
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                    cell.imageView.layer.cornerRadius = 5.0
                    cell.cornerDesignForCollectionCell()
                    cell.backgroundColor = UIColor.init(hexString: "2b2b36")
                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    return cell
                    
                }else{
                    
                    
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "OverlayPosterLV", bundle: nil), forCellWithReuseIdentifier: "OverlayPosterLV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverlayPosterLV", for: indexPath) as! OverlayPosterLV
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                        cell.iconImageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                    if cardDisplay.parentIcon .isEmpty {
                        cell.iconImageView.isHidden = true
                        cell.channelLogoViewHeightConstraint.constant = 0.0
                        cell.channelLogoViewWidthConstraint.constant = 0.0
                    } else {
                        cell.iconImageView.isHidden = false
                        cell.channelLogoViewHeightConstraint.constant = 45.0
                        cell.channelLogoViewWidthConstraint.constant = 45.0
                    }
                    if self.targetPath == self.favoritesStr {
                        if let _ = deleteFavotiteItemslist.firstIndex(of: channelObj.target.path) {
                            cell.favoriteButton.setImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                            //                            cell.favoriteButton.setBackgroundImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                        } else {
                            cell.favoriteButton.setImage(UIImage(named: "fav_deselected_list"), for: UIControl.State())
                        }
                        cell.favoriteButton.isHidden = false
                        cell.favoriteButtonWidthConstraint.constant = 30
                        cell.favoriteButton.tag = indexPath.row
                        cell.favoriteButton.addTarget(self, action: #selector(self.favoriteBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                    }
                    else{
                        cell.favoriteButton.isHidden = true
                        cell.favoriteButtonWidthConstraint.constant = 0
                    }
                    
                    let height = (productType.iPad ? 93 : 73)
                    cell.imagViewWidthConstraint.constant = CGFloat(height * 16/9)
                    cell.imageViewHeightConstraint.constant = CGFloat(height)
                    
                    cell.watchedProgressView.isHidden = true
                    cell.badgeLbl.isHidden = true
                    cell.badgeImgView.isHidden = true
                    cell.liveTagLbl.isHidden = true
                    cell.badgeSubLbl.isHidden = true
                    cell.badgeSubLbl.text = ""
                    if channelObj.display.markers.count > 0 {
                        for marker in channelObj.display.markers {
                            if marker.markerType == .seek {
                                cell.watchedProgressView.isHidden = false
                                cell.watchedProgressView.progress = Float.init(marker.value)!
                                cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                            }
                            if marker.markerType == .available_soon {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeImgView.isHidden = false
                                cell.badgeSubLbl.text = marker.value
                                cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "bbbbbb"))
                                cell.badgeImgView.image = UIImage.init(named: "rectangle_128")
                            }else if marker.markerType == .exipiryDays {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeSubLbl.text = marker.value
                                cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "e01d29"))
                                cell.badgeImgView.image = UIImage.init(named: "rectangle_129")
                            }else if marker.markerType == .exipiryInfo || marker.markerType == .expiryInfo {
                                cell.badgeLbl.isHidden = false
                                var splitArray = marker.value.components(separatedBy: "@")
                                if splitArray.count == 1 {
                                    cell.badgeLbl.text = splitArray.last
                                    cell.badgeLbl.textColor = .white
                                }else if splitArray.count == 2 {
                                    let string1 = splitArray[0]
                                    splitArray.remove(at: 0)
                                    let string2 = splitArray.joined(separator:" ")
                                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (string1 + string2))
                                    let range1: NSRange = attributedString.mutableString.range(of: string1, options: .caseInsensitive)
                                    let range2: NSRange = attributedString.mutableString.range(of: string2, options: .caseInsensitive)
                                    attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.expireTextColor!, range: range1)
                                    attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.cardTitleColor!, range: range2)
                                    cell.badgeLbl.attributedText = attributedString
                                }
                            }else if marker.markerType == .badge {
                                cell.liveTagLbl.isHidden = false
                                cell.liveTagLbl.text = marker.value
                                cell.liveTagLbl.sizeToFit()
                                cell.liveTagLblWidthConstraint.constant = (cell.liveTagLbl.frame.size.width + 20) < cell.frame.size.width ? cell.liveTagLbl.frame.size.width + 20 : cell.frame.size.width
                                cell.liveTagLbl.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            }
                        }
                    }
//                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
//                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                //                }
            }
            else if channelObj.cardType == .roller_poster {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterGV.identifier, for: indexPath) as! RollerPosterGV
                cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "potrait")
                cell.name.text = channelObj.display.title
                cell.desc.text = channelObj.display.subtitle1
                cell.expiryInfoLbl.text = ""
                cell.expiryInfoLbl.isHidden = true
                cell.leftOverTimeLabel.isHidden = true
                cell.leftOverLabelHeightConstraint.constant = 0.0
                cell.gradientImageView.isHidden = true
                if (indexPath as NSIndexPath).row + 1 == self.sections.count
                {
                    if self.noContentFlag == false {
                        //                        self.sectionsMetadata()
                    }
                }
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                cell.watchedProgressView.isHidden = true
                cell.badgeLbl.isHidden = true
                cell.tagLbl.isHidden = true
                cell.tagImgView.isHidden = true
                for marker in channelObj.display.markers {
                    
                    if marker.markerType == .seek {
                        cell.watchedProgressView.isHidden = false
                        cell.watchedProgressView.progress = Float.init(marker.value)!
                        cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                    }
                    else if marker.markerType == .record || marker.markerType == .stoprecord{
                        if marker.markerType == .record {
                            cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            cell.recordBtn.isHidden = false
                            cell.stopRecordingBtn.isHidden = true
                        } else {
                            cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            cell.recordBtn.isHidden = true
                            cell.stopRecordingBtn.isHidden = false
                        }
                        cell.recordBtn.tag = indexPath.row
                        cell.stopRecordingBtn.tag = indexPath.row
                        cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4){
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                    if marker.markerType == .exipiryInfo || marker.markerType == .expiryInfo {
                        cell.expiryInfoLbl.isHidden = false
                        cell.gradientImageView.isHidden = false
                        var splitArray = marker.value.components(separatedBy: "@")
                        if splitArray.count == 1 {
                            cell.expiryInfoLbl.text = splitArray.last
                            cell.expiryInfoLbl.textColor = .white
                        }else if splitArray.count == 2 {
                            let string1 = splitArray[0]
                            splitArray.remove(at: 0)
                            let string2 = splitArray.joined(separator:"\n")
                            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (string1 + string2))
                            let range1: NSRange = attributedString.mutableString.range(of: string1, options: .caseInsensitive)
                            let range2: NSRange = attributedString.mutableString.range(of: string2, options: .caseInsensitive)
                            attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.expireTextColor!, range: range1)
                            attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.cardTitleColor!, range: range2)
                            cell.expiryInfoLbl.attributedText = attributedString
                        }
                    }else if marker.markerType == .leftOverTime, marker.value.count > 0 {
                        cell.leftOverTimeLabel.isHidden = false
                        cell.leftOverLabelHeightConstraint.constant = 18.0
                        cell.leftOverTimeLabel.backgroundColor = UIColor.init(hexString: marker.bgColor)
                        cell.leftOverTimeLabel.text = marker.value
                        cell.leftOverTimeLabel.textColor = UIColor.init(hexString: marker.textColor)
                    }
                    else if marker.markerType == .tag {
                        cell.tagLbl.isHidden = false
                        cell.tagImgView.isHidden = false
                        cell.tagLbl.text = marker.value.capitalized
                        if marker.value.lowercased() == "free" {
                            cell.tagWidthConstraint.constant = 44.4
                            cell.tagImgView.image = UIImage.init(named: "free_tag")
                        }else if marker.value.lowercased() == "subscribe" {
                            cell.tagWidthConstraint.constant = 66.4
                            cell.tagImgView.image = UIImage.init(named: "subscribe_tag")
                        }else {
                            cell.tagWidthConstraint.constant = 95.4
                            cell.tagImgView.image = UIImage.init(named: "paid_tag")
                        }
                    }
                }
                //                cell.cornerDesignForCollectionCell()
                cell.backgroundColor = UIColor.clear
                return cell
            }
            else if channelObj.cardType == .live_poster || channelObj.cardType == .content_poster {
                collectionView.register(UINib(nibName: LivePosterLV.nibname, bundle: nil), forCellWithReuseIdentifier: LivePosterLV.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePosterLV.identifier, for: indexPath) as! LivePosterLV
                let cardInfo = channelObj.display
                if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                }
                cell.markerLbl.isHidden = true
                cell.nowPlayingStrip.isHidden = true
                cell.imageLeadingConstraint.constant = (UIScreen.main.screenType == .iPhone5 ? 15 : 0)
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in cardInfo.markers {
                    if marker.markerType == .badge {
                        cell.markerLbl.isHidden = false
                        cell.markerLbl.text = marker.value
                        cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
                        cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
                    }
                    else if marker.markerType == .special && marker.value == "now_playing" {
                        cell.nowPlayingStrip.isHidden = false
                    }
                    if marker.markerType == .record || marker.markerType == .stoprecord{
                        if marker.markerType == .record {
                            cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            
                            cell.recordBtn.isHidden = false
                            cell.stopRecordingBtn.isHidden = true
                        } else {
                            cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            cell.recordBtn.isHidden = true
                            cell.stopRecordingBtn.isHidden = false
                        }
                        cell.recordBtn.tag = indexPath.row
                        cell.stopRecordingBtn.tag = indexPath.row
                        cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                cell.imageView.layer.cornerRadius = 4.0
                cell.name.text = cardInfo.title
                if cardInfo.subtitle1 .isEmpty {
                    cell.desc.text = cardInfo.parentName
                }
                else {
                    cell.desc.text = cardInfo.subtitle1
                }
                cell.layer.cornerRadius = 4.0
                return cell
            }
            else if channelObj.cardType == .band_poster {
                let cardDisplay = channelObj.display
                collectionView.register(UINib(nibName: "BandPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellLV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellLV", for: indexPath) as! BandPosterCellLV
                cell.name.text = cardDisplay.title
                cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                if !cardDisplay.parentIcon .isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                cell.visulEV.blurRadius = 5
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in cardDisplay.markers {
                    if marker.markerType == .tag && marker.value == "Premium" {
                        cell.premiumView.isHidden = false
                    }
                    if marker.markerType == .record || marker.markerType == .stoprecord{
                        if marker.markerType == .record {
                            cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            
                            cell.recordBtn.isHidden = false
                            cell.stopRecordingBtn.isHidden = true
                        } else {
                            cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                            cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            cell.recordBtn.isHidden = true
                            cell.stopRecordingBtn.isHidden = false
                        }
                        cell.recordBtn.tag = indexPath.row
                        cell.stopRecordingBtn.tag = indexPath.row
                        cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                        if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                
                return cell
            }
            else if channelObj.cardType == .sheet_poster {
                /*if productType.iPad {
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                    if !cardDisplay.parentIcon .isEmpty && cardDisplay.parentIcon.contains("https") {
                        cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    for marker in cardDisplay.markers {
                        if marker.markerType == .record || marker.markerType == .stoprecord{
                            if marker.markerType == .record {
                                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                
                                cell.recordBtn.isHidden = false
                                cell.stopRecordingBtn.isHidden = true
                            } else {
                                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = true
                                cell.stopRecordingBtn.isHidden = false
                            }
                            cell.recordBtn.tag = indexPath.row
                            cell.stopRecordingBtn.tag = indexPath.row
                            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    cell.imageView.viewCornersWithFive()
//                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
//                    let tempHeight = tempWidth * 0.5625
//                    cell.imageViewHeightConstraint.constant = tempHeight
                    return cell
                }
                else {*/
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "SheetPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGV", for: indexPath) as! SheetPosterCellGV
                    cell.name.text = cardDisplay.title
                    if appContants.appName == .gac {
                        cell.titleHeight.constant = 35
                        cell.titleTopConstraint.constant = 3.0
                        cell.name.font = UIFont.ottRegularFont(withSize: 12)
                        cell.subtitleTop.constant = 1.0
                        cell.name.lineBreakMode = .byWordWrapping
                        cell.name.numberOfLines = 2
                    }
                    cell.desc.text = cardDisplay.subtitle1
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.tagLbl.isHidden = true
                    cell.tagImgView.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    cell.nowPlayingHeightConstraint.constant = 0.0
                    cell.durationLabel.isHidden = true
                    cell.durationLblBottomConstraint.constant = 5.0
//                    if sectionTitle == "continue_watching" || sectionTitle == "Continue Watching" {
                        if channelObj.display.markers.count > 0 {
                            for marker in channelObj.display.markers {
                                if marker.markerType == .badge {
                                    cell.episodeMarkupTagView.isHidden = false
                                    cell.episodeMarkupTagView.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                    cell.episodeMarkupLbl.text = marker.value
                                    cell.episodeMarkupLbl.sizeToFit()
                                    cell.badgeWidthConstraint.constant = (cell.episodeMarkupLbl.frame.size.width + 20) < cell.frame.size.width ? cell.episodeMarkupLbl.frame.size.width + 20 : cell.frame.size.width
                                    cell.durationLblBottomConstraint.constant = 24.0
                                }
                                else if marker.markerType == .special && marker.value == "now_playing" {
                                    cell.nowPlayingStrip.isHidden = false
                                    cell.nowPlayingHeightConstraint.constant = 15.0
                                }
                                else if (marker.markerType == .duration || marker.markerType == .leftOverTime) && !(marker.value .isEmpty) {
                                    cell.durationLabel.isHidden = false
                                    cell.durationLabel.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                    cell.durationLabel.text = marker.value
                                    cell.durationLabel.textColor = UIColor.init(hexString: marker.textColor)
                                    cell.durationLabel.sizeToFit()
                                    if marker.markerType == .leftOverTime {
                                        cell.durationLblWidthConstraint.constant = cell.durationLabel.frame.size.width + 8.0
                                    }
                                }
                                else if marker.markerType == .seek {
                                    cell.watchedProgressView.isHidden = false
                                    cell.watchedProgressView.progress = Float.init(marker.value)!
                                    cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                                }
                                else if marker.markerType == .record || marker.markerType == .stoprecord{
                                    if marker.markerType == .record {
                                        cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                        cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                        cell.recordBtn.isHidden = false
                                        cell.stopRecordingBtn.isHidden = true
                                    } else {
                                        cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                        cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                        cell.recordBtn.isHidden = true
                                        cell.stopRecordingBtn.isHidden = false
                                    }
                                    cell.recordBtn.tag = indexPath.row
                                    cell.stopRecordingBtn.tag = indexPath.row
                                    cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                                    cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                                }
                            }
                        //}
                    }
                    else {
                        cell.watchedProgressView.isHidden = true
                        cell.episodeMarkupTagView.isHidden = true
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        for marker in cardDisplay.markers {
                            if marker.markerType == .record || marker.markerType == .stoprecord{
                                if marker.markerType == .record {
                                    cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                    cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                    cell.recordBtn.isHidden = false
                                    cell.stopRecordingBtn.isHidden = true
                                } else {
                                    cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                    cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                    cell.recordBtn.isHidden = true
                                    cell.stopRecordingBtn.isHidden = false
                                }
                                cell.recordBtn.tag = indexPath.row
                                cell.stopRecordingBtn.tag = indexPath.row
                                cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                                cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                                //                                if self.recordingsProgramArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                                //                                    cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                //                                    cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                //                                }
                            }
                            else if marker.markerType == .badge {
                                cell.episodeMarkupTagView.isHidden = false
                                cell.episodeMarkupTagView.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.episodeMarkupLbl.text = marker.value
                                cell.episodeMarkupLbl.sizeToFit()
                                cell.badgeWidthConstraint.constant = (cell.episodeMarkupLbl.frame.size.width + 20) < cell.frame.size.width ? cell.episodeMarkupLbl.frame.size.width + 20 : cell.frame.size.width
                                cell.durationLblBottomConstraint.constant = 24.0
                            }
                            else if marker.markerType == .special && marker.value == "now_playing" {
                                cell.nowPlayingStrip.isHidden = false
                                cell.nowPlayingHeightConstraint.constant = 15.0
                            }
                            else if marker.markerType == .tag {
                                cell.tagLbl.isHidden = false
                                cell.tagImgView.isHidden = false
                                cell.tagLbl.text = marker.value.capitalized
                                if marker.value.lowercased() == "free" {
                                    cell.tagWidthConstraint.constant = 44.4
                                    cell.tagImgView.image = UIImage.init(named: "free_tag")
                                }else if marker.value.lowercased() == "subscribe" {
                                    cell.tagWidthConstraint.constant = 66.4
                                    cell.tagImgView.image = UIImage.init(named: "subscribe_tag")
                                }else {
                                    cell.tagWidthConstraint.constant = 95.4
                                    cell.tagImgView.image = UIImage.init(named: "paid_tag")
                                }
                            }
                        }
                    }
                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                    let tempHeight = tempWidth * 0.5625
                    cell.imageViewHeightConstraint.constant = tempHeight
                    cell.cornerDesignForCollectionCell()
                    return cell
//                }
            }
            else if channelObj.cardType == .circle_poster {
                let cardDisplay = channelObj.display
                
                collectionView.register(UINib(nibName: "CirclePosterCell", bundle: nil), forCellWithReuseIdentifier: "CirclePosterCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CirclePosterCell", for: indexPath) as! CirclePosterCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                if productType.iPad {
                    cell.imageView.layer.cornerRadius = cell.bounds.width / 2.0
                    cell.imageView.clipsToBounds = true
                } else {
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                    cell.imageViewHeightConstraint.constant = tempWidth
                    cell.imageView.layer.cornerRadius = tempWidth / 2.0
                    cell.imageView.clipsToBounds = true
                }
                cell.nameLbl.text = cardDisplay.title
                cell.nameLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
                if appContants.appName == .gac && productType.iPad {
                    if UIApplication.shared.statusBarOrientation.isLandscape {
                        cell.nameLbl.font = UIFont.ottRegularFont(withSize: 13)
                        cell.subTitleLabel.font = UIFont.ottRegularFont(withSize: 13)
                    }
                }
                cell.subTitleLabel.text = cardDisplay.subtitle1
                cell.subTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor

                cell.backgroundColor = UIColor.clear
                //                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if channelObj.cardType == .common_poster {
                if productType.iPad {
                    collectionView.register(UINib(nibName: SearchCommonPosterCellLViPad.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLViPad.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLViPad.identifier, for: indexPath) as! SearchCommonPosterCellLViPad
                    cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "tv")
                    cell.name.text = channelObj.display.title
                    cell.desc.text = channelObj.display.subtitle1
                    cell.subDesc.text = channelObj.display.subtitle2
                    
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    if self.targetPath == self.favoritesStr {
                        if let _ = deleteFavotiteItemslist.firstIndex(of: channelObj.target.path) {
                            cell.favoriteButton.setImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                            //                            cell.favoriteButton.setBackgroundImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                        } else {
                            cell.favoriteButton.setImage(UIImage(named: "fav_deselected_list")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
                            cell.favoriteButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
                        }
                        cell.favoriteButton.isHidden = false
                        cell.favoriteButton.tag = indexPath.row
                        cell.favoriteButton.addTarget(self, action: #selector(self.favoriteBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                    }
                    else{
                        cell.favoriteButton.isHidden = true
                    }
                    for marker in channelObj.display.markers {
                        if marker.markerType == .badge {
                            cell.viewWithTag(1)?.isHidden = false
                            cell.nameXPositionConstraint.constant = 9.0
                            cell.markerLabel.text = marker.value
                            cell.redDotView.isHidden = true
                            break
                        }
                        if marker.markerType == .record || marker.markerType == .stoprecord{
                            if marker.markerType == .record {
                                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = false
                                cell.stopRecordingBtn.isHidden = true
                            } else {
                                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = true
                                cell.stopRecordingBtn.isHidden = false
                            }
                            cell.recordBtn.tag = indexPath.row
                            cell.stopRecordingBtn.tag = indexPath.row
                            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                        else {
                            cell.viewWithTag(1)?.isHidden = true
                            if cell.nameXPositionConstraint != nil {
                                cell.nameXPositionConstraint.constant = 9.0
                            }
                        }
                        //                        else if marker.markerType == .special {
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //
                        //                            if marker.value == "live_dot" {
                        //                                cell.redDotView.isHidden = false
                        //                                cell.nameXPositionConstraint.constant = 20.0
                        //                                cell.redDotView.layer.cornerRadius = cell.redDotView.frame.size.width/2.0
                        //                            }
                        //                            break
                        //                        }
                        //                        else if marker.markerType == .duration || marker.markerType == .leftOverTime {
                        //                            cell.nameXPositionConstraint.constant = 9.0
                        //                            cell.redDotView.isHidden = true
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                        }
                        //                        else if marker.markerType == .tag {
                        //                            cell.nameXPositionConstraint.constant = 9.0
                        //                            cell.redDotView.isHidden = true
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                        }
                        //                        else if marker.markerType == .rating {
                        //                            cell.nameXPositionConstraint.constant = 9.0
                        //                            cell.redDotView.isHidden = true
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                        }
                    }
                    if channelObj.display.markers.count == 0 {
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else {
                        cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                    }
                    return cell
                    
                }
                else {
                    collectionView.register(UINib(nibName: SearchCommonPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLV.identifier, for: indexPath) as! SearchCommonPosterCellLV
                    cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "tv")
                    cell.name.text = channelObj.display.title
                    cell.desc.text = channelObj.display.subtitle1
                    cell.subDesc.text = channelObj.display.subtitle2
                    
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    //            var dotWidthConstraint : NSLayoutConstraint?
                    //            for constraint in cell.redDotView.constraints as [NSLayoutConstraint] {
                    //                if constraint.identifier == "dotWidthConstraint" {
                    //                    dotWidthConstraint = constraint
                    //                }
                    //            }
                    //            dotWidthConstraint?.constant = 0
                    
                    if self.targetPath == self.favoritesStr {
                        if let _ = deleteFavotiteItemslist.firstIndex(of: channelObj.target.path) {
                            cell.favoriteButton.setImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                            //                            cell.favoriteButton.setBackgroundImage(UIImage(named: "fav_selected_list"), for: UIControl.State())
                        } else {
                            cell.favoriteButton.setImage(UIImage(named: "fav_deselected_list")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
                            cell.favoriteButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
                        }
                        cell.favoriteButton.isHidden = false
                        cell.favoriteButton.tag = indexPath.row
                        cell.favoriteButton.addTarget(self, action: #selector(self.favoriteBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                    }
                    else{
                        cell.favoriteButton.isHidden = true
                    }
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    for marker in channelObj.display.markers {
                        if marker.markerType == .badge {
                            cell.viewWithTag(1)?.isHidden = false
                            if cell.nameXPositionConstraint != nil {
                                cell.nameXPositionConstraint.constant = 9.0
                            }
                            cell.markerLabel.text = marker.value
                            cell.markerLabel.sizeToFit()
                            cell.markerLabelBgViewWidthConstraint.constant =
                                cell.markerLabel.frame.size.width + 20
                            
                            cell.markerLabelBgView.backgroundColor = UIColor.init(hexString: marker.bgColor)
                            cell.redDotView.isHidden = true
                            break
                        }
                        if marker.markerType == .record || marker.markerType == .stoprecord{
                            if marker.markerType == .record {
                                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                
                                cell.recordBtn.isHidden = false
                                cell.stopRecordingBtn.isHidden = true
                            } else {
                                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = true
                                cell.stopRecordingBtn.isHidden = false
                            }
                            cell.recordBtn.tag = indexPath.row
                            cell.stopRecordingBtn.tag = indexPath.row
                            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                        else {
                            cell.viewWithTag(1)?.isHidden = true
                            if cell.nameXPositionConstraint != nil {
                                cell.nameXPositionConstraint.constant = 9.0
                            }
                        }
                        //                        else if marker.markerType == .special {
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //
                        //                            if marker.value == "live_dot" {
                        //                                //                        dotWidthConstraint?.constant = 6
                        //                                if cell.nameXPositionConstraint != nil {
                        //                                    cell.nameXPositionConstraint.constant = 20.0
                        //                                }
                        //                                cell.redDotView.isHidden = false
                        //                                cell.redDotView.layer.cornerRadius = cell.redDotView.frame.size.width/2.0
                        //                                cell.redDotView.backgroundColor = UIColor.init(hexString: marker.bgColor)
                        //                            }
                        //                            //                        break
                        //                        }
                        //                        else if marker.markerType == .duration || marker.markerType == .leftOverTime {
                        //                            if cell.nameXPositionConstraint != nil {
                        //                                cell.nameXPositionConstraint.constant = 9.0
                        //                            }
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                            cell.redDotView.isHidden = true
                        //                        }
                        //                        else if marker.markerType == .tag {
                        //                            if cell.nameXPositionConstraint != nil {
                        //                                cell.nameXPositionConstraint.constant = 9.0
                        //                            }
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                            cell.redDotView.isHidden = true
                        //                        }
                        //                        else if marker.markerType == .rating {
                        //                            if cell.nameXPositionConstraint != nil {
                        //                                cell.nameXPositionConstraint.constant = 9.0
                        //                            }
                        //                            cell.viewWithTag(1)?.isHidden = true
                        //                            cell.redDotView.isHidden = true
                        //                        }
                    }
                    if channelObj.display.markers.count == 0 {
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else {
                        cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                    }
                    return cell
                }
            }
            else if channelObj.cardType == .box_poster {
                collectionView.register(UINib(nibName: "BoxPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "BoxPosterCellLV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellLV.identifier, for: indexPath) as! BoxPosterCellLV
                let cardInfo = channelObj.display
                if !cardInfo.parentIcon .isEmpty {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                }
                cell.name.text = cardInfo.title
                cell.desc.text = cardInfo.subtitle1
                return cell
            }
            else if channelObj.cardType == .pinup_poster {
                
                if productType.iPad {
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "PinupPosterCellLV-iPad", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellLViPad")
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellLViPad", for: indexPath) as! PinupPosterCellLViPad
                    cell.desc.text = cardDisplay.title
                    cell.name.text = cardDisplay.subtitle1
                    if !cardDisplay.parentIcon .isEmpty && cardDisplay.parentIcon.contains("https") {
                        cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    cell.visulEV.blurRadius = 5
                    return cell
                }
                else {
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "PinupPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellLV")
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellLV", for: indexPath) as! PinupPosterCellLV
                    cell.desc.text = cardDisplay.title
                    cell.name.text = cardDisplay.subtitle1
                    if !cardDisplay.parentIcon .isEmpty {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    cell.visulEV.blurRadius = 5
                    for marker in cardDisplay.markers {
                        if marker.markerType == .tag && marker.value == "Premium" {
                            cell.premiumView.isHidden = false
                        }
                    }
                    return cell
                }
            }
            else if channelObj.cardType == .icon_poster {
                let cardDisplay = channelObj.display
                collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
                cell.name.text = cardDisplay.title
                if !cardDisplay.parentIcon .isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                cell.imageView.viewCornerDesign()
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 0.5625
                cell.imageViewHeightConstraint.constant = tempHeight
                cell.viewCornerDesign()
                return cell
            }
            else if channelObj.cardType == .ad_content {
                
                let nativeAd = self.nativeAds[channelObj.adPositionIndex]
                
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
            else if channelObj.cardType == .square_poster {
                let cardDisplay = channelObj.display
                
                collectionView.register(UINib(nibName: "SquarePosterCell", bundle: nil), forCellWithReuseIdentifier: "SquarePosterCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquarePosterCell", for: indexPath) as! SquarePosterCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "potrait")
                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                cell.nameLbl.text = cardDisplay.title
                cell.backgroundColor = .clear
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if channelObj.cardType == .rectangle_poster {
                let cardDisplay = channelObj.display
                collectionView.register(UINib(nibName: RectanglePosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: RectanglePosterCellLV.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RectanglePosterCellLV.identifier, for: indexPath) as! RectanglePosterCellLV
                cell.name.text = cardDisplay.title
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                return cell
            }
            else {
                if self.pageResponse.info.code == "partners" || self.section?.sectionInfo.dataType == "network" || channelObj.cardType == .network_poster {
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "PartnerCell", bundle: nil), forCellWithReuseIdentifier: "PartnerCell")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as! PartnerCell
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                    cell.imageView.viewCornerDesign()
                    cell.cornerDesignForCollectionCell()
                    cell.backgroundColor = UIColor.init(hexString: "2b2b36")
                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    return cell
                } else {
                    let cardDisplay = channelObj.display
                    collectionView.register(UINib(nibName: "SheetPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellLV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellLV", for: indexPath) as! SheetPosterCellLV
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.watchedProgressView.isHidden = true
                    if !cardDisplay.parentIcon .isEmpty {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.tagImgView.isHidden = true
                    for marker in cardDisplay.markers {
                        if marker.markerType == .record || marker.markerType == .stoprecord{
                            if marker.markerType == .record {
                                cell.recordBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.recordBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = false
                                cell.stopRecordingBtn.isHidden = true
                            } else {
                                cell.stopRecordingBtn.setTitleColor(UIColor.init(hexString: marker.textColor), for: .normal)
                                cell.stopRecordingBtn.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.recordBtn.isHidden = true
                                cell.stopRecordingBtn.isHidden = false
                            }
                            cell.recordBtn.tag = indexPath.row
                            cell.stopRecordingBtn.tag = indexPath.row
                            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    return cell
                }
            }
        }
    }
    @objc private func deleteCheckmarkSelectAction(_ sender : UIButton) {
        if let index = selectedObjectsForDelete.firstIndex(where: {$0.name == downloadStreamsArr[sender.tag].name && $0.analyticsMetaID == downloadStreamsArr[sender.tag].analyticsMetaID}) {
            selectedObjectsForDelete.remove(at: index)
        }else {
            if downloadStreamsArr[sender.tag].video_download == true {
                selectedObjectsForDelete.append(downloadStreamsArr[sender.tag])
            }
        }
        mydownloadSelectedCountLable.text = "\(selectedObjectsForDelete.count)/\(downloadStreamsArr.count) Selected"
        if selectedObjectsForDelete.count > 0 {
            myDownloadButton.isUserInteractionEnabled = true
            myDownloadButton.isEnabled = true
        }else {
            myDownloadButton.isUserInteractionEnabled = false
            myDownloadButton.isEnabled = false
        }
        if selectedObjectsForDelete.count == downloadStreamsArr.count {
            selectAllDownloads = true
            selectAllDownloadImageView.image = #imageLiteral(resourceName: "ic_mydownload_selected")
        }else {
            selectAllDownloadImageView.image = #imageLiteral(resourceName: "ic_mydownload_not_selected")
            selectAllDownloads = false
        }
        moviesCollection.reloadData()
    }
    private func getExpiryDate(endDate : Double) -> DateComponents {
        let currentDate = Date()
        let dateDif = Calendar.current.dateComponents([.hour, .minute], from: currentDate, to: Date(timeIntervalSince1970: endDate/1000.0))
        return dateDif
    }
    func showDeleteDownloadAlert (_ header : String = "Confirm".localized, message : String, stream:Stream) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        let resumeAlertAction = UIAlertAction(title: "No".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        let startOverAlertAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if #available(iOS 11.0, *) {
                let asset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: URL.init(string: stream.playlistURL)!))
                self.sendDeleteDownloadRequest(asset, stream)
            } else {
                // Fallback on earlier versions
            }
        })
        alert.addAction(resumeAlertAction)
        alert.addAction(startOverAlertAction)
        //        alert.view.tintColor = UIColor.redColor()
        self.present(alert, animated: true, completion: nil)
    }
    func sendDeleteDownloadRequest(_ asset:Asset, _ stream:Stream) {
        self.deleteFromLocalDB(asset, stream)
    }
    @objc func deleteBtnClicked(_ sender: UIButton) {
        if let stream = AppDelegate.getDelegate().selectedContentStream , self.downloadStreamsArr[sender.tag].targetPath == stream.targetPath {
            self.showAlert(message: "Cannot delete the content as it currenlty playing")
        } else {
            if self.downloadStreamsArr.count > sender.tag {
                self.showDeleteDownloadAlert(message: "Do you want to delete this content from My Downloads?", stream: self.downloadStreamsArr[sender.tag])
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.moviesCollection {
            if self.bannerData.count == 0 {
                return CGSize.zero
            }
            return CGSize(width: view.frame.width, height: view.frame.width / 2)
        }
        else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == self.moviesCollection {
            return CGSize(width: self.view.frame.size.width , height: productType.iPad ? 150.0 :  80.0)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == self.moviesCollection {
            
            if indexPath.section == 0 {
                if collectionView == self.moviesCollection && kind == UICollectionView.elementKindSectionHeader {
                    collectionView.register(UINib(nibName: "BannerCVC", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "bannerCellId")
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "bannerCellId", for: indexPath) as! BannerCVC
                    header.banners = self.bannerData
                    //header.scrollTheBanners(true)
                    header.bannerDelegate = self
                    return header
                }
                else if kind == UICollectionView.elementKindSectionFooter {
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
                    
                    footerView.backgroundColor = UIColor.clear
                    return footerView
                }
                else {
                    return UICollectionReusableView()
                }
            }
            else if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
                
                footerView.backgroundColor = UIColor.clear
                return footerView
            }
            else{
                return UICollectionReusableView()
            }
        } else {
            return UICollectionReusableView()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        moviesCollection.collectionViewLayout.invalidateLayout()
        self.Refresh(self)
    }
    
    func updateCellSizes(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        
        if collectionView == filtersCollectionView {
            if productType.iPad {
                return CGSize(width: 170, height: 47)
            }
            return CGSize(width: 120, height: 27)
        }
        else {
            if self.isMyDownloadsSection {
                if productType.iPad {
                    return CGSize(width: 360, height: 128)
                }
                else {
                    return CGSize(width: 333, height: 118)
                }
                
            }
            let sectionCard = self.sections[indexPath.item]
            if self.targetPath == self.favoritesStr  || sectionCard.cardType == .overlay_poster || sectionTitle == "Continue Watching" {
                if productType.iPad {
                    let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                    //                let ratioheight = newW * 9/16
                    let newCellSize = CGSize(width: newW, height: 93.0 )
                    printYLog("newCellSize vertical: ", newCellSize)
                    return newCellSize
                } else{
                    let tempWidth = (AppDelegate.getDelegate().window?.frame.size.width)! - 20.0
                    return CGSize(width: tempWidth, height: 73.0)
                }
            }
            else if sectionCard.cardType == .roller_poster {
                if productType.iPad { 
                    return CGSize(width: 151, height: 151 * 1.5)
                }
                else{
                    if (UIScreen.main.screenType == .iPhone5){
                        return CGSize(width: 100, height: 182)
                    }
                    else{
                        return CGSize(width: 116, height: 206)
                    }
                }
            }
            else if sectionCard.cardType == .square_poster {
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                return CGSize(width: tempWidth, height: tempWidth + 28.0)
            }
            else if sectionCard.cardType == .ad_content {
                return CGSize(width: 350, height: 120)
            }
            else if sectionCard.cardType == .icon_poster || self.pageResponse.info.code == "partners" /* || self.section?.sectionInfo.dataType == "network"*/
            {
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 0.5625
                return CGSize(width: tempWidth, height: tempHeight)
            }
            else if sectionCard.cardType == .sheet_poster {
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 0.5625
                if appContants.appName == .gac {
                    return CGSize(width: tempWidth, height: tempHeight + 52.0 + 25.0)
                }
                return CGSize(width: tempWidth, height: tempHeight + 52.0)
            }
            else if sectionCard.cardType == .circle_poster {
                if appContants.appName == .gac && productType.iPad {
                    if UIApplication.shared.statusBarOrientation.isLandscape {
                        return CGSize(width: 160, height: 290)
                        
                    } else {
                        return CGSize(width: 160, height: 215)
                    }
                    
                }
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * ((tempWidth+30.0)/tempWidth)
                return CGSize(width: tempWidth, height: tempHeight)
            }
            else if sectionCard.cardType == .rectangle_poster && productType.iPad {
                let width = (UIScreen.main.bounds.width - 30)/numColums-1
                return CGSize(width: width , height: width*(132/328))
            }
            else if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster{
                return CGSize(width: 333, height: 73)
            }
            else if self.section?.sectionInfo.dataType == "category" {
                return CGSize(width: 328, height: 132)
            }
            else if self.section?.sectionInfo.dataType == "network" || sectionCard.cardType == .network_poster  {
                //                if productType.iPad {
                secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
                interItemSpacing = 20
                minLineSpacing = 20
                let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                let newCellSize = CGSize(width: newW, height: newW * (9/16) )
                printYLog("newCellSize vertical: ", newCellSize)
                return newCellSize
                //                }else{
                //                let tempWidth = (AppDelegate.getDelegate().window?.frame.size.width)! - 20.0
                //                return CGSize(width: tempWidth, height: 73.0)
                //                }
            }else {
                if productType.iPad {
                    return CGSize(width: 360, height: 123)
                }
                else {
                    return CGSize(width: 333, height: 73)
                }
            }
        }
    }
    
    //cv delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == filtersCollectionView {
            if self.pageFilters[indexPath.item].items.count > 0 {
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                if appContants.appName == .gac {
                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FiltersViewController
                    storyBoardVC.filterObj = self.pageFilters[indexPath.item]
                    storyBoardVC.firstObj = self.section?.sectionInfo.name
                    if self.filterDic[self.pageFilters[indexPath.item].code] != nil {
                        storyBoardVC.selectedFiltersArray = NSMutableArray.init(array: self.filterDic[self.pageFilters[indexPath.item].code] as! NSMutableArray)
                    }
                    storyBoardVC.delegate = self
                    let nav = UINavigationController.init(rootViewController: storyBoardVC)
                    self.present(nav, animated: true, completion: nil)
                } else {
                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
                    storyBoardVC.filterObj = self.pageFilters[indexPath.item]
                    if self.filterDic[self.pageFilters[indexPath.item].code] != nil {
                        storyBoardVC.selectedFiltersArray = NSMutableArray.init(array: self.filterDic[self.pageFilters[indexPath.item].code] as! NSMutableArray)
                    }
                    storyBoardVC.delegate = self
                    let nav = UINavigationController.init(rootViewController: storyBoardVC)
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
        else {
            
            self.startAnimating(allowInteraction: false)
            if self.isMyDownloadsSection{
                if self.downloadStreamsArr.count > indexPath.row  {
                    let stream = self.downloadStreamsArr[indexPath.row]
                    self.loadOfflineContent(stream)
                }
            }else {
                let channelObj = self.sections[indexPath.item]
                if channelObj.template.count > 0{
                    PartialRenderingView.instance.reloadFor(card: channelObj, content: nil, partialRenderingViewDelegate: self)
                    self.stopAnimating()
                    return;
                }
                if AppDelegate.getDelegate().isTabsPage {
                    AppDelegate.getDelegate().sourceScreen = "\(self.pageResponse.info.path.capitalized)_Page"
                    LocalyticsEvent.tagEventWithAttributes("\(self.pageResponse.info.path.capitalized)_Page", ["Language":OTTSdk.preferenceManager.selectedLanguages, "Partners" : "", "Content Name":channelObj.display.title,"Section Name":sectionTitle])
                }
                AppDelegate.getDelegate().isFromPlayerPage = false
                self.didSelectCard(item: channelObj)
            }
        }
    }
    func loadOfflineContent(_ stream:Stream) {
        if #available(iOS 11.0, *) {
            self.asset = AssetPersistenceManager.sharedManager.localAssetForStream(withName: stream.name)
        }
        if self.asset == nil {
            
            if #available(iOS 11.0, *) {
                
                if let asset = AssetPersistenceManager.sharedManager.assetForStream(withName: stream.name), AssetPersistenceManager.sharedManager.downloadState(for: asset) == .downloading {
                    self.stopAnimating()
                    let alertAction: UIAlertAction
                    alertAction = UIAlertAction(title: "Yes", style: .default) { _ in
                        AssetPersistenceManager.sharedManager.cancelDownload(for: asset)
                        self.sendDeleteDownloadRequest(asset,stream)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshOfflineContent"), object: nil, userInfo: nil)
                        }
                    }
                    let alertController = UIAlertController(title: String.getAppName(), message: "Do you want cancel Downloading?",
                                                            preferredStyle: .alert)
                    alertController.addAction(alertAction)
                    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)

                    return;
                }
            }
        }
        
        _ = TargetPage.playerViewController()
        AppDelegate.getDelegate().selectedContentStream = stream
        self.enteredOnce = false
        if #available(iOS 10.0, *) {
            AssetPlaybackManager.sharedManager.setAssetForPlayback(asset)
        } else {
            // Fallback on earlier versions
        }
    }
    func sendDeleteDownloadRequest(_ asset:Asset) {
        /*self.startAnimating(allowInteraction: true)
        OTTSdk.mediaCatalogManager.deleteDownloadVideoRequest(paths: [asset.stream.targetPath], onSuccess: { (message) in
            if #available(iOS 11.0, *) {
                AssetPersistenceManager.sharedManager.cancelDownload(for: asset)
                AppDelegate.getDelegate().deleteStream(asset.stream)
                self.downloadStreamsArr.removeAll()
                self.moviesCollection.reloadData()
                self.downloadStreamsArr.append(contentsOf: AppDelegate.getDelegate().fetchStreamList())
                self.moviesCollection.reloadData()
                self.setResponseData()
                var userInfo = [String: Any]()
                userInfo[Asset.Keys.name] = asset.stream.name
                userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
                userInfo[Asset.Keys.downloadSelectionDisplayName] = displayNamesForSelectedMediaOptions(asset.urlAsset.preferredMediaSelection)

                NotificationCenter.default.post(name: .AssetDownloadStateChanged, object: nil, userInfo: userInfo)
                self.stopAnimating()
            }
        }) { (error) in
            self.stopAnimating()
        }*/
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {
        }
        else {
            if indexPath.row + 1 == self.sections.count
            {
                if self.goGetTheData {
                    self.goGetTheData = false
                    if (self.section?.sectionData.hasMoreData)! {
                        self.loadMoreData(filterString: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateNumCols()
        self.calculateNumColsForFilters()
        moviesCollection.collectionViewLayout.invalidateLayout()
        moviesCollection.reloadData()
        filtersCollectionView.collectionViewLayout.invalidateLayout()
        filtersCollectionView.reloadData()
        if AppDelegate.getDelegate().isPartialViewLoaded == true{
            PartialRenderingView.instance.reloadDataWithFrameUpdate()
        }
    }
    func didSelectedSuggestion(card : Card) {
        self.didSelectCard(item: card)
    }
    func didSelectedOfflineSuggestion(stream : Stream) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
            self.loadOfflineContent(stream)
        }
    }
    func didSelectCard(item:Card)  {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.goToPage(item, templateElement: nil)
    }
    private func gotoTargetedPathWith(path : String, cardItem : Card?, bannerItem : Banner?,templateElement: TemplateElement?) {
        if let item = bannerItem, item.target.path == "packages" {
            showAlert(message: AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ...")
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
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(view1, animated: true)
            return
        }
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            self.stopAnimating()
            var vc : UIViewController!
            if let tempController = viewController as? PlayerViewController {
                tempController.delegate = self
                if let item = cardItem {
                    tempController.defaultPlayingItemUrl = item.display.imageUrl
                    tempController.playingItemTitle = item.display.title
                    tempController.playingItemSubTitle = item.display.subtitle1
                    tempController.playingItemTargetPath = item.target.path
                    tempController.templateElement = templateElement
                }else if let item = bannerItem {
                    tempController.defaultPlayingItemUrl = item.imageUrl
                    tempController.playingItemTitle = item.title
                    tempController.playingItemSubTitle = item.subtitle
                    tempController.playingItemTargetPath = item.target.path
                }
                if templateElement != nil {
                    tempController.templateElement =  templateElement
                }
                AppDelegate.getDelegate().window?.addSubview(tempController.view)
            }else if let tempController = viewController as? ContentViewController {
                tempController.isToViewMore = true
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                }else if let item = bannerItem {
                    tempController.sectionTitle = item.title
                }
                vc = tempController
            }else if let tempController = viewController as? DetailsViewController {
                if let item = cardItem {
                    tempController.navigationTitlteTxt = item.display.title
                    tempController.isCircularPoster = item.cardType == .circle_poster ? true : false
                }else if let item = bannerItem {
                    tempController.navigationTitlteTxt = item.title
                }
                vc = tempController
            }else if let tempController = viewController as? ListViewController {
                tempController.isToViewMore = true
                vc = tempController
            }else {
                vc = viewController
            }
            guard vc != nil else {return}
            guard let topVc = UIApplication.topVC() else {return}
            topVc.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    fileprivate func goToPage(_ item: Card, templateElement: TemplateElement?) {
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
        gotoTargetedPathWith(path: path, cardItem: item, bannerItem: nil, templateElement: templateElement)
        /*TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = item.display.imageUrl
                vc.playingItemTitle = item.display.title
                vc.playingItemSubTitle = item.display.subtitle1
                vc.playingItemTargetPath = item.target.path
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if let vc = viewController as? ContentViewController {
                vc.isToViewMore = true
                vc.sectionTitle = item.display.title
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = item.display.title
                vc.isCircularPoster = item.cardType == .circle_poster ? true : false
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            self.stopAnimating()
        }*/
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
        if Utilities.hasConnectivity(), AppDelegate.getDelegate().isDirectDownloadsPage {
            AppDelegate.getDelegate().loadLaunchScreen()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
    }
    
    func loadMoreData(filterString:String?) {
        
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
        self.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.sectionContent(path: self.pageResponse.info.path, code: (self.section?.sectionInfo.code)!, offset: self.lastIndex, count: nil, filter: filterString == nil ? nil:(filterString? .isEmpty)! ? nil:filterString, onSuccess: { (response) in
            //            self.sections.removeAll()
            
            if response.count > 0 {
                if let cardsResponse = response.first{
                    self.section?.sectionData.hasMoreData = cardsResponse.hasMoreData
                    self.lastIndex =  cardsResponse.lastIndex
                    if cardsResponse.data.count > 0{
                        self.goGetTheData = true
                        self.sections.append(contentsOf: cardsResponse.data)
                        self.moviesCollection.reloadData()
                        if appContants.appName != .gac {
                            self.filtersCollectionView.reloadData()
                        }
                    }
                }
                
                if self.sections.count > 0 {
                    self.showHideErrorView(true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                        self.moviesCollection.reloadData()
                        self.moviesCollection.isHidden = false
                    }
                }
                else {
                    self.showHideErrorView(false)
                    self.moviesCollection.isHidden = true
                }
                if appContants.appName != .gac {
                    self.filtersCollectionView.reloadData()
                }
            }
            else {
                self.showHideErrorView(false)
                self.moviesCollection.isHidden = true
                if appContants.appName != .gac {
                    self.filtersCollectionView.reloadData()
                }
            }
            self.stopAnimating()
        }) { (error) in
            self.stopAnimating()
        }
        
    }
    
    func getProgressValueFrom(currentTime:TimeInterval, maxTime:TimeInterval) -> Float {
        if !currentTime.isNaN && !maxTime.isNaN {
            let presentWatchedTime : Int64 = Int64(currentTime)
            
            let totalShowTime : Int64 = Int64(maxTime)
            let totalPercentWatched = (Float(presentWatchedTime) / Float(totalShowTime))
            return totalPercentWatched
        }
        else {
            return 0.0
        }
    }
    @IBAction func selectAllButtonClicked(_ sender:Any) {
        if deleteFavotiteItemslist.count == self.sections.count{
            deleteFavotiteItemslist.removeAll()
        }
        else{
            deleteFavotiteItemslist.removeAll()
            for programData in self.sections {
                deleteFavotiteItemslist.append(programData.target.path)
            }
        }
        self.checkDeleteButtonStatus()
        self.moviesCollection.reloadData()
    }
    @IBAction func deleteFavoriteButtonClicked(_ sender:UIButton){
        if let value = sender.titleLabel?.text, value.lowercased().contains("find") {
            AppDelegate.getDelegate().loadHomePage()
            return
        }
        self.startAnimating(allowInteraction: false)
        AppDelegate.isFavouriteClicked = true
        var favListPath = ""
        var isPlayerFavItemFound = false
        for (index,favItem) in deleteFavotiteItemslist.enumerated(){
            favListPath = favListPath + favItem
            if index != deleteFavotiteItemslist.count - 1 {
                favListPath = favListPath + ","
            }
            if playerVC != nil {
                if playerVC?.pageDataResponse?.info.path == favItem {
                    isPlayerFavItemFound = true
                }
            }
        }
        OTTSdk.userManager.deleteUserFavouriteItem(pagePath: (favListPath), onSuccess: { (response) in
            if playerVC != nil {
                if isPlayerFavItemFound == true {
                    playerVC?.isFavourite = false
                    if playerVC?.favInPlayer != nil {
                        playerVC?.favInPlayer.setImage( UIImage.init(named: "img_watchlist_circle_player"), for:UIControl.State.normal)
                    }
                }
            }
        }, onFailure: { (error) in
            
        })
        
        self.stopAnimating()
        deleteFavotiteItemslist.removeAll()
        checkDeleteButtonStatus()
        self.Refresh(UIButton.init())
        LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Removed"])
    }
    @objc func favoriteBtnClicked(sender:UIButton) {
        let programData = self.sections[sender.tag]
        if let index = deleteFavotiteItemslist.firstIndex(of: programData.target.path) {
            deleteFavotiteItemslist.remove(at: index)
        } else {
            deleteFavotiteItemslist.append(programData.target.path)
        }
        
        self.checkDeleteButtonStatus()
        self.moviesCollection.reloadData()
    }
    func checkDeleteButtonStatus() {
        if deleteFavotiteItemslist.count > 0{
            deleteFavoriteButtonHeightConstraint?.constant = 40
            deleteFavoriteButton?.isHidden = false
            
            if deleteFavotiteItemslist.count == self.sections.count{
                self.selectAllButton?.setTitle("Clear", for: .normal)
            }
            else{
                self.selectAllButton?.setTitle("Select all", for: .normal)
            }
        }
        else{
            deleteFavoriteButtonHeightConstraint?.constant = 0
            deleteFavoriteButton?.isHidden = true
            self.selectAllButton?.setTitle("Select all", for: .normal)
        }
    }
    @objc func recordBtnClicked(sender:UIButton) {
        let programData = self.sections[sender.tag]
        
        let vc = ProgramRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = 0
        vc.rowIndex = sender.tag
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
        
    }
    
    @objc func stopRecordBtnClicked(sender:UIButton) {
        let programData = self.sections[sender.tag]
        
        let vc = ProgramStopRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = 0
        vc.rowIndex = sender.tag
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }
    
    // MARK: - Partial Rendering protocol methods
    func record(confirm: Bool, content: Any?) {
        if confirm == true {
            
        }
    }
    
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        if card != nil && templateElement != nil{
            self.goToPage(card!, templateElement: templateElement)
        }
    }
    
    // MARK: - Program Record protocol methods
    func programRecordConfirmClicked(programObj:Card?, selectedPrefButtonIndex:Int, sectionIndex:Int, rowIndex:Int) {
        
        var content_type = ""
        var content_id = ""
        var optionsArr = [String]()
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
        //            self.moviesCollection.reloadData()
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
        
    }
    
    func programStopRecordCancelClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
    }
    
    //MARK: - banner delegate Methods
    func didSelectedBannerItem(bannerItem: Banner) -> Void
    {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        gotoTargetedPathWith(path: bannerItem.target.path, cardItem: nil, bannerItem: bannerItem,templateElement: nil)
        /*if bannerItem.isInternal {
            if (bannerItem.target.path == "packages") {
                let alertMessage = AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ..."
                self.showAlert(message: alertMessage)
            }
            else{
                self.startAnimating(allowInteraction: false)
                TargetPage.getTargetPageObject(path: bannerItem.target.path) { (viewController, pageType) in
                    if let vc = viewController as? ContentViewController{
                        
                        //                self.pageContentResponse = vc.pageContentResponse
                        //                self.getTargetedMenuData()
                        
                        vc.isToViewMore = true
                        vc.sectionTitle = bannerItem.title
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(vc, animated: true)
                        //
                        //                var menu : Menu?
                        //                for _menu in TabsViewController.instance.titlearray{
                        //                    if _menu.targetPath == vc.pageContentResponse.info.path{
                        //                        menu = _menu
                        //                        break
                        //                    }
                        //                }
                        //                if menu != nil{
                        //                    TabsViewController.instance.showComponent(menu: menu!)
                        //                }
                    }
                    else if let vc = viewController as? PlayerViewController{
                        vc.delegate = self
                        vc.defaultPlayingItemUrl = bannerItem.imageUrl
                        vc.playingItemTitle = bannerItem.title
                        vc.playingItemSubTitle = bannerItem.subtitle
                        vc.playingItemTargetPath = bannerItem.target.path
                        AppDelegate.getDelegate().window?.addSubview(vc.view)
                    }
                    else if let vc = viewController as? DetailsViewController {
                        vc.navigationTitlteTxt = bannerItem.title
                        let topVC = UIApplication.topVC()!
                        topVC.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        if let vc = viewController as? ListViewController{
                            vc.isToViewMore = true
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
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            if  playerVC != nil{
                playerVC?.isNavigatingToBrowser = true
                playerVC?.showHidePlayerView(true)
                playerVC?.player.pause()
            }
            view1.urlString = bannerItem.target.path
            view1.pageString = bannerItem.title
            view1.viewControllerName = "ListViewController"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
        print("hi didSelectedBannerItem", bannerItem)*/
    }
    func showAlert(_ header : String = String.getAppName(),  message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
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
    
    
    // MARK: - Filter Delegate Methods
    func filterSelected(filterList:NSMutableArray, filter:Filter) {
        self.lastIndex = -1
        self.filterDic[filter.code] = filterList
        print(self.filterDic)
        var filterString = ""
        for (key, value) in self.filterDic {
            let filterCodeList = value as! NSMutableArray
            if filterCodeList.count > 0 {
                filterString = filterString + (filterString.count > 0 ? ";" : "") + key + ":"
                for filterCode in filterCodeList {
                    if filterCodeList.lastObject as! String == filterCode as! String {
                        filterString = "\(filterString)\(filterCode)"
                    }
                    else {
                        filterString = "\(filterString)\(filterCode),"
                    }
                }
            }
        }
        self.sections.removeAll()
        self.loadMoreData(filterString: filterString)
    }
    // MARK: - GADAdLoaderDelegate
    
    func addNativeAds() {
        
        if nativeAds.count <= 0 {
            return
        }
        var index = adInterval
        var rowVal = 0
        for _ in nativeAds {
            if index < self.sections.count {
                let cardData = Card.init()
                cardData.cardType = .ad_content
                cardData.adPositionIndex = rowVal
                self.sections.insert(cardData, at: index)
                index += 1
                rowVal = rowVal + 1
                index += adInterval
            } else {
                break
            }
        }
        
        if sections.count > 0 {
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
        self.moviesCollection.reloadData()
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
@available(iOS 10.0, *)
extension ListViewController: AssetPlaybackDelegate {
    func streamPlaybackManager(_ streamPlaybackManager: AssetPlaybackManager, playerReadyToPlay player: AVPlayer) {
        if let playerVC = playerVC {
            playerVC.delegate = self
            playerVC.defaultPlayingItemUrl = ""
            if playerVC.defaultPlayingItemView != nil {
                playerVC.defaultPlayingItemView.isHidden = true
            }
            playerVC.player.playerView.playerLayer.isHidden = false
            playerVC.view.tag = 142
            for subView in AppDelegate.getDelegate().window!.subviews {
                if subView.tag == 142 {
                    subView.removeFromSuperview()
                }
            }
            playerVC.stopAnimating()
            playerVC.stopAnimatingPlayer(playerVC.isMinimized)
            AppDelegate.getDelegate().window?.addSubview(playerVC.view)
            playerVC.player.playFromBeginning()
            self.stopAnimating()
        }
    }

    func streamPlaybackManager(_ streamPlaybackManager: AssetPlaybackManager,
                               playerCurrentItemDidChange player: AVPlayer) {
        if !enteredOnce {
            enteredOnce = true
            guard let playerViewController = playerVC, player.currentItem != nil else { return }
            GCKCastContext.sharedInstance().sessionManager.endSessionAndStopCasting(true)
            playerViewController.delegate = self
            playerViewController.isDownloadContent = true
            playerViewController.offLineDownloadAsset = self.asset
            playerViewController.loadVideo(urlString: (self.asset?.stream.playlistURL)!)
            playerViewController.playOfflineContent(self.asset!)
            playerViewController.player.avplayer = player
            playerViewController.addPlayerPeriodicObserver()
            playerViewController.player.addOfflineObservers()
            playerViewController.view.tag = 142
            for subView in AppDelegate.getDelegate().window!.subviews {
                if subView.tag == 142 {
                    subView.removeFromSuperview()
                }
            }
            playerViewController.stopAnimating()
            playerViewController.stopAnimatingPlayer(playerViewController.isMinimized)
            AppDelegate.getDelegate().window?.addSubview(playerViewController.view)
            self.stopAnimating()
        }
    }
}
extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)

        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}
