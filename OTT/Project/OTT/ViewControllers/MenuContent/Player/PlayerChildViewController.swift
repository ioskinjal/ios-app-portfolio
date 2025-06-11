//
//  playerSuggestionsVC.swift
//  sampleColView
//
//  Created by Ankoos on 27/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import PubNub
import OTTSdk
import GoogleMobileAds

protocol PlayerChildViewControllerDelegate {
    func didSelectedSuggestion(card : Card)
    func didSelectedOfflineSuggestion(stream : Stream)
    func openShareView()
    func StartParty()
    
}

class PlayerChildViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,tabMenuProtocal,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol,UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource, UITableViewDelegate,PlayerBarMenuProtocal,AttachmentHandlerDelegate,PNEventsListener,UserRatingViewProtocol,StartWatchPartyViewProtocol,StartWatchPartyConfirmationViewProtocol,GADBannerViewDelegate {
    
    
    @IBOutlet weak var collectionViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var noRelatedVideosLbl: UILabel!
    
    @IBOutlet weak var chatMessagestableView: UITableView!
    @IBOutlet weak var chatMessagestableViewLeftConstraint: NSLayoutConstraint?
    @IBOutlet weak var chatMessagestableViewRightConstraint: NSLayoutConstraint?

    @IBOutlet weak var suggestionCVTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatMessagesTableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorNoSuggestionTop: NSLayoutConstraint!
    var chatClient: PubNub!
    var reusableViewHeight :CGFloat = 120
    var cVL: CustomFlowLayout!
    var secInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    var cellSizes: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 113)
    var numColums: CGFloat = 1
    var interItemSpacing: CGFloat = 0
    var minLineSpacing: CGFloat = productType.iPad ? 20 : 14
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var tabMenuItemNumber:Int = 0
    var showLoginView:Bool = false
    var showHide:Bool = false
    var errorCode:Int = 0
    var targetPath = ""
    var bannerAdTag = ""
    var descLabelHeight = 0.0
    var playerHeight: CGFloat?
    var delegate : PlayerChildViewControllerDelegate?
    let chatPlaceHolderText = "Type anything…"
    @IBOutlet weak var suggestionsCV: UICollectionView!
    @IBOutlet weak var chatTxtAndBtnView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var chatMessageTxt: UITextField!
    @IBOutlet weak var chatMessageTxtView: UITextView!
    
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var cameraButton: UIButton!

    @IBOutlet weak var playerCouchScreenViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerCouchScreenView: UIView!
    
    var showdetailTableView = false
    var contentsArrayObj : [Any] = []
    var currentObj :Any!
    var sectionList = [Section]()
    var castInfo : Section?
    var sectionDataList = [Card]()
    var contentData:PageContentResponse?
    var goGetTheData:Bool = true
    var hasMoreData:Bool = false
    var isFavourite:Bool = false
    var showUserRatingView:Bool = false
    var isExpiryDataAvailable:Bool = false
    var userRatingVal:Int = 0
    var showTakeTestButton:Bool = false
    var enableTakeTestButton:Bool = false
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    var chatChannelId:String?
    var chatMessagesArr = [[String:Any]]()
    var isRecipe = false
//    var chatMessagesArr = [Question]()
    var chatMessagetextArr = [ChatMessageText]()
    var chatViewYPosition:CGFloat = 0.0
    var isLive:Bool = false
    var chatBackUpMinutes = -10
    var maxChatBackupminutes = -30
    var showWatchPartyMenu:Bool = false
    var showWatchPartyButton:Bool = false
    var downloadAsset : Asset?
    var isDownloaded:Bool = false
    var isOfflineContent = false
    var playlistURL = ""
    var analyticsMetaID = ""
    var downloadedStreamsList = [Stream]()

    var popUpBitRates = [[String : Any]]()
    fileprivate var selectedBitRate = 265_000

    
    var isBannerAdsReceived: Bool = false
    var bannerAdView : UIView?
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
            if self.chatClient != nil && self.chatChannelId != nil {
                self.chatClient.unsubscribeFromChannels([self.chatChannelId!], withPresence: true)
                self.chatClient.unsubscribeFromPresenceChannels([self.chatChannelId!])
                self.chatClient.removeListener(self)
                self.chatClient = nil
            }
        }
        
        func intisalizePubNub() {
            // Initialize and configure PubNub client instance
            let configuration = PNConfiguration(publishKey: appContants.pubNubPublishKey, subscribeKey: appContants.pubNubSubscribeKey)
            self.chatClient = PubNub.clientWithConfiguration(configuration)
            self.chatClient.addListener(self)
            
            // Subscribe to demo channel with presence observation
            if self.chatChannelId != nil {
                self.chatClient.subscribeToChannels([self.chatChannelId!], withPresence: true)
                self.chatClient.subscribeToPresenceChannels([self.chatChannelId!])
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.playerCouchScreenView != nil {
            self.playerCouchScreenView.isHidden = true
        }
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if appContants.appName == .gac {
            self.collectionViewLeftConstraint.constant = 0
            self.collectionViewRightConstraint.constant = 0
        } else {
        self.collectionViewLeftConstraint.constant = 5.0
        self.collectionViewRightConstraint.constant = -5.0
        }
        self.chatMessagestableViewLeftConstraint?.constant = 5.0
        self.chatMessagestableViewRightConstraint?.constant = -5.0
        if self.showLoginView {
            reusableViewHeight = reusableViewHeight + 109.0
        }
        self.showHide = true
        self.chatMessagestableView.register(UINib.init(nibName: ChatMessageTableViewCell.nibname, bundle: nil), forCellReuseIdentifier: ChatMessageTableViewCell.identifier)
        
        //        self.chatMessagestableView.register(UINib.init(nibName: ChatMessageWithAttacmentTableViewCell.nibname, bundle: nil), forCellReuseIdentifier: ChatMessageWithAttacmentTableViewCell.identifier)
        self.chatMessagestableView.backgroundColor = AppTheme.instance.currentTheme.chatTableBGView
        self.chatMessagestableView.dataSource = self
        self.chatMessagestableView.delegate = self
        self.chatMessageTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.chatMessageTxtView.text = self.chatPlaceHolderText
        //#warning
        //        self.showLoginView = true
        self.chatMessageTxt.delegate = self
        self.chatMessageTxtView.delegate = self
        self.noRelatedVideosLbl.text = "No suggestions found".localized
        self.noRelatedVideosLbl.textColor = AppTheme.instance.currentTheme.noContentAvailableTitleColor
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        suggestionsCV.dataSource = self
        suggestionsCV.delegate = self
        if #available(iOS 10.0, *) {
            self.downloadedStreamsList = AppDelegate.getDelegate().fetchStreamList()
        } else {
            // Fallback on earlier versions
        }
        if !self.isOfflineContent {
            self.isFavourite = (self.contentData?.pageButtons.isFavourite)!
            var selectIndex = 0
            for tabDetails in (self.contentData?.tabsInfo.tabs)! {
                if self.contentData?.tabsInfo.selectedTab == tabDetails.code {
                    self.tabMenuItemNumber = selectIndex
                }
                selectIndex = selectIndex + 1
            }
            self.loadData()
        }
        self.suggestionsCV.backgroundColor = .clear
            //AppTheme.instance.currentTheme.chatTableBGView

        suggestionsCV.register(UINib(nibName: "MenuBarReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuBarReusableView")
        if !self.isOfflineContent, (appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .reeldrama) || appContants.appName == .gac {
            if #available(iOS 10.0, *) {
                self.downloadedStreamsList = AppDelegate.getDelegate().fetchStreamList()
                StreamListManager.shared.streams = AppDelegate.getDelegate().fetchStreamList()
            }
            if let streams = StreamListManager.shared.streams {
                for stream in streams {
                    StreamListManager.shared.streamMap[stream.name] = stream
                }
            }
            if contentData != nil, let stream = StreamListManager.shared.stream(withName: (self.contentData?.shareInfo.name)!) {
                stream.playlistURL = self.playlistURL
                stream.name = (self.contentData?.shareInfo.name)!
                stream.subTitle = (self.contentData?.shareInfo.shareDescription)!
                stream.imageData = NSData.init(contentsOf: URL.init(string: (self.contentData?.shareInfo.imageUrl)!)!)
                stream.targetPath = (self.contentData?.info.path)!
                stream.analyticsMetaID = self.analyticsMetaID
                if #available(iOS 11.0, *) {
                    if let asset = AssetPersistenceManager.sharedManager.assetForStream(withName: stream.name) {
                        self.downloadAsset = asset
                    } else {
                        self.downloadAsset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: URL.init(string: self.playlistURL)!))
                    }
                }
            } else {
                let stream = Stream()
                stream.playlistURL = self.playlistURL
                stream.name = (self.contentData?.shareInfo.name)!
                stream.subTitle = (self.contentData?.shareInfo.shareDescription)!
                if self.contentData?.shareInfo.imageUrl.isEmpty == false {
                    stream.imageData = NSData.init(contentsOf: URL.init(string: (self.contentData?.shareInfo.imageUrl)!)!)
                }
                stream.targetPath = (self.contentData?.info.path)!
                stream.analyticsMetaID = self.analyticsMetaID
                if let user = OTTSdk.preferenceManager.user {
                    stream.userID = user.userId
                }
                if #available(iOS 11.0, *) {
                    if let asset = AssetPersistenceManager.sharedManager.assetForStream(withName: stream.name) {
                        self.downloadAsset = asset
                    } else {
                        if let url = URL.init(string: self.playlistURL){
                            self.downloadAsset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: url))
                        }
                    }
                }
            }
        }
        cVL = CustomFlowLayout()
        cVL.cellRatio = false
        cVL.secInset = secInsets
        cVL.cellSize = cellSizes
        cVL.interItemSpacing = (minLineSpacing/numColums) * (numColums-1)
        cVL.minLineSpacing = minLineSpacing
        cVL.scrollDir = scrollDir
        cVL.sectionHeadersPinToVisibleBounds = true
        numColums = productType.iPad ? 3 : 2
         
        if appContants.appName == .gac {
            self.showdetailTableView = true
        }
        
        self.calculateNumCols()
        cVL.setupLayout()
        suggestionsCV.collectionViewLayout = cVL
        self.suggestionsCV.isHidden = false
        self.suggestionsCV.reloadData()
        if self.playerCouchScreenViewTopConstraint != nil {
            self.playerCouchScreenViewTopConstraint.constant = reusableViewHeight
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPlayerCouchScreen), name: NSNotification.Name(rawValue: "ShowPlayerCouchScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidePlayerSuggestionView), name: NSNotification.Name(rawValue: "HidePlayerSuggestionView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTheAnimation), name: NSNotification.Name(rawValue: "StopAnimating"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadSuggestions), name: NSNotification.Name(rawValue: "ReloadSuggestions"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewTrasit), name: NSNotification.Name(rawValue: "ViewTransit"), object: nil)
        //        self.getSuggestedChannelsList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showChatMessageView), name: NSNotification.Name(rawValue: "ShowChatView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideChatMessageView), name: NSNotification.Name(rawValue: "HideChatView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleTakeTestButton(notification:)), name: NSNotification.Name(rawValue: "handleTakeTestButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideChatKeyBoard(notification:)), name: NSNotification.Name(rawValue: "hideChatKeyBoard"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        /*if self.isLive {
         self.chatMessagestableView.isHidden = false
         self.chatTxtAndBtnView.isHidden = false
         self.suggestionsCV.isHidden = false
         if !self.showLoginView {
         reusableViewHeight = reusableViewHeight - 60
         }
         else {
         reusableViewHeight = reusableViewHeight - 47
         }
         self.getChatHistory()
         }
         else {
         self.chatMessagestableView.isHidden = true
         self.chatTxtAndBtnView.isHidden = true
         self.suggestionsCV.isHidden = false
         }*/
        self.intisalizePubNub()
        self.getChatHistory()
        self.chatMessagestableView.isHidden = true
        self.chatTxtAndBtnView.isHidden = true
        self.suggestionsCV.isHidden = false
        
        secInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        interItemSpacing = 10
        minLineSpacing = productType.iPad ? 39 : 10
        Log(message: "\(self.suggestionsCV.frame)")
        if #available(iOS 11.0, *), let asset = self.downloadAsset, (appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .reeldrama) || appContants.appName == .gac {
            let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
            switch downloadState {
            case .downloaded:
                self.isDownloaded = true
            case .downloading:
                self.isDownloaded = false
            case .notDownloaded:
                self.isDownloaded = false
            }
        }
        // Do any additional setup after loading the view.
        self.isBannerAdsReceived = false
        self.loadBannerAd()
    }
    
    @objc func hideChatKeyBoard(notification: NSNotification) {
        self.HideKeyboardButtonClicked()
    }
    
    @objc func handleTakeTestButton(notification: NSNotification) {
        if let status = notification.userInfo?["showButton"] as? Bool {
            self.showTakeTestButton = status
            if status{
                reusableViewHeight = 140
            }
            else{
                self.reusableViewHeight = 135.0 - 60
            }
            if self.chatMessagesArr.count > 0 {
                reusableViewHeight = 180
            }
            self.chatMessagestableView.reloadData()
        }
        if let enable = notification.userInfo?["isEnabled"] as? Bool {
            self.enableTakeTestButton = enable
        }
    }
    
    func calculateMenuBarHeight() -> Int {
        var defaultHeight = 100
        if self.showUserRatingView == true {
            defaultHeight = defaultHeight + 50 + 15
        }
        
        if self.isExpiryDataAvailable == true {
            defaultHeight = defaultHeight + 18 + 6
        }
        //if self.showHide == true {
            defaultHeight = defaultHeight + Int(self.descLabelHeight)
        //}
        if self.showHide == false {
            if self.castInfo?.sectionData.data.count ?? 0 > 0 {
                 defaultHeight = defaultHeight + 100
            }
        }
        if self.showLoginView {
            defaultHeight = defaultHeight + 129
        }
        if self.showdetailTableView == true {
            defaultHeight = defaultHeight + 220 // for gac details Table View
        }
        if !isRecipe && appContants.appName == .gac{
            defaultHeight = defaultHeight - 66
        }
        defaultHeight = defaultHeight + 20
        return defaultHeight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if productType.iPad {
            self.chatViewYPosition = 275.0
        }
        else {
            self.chatViewYPosition = 200.0
        }
        self.view.translatesAutoresizingMaskIntoConstraints = false
        /*if self.isLive {
            self.chatMessagestableView.isHidden = false
            self.suggestionsCV.isHidden = true
        } else {*/
            //self.chatMessagestableView.isHidden = true
            /*if sectionDataList.count > 0 {
                suggestionsCV.reloadData()
                self.suggestionsCV.isHidden = false
                self.errorView.isHidden = true
            } else {
                self.suggestionsCV.isHidden = false
                self.errorView.isHidden = true
            }
            suggestionsCV.reloadData()*/
        if sectionDataList.count > 0 {
            self.didSelectedItem(item: tabMenuItemNumber)
        }
//        }
    }

    @objc func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            if productType.iPad {
                keyboardHeight = keyboardFrame.cgRectValue.height - 20
            }
            else{
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }

        self.chatViewYPosition = keyboardHeight
        AppDelegate.getDelegate().keyBoardShown = true

    }

    @objc func keyboardWillDisappear(notification: NSNotification?) {
        AppDelegate.getDelegate().keyBoardShown = false

    }
    @available(iOS 10.0, *)
    func saveStreamData() {
        var streamDic = [String:Any]()
        streamDic["title"] = self.contentData?.shareInfo.name
        streamDic["subTitle"] = self.contentData?.shareInfo.shareDescription
        streamDic["streamURL"] = self.playlistURL
        streamDic["imageData"] = NSData.init(contentsOf: URL.init(string: (self.contentData?.shareInfo.imageUrl)!)!)
        streamDic["targetPath"] = self.contentData?.info.path
        streamDic["analyticsMetaID"] = self.analyticsMetaID
        streamDic["downloaded_end_date"] = Date().timeIntervalSince1970 * 1000
        streamDic["downloaded_start_date"] = Date().timeIntervalSince1970 * 1000
        streamDic["bit_rate"] = "\(selectedBitRate)"
        streamDic["download_size"] = ""
        streamDic["video_download"] = false
        if let content = contentData {
            let (h, m, s) = (content.streamStatus.totalDurationInMillis.msToSeconds.hour, content.streamStatus.totalDurationInMillis.msToSeconds.minute, content.streamStatus.totalDurationInMillis.msToSeconds.second)
            if h > 0, m > 0, s > 0 {
                streamDic["video_duration"] = content.streamStatus.totalDurationInMillis.msToSeconds.hourMinuteSecondMS
            }else if m > 0, s > 0 {
                streamDic["video_duration"] =  content.streamStatus.totalDurationInMillis.msToSeconds.minuteSecondMS
            }else if s > 0 {
                streamDic["video_duration"] =  "\(s)sec"
            }else {
                streamDic["video_duration"] = ""
            }
        }
        AppDelegate.getDelegate().saveStream(streamDic)
    }
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return ((seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func getChatHistory() {
        //        self.client.logger.enabled = true
        //        self.client.logger.setLogLevel(PNLogLevel.PNVerboseLogLevel.rawValue)
        if self.chatChannelId != nil && self.chatClient != nil{
           // self.startAnimating(allowInteraction: true)
            self.chatClient.historyForChannel(self.chatChannelId!, start: NSNumber.init(value: Date().getTenMinutesBackTimeStamp(value: chatBackUpMinutes)), end: NSNumber.init(value: Date().getCurrentTimeStamp()), includeTimeToken: true) { (result, error) in
                if result != nil {
                    let chatDicArr = result?.data.messages as? [[String:Any]]
                    
                    if (chatDicArr?.count)! > 0 {
                        self.chatMessagesArr.append(contentsOf: chatDicArr!)
                        if self.chatMessagesArr.count > 0 {
                            self.errorView.isHidden = true
                            self.chatMessagestableView.reloadData()
                        }
                        else {
                            /*self.noRelatedVideosLbl.text = "No Messages Found".localized
                             if !self.showLoginView {
                             self.errorViewTopConstraint.constant = 170.0
                             }
                             else {
                             self.errorViewTopConstraint.constant = 250
                             }
                             self.errorView.isHidden = false*/
                        }
                        self.stopAnimating()
                    }
                    else {
                        self.chatBackUpMinutes = self.chatBackUpMinutes - 10
                        if self.chatBackUpMinutes >= self.maxChatBackupminutes {
                            self.getChatHistory()
                        }
                        else {
                            if self.chatMessagesArr.count > 0 {
                                self.errorView.isHidden = true
                                self.chatMessagestableView.reloadData()
                            }
                            /*else {
                             self.noRelatedVideosLbl.text = "No Messages Found".localized
                             if !self.showLoginView {
                             self.errorViewTopConstraint.constant = 170.0
                             }
                             else {
                             self.errorViewTopConstraint.constant = 250
                             }
                             self.errorView.isHidden = false
                             }*/
                            self.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    /*func getChatHistoryUsingApi() {
        self.startAnimating(allowInteraction: true)
        OTTSdk.userManager.fetchQuestions(path: self.targetPath, onSuccess: { (questionsArr) in
            self.stopAnimating()
            self.chatMessagesArr = questionsArr
            self.chatMessagetextArr.removeAll()
            for question in self.chatMessagesArr {
                var chatMessageObj = ChatMessageText()
                chatMessageObj.chatMessageStr = question.question
                self.chatMessagetextArr.append(chatMessageObj)
            }
            
            DispatchQueue.main.async {
                self.chatMessagestableView.reloadData()
                self.scrollToBottom()
            }
        }) { (error) in
            self.stopAnimating()
        }
    }*/

    func refreshData() {
        OTTSdk.mediaCatalogManager.pageContent(path: self.contentData!.info.path, onSuccess: { (response) in
            self.contentData = response
            self.sectionList.removeAll()
            
            /*let tempContentType = self.contentData?.info.attributes.contentType ?? "live"
            
            let tempChatSection = self.getStaticSection(code: "chatroom", contentType: tempContentType)
            self.sectionList.append(tempChatSection)*/
            
            for pageDataInfo in (self.contentData?.data)! {
                if pageDataInfo.paneType == .section {
                    let section = pageDataInfo.paneData as? Section
                    if (section?.sectionInfo.code == "grouplist_content_actors" ||  section?.sectionInfo.code == "playlist_content_actors" || section?.sectionInfo.code == "content_actors" || section?.sectionInfo.code == "movie_actors") { 
                        self.castInfo = section
                    }
                    else{
                        self.sectionList.append(section!)
                        self.loadData()
                    }
                }
            }
             
           /* if (tempContentType == "tvshowepisode" || tempContentType == "tvshow" || tempContentType == "movie") {
                let tempWatchPartySection = self.getStaticSection(code: "watchparty", contentType: tempContentType)
                self.sectionList.append(tempWatchPartySection)
            }*/
            
        }, onFailure: { (error) in
            self.stopAnimating()
        })

    }
    
    func loadData() {
        #warning("hardcoded menu index as per requirement")
        /* for (index, sectionObj) in sectionList.enumerated() {
            if sectionObj.sectionData.section == self.contentData?.tabsInfo.selectedTab && !(self.contentData?.tabsInfo.selectedTab .isEmpty ?? false) {
                self.tabMenuItemNumber = index
            }
        }*/
        self.tabMenuItemNumber = 0
         #warning("hardcoded menu index as per requirement")
        if contentData != nil {
            self.isFavourite = (self.contentData?.pageButtons.isFavourite)!
        }
        #warning("hard coded false value")
        //self.showUserRatingView = self.contentData?.pageButtons.feedback?.feedbackAllowed ?? false
        self.showUserRatingView = false
        self.isExpiryDataAvailable = false
        if self.contentData != nil {
            for pageData in self.contentData!.data {
                if pageData.paneType == .content {
                    let content = pageData.paneData as? Content
                    for dataRow in (content?.dataRows)! {
                        for element in dataRow.elements {
                            if element.elementType == .text {
                                if element.elementSubtype == "expiryInfo" && !(element.data .isEmpty) {
                                    self.isExpiryDataAvailable = true
                                    break
                                }
                            }
                        }
                    }
                    break
                }
            }
        }
        if ((self.contentData?.pageButtons.feedback?.userFeedbackRecord) != nil) {
            self.userRatingVal = self.contentData?.pageButtons.feedback?.userFeedbackRecord?.rating ?? 0           
        }
        else{
            self.userRatingVal = 0
        }
        if sectionList.count > 0 {
            self.sectionDataList = sectionList[tabMenuItemNumber].sectionData.data
            self.hasMoreData = sectionList[tabMenuItemNumber].sectionData.hasMoreData
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                self.didSelectedItem(item: self.tabMenuItemNumber)
            }
            errorView.isHidden = true
        }
        else{
            errorView.isHidden = true
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        if playerVC != nil {
            return true
        }
        return false
    }
        
    // MARK: - Collectionview methods
    func calculateNumCols() {
        if productType.iPad {
            if currentOrientation().portrait {
                numColums = 2
            } else if currentOrientation().landscape {
                numColums = 3
            } else {
                if self.view.frame.width > 1000.0 {
                    numColums = 4
                } else {
                    numColums = 3
                }
            }
            for card in sectionDataList {
                if card.cardType == .roller_poster {
                    if currentOrientation().portrait {
                        numColums = 5
                    } else if currentOrientation().landscape {
                        numColums = 7
                    }
                }else if card.cardType == .circle_poster || card.cardType == .square_poster{
                    if currentOrientation().portrait {
                        numColums = 4
                    } else if currentOrientation().landscape {
                        numColums = 5
                    }
                }else if card.cardType == .sheet_poster {
                    if currentOrientation().portrait {
                        numColums = 3
                    } else if currentOrientation().landscape {
                        numColums = 4
                    }else {
                        numColums = 3
                    }
                }
                else {
                    if currentOrientation().portrait {
                        numColums = 2
                    } else if currentOrientation().landscape {
                        numColums = 3
                    } else {
                        if self.view.frame.width > 1000.0 {
                            numColums = 4
                        } else {
                            numColums = 3
                        }
                    }
                }
            }
        } else {
            if currentOrientation().portrait {
                numColums = 3
            } else if currentOrientation().landscape {
                numColums = 5
            }
            for card in sectionDataList {
                if card.cardType == .roller_poster {
                    if currentOrientation().portrait {
                        numColums = 3
                    } else if currentOrientation().landscape {
                        numColums = 5
                    }
                }
                else if card.cardType == .sheet_poster {
                    numColums = 2
                }else if card.cardType == .circle_poster || card.cardType == .square_poster{
                    numColums = 3
                }
                else {
                    numColums = 2
                }
            }
        }
        
        cVL.numberOfColumns = numColums
        Log(message: "numColums: \(self.numColums)")
    }

    func setCvFrm() -> Void {
        if scrollDir == .horizontal {
            //            let htCnstr: CGFloat = secInsets.top + secInsets.bottom + cellSizes.height + 20
            //            cVHtCnstr.constant = htCnstr
            //            print("htCnstr", htCnstr)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if section == 0 {
            if self.isBannerAdsReceived == true && self.bannerAdView != nil {
                return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 20.0)
            }
            else {
                return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            }
        }
        else {
            if productType.iPad {
                return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 0.0)
            }
            return secInsets
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            if self.isBannerAdsReceived == true && self.bannerAdView != nil {
                return 1
            }
            else {
                return 0
            }
        }
        else {
            if self.isOfflineContent {
                if self.downloadedStreamsList.count == 0 {
                    self.errorNoSuggestionTop.constant = self.errorNoSuggestionTop.constant + 50
                }
                return self.downloadedStreamsList.count
            }
            if self.sectionDataList.count == 0 {
                self.errorNoSuggestionTop.constant = self.errorNoSuggestionTop.constant + 50
            }
            return self.sectionDataList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        Log(message: "rendering cell: \(indexPath.item)")
        
        if indexPath.section == 0 {
            collectionView.register(UINib(nibName: PlayerBannerAdCell.nibname, bundle: nil), forCellWithReuseIdentifier: PlayerBannerAdCell.identifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerBannerAdCell.identifier, for: indexPath) as! PlayerBannerAdCell
            cell.backgroundColor = .clear
            if self.bannerAdView != nil {
                cell.addSubview(self.bannerAdView!)
            }
            return cell
        }
        else {
            
            if self.sectionDataList.count > 0
            {
                let sectionCard = self.sectionDataList[indexPath.item]
                if sectionCard.cardType == .roller_poster {
                    let cardDisplay = sectionCard.display
                    
                    collectionView.register(UINib(nibName: RollerPosterGV.nibname, bundle: nil), forCellWithReuseIdentifier: RollerPosterGV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterGV.identifier, for: indexPath) as! RollerPosterGV
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "potrait")
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.expiryInfoLbl.text = ""
                    cell.expiryInfoLbl.isHidden = true
                    cell.gradientImageView.isHidden = true
                    cell.watchedProgressView.isHidden = true
                    cell.leftOverTimeLabel.isHidden = true
                    cell.leftOverLabelHeightConstraint.constant = 0.0
                    cell.tagLbl.isHidden = true
                    cell.tagImgView.isHidden = true

                    for marker in cardDisplay.markers {
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
                            if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4){
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
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else if sectionCard.cardType == .channel_poster || sectionCard.cardType == .overlay_poster {
                    let cardDisplay = sectionCard.display
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
                    
                    let height = (productType.iPad ? 93 : 73)
                    cell.imagViewWidthConstraint.constant = CGFloat(height * 16/9)
                    cell.imageViewHeightConstraint.constant = CGFloat(height)
                    
                    cell.watchedProgressView.isHidden = true
                    cell.badgeLbl.isHidden = true
                    cell.badgeImgView.isHidden = true
                    cell.liveTagLbl.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    cell.badgeSubLbl.isHidden = true
                    cell.badgeSubLbl.text = ""
                    //                cell.nowPlayingHeightConstraint.constant = 0.0
                    if sectionCard.display.markers.count > 0 {
                        for marker in sectionCard.display.markers {
                            if marker.markerType == .seek {
                                cell.watchedProgressView.isHidden = false
                                cell.watchedProgressView.progress = Float.init(marker.value)!
                                cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                                //                            cell.watchedProgressView.progress = 0.0
                                //                            cell.watchedProgressView.isHidden = true
                            }
                            else if marker.markerType == .special && marker.value == "now_playing" {
                                cell.nowPlayingStrip.isHidden = false
                                //                            cell.nowPlayingHeightConstraint.constant = 15.0
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
                            }
                            else if marker.markerType == .badge {
                                cell.liveTagLbl.isHidden = false
                                cell.liveTagLbl.text = marker.value
                                cell.liveTagLbl.sizeToFit()
                                cell.liveTagLblWidthConstraint.constant = (cell.liveTagLbl.frame.size.width + 20) < cell.frame.size.width ? cell.liveTagLbl.frame.size.width + 20 : cell.frame.size.width
                                cell.liveTagLbl.backgroundColor = UIColor.init(hexString: marker.bgColor)
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
                            }
                        }
                    }
                    //                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    //                cell.cornerDesignForCollectionCell()
                    return cell
                    
                }
                else if sectionCard.cardType == .band_poster {
                    collectionView.register(UINib(nibName: BandPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: BandPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandPosterCellLV.identifier, for: indexPath) as! BandPosterCellLV
                    let cardInfo = sectionCard.display
                    cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.desc.text = cardInfo.title
                    cell.name.text = cardInfo.subtitle1
                    cell.visulEV.blurRadius = 5
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    for marker in cardInfo.markers {
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
                            if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    return cell
                }
                else if sectionCard.cardType == .sheet_poster {
                    
                    if productType.iPad {
                        collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                        let cardInfo = sectionCard.display
                        cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                        cell.name.text = cardInfo.title
                        cell.desc.text = cardInfo.subtitle1
                        cell.watchedProgressView.isHidden = true
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
                        cell.episodeMarkupTagView.isHidden = true
                        for marker in cardInfo.markers {
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
                                if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                    cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                    cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                }
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
                            else if (marker.markerType == .duration || marker.markerType == .leftOverTime) && !(marker.value .isEmpty) {
                                cell.durationLabel.isHidden = false
                                cell.durationLabel.backgroundColor = UIColor.init(hexString: marker.bgColor)
                                cell.durationLabel.text = marker.value
                                cell.durationLabel.sizeToFit()
                                cell.durationLabel.textColor = UIColor.init(hexString: marker.textColor)
                                if marker.markerType == .leftOverTime {
                                    cell.durationLblWidthConstraint.constant = cell.durationLabel.frame.size.width + 8.0
                                }
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
                        //                cell.imageView.layer.cornerRadius = 5.0
                        if appContants.appName != .aastha {
                            cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                        }
                        
                        //                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                        //                    let tempHeight = tempWidth * 0.5625
                        //                    cell.imageViewHeightConstraint.constant = tempHeight
                        cell.cornerDesignForCollectionCell()
                        return cell
                        
                    } else {
                        
                        collectionView.register(UINib(nibName: SheetPosterCellGV.nibname, bundle: nil), forCellWithReuseIdentifier: SheetPosterCellGV.identifier)
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SheetPosterCellGV.identifier, for: indexPath) as! SheetPosterCellGV
                        let cardInfo = sectionCard.display
                        cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                        cell.name.text = cardInfo.title
                        cell.desc.text = cardInfo.subtitle1
                        cell.watchedProgressView.isHidden = true
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
                        cell.episodeMarkupTagView.isHidden = true
                        for marker in cardInfo.markers {
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
                                if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                    cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                    cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                }
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
                        //                cell.imageView.layer.cornerRadius = 5.0
                        if appContants.appName != .aastha {
                            cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                        }
                        let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                        let tempHeight = tempWidth * 0.5625
                        cell.imageViewHeightConstraint.constant = tempHeight
                        cell.cornerDesignForCollectionCell()
                        return cell
                    }
                }
                else if sectionCard.cardType == .common_poster {
                    if productType.iPad {
                        collectionView.register(UINib(nibName: SearchCommonPosterCellLViPad.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLViPad.identifier)
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLViPad.identifier, for: indexPath) as! SearchCommonPosterCellLViPad
                        cell.imageView.loadingImageFromUrl(sectionCard.display.imageUrl, category: "tv")
                        cell.name.text = sectionCard.display.title
                        cell.desc.text = sectionCard.display.subtitle1
                        cell.subDesc.text = sectionCard.display.subtitle2
                        
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        for marker in sectionCard.display.markers {
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
                                if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
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
                        if sectionCard.display.markers.count == 0 {
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
                        cell.imageView.loadingImageFromUrl(sectionCard.display.imageUrl, category: "tv")
                        cell.name.text = sectionCard.display.title
                        cell.desc.text = sectionCard.display.subtitle1
                        cell.subDesc.text = sectionCard.display.subtitle2
                        
                        //            var dotWidthConstraint : NSLayoutConstraint?
                        //            for constraint in cell.redDotView.constraints as [NSLayoutConstraint] {
                        //                if constraint.identifier == "dotWidthConstraint" {
                        //                    dotWidthConstraint = constraint
                        //                }
                        //            }
                        //            dotWidthConstraint?.constant = 0
                        
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        for marker in sectionCard.display.markers {
                            if marker.markerType == .badge {
                                cell.viewWithTag(1)?.isHidden = false
                                if cell.nameXPositionConstraint != nil {
                                    cell.nameXPositionConstraint.constant = 9.0
                                }
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
                                if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
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
                        if sectionCard.display.markers.count == 0 {
                            cell.viewWithTag(1)?.isHidden = true
                        }
                        else {
                            cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                        }
                        return cell
                    }
                }
                else if sectionCard.cardType == .box_poster {
                    collectionView.register(UINib(nibName: BoxPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: BoxPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellLV.identifier, for: indexPath) as! BoxPosterCellLV
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon .isEmpty {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.name.text = cardInfo.title
                    cell.desc.text = cardInfo.subtitle1
                    
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    for marker in cardInfo.markers {
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
                            if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    return cell
                }
                else if sectionCard.cardType == .pinup_poster {
                    collectionView.register(UINib(nibName: PinupPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: PinupPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinupPosterCellLV.identifier, for: indexPath) as! PinupPosterCellLV
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon.isEmpty {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.name.text = cardInfo.subtitle1
                    cell.desc.text = cardInfo.title
                    return cell
                }
                else if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster {
                    collectionView.register(UINib(nibName: LivePosterLV.nibname, bundle: nil), forCellWithReuseIdentifier: LivePosterLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePosterLV.identifier, for: indexPath) as! LivePosterLV
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon.isEmpty && (cardInfo.parentIcon.contains("https") || cardInfo.parentIcon.contains("http")) {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.markerLbl.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    
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
                            if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    cell.imageView.layer.cornerRadius = 4.0
                    cell.name.text = cardInfo.title
                    if cardInfo.parentName .isEmpty {
                        cell.desc.text = cardInfo.subtitle1
                    }
                    else {
                        cell.desc.text = cardInfo.parentName
                    }
                    cell.layer.cornerRadius = 5.0
                    return cell
                }
                else {
                    collectionView.register(UINib(nibName: RollerPosterLV.nibname, bundle: nil), forCellWithReuseIdentifier: RollerPosterLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterLV.identifier, for: indexPath) as! RollerPosterLV
                    return cell
                }
                
            }
            else
            {
                if self.isOfflineContent {
                    collectionView.register(UINib(nibName: "SheetPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellLV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellLV", for: indexPath) as! SheetPosterCellLV
                    if #available(iOS 11.0, *) {
                        let stream = self.downloadedStreamsList[indexPath.row]
                        let asset = Asset.init(stream: stream, urlAsset: AVURLAsset.init(url: URL.init(string: stream.playlistURL)!))
                        cell.name.text = stream.name
                        cell.desc.text = stream.subTitle
                        cell.asset = asset
                        cell.imageView.image = UIImage.init(data: stream.imageData! as Data)
                        cell.imageView.layer.cornerRadius = 5.0
                        cell.deleteBtn.tag = indexPath.row
                        cell.deleteBtn.isHidden = true
                    } else {
                        // Fallback on earlier versions
                    }
                    cell.layer.cornerRadius = 5.0
                    return cell
                    
                }
                //tvshows or episodes
                collectionView.register(UINib(nibName: PinupPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: PinupPosterCellLV.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinupPosterCellLV.identifier, for: indexPath) as! PinupPosterCellLV
                return cell
            }
            
        }
    }
    
    
  
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cvheader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBarReusableView", for: indexPath) as! MenuBarReusableView
       
        let tempContentType = self.contentData?.info.attributes.contentType ?? "live"
        cvheader.isDownloaded = self.isDownloaded
        cvheader.errorCode = self.errorCode
        cvheader.titlearray = sectionList
        cvheader.showLoginView = self.showLoginView
        cvheader.isRecipe = self.isRecipe
        cvheader.downloadButton = contentData != nil ? (self.contentData?.pageButtons.downloadOptions.showDownload)! : false
        cvheader.favButton = contentData != nil ? (self.contentData?.pageButtons.showFavouriteButton)! : false
        cvheader.shareButton = contentData != nil ? (self.contentData?.shareInfo.isSharingAllowed)! : false
        cvheader.isFav = self.isFavourite
        cvheader.showhide = self.showHide
        cvheader.showWatchPartyButton = self.showWatchPartyButton
        cvheader.contentType = tempContentType
        cvheader.castInfo = self.castInfo
        cvheader.showFav = contentData != nil ? (self.contentData?.pageButtons.showFavouriteButton)! : false
        cvheader.showUserRatingView = self.showUserRatingView
        cvheader.userRatingVal = self.userRatingVal
        cvheader.setupViews()
        cvheader.tabMenuDelegate = self
        cvheader.asset = self.downloadAsset
        cvheader.playerHeight = self.playerHeight
        if appContants.appName == .gac {
            cvheader.ShowHideDescriptionButton?.isHidden = true
            cvheader.downloadBtn.isHidden = true
            cvheader.showHideClicked()
            cvheader.contentDetailResponse = self.contentData
        }
        if self.isOfflineContent {
            cvheader.loadOfflinePlayerItemDetails()
        } else {
            cvheader.showFav = (self.contentData?.pageButtons.showFavouriteButton)!
            if (self.contentData?.info.attributes.isLive ?? true) == true {
                cvheader.showDownload  = false
            }
            else {
            cvheader.showDownload  = true// (self.contentData?.pageButtons.downloadOptions.showDownload)!
            }
            cvheader.setupPlayerItemView(obj: self.contentData!)
        }
//        cvheader.setupPlayerItemView(obj: self.contentData!)
        cvheader.tabIndex = tabMenuItemNumber
        cvheader.setIndexTabCell(index:tabMenuItemNumber)
        return cvheader
        
           
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            let tempHeight = (self.calculateMenuBarHeight())
            
            return CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(tempHeight))
        }
        else {
            return CGSize.init(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        else {
            if self.isOfflineContent {
                self.startAnimating(allowInteraction: false)
                self.delegate?.didSelectedOfflineSuggestion(stream: self.downloadedStreamsList[indexPath.row])
                return
            }
            Log(message: "playesugestions VC \(indexPath)")
            let cardObj = self.sectionDataList[indexPath.item]
            //        var userID = OTTSdk.preferenceManager.user?.email
            //        if userID != nil && (userID? .isEmpty)! {
            //            userID = OTTSdk.preferenceManager.user?.phoneNumber
            //        }
            //        else {
            //            userID = "NA"
            //        }
            //        let attributes = ["User ID":userID,"TimeStamp":"\(Int64(Date().timeIntervalSince1970 * 1000))","Show Name":cardObj.display.title]
            //        LocalyticsEvent.tagEventWithAttributes("\(AppDelegate.getDelegate().taggedScreen)>Section>\(sectionList[tabMenuItemNumber].sectionInfo.name)", attributes as! [String : String])
            self.startAnimating(allowInteraction: false)
            if playerVC == nil {
                self.hidePlayerSuggestionView()
            }
            if productType.iPad {
                //            self.suggestionsCV.isHidden = true
            }
            AppDelegate.getDelegate().isFromPlayerPage = true
            self.delegate?.didSelectedSuggestion(card: cardObj)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(2000)) {
                self.stopAnimating()
            }
            
            /*
             TargetPage.getTargetPageObject(path: cardObj.target.path) { (viewController, pageType) in
             self.stopAnimating()
             let topVC = UIApplication.topVC()!
             topVC.navigationController?.pushViewController(viewController, animated: true)
             }
             */
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if self.isBannerAdsReceived == true && self.bannerAdView != nil {
                return CGSize(width: 333, height: 250)
            }
            else {
                return CGSize(width: 0, height: 0)
            }
        }
        else {
            if self.isOfflineContent {
                if productType.iPad {
                    return CGSize(width: 360, height: 73)
                }
                return CGSize(width: 333, height: 83)
            }
            let sectionCard = self.sectionDataList[indexPath.item]
            
            if sectionCard.cardType == .roller_poster {
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 1.5
                return CGSize(width: tempWidth, height: tempHeight + 32.0)
                
            }
            else if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster{
                return CGSize(width: 333, height: 73)
            } else if sectionCard.cardType == .sheet_poster {
                if productType.iPad {
                    return CGSize(width: 179 * 1.3, height: 152 * 1.2)
                }
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 0.5625
                if productType.iPad {
                    return CGSize(width: tempWidth - 10, height: tempHeight + 52.0)
                }
                if appContants.appName == .gac {
                    return CGSize(width: tempWidth, height: tempHeight + 52.0 + 25)

                }
                return CGSize(width: tempWidth, height: tempHeight + 52.0)
            }
            else if sectionCard.cardType == .channel_poster || sectionCard.cardType == .overlay_poster {
                if productType.iPad {
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)!/numColums) - 20.0
                    return CGSize(width: tempWidth, height: 73.0)
                } else{
                    let tempWidth = (AppDelegate.getDelegate().window?.frame.size.width)! - 20.0
                    return CGSize(width: tempWidth, height: 73.0)
                }
            }
            else {
                if productType.iPad {
                    return CGSize(width: 360, height: 73)
                }
                return CGSize(width: 333, height: 73)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }
        else {
            if indexPath.row + 1 == self.sectionDataList.count
            {
                if self.goGetTheData {
                    self.goGetTheData = false
                    for pageData in (contentData?.data)! {
                        if pageData.paneType == .section {
                            let section = pageData.paneData as? Section
                            if section?.sectionData.section == sectionList[tabMenuItemNumber].sectionInfo.code {
                                if self.hasMoreData {
                                    self.loadNextSectionContent(section: section!)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    
    func loadNextSectionContent(section:Section) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.mediaCatalogManager.sectionContent(path: (self.contentData?.info.path)!, code: section.sectionInfo.code, offset: section.sectionData.lastIndex, count: nil, filter: nil, onSuccess: { (response) in
            self.stopAnimating()
            if response.count > 0 {
                self.hasMoreData = (response.first?.hasMoreData)!
                if (response.first?.data.count)! > 0 {
                    
                    for card in (response.first?.data)! {
                        self.sectionDataList.append(card)
                    }
                    self.suggestionsCV.reloadData()
                    self.goGetTheData = true
                }
            }
        }) { (error) in
            self.stopAnimating()
            Log(message: error.message)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if (coordinator as UIViewControllerTransitionCoordinator?) != nil {
            suggestionsCV.collectionViewLayout.invalidateLayout()
            printLog(log: UIDevice.current.orientation as AnyObject)
            if productType.iPad {
                self.calculateNumCols()
            }
            self.suggestionsCV.reloadData()
        }
    }
    
    @objc func viewTrasit() {
        if productType.iPad {
            suggestionsCV.collectionViewLayout.invalidateLayout()
            printLog(log: UIDevice.current.orientation as AnyObject)
            self.calculateNumCols()
            self.suggestionsCV.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //        var sectionHeaderHeight:CGFloat = 0.0
        //        if self.showLoginView {
        //            if self.showHide {
        //                sectionHeaderHeight = 290.0;
        //            }
        //            else {
        //                sectionHeaderHeight = 200.0;
        //            }
        //        }
        //        else {
        //            if self.showHide {
        //                sectionHeaderHeight = reusableViewHeight - 50.0;
        //            }
        //            else {
        //                sectionHeaderHeight = 80.0;
        //            }
        //        }
        //        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        //            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        //        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        //            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        suggestionsCV.collectionViewLayout.invalidateLayout()
        printLog(log: UIDevice.current.orientation as AnyObject)
        if productType.iPad {
            self.calculateNumCols()
        }
        //        self.suggestionsCV.reloadData()
        self.suggestionsCV.layoutIfNeeded()
    }
    
    @IBAction func couchOkBtnClicked(_ sender: Any) {
        if self.playerCouchScreenView != nil {
        self.playerCouchScreenView.isHidden = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HidePlayerCouchScreen"), object: nil, userInfo: nil)
//        playerVC?.hideCouchScreen()
    }
    
    @objc func showPlayerCouchScreen() {
        if self.playerCouchScreenView != nil {
        self.playerCouchScreenView.isHidden = false
        }
//        playerVC?.showCouchScreen()
    }
    
    @objc func recordBtnClicked(sender:UIButton) {
        let programData = self.sectionDataList[sender.tag]
        
        let vc = ProgramRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = 0
        vc.rowIndex = sender.tag
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
        
    }
    
    @objc func stopRecordBtnClicked(sender:UIButton) {
        let programData = self.sectionDataList[sender.tag]
        
        let vc = ProgramStopRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = 0
        vc.rowIndex = sender.tag
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }
    
    @objc func hidePlayerSuggestionView() {
        self.suggestionsCV.isHidden = true
        /*if playerVC != nil {
            if playerVC?.playerHolderView != nil {
                playerVC?.playerHolderView.isHidden = true
            }
        }*/
    }
    
    @objc func stopTheAnimation() {
        self.stopAnimating()
    }
    
    @objc func reloadSuggestions() {
        self.chatMessagesTableTopConstraint.constant = 0
        self.view.endEditing(true)
        self.suggestionsCV.performBatchUpdates({
            // modify here the collection view
            // eg. with: collectionView.insertItems
            // or: collectionView.deleteItems
        }) { (success) in
            self.suggestionsCV.reloadItems(inSection: 0)
        }
    }
   
        // MARK: - Table View Delegates
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chatMessagesArr.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.identifier) as! ChatMessageTableViewCell
        cell.backgroundColor = UIColor.clear
        let chatMessageDic = self.chatMessagesArr[indexPath.row]
        cell.chatUsername.text = chatMessageDic["sender"] as? String
        cell.chatUserMessage.text = chatMessageDic["message"] as? String
        cell.chatUserMessage.isHidden = true
        cell.chatUserMessageTxtView.text = chatMessageDic["message"] as? String
        cell.chatUserMessageTxtView.delegate = self
        cell.chatUserMessageTxtView.autoresizingMask = UIView.AutoresizingMask.flexibleBottomMargin
        cell.chatUserMessage.backgroundColor = UIColor.clear
        cell.chatUserMessageTxtView.backgroundColor = UIColor.clear
        cell.chatUserMessageTxtView.setContentOffset(CGPoint(x: 0, y: 10), animated: false)
        cell.chatUsername.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        cell.chatDateTimeLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        cell.chatUserMessage.textColor = cell.chatUsername.textColor
        cell.chatUserMessageTxtView.textColor = cell.chatUsername.textColor
        cell.chatSeperatorLbl.backgroundColor = AppTheme.instance.currentTheme.myQuestionsCellBorderColor
        cell.chatDateTimeLbl.font = UIFont.ottRegularFont(withSize: 10)
        cell.chatUsername.font = UIFont.ottBoldFont(withSize: 11)
        if chatMessageDic["timetoken"] != nil {
            if let timeToken = chatMessageDic["timetoken"] as? NSNumber {
                let timeTokenStr = NSString.init(string: "\(timeToken)").substring(to: 10)
                cell.chatDateTimeLbl.text = self.getChatDate(unixdate: Int(timeTokenStr)!)
            }
            else if let timeToken = chatMessageDic["timetoken"] as? String {
                let timeTokenStr = NSString.init(string: "\(timeToken)").substring(to: 10)
                cell.chatDateTimeLbl.text = self.getChatDate(unixdate: Int(timeTokenStr)!)
            }
        }
        if let messageDic = chatMessageDic["message"] as? [String:Any]{
            cell.chatUsername.text = messageDic["sender"] as? String
            cell.chatUserMessage.text = messageDic["message"] as? String
            cell.chatUserMessageTxtView.text = messageDic["message"] as? String
        }
        /*
         cell.chatUserIcon.image = #imageLiteral(resourceName: "appLogo")
         cell.chatUserIcon.clipsToBounds = true
         cell.chatUserIcon.layer.borderWidth = 1
         cell.chatUserIcon.layer.cornerRadius = cell.chatUserIcon.frame.size.width/2.0
         cell.chatUserIcon.layer.borderColor = UIColor.init(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0).cgColor
         cell.chatUserIcon.layer.masksToBounds = true
         */
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatMessageDic = self.chatMessagesArr[indexPath.row]
        let chatMsg =  chatMessageDic["message"] as? String
        return CGFloat(getLabelHeight(labelText: chatMsg ?? "") + 60)
    }
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessageObj = self.chatMessagesArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageWithAttacmentTableViewCell.identifier) as! ChatMessageWithAttacmentTableViewCell
        let chatMessageTextObj = self.chatMessagetextArr[indexPath.row]
        let timeTokenStr = NSString.init(string: "\(chatMessageObj.postedTime)").substring(to: 10)
        cell.chatUsername.text = self.getDate(unixdate: Int(timeTokenStr)!)
        cell.chatUsername.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
        cell.chatUserMessageTxtView.text = chatMessageTextObj.chatMessageStr
        if chatMessageTextObj.chatMessageStr .isEmpty {
            cell.chatUserMessageTxtViewHeightConstraint.constant = 0.0
        } else {
            cell.chatUserMessageTxtViewHeightConstraint.constant = chatMessageTextObj.messageHeight
        }
        cell.chatUserMessageTxtView.font = UIFont.ottRegularFont(withSize: 12.0)
        cell.chatUserMessageTxtView.delegate = self
        cell.chatUserMessageTxtView.backgroundColor = AppTheme.instance.currentTheme.chatTextBGView
        cell.chatUserMessageTxtView.textColor = cell.chatUsername.textColor
        cell.attachmentImage.sd_setImage(with: URL(string: chatMessageObj.attachmentPath), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
        
        if chatMessageObj.hasAttachment {
            cell.attachmentIcon.isHidden = true
            cell.attachmentImage.isHidden = false
            cell.attachmentImageViewHeightConstraint.constant = 100.0
        } else {
            cell.attachmentIcon.isHidden = true
            cell.attachmentImage.isHidden = true
            cell.attachmentImageViewHeightConstraint.constant = 0.0
        }
        cell.attachmentImage.layer.cornerRadius = 5.0
        cell.attachmentImage.layer.borderColor = UIColor.white.cgColor
        cell.attachmentImage.layer.borderWidth = 3.0
        cell.atachmentButton.tag = indexPath.row
        cell.atachmentButton.addTarget(self, action: #selector(self.handleAttachmentClick(_:)), for: UIControl.Event.touchUpInside)
        var inputString = ""
        var messageType = ""
        if chatMessageObj.status == 0 || chatMessageObj.status == 1 || chatMessageObj.status == 2 || chatMessageObj.status == 3 || chatMessageObj.status == 4 {
            inputString = "Delivered"
            messageType = "message_delivered"
        } /*else if chatMessageObj.status == 2 {
            inputString = "Approved"
            messageType = "message_approved"
        } else if chatMessageObj.status == 3 {
            inputString = "Rejected"
            messageType = "message_rejected"
        } */else if chatMessageObj.status == 5 {
            inputString = "Not Delivered"
            messageType = "message_rejected"
        } else {
            inputString = ""
            messageType = ""
        }
        cell.chatDateTimeLbl.textAlignment = .right
        cell.chatDateTimeLbl.attributedText = self.getAttributedText(inputString: inputString, messageType: messageType)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }*/
       
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//          let chatMessageTextObj = self.chatMessagetextArr[indexPath.row]
//          let chatMessageObj = self.chatMessagesArr[indexPath.row]
////          if chatMessageObj.hasAttachment {
////              return chatMessageTextObj.messageHeight + 170.0
////          }
//          return chatMessageTextObj.messageHeight + 80.0
//      }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gac  || appContants.appName == .reeldrama {
            return 0
        }
        return CGFloat(self.calculateMenuBarHeight())
        //        var tempHeight = reusableViewHeight
        //        if self.showUserRatingView {
        //            tempHeight = tempHeight + 50
        //        }
        //        return tempHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .reeldrama  || appContants.appName == .gac {
            return nil
        }
        /*let header = Bundle.main.loadNibNamed("PlayerMenuBar", owner: self, options: nil)?.first as! PlayerMenuBar
         header.playerBarMenuDelegate = self
         header.backgroundColor = .clear
         header.showLoginView = self.showLoginView
         header.setupViews()
         header.isFav = self.isFavourite
         header.showhide = self.showHide
         header.showTestButton = self.showTakeTestButton
         header.enableTestButton = self.enableTakeTestButton
         header.showQuestionsInfo = (self.chatMessagesArr.count > 0 ? true : false)
         header.showFav = (self.contentData?.pageButtons.showFavouriteButton)!
         header.setupPlayerItemView(obj: self.contentData!)*/
        
        
        let cvheader = Bundle.main.loadNibNamed("MenuBarReusableView", owner: self, options: nil)?.first as! MenuBarReusableView
        
        //            let cvHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBarReusableView", for: indexPath) as! MenuBarReusableView
        let tempContentType = self.contentData?.info.attributes.contentType ?? "live"
        
        cvheader.errorCode = self.errorCode
        cvheader.titlearray = sectionList
        cvheader.showLoginView = self.showLoginView
        cvheader.isFav = self.isFavourite
        cvheader.showhide = self.showHide
        cvheader.showWatchPartyButton = self.showWatchPartyButton
        cvheader.castInfo = self.castInfo
        cvheader.contentType = tempContentType
        cvheader.showFav = (self.contentData?.pageButtons.showFavouriteButton)!
        cvheader.showUserRatingView = self.showUserRatingView
        cvheader.userRatingVal = self.userRatingVal
        //cvheader.setupPlayerItemView(obj: self.contentData!)
        cvheader.setupViews()
        cvheader.tabMenuDelegate = self
        cvheader.setupPlayerItemView(obj: self.contentData!)
        cvheader.tabIndex = tabMenuItemNumber
        cvheader.setIndexTabCell(index:tabMenuItemNumber)
        return cvheader
        
        
        //return header
    }
    
  
    
    /*@objc func handleAttachmentClick(_ sender:UIButton) {
        let chatMessageObj = self.chatMessagesArr[sender.tag]
        if chatMessageObj.hasAttachment {
            if playerVC != nil {
                playerVC?.player.pause()
                playerVC?.isNavigatingToBrowser = true
//                if playerVC?.playBtn != nil {
//                    playerVC?.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
//                }
            }
            let attachmentVC = AttachmentViewController.init(nibName: "AttachmentViewController", bundle: nil)
            attachmentVC.attachmentImagePath = chatMessageObj.attachmentPath
            self.present(attachmentVC, animated: true, completion: nil)
        }
    }*/
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        // MARK: - UITextField Delegates methods
        
        @objc private func textFieldDidChange(_ textField: UITextField) {
            
    //        if (textField.text?.characters.count)! > 38 {
    //            textField.text = "\((textField.text)!)\n"
    //            var newFrame = textField.frame
    //            newFrame.size.height = textField.frame.size.height + 30.0
    //            self.view.frame.origin.y = self.view.frame.origin.y - 30.0
    //            textField.frame = newFrame;
    //        }
    //        let fixedWidth = textField.frame.size.width
    //        textField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        let newSize = textField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        var newFrame = textField.frame
    //        newFrame.size.height = newSize.height
    //        textField.frame = newFrame;
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.view.frame.origin.y = -(self.chatViewYPosition)
            self.errorView.isHidden = true
            self.suggestionCVTopConstraint.constant = self.chatViewYPosition
            self.chatMessagesTableTopConstraint.constant = self.chatViewYPosition
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.chatMessageTxt.resignFirstResponder()
            self.view.frame.origin.y = 0
            if self.chatMessagesArr.count == 0 {
                self.errorView.isHidden = false
            }
            self.suggestionCVTopConstraint.constant = 0
            self.chatMessagesTableTopConstraint.constant = 0
            return true
        }
        
        // MARK: - UITextView Delegates methods
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if OTTSdk.preferenceManager.user != nil {
//                if let playerVC = self.parent as? PlayerViewController {
//                    playerVC.playerHolderView.translatesAutoresizingMaskIntoConstraints = true
//                }
                let deadlineTime = DispatchTime.now() + .milliseconds(100)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.chatMessageTxtView.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    if textView.text.count == 0 || textView.text == self.chatPlaceHolderText {
                        textView.text = nil
                    }
                    textView.textColor = UIColor.black
                    self.view.frame.origin.y = -(self.chatViewYPosition)
                    self.errorView.isHidden = true
                    self.suggestionCVTopConstraint.constant = self.chatViewYPosition
                    self.chatMessagesTableTopConstraint.constant = self.chatViewYPosition
                }
            }
            else {
                self.chatMessageTxtView.resignFirstResponder()
                self.showAlertWithText(message: "Please login to send message")
                self.chatMessageTxtView.tintColor = UIColor.clear
                self.showChatMessageView()
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.text == self.chatPlaceHolderText {
            }
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            if URL.absoluteString.contains("tel") {
                
                if UIApplication.shared.canOpenURL(NSURL.init(string: String.init(format: "telprompt://%@", URL.absoluteString.components(separatedBy: ":").last!))! as URL) {
                    UIApplication.shared.openURL(NSURL.init(string: String.init(format: "telprompt://%@", URL.absoluteString.components(separatedBy: ":").last!))! as URL)
                }
            }
            return true
        }
    func RateNowButtonClickedInHeader() {
        let vc = UserRatingView()
        vc.contentData = self.contentData
        vc.delegate = self
        self.presentpopupViewController(vc, animationType: .bottomTop, completion: { () -> Void in
        })
    }
    func watchPartyButtonClicked() {
        if self.showWatchPartyMenu == true {
            self.showWatchPartyView()
        }
        else {
            self.watchPartyButtonTap()
        }
    }
    
    func watchPartyButtonTap() {
        let vc = StartWatchPartyConfirmationView()
        vc.contentData = self.contentData
        vc.delegate = self
        self.presentpopupViewController(vc, animationType: .bottomTop, completion: { () -> Void in
        })
        
    }
    func showWatchPartyView() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            let vc = StartWatchParty()
            vc.contentData = self.contentData
            vc.changePartyButtonText = self.showWatchPartyMenu
            vc.delegate = self
            self.parent?.presentpopupViewController(vc, animationType: .bottomTop, completion: { () -> Void in
            })
        }
    }
    
    func HideKeyboardButtonClicked() {
        if AppDelegate.getDelegate().keyBoardShown == true {
            if self.chatMessageTxtView.text == "" {
                self.chatMessageTxtView.text = self.chatPlaceHolderText
            }
            self.view.endEditing(true)
            self.view.frame.origin.y = 0
            self.suggestionCVTopConstraint.constant = 0
            self.chatMessagesTableTopConstraint.constant = 0
        }
    }
    
        // MARK: - Tabmenu protocol methods
    func ShowHideDescriptionInHeader(showHide: Bool, descHeight: CGFloat) {
        
        self.showHide = showHide
        self.descLabelHeight = Double(descHeight)
        if self.suggestionsCV.isHidden == false {
            self.suggestionsCV.reloadData()
        }
        else if self.chatMessagestableView.isHidden == false {
            self.chatMessagestableView.reloadData()
        }
    }
    func DisplayWatchPartyView() {
        self.watchPartyButtonClicked()
    }
    func didSelectedItem(item: Int){
        if sectionList[item].sectionInfo.code == "chatroom" {
            self.errorView.isHidden = true
            tabMenuItemNumber = item
            self.suggestionsCV.isHidden = true
            self.chatMessagestableView.isHidden = false
            self.chatTxtAndBtnView.isHidden = false
            self.chatMessagestableView.reloadData()
        }
        else if sectionList[item].sectionInfo.code == "watchparty" {
            self.watchPartyButtonClicked()
            self.didSelectedItem(item: tabMenuItemNumber)
        }
        else {
            self.view.endEditing(true)
            if self.chatMessageTxtView.text == "" {
                self.chatMessageTxtView.text = self.chatPlaceHolderText
            }
            self.view.frame.origin.y = 0
            self.suggestionCVTopConstraint.constant = 0
            self.chatMessagesTableTopConstraint.constant = 0
            self.chatMessagestableView.isHidden = true
            self.chatTxtAndBtnView.isHidden = true
            tabMenuItemNumber = item
            if item == 0 {
                var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 113)
                tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
                cVL.cellSize = tmpCellsize
                
            }else if item == 1{
                var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 219)
                tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
                cVL.cellSize = tmpCellsize
            }else{
                var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 219)
                tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
                cVL.cellSize = tmpCellsize
            }
            self.sectionDataList = sectionList[tabMenuItemNumber].sectionData.data
            self.hasMoreData = sectionList[tabMenuItemNumber].sectionData.hasMoreData
            self.goGetTheData = true
            if self.sectionDataList.count == 0 {
                self.errorView.isHidden = false
                self.errorViewTopConstraint?.constant = 50
                self.view.sendSubviewToBack(errorView)
                self.suggestionsCV.isHidden = false
            }
            else {
                self.errorView.isHidden = true
                self.suggestionsCV.isHidden = false
            }
            self.suggestionsCV.setContentOffset(CGPoint.zero, animated: false)
            self.suggestionsCV.reloadData()
        }
    }
        func updateTableview(height:CGFloat,showHide:Bool){
            reusableViewHeight = height
            self.showHide = showHide
            if showHide {
                //reusableViewHeight = height + 109
                reusableViewHeight = height
            }
            self.suggestionsCV.reloadData()
            self.chatMessagestableView.reloadData()
            UIView.performWithoutAnimation {
                self.chatMessagestableView.beginUpdates()
                self.chatMessagestableView.endUpdates()
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
        let tempVal = self.recordingSeriesArr.index(of: programObj!.display.subtitle4)
        if tempVal != nil {
            tempID = "2"
        }
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
    
    func goToSignUp() {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        storyBoardVC.viewControllerName = "PlayerVC"
        if  playerVC != nil{
            playerVC?.showHidePlayerView(true)
        }
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    func goToSignIn() {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Sign in")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "PlayerVC"
        if  playerVC != nil{
            playerVC?.showHidePlayerView(true)
        }
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    func goToSubscribePage() {
//        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
//        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SelectPackageViewController") as! SelectPackageViewController
//        storyBoardVC.isFromMoviePage = true
//        storyBoardVC.movieTargetPath = self.targetPath
//        storyBoardVC.viewControllerName = "PlayerVC"
//        if  playerVC != nil{
//            playerVC?.showHidePlayerView(true)
//        }
//        let topVC = UIApplication.topVC()!
//        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
//
    }
    func goToShare() {
        //Set the default sharing message.
        self.delegate?.openShareView()
    }
    
    func favbtnClicked() {
        if OTTSdk.preferenceManager.user != nil {
            if self.isFavourite {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Removed"])
                OTTSdk.userManager.deleteUserFavouriteItem(pagePath: (self.contentData?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = false
                    self.showHide = false
                    if self.showLoginView {
                        self.reusableViewHeight = 244.0
                    } else {
                        self.reusableViewHeight = 135.0
                    }
                    self.suggestionsCV.reloadData()
                    self.chatMessagestableView.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)

                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
                        FavouritesListViewController.instance.moviesCollection.reloadData()
                    })
                    self.showAlertWithText(message: "Removed from Favorites")
                }, onFailure: { (error) in
                    Log(message: error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message)
                })
            }
            else {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Added"])
                OTTSdk.userManager.AddUserFavouriteItem(pagePath: (self.contentData?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = true
                    self.showHide = false
                    if self.showLoginView {
                        self.reusableViewHeight = 244.0
                    } else {
                        self.reusableViewHeight = 135.0
                    }
                    self.suggestionsCV.reloadData()
                    self.chatMessagestableView.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)
                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
                        FavouritesListViewController.instance.moviesCollection.reloadData()
                    })
                    self.showAlertWithText(message: "Added to Favorites")
                }, onFailure: { (error) in
                    Log(message: error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message)
                })
            }
        }
        else {
            self.showAlertWithText(message: "Please sign in to add your videos to Favorite".localized)
        }
    }
    func downloadBtnClicked() {
        if OTTSdk.preferenceManager.user != nil {
            if #available(iOS 11.0, *), let asset = self.downloadAsset {
                let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                let alertAction: UIAlertAction
                switch downloadState {
                case .notDownloaded:
                    if AppDelegate.getDelegate().offlineDownloadsLimit > 0 {
                        if AppDelegate.getDelegate().offlineDownloadsLimit == AppDelegate.getDelegate().fetchStreamList().count {
                            self.errorAlert(forTitle: "Alert", message: "You have reached maximum downloads", needAction: false) { flagValue in }
                            return
                        }
                    }
                    let bitRates = BitRateDownloadVC(nibName: "BitRateDownloadVC", bundle: nil)
                    bitRates.popUpBitRates = popUpBitRates
                    bitRates.selectedBitRate = { bit_rate_value, stream_url in
                        asset.stream.bit_rate = "\(bit_rate_value)"
                        asset.stream.playlistURL = stream_url
                        asset.urlAsset = AVURLAsset(url: URL(string: stream_url)!)
                        self.sendDownloadRequest(asset)
                    }
                    bitRates.modalPresentationStyle = .overFullScreen
                    present(bitRates, animated: false, completion: nil)
                    return
                case .downloading:
                    alertAction = UIAlertAction(title: "Yes", style: .default) { _ in
//                        let tempAsset = AssetPersistenceManager.sharedManager.assetForStream(withName: asset.stream.name)
//                        self.downloadAsset = tempAsset
                        self.sendDeleteDownloadRequest(asset, downloadState: downloadState)
                    }
                    let alertController = UIAlertController(title: String.getAppName(), message: "Do you want cancel Downloading?",
                                                            preferredStyle: .alert)
                    alertController.addAction(alertAction)
                    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                case .downloaded:
                    alertAction = UIAlertAction(title: "Yes", style: .default) { _ in
                        self.sendDeleteDownloadRequest(asset, downloadState: downloadState)
                        AssetPersistenceManager.sharedManager.deleteAsset(asset)
                        AppDelegate.getDelegate().deleteStream(asset.stream)
                        self.suggestionsCV.reloadData()
                    }
                    let alertController = UIAlertController(title: String.getAppName(), message: "Do you want delete from My Downloads?",
                                                            preferredStyle: .alert)
                    alertController.addAction(alertAction)
                    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
            } else {
                self.showAlertWithText(message: "Sorry!! Download is not supported in your device")
            }
        }
        else {
            self.showAlertWithText(message: "Please sign in to download video")
        }
    }
    func sendDownloadRequest(_ asset:Asset) {
        if #available(iOS 11.0, *) {
            AssetPersistenceManager.sharedManager.downloadStream(for: asset)
            if let asset = AssetPersistenceManager.sharedManager.assetForStream(withName: asset.stream.name) {
                self.downloadAsset = asset
            }
            self.saveStreamData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshOfflineContent"), object: nil, userInfo: nil)
            }
            self.stopAnimating()
        } else {
            // Fallback on earlier versions
        }
        return;
        self.startAnimating(allowInteraction: true)
        OTTSdk.mediaCatalogManager.contentDownloadRequest(path: asset.stream.targetPath, onSuccess: { (message) in
        }) { (error) in
            self.stopAnimating()
        }
    }
    func sendDeleteDownloadRequest(_ asset:Asset, downloadState:Asset.DownloadState) {
        self.startAnimating(allowInteraction: true)
        OTTSdk.mediaCatalogManager.deleteDownloadVideoRequest(paths: [asset.stream.targetPath], onSuccess: { (message) in
            if #available(iOS 11.0, *) {
                if downloadState == .downloading {
                    AssetPersistenceManager.sharedManager.cancelDownload(for: asset)
                    AppDelegate.getDelegate().deleteStream(asset.stream)
                    var userInfo = [String: Any]()
                    userInfo[Asset.Keys.name] = asset.stream.name
                    userInfo[Asset.Keys.downloadState] = Asset.DownloadState.notDownloaded.rawValue
                    userInfo[Asset.Keys.downloadSelectionDisplayName] = displayNamesForSelectedMediaOptions(asset.urlAsset.preferredMediaSelection)

                    NotificationCenter.default.post(name: .AssetDownloadStateChanged, object: nil, userInfo: userInfo)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshOfflineContent"), object: nil, userInfo: nil)
                    }
                } else if downloadState == .downloaded {
                    AssetPersistenceManager.sharedManager.deleteAsset(asset)
                    AppDelegate.getDelegate().deleteStream(asset.stream)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                    self.suggestionsCV.reloadData()
                    self.stopAnimating()
                }
            } else {
                // Fallback on earlier versions
            }
        }) { (error) in
            self.stopAnimating()
        }
    }
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        
        let alertController = UIAlertController(title: header, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        //errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    //MARK:- user rating view delegate methods
    func updateUserRating(rating:Double) {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        self.userRatingVal = Int(rating)
        if self.suggestionsCV.isHidden == false {
            self.suggestionsCV.reloadData()
        }
        else if self.chatMessagestableView.isHidden == false {
            self.chatMessagestableView.reloadData()
        }
        
    }
    func closeButtonSelected() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        else if self.parent?.popupViewController != nil {
            self.parent?.dismissPopupViewController(.fade)
        }
    }
     //MARK:- Watch Party view delegate methods
    func StartThePartySelected() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        else if self.parent?.popupViewController != nil {
            self.parent?.dismissPopupViewController(.fade)
        }
        if self.showWatchPartyMenu == false {
            self.showWatchPartyMenu = true
             self.delegate?.StartParty()
        }
    }
     
    func watchPartyCloseButtonSelected() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        else if self.parent?.popupViewController != nil {
            self.parent?.dismissPopupViewController(.fade)
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
    
     
     
     
    
    //MARK:- Pubnub SDK Delegates
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
        }
        
        if self.chatChannelId! == message.data.channel {
            let chatDict = message.data.message as? [String:Any]
            self.chatMessagesArr.append(chatDict!)
            self.errorView.isHidden = true
            DispatchQueue.main.async {
                self.chatMessagestableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    // New presence event handling.
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            
            Log(message: "\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            Log(message: "\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                    
                    // Select last object from list of channels and send message to it.
                    if client.channels().count > 0 {
                        //let targetChannel = client.channels().last!
                    }
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                if status is PNErrorStatus {
                    let errorStatus: PNErrorStatus = status as! PNErrorStatus
                    if errorStatus.category == .PNAccessDeniedCategory {
                        
                        /**
                         This means that PAM does allow this client to subscribe to this channel and channel group
                         configuration. This is another explicit error.
                         */
                    }
                    else {
                        
                        /**
                         More errors can be directly specified by creating explicit cases for other error categories
                         of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                         `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                         or `PNNetworkIssuesCategory`
                         */
                    }
                }
            }
        }
    }
    
    // MARK: - Attachment Handler Delegate methods

    func imagePicked(_ imageData: NSData, fileName: String, filePath: String) {
        self.chatMessageTxtView.resignFirstResponder()
        if self.chatMessageTxtView.text == self.chatPlaceHolderText {
            self.chatMessageTxtView.text = ""
        }
        self.view.frame.origin.y = 0
        self.suggestionCVTopConstraint.constant = 0
        self.chatMessagesTableTopConstraint.constant = 0
        if playerVC != nil {
            playerVC?.stopAnimating()
            playerVC?.stopAnimating1()
            playerVC?.stopAnimatingPlayer(false)
            playerVC?.player.playFromCurrentTime()
            if playerVC?.playBtn != nil {
                playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
            }
        }
        self.sendMessage(self.chatMessageTxtView.text, fileData: imageData)
    }
    
    func videoPicked(_ videoData: NSData, fileName: String, filePath: String) {
        self.chatMessageTxtView.resignFirstResponder()
        if self.chatMessageTxtView.text == self.chatPlaceHolderText {
            self.chatMessageTxtView.text = ""
        }
        self.view.frame.origin.y = 0
        self.suggestionCVTopConstraint.constant = 0
        self.chatMessagesTableTopConstraint.constant = 0
        if playerVC != nil {
            playerVC?.stopAnimating()
            playerVC?.stopAnimating1()
            playerVC?.stopAnimatingPlayer(false)
            playerVC?.player.playFromCurrentTime()
            if playerVC?.playBtn != nil {
                playerVC?.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
            }
        }
        self.sendMessage(self.chatMessageTxtView.text, fileData: videoData)
    }

        // MARK: - Player Bar menu protocol methods
    
    func getAttributedText(inputString:String, messageType:String) ->  NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        //            paragraphStyle.paragraphSpacing = 0.5;
        paragraphStyle.alignment = NSTextAlignment.left
        
        //Title
        let tempInputString = inputString
        let tempTimeString = tempInputString
        var stringColor = UIColor.init()
        if tempTimeString.count > 0{
            let textAttachment = NSTextAttachment.init()
            if messageType == "message_delivered" {
                textAttachment.image = UIImage.init(named: "message_delivered")
                stringColor = UIColor.init(hexString: "acacac")
            } else if messageType == "message_approved" {
                textAttachment.image = UIImage.init(named: "message_approved")
                stringColor = UIColor.init(hexString: "13a54a")
            } else if messageType == "message_rejected" {
                textAttachment.image = UIImage.init(named: "message_rejected")
                stringColor = UIColor.init(hexString: "fa5757")
            } else if messageType == "message_not_delivered" {
                textAttachment.image = UIImage.init(named: "message_rejected")
                stringColor = UIColor.init(hexString: "fa5757")
            }
            textAttachment.bounds = CGRect.init(x: 0, y: 0, width: 12, height: 8)
            let titleAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):
                UIFont.ottRegularFont(withSize: 10.0),
                                  convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): stringColor,convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle) : paragraphStyle]
            let titleAttributedString = NSMutableAttributedString(
                string: " " + inputString,
                attributes: convertToOptionalNSAttributedStringKeyDictionary(titleAttribute))

            let attachment = NSAttributedString.init(attachment: textAttachment)
            attributedString.append(attachment)
            attributedString.append(titleAttributedString)
        }
        
        return attributedString
        
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }

    
        func playerBarGoToSignUp() {
            self.goToSignUp()
        }
        func playerBarGoSignIn() {
            self.goToSignIn()
        }
        func playerBarUpdateTableview(height:CGFloat,showHide:Bool) {
            self.showHide = showHide
    //        if self.keyBoardShown {
    //        }
    //        else {
    //            self.suggestionCVTopConstraint.constant = 0
    //            self.chatMessagesTableTopConstraint.constant = 0
    //        }
            self.resignKeyboard()
            self.updateTableview(height: height, showHide: showHide)
        }
        func playerBarFavbtnClicked() {
            self.favbtnClicked()
        }
    
    func playerBarTakeTestButtonClicked(testUrl: String) {
        
       
        
    }


    @objc func resignKeyboard() {
        self.view.endEditing(true)
        self.hideChatMessageView()
        self.showChatMessageView()
        if self.chatMessagesArr.count == 0 {
//            self.errorView.isHidden = false
        }
    }
    
    @IBAction func openCamera(_ sender: Any) {
        self.chatMessageTxtView.resignFirstResponder()
        if self.chatMessageTxtView.text .isEmpty {
            self.chatMessageTxtView.text = nil
            self.chatMessageTxtView.text = self.chatPlaceHolderText
            self.chatMessageTxtView.textColor = UIColor.lightGray
        }
        self.view.frame.origin.y = 0
        self.suggestionCVTopConstraint.constant = 0
        self.chatMessagesTableTopConstraint.constant = 0
        AttachmentHandler.instance.delegate = self
        AttachmentHandler.instance.showAttachmentActionSheet(vc: self)
    }

    @IBAction func sendMsgClicked(_ sender: Any) {
        self.chatMessageTxtView.text = self.chatMessageTxtView.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !(self.chatMessageTxtView.text? .isEmpty)! && self.chatMessageTxtView.text != self.chatPlaceHolderText {
            self.chatMessageTxtView.resignFirstResponder()
            self.view.frame.origin.y = 0
            if self.chatMessagesArr.count == 0 {
                self.errorView.isHidden = false
            }
            self.suggestionCVTopConstraint.constant = 0
            self.chatMessagesTableTopConstraint.constant = 0
            var chatDict = [String:Any]()
            if OTTSdk.preferenceManager.user != nil {
                var senderName = ""
                if (OTTSdk.preferenceManager.user?.firstName.count)! > 0 {
                    let tempStr = ((OTTSdk.preferenceManager.user?.firstName)!) + " " + ((OTTSdk.preferenceManager.user?.lastName)!)
                    senderName = tempStr
                }
                else if (OTTSdk.preferenceManager.user?.name.count)! > 0{
                    senderName = (OTTSdk.preferenceManager.user?.name)!
                }
                else{
                    senderName = OTTSdk.preferenceManager.user?.email ?? ""
                }
                
                chatDict["sender"] = senderName
                chatDict["message"] = self.chatMessageTxtView.text!
                chatDict["timetoken"] = Date().getCurrentTimeStamp()
                self.chatMessageTxtView.text = nil
                self.chatMessageTxtView.text = self.chatPlaceHolderText
                self.chatMessageTxtView.textColor = UIColor.lightGray
                self.chatClient.publish(chatDict, toChannel: self.chatChannelId!, storeInHistory: true, withCompletion: { (publishStatus) -> Void in
                                        
                                        if !publishStatus.isError {
                                            
                                            // Message successfully published to specified channel.
                                        }
                                        else {
                                            
                                            /**
                                             Handle message publish error. Check 'category' property to find out
                                             possible reason because of which request did fail.
                                             Review 'errorData' property (which has PNErrorData data type) of status
                                             object to get additional information about issue.
                                             
                                             Request can be resent using: publishStatus.retry()
                                             */
                                        }
                })
            }
            else {
                self.chatMessageTxtView.text = nil
                self.chatMessageTxtView.text = self.chatPlaceHolderText
                self.chatMessageTxtView.textColor = UIColor.lightGray
                self.showAlertWithText(message: "Please login to send message")
            }
        }
    }
    @IBAction func sendMsgClickedUsingApi(_ sender: Any) {
        self.chatMessageTxtView.text = self.chatMessageTxtView.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !(self.chatMessageTxtView.text? .isEmpty)! && self.chatMessageTxtView.text != self.chatPlaceHolderText{
            self.chatMessageTxtView.resignFirstResponder()
            self.view.frame.origin.y = 0
            if self.chatMessagesArr.count == 0 {
                self.errorView.isHidden = false
            }
            self.suggestionCVTopConstraint.constant = 0
            self.chatMessagesTableTopConstraint.constant = 0
            self.sendMessage(self.chatMessageTxtView.text, fileData: nil)
        }
    }
    
    func sendMessage(_ message:String?, fileData:NSData?) {
        if let user = OTTSdk.preferenceManager.user {
            
            self.startAnimating(allowInteraction: false)
                        
            OTTSdk.userManager.submitQuestion(question: message == nil ? "" : message!, path: self.targetPath, userName: "\(user.phoneNumber)", fileData: fileData , onSuccess: { (message) in
                self.stopAnimating()
                self.chatMessageTxtView.resignFirstResponder()
                self.chatMessageTxtView.text = nil
                self.chatMessageTxtView.text = self.chatPlaceHolderText
                self.chatMessageTxtView.textColor = UIColor.lightGray
                self.errorView.isHidden = true
                self.suggestionCVTopConstraint.constant = 0
                self.chatMessagesTableTopConstraint.constant = 0
                self.getChatHistory()
            }) { (error) in
                self.stopAnimating()
                self.showAlertWithText(message: error.message)
            }
        }
        else {
            self.chatMessageTxtView.text = nil
            self.chatMessageTxtView.text = self.chatPlaceHolderText
            self.chatMessageTxtView.textColor = UIColor.lightGray
            self.showAlertWithText(message: "Please login to send message")
        }

    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.chatMessagesArr.count > 0 {
                let indexPath = IndexPath(row: self.chatMessagesArr.count-1, section: 0)
                self.chatMessagestableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func hideChatMessageView() {
        self.chatTxtAndBtnView.isHidden = true
        self.chatMessageTxt.resignFirstResponder()
        self.chatMessageTxtView.resignFirstResponder()
        if chatMessageTxtView.text == nil || chatMessageTxtView.text .isEmpty || chatMessageTxtView.text == self.chatPlaceHolderText{
            chatMessageTxtView.text = self.chatPlaceHolderText
            chatMessageTxtView.textColor = UIColor.lightGray
        }
        self.view.frame.origin.y = 0
        self.suggestionCVTopConstraint.constant = 0
        self.chatMessagesTableTopConstraint.constant = 0
    }
    @objc func showChatMessageView() {
        if self.isLive {
            self.chatTxtAndBtnView.isHidden = false
            if chatMessageTxtView.text == nil || chatMessageTxtView.text .isEmpty || chatMessageTxtView.text == self.chatPlaceHolderText{
                chatMessageTxtView.text = self.chatPlaceHolderText
                chatMessageTxtView.textColor = UIColor.lightGray
            }
        }
    }
    func tappedMenu() {
        self.updateTableview(height: reusableViewHeight, showHide: false)
    }
    func getDate(unixdate: Int) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.amSymbol = "AM"
        dayTimePeriodFormatter.pmSymbol = "PM"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    func getChatDate(unixdate: Int) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        dayTimePeriodFormatter.amSymbol = "AM"
        dayTimePeriodFormatter.pmSymbol = "PM"
        dayTimePeriodFormatter.timeZone = NSTimeZone.local
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    func getLabelHeight(labelText:String) -> Int {
        let constraintRect = CGSize(width: (self.chatMessagestableView.frame.width - 68), height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = labelText.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 14.0)], context: nil)
        return Int(boundingBox.height)
    }
   
    func loadBannerAd(){
     
        var tempBannerUnitId = ""
        tempBannerUnitId = AppDelegate.getDelegate().defaultPlayerBannerAdTag
        
        if AppDelegate.getDelegate().showBannerAds && !tempBannerUnitId.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                self.bannerAdView = UIView.init(frame: CGRect.init(x: 0, y: 0, width:  UIScreen.main.bounds.size.width, height: 250))
                //                    let bannerView = DFPBannerView(adSize:kGADAdSizeBanner)
                let bannerView = DFPBannerView(adSize:kGADAdSizeMediumRectangle)
                let request = DFPRequest()
                //#warning("comment test devices")
                //                request.testDevices = [kGADSimulatorID,"46805d24bda9feaa573e40056cd97b73"]
                bannerView.adUnitID = tempBannerUnitId
                bannerView.rootViewController = self
                bannerView.delegate = self
                bannerView.load(request)
                self.bannerAdView?.addSubview(bannerView)
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                
                // Layout constraints that align the banner view to the bottom center of the screen.
                self.bannerAdView?.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal,
                                                                    toItem: self.bannerAdView, attribute: .top, multiplier: 1, constant: 0))
                self.bannerAdView?.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal,
                                                                    toItem: self.bannerAdView, attribute: .centerX, multiplier: 1, constant: 0))
                
            })
        }
        else{
            self.hideBannerAd()
        }
        
    }
    func hideBannerAd(){
        //self.adBannerViewHeightConstraint.constant = 0.0
        self.isBannerAdsReceived = false
        self.suggestionsCV.reloadData()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.hideBannerAd()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.isBannerAdsReceived = true
        self.suggestionsCV.reloadData()
        if self.errorView.isHidden == false {
            self.errorViewTopConstraint?.constant = 270
        }
        //self.adBannerViewHeightConstraint.constant = 250.0
    }
    
}
