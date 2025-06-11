//
//  PlayerViewController.swift
//  sampleColView
//
//  Created by Muzaffar on 20/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import CoreMotion
import OTTSdk
import Bluuur
import GoogleCast
import GoogleInteractiveMediaAds
import MaterialComponents

protocol PlayerViewControllerDelegate {
    func didSelectedSuggestion(card : Card)
    func didSelectedOfflineSuggestion(stream : Stream)
}

enum PlaybackMode : Int {
    case none = 0
    case local
    case remote
}

let kMediaKeyPosterURL = "posterUrl"
let kMediaKeyDescription = "description"
let kPrefPreloadTime = "preload_time_sec"

@available(iOS 10.0, *)
class PlayerViewController: UIViewController, PlayerDelegate,UIGestureRecognizerDelegate,BitRateProtocol, PlayerChildViewControllerDelegate,SubtitleLanguageProtocol,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,IMAAdsLoaderDelegate,IMAAdsManagerDelegate, PlayerSuggestionsViewDelegate, ComingUpNextViewDelegate, ActiveStreamsDevicesViewCotrollerDelegate,
    AVPlayerItemLegibleOutputPushDelegate,
    PartialRenderingViewDelegate,
    PlayerBarMenuProtocal,
    AVPictureInPictureControllerDelegate{

    
    struct AnalyticsInfoData {
        var navigatingFrom = "Player"
    }
    @IBOutlet weak var goLiveBtnLeadConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var defaultPlayingItemViewViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastChnlBtnLeadConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var startOverBtnLeadConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var subTitlesBtnWidthConstraint: NSLayoutConstraint? // Add outlet for subtitles width
    @IBOutlet weak var minimizedViewTitleLbl: UILabel?
    
    @IBOutlet weak var fSButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var fSButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var minimizedSubtitleLbl: UILabel?
    @IBOutlet weak var comingUpVdoLblTpConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitlesBtn: UIButton? // Add outlet for subtitles.. subtitles through srt files
    @IBOutlet weak var ccButton: UIButton?
    @IBOutlet weak var waterMarkImgView: UIImageView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var playerHolderView: UIView!
    
    @IBOutlet weak var sliderPlayer: PlayerSlider!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var mQualityButton: UIButton? // Add outlet for Video quality options
    @IBOutlet weak var playBtn: UIButton?
    @IBOutlet weak var navBarButtonsStackView: UIStackView!
    @IBOutlet weak var navBarButtonsStackViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var navBarButtonsStackViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var navViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var ccButtonTop: NSLayoutConstraint!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var nextContentButton: UIButton!
    @IBOutlet weak var nextContentButtonWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var lastChannelButton: UIButton!
    @IBOutlet weak var lastChannelButtonWidthConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var vodStartOverButton: UIButton!
    @IBOutlet weak var vodStartOverButtonWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var vodStartOverButtonTrailingConstraint: NSLayoutConstraint?

    @IBOutlet weak var startOverOrGoLiveButton: UIButton!
    @IBOutlet weak var startOverOrGoLiveButtonWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var recordButton: UIButton?
    
    @IBOutlet weak var comingUpNextView: ComingUpNextView!
    
    
    @IBOutlet var suggestionsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet weak var favInPlayer: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var fullScreenButtonTrailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var takeTestButtonInPlayer: UIButton!
    var takeTestUrl:String = ""
    var isTestButtonShown:Bool = false
    @IBOutlet weak var suggestionsView: PlayerSuggestionsView!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var sliderPlayerLeft: NSLayoutConstraint!
    @IBOutlet weak var slideViewBottom: NSLayoutConstraint!
    @IBOutlet weak var sliderPlayerRight: NSLayoutConstraint!
    @IBOutlet weak var fullScreenTop: NSLayoutConstraint!
    @IBOutlet weak var endTimeRight: NSLayoutConstraint!
    
    @IBOutlet weak var previewLblViewleading: NSLayoutConstraint!
    @IBOutlet weak var previewLblView: UIView!
    @IBOutlet weak var previewDurationLbl : UILabel!
    @IBOutlet weak var sign_signup_MsgLbl: UILabel!
    
    var isPreviewContent: Bool = false
    var previewSecondsRemaining = 0
    var lastScrubbingValue : Float = 0
    var comingFromBackground: Bool = false
    var willEnterForeground: Bool = false
    var playerStateInBackGroundMode: Int = 0
    var isChangedToLandscapeOnce: Bool = false
    var isPlayerDragging: Bool = false
    var shouldHideMinimizedPlayer = false
    var dockPlayIconName = (productType.iPad ? "player-play-icon_ipad" : "player-play-icon")
    var dockPauseIconName = (productType.iPad ? "miniPlayer-Pause_ipad" : "miniPlayer-Pause")
    var isFavourite:Bool = false
    var isNavigatingToBrowser:Bool = false
    @IBOutlet weak var shareBtn: UIButton? // Add outlet for Sharing feature
    @IBOutlet weak var seekFwd: UIButton!
    @IBOutlet weak var seekBckwd: UIButton!
    @IBOutlet weak var nextVdoPlayBtnView: UIView!
    
    @IBOutlet weak var defaultPlayingItemView: UIImageView!
    
    @IBOutlet weak var nextVdoviewGoLiveBtn: UIButton!
    
    @IBOutlet weak var nextVideoCloseBtn: UIButton!
    @IBOutlet weak var nextVdoPlayBtnLeadingConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var closeBtnOnDockPlayer: UIButton!
    @IBOutlet weak var playPauseButtonOnDockPlayer: UIButton!
    
    @IBOutlet weak var navImageView: UIImageView?
    @IBOutlet weak var navTitleLable: UILabel?
    @IBOutlet weak var navSubTitleLable: UILabel?
    @IBOutlet weak var navExpiryLable: UILabel?
    @IBOutlet weak var navExpiryLabelWidthConstraint : NSLayoutConstraint?
    @IBOutlet weak var navTitleLableWidthConstraint: NSLayoutConstraint?

    
    //PIN VIEW DETAILS
    
    @IBOutlet private weak var pinView : UIView!
    @IBOutlet private weak var pinInnerView : UIView!
    @IBOutlet private weak var pinTitleLabel : UILabel!
    @IBOutlet private weak var pinErrorMsgLabel : UILabel!
    @IBOutlet private weak var pinNumberTextField : MDCTextField!
    @IBOutlet private weak var pinCancelButton : UIButton!
    @IBOutlet private weak var pinConfirmButton : UIButton!
    fileprivate var pinNumberController: MDCTextInputControllerOutlined?
    var showWatchPartyMenu:Bool = false
    var defaultPlayingItemUrl = ""
    var playingItemTitle = ""
    var playingItemSubTitle = ""
    var templateElement:TemplateElement?
    var playingItemTargetPath = ""
    var pageString :String!
    var contentObj :Any!
    var contentsArrayObj :[Any]!
    var videoUrlString:String!
    var videoUrlString_ChromeCast:String!
    var delegate : PlayerViewControllerDelegate?
    var partialRenderingViewDelegate : PartialRenderingViewDelegate?
    var closeCaptions : CloseCaptions!
    @IBOutlet weak var playerIndicatorView:UIView?
    var playerIndicatorCustomView:CustomActivityIndicatorView?
    var viewInTransition: Bool = false
    var minBtnTouched: Bool = false
    var isPlayerAddedToView : Bool = false
    var hideControls: Bool = false
    var isSeeking: Bool = false
    var myTimer: Timer? = nil
    var streamPollTimer: Timer? = nil
    var nextVDOTimer: Timer? = nil
    var connectivityTimer: Timer? = nil
    var programEndTimer: Timer? = nil
    var enableTakeTestTimer: Timer? = nil
    var hideControllsTimer : Timer?
    
    var testVal: Int = 1
    var player: Player!
    var playerObserver:AnyObject!
    var currentTime:String = "00:00"
    var defaultSubtitleLang:String = ""
    var pageData = [PageData]()
    var captionsList = [CCData]()
    var pageDataResponse : PageContentResponse!
    lazy var streamResponse = StreamResponse([:])
    var analyitcs_info_obj : AnalyticsInfo!
    //var maxBitrateAllowed = 0
    var continueWatchDict = [String:String]()
    var a_m_d: NSMutableDictionary!
    var c_m_d: NSMutableDictionary!
    var nextEpisodesSectionDict = NSMutableDictionary()
    var isAlertBtnClicked:Bool = false
    var isContinueWatchAlertShown:Bool = false
    var nextVideoContent : Card!
    var currentVideoContent : Card!
    var mediaInfo: GCKMediaInformation!
    var sessionManager:GCKSessionManager!
    var castSession:GCKCastSession!
    var castMediaController:GCKUIMediaController!
    var castTargetTime:CMTime!
    var playerCastObserver:AnyObject!
    var castingLastStreamPosition:TimeInterval?
    var chatChannelId:String?
    var bitRates = NSMutableArray()
    fileprivate var popUpBitRates = [[String : Any]]()
    let playerInstance = PlayerResultModel()
    var loaderDelegate = AssetLoaderDelegate()
    var _playBackMode = PlaybackMode(rawValue: 0)
    var playerErrorCode = 0
    var watchedSeekPosition = 0
    var seekStartValue:Int64!
    var seekEndValue:Int64!
    var countdown = 10
    var goLiveTargetPath = ""
    var playerLicenseUrl = ""
    var isPlayBackEnd:Bool = false
    var playitem:AVPlayerItem?
    var ccTimeObserver : Any!
    var adDisplayPostionsArray = [Int]()
    private var skipIntroStartTime = 0
    private var skipIntroEndTime = 0
    private var isSkipIntroShow = false
    private var selectedActionTitle = ""
    ////////
//    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerWidth: NSLayoutConstraint!
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    @IBOutlet weak var titleControlsWidth: NSLayoutConstraint!
    @IBOutlet weak var titleControlsHeight: NSLayoutConstraint!
    @IBOutlet weak var onMinView: UIView!
    @IBOutlet weak var playerControlsWidth: NSLayoutConstraint!
    @IBOutlet weak var playerControlsHeight: NSLayoutConstraint!
    @IBOutlet weak var minimizeButton: UIButton!
//    @IBOutlet weak var fullscreen: UIButton!
    @IBOutlet weak var goLiveBtn : UIButton?
    @IBOutlet weak var startOverBtn : UIButton!
    @IBOutlet weak var skipButton : UIButton!
    /*
    @IBOutlet weak var imgIconWidth: NSLayoutConstraint!
    @IBOutlet weak var imgIconheight: NSLayoutConstraint!
    @IBOutlet weak var pvViewwidth: NSLayoutConstraint!
    @IBOutlet weak var pvViewheight: NSLayoutConstraint!
    @IBOutlet weak var pv: UIProgressView!
    @IBOutlet weak var pvViewMain: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
*/
    var playBackSpeedArray = NSMutableArray()
    var selectedPlayBackSpeed = ""
    var onMinViewLeadingConstraint: NSLayoutConstraint!
    /*
    var isVolumeChanging:Bool = false
    var isBrightnessChanging:Bool = false
    var panStartLocation:CGPoint!
    var panCount:Int = 0
    var currentOutputVolume:Float!
*/
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    var indicatorViewTapGestureRecognizer: UITapGestureRecognizer?
    var playerControlTapGestureRecognizer: UITapGestureRecognizer?

    var isMinimized: Bool = false
    var isPlayerLoaded: Bool = false
    var initialFirstViewFrame = CGRect(x: 0, y: 0, width: 96, height: 54)
    var animationDuration = 0.2
    
    var winFrm = UIApplication.shared.keyWindow?.frame
    var scaleFactor: CGFloat = 0
    var shiftOrigin: CGFloat = 0
    var alertController : UIAlertController! = nil

    var playerTapGesture: UITapGestureRecognizer?
    var playerPanGesture: UIPanGestureRecognizer?
    var adPanGesture: UIPanGestureRecognizer?
    var initialGestureDirection: UIPanGestureRecognizerDirection?
    var panGestureDirection: UIPanGestureRecognizerDirection?
    var touchPositionStartY: CGFloat?
    var touchPositionStartX: CGFloat?
    var viewMinimizedFrame: CGRect?
    
    var removeViewOffset: CGFloat?
    var isOpen: Bool = false
    var isPlaying: Bool = false
    var isFullscreen: Bool = false
    var isFromErrorFlow:Bool = false
    var isSharingFlowClicked:Bool = false
    var isAutoRedirect:Bool = false
    var isGoLiveBtnAvailable:Bool = false
    var timeRangePlayer: CMTimeRange!
    var startOverFlag: Bool = false
    var goLiveFlag: Bool = false
    var hideTimer: Timer?
    var prevPlayerOrientation: UIDeviceOrientation!
    var changeOrientationTo: Int!
    var rotateMM: CMMotionManager!
    var nextItemText = "Coming Up Next in "
    
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    var adsDisplayContainer: IMAAdDisplayContainer!
    var shouldPlayAd = false
    var isMidRollAdPlaying = false
    var popUpOnceArrived = false
    var adUrlToPlay = ""
    var adTypeToPlay = "-1"
    var watchedTime = ""
    var pollEventType = 1
    var testStartTime:Int64 = -1
    ///////
    
    @IBOutlet weak var playerControlsView: UIView!
    weak var currentViewController: UIViewController?
    var analytics_info_contentType: String!
    var analytics_info_dataType: String!
    var analytics_meta_id: String!
    var analytics_meta_data: NSMutableDictionary!
    var episodeModelDict:NSDictionary!

    let resourceRequestDispatchQueue = DispatchQueue(label: "com.example.apple-samplecode.resourcerequests")
    var analyticsInfo = AnalyticsInfoData()
    var castButton : GCKUICastButton?
    var myVolumeView : MPVolumeView?
    var shouldSeekToStartOver = true
    var isQualityOptionsFound = false
    var bannerAdFoundExceptPlayer = false

    var previewTimer: Timer? = nil
    var previewElement : Element?
    @IBOutlet weak var warningLbl: UILabel?
    var isWarningMessageDisplayed = false

    
    var systemVolumeView:MPVolumeView = {
        let volumeView = MPVolumeView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        volumeView.isHidden = false
        volumeView.alpha = 0.01
        return volumeView
    }()

    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            
            // Sets the delegate and dispatch queue to use with the resource loader.
            newAsset.resourceLoader.setDelegate(loaderDelegate, queue: resourceRequestDispatchQueue)
            
            asynchronouslyLoadURLAsset(newAsset: newAsset)
        }
    }
    var playerItem: AVPlayerItem? {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            self.player.avplayer.replaceCurrentItem(with: playerItem)
        }
    }
    // Must load and test these asset keys before playing.
    let assetKeysRequiredToPlay = [
        "playable"
    ]
    //    let playbackLikelyToKeepUpContext:UnsafeMutablePointer<Int>? = nil
    
    
    // Subtitles
    enum SubTitleType {
        case none
        case embedded
        case external
    }
    var subTitleType = SubTitleType.none
    var output = AVPlayerItemLegibleOutput.init()
    
    
    var offLineDownloadAsset : Asset?
    var isDownloadContent:Bool = false
    // MARK: - View lifecycle
    
    convenience init() {
        self.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }
    
    func requestAds() {
        // Create ad display container for ad rendering.
        if adsManager != nil {
            adsManager?.destroy()
        }
        if isDownloadContent {
            return
        }
        adsDisplayContainer = IMAAdDisplayContainer(adContainer: playerHolderView, viewController: self, companionSlots: nil)
        // Create an ad request with our ad tag, display container, and optional user context.
        adsDisplayContainer?.adContainer.isUserInteractionEnabled = true
        if self.adsDisplayContainer != nil {
//            self.adsDisplayContainer.adContainer.addGestureRecognizer(adPanGesture!)
        }
        var updatedAdUrl = self.adUrlToPlay
        if appContants.appName == .tsat {
            if AppDelegate.getDelegate().device_atts == 3 {
                var linkString = ""
                if AppDelegate.getDelegate().configs?.siteURL.last == "/" {
                    linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")\(self.pageDataResponse.info.path)"
                } else {
                    linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")/\(self.pageDataResponse.info.path)"
                }
                
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "[placeholder]", with: linkString)
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "correlator=", with: "correlator=\(Date().getCurrentTimeStamp())")
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_ID}}", with: "\(AppDelegate.getDelegate().device_Ifa)")
                updatedAdUrl = updatedAdUrl + "&DEVICE_ID=\(AppDelegate.getDelegate().device_Ifa)"
                updatedAdUrl = updatedAdUrl + "&dnt=0"
            }
            else{
                updatedAdUrl = updatedAdUrl + "&dnt=1"
            }
        }
        else if appContants.appName == .firstshows {
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{WIDTH}}", with: "\(AppDelegate.getDelegate().window!.frame.size.width)")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{HEIGHT}}", with: "\(AppDelegate.getDelegate().window!.frame.size.height)")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{CACHEBUSTER}}", with: "\(Date().getCurrentTimeStamp())")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{IP}}", with: AppDelegate.getDelegate().trueip)
            
            let charactersToEscape = "\n{}!*'();:@&=+$,/?%#[]\" "
            let allowedCharacters = CharacterSet(charactersIn: charactersToEscape).inverted
            
            let _userAgent = AppDelegate.getDelegate().userAgent
            let userAgent = _userAgent.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{USER_AGENT}}", with: userAgent ?? "")
            
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{LAT}}", with: AppDelegate.getDelegate().latitude)
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{LON}}", with: AppDelegate.getDelegate().longitude)
            
            if AppDelegate.getDelegate().device_atts == 3 {
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DNT}}", with: "0")
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_ID}}", with: AppDelegate.getDelegate().device_Ifa)
            }
            else{
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DNT}}", with: "1")
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_ID}}", with: AppDelegate.getDelegate().device_Ifv)
            }
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{IFA_TYPE}}", with: "\(AppDelegate.getDelegate().device_atts)")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{APP_NAME}}", with: "\(appContants.appName)")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{APP_BUNDLE}}", with: "1546724274")
            
            let _appStoreLink = Constants.OTTUrls.appStoreLinkWithHttp
            
            let appStoreLink = _appStoreLink.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{APP_STORE_URL}}", with: appStoreLink ?? "")
            
            
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_BRAND_NAME}}", with: "Apple")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{CONTENT_ID}}", with: self.pageDataResponse.info.attributes.contentId)
            
            let _contentTitle = self.navTitleLable?.text ?? ""
            let contentTitle = _contentTitle.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{CONTENT_TITLE}}", with: contentTitle ?? "")
        }
        else if appContants.appName == .gac {
          
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{CACHEBUSTER}}", with: "\(Date().getCurrentTimeStamp())")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{IP}}", with: AppDelegate.getDelegate().trueip)
            
            let charactersToEscape = "\n{}!*'();:@&=+$,/?%#[]\" "
            let allowedCharacters = CharacterSet(charactersIn: charactersToEscape).inverted
            
            let _userAgent = AppDelegate.getDelegate().userAgent
            let userAgent = _userAgent.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{USER_AGENT}}", with: userAgent ?? "")
             
            if AppDelegate.getDelegate().device_atts == 3 {
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DNT}}", with: "0")
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_ID}}", with: AppDelegate.getDelegate().device_Ifa)
            }
            else{
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DNT}}", with: "1")
                updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{DEVICE_ID}}", with: AppDelegate.getDelegate().device_Ifv)
            }
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{IFA_TYPE}}", with: "\(AppDelegate.getDelegate().device_atts)")
            updatedAdUrl = updatedAdUrl.replacingOccurrences(of: "{{APP_NAME}}", with: "\(appContants.appName)")
            
        }
        let request = IMAAdsRequest(
            adTagUrl:updatedAdUrl,
            adDisplayContainer: adsDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        adsLoader?.requestAds(with: request)
        self.handleGestureAddRemove()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if appContants.appName == .gac {
            
            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                if isPreviewContent == true {
                    self.shareBtn?.isHidden = true
                    self.favInPlayer?.isHidden = true
                }
                else {
                    //self.shareBtn?.isHidden = false
                }
                
                self.takeTestButtonInPlayer?.isHidden = true
                self.sliderPlayerLeft.constant = 15
                self.slideViewBottom.constant =  -45
                self.sliderPlayerRight.constant = -15
                self.fullScreenTop.constant = 0
                self.endTimeRight.constant = -25
            } else {
                if isPreviewContent == true {
                    self.shareBtn?.isHidden = true
                }
                self.ccButton?.isHidden = true
                self.startOverBtn?.isHidden = true
                self.nextContentButton?.isHidden = true
                self.lastChannelButton?.isHidden = true
                self.skipButton?.isHidden = true
                self.takeTestButtonInPlayer?.isHidden = true
                self.goLiveBtn?.isHidden = true
                self.recordButton?.isHidden = true
                self.favInPlayer?.isHidden = true
                self.vodStartOverButton?.isHidden = true
                self.sliderPlayerLeft.constant = 0
                self.slideViewBottom.constant = self.playerHolderView.bounds.minY + 5
                self.sliderPlayerRight.constant = 0
                self.fullScreenTop.constant = -57
                self.endTimeRight.constant = -51
            }
        }
    }
  /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pvViewMain.transform = CGAffineTransform.init(rotationAngle: CGFloat(-M_PI/2))
        //pv.transform = CGAffineTransform.init(scaleX: 1.0, y: 10)
        if productType.iPhone {
            imgIconWidth.constant = 20
            imgIconheight.constant = 20
            pvViewwidth.constant = self.view.frame.width/3.5
            pvViewheight.constant = 40
            pv.transform = CGAffineTransform.init(scaleX: 1.0, y: 5)

        }else {
            pvViewwidth.constant = self.view.frame.width/3.5
            pv.transform = CGAffineTransform.init(scaleX: 1.0, y: 10)

        }

    }
*/

    private func setupPinUI() {
        pinNumberController = MDCTextInputControllerOutlined(textInput: pinNumberTextField)
        pinNumberController?.activeColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.floatingPlaceholderActiveColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.floatingPlaceholderNormalColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberController?.inlinePlaceholderColor = AppTheme.instance.currentTheme.textFieldBorderColor
        pinNumberTextField.center = .zero
        pinNumberTextField.clearButtonMode = .never
        
        pinInnerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        pinTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        pinErrorMsgLabel.backgroundColor = AppTheme.instance.currentTheme.themeColor
        pinNumberTextField.textColor = AppTheme.instance.currentTheme.cardTitleColor
        pinCancelButton.setTitle("CANCEL".localized, for: .normal)
        pinConfirmButton.setTitle("CONFIRM".localized, for: .normal)
        
        pinCancelButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 16.0)
        pinConfirmButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 16.0)
        pinTitleLabel.font = UIFont.ottRegularFont(withSize: 16.0)
        pinErrorMsgLabel.font = UIFont.ottRegularFont(withSize: 14.0)
        pinNumberTextField.font = UIFont.ottRegularFont(withSize: 16.0)
        pinErrorMsgLabel.text = ""
        pinTitleLabel.text = AppDelegate.getDelegate().parentalControlPopupMessage
        pinCancelButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        pinConfirmButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        pinView.frame = UIScreen.main.bounds
        pinInnerView.viewCornersWithFive()
    }

    @IBAction private func cancelAndCloseAction(_ sender : UIButton) {
        self.view.endEditing(true)
        if sender.tag == 10 {
            guard let number = pinNumberTextField.text, number.count > 0 else {
                errorAlert(forTitle: String.getAppName(), message: "Please enter PIN".localized, needAction: false) { _ in }
                return
            }
            guard number.count == AppDelegate.getDelegate().parentalControlPinLength else {
                errorAlert(forTitle: String.getAppName(), message: "Please enter Valid PIN".localized, needAction: false) { _ in }
                return
            }
        }
        pinView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if appContants.appName == .aastha {
            self.previewLblView?.isHidden = true
            self.sign_signup_MsgLbl?.isHidden = true
            self.previewLblView?.layer.cornerRadius = 5
            self.previewLblView?.layer.borderWidth = 1
            self.previewLblView?.layer.borderColor = UIColor.white.cgColor
            self.previewLblView?.clipsToBounds = true
        }
        setupPinUI()
        skipButton.viewCornerRadiusWithTwo()
        skipButton.isHidden = true
        warningLbl?.isHidden = true
        if sliderPlayer != nil {
            sliderPlayer.value = 0.0
            sliderPlayer.setThumbImage(UIImage(named: "player-slider-thumb"), for: .normal)
            sliderPlayer.setThumbImage(UIImage(named: "player-slider-thumb-selected"), for: .highlighted)
            sliderPlayer.minimumTrackTintColor = AppTheme.instance.currentTheme.themeColor
            
        }
        self.takeTestButtonInPlayer.titleLabel?.font = UIFont.ottSemiBoldFont(withSize: 15)
        self.takeTestButtonInPlayer.isHidden = true
        UIApplication.shared.hideSB()
        AppDelegate.getDelegate().removeStatusBarView()
        playBackSpeedArray = ["0.25x","0.5x","0.75x","Normal","1.25x","1.50x","1.75x","2x"]
        self.selectedPlayBackSpeed = "Normal"
    //    pvViewMain.isHidden = true
        self.onMinViewLeadingConstraint = NSLayoutConstraint(item: self.onMinView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.playerHolderView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)
        self.closeBtnOnDockPlayer.setImage(UIImage.init(named:(productType.iPad ? "miniplayer-close_ipad" : "miniplayer-close")), for: .normal)
        AppDelegate.getDelegate().taggedScreen = "Player"
        AppDelegate.getDelegate().isPlayerPage = true
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        castTargetTime = CMTime.invalid
        self.view.backgroundColor = UIColor.clear
        self.continueWatchDict["playingItemTitle"] = self.playingItemTitle
        self.continueWatchDict["defaultPlayingItemUrl"] = self.defaultPlayingItemUrl
        self.continueWatchDict["playingItemSubTitle"] = self.playingItemSubTitle
        self.continueWatchDict["playingItemTargetPath"] = self.playingItemTargetPath
        
        self.navBarButtonsStackViewWidthConstraint?.constant = 140

        self.resetPlayerItems()
        if self.defaultPlayingItemView != nil {
            self.defaultPlayingItemView.isHidden = true
        }
        if !isDownloadContent {
            self.pageData = self.pageDataResponse.data
        }
        updateFavoriteButtonUI()
       // self.fullScreenButton.isHidden = true
        self.viewDidLoadSwipe()
        if self.pageDataResponse != nil && self.pageDataResponse.adUrlResponse.adUrlTypes.count > 0{
            // Url to play
            for b in self.pageDataResponse.adUrlResponse.adUrlTypes{
                print("b:\(b.urlType.rawValue) and \(b.url)")
                if b.urlType == .preUrl {
                    if !b.url.isEmpty{
                        self.adUrlToPlay = b.url
                        self.adTypeToPlay = "0"
                    }
                }
            }
        }
        
        if self.pageDataResponse != nil {
            self.skipIntroStartTime = -1
            self.skipIntroEndTime = -1
            
            if self.pageDataResponse.info.attributes.introStartTime > 0 {
                self.skipIntroStartTime = self.pageDataResponse.info.attributes.introStartTime
            }
            if self.pageDataResponse.info.attributes.introEndTime > 0 {
                self.skipIntroEndTime = self.pageDataResponse.info.attributes.introEndTime
            }
        }
        
                
        //if self.episodeObj != nil{
        //}
        if AppDelegate.getDelegate().showVideoAds {
            setUpAdsLoader()
        }
        if self.sliderPlayer != nil {
            self.sliderPlayer.value = 0.0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(closePlayer), name: NSNotification.Name(rawValue: "ClosePlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadApiForPlayerUrlInErrorCase), name: NSNotification.Name(rawValue: "loadApiForPlayerUrlInErrorCase"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidEnterBackground(_:)), name:UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(playerWillEnterForeground(_:)), name:UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidBecomeActive(_:)), name:UIApplication.didBecomeActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(playerWillResignActive(_:)), name:UIApplication.willResignActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAVPlayerAccess),
                                               
                                               name: NSNotification.Name.AVPlayerItemNewAccessLogEntry,
                                               object: nil)
        if self.waterMarkImgView != nil {
            self.waterMarkImgView.alpha = 0.0
            waterMarkImgView.image = UIImage(named: "AppWaterMarkIcon")!
        }
        self.checkToEnableCCBtn()
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
        sessionManager.add(self)
        castMediaController = GCKUIMediaController.init()
        castMediaController.delegate = self
        
        if productType.iPhone && DeviceType.IS_IPHONE_X {
            self.navBarButtonsStackViewBottomConstraint?.constant = 0
            self.navViewTopConstraint?.constant = 20
        }
        else {
            self.navBarButtonsStackViewBottomConstraint?.constant = 5
            self.navViewTopConstraint?.constant = 16
        }
        setPlayerToFullscreen(1)
        if !isDownloadContent {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.didStartDisplay()
            }
        }
        let messageDataDict:[String: Bool] = ["status": true]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
       // self.setupGesture()
       // self.view.addSubview(systemVolumeView)
        
        if appContants.appName == .gac {
            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                self.shareBtn?.isHidden = true
                self.takeTestButtonInPlayer?.isHidden = true
                self.favInPlayer?.isHidden = true
                self.sliderPlayerLeft.constant = 15
                self.slideViewBottom.constant =  -45
                self.sliderPlayerRight.constant = -15
                self.fullScreenTop.constant = 0
                self.endTimeRight.constant = -25
            } else {
                self.ccButton?.isHidden = true
                self.startOverBtn?.isHidden = true
                self.nextContentButton?.isHidden = true
                self.lastChannelButton?.isHidden = true
                self.shareBtn?.isHidden = true
                self.skipButton?.isHidden = true
                self.takeTestButtonInPlayer?.isHidden = true
                self.goLiveBtn?.isHidden = true
                self.recordButton?.isHidden = true
                self.favInPlayer?.isHidden = true
                self.vodStartOverButton?.isHidden = true
                self.sliderPlayerLeft.constant = 0
                self.slideViewBottom.constant = self.playerHolderView.bounds.minY + 5
                self.sliderPlayerRight.constant = 0
                self.fullScreenTop.constant = -57
                self.endTimeRight.constant = -51
            }
            if let yourBackImage = UIImage(named: "group_3988") {
                self.minimizeButton?.setImage(yourBackImage, for: .normal)
                self.minimizeButton?.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 3, right: 8)
            }
        }

    }
    @IBOutlet weak var pipButton: UIButton!
    var playerPipObserver:AnyObject!
    var pictureInPictureController : AVPictureInPictureController!
    var isPipRestored = false
    
    @IBAction func togglePictureInPictureMode(_ sender: UIButton) {
        if pictureInPictureController.isPictureInPictureActive {
            pictureInPictureController.stopPictureInPicture()
        } else {
            pictureInPictureController.startPictureInPicture()
        }
    }
    
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        if AVPictureInPictureController.isPictureInPictureSupported() {
            
            let avpl = self.player.playerView.playerLayer
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pictureInPictureController = AVPictureInPictureController(playerLayer: avpl)!
            pictureInPictureController.delegate = self
            
            playerPipObserver = pictureInPictureController.observe(\AVPictureInPictureController.isPictureInPicturePossible,
                                                                        options: [.initial, .new]) { [weak self] _, change in
//                // Update the PiP button's enabled state.
                self?.pipButton?.isEnabled = true
                self?.pipButton?.isHidden = false
                if #available(iOS 14.2, *) {
                    self?.pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = true
                }
                if #available(iOS 14.0, *) {
                    self?.pictureInPictureController.requiresLinearPlayback = false
                }
            }
        } else {
            print(" PiP isn't supported by the current device. Disable the PiP button.")
            pipButton?.isEnabled = false
            pipButton?.isHidden = true
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
    
    func resetPlayerItems() {
        if self.goLiveBtn != nil  && isGoLiveBtnAvailable == false{
//            self.timeRangePlayer = nil
            self.goLiveBtn?.isHidden = true
            self.startOverOrGoLiveButton.isHidden = true
            self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
            self.startOverFlag = true
        }
    }
    
    @objc internal func playerWillResignActive(_ aNotification: Notification) {
        if (self.player != nil){
            self.playerStateInBackGroundMode = self.player.playbackState.rawValue
            self.comingFromBackground = false
            DispatchQueue.main.async {
                if self.adsManager != nil{
                    self.adsManager?.pause()
                }
                
                if self.isPreviewContent == true && self.previewSecondsRemaining > 4 {
                    self.previewTimer?.invalidate()
                    self.previewTimer = nil
                }
            }
        }
    }
    @objc internal func playerDidBecomeActive(_ aNotification: Notification) {
        self.stopAnimating1(#line)
        if self.willEnterForeground == true {
            self.willEnterForeground = false
            self.comingFromBackground = true
            if self.playBtn != nil && self.player != nil && !self.player.avplayer.isExternalPlaybackActive && self.isWarningMessageDisplayed == false {
                if self.isMidRollAdPlaying == false {
                    if self.player.playbackState == .paused {
                        self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                    }
                }
                else if self.adsManager != nil{
                    self.adsManager?.resume()
                }
                if self.isPreviewContent == true && previewSecondsRemaining > 4 {
                    self.previewTimer?.invalidate()
                    self.previewTimer = nil
                    self.previewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(previewSecondsRemaining), target: self, selector: #selector(PlayerViewController.handlePreviewEnd), userInfo: nil, repeats: false)
                }
            }
        }
        else{
            self.comingFromBackground = true
            if  (self.player != nil){
                
                if pictureInPictureController != nil && pictureInPictureController.isPictureInPicturePossible {
                    // not required to pause the content.
                }
                else{
                    if (self.playerStateInBackGroundMode == PlaybackState.playing.rawValue){
                        self.buttonAction(sender: self.playBtn!)
                    }
                    else{
                        self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                    }
                }
            }
            DispatchQueue.main.async {
                if self.adsManager != nil{
                    self.adsManager?.resume()
                }
            }
        }
        if self.player != nil  && self.isMidRollAdPlaying == false && self.isWarningMessageDisplayed == false {
            self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(self.player.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
        }
    }
    @objc internal func playerDidEnterBackground(_ aNotification: Notification) {
        if appContants.isEnabledAnalytics && self.player != nil && self.analytics_meta_id != "" && self.analytics_meta_data.count > 0 {
            if pictureInPictureController != nil && pictureInPictureController.isPictureInPicturePossible {
                // not required to pause the content.
//                pictureInPictureController.startPictureInPicture()
            }
            else{
                if self.adsManager != nil && self.isMidRollAdPlaying == true {
                    logAnalytics.shared().triggerLogEvent(.trigger_ad_completed_by_user, position: 0)
                }
                logAnalytics.shared().closeSession(false)
            }
        }
    }
    
    @objc internal func playerWillEnterForeground(_ aNoticiation: Notification) {
        self.willEnterForeground = true
        if appContants.isEnabledAnalytics && self.player != nil && self.analytics_meta_id != "" && self.analytics_meta_data.count > 0 {
            if self.player.playerItem != nil {
                if pictureInPictureController != nil && pictureInPictureController.isPictureInPicturePossible {
                    // not required to pause the content.
                }
                else {
                    logAnalytics.shared().initSession(withMetaData: self.analytics_meta_data as! [AnyHashable : Any]?)
                    logAnalytics.shared().attach(self.player.avplayer)
                }
            }
        }
        if self.player != nil && !self.player.avplayer.isExternalPlaybackActive && self.adsManager != nil && self.isMidRollAdPlaying == true {
            if self.analytics_meta_data.count > 0 {
                self.analytics_meta_data["adType"] = self.adTypeToPlay
                logAnalytics.shared().updateMetaData(self.analytics_meta_data as! [AnyHashable : Any]?)
            }
            logAnalytics.shared().triggerLogEvent(.trigger_ad_start, position: 0)
           
        }
        if self.analytics_info_contentType == "live" {
            if self.isMinimized == false {
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = false
                    if appContants.appName == .tsat ||  appContants.appName == .aastha {
                        self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        
                    }
                    else {
                        //MARK: as per client requirement startover button is not required
                        self.startOverOrGoLiveButton.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
            }
            else{
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = true
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
                }
            }
            self.goLiveFlag = true
        }
        
        if self.player != nil && self.isMidRollAdPlaying == true && self.isWarningMessageDisplayed == true {
            self.player.pause()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skipButton.isHidden = true
        if self.defaultPlayingItemView != nil {
//        self.defaultPlayingItemView.translatesAutoresizingMaskIntoConstraints = false
        }
//        UIApplication.shared.statusBarStyle = .lightContent
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        AppDelegate.getDelegate().isPlayerPage = true
        if !self.isSharingFlowClicked {
            if AppDelegate.getDelegate().detailsViewController != nil && AppDelegate.getDelegate().detailsViewController?.detailsTableView != nil {
//                AppDelegate.getDelegate().detailsViewController?.detailsTableView.reloadData()
            }
            if TabsViewController.instance.HomeToolBarCollection != nil {
                TabsViewController.instance.HomeToolBarCollection.collectionViewLayout.invalidateLayout()
            }
            if AppDelegate.getDelegate().contentViewController != nil && AppDelegate.getDelegate().contentViewController?.homeCV != nil {
                AppDelegate.getDelegate().contentViewController?.homeCV.collectionViewLayout.invalidateLayout()
            }
//            let appDelegate = AppDelegate.getDelegate()
//            appDelegate.shouldRotate = true
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
        }
        if !isDownloadContent {
            self.loadApiForPlayerUrlInErrorCase()
            self.pushEvents(false, "")
        }

    }
    
    func pushEvents(_ isPlayerControl:Bool, _ controlType:String) {
        if !isDownloadContent {
        var contentName = ""
        var recommendationsArrStr = [String]()
        var prefferedBitRate:String = ""
        for pageData in self.pageDataResponse.data {
            if pageData.paneType == .content {
                let content = pageData.paneData as? Content
                contentName = (content?.title)!
            } else {
                let section = pageData.paneData as? Section
                recommendationsArrStr.append(section?.sectionInfo.name ?? "")
            }
        }
        if self.player != nil {
            if self.player.avplayer.currentItem != nil {
                let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                prefferedBitRate = String(format:"%.1f", floor((playitem.preferredPeakBitRate/1024)))
            }
        }
        
        if self.analytics_info_dataType == "tvshowepisode" || self.analytics_info_dataType == "episode" {
            if isPlayerControl {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"TV_Show":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate, "Player_Controls":controlType])
            } else {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"TV_Show":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate])
            }
        } else if self.analytics_info_dataType == "movie"{
            if isPlayerControl {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Movies":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate, "Player_Controls":controlType])
            } else {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Movies":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate])
            }
        } else if self.analytics_info_dataType == "channel"{
            if isPlayerControl {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Live_TV":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate, "Player_Controls":controlType])
            } else {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Live_TV":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate])
            }
        } else if self.analytics_info_dataType == "epg"{
            if isPlayerControl {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Catchup":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate, "Player_Controls":controlType])
            } else {
                LocalyticsEvent.tagEventWithAttributes("Player_Page", ["Content_Type":self.analytics_info_contentType,"Catchup":contentName, "Language":OTTSdk.preferenceManager.selectedLanguages, "Recommendations":recommendationsArrStr.joined(separator: ","), "Bit_Rate":prefferedBitRate])
            }
        }
    }
    }
    
    @objc func loadApiForPlayerUrlInErrorCase(){
        self.sign_signup_MsgLbl?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            AppDelegate.getDelegate().removeStatusBarView()
            UIApplication.shared.hideSB()
        }
        if isFromErrorFlow {
            self.startAnimating1(#line, allowInteraction: false)
            if AppDelegate.getDelegate().cancelOTPFromPlayer {
                self.loadPlayerSuggestions(loginViewStatus: false)
                AppDelegate.getDelegate().cancelOTPFromPlayer = false
            }
            if !Utilities.hasConnectivity() && self.isDownloadContent == false {
                self.stopAnimating1(#line)
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()) { (buttonTitle) in }
                return
            }
            let qosClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qosClass)
            backgroundQueue.async(execute: {
                OTTSdk.mediaCatalogManager.pageContent(path: self.pageDataResponse.info.path, onSuccess: { (response) in
                    self.pageDataResponse = response
                    
                    self.skipIntroStartTime = -1
                    self.skipIntroEndTime = -1
                    
                    if self.pageDataResponse.info.attributes.introStartTime > 0 {
                        self.skipIntroStartTime = self.pageDataResponse.info.attributes.introStartTime
                    }
                    if self.pageDataResponse.info.attributes.introEndTime > 0 {
                        self.skipIntroEndTime = self.pageDataResponse.info.attributes.introEndTime
                    }
                    
                    self.updateRecordButtonImage()
                    self.updateFavoriteButtonUI()
                    if self.pageDataResponse != nil && self.pageDataResponse.adUrlResponse.adUrlTypes.count > 0{
                        for b in self.pageDataResponse.adUrlResponse.adUrlTypes{
                            print("b:\(b.urlType.rawValue) and \(b.url)")
                            if b.urlType == .preUrl {
                                if !b.url.isEmpty{
                                    self.adUrlToPlay = b.url
                                    self.adTypeToPlay = "0"
                                }
                            }
                        }
                    }
                    self.didStartDisplay()
                }, onFailure: { (error) in
                    self.stopAnimating1(#line)
                })
            })
        }
        else {
            if playerVC != nil && playerVC?.player != nil {
                if playerVC!.adsManager != nil && isMidRollAdPlaying == true {
                    playerVC!.adsManager!.resume()
                }
                else if playerVC?.player?.playbackState == .paused {
                    playerVC?.player.playFromCurrentTime()
                }
            }
        }
        self.onMinView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.getDelegate().isPlayerPage = true
        AppDelegate.getDelegate().removeStatusBarView()
        UIApplication.shared.hideSB()
        if self.isSharingFlowClicked {
            self.isSharingFlowClicked = false
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.stopAnimating1(#line)
            }
            let tmpHeight = self.playerHeightActual()
            if self.playerWidth != nil && self.playerHeight != nil{
            self.playerWidth.constant = (self.winFrm?.size.width)!
            self.playerHeight.constant = tmpHeight
            }
            if self.defaultPlayingItemViewViewHeightConstraint != nil {
                self.defaultPlayingItemViewViewHeightConstraint.constant = tmpHeight
            }
            if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
                self.playerControlsWidth.constant = (self.winFrm?.size.width)!
                self.playerControlsHeight.constant = tmpHeight
            }
            if self.playerHolderView != nil {
            self.playerHolderView.frame.origin = CGPoint(x: 0.0, y: 20.0)
                if self.playerIndicatorView != nil {
            self.playerIndicatorView?.center = self.playerHolderView.center
                }
            }
//            UIApplication.shared.isStatusBarHidden = false
            if self.playBtn != nil && self.playBtn?.tag != 2 && self.player != nil{
                self.player.playFromCurrentTime()
            }
        }
        else if self.playerHolderView != nil {
            self.playerHolderView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().isPlayerPage = false
    }

    func didStartDisplay()  {
        
        suggestionsView.delegate = self
        comingUpNextView.delegate = self
        resetLastChannelButtonWidthConstraint()
        //Navigation UI Fills
        let contentInformation = self.contentInformation()
        navTitleLable?.text = contentInformation.title
        navSubTitleLable?.text = contentInformation.subTitle
        self.navExpiryLable?.isHidden = (contentInformation.expiryDaysText.count > 0 ? false : true)

        self.navExpiryLable?.text = contentInformation.expiryDaysText
        self.navExpiryLable?.sizeToFit()
        self.navExpiryLabelWidthConstraint?.constant = (self.navExpiryLable?.frame.size.width ?? 0) + 20.0
        navExpiryLable?.changeBorder(color: .red)
        navExpiryLable?.viewBorderWithOne(cornersRequired: true)
        self.navExpiryLable?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        
        self.minimizedViewTitleLbl?.font = UIFont.ottRegularFont(withSize: 14)
        self.minimizedSubtitleLbl?.font = UIFont.ottRegularFont(withSize: 12)
        self.minimizedViewTitleLbl?.text = contentInformation.title
        self.minimizedSubtitleLbl?.text = contentInformation.subTitle
        self.minimizedSubtitleLbl?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        let imageUrl = ((contentInformation.imageUrl?.count ?? 0) > 0) ?  contentInformation.imageUrl! : contentInformation.logo
        navImageView?.loadingImageFromUrl(imageUrl, category: "")
        self.comingFromBackground = false
        self.updateRecordButtonImage()
        self.updateFavoriteButtonUI()
        if self.pageDataResponse != nil {
            
            self.nextContentButtonWidthConstraint?.constant = 0
            self.lastChnlBtnLeadConstraint?.constant = 0
            if self.nextContentButton != nil {
                self.nextContentButton.isHidden = true
                if self.pageDataResponse.info.attributes.nextButtonTitle.count > 0 {
                    self.nextContentButton.setTitle(self.pageDataResponse.info.attributes.nextButtonTitle, for: UIControl.State.normal)
                }
            }
          
            isPlayerAddedToView = false
            self.getPlayerStreamContent(streamPin: "")
            self.nextContentButtonWidthConstraint?.constant = 0
            self.lastChnlBtnLeadConstraint?.constant = 0
            
             let attributes = self.pageDataResponse.info.attributes
             if ((attributes.contentType == "epg") && (attributes.isLive == true)) == false{
                OTTSdk.mediaCatalogManager.nextVideoContent(path: self.pageDataResponse.info.path, offset: -1, count: 1, onSuccess: { (response) in
                   
                    _ = self.comingUpNextView
                    self.comingUpNextView.initiate(card: response.data.first,headerLabelText: self.pageDataResponse.info.attributes.recommendationText)
                    
                    
                    if response.data.count > 0 {
                     
                        self.nextVideoContent = response.data.first
                        if self.pageDataResponse.info.attributes.showNextButton == "true" {
                            self.nextContentButtonWidthConstraint?.constant = 95
                            self.lastChnlBtnLeadConstraint?.constant = 10
                            //self.nextContentButton.isHidden = false
                        }
                    }
                    
                }, onFailure: { (error) in
             print(error.message)
             })
             }
        }
        if (self.castSession != nil && self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem != nil && (self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem?.mediaInformation.streamDuration.isInfinite)! == false) {
            self.castSession.remoteMediaClient?.stop()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
//        if fromInterfaceOrientation == .portrait {
//            self.playerHolderView.frame = UIScreen.main.bounds
//            print(UIScreen.main.bounds)
//             self.playerHolderHeightConstraint.constant = UIScreen.main.bounds.height
//            self.view.bringSubview(toFront: self.playerHolderView)
//            self.view.bringSubview(toFront: self.navView)
//        }else{
//            self.playerHolderHeightConstraint.constant = 260
//            self.navViewHeightConstraint.constant = 80
//            self.view.bringSubview(toFront: self.navView)
//        }
//    }
    
    
    func backAction() {
        self.stopAnimating1(#line)
        AppDelegate.getDelegate().notificationCA = ""
        AppDelegate.getDelegate().notificationCR = ""
//        UIApplication.shared.statusBarStyle = .lightContent
        if self.player == nil {
            return
        }
        if isDownloadContent {
            if self.player != nil {
                self.player.pause()
            }
            isPlayerLoaded = false
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().closeSession(false)
            }
            if self.analytics_info_contentType != "live" && self.analytics_info_contentType != ""  {
                self.addToContinueWatchingList(isAddingNextEpisode: false)
            }
            for tabControllKey in TabsViewController.instance.tabsControllersRefreshStatus.keys {
                if tabControllKey != TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath {
                    if tabControllKey != "guide" {
                        TabsViewController.instance.tabsControllersRefreshStatus[tabControllKey] = false
                    }
                }
            }
        }
        
        self.removeObserver()
        if self.myTimer != nil{
            self.myTimer?.invalidate()
            self.myTimer = nil
        }
        /*if self.player.timeObserver != nil {
            self.player.avplayer.removeTimeObserver(self.player.timeObserver)
            self.player.timeObserver = nil
        }*/
        if self.player != nil {
            self.player.pause()
            if self.player.timeObserver != nil {
                self.player.avplayer.removeTimeObserver(self.player.timeObserver!)
                self.player.timeObserver = nil
            }
            if !isDownloadContent {
                self.player.avplayer.replaceCurrentItem(with: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetContinueWatchingList"), object: nil)
                NotificationCenter.default.removeObserver(self)
            }
        }
        if isDownloadContent {
            self.player.delegate = nil
            self.player.playerView.player = nil
            self.player.avplayer.pause()
            self.player.setupPlayerItem(nil)
        }

        self.player = nil
        self.castMediaController.delegate = nil
        self.castSession = nil
        self.sessionManager.remove(self)
    }
    
    func addToContinueWatchingList(isAddingNextEpisode:Bool) {
        return;
        let percentWatched = getTotalPercentageWatched()
        if percentWatched <= 98 {
            self.updateTheContinueWatchingList(isAddingNextEpisode: false)
        }
        else if percentWatched < 1{
            self.removeTheShowEpisodeIfalreadyExists()
        }
//        else if percentWatched > 98 {
//            self.removeTheShowEpisodeIfalreadyExists()
//            // adding next episode of the tvshow, only when it is not from continue watching section.
//            if self.nextEpisodesSectionDict.count > 0 {
//                let episodesArray = self.nextEpisodesSectionDict["data"] as! NSArray
//                if episodesArray.count > 0 {
//                    episodeModelDict = episodesArray.object(at: 0) as! NSDictionary
//                }
//                self.updateTheContinueWatchingList(isAddingNextEpisode: true)
//            }
//        }
    }

    

    
    @IBAction func infoTap(_ sender: Any) {
        self.hideAllTheControls()
        if (self.currentVideoContent?.template.count ?? 0) > 0{
            PartialRenderingView.instance.reloadFor(card: self.currentVideoContent!, content: self.contentObj, showInfoOnly: true, partialRenderingViewDelegate: self, isFromPlayer : true)
        }
        else{
            let contentInformation = self.contentInformation()
            let imageUrl = ((contentInformation.imageUrl?.count ?? 0) > 0) ?  contentInformation.imageUrl! : contentInformation.logo
            PartialRenderingView.instance.reloadFor(title: contentInformation.title, subTitle: contentInformation.subTitle, imageUrl: imageUrl, description: contentInformation.description, isFromPlayer: true, subTitle1: contentInformation.subTitle1, cast: contentInformation.cast, status: contentInformation.expiryDaysText,statusElementSubtype: contentInformation.expiryElementSubtype)
        }
    }
    
    @IBAction func seekFwdAction(_ sender: AnyObject) {
        if self.playBtn != nil && self.playBtn?.tag != 2 {
            var seconds : Int64 = Int64(sliderPlayer.value)
            if seconds > 0 {
                seconds = seconds + 10
                let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                if self.player != nil {
                    if self.player.maximumDuration.isFinite && !self.player.maximumDuration.isLess(than: Double(seconds))
                    {
                        if self.startTime != nil {
                            self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
                            currentTime = self.startTime.text!
                        }
                        self.startAnimating1(#line, allowInteraction: false)
                        seekEndValue = Int64(seconds)
                        //                    self.getLogAnalyticsEventDict(eventType: PlayerEventType.SEEKING)
                        //                    if lastEvent != PlayerEventType.BUFFER_START {
                        //                        printLog(log: "lastEvent:2- \(player.bufferingState)" as AnyObject)
                        //                        self.getLogAnalyticsEventDict(eventType: PlayerEventType.BUFFER_START)
                        //                    }
                        if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
                            castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
                            if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                                castSession.remoteMediaClient?.play()
                                if self.playBtn != nil {
                                self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                                }
                            }
                            if self.player.avplayer.isExternalPlaybackActive {
                                self.reportSeekEvent(true)
                                self.player!.seekToTime(targetTime)
                                self.reportSeekEvent(false)
                                if self.player.playbackState == .paused {
                                    self.player.pause()
                                    self.stopAnimating1(#line)
                                }
                            }
                        } else {
                            self.reportSeekEvent(true)
                            self.player!.seekToTime(targetTime)
                            self.reportSeekEvent(false)
                            if self.player.playbackState == .paused {
                                self.player.pause()
                            }
                            //if self.analytics_info_contentType == "live" {
                                self.stopAnimating1(#line)
                            //}
                        }
                    }
                    else {
                        if self.sliderPlayer != nil && Int64(sliderPlayer.value) == 0 {
                            if self.startTime != nil {
                            self.startTime.text = "00:00"
                            }
                        }
                        self.stopAnimating1(#line)
                    }
                }
            }
            self.pushEvents(true, "10s Forward")
        }
    }
    
    @IBAction func seekBackAction(_ sender: AnyObject) {
        
        if self.playBtn != nil && self.playBtn?.tag != 2 {
            var seconds : Int64 = Int64(sliderPlayer.value)
            if seconds > 0 && seconds > 10{
                seconds = seconds - 10
                let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                if self.startTime != nil {

                self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
                currentTime = self.startTime.text!
                }
                self.startAnimating1(#line, allowInteraction: false)
                seekEndValue = Int64(seconds)
                /* self.getLogAnalyticsEventDict(eventType: PlayerEventType.SEEKING)
                 if lastEvent != PlayerEventType.BUFFER_START {
                 printLog(log: "lastEvent:2- \(player.bufferingState)" as AnyObject)
                 self.getLogAnalyticsEventDict(eventType: PlayerEventType.BUFFER_START)
                 }*/
                if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
                    let gckOpt = GCKMediaSeekOptions.init()
                    gckOpt.interval = Double(seconds)
                    castSession.remoteMediaClient?.seek(with: gckOpt)
//                    castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
                    if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                        castSession.remoteMediaClient?.play()
                        if self.playBtn != nil {
                            self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                        }
                    }
                    if self.player.avplayer.isExternalPlaybackActive {
                        self.reportSeekEvent(true)
                        self.player!.seekToTime(targetTime)
                        self.reportSeekEvent(false)
                        if self.player.playbackState == .paused {
                            self.player.pause()
                            self.stopAnimating1(#line)
                        }
                    }
                } else {

                    self.reportSeekEvent(true)
                    self.player!.seekToTime(targetTime)
                    self.reportSeekEvent(false)
                    if self.player.playbackState == .paused {
                        self.player.pause()
                        self.stopAnimating1(#line)
                    }
                    if self.analytics_info_contentType == "live" {
                        self.stopAnimating1(#line)
                        if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == true{
                            self.goLiveBtn?.isHidden = false
                            if appContants.appName == .tsat || appContants.appName == .aastha  {
                                if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                    self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                }
                                else {
                                    self.startOverOrGoLiveButton.isHidden = true
                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                }
                            }
                            else{
                                //MARK: as per client requirement startover button is not required
                                self.startOverOrGoLiveButton.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                            }
                        }
                    }
                }
            }
            self.pushEvents(true, "10s Rewind")
        }
    }

    /*
     @IBAction func ccTap(_ sender: Any) {
         if ccButton != nil{
             ccButton!.isSelected = !ccButton!.isSelected
             if self.subTitleType == .embedded{
                 _ = self.setEmbeddedSubtitle(isOn: self.ccButton!.isSelected)
             }
             else if self.subTitleType == .external{
                 self.setExternalSubtitle(isOn: self.ccButton!.isSelected)
             }
         }
     }
     
     */
    
    @IBAction func ccTap(_ sender: Any) {
        if self.closeCaptions.ccList.count > 1 {
            let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
            if ccButton?.isSelected == true {
                actionSheet.addAction(UIAlertAction(title: "Off", style: .default, handler: { (action) -> Void in
                    self.selectedActionTitle = action.title ?? ""
                    self.ccButton?.isSelected = false
                    
                    let switchUserDefaults = UserDefaults.standard
                    switchUserDefaults.set(false, forKey: "ccStatus")
                    switchUserDefaults.synchronize()
                    
                    if self.subTitleType == .embedded{
                        _ = self.setEmbeddedSubtitle(isOn: self.ccButton!.isSelected)
                    }
                    else if self.subTitleType == .external{
                        self.setExternalSubtitle(isOn: self.ccButton!.isSelected)
                    }
                    
                }))
            }
            for model in self.closeCaptions.ccList {
                actionSheet.addAction(UIAlertAction(title: model.language, style: .default, handler: { (action) -> Void in
                    //self.removeSubTitleObserver()
                    self.ccButton?.isSelected = true
                    let switchUserDefaults = UserDefaults.standard
                    switchUserDefaults.set(true, forKey: "ccStatus")
                    switchUserDefaults.synchronize()
                    self.selectedActionTitle = action.title ?? ""
                    self.defaultSubtitleLang = action.title ?? "English"
                    self.loadVideoSubtitle()
                    if self.subTitleType == .embedded{
                        _ = self.setEmbeddedSubtitle(isOn: self.ccButton!.isSelected)
                    }
                    else if self.subTitleType == .external{
                        self.setExternalSubtitle(isOn: self.ccButton!.isSelected)
                    }
                    
                }))
            }
            if #available(iOS 13.0, *) {
                for action in actionSheet.actions {
                    action.setValue(AppTheme.instance.currentTheme.cardTitleColor, forKey: "titleTextColor")
                }
            }
            if let index = actionSheet.actions.firstIndex(where: {$0.title == self.selectedActionTitle}), ccButton?.isSelected == true {
                actionSheet.actions[index].setValue(true, forKey: "checked")
            }
            actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .destructive, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }else {
            self.ccButton?.isSelected = !(self.ccButton?.isSelected ?? false)
            
            let switchUserDefaults = UserDefaults.standard
            switchUserDefaults.set(self.ccButton?.isSelected, forKey: "ccStatus")
            switchUserDefaults.synchronize()
            
            if self.subTitleType == .embedded{
                _ = self.setEmbeddedSubtitle(isOn: self.ccButton!.isSelected)
            }
            else if self.subTitleType == .external{
                self.setExternalSubtitle(isOn: self.ccButton!.isSelected)
            }
        }
    }

    @IBAction func nextContentTap(_ sender: Any) {
        self.nextVideoPlayBtnCLicked(sender)
        print(#function)
    }
    @IBAction func VodStartOverButtonTap(_ sender: Any) {
        self.player.seekToTime(CMTimeMake(value: Int64(0), timescale: 1))
        //self.player?.playFromCurrentTime()
    }
    
    func setLastWatchedContentPath(path : String){
        print("#play : add path : \(path)")
        if self.analytics_info_dataType == "channel"{
            let paths = appContants.lastWatchedContentPaths
            if paths?.last == path{
                return;
            }
            else{
                var updatedPaths = [String]()
                if paths == nil{
                    updatedPaths.append(path)
                }
                else{
                    updatedPaths.append(contentsOf: paths!)
                    updatedPaths.append(path)
                }
                appContants.lastWatchedContentPaths = updatedPaths
                resetLastChannelButtonWidthConstraint()
            }
        }
        else{
            print("#play : Not a channel")
        }
    }
    
    
    @IBAction func lastChannelTap(_ sender: Any) {
        print(#function)
        var paths = appContants.lastWatchedContentPaths
        if let path = paths?.popLast(){
            if path == playingItemTargetPath{
                if let butOnePath = paths?.popLast(){
                    paths?.append(path)
                    paths?.append(butOnePath)
                    let card = Card()
                    card.target.path = butOnePath
                    playingItemTargetPath = card.target.path
                    self.loopNextVideo(card)
                }
            }
            appContants.lastWatchedContentPaths = paths
            resetLastChannelButtonWidthConstraint()
        }
        else{
            lastChannelButtonWidthConstraint?.constant = 0
            if self.nextContentButtonWidthConstraint?.constant == 0 {
                self.lastChnlBtnLeadConstraint?.constant = 0
            }
            if self.lastChannelButtonWidthConstraint?.constant == 0 {
                self.startOverBtnLeadConstraint?.constant = 0
            }
            if self.startOverOrGoLiveButtonWidthConstraint?.constant == 0 {
                self.goLiveBtnLeadConstraint?.constant = 0
            }
        }
    }
    
    func removeCurrentPathInLastWatchedChannels(){
        var paths = appContants.lastWatchedContentPaths
        if let path = paths?.popLast(){
            if path != playingItemTargetPath{
                paths?.append(path)
            }
        }
        appContants.lastWatchedContentPaths = paths
    }
    
    func resetLastChannelButtonWidthConstraint(){
        let attributes = self.pageDataResponse.info.attributes
        if ((attributes.contentType == "epg") && (attributes.isLive == true)) == false{
            lastChannelButtonWidthConstraint?.constant = 0
            if self.nextContentButtonWidthConstraint?.constant == 0 {
                self.lastChnlBtnLeadConstraint?.constant = 0
            }
            if self.lastChannelButtonWidthConstraint?.constant == 0 {
                self.startOverBtnLeadConstraint?.constant = 0
            }
            if self.startOverOrGoLiveButtonWidthConstraint?.constant == 0 {
                self.goLiveBtnLeadConstraint?.constant = 0
            }
        }
        else{
            var paths = appContants.lastWatchedContentPaths
            if let index = paths?.lastIndex(of: self.playingItemTargetPath){
                paths!.remove(at: index)
            }
            if paths?.count == 0{
                lastChannelButtonWidthConstraint?.constant = 0
                self.startOverBtnLeadConstraint?.constant = 0
                if self.nextContentButtonWidthConstraint != nil &&  self.nextContentButtonWidthConstraint?.constant == 0 {
                    self.lastChnlBtnLeadConstraint?.constant = 0
                }
                if self.startOverOrGoLiveButtonWidthConstraint != nil &&  self.startOverOrGoLiveButtonWidthConstraint?.constant == 0 {
                    self.goLiveBtnLeadConstraint?.constant = 0
                }
            }
            else{
//                lastChannelButtonWidthConstraint?.constant = 75
//                self.startOverBtnLeadConstraint?.constant = 10
                //#warning("as per requirement no need to Show last channel")
                lastChannelButtonWidthConstraint?.constant = 0
                self.startOverBtnLeadConstraint?.constant = 0
            }
        }
        
    }
    
    @IBAction func startOverTap(_ sender: Any?) {
        self.pushEvents(true, "Start Over")
        
        let attributes = self.pageDataResponse.info.attributes
        let programStartTime = attributes.startTime
        
        var startSeconds: Int64 = 0
        let timeRanges = player.playerItem?.seekableTimeRanges
        if timeRanges != nil && (timeRanges?.count)! > 0 {
            if self.analytics_info_contentType == "live" && Int64(truncating: programStartTime) > 0 && (self.timeRangePlayer != nil) {
                let totalPlayTime = CMTimeGetSeconds(self.timeRangePlayer.duration)
                let timeDiffInSec = (Date().toMillis() - Int64(truncating: programStartTime)) / 1000
                startSeconds = Int64(CMTimeGetSeconds(self.timeRangePlayer.start))
                
                if Float64(timeDiffInSec) < totalPlayTime {
                    let seekToTime = (totalPlayTime-Float64(timeDiffInSec) + Float64(startSeconds))
                    if self.sliderPlayer != nil {
                        self.sliderValueDidChange(self.sliderPlayer)
                    }
                    self.player!.seekToTime(CMTimeMakeWithSeconds(seekToTime, preferredTimescale: 1))
                    self.reportSeekEvent(false)
                    if self.analytics_info_contentType == "live" {
                        self.sliderPlayer.oldValue = Float(seekToTime)
                        //self.sliderPlayer.maxForwardValue = Float(seekToTime)
                        self.isGoLiveBtnAvailable = false
                        self.goLiveBtn?.isHidden = false
                        if appContants.appName == .tsat || appContants.appName == .aastha  {
                            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                            }
                            else {
                                self.startOverOrGoLiveButton.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                            }
                        }
                        else {
                        //MARK: as per client requirement startover button is not required
                        self.startOverOrGoLiveButton.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                }
                else {
                    let contentInformation = self.contentInformation()
                    var duration = ""
                    if (AppDelegate.getDelegate().configs?.maxDvrDisplayText.count ?? 0) > 0{
                        duration = AppDelegate.getDelegate().configs!.maxDvrDisplayText
                    }
                    else{
                        duration = self.secondsToTimeInString(seconds: Int(CMTimeGetSeconds(self.timeRangePlayer.duration))).lowercased()
                    }
                    self.player.pause()
                    /* "Start Over can only go back \(duration), not to the beginning of this program. If you want to watch from the beginning, the full program will be available to watch in the Guide 30 minutes after it ends."*/
                    self.showAlertWithText(contentInformation.title, message: AppDelegate.getDelegate().configs!.startOverTextMessage, buttonTitles: ["Start Over","Cancel"]) { (buttonTitle) in
                        if buttonTitle == "Start Over"{
                            self.isGoLiveBtnAvailable = true
                            if self.sliderPlayer != nil {
                                self.sliderValueDidChange(self.sliderPlayer)
                            }
                            self.player!.seekToTime(CMTime.zero)
                            self.reportSeekEvent(false)
                            if self.analytics_info_contentType == "live" {
                                self.sliderPlayer.oldValue = 0.0
//                                self.sliderPlayer.maxForwardValue = 0.0
                            }
                            self.startOverFlag = false
                            if self.isMinimized == false {
                                if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == true {
                                    self.goLiveBtn?.isHidden = false
                                    if appContants.appName == .tsat || appContants.appName == .aastha {
                                        if UIDevice.current.orientation.isLandscape || self.orientation().isLandscape || self.isFullscreen {
                                            self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                        }
                                        else {
                                            self.startOverOrGoLiveButton.isHidden = true
                                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                        }
                                    }
                                }
                            }
                            else{
                                self.goLiveBtn?.isHidden = true
                                self.startOverOrGoLiveButton.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
                            }
                            
                            self.goLiveFlag = true
                        }
                        else if buttonTitle == "Cancel"{
                            // Do nothing
                            self.player.playFromCurrentTime()
                        }
                    }
                }
            }
            else {
                self.player.seekToTime(CMTimeMake(value: Int64(Int(0)), timescale: 1))
                self.player?.playFromCurrentTime()
            }
        }
    }
    func updateFavoriteButtonUI() {
        if pageDataResponse != nil {
            self.isFavourite = (self.pageDataResponse?.pageButtons.isFavourite)!
            let showFavouriteBtn = (self.pageDataResponse?.pageButtons.showFavouriteButton)!
            if showFavouriteBtn {
                if appContants.appName != .gac && isPreviewContent == false {
                    self.favInPlayer?.isHidden = false
                }
                else {
                    self.favInPlayer?.isHidden = true
                }
                self.setFavUI()
            }
            else {
                self.favInPlayer?.isHidden = true
            }
        }
    }
    func setFavUI() {
        if self.isFavourite == false {
            self.favInPlayer?.setImage(UIImage.init(named:"img_watchlist_circle_player"), for:UIControl.State.normal)
        }
        else {
            self.favInPlayer?.setImage(UIImage.init(named:"img_remove_watchlist_circle_player"), for:UIControl.State.normal)
        }
    }
    @IBAction func favoriteTap(_ sender: Any) {
        if OTTSdk.preferenceManager.user != nil {
            if self.isFavourite {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Removed"])
                OTTSdk.userManager.deleteUserFavouriteItem(pagePath: (self.pageDataResponse?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)

//                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
//                        FavouritesListViewController.instance.moviesCollection.reloadData()
//                    })
                    self.favInPlayer.setImage(UIImage.init(named:"img_watchlist_circle_player"), for:UIControl.State.normal)
                }, onFailure: { (error) in
                    print(error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message) { (message) in
                        
                    }
                })
            }
            else {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Added"])
                OTTSdk.userManager.AddUserFavouriteItem(pagePath: (self.pageDataResponse?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = true
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)
//                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
//                        FavouritesListViewController.instance.moviesCollection.reloadData()
//                    })
                    self.favInPlayer.setImage(UIImage.init(named:"img_remove_watchlist_circle_player"), for:UIControl.State.normal)
                }, onFailure: { (error) in
                    print(error.message)
                    self.stopAnimating()
                    self.showAlertWithText(message: error.message) { (message) in
                        
                    }
                })
            }
        }
        else {
            self.showAlertWithText(message: "Please sign in to add your videos to Favorite".localized) { (message) in
            }
        }
    }
    
    @IBAction func recordingTap(_ sender: Any) {
        if !self.pageDataResponse.info.attributes.isRecorded && self.pageDataResponse.info.attributes.isRecordingAllowed{
            self.hideAllTheControls()
            let contentInformation = self.contentInformation()
            var card : Card!
            if self.currentVideoContent != nil{
                card = self.currentVideoContent!
            }
            else{
                card = Card.init(["template" : contentInformation.contentCode,"target" : ["path" : self.pageDataResponse.info.path,"pageAttributes":["recordingForm":self.pageDataResponse.info.attributes.recordingForm]]])
            }
            PartialRenderingView.instance.reloadFor(card: card, content: self.contentObj, showOnlyRecordOptions: true, partialRenderingViewDelegate: self, isFromPlayer : true)
        }
    }
    
    func updateRecordButtonImage(){
        
        var imageName = "player-recording-off"
        if self.pageDataResponse.info.attributes.isRecorded{
            if self.streamResponse.analyticsInfo.contentType == "live"{
                imageName = "player-recording-live"
            }
            else{
                imageName = "player-recording-epg"
            }
        }
        else{
            imageName = "player-recording-off"
        }
        self.recordButton?.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
    }
    

    func record(confirm: Bool, content: Any?) {
        if confirm {
            self.pageDataResponse.info.attributes.isRecorded = true
            self.recordButton?.isEnabled = false
            self.updateRecordButtonImage()
            self.updateSliderForwardStatus()
        }
        if AppDelegate.getDelegate().isPartialViewLoaded == true{
            PartialRenderingView.instance.dismiss()
        }
        self.partialRenderingViewDelegate?.record(confirm: confirm, content: content)
    }
    
    func errorIn(partialRenderingView : PartialRenderingView, errorMessage : String){
        self.showAlertWithText(message: errorMessage, completion: { (buttonTitle) in

        })
    }
    
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        
    }

    @IBAction func nextVideoPlayBtnCLicked(_ sender: Any) {
        if self.nextVDOTimer != nil {
            self.nextVDOTimer!.invalidate()
            self.nextVDOTimer = nil
        }
        self.playNextVideo()
    }
    
    @IBAction func nextVideoCloseBtnClicked(_ sender: Any) {
        if self.nextVDOTimer != nil {
            self.nextVDOTimer!.invalidate()
            self.nextVDOTimer = nil
        }
    }
    
    // MARK: - play
    func asynchronouslyLoadURLAsset(newAsset: AVURLAsset) {
        /*
         Using AVAsset now runs the risk of blocking the current thread (the
         main UI thread) whilst I/O happens to populate the properties. It's
         prudent to defer our work until the properties we need have been loaded.
         */
        newAsset.loadValuesAsynchronously(forKeys: self.assetKeysRequiredToPlay) {
            /*
             The asset invokes its completion handler on an arbitrary queue.
             To avoid multiple threads using our internal state at the same time
             we'll elect to use the main thread at all times, let's dispatch
             our handler to the main queue.
             */
            DispatchQueue.main.async {
                /*
                 `self.asset` has already changed! No point continuing because
                 another `newAsset` will come along in a moment.
                 */
                guard newAsset == self.asset else { return }
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in self.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        // self.goBackAfterFailedToPlay(message: error?.localizedDescription)
                        return
                    }
                }
                
                // We can't play this asset.
                if !newAsset.isPlayable {
                    //self.goBackAfterFailedToPlay(message: nil)
                    return
                }
                
                /*
                 We can play this asset. Create a new `AVPlayerItem` and make
                 it our player's current item.
                 */
                if self.player != nil {
                    self.player.asset = newAsset
                    self.playerItem = AVPlayerItem(asset: newAsset)
                    self.comingUpNextView.player = self.player.avplayer
                }
                
                //                self.addObservers()
                /* self.convivaSession?.attachStreamer(self.player)*/
                
            }
        }
    }
    func updatePreviewElement(){
        
        self.previewTimer?.invalidate()
        self.previewTimer = nil
         
        if (self.pageDataResponse.streamStatus.hasAccess == false) && (self.pageDataResponse.streamStatus.previewStreamStatus == true){
            self.isPreviewContent = true
           // self.previewSecondsRemaining = self.pageDataResponse.streamStatus.totalDurationInMillis / 1000
            let totalPlayerDuration = self.pageDataResponse.streamStatus.totalDurationInMillis / 1000
            let previewDuration = Int(self.streamResponse.streams[0].params.duration) ?? 0
            self.previewSecondsRemaining = previewDuration > totalPlayerDuration ? totalPlayerDuration : previewDuration
           // self.previewSecondsRemaining = Int(self.streamResponse.streams[0].params.duration) ?? 0
            self.hideAllTheControls()
            if self.player != nil {
                self.previewLblView?.isHidden = (self.isMinimized == true && self.player.playbackState != .playing ? true : false)
            }
            else {
                self.previewLblView?.isHidden = true
            }
            self.previewDurationLbl?.text = "Preview ends in \(secondsToHoursMinutesSeconds(seconds: Int(previewSecondsRemaining)))"
            if  (previewDuration > 0) && (self.streamResponse.streamStatus.message.isEmpty == false){
                // enable
                self.sliderPlayer?.isUserInteractionEnabled = false
                self.sliderPlayer?.alpha = 0.5
                let warningMessage = self.streamResponse.streamStatus.message
                self.waringLabletext(text: warningMessage)
                self.previewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(previewSecondsRemaining), target: self, selector: #selector(PlayerViewController.handlePreviewEnd), userInfo: nil, repeats: false)
                self.startOverOrGoLiveButton?.isHidden = true
                self.startOverBtn?.isHidden = true
                self.goLiveBtn?.isHidden = true
                self.nextContentButton?.isHidden = true
            }
        }
        else{
            self.warningLbl?.isHidden = true
            self.sliderPlayer?.isUserInteractionEnabled = true
            self.sliderPlayer?.alpha = 1
            if self.previewTimer != nil{
                self.previewTimer?.invalidate()
                self.previewTimer = nil
            }
        }
    }
    func waringLabletext(text:String) {
        self.warningLbl?.isHidden = false
        let fullString = NSMutableAttributedString(string: "")

        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "info_icon.png")

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: "     \(text)"))

        // draw the result in a label
        warningLbl?.attributedText = fullString

    }
    
    @objc func handlePreviewEnd(){
        if self.player != nil {
            self.player.pause()
        }
        if self.previewTimer != nil{
            self.previewTimer?.invalidate()
            self.previewTimer = nil
        }
        self.isWarningMessageDisplayed = true
        
        var alertButtons = (AppDelegate.getDelegate().configs?.showIosPackages ?? false) ? ["Cancel","Subscribe"] : ["OK"]
       
        if OTTSdk.preferenceManager.user == nil {
            alertButtons = ["Sign in","Cancel"]
        }
        
        let message = self.pageDataResponse.streamStatus.message
        
        self.showAlertWithText(message: message, buttonTitles: alertButtons) { (buttonTitle) in
            if (buttonTitle == "Cancel" || buttonTitle == "OK") {
                self.closePlayer()
                self.isWarningMessageDisplayed = false
            }
            else if buttonTitle == "Subscribe"{
                let message = AppDelegate.getDelegate().configs?.resSErrorNeedPaymentIos ?? ""
                self.showAlertWithText(message: (message.count > 0 ? message : "Please subscribe to a package by visiting our website !!!") ) { (title) in
                    self.closePlayer()
                    self.isWarningMessageDisplayed = false
                }
            }
            else if buttonTitle == "Sign in"{
                self.isFromErrorFlow = true
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                storyBoardVC.viewControllerName = "PlayerVC"
                if  playerVC != nil{
                    playerVC?.showHidePlayerView(true)
                }
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
            }
        }
    }
    func play(){
        print("----------------play--------------")
        
        if ( playerInstance.streams.defaultFairplayStream.sType == "fairplay"){
            loaderDelegate.playerInstance = self.playerInstance
            loaderDelegate.fetchAppCertificateDataWithCompletionHandler { _ in
                /*
                 Create an asset for the media specified by the playlist url. Calling the setter
                 for the asset property will then invoke a method to load and test the necessary asset
                 keys before playback.
                 */
                if let playlistURL = URL(string: playerInstance.streams.defaultFairplayStream.url) {
                    
                    self.videoUrlString = playlistURL.absoluteString
                    self.buildAnalyticsMetaData()
                    
                    let asset = AVURLAsset(url: playlistURL, options: .none)
                    self.asset = asset
                    if self.player != nil {
                        if self.player.playbackState == .playing {
                            self.player.pause()
                        }
                        self.player.setupPlayerItem(nil)
                        self.player.setupAsset(asset)
                        self.comingUpNextView.player = self.player.avplayer
                        self.startPolling()
                    }
                }
            }
        }
        else if let playlistURL = URL(string: playerInstance.streams.defaultStream.url) {
            
            self.videoUrlString = playlistURL.absoluteString
            self.buildAnalyticsMetaData()
            if self.player != nil && self.player.playbackState == .playing {
                self.player.pause()
            }
            if self.player != nil {
                self.player.setupPlayerItem(nil)
                let asset = AVURLAsset(url: playlistURL as URL, options: .none)
                self.player.setupAsset(asset)
                self.comingUpNextView.player = self.player.avplayer
            
                self.startPolling()
            }
        }
//        self.loadPlayerSuggestions(loginViewStatus: false, offlineContent: isDownloadContent)
    }
    private func showPinAlertWithMessage(message : String, errorMsg : String, pinText : String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let attributedString = NSMutableAttributedString(string: message + errorMsg)
        if errorMsg.count > 0 {
            guard let range = attributedString.string.range(of: errorMsg) else {return}
            let nsRange = NSRange(range, in: attributedString.string)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
        }
        alertController.setValue(attributedString, forKey: "attributedMessage")
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter PIN"
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.text = pinText
            textField.isSecureTextEntry = true
        }
        alertController.addAction(UIAlertAction(title: "CANCEL".localized, style: .default, handler:{ action in
            self.closePlayer()
        }))
        alertController.addAction(UIAlertAction(title: "CONFIRM".localized, style: .default, handler: { action in
            if let pinTf = alertController.textFields?.first! {
                guard let pin = pinTf.text, pin.count > 0 else {
                    self.showPinAlertWithMessage(message: message, errorMsg: "\n\nPlease enter PIN", pinText: pinTf.text ?? "")
                    return
                }
                guard pin.count == AppDelegate.getDelegate().parentalControlPinLength else {
                    self.showPinAlertWithMessage(message: message, errorMsg: "\n\nPlease enter valid PIN", pinText: pin)
                    return
                }
                self.getPlayerStreamContent(streamPin: pin)
            }
        }))
        if presentedViewController != nil {
            self.dismiss(animated: true, completion: {
                self.present(alertController, animated: true, completion: nil)
            })
        }else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func getPlayerStreamContent(streamPin : String) {
        self.alertController = nil
        if self.startOverOrGoLiveButtonWidthConstraint != nil {
            self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
        }
        if self.nextContentButtonWidthConstraint?.constant == 0 {
            self.lastChnlBtnLeadConstraint?.constant = 0
        }
        if self.lastChannelButtonWidthConstraint?.constant == 0 {
            self.startOverBtnLeadConstraint?.constant = 0
        }
        if self.startOverOrGoLiveButtonWidthConstraint != nil && self.startOverOrGoLiveButtonWidthConstraint?.constant == 0 {
            self.goLiveBtnLeadConstraint?.constant = 0
        }
        self.analytics_meta_id = ""
        if !Utilities.hasConnectivity() && self.isDownloadContent == false {
            self.stopAnimating1(#line)
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                self.closePlayer()
            }
            return
        }
        self.resetPlayerItems()
        
        let showSubscriptionPopup = ((self.pageDataResponse.streamStatus.hasAccess == false) && (self.pageDataResponse.streamStatus.previewStreamStatus == false))
        if showSubscriptionPopup{
            self.handlePreviewEnd()
            return;
        }
        
        if self.skipButton != nil {
            self.skipButton.isHidden = true
        }
        self.isSkipIntroShow = false
        let qosClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        backgroundQueue.async(execute: {
            OTTSdk.mediaCatalogManager.stream(path: self.pageDataResponse.info.path, network_type: String().getNetworkType(), stream_type:self.pageDataResponse.info.attributes.playerType, stream_pin: streamPin , onSuccess: { (response) in
                //        OTTSdk.mediaCatalogManager.getEncryptedStream(payLoad: dictionary, onSuccess: { (response) in
//                if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
//                    self.pinNumberTextField.text = ""
//                    keyWindow.addSubview(self.pinView)
//                }
                self.isDownloadContent = false
                if self.adDisplayPostionsArray.count > 0{
                    self.adDisplayPostionsArray.removeAll()
                }
                print(response)
                self.streamResponse = response
                self.analyitcs_info_obj = response.analyticsInfo
                self.chatChannelId = "\(response.analyticsInfo.id)"
                //self.maxBitrateAllowed = (response.maxBitrateAllowed == 0) ? (AppDelegate.getDelegate().configs?.allowedMaxStreamBitrate ?? 6000) : response.maxBitrateAllowed
                self.analytics_info_contentType = response.analyticsInfo.contentType
                
                if self.analytics_info_contentType == "live" {
                    self.playBackSpeedArray = ["0.25x","0.5x","0.75x","Normal"]
                    self.selectedPlayBackSpeed = "Normal"
                }
                else {
                    self.playBackSpeedArray = ["0.25x","0.5x","0.75x","Normal","1.25x","1.50x","1.75x","2x"]
                }
                self.updateRecordButtonImage()
                for pageEventInfo in self.pageDataResponse.pageEventInfo {
                    if (pageEventInfo.eventCode == .stream_end && pageEventInfo.targetType == .api && pageEventInfo.targetPath == "next_video") {
                        self.nextContentButton.setTitle(pageEventInfo.targetParams.buttonText, for: UIControl.State.normal)
                        self.nextContent(path: self.pageDataResponse.info.path)
                        break
                    }
                }
                
                self.updateSliderForwardStatus()
                if self.startOverOrGoLiveButtonWidthConstraint != nil {
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.analytics_info_contentType == "live" ? 85 : 0
                }
                self.analytics_info_dataType = response.analyticsInfo.dataType
                self.pushEvents(false, "")
                
                if response.analyticsInfo.dataType.lowercased() == "epg" {
                    self.analytics_info_contentType = ""
                }
                /*------------------------Analytics ----------------------*/
                self.analytics_meta_id = response.analyticsInfo.dataKey
                /*------------------------Analytics ----------------------*/
                
                //For VOD's, look back – Next video ; For TV shows-- Next Episode
                /* if response.analyticsInfo.contentType == "vod" {
                 if self.nextContentButton != nil {
                 if response.analyticsInfo.dataType == "epg"{
                 self.nextContentButton.setTitle("Next Class", for: UIControl.State.normal)
                 }
                 else if response.analyticsInfo.dataType == "movie"{
                 self.nextContentButton.setTitle("Up Next", for: UIControl.State.normal)
                 }
                 else{
                 self.nextContentButton.setTitle("Next Class", for: UIControl.State.normal)
                 }
                 }
                 else{
                 self.nextContentButton.setTitle("Next Class", for: UIControl.State.normal)
                 }
                 }*/
                
                
                if self.vodStartOverButton != nil {
                    if self.analytics_info_contentType != "live" && self.analytics_info_contentType != "channel"  {
                        //self.vodStartOverButton.isHidden = false
                        self.vodStartOverButtonWidthConstraint?.constant = 85
                        self.vodStartOverButtonTrailingConstraint?.constant = 10
                    }
                    else {
                        self.vodStartOverButton.isHidden =  true
                        self.vodStartOverButtonWidthConstraint?.constant = 0
                        self.vodStartOverButtonTrailingConstraint?.constant = 0
                    }
                }
                //            self.loadPlayerSuggestions(loginViewStatus: false)
                let streamsArray = response.streams
                
                self.playerInstance.contentType = ContentType.tvShow
                if self.playerInstance.streams.allStreams.count > 0 {
                    self.playerInstance.streams.allStreams.removeAll()
                }
                
                let newStream = StreamResult()
                self.playerInstance.streams.defaultFairplayStream = newStream
                self.playerInstance.streams.defaultStream = newStream
                self.updatePreviewElement()
                
                for streamResponse in streamsArray {
                    var streamings = StreamResult()
                    streamings.sType =  streamResponse.streamType
                    streamings.url = streamResponse.url
                    
                    //MOVIE STREAM
                    //streamings.url = "https://moviesyupp4-vh.akamaihd.net/i/549719/teleup/vubx/VUBX_05683727_1468034_2_,350,650,1600,2200,k.mp4.csmil/master.m3u8?hdnts=st=1562069596~exp=1562091196~acl=!*/i/549719/teleup/vubx/VUBX_05683727_1468034_2_,350,650,1600,2200,k.mp4.csmil/*!/payload/yupptvott_7_1_F57D489D-93B5-4E24-8A5E-62CC4480C661_US_0.0.0.0_frndlytv_1_movie_9_Wifi/*~data=yupptvott_7_1_F57D489D-93B5-4E24-8A5E-62CC4480C661_US_0.0.0.0_frndlytv_1_movie_9_Wifi~hmac=73a2801c2d98e19c6c4fe41a015b55f50b8250cbd650d94060eefeb3c43f760c"
                    
                    
                    /* DRM : STREEM TEST
                     streamings.url = "https://teleupon1.akamaized.net/ondemand/290049/vubiquity/vubx_08265870_2260548_2/221472/fps/stream.m3u8?hdnea=st=1562317921~exp=1562321521~acl=*~hmac=c2433544f69584d8d1edfa1037158f84417a192f27379814b99a1a13b5 738eaa"
                     streamings.sType = "fairplay"
                     streamResponse.keys.licenseKey = "http://fp.service.expressplay.com/hms/fp/rights/?ExpressPlayToken=AQAAABgmKdIAAABQ8cybQpMbWwdBJ4704pTJlABSOdz9lt6GPzeFhdankmwSljs0GN5Y6VpIaaTwknSHZhzFtAOPKQ2Eglz0sdu8OhmkT8PKWMPs0tiAhtu5_OvFMBIkLOf66QwKNpMsateefnJ36g"
                     */
                    
                    let isDefault = streamResponse.isDefault
                    streamings.isDefault = isDefault
                    self.closeCaptions = streamResponse.closeCaptions
                    self.defaultSubtitleLang = self.closeCaptions.defaultLang
                    self.selectedActionTitle = self.defaultSubtitleLang
                    self.loadVideoSubtitle()
                    streamings.licenseKeys.certificate = streamResponse.keys.certificate
                    streamings.licenseKeys.license = streamResponse.keys.licenseKey
                    streamings.previewDuration = Int(streamResponse.params.duration) ?? 0
                    if streamings.sType == "fairplay"{
                        self.playerInstance.streams.defaultFairplayStream = streamings
                    }else{
                        self.playerInstance.streams.defaultStream = streamings
                    }
                    self.playerInstance.streams.allStreams.append(streamings)
                }
                
                var vdict_cc : Any?
                var urlString:String = ""
                for stream in streamsArray{
                    if (stream.streamType == "hls") || (stream.streamType == "fairplay"){
                        let dict = stream
                        self.printLog(log:dict)
                        urlString = dict.url
                    }
                    else if (stream.streamType == "widevine"){
                        vdict_cc = stream
                        self.videoUrlString_ChromeCast = stream.url
                        self.playerLicenseUrl = stream.keys.licenseKey
                    }
                }
              
                if vdict_cc == nil{
                    self.videoUrlString_ChromeCast = urlString
                }
              
                if urlString .isEmpty {
                    if let streamResult = self.playerInstance.streams.allStreams.first {
                        urlString = streamResult.url
                    }
                }
                //self.selectedPlayBackSpeed = "Normal"
                self.setLastWatchedContentPath(path: self.playingItemTargetPath)
                self.loadVideo(urlString: urlString)
                self.loadPlayerSuggestions(loginViewStatus: false)
                self.setLiveProgramChangeNotifications()
                self.enableTakeaTestButtonNotifications()
                self.playerErrorCode = 0
            }) { (error) in
                let deadlineTime = DispatchTime.now() + .milliseconds(1000)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    if self.playerHolderView != nil {
                        self.playerHolderView.isHidden = false
                    }
                }
                self.stopAnimating1(#line)
                self.playerErrorCode = error.code
                self.isFromErrorFlow = true
                if error.code == -14 {
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.isHidden = self.isMinimized
                    }
                    
                    self.showAlertWithText(message: error.message, buttonTitles: ["Verify".localized,"Cancel".localized], completion: { (buttonTitle) in
                        if buttonTitle == "Verify".localized{
                            if !(OTTSdk.preferenceManager.user?.isPhoneNumberVerified)! {
                                if (OTTSdk.preferenceManager.user?.phoneNumber .isEmpty)! {
                                    let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "VerifyMobileViewController") as! VerifyMobileViewController
                                    storyBoardVC.viewControllerName = "PlayerVC"
                                    if  playerVC != nil{
                                        playerVC?.view.isHidden = true
                                    }
                                    let topVC = UIApplication.topVC()!
                                    topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                                }
                                else {
                                    let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                    storyBoardVC.viewControllerName = "PlayerVC"
                                    storyBoardVC.otpSent = false
                                    storyBoardVC.identifier = OTTSdk.preferenceManager.user?.phoneNumber
                                    storyBoardVC.actionCode = 2
                                    if  playerVC != nil{
                                        playerVC?.view.isHidden = true
                                    }
                                    let topVC = UIApplication.topVC()!
                                    topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                                }
                            }
                        }
                        else if buttonTitle == "Cancel".localized{
                            self.closePlayer()
                        }
                    })
                }
                else if error.code == -15 {
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.isHidden = self.isMinimized
                    }
                    self.showAlertWithText(message: error.message, buttonTitles: ["Verify".localized,"Cancel".localized], completion: { (buttonTitle) in
                        if buttonTitle == "Verify".localized{
                            if !(OTTSdk.preferenceManager.user?.isEmailVerified)! && !(OTTSdk.preferenceManager.user?.email .isEmpty)! {
                                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                storyBoardVC.viewControllerName = "PlayerVC"
                                storyBoardVC.otpSent = false
                                storyBoardVC.identifier = OTTSdk.preferenceManager.user?.email
                                storyBoardVC.actionCode = 4
                                let topVC = UIApplication.topVC()!
                                topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                            }
                        }
                        else if buttonTitle == "Cancel".localized{
                            self.closePlayer()
                        }
                    })
                }
                
                if error.code == -1000 {
                    if self.defaultPlayingItemView != nil && self.player != nil {
                        self.player.pause()
                        self.defaultPlayingItemView.isHidden = self.isMinimized
                    }
                    self.loadPlayerSuggestions(loginViewStatus: true)
                    if self.navView != nil{
                        self.navView.alpha = 1.0
                        self.navView.isHidden = false
                    }
                }
                else if error.code == 402 || error.code == -4 {
                    self.player?.pause()
                    self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: true) { (flag) in
                        if flag {
                            self.closePlayer()
                        }
                    }
                    self.loadPlayerSuggestions(loginViewStatus: false)
                    return;
                }else if error.code == -820 || error.code == -821 {
                    self.showPinAlertWithMessage(message: AppDelegate.getDelegate().parentalControlPopupMessage, errorMsg: "", pinText: "")
                }else if error.code == -823 {
                    self.showPinAlertWithMessage(message: AppDelegate.getDelegate().parentalControlPopupMessage, errorMsg: "\n\n" + error.message, pinText: "")
                }
                else {
                    self.loadPlayerSuggestions(loginViewStatus: false)
                }
                self.hideControls = true
                self.showHideControllers()
                if self.navView != nil{
                    self.navView.alpha = 1.0
                    self.navView.isHidden = false
                }
                self.showAlertWithText(message: error.message, completion: { (buttonTitle) in
                    if error.code != -1000 {
                        self.closePlayer()
                    }
                    else {
                        if self.isFullscreen {
                            self.minimizeButtonTouched(self.minimizeButton)
                        }
                    }
                })
            }
        })
    }
    
    /// Jira : https://yupptv.atlassian.net/browse/YOP-6005
    func nextContent(path : String) -> Void {
        self.startAnimating1(#line, allowInteraction: false)
        if (self.streamResponse.analyticsInfo.contentType == "vod" &&  self.streamResponse.analyticsInfo.dataType == "epg"){
            OTTSdk.mediaCatalogManager.nextEpgsContent(path: path, offset: -1, count: 1, onSuccess: { (response) in
                self.updateNextContentResponse(response: response, error: nil)
            }, onFailure: { (error) in
                self.updateNextContentResponse(response: nil, error: error)
            })
        }
        else{
            OTTSdk.mediaCatalogManager.nextVideoContent(path: path, offset: -1, count: 1, onSuccess: { (response) in
                self.updateNextContentResponse(response: response, error: nil)
            }, onFailure: { (error) in
                self.updateNextContentResponse(response: nil, error: error)
            })
        }
    }
    
    func updateNextContentResponse(response : SectionData?, error : APIError?){
        if response != nil{
            _ = self.comingUpNextView
            if response!.data.count > 0 {
                self.nextVideoContent = response!.data.first
                self.comingUpNextView.shouldShow = (self.analytics_info_contentType != "live")
                if (self.analytics_info_contentType != "live"){
                    self.comingUpNextView.initiate(card: response!.data.first,headerLabelText: self.pageDataResponse.info.attributes.recommendationText)
                    if self.nextContentButtonWidthConstraint != nil, self.lastChnlBtnLeadConstraint != nil{
                        self.nextContentButton.sizeToFit()
                        self.nextContentButtonWidthConstraint?.constant = self.nextContentButton.frame.size.width + 20
                        self.lastChnlBtnLeadConstraint?.constant = 10
                    }
                }
                else{
                    self.nextContentButton.isHidden = true
                    self.nextContentButtonWidthConstraint?.constant = 0
                    self.lastChnlBtnLeadConstraint?.constant = 0
                }
            } else {
                self.nextVideoContent = nil
            }
        }
        else if error != nil{
            print(error!.message)
            self.nextVideoContent = nil
            self.stopAnimating1(#line)
        }
    }
    private func removeSrtLocalPath(localPathName:String) {
        let filemanager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(localPathName)
        do {
            try filemanager.removeItem(atPath: destinationPath)
            Log(message: "Local path removed successfully")
        } catch let error {
            Log(message: "------Error \(error.localizedDescription)")
        }
    }
    func loadVideoSubtitle() {
        self.captionsList = self.closeCaptions.ccList
        for ccData in self.self.closeCaptions.ccList {
            if ccData.language == self.defaultSubtitleLang {
                removeSrtLocalPath(localPathName: "sample.\(ccData.fileType)")
                let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                let captionFilePath = documentsPath.appendingPathComponent("sample.\(ccData.fileType)")
                PlayerViewController.load(url: URL.init(string: ccData.filePath)!, to: captionFilePath!) {
                   _ = self.addPlayerSubTitles()
                }
                break;
            }
        }
        if self.captionsList.count > 0 {
            if self.subtitlesBtn != nil {
                self.subtitlesBtn!.isHidden = false
                self.subTitlesBtnWidthConstraint?.constant = 20.0
            }
        }
        else {
            if self.subtitlesBtn != nil {
                self.subtitlesBtn!.isHidden = true
                self.subTitlesBtnWidthConstraint?.constant = 0.0
            }
        }
    }
    
    func playerLoadedTimeRanges(_ player: Player) {
        let timeRanges = player.playerItem?.seekableTimeRanges
        if (timeRanges?.count)! > 0{
            let timeRange: CMTimeRange = timeRanges![0].timeRangeValue
            self.timeRangePlayer = timeRange
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSeconds = CMTimeGetSeconds(timeRange.duration)
            // Set the minimum and maximum values of the time slider to match the seekable time range.
            //            print("player log: minimumValue: \(startSeconds), maximumValue:  \(startSeconds + durationSeconds), duration:  \(CMTimeGetSeconds(timeRange.duration))");
            if self.sliderPlayer != nil {
                if !startSeconds.isNaN {
                    self.sliderPlayer.minimumValue = Float(startSeconds)
                    self.sliderPlayer.maximumValue = Float(startSeconds + durationSeconds)
                    if self.endTime != nil {
                    self.endTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(durationSeconds)))"
                    }
                }
            }
            }
        }

    func loadPlayerSuggestions(loginViewStatus:Bool) {
        var showWatchPartyButton = false
        var sectionArr = [Section]()
        let tempContentType = self.pageDataResponse?.info.attributes.contentType ?? "live"
        
        if (tempContentType == "live" || tempContentType == "epg") {
            /*let tempChatSection = self.getStaticSection(code: "chatroom", contentType: tempContentType)
            sectionArr.append(tempChatSection)*/
            // not required for reeldrama and firstshows
        }
        else if (tempContentType == "tvshowepisode" || tempContentType == "tvshow" || tempContentType == "movie") && self.showWatchPartyMenu == true {
            let tempChatSection = self.getStaticSection(code: "chatroom", contentType: tempContentType)
            sectionArr.append(tempChatSection)
        }
        var castInfo:Section?
        for pageDataInfo in self.pageData {
            if pageDataInfo.paneType == .section {
                let section = pageDataInfo.paneData as? Section
                if (section?.sectionInfo.code == "grouplist_content_actors" ||  section?.sectionInfo.code == "playlist_content_actors" || section?.sectionInfo.code == "content_actors" || section?.sectionInfo.code == "movie_actors") {
                    castInfo = section
                }
                else{
                    sectionArr.append(section!)
                }
            }
        }
        if (tempContentType == "tvshowepisode" || tempContentType == "tvshow" || tempContentType == "movie") {
           /* let tempWatchPartySection = self.getStaticSection(code: "watchparty", contentType: tempContentType)
            sectionArr.append(tempWatchPartySection) */
            showWatchPartyButton = true
        }
        
        var isLive:Bool = false
        if self.analytics_info_contentType != nil {
            if (self.analytics_info_contentType == "live" || self.analytics_info_contentType == "epg") {
                //#warning disabling chat feature, If want to enable set isLive = true
                isLive = true
            }
        }
        
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        let newViewController = homeStoryboard.instantiateViewController(withIdentifier: "PlayerChildViewController") as! PlayerChildViewController
        self.currentViewController = newViewController
        newViewController.playerHeight = self.playerHolderView?.bounds.height ?? ((ScreenSize.SCREEN_MIN_LENGTH * 0.30) / 1.77)
        newViewController.currentObj = self.contentObj
        newViewController.castInfo = castInfo
        newViewController.sectionList = sectionArr
        newViewController.contentData = self.pageDataResponse
        newViewController.delegate = self
        newViewController.showLoginView = loginViewStatus
        newViewController.isLive = isLive
        newViewController.chatChannelId = self.chatChannelId
        newViewController.showWatchPartyMenu = self.showWatchPartyMenu
        newViewController.showWatchPartyButton = showWatchPartyButton
        newViewController.popUpBitRates = popUpBitRates
        // newViewController.errorCode = AppDelegate.getDelegate().showIosPackages ? self.playerErrorCode : 0
        newViewController.errorCode = 0
        newViewController.targetPath = pageDataResponse != nil ? self.pageDataResponse.info.path : ""
        // self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        // let deadlineTime = DispatchTime.now() + .milliseconds(1150)
        // DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        // self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = true
        // }
        newViewController.isOfflineContent = isDownloadContent
        if self.videoUrlString != nil {
            newViewController.playlistURL = self.videoUrlString
        }
        if self.analytics_meta_id != nil {
            newViewController.analyticsMetaID = self.analytics_meta_id
        }
        self.addChild(self.currentViewController!)
        if self.containerView != nil {
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }
        
    }
    @objc func handleZoomGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer?) {
        //if self.orientation() == .landscapeRight || self.orientation() == .landscapeLeft {
            if self.player.fillMode == AVLayerVideoGravity.resizeAspectFill.rawValue{
                self.player.fillMode = AVLayerVideoGravity.resizeAspect.rawValue
            }
            else{
                self.player.fillMode = AVLayerVideoGravity.resizeAspectFill.rawValue
            }
        /*}
        else {
            self.player.fillMode = AVLayerVideoGravity.resizeAspect.rawValue
        }*/
    }


    func loadVideo(urlString:String) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if isPlayerAddedToView {
            videoUrlString = urlString
            if (self.videoUrlString_ChromeCast == nil) || self.videoUrlString_ChromeCast .isEmpty || self.videoUrlString_ChromeCast == ""{
                 self.videoUrlString_ChromeCast = urlString
            }
            let videoUrl = URL(string: urlString)
            if !isDownloadContent {
                if !Utilities.hasConnectivity() && self.isDownloadContent == false {
                    self.stopAnimating1(#line)
                    self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                        self.closePlayer()
                    }
                    return
                }
            }
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            tapGestureRecognizer!.numberOfTapsRequired = 1
            self.player?.view.addGestureRecognizer(tapGestureRecognizer!)
            self.indicatorViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            indicatorViewTapGestureRecognizer?.numberOfTapsRequired = 1
            if self.playerIndicatorView != nil {
                self.playerIndicatorView?.addGestureRecognizer(indicatorViewTapGestureRecognizer!)
            }
            self.playerControlTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            self.playerControlTapGestureRecognizer!.numberOfTapsRequired = 1
            if self.playerControlsView != nil {
                self.playerControlsView.addGestureRecognizer(playerControlTapGestureRecognizer!)
            }

            if videoUrl != nil {
                self.getBitRate(from: videoUrl!)
            }
            //2 // self.player.setUrl(videoUrl!)
            self.isPlayBackEnd = false
            if !isDownloadContent {
                self.play()
            }
            return
        }
        if self.player != nil {
            self.removeObserver()
            self.player.view.removeFromSuperview()
            self.player = nil
        }
        
        
        videoUrlString = urlString
        if (self.videoUrlString_ChromeCast == nil) || self.videoUrlString_ChromeCast .isEmpty || self.videoUrlString_ChromeCast == ""{
             self.videoUrlString_ChromeCast = urlString
        }
//        if self.videoUrlString_ChromeCast != nil && self.videoUrlString_ChromeCast != "" && !self.videoUrlString_ChromeCast.contains("dw=") {
//            self.videoUrlString_ChromeCast = self.videoUrlString_ChromeCast + "&dw=0"
//        }
        printLog(log: "videoUrlString: \(urlString)" as AnyObject?)

        if sliderPlayer != nil {
            sliderPlayer.setThumbImage(UIImage(named: "player-slider-thumb"), for: .normal)
            sliderPlayer.setThumbImage(UIImage(named: "player-slider-thumb-selected"), for: .highlighted)
            sliderPlayer.minimumTrackTintColor = AppTheme.instance.currentTheme.themeColor
        }
       /*
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        if let trackLeftImage = UIImage(named: "scrubber_primary") { //this is the selected area (blue) on the left side of the slider
            let trackLeftResizable =
                trackLeftImage.resizableImage(withCapInsets: insets)
            if sliderPlayer != nil {
            sliderPlayer.setMinimumTrackImage(trackLeftResizable, for: .normal)
            }
        }
    
        if let trackRightImage =  UIImage.init(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)) { // and the right side, unselected area, grey
            let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
            if sliderPlayer != nil {
            sliderPlayer.setMaximumTrackImage(trackRightResizable, for: .normal)
            }
        }
 */
        
        self.view.autoresizingMask = ([UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight])
        
        self.player = Player()
        self.player.delegate = self
        self.printLog(log:self.view.bounds as AnyObject?)
        
        if self.playerHolderView != nil {
            self.player.view.frame = self.playerHolderView.bounds
        }
        self.player.view.autoresizesSubviews = true
        
        if sliderPlayer != nil {

        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChangeEnd(_:)), for: .touchUpInside)
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChangeEnd(_:)), for: .touchUpOutside)
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChangeEnd(_:)), for: .touchCancel)
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChange(_:)), for: .valueChanged)
            
            let gr = UITapGestureRecognizer(target: self, action: #selector(self.sliderTappedAction))
            sliderPlayer.addGestureRecognizer(gr)

        }
//
//        brightnessSlider = UISlider(frame: CGRect(x: CGFloat(0), y: CGFloat(60), width: CGFloat(120), height: CGFloat(70)))
//        brightnessSlider.addTarget(self, action: #selector(PlayerVC.sliderValueChanged), for: (.touchUpInside))
//        brightnessSlider.minimumValue = 0.0
//        brightnessSlider.maximumValue = 1.0
//        brightnessSlider.value = Float(UIScreen.main.brightness)
//        brightnessSlider.translatesAutoresizingMaskIntoConstraints = true
//        brightnessSlider.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
//        brightnessSlider.isHidden = true
//
//        volumeView = MPVolumeView(frame: CGRect(x: CGFloat(230), y: CGFloat(60), width: CGFloat(120), height: CGFloat(70)))
//        volumeView.showsVolumeSlider = true
//        volumeView.showsRouteButton = false
//        volumeView.translatesAutoresizingMaskIntoConstraints = true
//        volumeView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_2))
//        volumeView.isHidden = true
        
//        brightnessimage = UIImageView(image: UIImage(named: "brightness")!)
//        brightnessimage.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
//        brightnessimage.backgroundColor = UIColor.clear
//        brightnessimage.isHidden = true
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
//        panGesture.delegate = self
//        panGesture.maximumNumberOfTouches = 1
        
        if self.playBtn != nil {
            self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
            self.playBtn?.center = self.view.center
            self.playBtn?.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            self.playBtn?.tag = 1
        }
        
//        self.movieTvName.text = self.movieName
//        self.movieTvYear.text = self.movieYear
        
        
        self.castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(44), height: CGFloat(44)))
        castButton!.tintColor = UIColor.white
        castButton!.addTarget(self, action: #selector(PlayerViewController.castButtonSelected), for: UIControl.Event.touchUpInside)

        self.myVolumeView = MPVolumeView(frame: CGRect(x: castButton!.frame.size.width + 5.0, y: castButton!.frame.origin.y, width: CGFloat(54), height: CGFloat(44)))
        myVolumeView!.showsVolumeSlider = false
        //self.view.addSubview(myVolumeView!)

        if self.navBarButtonsStackView != nil {
            self.navBarButtonsStackView.insertArrangedSubview(myVolumeView!, at: 0)
            self.navBarButtonsStackView.insertArrangedSubview(castButton!, at: 1)
//                       self.navBarButtonsStackView.addArrangedSubview(myVolumeView!)
//                       self.navBarButtonsStackView.addArrangedSubview(castButton!)
            
            suggestionsButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            settingsButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            shareBtn!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            
            castButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            myVolumeView!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            chatButton!.widthAnchor.constraint(equalToConstant: 44).isActive = true
            self.navBarButtonsStackView.superview!.bringSubviewToFront(self.navBarButtonsStackView)
            self.navBarButtonsStackView.backgroundColor = .clear
        }
        
        self.comingUpNextView.superview!.bringSubviewToFront(self.comingUpNextView)
        
        self.player.avplayer.allowsExternalPlayback = true
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.player.avplayer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PlayerViewController.contentDidFinishPlaying123(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: self.player.avplayer.currentItem);
        if AppDelegate.getDelegate().showVideoAds && (self.player != nil && self.playerHolderView != nil /*&& self.player.avplayer.isExternalPlaybackActive == true*/) {
            if self.templateElement != nil {
                if self.templateElement!.elementCode != "resume" {
                    self.requestAds()
                }
            }
            else {
                 self.requestAds()
            }
        }
        
        if self.startTime != nil {
            self.startTime.text = "00:00"
        }
        let deadlineTime = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if self.playerHolderView != nil {
                self.playerHolderView.isHidden = false
            }
        }
        self.playerObserver = self.player.avplayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
            if self.playBtn != nil && self.playBtn?.tag == 2 && self.isMidRollAdPlaying == true {
                if self.player != nil {
                    self.player.pause()
                }
                return
            }
            //                self.printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
            if self.player.avplayer.currentItem?.status == .readyToPlay {
                //                self.player.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                //                                   options: NSKeyValueObservingOptions.new, context: self.playbackLikelyToKeepUpContext)
//                self.player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

                if self.player.maximumDuration .isFinite{
                    let _: Int = Int(self.player.maximumDuration)
                    self.view.isUserInteractionEnabled = true
                    if self.player.avplayer.isExternalPlaybackActive {
                        let duration : CMTime = CMTimeMake(value: Int64(self.player.maximumDuration), timescale: 1)
                        let seconds : Float64 = CMTimeGetSeconds(duration)
                        if self.sliderPlayer != nil {
                        self.sliderPlayer.maximumValue = Float(seconds)
                        }
                    } else {
                        /**/
                         let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                         if (self.mediaInfo != nil) && hasConnectedCastSession() && (self.player.playbackState.rawValue == PlaybackState.paused.rawValue || self.player.playbackState.rawValue == PlaybackState.playing.rawValue) {
                         self.player.pause()
                         }
                        
                    }
                    /*var minValue: Int = 0
                    var maxValue: Int = 0
                    if self.sliderPlayer != nil {
                        minValue = Int(self.sliderPlayer.minimumValue)
                        maxValue = Int(self.sliderPlayer.maximumValue)
                    }
                    let time: Float64 = self.player.currentTime
 */
                    //
                    if self.isSeeking == false {
                        if self.sliderPlayer != nil {
                            /*if self.isMidRollAdPlaying || (self.popUpOnceArrived && !self.isAlertBtnClicked) {
//                                self.player.pause()
                            } else {
                                if duration + minValue > 0{

                                    self.sliderPlayer.value = Float(Int((maxValue - minValue) * Int(time) / duration + minValue))
                                }
                            }*/
                        }
                    }
                    //
                    if (self.player.playbackState.rawValue == PlaybackState.playing.rawValue) && self.sliderPlayer != nil && self.sliderPlayer.isHidden == false && self.hideControls == false{
                        self.testVal = 1
                        self.hideControls = true
                        self.myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers), userInfo: nil, repeats: false)
                    }
                } else {
                    /*for playing automatically in chromecast if cast session there*/
                    
                    let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                    if hasConnectedCastSession() {
                        if (self.mediaInfo != nil) && (self.player.playbackState.rawValue == PlaybackState.paused.rawValue || self.player.playbackState.rawValue == PlaybackState.playing.rawValue) {
                            self.player.pause()
                            
//                            printYLog("========22===========",self.player.playbackState.rawValue,self.slideView.isHidden,self.hideControls)
                            //self._playBackMode = .local
                            //                            self.switchToRemotePlayback()
                        }else{
//                            self.switchToRemotePlaybackInitialize()
                        }
                    }
                    //printYLog("===================",self.player.playbackState.rawValue,self.slideView.isHidden,self.hideControls)
                    if (self.player.playbackState.rawValue == PlaybackState.playing.rawValue) && (self.slideView != nil && self.slideView.isHidden == false) && self.hideControls == false{
                        self.testVal = 3
                        self.hideControls = true
                        self.myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers), userInfo: nil, repeats: false)
                    }
                }
                if self.playBtn != nil {
                    self.playBtn?.isHidden = false
                    /*if self.analytics_info_contentType == "live" {
                        if self.seekFwd != nil && self.seekBckwd != nil {
                        self.seekFwd.isHidden = true
                        self.seekBckwd.isHidden = true
                        }
                    } else {*/
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        if self.sliderPlayer != nil {
                            if self.sliderPlayer.disableFarwardSeek == false {
                                self.seekFwd.isHidden = self.isPreviewContent ? true : false
                            }
                            else {
//                                 self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
                            }
                        }
                        else{
                            self.seekFwd.isHidden = self.sliderPlayer.disableFarwardSeek
                        }
                        self.seekBckwd.isHidden = self.isPreviewContent ? true : false
                    }
                    //}
                }
            }
            else if self.player.avplayer.currentItem?.status == .failed{
                self.videoUnknownOrFailed()
            }
            } as AnyObject
        
        if !self.isPlayerAddedToView {
            self.addChild(self.player)
            if self.playerHolderView != nil {
                self.playerHolderView.addSubview(self.player.view)
                self.playerHolderView.sendSubviewToBack(self.player.view)
            }
            self.player.view.autoresizingMask = ([UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight])
            self.player.didMove(toParent: self)
            
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            tapGestureRecognizer!.numberOfTapsRequired = 1
            self.player.view.addGestureRecognizer(tapGestureRecognizer!)
            self.indicatorViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            indicatorViewTapGestureRecognizer!.numberOfTapsRequired = 1
            if self.playerIndicatorView != nil {
                self.playerIndicatorView?.addGestureRecognizer(indicatorViewTapGestureRecognizer!)
            }
            self.playerControlTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            playerControlTapGestureRecognizer!.numberOfTapsRequired = 1
            if self.playerControlsView != nil {
                self.playerControlsView.addGestureRecognizer(playerControlTapGestureRecognizer!)
            }
            
            let playerViewZoomTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomGestureRecognizer(_:)))
            playerViewZoomTapGestureRecognizer.numberOfTapsRequired = 2
            self.tapGestureRecognizer?.require(toFail: playerViewZoomTapGestureRecognizer)
            self.indicatorViewTapGestureRecognizer?.require(toFail: playerViewZoomTapGestureRecognizer)
            self.playerControlTapGestureRecognizer?.require(toFail: playerViewZoomTapGestureRecognizer)
            if self.player != nil {
                self.player.view.addGestureRecognizer(playerViewZoomTapGestureRecognizer)
            }
            let playerZoomTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomGestureRecognizer(_:)))
            playerZoomTapGestureRecognizer.numberOfTapsRequired = 2
            self.tapGestureRecognizer?.require(toFail: playerZoomTapGestureRecognizer)
            self.indicatorViewTapGestureRecognizer?.require(toFail: playerZoomTapGestureRecognizer)
            self.playerControlTapGestureRecognizer?.require(toFail: playerZoomTapGestureRecognizer)
            if self.playerControlsView != nil {
                self.playerControlsView.addGestureRecognizer(playerZoomTapGestureRecognizer)
            }

//            self.player.view.addSubview(brightnessimage)
//            self.player.view.addGestureRecognizer(panGesture)
//            brightnessimage.center = self.view.center
            self.player.fillMode = "AVLayerVideoGravityResizeAspect"
            
            if self.sliderPlayer != nil {
                self.view.bringSubviewToFront(sliderPlayer)
                self.view.bringSubviewToFront(suggestionsView)
            }
            
            testVal = 2
            self.isPlayerAddedToView = true
        }
        let videoUrl = URL(string: urlString)
        
        if videoUrl != nil {
            if !Utilities.hasConnectivity() && self.isDownloadContent == false {
                self.stopAnimating1(#line)
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                    self.closePlayer()
                }
                return
            }
            //3 // self.player.setUrl(videoUrl!)
            
            self.play()
            self.player.playbackLoops = false
            self._playBackMode = .local
            self.getBitRate(from: videoUrl!)
            myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers), userInfo: nil, repeats: false)
            
//            self.perform(#selector(self.showHideControllers), with: NSNumber.init(value: true), afterDelay: 5)
        }
        else{
            self.stopAnimating1(#line)
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().sendError("Failed to load Video".localized)
                logAnalytics.shared().closeSession(true)
            }
            if self.adsManager != nil {
                self.adsManager?.destroy()
            }
            self.showAlertWithText(message: "Failed to load Video".localized){ (buttonTitle) in
                self.closePlayer()
            }
        }
        if AVPictureInPictureController.isPictureInPictureSupported() {
            // Create a new controller, passing the reference to the AVPlayerLayer.
            if self.player != nil && self.player.playerView != nil {
                let avpl = self.player.playerView.playerLayer
                pictureInPictureController = AVPictureInPictureController(playerLayer: avpl)
                pictureInPictureController?.delegate = self
            }
        }
        if #available(iOS 13.0, *) {
            if let startImage = UIImage.init(named: "img_pip") {
                pipButton?.setImage(startImage, for: .normal)
            }
            else{
                let startImage : UIImage = AVPictureInPictureController.pictureInPictureButtonStartImage
                pipButton?.setImage(startImage, for: .normal)
            }
            pipButton.imageView?.contentMode = .scaleAspectFit
            let stopImage : UIImage  = AVPictureInPictureController.pictureInPictureButtonStopImage
            pipButton?.setImage(stopImage, for: .selected)
        }
        self.pipButton?.isHidden = true
        self.setupPictureInPicture()
    }
    func playOfflineContent(_ playerAsset:Asset) {
        
        if self.sessionManager == nil {
            self.sessionManager = GCKCastContext.sharedInstance().sessionManager
            sessionManager.add(self)
        }
        
        if self.player.playbackState == .playing {
            self.player.pause()
        }
        self.analytics_meta_id = playerAsset.stream.analyticsMetaID
        self.buildAnalyticsMetaData()
        self.player.setupPlayerItem(nil)
        self.player.setupAsset(playerAsset.urlAsset)
        self.loadPlayerSuggestions(loginViewStatus: false)
//        self.loadPlayerSuggestions(loginViewStatus: false, offlineContent: true)
    }
    /*func loadPlayerSuggestions(loginViewStatus:Bool, offlineContent:Bool) {
        var sectionArr = [Section]()
        for pageDataInfo in self.pageData {
            if pageDataInfo.paneType == .section {
                let section = pageDataInfo.paneData as? Section
                if (section?.sectionInfo.code == "grouplist_content_actors" ||  section?.sectionInfo.code == "playlist_content_actors" || section?.sectionInfo.code == "content_actors" || section?.sectionInfo.code == "movie_actors") {
                    // not required to show cast
                }
                else{
                    sectionArr.append(section!)
                }
            }
        }

        var isLive:Bool = false
        if self.analytics_info_contentType != nil {
            if self.analytics_info_contentType == "live" {
                //#warning disabling chat feature, If want to enable set isLive = true
                isLive = true
            }
        }
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        let newViewController = homeStoryboard.instantiateViewController(withIdentifier: "PlayerChildViewController") as! PlayerChildViewController
        self.currentViewController = newViewController
        newViewController.isOfflineContent = offlineContent
        if self.videoUrlString != nil {
            newViewController.playlistURL = self.videoUrlString
        }
        if self.analytics_meta_id != nil {
            newViewController.analyticsMetaID = self.analytics_meta_id
        }
        newViewController.currentObj = self.contentObj
        newViewController.sectionList = sectionArr
        newViewController.contentData = self.pageDataResponse
        newViewController.delegate = self
        newViewController.isLive = isLive
        newViewController.chatChannelId = self.chatChannelId
        newViewController.showLoginView = loginViewStatus
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.currentViewController!)
        if self.containerView != nil {
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }
    }*/
    @objc func contentDidFinishPlaying123(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if AppDelegate.getDelegate().showVideoAds && self.player != nil{
            if (notification.object as! AVPlayerItem) == self.player.avplayer.currentItem {
                //adsLoader.contentComplete()
                self.isPlayBackEnd = true
            }
        }
    }
    func addPlayerPeriodicObserver() {
        self.startAnimating1(allowInteraction:true)
        self.playerObserver = self.player.avplayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
            //            if self.showReplayButton == true || self.playBtn.tag == 2 {
            //                return
            //            }
            //                self.printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
            if self.player.avplayer.currentItem?.status == .readyToPlay {
                //                self.player.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                //                                   options: NSKeyValueObservingOptions.new, context: self.playbackLikelyToKeepUpContext)
                self.player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                
                if self.player.maximumDuration .isFinite{
                    
                    
                    
                    let duration: Int = Int(self.player.maximumDuration)
                    self.view.isUserInteractionEnabled = true
                    if self.player.avplayer.isExternalPlaybackActive {
                        let duration : CMTime = CMTimeMake(value: Int64(self.player.maximumDuration), timescale: 1)
                        let seconds : Float64 = CMTimeGetSeconds(duration)
                        if self.sliderPlayer != nil {
                            self.sliderPlayer.maximumValue = Float(seconds)
                        }
                    } else {
                        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                        if (self.mediaInfo != nil) && hasConnectedCastSession() && (self.player.playbackState.rawValue == PlaybackState.paused.rawValue || self.player.playbackState.rawValue == PlaybackState.playing.rawValue) {
                            self.player.pause()
                        }
                    }
                    var minValue: Int = 0
                    var maxValue: Int = 0
                    if self.sliderPlayer != nil {
                        minValue = Int(self.sliderPlayer.minimumValue)
                        maxValue = Int(self.sliderPlayer.maximumValue)
                    }
                    let time: Float64 = self.player.currentTime
                    //
                    if self.isSeeking == false {
                        self.stopAnimatingPlayer(self.isMinimized)
                        if self.sliderPlayer != nil {
                            self.sliderPlayer.value = Float(Int((maxValue - minValue) * Int(time) / duration + minValue))
                        }
                        //                        self.printLog(log:"sliderPlayer value:\(self.sliderPlayer.value)" as AnyObject?)
                    }
                    //
                    if (self.player.playbackState.rawValue == PlaybackState.playing.rawValue) && self.sliderPlayer != nil && self.sliderPlayer.isHidden == false && self.hideControls == false{
                        self.testVal = 1
                        self.hideControls = true
                        self.myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers), userInfo: nil, repeats: false)
                    }
                    
                    if self.startTime != nil && self.currentTime != self.startTime.text! {
                        self.stopAnimatingPlayer(self.isMinimized)
                    }
                }
                if self.playBtn != nil {
                    self.playBtn?.isHidden = false
                    self.seekFwd.isHidden = self.isPreviewContent ? true : false
                    self.seekBckwd.isHidden = self.isPreviewContent ? true : false
                }
                //                self.airPlayActiveViewSub.center = self.playBtn.center
            }
            else if self.player.avplayer.currentItem?.status == .failed{
                self.videoUnknownOrFailed()
            }
            } as AnyObject?
        
    }
    func buildAnalyticsMetaData(_ autoPlay : String = "false") {
        if appContants.isEnabledAnalytics {
            let userId: String = {
                if let userId_tmp = OTTSdk.preferenceManager.user?.userId {
                    return "\(userId_tmp)"
                } else {
                    return "-1"
                }
            }()
            let userSubscribed: String = {
                if analyitcs_info_obj != nil, self.analyitcs_info_obj.packageType.count > 0 {
                    if (self.analyitcs_info_obj.packageType == "regular" ||  self.analyitcs_info_obj.packageType == "promo") {
                        return "1"
                    }
                    else{
                        return "0"
                    }
                } else {
                    return "0"
                }
            }()
            self.analytics_meta_data = [:]
            var streamURL = ""
            if self.videoUrlString.components(separatedBy: "?").count > 0 {
                streamURL = self.videoUrlString.components(separatedBy: "?").first!
            }
            var customdata = "-1"
            if analyitcs_info_obj != nil, self.analyitcs_info_obj.customData.count > 0 {
                customdata = self.analyitcs_info_obj.customData
            }
            if self.analytics_meta_id != "" {
                OTTSdk.appManager.updateLocation(onSuccess: { (locationResponse) in
                    self.analytics_meta_data = [
                        "appName": OTTSdk.preferenceManager.tenantCode.lowercased(),
                        "authKey": "\(PreferenceManager.sessionId)",
                        "playerUrl": streamURL,
                        "autoPlay": autoPlay,
                        "userId":  userId,
                        "isSubscribed": userSubscribed,
                        "navigatingFrom": AppAnalytics.navigatingFrom,
                        "eventMessage": "-1",
                        "meta_id": self.analytics_meta_id,
                        "gip": locationResponse.ipInfo.trueIP,
                        "isp": "-1",
                        "gcon": locationResponse.ipInfo.country,
                        "gren": locationResponse.ipInfo.region,
                        "gcity": locationResponse.ipInfo.city,
                        "attribute1" : customdata
                    ]
                    logAnalytics.shared().initSession(withMetaData: self.analytics_meta_data! as! [AnyHashable : Any])
                }, onFailure: { (error) in
                    self.analytics_meta_data = [
                        "appName": OTTSdk.preferenceManager.tenantCode.lowercased(),
                        "authKey": "\(PreferenceManager.sessionId)",
                        "playerUrl": streamURL,
                        "autoPlay": autoPlay,
                        "userId":  userId,
                        "isSubscribed": userSubscribed,
                        "navigatingFrom": AppAnalytics.navigatingFrom,
                        "eventMessage": "-1",
                        "meta_id": self.analytics_meta_id,
                        "gip":  "-1",
                        "isp":  "-1",
                        "gcon":  "-1",
                        "gren":  "-1",
                        "gcity":  "-1",
                        "attribute1" : customdata
                    ]
                    logAnalytics.shared().initSession(withMetaData: self.analytics_meta_data! as! [AnyHashable : Any])
                })
            }
        }
    }
    
    @IBAction func buttonActionGoLive(sender: UIButton) {
        self.pushEvents(true, "Go Live")
        if self.player != nil && self.player.playerItem != nil {
            let timeRanges = self.player.playerItem?.seekableTimeRanges
            if (timeRanges?.count)! > 0 {
                if self.sliderPlayer == nil {
                self.sliderValueDidChange(self.sliderPlayer)
//                self.startOverFlag = true
//                self.startOverBtn.isHidden = false
                }
                self.isGoLiveBtnAvailable = false
                if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == false{
                    self.goLiveBtn?.isHidden = true
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                            self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        else {
                            self.startOverOrGoLiveButton.isHidden = true
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                }
                self.goLiveFlag = false
                let time: Double = Double.greatestFiniteMagnitude
                if !(self.player.maximumDuration .isInfinite) && !(self.player.maximumDuration .isNaN) {
                    seekEndValue = Int64(self.player.maximumDuration)
                }
               
                let seekableRange = self.player.playerItem?.seekableTimeRanges.last?.timeRangeValue
                
                var seekableStart: CGFloat? = nil
                if let start = seekableRange?.start {
                    seekableStart = CGFloat(CMTimeGetSeconds(start))
                }
                
                var seekableDuration: CGFloat? = nil
                if let duration = seekableRange?.duration {
                    seekableDuration = CGFloat(CMTimeGetSeconds(duration))
                }
                
                let livePosition = (seekableStart ?? 0.0) + (seekableDuration ?? 0.0)

                 self.player!.seekToTime(CMTimeMakeWithSeconds(Float64(livePosition), preferredTimescale: Int32(Double(NSEC_PER_SEC))))
                
                
               // self.player!.seekToTime(CMTimeMakeWithSeconds(time, preferredTimescale: Int32(Double(NSEC_PER_SEC))))
                self.reportSeekEvent(false)
                
                if self.analytics_info_contentType == "live" {
                    self.sliderPlayer.oldValue = Float(livePosition)
//                    self.sliderPlayer.maxForwardValue = Float(livePosition)
                }
            }
        }

//        let card = Card()
//        card.display.imageUrl = self.defaultPlayingItemUrl
//        card.display.title = self.playingItemTitle
//        card.display.subtitle1 = self.playingItemSubTitle
//        card.target.path = self.goLiveTargetPath
//        self.didSelectedSuggestion(card: card)

        /*
        let timeRanges = player.playerItem?.seekableTimeRanges
        if (timeRanges?.count)! > 0 {
            self.sliderValueDidChange(self.sliderPlayer)
            let time: Double = Double.greatestFiniteMagnitude
            self.player!.seekToTime(CMTimeMakeWithSeconds(time, Int32(Double(NSEC_PER_SEC))))
            self.reportSeekEvent(false)
        }
         */
    }

    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        // Enable for sharing feature
        
        //Set the default sharing message.
        if self.isDownloadContent == false {
            let title = self.pageDataResponse.shareInfo.name
            //Set the link to share.
            var linkString = ""
            if AppDelegate.getDelegate().configs?.siteURL.last == "/" {
                linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")\(self.pageDataResponse.info.path)"
            } else {
                linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")/\(self.pageDataResponse.info.path)"
            }
            
            if let link = NSURL(string: linkString)
            {
                self.isSharingFlowClicked = true
                let objectsToShare = [title,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                if  productType.iPad   {
                    activityVC.excludedActivityTypes = []
                    activityVC.popoverPresentationController?.sourceView = self.view
                    let tempShareBtn:UIButton = sender as! UIButton
                    activityVC.popoverPresentationController?.sourceRect = tempShareBtn.frame
                }
                self.stopAnimating1(#line)
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }

    @IBAction func chatButtonAction(_ sender: AnyObject) {
       // self.chatButton.isHidden = true
       // self.chatButton.alpha = 0.0
        self.fullScreenTouched(chatButton)
    }

    @IBAction func subtitlesBtnClicked(_ sender: Any) {
        // Enable for subtitles feature with srt files
/*
        let vc = SubtitleLanguageViewController()
        vc.delegate = self
        if captionsList.count > 0 {
            vc.subTitleLangArry = captionsList
        }
        vc.defaultSubtitleLang = self.defaultSubtitleLang
        self.presentpopupViewController(vc, animationType: .bottomBottom, completion: { () -> Void in
        })*/
    }
    /*
    @IBAction func favouriteBtnClicked(_ sender: Any) {
        if self.isFavourite {
            self.startAnimating1(#line, allowInteraction: false)
            OTTSdk.userManager.deleteUserFavouriteItem(pagePath: self.pageDataResponse.info.path, onSuccess: { (response) in
                self.stopAnimating1(#line)
                self.isFavourite = false
                self.favouriteBtn.setImage( imageLiteral(resourceName: "circle_icon"), for: UIControl.State.normal)
                FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
                    FavouritesListViewController.instance.moviesCollection.reloadData()
                })
                
            }, onFailure: { (error) in
                print(error.message)
                self.showAlertWithText(message: error.message)
                self.stopAnimating1(#line)
            })
        }
        else {
            self.startAnimating1(#line, allowInteraction: false)
            OTTSdk.userManager.AddUserFavouriteItem(pagePath: self.pageDataResponse.info.path, onSuccess: { (response) in
                self.stopAnimating1(#line)
                self.isFavourite = true
                self.favouriteBtn.setImage( imageLiteral(resourceName: "check_selected"), for: UIControl.State.normal)
                FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (isFinished) in
                    FavouritesListViewController.instance.moviesCollection.reloadData()
                })
            }, onFailure: { (error) in
                print(error.message)
                self.showAlertWithText(message: error.message)
                self.stopAnimating1(#line)
            })
        }
    }*/

    @IBAction func nextVideoPlayBtnClicked(_ sender: Any) {
        if self.nextVDOTimer != nil {
            self.nextVDOTimer!.invalidate()
            self.nextVDOTimer = nil
        }
        self.playNextVideo()
    }

     //MARK: -  Polling
    func startPolling(){
        if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gac  {
            if self.streamPollTimer != nil{
                self.streamPollTimer?.invalidate()
                self.streamPollTimer = nil
            }
            self.streamPollTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.streamResponse.sessionInfo.pollIntervalInMillis/1000) , target: self, selector: #selector(PlayerViewController.poll), userInfo: nil, repeats: true)
            print("#Player : startPolling : \(self.streamResponse.sessionInfo.pollIntervalInMillis/1000)")
        }
    }
    
    @objc func poll(){
        if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gac  {
            
            if self.streamResponse.sessionInfo.streamPollKey.isEmpty == false {
                
                OTTSdk.mediaCatalogManager.poll(pollKey: self.streamResponse.sessionInfo.streamPollKey, event_type: pollEventType, onSuccess: { (successMessage) in
                    print("#Player : poll success \(successMessage)")
                }) { (error) in
                    if (error.code == -4401) || (error.code == -4402) || (error.code == -4000) || (error.code == -4001){
                        
                        if #available(iOS 14.0, *) {
                            if self.pictureInPictureController != nil {
                                self.pictureInPictureController.requiresLinearPlayback = true
                            }
                        }
                        
                        if self.streamPollTimer != nil{
                            self.streamPollTimer?.invalidate()
                            self.streamPollTimer = nil
                        }
                        if self.player != nil{
                            self.player.disablePlay = true
                            self.player.pause()
                        }
                        if self.pictureInPictureController != nil,  self.pictureInPictureController.isPictureInPictureActive {
                            self.pictureInPictureController.stopPictureInPicture()
                        }
                        /// -4401 --> stop the player and display the error message.
                        if (error.code == -4401) || (error.code == -4402){
                            var message = error.message
                            if let details = (error.details as? [String : Any]){
                                if let description = details["description"] as? String{
                                    message = description
                                }
                            }
                            self.showAlertWithText(message: message, buttonTitles: ["Continue"]) { (buttonTitle) in
                                if buttonTitle == "Continue"{
                                    self.closePlayer()
                                }
                            }
                        }
                        /// -4000 --> List the player sessions and ask user to end the few active streams
                        else if (error.code == -4000) || (error.code == -4001){
                            var message = error.message
                            if let details = (error.details as? [String : Any]){
                                if let description = details["description"] as? String{
                                    message = description
                                }
                            }
                            self.showActiveSteamsAlertAndProceed(title: error.message, message: message)
                        }
                    }
                    print("#Player : poll error \(error.message)")
                }
            }
            else{
                print("#Player : poll no key")
                // Without stream key there is no need of polling
                if self.streamPollTimer != nil{
                    self.streamPollTimer?.invalidate()
                    self.streamPollTimer = nil
                }
            }
            if self.player != nil && ((self.player.playbackState == .playing) || (self.player.playbackState == .paused)) && (pollEventType == 1){
                pollEventType = 2
            }
        }
    }

    
    func endPollAndStreamSession(pollKey : String){
        if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gac  {
            if self.streamPollTimer != nil{
                self.streamPollTimer?.invalidate()
                self.streamPollTimer = nil
            }
            pollEventType = 0
            OTTSdk.mediaCatalogManager.poll(pollKey: pollKey, event_type: pollEventType, onSuccess: { (successMessage) in
                self.endStreamSession(pollKey: pollKey)
            }, onFailure: { (error) in
                self.endStreamSession(pollKey: pollKey)
            })
        }
    }
    
    func endStreamSession(pollKey : String){
        if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gac  {
            OTTSdk.mediaCatalogManager.endStreamSession(pollKey: pollKey, onSuccess: { (successMessage) in
            }) { (error) in
            }
        }
    }
    
    //MARK: - ActiveStreamsDevicesViewCotrollerDelegate Methods
    func didClosedTheScreen(streamActiveSession : StreamActiveSession?, withSuccess : Bool = false){
        self.shouldHideMinimizedPlayer = false
        if withSuccess{
            DispatchQueue.main.async {
                self.view.window?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                self.expandViews(isInitialSetUp: false,"",41)
                let card = Card()
                card.target.path = self.playingItemTargetPath
                self.player.disablePlay = false
                self.loopNextVideo(card)
                playerVC?.view.isHidden = false
            }
        }
        else{
            self.closePlayer()
        }
    }
    
    //MARK: - Custom Methods
    func showActiveSteamsAlertAndProceed(title : String , message : String ){
        self.showAlertWithText(title, message: message, buttonTitles: ["Active Screens","Close Screen"]) { (buttonTitle) in
            if buttonTitle == "Active Screens"{
                let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
                let obj = storyBoard.instantiateViewController(withIdentifier: "ActiveStreamsDevicesViewCotroller") as! ActiveStreamsDevicesViewCotroller
                obj.delegate = self
                obj.isComingFromPlayerPage = true
                self.shouldHideMinimizedPlayer = true
                self.minimizeButtonTouched(self.minimizeButton!)
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(obj, animated: true)
                if #available(iOS 14.0, *) {
                    if self.pictureInPictureController != nil {
                        self.pictureInPictureController.requiresLinearPlayback = false
                    }
                }
            }
            else if buttonTitle == "Close Screen"{
                self.closePlayer()
            }
        }
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
    
    
    
    
    
    
    func removeObserver() -> Void {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if (self.playerObserver != nil) {
            self.player.avplayer.removeTimeObserver(self.playerObserver!)
            self.playerObserver = nil
        }
    }
 // MARK: - getBitRate
    func bitRateSelected(selected: String, displayType: String) {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        if (displayType == "playBackSpeed"){
            self.selectedPlayBackSpeed = selected
            var selectedValue = selected.replacingOccurrences(of: "x", with: "")
            selectedValue = selectedValue.replacingOccurrences(of: "X", with: "")
            if selectedValue.lowercased() == "normal"{
                selectedValue = "1"
            }
            if let tempVal = Float(selectedValue){
                self.player.playBackSpeed = tempVal
            }
            self.buttonAction(sender: self.playBtn!)
        }
        else{
            if appContants.appName == .mobitel {
                if ((AppDelegate.getDelegate().configs?.maxBitRate) ?? -1 != -1) {
                    let bitRateValue = Double(AppDelegate.getDelegate().configs!.maxBitRate)
                    self.player.avplayer.currentItem!.preferredPeakBitRate = floor(bitRateValue*1024)
                }
                else {
                    let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                    let bitRateValue = Double(selected)!
                    playitem.preferredPeakBitRate = floor(bitRateValue*1024)
                }
            }
            else {
                let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                let bitRateValue = Double(selected)!
                playitem.preferredPeakBitRate = floor(bitRateValue*1024)
            }
        }
    }
    
    func getBitRate(from urlToParse: URL) {
        self.mQualityButton?.alpha = 1.0
        self.mQualityButton?.isHidden = false
        self.bitRates.removeAllObjects()
//        bitRateSwithing = false
        if (urlToParse.absoluteString as NSString).range(of: ".m3u8", options: .caseInsensitive).location == NSNotFound {
            // for mp4 links
//            if self.mQualityButton != nil {
//                self.mQualityButton!.alpha = 0
//                self.mQualityButton!.isHidden = true
//            }
            isQualityOptionsFound = false
            return
        }
        self.mediaInfo = GCKMediaInformation()
        UserDefaults.standard.removeObject(forKey: "channelQuality")
        UserDefaults.standard.synchronize()
        if !isDownloadContent{
            if !Utilities.hasConnectivity() && self.isDownloadContent == false{
                self.stopAnimating1(#line)
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                    self.closePlayer()
                }
                return
            }
        }
        // read everything from text
        var fileContents:String = ""
        
        guard let myURL = NSURL(string: urlToParse.absoluteString) else {
            print("Error: \(String(describing: NSURL(string: urlToParse.absoluteString))) doesn't seem to be a valid URL")
            return
        }
        do {
            fileContents = try String(contentsOf: urlToParse, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Error: \(error)")
            if !self.isDownloadContent {
                if !Utilities.hasConnectivity() && self.isDownloadContent == false{
                    self.stopAnimating1(#line)
                    self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                        self.closePlayer()
                    }
                    return
                }
                else {
                    self.stopAnimating1(#line)
                    //                self.showAlertWithText(message: "Unable to load video".localized)
                }
            }
        }
        
        // first, separate by new line
        let allLinedStrings = fileContents.components(separatedBy: CharacterSet.newlines)
        let bandWidthAndResolutionArray = allLinedStrings.filter({$0.contains("#EXT-X-STREAM-INF")})
        let downloadUrlsArray = allLinedStrings.filter({$0.contains("https://")})
        for strsInOneLineTmp: String in allLinedStrings {
            // then break down even further
            if !(strsInOneLineTmp.contains("#EXT-X-I-FRAME-STREAM-INF")) {
                let strsInOneLine = strsInOneLineTmp.replacingOccurrences(of: "#EXT-X-STREAM-INF:", with: "")
                if (strsInOneLine as NSString).range(of: "BANDWIDTH", options: .caseInsensitive).location != NSNotFound {
                    let singleStrs = strsInOneLine.components(separatedBy: ",")
                    var bandWidthStr = ""
                    for chkBW: String in singleStrs {
                        if (chkBW as NSString).range(of: "BANDWIDTH", options: .caseInsensitive).location != NSNotFound {
                            bandWidthStr = chkBW
                            break;
                        }
                    }
                    let bitRateT = bandWidthStr.replacingOccurrences(of: "BANDWIDTH=", with: "")
                    if Double(bitRateT) != nil {
                        let bitRate: Double = Double(bitRateT)! / 1024
                        //                let convertedBitRate = NSNumber.init(integerLiteral: Int(bitRate))
                        if !bitRates.contains("\(bitRate)") {
                            if let _config = AppDelegate.getDelegate().configs {
                                if _config.maxBitRate == -1 {
                                    bitRates.add("\(bitRate)")
                                }
                                else {
                                    if Int(bitRate) < _config.maxBitRate {
                                        bitRates.add("\(bitRate)")
                                    }
                                }
                            }
                            else {
                                bitRates.add("\(bitRate)")
                            }
                        }
                    }
                }
            }
        }
        popUpBitRates.removeAll()
        popUpBitRates.append(["frame" : "", "bit_rate" : 265_000, "download_url" : self.videoUrlString])
        if bandWidthAndResolutionArray.count == downloadUrlsArray.count {
            for index in 0..<bandWidthAndResolutionArray.count {
                let seperatedBandWidth = bandWidthAndResolutionArray[index].components(separatedBy: ",").filter({$0.contains("BANDWIDTH")}).last!.components(separatedBy: "=").last!
                let seperatedResolution = bandWidthAndResolutionArray[index].components(separatedBy: ",").filter({$0.contains("RESOLUTION")}).last?.components(separatedBy: "=").last ?? ""
                popUpBitRates.append(["frame" : seperatedResolution, "bit_rate" : Int(seperatedBandWidth), "download_url" : downloadUrlsArray[index]])
            }
        }
        if bitRates.count > 1 {
            self.isQualityOptionsFound = true
//            if self.mQualityButton != nil {
//            self.mQualityButton!.alpha = 1
//            self.mQualityButton!.isHidden = false
//            }
        }
        else {
            if bitRates.count == 1 {
                let  tempVal = bitRates[0] as! String
                let bitRateValue = Double(tempVal) ?? 0.0
                self.player.avplayer.currentItem?.preferredPeakBitRate = floor(bitRateValue as! Double*1024)
            }
            self.isQualityOptionsFound = false
            //            if self.mQualityButton != nil {
            //            self.mQualityButton!.alpha = 0
            //            self.mQualityButton!.isHidden = true
            //            }
        }
    }
    
    // Handle notification.
    @objc func handleAVPlayerAccess(notification: Notification) {
        
        guard let playerItem = notification.object as? AVPlayerItem,
            let lastEvent = playerItem.accessLog()?.events.last else {
                return
        }
        
        let indicatedBitrate = lastEvent.indicatedBitrate
        PartialRenderingView.instance.bitrate = indicatedBitrate
        print("#player : quality : indicatedBitrate : \(indicatedBitrate)")
        // Use bitrate to determine bandwidth decrease or increase.
    }
    
    // MARK: - Subtitles Delegate
    func subtitleLangSelected(selected:String) {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        self.defaultSubtitleLang = selected
        if selected == "Off" {
            self.subtitleLabel?.isHidden = true
        }
        else {
            self.subtitleLabel?.isHidden = false
            self.captionsList = self.closeCaptions.ccList
            for ccData in self.self.closeCaptions.ccList {
                if ccData.language == self.defaultSubtitleLang {
                    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    let captionFilePath = documentsPath.appendingPathComponent("sample.\(ccData.fileType)")

                    PlayerViewController.load(url: URL.init(string: ccData.filePath)!, to: captionFilePath as! URL) {
                        self.addPlayerSubTitles()
                    }
                    break;
                }
            }
            if self.captionsList.count > 0 {
                if self.subtitlesBtn != nil {
                    self.subtitlesBtn!.isHidden = false
                }
                self.subTitlesBtnWidthConstraint?.constant = 20.0
            }
            else {
                if self.subtitlesBtn != nil {
                self.subtitlesBtn!.isHidden = true
                }
                self.subTitlesBtnWidthConstraint?.constant = 0.0
            }
        }
    }
    
    // MARK: - UIGestureRecognizer
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer?) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if self.isMinimized == true {
            self.expandViews(isInitialSetUp: false,"",42)
            return
        }
        if self.myTimer != nil{
            self.myTimer?.invalidate()
            self.myTimer = nil
//            hideControls = false
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideChatKeyBoard"), object: nil)
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            if !hideControls {
                if self.sliderPlayer != nil {
                    if !self.sliderPlayer.isHidden {
                        hideControls = true
                        testVal = 6
                        showHideControllers()
                    }
                    else if self.nextVideoContent == nil{
                        hideControls = false
                        testVal = 6
                        showHideControllers()
                    }
                }
            }
            else {
                if self.sliderPlayer != nil {
                if self.sliderPlayer.isHidden {
                    hideControls = false
                    testVal = 7
                    showHideControllers()
                }
                }
            }
            
            break
        case PlaybackState.paused.rawValue:
            if !hideControls {
                if self.sliderPlayer != nil {
                if !self.sliderPlayer.isHidden {
                    hideControls = true
                    testVal = 8
                    showHideControllers()
                }
                }
            }
            else {
                if self.sliderPlayer != nil {
                if self.sliderPlayer.isHidden {
                    hideControls = false
                    testVal = 9
                    showHideControllers()
                }
                }
            }
            break
        case PlaybackState.playing.rawValue:
//        if !hideControls {
            if !self.sliderPlayer.isHidden {
                hideControls = true
                testVal = 10
                showHideControllers()
            }
//        }
        else {
                if self.sliderPlayer.isHidden {
                    hideControls = false
                    testVal = 11
                    showHideControllers()
                    hideControls = true
                    testVal = 12
                    myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers), userInfo: nil, repeats: false)
                }
            }
        case PlaybackState.failed.rawValue:
            self.player.pause()
            if self.playBtn != nil {
                self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
            }
            self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(self.player.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
        default:
            self.player.pause()
            if self.playBtn != nil {
                self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
            }
            self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(self.player.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
        }
    }
    

    //MARK: - PlayerSuggestionsView delegate
    func didSelectedCard(card: Card, suggestionsView : PlayerSuggestionsView) -> Void{
        self.subtitleLabel?.isHidden = true

        hideControls = true
        showHideControllers()
        self.suggestionsView.suggestionsSwipeTap()
        
        var playableStatus:Bool = false
        if card.target.pageType == "player" {
            playableStatus = true
        }
        if playableStatus {
            self.loopNextVideo(card)
        } else {
            if productType.iPhone && (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) {
                let appDelegate = AppDelegate.getDelegate()
                appDelegate.shouldRotate = false
                let value = self.orientation().rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
                let value1 = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value1, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            self.delegate?.didSelectedSuggestion(card: card)
        }
         
    }
    
    // MARK: - PlayerDelegate
   
    func videoUnknownOrFailed()  {
        self.stopAnimating1(#line)
        if !Utilities.hasConnectivity() && self.isDownloadContent == false{
            if self.connectivityTimer != nil{
                self.connectivityTimer?.invalidate()
                self.connectivityTimer = nil
            }
            if appContants.isEnabledAnalytics {
                if !isDownloadContent {
                    logAnalytics.shared().sendError(AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    logAnalytics.shared().closeSession(true)
                }
            }
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                self.closePlayer()
            }
        }
        else {
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().closeSession(true)
            }
            self.showAlertWithText(message: PlaybackState.failed.description){ (buttonTitle) in
                self.closePlayer()
            }
//            eventMessageAnalytics = PlaybackState.failed.description
//            if self.session != nil && eventMessageAnalytics.count > 0{
//                self.session.reportError(PlaybackState.failed.description)
//            }
//            self.getLogAnalyticsEventDict(eventType: PlayerEventType.ERROR)
//            self.playerDestroyed()
        }
    }
    
    func playerInitialized(_ player: Player) {
        if appContants.isEnabledAnalytics {
            logAnalytics.shared().attach(player.avplayer)
        }
    }

    func playerRateDidChange(_ player: Player) {
        if self.player != nil{
          
            if (self.player.avplayer.timeControlStatus == .playing){
                self.stopAnimating1(#line)
            }
            else if self.player.avplayer.timeControlStatus == .waitingToPlayAtSpecifiedRate{
                self.startAnimating1(#line, allowInteraction: false)
            }
            else{
                if (self.player.playbackState != .playing) && (self.player.playbackState != .stopped){
                    self.startAnimating1(#line, allowInteraction: false)
                }
            }
        }
    }
    
    func playerReady(_ player: Player) {
        skipButton?.isHidden = true
        isSkipIntroShow = false
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.playitem = self.player.avplayer.currentItem
        self.player?.avplayer.isClosedCaptionDisplayEnabled = true
//        if self.maxBitrateAllowed != 0 {
//            let bitRateValue = Double(self.maxBitrateAllowed)
//            playitem?.preferredPeakBitRate = floor(bitRateValue) * 1024
////            playitem?.preferredMaximumResolution = self.view.window!.bounds.size
//        }
        self.setSubtitles()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.stopAnimating1(#line)
        }
        if (self.playBtn != nil && self.playBtn?.tag == 2) || self.player == nil || self.playBtn == nil || self.sliderPlayer == nil {
            return
        }
        if (self.analytics_info_contentType == "live") && (self.isMinimized == false) /*&& self.startOverBtn != nil*/ {
            if self.startOverFlag == true {
                self.startOverFlag = true

                if appContants.appName == .tsat || appContants.appName == .aastha  {
                    if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                        self.startOverOrGoLiveButton?.isHidden = !(self.goLiveBtn?.isHidden ?? true)
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                    }
                    else {
                        self.startOverOrGoLiveButton?.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                    }
                }
                else {
                    //MARK: as per client requirement startover button is not required
                    self.startOverOrGoLiveButton?.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                }
            } else {
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = isMinimized
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                            self.startOverOrGoLiveButton?.isHidden = !(self.goLiveBtn?.isHidden ?? true)
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                        }
                        else {
                            self.startOverOrGoLiveButton?.isHidden = true
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                        }
                    }
                    else{
                        //MARK: as per client requirement startover button is not required
                        self.startOverOrGoLiveButton?.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                    }
                }
                self.goLiveFlag = true
            }
        }

//        if self.showReplayButton == true || self.playBtn?.tag == 2 {
//            return
//        }
        if self.player.currentTime.isFinite {
            if self.player.avplayer.currentItem != nil{
                if (appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gac  || appContants.appName == .reeldrama) {
                    if bitRates.count == 1 {
                        let  tempVal = bitRates[0] as! String
                        let bitRateValue = Double(tempVal) ?? 0.0
                        self.player.avplayer.currentItem?.preferredPeakBitRate = floor(bitRateValue*1024)
                    }
                    else {
                        let bitRateValue = Double(AppDelegate.getDelegate().selectedVideoQualityMaxBitrate)
                        self.player.avplayer.currentItem!.preferredPeakBitRate = floor(bitRateValue*1024)
                    }
                }
                else if appContants.appName == .mobitel {
                    if ((AppDelegate.getDelegate().configs?.maxBitRate) ?? -1 != -1) {
                        let bitRateValue = Double(AppDelegate.getDelegate().configs!.maxBitRate)
                        self.player.avplayer.currentItem!.preferredPeakBitRate = floor(bitRateValue*1024)
                    }
                }
            }
            
            /*if self.pageDataResponse.pageEventInfo.count > 0 {
                for pageEventInfo in self.pageDataResponse.pageEventInfo {
                    if pageEventInfo.eventCode == .stream_end && pageEventInfo.targetType == .page {
                        self.isGoLiveBtnAvailable = true
                        if self.goLiveBtn != nil {
                            self.goLiveBtn.isHidden = false
                            if pageEventInfo.targetParams.buttonText .isEmpty {
                                self.goLiveBtn.setTitle("Go Live".localized, for: UIControl.State.normal)
//                                self.nextVdoviewGoLiveBtn.setTitle("Go Live".localized, for: UIControl.State.normal)
                            }
                            else {
                                self.goLiveBtn.setTitle(pageEventInfo.targetParams.buttonText, for: UIControl.State.normal)
//                                self.nextVdoviewGoLiveBtn.setTitle(pageEventInfo.targetParams.buttonText, for: UIControl.State.normal)
                                self.goLiveBtn.titleLabel?.minimumScaleFactor = 0.1
                                self.goLiveBtn.titleLabel?.numberOfLines = 0
                                self.goLiveBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                            }
                        }
                        self.isAutoRedirect = pageEventInfo.targetParams.autoRedirect
                        self.goLiveTargetPath = pageEventInfo.targetPath
                        break;
                    }
                }
            }
            else {
                if self.goLiveBtn != nil {
                    self.goLiveBtn.isHidden = true
                }
            }*/
            if self.timeRangePlayer != nil {
                let startSeconds = CMTimeGetSeconds(self.timeRangePlayer.start)
                let durationSeconds = CMTimeGetSeconds(self.timeRangePlayer.duration)
                if self.sliderPlayer != nil {
                    self.sliderPlayer.value = Float(startSeconds)//Float(player.currentTime)
                }
                if ((self.analytics_info_contentType == "live") && ((player.currentTime - startSeconds) >= (durationSeconds - 10))) {
                    
                    self.isGoLiveBtnAvailable = (self.analytics_info_contentType.lowercased() == "live" && durationSeconds > 300)
                    if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == false {
                        self.goLiveBtn?.isHidden = true
                        if appContants.appName == .tsat || appContants.appName == .aastha  {
                            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                self.startOverOrGoLiveButton?.isHidden = !(self.goLiveBtn?.isHidden ?? true)
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                            }
                            else {
                                self.startOverOrGoLiveButton?.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                            }
                        }
                        else {
                         //MARK: as per client requirement startover button is not required
                         self.startOverOrGoLiveButton?.isHidden = true
                         self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                        }
                    }
                    if self.startTime != nil {
                    self.startTime.text = "LIVE".localized
                    }
                } else {
                    if (self.analytics_info_contentType == "live") {
                        if self.startOverFlag == true {
                            if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == false {
                                self.goLiveBtn?.isHidden = true
                                self.startOverOrGoLiveButton?.isHidden = !self.goLiveBtn!.isHidden
                            }
                        } else {
                            if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == false {
                                self.goLiveBtn?.isHidden = true
                                if appContants.appName == .tsat || appContants.appName == .aastha  {
                                    if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                        self.startOverOrGoLiveButton?.isHidden = !self.goLiveBtn!.isHidden
                                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                                    }
                                    else {
                                        self.startOverOrGoLiveButton?.isHidden = true
                                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                                    }
                                }
                                else {
                                //MARK: as per client requirement startover button is not required
                                self.startOverOrGoLiveButton?.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton?.isHidden ?? true ? 0 : 95
                                }
                            }
                        }
                    }
                    if self.startTime != nil && !startSeconds.isNaN{
                        self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(player.currentTime - startSeconds)))"
                    }
                }
                }
            else {
                if self.startTime != nil {
                   self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(player.currentTime)))"
                }
                }
            if self.continueAfterPlayButtonClicked() || self.player.avplayer.isExternalPlaybackActive {
                if castTargetTime != CMTime.invalid {
                    self.player.seekToTime(castTargetTime)
                    castTargetTime = CMTime.invalid
                    self.player.playFromCurrentTime()
                }  else {
                    if ((templateElement?.elementCode == "startover" || templateElement?.elementCode == "startover_past") && self.analytics_info_contentType != "live") {
                          self.watchedSeekPosition = 0
                    }
                    else if self.pageDataResponse != nil {
                        let streamStatus = self.pageDataResponse.streamStatus
                        self.watchedSeekPosition = streamStatus.seekPositionInMillis
                    }
                    self.checkWhetherInContinueWatchingList()
                    if self.watchedSeekPosition > 0 {

                        if self.popUpOnceArrived {
//                            self.isAlertBtnClicked = true
                        }
                        self.watchedTime = self.convertTime(miliseconds: self.watchedSeekPosition)
//                        let message = String.init(format: "%@%@", "Would you like to continue from".localized,self.watchedTime)
                        if watchedTime .isEmpty {
                            self.player.playFromCurrentTime()
                        }
                        else {
                            //                            self.player.pause()
                            /*if !self.isMidRollAdPlaying && !self.popUpOnceArrived{
                             self.isAlertBtnClicked = false
                             self.showContinueWatchingAlertWithText(message: message)
                             } else {*/
                            if !self.isMidRollAdPlaying {
                                self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                                self.player?.playFromCurrentTime()
                            }
                            //                            }
                        }
                        
                    }
                    else {
                        self.isAlertBtnClicked = true
                        if !self.isMidRollAdPlaying && isNavigatingToBrowser == false {
                            self.player?.playFromCurrentTime()
                        }
                    }
                }
            }
            
            if self.templateElement != nil {
                if (templateElement?.elementCode == "startover_live") && self.shouldSeekToStartOver{
                    self.shouldSeekToStartOver = false
                    self.startOverTap(nil)
                }
            }
            //                }
            //            }
            //        }
        }
        if self.defaultPlayingItemView != nil {
            self.defaultPlayingItemView.isHidden = true
        }
        self.hideControls = true
        self.showHideControllers()
        if self.playBtn != nil {
            self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
        }
        if bitRates.count > 0 {
            /*
            let myArray = (bitRates as NSArray).sortedArray(using: [NSSortDescriptor(key: "doubleValue", ascending: true)])
            if self.player != nil {
                let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                let bitRateValue = Double(myArray.first as! String)!
                playitem.preferredPeakBitRate = floor(bitRateValue*1024)
            }
            bitRates = NSMutableArray.init(array: myArray)
 */
        }
        self.view.bringSubviewToFront(skipButton)
    }
    
    func playerPlaybackStateDidChange(_ playeraa: Player) {
       self.printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.printLog(log: "playeraa.avplayer.currentItem?.status: \(String(describing: playeraa.avplayer.currentItem?.status.rawValue))" as AnyObject?)
        self.printLog(log: "playeraa.playbackState.rawValue: \(playeraa.playbackState.rawValue)" as AnyObject?)
//        printLog(log: "self.showReplayButton 1: \(self.showReplayButton) self.playBtn?.tag: \(self.playBtn?.tag)" as AnyObject?)
        if !Utilities.hasConnectivity() && self.isDownloadContent == false {
//            if self.connectivityTimer != nil{
//                self.connectivityTimer?.invalidate()
//                self.connectivityTimer = nil
//            }
            if appContants.isEnabledAnalytics {
                if !isDownloadContent {
                    logAnalytics.shared().sendError(AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    logAnalytics.shared().closeSession(true)
                }
            }
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                self.closePlayer()
            }
        }
//        if self.showReplayButton == true || self.playBtn?.tag == 2 {
//            self.removeObserver()
//            return
//        }
        if playeraa.playbackState.rawValue == PlaybackState.failed.rawValue{
            self.stopAnimating1(#line)
            self.removeCurrentPathInLastWatchedChannels()
            if !Utilities.hasConnectivity() && self.isDownloadContent == false {
//                if self.connectivityTimer != nil{
//                    self.connectivityTimer?.invalidate()
//                    self.connectivityTimer = nil
//                }
                if appContants.isEnabledAnalytics {
                    if !isDownloadContent {
                        logAnalytics.shared().sendError(AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                        logAnalytics.shared().closeSession(true)
                    }
                }
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                    self.closePlayer()
                }
            }
            else {
                if appContants.isEnabledAnalytics {
                    logAnalytics.shared().sendError("Failed to load Video".localized)
                    logAnalytics.shared().closeSession(true)
                }
                if self.adsManager != nil {
                    self.adsManager?.destroy()
                }
                self.showAlertWithText(message: "Failed to load Video".localized){ (buttonTitle) in
                    self.closePlayer()
                }
            }
        }
        if playeraa.playbackState.rawValue == PlaybackState.playing.rawValue {
            isSeeking = false
//            isPlayingActual = false
        }
        self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(playeraa.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if self.endTime != nil && (self.endTime.text? .isEmpty)! {
            if self.analytics_info_contentType == "live" {
                self.hideControls = true
            }
            else {
                self.hideControls = false
            }
            self.showHideControllers()
        }
        if self.player == nil || self.playBtn == nil || self.playerObserver == nil {
            return;
        }
        if self.timeRangePlayer != nil {
            let durationSeconds = CMTimeGetSeconds(self.timeRangePlayer.duration)
            
            if self.analytics_info_contentType == "live" && durationSeconds > 300{
                if player.bufferingState == .ready{
                    isGoLiveBtnAvailable = true
                    isSeeking = false
                }
                self.hideControls = true
            } else {
                isSeeking = false
            }
        }
//        self.player.pause()
        if isNavigatingToBrowser == false && self.isPlayBackEnd == false {
            if self.watchedSeekPosition > 0 {
                if isAlertBtnClicked {
                    self.player.playFromCurrentTime()
                }
            }
            else{
                if !GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession() && !isMidRollAdPlaying {
                    if self.pictureInPictureController != nil && (self.pictureInPictureController.isPictureInPictureActive == true) {
                        // nothing to do
                    }
                    else {
                        if self.player.playbackState == .paused {
                            self.player.pause()
                            self.stopAnimating1(#line)
                        }
                        else {
                            self.player.playFromCurrentTime()
                        }
                    }
                }
            }
            if self.playBtn != nil {
                if self.pictureInPictureController != nil && (self.pictureInPictureController.isPictureInPictureActive == true) {
                    // nothing to do
                }
                else {
                    if self.player?.playbackState == .paused {
                        self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                        self.playBtn?.isHidden = false
                    }
                    else{
                        self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                        self.playBtn?.isHidden = true
                    }
                }
            }
        }
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.playitem?.remove(self.output)
        if !isDownloadContent, offLineDownloadAsset == nil {
            getPlayerStreamContent(streamPin: "")
        }
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if (checkForPostRollAds() == true) {
            self.isPlayBackEnd = true
            return
        }
        else{
            if self.startTime != nil {
                self.startTime.text = "00:00"
            }
            if self.playBtn != nil {
                self.playBtn?.isHidden = true
            }
            self.isPlayBackEnd = true
            if !self.isMinimized {
                hideControls = false
                showHideControllers()
            }
            testVal = 13
            if self.playBtn != nil {
                self.playBtn?.isHidden = false
                self.playBtn?.setImage(UIImage(named:"reply_icon"), for: .normal)
                self.playBtn?.tag = 2
            }
            if self.sliderPlayer != nil {
                self.sliderPlayer.isUserInteractionEnabled = false
            }
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().closeSession(true)
            }
            //        if self.analytics_info_contentType != "live" && self.analytics_info_contentType != ""{
            //            self.updateTheRecentlyWatchedList()
            //            for tabControllKey in TabsViewController.instance.tabsControllersRefreshStatus.keys {
            //                if tabControllKey != TabsViewController.instance.titlearray[TabsViewController.instance.selectedMenuRow].targetPath {
            //                    if tabControllKey != "guide" {
            //                        TabsViewController.instance.tabsControllersRefreshStatus[tabControllKey] = false
            //                    }
            //                }
            //            }
            //        }
            if self.isAutoRedirect {
                self.buttonActionGoLive(sender: UIButton())
            }
            else if self.nextVideoContent != nil {
                
                if self.isGoLiveBtnAvailable {
                    //                self.nextVdoviewGoLiveBtn.isHidden = false
                    //                self.nextVdoPlayBtnLeadingConstraint.constant = 11.0
                }
                else {
                    //                self.nextVdoviewGoLiveBtn.isHidden = true
                    //                self.nextVdoPlayBtnLeadingConstraint.constant = 59.0
                }
                if self.nextVideoCloseBtn != nil {
                    self.nextVideoCloseBtn.isHidden = false
                }
                if appContants.appName == .aastha && pageDataResponse.info.attributes.SignAndSignupErrorMessage != "" {
                    if  OTTSdk.preferenceManager.user == nil {
                        self.sign_signup_MsgLbl?.isHidden = false
                        if !productType.iPad && self.orientation() == .portrait {
                            self.sign_signup_MsgLbl.lineBreakMode = .byTruncatingTail
                            self.sign_signup_MsgLbl.numberOfLines = 2
                        }
                        self.sign_signup_MsgLbl?.text = pageDataResponse.info.attributes.SignAndSignupErrorMessage
                        
                        if self.adsManager != nil {
                            self.adsManager?.destroy()
                        }
                        
                        self.showAlertWithText(message:pageDataResponse.info.attributes.SignAndSignupErrorMessage, buttonTitles: ["Sign in", "Cancel"] ){ (buttonTitles) in
                            if buttonTitles == "Sign in" {
                                self.isFromErrorFlow = true
                                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                                storyBoardVC.viewControllerName = "PlayerVC"
                                if  playerVC != nil{
                                    playerVC?.showHidePlayerView(true)
                                }
                                let topVC = UIApplication.topVC()!
                                topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
                            }
                            else {
                                self.closePlayer()
                            }
                        }
                    } else {
                        if self.isPreviewContent == false {
                            self.playNextVideo()
                        }
                    }
                } else {
                    if self.isPreviewContent == false {
                        self.playNextVideo()
                    }
                }
                /* disabling next video old ui
                 self.startTimerForNextItemPlay()
                 */
            }
            else {
                if self.isGoLiveBtnAvailable && !self.isMinimized {
                    //                self.nextVdoviewGoLiveBtn.isHidden = false
                    if self.nextVideoCloseBtn != nil {
                        self.nextVideoCloseBtn.isHidden = true
                    }
                }
                else {
                    //                self.nextVdoviewGoLiveBtn.isHidden = true
                }
            }
            self.hideSomePlayerControllers(status: true)
            //        self.removeObserver()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetRecentlyWatchedList"), object: nil)
            
            
            if self.nextVideoContent == nil{
                self.stopAnimating1(#line)
                if self.seekFwd != nil && self.seekBckwd != nil {
                    self.seekFwd.isHidden = true
                    self.seekBckwd.isHidden = true
                }
                //            self.closePlayer()
            }
            //        if self.myTimer != nil{
            //            self.myTimer?.invalidate()
            //            self.myTimer = nil
            //        }
            //        if self.player.timeObserver != nil {
            //            self.player.avplayer.removeTimeObserver(self.player.timeObserver)
            //            self.player.timeObserver = nil
            //        }
            //        self.player.delegate = nil
            //        self.player.playerView.player = nil
            //        self.player.avplayer.pause()
            //        self.player.setupPlayerItem(nil)
            
            /* if (_playBackMode == .local)
             {
             if pageString == "TVSHOWS" {
             
             
             let yuppFlixUserDefaults = UserDefaults.standard
             var continueWatchingList:NSMutableArray!
             
             if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") != nil {
             if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") is NSArray {
             continueWatchingList = NSMutableArray.init(array: yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") as! NSArray)
             }
             else{
             continueWatchingList = yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") as! NSMutableArray
             }
             
             continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
             for episodeDict in continueWatchingList {
             let tempEpisodeDict = episodeDict as! NSDictionary
             if (episodeModelDict["name"] as! String == tempEpisodeDict["name"] as! String) && (episodeModelDict["tvShowName"] as! String == tempEpisodeDict["tvShowName"] as! String) {
             continueWatchingList.remove(tempEpisodeDict)
             yuppFlixUserDefaults.set(continueWatchingList, forKey: "Continue_Watching_List")
             yuppFlixUserDefaults.synchronize()
             break
             }
             }
             
             }
             if !self.isFromContinueWatching {
             let episodesArray = self.nextEpisodesSectionDict["data"] as! NSArray
             let episodeDictionary = self.containsNextEpisode(episodeDictArr: episodesArray)
             if episodeDictionary.count > 0 {
             episodeModelDict = episodeDictionary
             self.addToContinueWatchingList(isAddingNextEpisode: true)
             }
             self.showNextEpisodesPlayList()
             }
             else{
             self.replayBtn.isHidden = true
             self.playBtn?.isHidden = false
             self.playBtn?.setImage(UIImage(named:"reply_icon"), for: .normal)
             self.playBtn?.tag = 2
             }
             }
             else {
             self.recommendedMoviesList()
             }
             }*/
        }
    }
    

    func playerCurrentTimeDidChange(_ player: Player) {
        if _playBackMode == .remote {
            /**/
            if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected && castMediaController.lastKnownStreamPosition.isFinite && self.startTime != nil {
                self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(castMediaController.lastKnownStreamPosition)))"
                if isSeeking == false {
                    if self.sliderPlayer != nil {
                        self.sliderPlayer.value = Float(Int(castMediaController.lastKnownStreamPosition))
                    }
                }
            }
            
        } else {
            if self.player != nil {
                if self.player.avplayer.isExternalPlaybackActive {
                    testVal = 14
                    showHideControllers()
                    
                }
                
                if isSeeking == false {
                    //                if isPlayingActual == false {
                    //                    isPlayingActual = true
                    //                }
                    //                else {
                    if  !(self.player.currentTime.isNaN) && self.player.currentTime.isFinite {
                        if self.timeRangePlayer != nil {
                            let startSeconds = CMTimeGetSeconds(self.timeRangePlayer.start)
                            let durationSeconds = CMTimeGetSeconds(self.timeRangePlayer.duration)
                            if self.nextVideoContent == nil {
                                self.comingUpNextView.card = nil
                                self.comingUpNextView.shouldShow = false
                            }

                            self.comingUpNextView.updateHiddenStateFor(duration: CMTimeGetSeconds(self.timeRangePlayer.duration), currentTime: self.player.currentTime)
                            //                        print("player log: currentTime:", Int(player.currentTime))
                            //                        print("player log: self.sliderPlayer.value:", self.sliderPlayer.value)
                            //                        print("player log: self.sliderPlayer.minimumValue:", self.sliderPlayer.minimumValue)
                            //                        print("player log: self.sliderPlayer.maximumValue:", self.sliderPlayer.maximumValue)
                            if self.sliderPlayer != nil && isSeeking == false {
                                if self.player != nil /*&& self.player.avplayer.isExternalPlaybackActive*/ {
                                   if ((templateElement?.elementCode == "startover" || templateElement?.elementCode == "startover_past") && self.analytics_info_contentType != "live") {
                                         self.watchedSeekPosition = 0
                                   }
                                   else if self.pageDataResponse != nil {
                                    let streamStatus = self.pageDataResponse.streamStatus
                                    self.watchedSeekPosition = streamStatus.seekPositionInMillis
                                   }
                                    self.checkWhetherInContinueWatchingList()
                                    if self.watchedSeekPosition > 0 && !self.isContinueWatchAlertShown{
                                        self.isAlertBtnClicked = false
                                        let watchedTime = self.convertTime(miliseconds: self.watchedSeekPosition)
//                                        let message = String.init(format: "%@%@", "Would you like to continue from".localized,watchedTime)
                                        /* if /*watchedTime .isEmpty &&*/ !isMidRollAdPlaying {
                                            self.player.playFromCurrentTime()
                                        }
                                        else {
                                            self.player.pause()
                                            //self.showContinueWatchingAlertWithText(message: message)
                                        } */
                                        
                                    }
                                }
                                if ((lastScrubbingValue - self.sliderPlayer.value) > -5) && ((lastScrubbingValue - self.sliderPlayer.value) < 5){
                                    // To avoid scrolling thumb on the slider back and forth after seeking
                                    self.sliderPlayer.value = Float(self.player.currentTime)
                                    
                                }
                                lastScrubbingValue = self.sliderPlayer.value
                                
                                if self.mQualityButton != nil {
                                    self.mQualityButton!.alpha = 1.0
                                }
                                if self.shareBtn != nil{
                                    self.shareBtn!.alpha = 1.0
                                    self.shareBtn!.isHidden = ((appContants.appName == .gac  || self.isPreviewContent == false) ? false : true)

                                }
                            }
                            if self.goLiveBtn != nil {
                                self.goLiveBtn?.alpha = 1.0
                            }
                            self.checkForMidRollAds()

                            if (viewInTransition == false && self.analytics_info_contentType == "live" && ((self.player.currentTime - startSeconds) >= (durationSeconds - 15)) && durationSeconds > 300) {
                                
                                if self.startOverFlag == true {
                                    //                                        self.startOverBtn.isHidden = isMinimized
                                }
                                
                                if (self.isMinimized == false) && (self.hideControls == false) {
                                    if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == false {
                                        self.goLiveBtn?.isHidden = true
                                        if appContants.appName == .tsat || appContants.appName == .aastha {
                                            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                                self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                            }
                                            else {
                                                self.startOverOrGoLiveButton.isHidden = true
                                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                            }
                                        }
                                    }
                                }
                                //                                else{
                                //                                    self.goLiveBtn?.isHidden = true
                                //                                    self.startOverOrGoLiveButton.isHidden = true
                                //                                    self.startOverOrGoLiveButtonWidthConstraint.constant = 0
                                //                                }
                                if self.startTime != nil {
                                    self.startTime.text = "LIVE".localized
                                    self.isGoLiveBtnAvailable = false
                                }
                            } else {
                                if viewInTransition == false && (self.analytics_info_contentType == "live") && durationSeconds > 300 {
                                    if self.isGoLiveBtnAvailable == false{
                                        self.isGoLiveBtnAvailable = true
                                        if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == true {
                                            if self.isMinimized == false {
                                                self.goLiveBtn?.isHidden = false
                                                if appContants.appName == .tsat || appContants.appName == .aastha {
                                                    if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                                        self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                    }
                                                    else {
                                                        self.startOverOrGoLiveButton.isHidden = true
                                                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                    }
                                                }
                                                else {
                                                //MARK: as per client requirement startover button is not required
                                                self.startOverOrGoLiveButton.isHidden = true
                                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                }
                                            }
                                            else{
                                                self.goLiveBtn?.isHidden = true
                                                self.startOverOrGoLiveButton.isHidden = true
                                                self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
                                            }
                                        }
                                        self.showHideControllers()
                                    }
                                    
                                    if isMinimized {
                                        if self.goLiveBtn != nil && !self.isGoLiveBtnAvailable {
                                            self.goLiveBtn?.isHidden = true
                                            if appContants.appName == .tsat || appContants.appName == .aastha {
                                                if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                                    self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                }
                                                else {
                                                    self.startOverOrGoLiveButton.isHidden = true
                                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                }
                                            }
                                            else {
                                            //MARK: as per client requirement startover button is not required
                                            self.startOverOrGoLiveButton.isHidden = true
                                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                            }
                                            //                                            self.startOverBtn.isHidden = true
                                        }
                                    }
                                    else if self.startOverFlag == true {
                                        if self.goLiveBtn != nil && !self.isGoLiveBtnAvailable {
                                            self.goLiveBtn?.isHidden = true
                                            if appContants.appName == .tsat || appContants.appName == .aastha {
                                                if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                                    self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                }
                                                else {
                                                    self.startOverOrGoLiveButton.isHidden = true
                                                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                                }
                                            }
                                            else {
                                            //MARK: as per client requirement startover button is not required
                                            self.startOverOrGoLiveButton.isHidden = true
                                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                                            }
                                            //                                            self.startOverBtn.isHidden = false
                                        }
                                    }
                                    else {
                                        if self.goLiveBtn != nil && !self.isGoLiveBtnAvailable {
                                            //                                            self.goLiveBtn.isHidden = true
                                            //                                            self.startOverBtn.isHidden = true
                                        }
                                    }
                                }
                                if self.startTime != nil && !startSeconds.isNaN{
                                    if self.previewSecondsRemaining == 0 {
                                        self.previewLblView?.isHidden = true
                                    }
                                    else if self.player.playbackState == .playing {
                                        self.previewDurationLbl?.text = "Preview ends in \(secondsToHoursMinutesSeconds(seconds: previewSecondsRemaining))"
                                        self.previewSecondsRemaining = self.previewSecondsRemaining == 0 ? 0 : self.previewSecondsRemaining - 1
                                        print("timer val", previewSecondsRemaining)
                                        if isMinimized == false {
                                            self.previewLblView.isHidden = isPreviewContent ? false : true
                                        }
                                    }
                                    self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(self.player.currentTime - startSeconds)))"
                                    if Int(self.player.currentTime - startSeconds) >= self.skipIntroStartTime, Int(self.player.currentTime - startSeconds) < self.skipIntroEndTime, !isSkipIntroShow {
                                        if Int(self.player.currentTime - startSeconds) == self.skipIntroStartTime {
                                            self.hideControls = false
                                            self.showHideControllers()
                                        }
                                        UIView.transition(with: skipButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                                            self.skipButton.isHidden = false
                                        })
                                    }else if (self.analytics_info_contentType != "live") && (Int(self.player.currentTime - startSeconds) >= self.skipIntroEndTime) {
                                        UIView.transition(with: skipButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                                            if Int(self.player.currentTime - startSeconds) == self.skipIntroEndTime {
                                                self.hideControls = false
                                                self.showHideControllers()
                                            }
                                            self.isSkipIntroShow = true
                                            self.skipButton.isHidden = true
                                        })
                                    }else {
                                        self.skipButton.isHidden = true
                                    }
                                }
                                
                            }
                        } else {
                            if self.startTime != nil {
                                self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(self.player.currentTime)))"
                            }
                        }
                    }
                    //                }
                }
                if  self.player.maximumDuration.isFinite {
                    if self.endTime != nil {
                        self.endTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(self.player.maximumDuration)))"
                    }
                }
            }
        }
        /*if self.sliderPlayer != nil && self.sliderPlayer.isTracking == false{
            if self.analytics_info_contentType == "live" {
                if self.sliderPlayer.maxForwardValue == 0.0 {
                    self.sliderPlayer.oldValue = self.sliderPlayer.value
                }
                else{
                    if self.sliderPlayer.value < self.sliderPlayer.maxForwardValue {
                        self.sliderPlayer.oldValue = self.sliderPlayer.value
                        self.sliderPlayer.maxForwardValue = self.sliderPlayer.value
                    }
                    else{
                        self.sliderPlayer.oldValue = self.sliderPlayer.maxForwardValue
                    }
                }
            }
            else{
                self.sliderPlayer.oldValue = self.sliderPlayer.value
                if  self.sliderPlayer.maxForwardValue < self.sliderPlayer.value {
                    self.sliderPlayer.maxForwardValue = self.sliderPlayer.value
                }
            }
        }*/
        if self.sliderPlayer != nil && self.sliderPlayer.isTracking == false{
            self.sliderPlayer.oldValue = self.sliderPlayer.value
//            if (self.analytics_info_contentType != "live") && self.sliderPlayer.maxForwardValue < self.sliderPlayer.value {
//                self.sliderPlayer.maxForwardValue = self.sliderPlayer.value
//            }
//            else if self.analytics_info_contentType == "live" {
//                if self.sliderPlayer.maxForwardValue == 0.0 {
//                    self.sliderPlayer.oldValue = self.sliderPlayer.value
//                }
//            }
//
        }
    }
    
    func playerWillComeThroughLoop(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        
    }
    

    
    func setSubtitles(){
        if self.isDownloadContent == false {
            DispatchQueue.main.async {
                self.player.avplayer.appliesMediaSelectionCriteriaAutomatically = false
                self.subTitleType = SubTitleType.none
                if self.closeCaptions.ccList.count > 0 {
                    self.subTitleType = SubTitleType.external
                    let isExternalSubTilte = self.addPlayerSubTitles()
                    if isExternalSubTilte{
                        self.subTitleType = SubTitleType.external
                        self.setExternalSubtitle(isOn: self.ccButton?.isSelected ?? false)
                    }
                }
                else{
                    let isEmbeddedSubTilte = self.setEmbeddedSubtitle(isOn: self.ccButton?.isSelected ?? false)
                    if isEmbeddedSubTilte{
                        self.subTitleType = SubTitleType.embedded
                    }
                    else{
                        let isExternalSubTilte = self.addPlayerSubTitles()
                        if isExternalSubTilte{
                            self.subTitleType = SubTitleType.external
                            self.setExternalSubtitle(isOn: self.ccButton?.isSelected ?? false)
                        }
                        else{
                           
                        }
                    }
                }
            }
        }
    }
    
    func setExternalSubtitle(isOn : Bool = true) {//ccButton?.isSelected
        if self.player?.avplayer.currentItem != nil{
            self.playitem = (self.player?.avplayer.currentItem!)!
            output.setDelegate(self, queue:DispatchQueue.main)
            if isOn {
                //on
                self.player.avplayer.isClosedCaptionDisplayEnabled = true
                output.suppressesPlayerRendering = false
                self.subtitleLabel?.isHidden =  self.isMinimized //false
            } else {
                //off
                output = AVPlayerItemLegibleOutput.init()
                self.player.avplayer.isClosedCaptionDisplayEnabled = false
                output.suppressesPlayerRendering = true
                self.subtitleLabel?.isHidden = true
            }
            if  !((self.playitem?.outputs.contains(output)) != nil){
                self.playitem?.add(output)
            }
        }
    }
 
    func setEmbeddedSubtitle(isOn : Bool = true) -> Bool{
        if self.player?.avplayer.currentItem != nil{
            self.playitem = (self.player?.avplayer.currentItem!)!
            output.setDelegate(self, queue:DispatchQueue.main)
            // Create a group of the legible AVMediaCharacteristics (Subtitles)
            
            if let group = self.player.asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
                // Create an option group to hold the options in the group that match the locale
                let options =
                    AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, withMediaCharacteristics: [AVMediaCharacteristic.legible])
                
                // Assign the first option from options to the variable option
                if let option = options.first {
                    // Select the option for the selected locale
                    if  !((self.playitem?.outputs.contains(output)) != nil) {
                        self.playitem?.remove(output)
                    }
                    if isOn {
                        //output = AVPlayerItemLegibleOutput.init()
                        self.player.avplayer.isClosedCaptionDisplayEnabled = true
                        self.player.avplayer.appliesMediaSelectionCriteriaAutomatically = true
                        output.suppressesPlayerRendering = false
                        self.player.playerItem?.select(option, in: group)
                    }
                    else{
                        //output = AVPlayerItemLegibleOutput.init()
                        self.player.avplayer.isClosedCaptionDisplayEnabled = false
                        self.player.avplayer.appliesMediaSelectionCriteriaAutomatically = false
                        output.suppressesPlayerRendering = true
                        
                        self.player.playerItem?.select(nil, in: group)
                    }
                    if  !((self.playitem?.outputs.contains(output)) != nil) {
                        self.playitem?.add(output)
                    }
                    return true
                }
            }
        }
        return false
        
        /* To check all characteristics
        for characteristic in self.player.asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            print("\(characteristic)")
            // Retrieve the AVMediaSelectionGroup for the specified characteristic.
            if let group = self.player.asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                // Print its options.
                for option in group.options {
                    print("  Option: \(option.displayName)")
                }
            }
        } */
        /* Set the locale identifier to the value of languageID to select the current language
        let locale = Locale(identifier: "en-EN")
        let options =
            AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
        self.player.playerItem?.select(options.first, in: group)
         */
    }
    
    func checkToEnableCCBtn() {
        let shouldSubtitleOn = (UserDefaults.standard.value(forKey: "ccStatus") as? Bool) ?? true
       ccButton?.isSelected = shouldSubtitleOn
        
        let switchUserDefaults = UserDefaults.standard
        if switchUserDefaults.value(forKey: "ccStatus") == nil {
            switchUserDefaults.set(true, forKey: "ccStatus")
            switchUserDefaults.synchronize()
        }
    }
    
    func checkWhetherInContinueWatchingList() {
        return;
        let yuppFLixUserDefaults = UserDefaults.standard
        if yuppFLixUserDefaults.object(forKey: "Continue_Watching_List") != nil {
            var continueWatchingList = NSMutableArray()
            var currentShowTimeList = NSMutableArray()
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
            let continueCurrentTimeList = continueDict["Current_Show_Time"]
            if continueCurrentTimeList != nil {
                if continueCurrentTimeList is NSArray {
                    currentShowTimeList = NSMutableArray.init(array: continueCurrentTimeList as! NSArray)
                }
                else {
                    currentShowTimeList = continueCurrentTimeList as! NSMutableArray
                }
            }
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            
            var episodeIndex = 0
            for episodeDict in continueWatchingList {
                let tempEpisodeDict = episodeDict as! NSDictionary
                let presentplayingItemTargetPath = self.playingItemTargetPath
                let tempTvShowID = episodeDict as! [String:String]
                if (presentplayingItemTargetPath == tempTvShowID["playingItemTargetPath"]) {
                    let episodePlayDict = currentShowTimeList.object(at: episodeIndex) as! [String:TimeInterval]
                    if episodePlayDict["Current_Time"] != nil && !(episodePlayDict["Current_Time"]?.isNaN)!{
                        self.watchedSeekPosition = Int(Int64(episodePlayDict["Current_Time"]!)) * 1000
                    }
                    break
                }
                episodeIndex = episodeIndex + 1
            }
        }
    }
    
    @objc func castButtonSelected() {
        print("castButtonSelected--------------")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(700)) {
            self.minBtnTouched = true
            self.minimizeViews()
        }

    }
    
    func addPlayerSubTitles() -> Bool {
        //        return;
        // Subtitle file
        if self.captionsList.count > 0 {
            for ccData in self.self.closeCaptions.ccList {
                if ccData.language == self.defaultSubtitleLang {
                    let subtitleFile = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                    if let captionFilePath = subtitleFile.appendingPathComponent("sample.\(ccData.fileType)"){
                        // Add subtitles
                        //            self.addSubtitles().open(file: captionFilePath as! URL)
                        self.addSubtitles().open(file: captionFilePath , encoding: .utf8, fileType: ccData.fileType)
                        return true
                    }
                }
            }
        }
        return false
    }

    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest.init(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    let captionFileData = try Data.init(contentsOf: tempLocalUrl)
                    try captionFileData.write(to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    /*startTimerForNextItemPlay
    
    func startTimerForNextItemPlay() {
        self.nextVDOTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.otpCountDownTick), userInfo: nil, repeats: true)
        RunLoop.main.add(self.nextVDOTimer!, forMode: RunLoop.Mode.common)
    }
    @objc func otpCountDownTick() {
        countdown -= 1
        if (countdown <= 0) {
            self.nextVDOTimer!.invalidate()
            self.nextVDOTimer = nil
            self.playNextVideo()
            return
        }
        
        let colorText = self.getText(count: countdown, secondsText: "Secs")
        let countDownString = NSMutableAttributedString.init(string: nextItemText as String)
        countDownString.append(colorText)
        self.comingUpNextLbl.attributedText = countDownString
    }
  */
    func getText(count:Int,secondsText:String ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        //Count number first
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let countTextAttribute = [NSAttributedString.Key.font:
            UIFont.ottRegularFont(withSize: 10.0),
                                  NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "d90738"), NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let countText = " \(count) "
        let countTextAttributedString = NSMutableAttributedString(
            string: countText,
            attributes: countTextAttribute)
        attributedString.append(countTextAttributedString)
        
        //seconds text later
        let mainTitleAttribute = [NSAttributedString.Key.font:
            UIFont.ottRegularFont(withSize: 10.0),
                                  NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "d90738"), NSAttributedString.Key.paragraphStyle : paragraphStyle]
        let mainTitleAttributedString = NSMutableAttributedString(
            string: secondsText,
            attributes: mainTitleAttribute)
        attributedString.append(mainTitleAttributedString)
        
        
        return attributedString
    }
    
    func playNextVideo() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HidePlayerSuggestionView"), object: nil, userInfo: nil)
        AppDelegate.getDelegate().isFromPlayerPage = true
        self.pushEvents(true, "Up Next")
        if self.nextVideoContent != nil {
            let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
            if hasConnectedCastSession() || (self.player != nil &&  self.player.avplayer.isExternalPlaybackActive) {
                self.didSelectedSuggestion(card: self.nextVideoContent)
            } else {
                hideControls = true
                showHideControllers()
                self.loopNextVideo(self.nextVideoContent)
            }
        }
        if self.sliderPlayer != nil {
            self.sliderPlayer.isUserInteractionEnabled = true
        }
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        if hours > 0 {
            return String(format:"%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format:"%02d:%02d", minutes, seconds)
        }
    }
    @IBAction func skipIntroActionTapped(_ sender : Any) {
        self.player.seekToTime(CMTimeMake(value: Int64(self.skipIntroEndTime), timescale: 1))
    }
    func secondsToTimeInString (seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute] //[.hour, .minute, .second]
        formatter.unitsStyle = .full
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    @IBAction func TakeTestButtonInPlayerClicked() {
//        if let url = URL(string: self.takeTestUrl) {
//            UIApplication.shared.open(url)
//        }
        
    }
    //MARK: - live program update details
    func enableTakeaTestButtonNotifications() {
        printYLog( "Function: \(#function), line: \(#line)")
        if self.enableTakeTestTimer != nil{
            self.enableTakeTestTimer?.invalidate()
            self.enableTakeTestTimer = nil
        }
        self.isTestButtonShown = false
        if self.takeTestButtonInPlayer != nil {
            self.takeTestButtonInPlayer.isHidden = true
        }
        self.testStartTime = -1
        let attributes = self.pageDataResponse.info.attributes
        if (attributes.contentType == "epg") && (attributes.isLive == true){
            self.isTestButtonShown = false
            self.takeTestButtonInPlayer?.isHidden = true
            if self.enableTakeTestTimer != nil {
                self.enableTakeTestTimer?.invalidate()
                self.enableTakeTestTimer = nil
            }
            takeTestUrl =  self.pageDataResponse.info.attributes.takeaTestURL.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            self.testStartTime = Int64(truncating: attributes.takeaTestStartTime)
            if takeTestUrl.count > 3 {
                if let userAttributes = OTTSdk.preferenceManager.user?.attributes, (userAttributes.lms_user_name.count > 0 && userAttributes.lms_password.count > 0){
                    self.isTestButtonShown = true
                    self.handleTakeTestButtonUI(false)
                    self.enableTakeTestTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(PlayerViewController.updateTestBtntext), userInfo: nil, repeats: true)
                }
                else{
                    OTTSdk.userManager.userInfo(onSuccess: { (_) in
                        if let userAttributes = OTTSdk.preferenceManager.user?.attributes, (userAttributes.lms_user_name.count > 0 && userAttributes.lms_password.count > 0){
                            self.isTestButtonShown = true
                            self.handleTakeTestButtonUI(false)
                            self.enableTakeTestTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(PlayerViewController.updateTestBtntext), userInfo: nil, repeats: true)
                        }
                        else{
                            self.isTestButtonShown = false
                            self.handleTakeTestButtonUI(false)
                        }
                    }) { (error) in
                        self.isTestButtonShown = false
                        self.handleTakeTestButtonUI(false)
                    }
                }
            }
        }
    }
    @objc func updateTestBtntext(){
        if self.testStartTime != -1 {
            var timeDiffInSec = (self.testStartTime - Date().toMillis()) / 1000
            if timeDiffInSec <= 0{
                timeDiffInSec = 0
                if self.enableTakeTestTimer != nil{
                    self.enableTakeTestTimer?.invalidate()
                    self.enableTakeTestTimer = nil
                    if self.takeTestButtonInPlayer != nil {
                        self.takeTestButtonInPlayer.setTitle(" ", for: .normal)
                        self.takeTestButtonInPlayer.backgroundColor = AppTheme.instance.currentTheme.themeColor
                        self.takeTestButtonInPlayer.isUserInteractionEnabled = true
                    }
                }
                self.takeaTestButtonEnableNotified()
            }
            else{
                if self.takeTestButtonInPlayer != nil {
                    let timeStr = secondsToHoursMinutesSeconds(seconds: Int(timeDiffInSec))
                    self.takeTestButtonInPlayer.setTitle("  ", for: .normal)
                    self.takeTestButtonInPlayer.backgroundColor = .darkGray
                    self.takeTestButtonInPlayer.isUserInteractionEnabled = false
                }
            }
        }
    }
    @objc func takeaTestButtonEnableNotified(){
        printYLog( "Function: \(#function), line: \(#line)")
        takeTestUrl =  self.pageDataResponse.info.attributes.takeaTestURL.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if takeTestUrl.count > 3 {
            if let userAttributes = OTTSdk.preferenceManager.user?.attributes, (userAttributes.lms_user_name.count > 0 && userAttributes.lms_password.count > 0){
                self.isTestButtonShown = true
                self.handleTakeTestButtonUI(true)
            }
            else{
                OTTSdk.userManager.userInfo(onSuccess: { (_) in
                    if let userAttributes = OTTSdk.preferenceManager.user?.attributes, (userAttributes.lms_user_name.count > 0 && userAttributes.lms_password.count > 0){
                        self.isTestButtonShown = true
                        self.handleTakeTestButtonUI(true)
                    }
                }) { (error) in
                }
            }
        }
    }
    func handleTakeTestButtonUI(_ isEnable:Bool){
        if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) {
            if self.takeTestButtonInPlayer != nil {
                self.takeTestButtonInPlayer.isHidden = appContants.appName == .gac ? true : false
                self.takeTestButtonInPlayer.isUserInteractionEnabled = isEnable
                if isEnable{
                    self.takeTestButtonInPlayer.setTitle("", for: .normal)
                    self.takeTestButtonInPlayer.backgroundColor = AppTheme.instance.currentTheme.themeColor
                    self.takeTestButtonInPlayer.isUserInteractionEnabled = true
                }
                else{
                    self.takeTestButtonInPlayer.setTitle("Test will be enabled in", for: .normal)
                    self.takeTestButtonInPlayer.backgroundColor = .darkGray
                    self.takeTestButtonInPlayer.isUserInteractionEnabled = false
                    
                }
            }
        }
        let messageDataDict:[String: Bool] = ["showButton": self.isTestButtonShown,"isEnabled":isEnable]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "handleTakeTestButton"), object: nil, userInfo: messageDataDict)
    }
    func setLiveProgramChangeNotifications(){
        printYLog( "Function: \(#function), line: \(#line)")
        if self.programEndTimer != nil{
            self.programEndTimer?.invalidate()
            self.programEndTimer = nil
        }
        let attributes = self.pageDataResponse.info.attributes
        if (attributes.contentType == "epg") && (attributes.isLive == true){
            var timeDiffInSec = ( Int64(truncating: attributes.endTime) - Date().toMillis()) / 1000
            if timeDiffInSec <= 0{
                timeDiffInSec = 3600
            }
            self.programEndTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeDiffInSec), target: self, selector: #selector(PlayerViewController.liveProgramDidEndNotified), userInfo: nil, repeats: false)
            print("end time         : \(attributes.endTime)")
            print("timeDiffInSec    : \(timeDiffInSec)")
        }
    }
    
    @objc func liveProgramDidEndNotified(){
        printYLog( "Function: \(#function), line: \(#line)")
        let qosClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        backgroundQueue.async(execute: {
            OTTSdk.mediaCatalogManager.pageContent(path: self.playingItemTargetPath, onSuccess: { (response) in
                let endTimeOfPreviousProg =  self.pageDataResponse.info.attributes.endTime
                
                //check
                if endTimeOfPreviousProg.isEqual(to: response.info.attributes.endTime){
                    self.setLiveProgramChangeNotifications()
                    //                self.programEndTimer?.invalidate()
                    //                self.programEndTimer = nil
                    //                // let the api call after 5 second for update
                    //                self.programEndTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(PlayerViewController.liveProgramDidEndNotified), userInfo: nil, repeats: false)
                    return;
                }
                else{
                    // Got the updated program end time
                    if self.programEndTimer != nil{
                        self.programEndTimer?.invalidate()
                        self.programEndTimer = nil
                    }
                    self.setLiveProgramChangeNotifications() // reset timer
                    
                    self.pageDataResponse = response
                    self.updateRecordButtonImage()
                    self.updateFavoriteButtonUI()
                    let contentInformation = self.contentInformation()
                    self.navTitleLable?.text = contentInformation.title
                    self.navSubTitleLable?.text = contentInformation.subTitle
                    self.navExpiryLable?.isHidden = (contentInformation.expiryDaysText.count > 0 ? false : true)
                    print ("\(response.info.attributes.contentType)")
                    self.currentVideoContent = nil
                    self.navExpiryLable?.text = contentInformation.expiryDaysText
                    self.navExpiryLable?.sizeToFit()
                    self.navExpiryLabelWidthConstraint?.constant = (self.navExpiryLable?.frame.size.width ?? 0) + 20.0
                    self.navExpiryLable?.viewCornerDesignWithBorder(.red)
                    self.navExpiryLable?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    
                    self.minimizedViewTitleLbl?.text = contentInformation.title
                    self.minimizedSubtitleLbl?.text = contentInformation.subTitle
                    let imageUrl = ((contentInformation.imageUrl?.count ?? 0) > 0) ?  contentInformation.imageUrl! : contentInformation.logo
                    self.navImageView?.loadingImageFromUrl(imageUrl, category: "")
                    self.pageData = self.pageDataResponse.data
                    self.loadPlayerSuggestions(loginViewStatus: false)
                    self.enableTakeaTestButtonNotifications()

                    
                    
                    // update suggestions
                    for pageData in self.pageDataResponse.data{
                        if pageData.paneType == .section {
                            if let section = pageData.paneData as? Section{
                                self.suggestionsView.updateSuggestions(sectionData: section.sectionData)
                                break;
                            }
                        }
                    }
                }
            }) { (error) in
            }
        })
    }
    
    func showContinueWatchingAlertWithText (_ header : String = "Resume".localized, message : String) {
        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
        self.popUpOnceArrived = true
        if self.templateElement != nil {
            if self.templateElement!.elementCode == "resume" {
                if hasConnectedCastSession() {
                    let mOpt = GCKMediaLoadOptions.init()
                    mOpt.autoplay = true
                    mOpt.playPosition = Double(Int(self.watchedSeekPosition/1000))
                    self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, with: mOpt)
//                    self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(Int(self.watchedSeekPosition/1000)))
                } else {
//                    if self.player != nil {
//                        self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
//                    }
                    self.isAlertBtnClicked = true
                    if self.isMidRollAdPlaying {
                        if self.adsManager != nil {
                            self.adsManager?.start()
                        }
                    } else {
                        self.startAnimating1(#line, allowInteraction: false)
                        if self.player != nil {
                            self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                        }
                        self.isAlertBtnClicked = true
                        self.player.playFromCurrentTime()
                    }
                }
            } else if self.templateElement!.elementCode == "startover" || self.templateElement!.elementCode == "startover_past" {
                self.isAlertBtnClicked = true
                if hasConnectedCastSession() {
                    var seconds : Int64 = 0
                    if self.sliderPlayer != nil {
                        seconds = Int64(self.sliderPlayer.value)
                    }
                    self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                } else {
                    self.startAnimating1(#line, allowInteraction: false)
                    if self.isMidRollAdPlaying {
                        if self.adsManager != nil {
                            self.adsManager?.start()
                        }
                    } else {
                        if self.player != nil {
                            self.player.playFromBeginning()
                        }
                    }
                }
            }
        } else {
            /**/
            self.showAlertWithText(header, message: message, buttonTitles: ["Resume".localized,"Start over".localized]) { (buttonTitle) in
                if buttonTitle == "Resume".localized{
                    if hasConnectedCastSession() {
                        self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(Int(self.watchedSeekPosition/1000)))
                    } else {
                        if self.player != nil {
                            self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                        }
                        self.isAlertBtnClicked = true
                        self.startAnimating1(#line, allowInteraction: false)
                        if self.isMidRollAdPlaying {
                            if self.adsManager != nil {
                                self.adsManager?.start()
                            }
                        } else {
                            if self.player != nil {
                                self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                            }
                            self.isAlertBtnClicked = true
                            self.player.playFromCurrentTime()
                        }
                    }
                }
                else if buttonTitle == "Start over".localized{
                    self.isAlertBtnClicked = true
                    if hasConnectedCastSession() {
                        var seconds : Int64 = 0
                        if self.sliderPlayer != nil {
                            seconds = Int64(self.sliderPlayer.value)
                        }
                        self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                    } else {
                        self.startAnimating1(#line, allowInteraction: false)
                        if self.isMidRollAdPlaying {
                            if self.adsManager != nil {
                                self.adsManager?.start()
                            }
                        } else {
                            if self.player != nil {
                                self.player.playFromBeginning()
                            }
                        }
                    }
                }
            }
            if self.player != nil {
                self.player.pause()
            }
        }
        self.isContinueWatchAlertShown = true
    }
    
    func getContinueWathingTime (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        if hours > 0 {
            return String(format:"%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format:"00:%02d:%02d", minutes, seconds)
        }
    }
    
    func convertTime(miliseconds: Int) -> String {
        
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var secondsTemp: Int = 0
        var minutesTemp: Int = 0
        var hoursTemp: Int = 0
        
        if miliseconds < 1000 {
            return ""
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return String(format:"00m:%02ds", seconds)
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            return String(format:"00h:%02dm:%02ds", minutes, seconds)
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return String(format:"%dh:%02dm:%02ds", hours, minutes, seconds)
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(days) days, \(hours) hours, \(minutes) minutes, \(seconds) seconds"
        }
    }
    
    func showAlertWithText (_ header : String = String.getAppName(), message : String, buttonTitles : [String] = ["Ok".localized], completion : @escaping (_ title: String) -> Void ) {
        var _message = message
        if message.contains("master.m3u8") {
            _message = "Failed to load video".localized
            self.stopAnimating1(#line)
            return;
        }

        self.alertController = UIAlertController(title: header, message: _message, preferredStyle: .alert)
        for buttonTitle in buttonTitles{
            let confirmAction = UIAlertAction(title: buttonTitle, style: .default) { (_) in
                self.alertController?.view?.isHidden = true
                self.alertController = nil
                completion(buttonTitle)
            }
            self.alertController.addAction(confirmAction)
        }
        
//        self.alertController.view.isHidden = true
        self.present(self.alertController, animated: true) {
//            let angle: CGFloat = (self.previousOrientation == "r" ? -.pi/2 : .pi/2)
//            self.alertController.view.transform = CGAffineTransform.init(rotationAngle:angle)
//            self.alertController.view.isHidden = false
        }
    }

    @IBAction func suggestionsTap() {
        
        for pageData in self.pageDataResponse.data{
            if pageData.paneType == .section {
                if let section = pageData.paneData as? Section, section.sectionData.data.count > 0{
                    suggestionsView.updateSuggestions(sectionData: section.sectionData)
                    break;
                }
            }
        }
        
        suggestionsView.showOrHideSuggestions()
        suggestionsView.isHidden = !suggestionsView.isVisible
        if suggestionsView.isVisible{
            self.hideAllTheControls()
        }
    }
    
    @IBAction func closePlayer() {
        if self.programEndTimer != nil{
            self.programEndTimer?.invalidate()
            self.programEndTimer = nil
        }
        if self.streamPollTimer != nil{
            self.streamPollTimer?.invalidate()
            self.streamPollTimer = nil
        }
        if self.enableTakeTestTimer != nil {
            self.enableTakeTestTimer?.invalidate()
            self.enableTakeTestTimer = nil
        }
        if self.ccTimeObserver != nil {
            self.player.avplayer.removeTimeObserver(self.ccTimeObserver)
            self.ccTimeObserver = nil
        }
        if self.previewTimer != nil{
            self.previewTimer?.invalidate()
            self.previewTimer = nil
        }
        DispatchQueue.main.async {
            AppDelegate.getDelegate().selectedContentStream  = nil
            let messageDataDict:[String: Bool] = ["status": false]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
//            UIApplication.shared.isStatusBarHidden = false
            if productType.iPhone {
                let appDelegate = AppDelegate.getDelegate()
                appDelegate.shouldRotate = false
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            self.removeViews()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        }
        UIApplication.shared.showSB()
    }
    
    @IBAction func pauseButtonTapOnDockPlayer(_ sender: Any) {
        if !self.isMidRollAdPlaying {
            self.buttonAction(sender: self.playBtn!)
        }
    }

      // MARK: -  Bitrate popup
    @IBAction func settingsClicked(_ sender: AnyObject) {
        //        if self.isQualityOptionsFound {
        //            self.QualityButtonSelected()
        //        }
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let titleAttrString = NSMutableAttributedString(string: "Settings", attributes: [NSAttributedString.Key.font: UIFont.ottBoldFont(withSize: 20.0)])
        titleAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppTheme.instance.currentTheme.applicationBGColor as Any, range: NSRange(location:0,length:titleAttrString.length))
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        
        
        if self.isQualityOptionsFound && appContants.appName != .mobitel {
            alert.addAction(UIAlertAction(title: "Quality", style: .default , handler:{ (UIAlertAction)in
                self.QualityButtonSelected()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Playback speed", style: .default , handler:{ (UIAlertAction)in
            self.playBackSpeedSelected()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as! UIView).bounds
        }
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
        if #available(iOS 13.0, *) {
            alert.view.tintColor = UIColor.white
        }
        else{
            alert.view.tintColor = AppTheme.instance.currentTheme.applicationBGColor
        }
        
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    func QualityButtonSelected(){
        if self.isDownloadContent {
            let alert = UIAlertController(title: String.getAppName(), message: "You are offline", preferredStyle: UIAlertController.Style.alert)
            let messageAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(messageAlertAction)
            self.present(alert, animated: true, completion: nil)
            return;
        }
        self.pushEvents(true, "Quality Settings")
        
        let vc = BitRatesViewController()
        vc.delegate = self
        vc.displayType = "quality"
        if bitRates.count > 0 {
            vc.bitRateArry = bitRates
        }
        if self.player != nil {
            if self.player.avplayer.currentItem != nil {
                let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                let prefferedBitRate:String = String(format:"%.1f", floor((playitem.preferredPeakBitRate/1024)))
                vc.prefferedBitRate = prefferedBitRate
                self.presentpopupViewController(vc, animationType: .bottomBottom, completion: { () -> Void in
                })
            }
        }
    }
    func playBackSpeedSelected() {
        self.pushEvents(true, "Playback Speed Settings")
        let vc = BitRatesViewController()
        vc.delegate = self
        vc.bitRateArry = playBackSpeedArray
        vc.prefferedBitRate = selectedPlayBackSpeed
        vc.displayType = "playBackSpeed"
        if self.player.playbackState != .paused {
            self.buttonAction(sender: self.playBtn!)
        }
        self.presentpopupViewController(vc, animationType: .bottomBottom, completion: { () -> Void in
        })
    }
    // MARK: - PLAY / PAUSE
    @IBAction func buttonAction(sender: UIButton) {
        if sender.tag == 1 {
            /**/
            if _playBackMode == .remote {
                if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                    castSession.remoteMediaClient?.play()
                    if self.playBtn != nil {
                    self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                    }
                    if self.player.avplayer.isExternalPlaybackActive {
                        self.player.playFromCurrentTime()
                        if self.playBtn != nil {
                        self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                        }
                    }
                    self.pushEvents(true, "Play")
                }
                else {
                    castSession.remoteMediaClient?.pause()
                    if self.playBtn != nil {
                    self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                    }
                    if self.player.avplayer.isExternalPlaybackActive {
                        self.player.pause()
                        if self.playBtn != nil {
                        self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                        }
                    }
                    self.pushEvents(true, "Pause")
                }
            }
            else{
                
                if (self.player.playbackState.rawValue == PlaybackState.paused.rawValue) {
                    self.player.playFromCurrentTime()
                    if self.playBtn != nil {
                        self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                    }
                    hideControls = true
                    testVal = 3
                    showHideControllers()
                    self.pushEvents(true, "Play")
                }
                else {
                    self.player.pause()
                    if self.playBtn != nil {
                    self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
                    }
                    hideControls = false
                    testVal = 4
                    showHideControllers()
                    self.pushEvents(true, "Pause")
                }
            }
        }
        else{
           // self.showReplayButton = false
            self.isPlayBackEnd = true
            self.hideSomePlayerControllers(status: false)
            if self.playBtn != nil {
            self.playBtn?.tag = 1
            }
            if self.sliderPlayer != nil {
            self.sliderPlayer.isUserInteractionEnabled = true
            }
            countdown = 10
            if _playBackMode == .remote {
                if self.playerCastObserver != nil {
                    self.playerCastObserver.invalidate()
                    self.playerCastObserver = nil
                }
                let seconds : Int64 = 0
                hideControls = true
                testVal = 5
                showHideControllers()
                if self.nextVDOTimer != nil {
                    self.nextVDOTimer!.invalidate()
                    self.nextVDOTimer = nil
                }
                castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                self.castObserver()
            }
            else{
                if self.playBtn != nil {
                self.playBtn?.isHidden = false
                // self.replayBtn.isHidden = true
                self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                }
                hideControls = true
                testVal = 5
                showHideControllers()
                if self.nextVDOTimer != nil {
                    self.nextVDOTimer!.invalidate()
                    self.nextVDOTimer = nil
                }
                if appContants.isEnabledAnalytics && self.player != nil && self.analytics_meta_id != "" && self.analytics_meta_data.count > 0 {
                    if self.player.playerItem != nil {
                        self.buildAnalyticsMetaData()
                        logAnalytics.shared().attach(self.player.avplayer)
                    }
                }
                if (self.pageDataResponse.streamStatus.hasAccess == false) {
                    self.playBtn?.tag = 2
                    self.handlePreviewEnd()
                }
                else {
                    self.player.playFromBeginning()
                }
            }
            self.pushEvents(true, "Replay")
        }
        self.playPauseButtonOnDockPlayer.setImage(UIImage(named:(self.player.playbackState == .paused) ?  dockPlayIconName : dockPauseIconName), for: .normal)
    }
    
    @objc func showHideControllers() {
        printLog(log: "Function: \(#function),-------------- line: \(#line) testVal: \(testVal)" as AnyObject?)
        
         if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) {
            self.navTitleLableWidthConstraint?.constant = (AppDelegate.getDelegate().window?.frame.size.width ?? 250) - 250
            if self.chatButton != nil {
                if self.showWatchPartyMenu == true {
                    self.chatButton.isHidden = self.previewSecondsRemaining == 0 ? false : true
                }
                else {
                    self.chatButton.isHidden = true
                }
            }
            if self.suggestionsButton != nil {
                self.suggestionsButton.isHidden = self.previewSecondsRemaining == 0 ? false : true
            }
            if self.settingsButton != nil {
                self.settingsButton.isHidden = self.previewSecondsRemaining == 0 ? false : true
            }
            if self.shareBtn != nil {
                self.shareBtn!.isHidden = ((appContants.appName == .gac  || self.isPreviewContent == false) ? false : true)
            }
            if (self.analytics_info_contentType == "live"){
                self.view.endEditing(true)
              
                if self.takeTestButtonInPlayer != nil && isTestButtonShown == true {
                    self.takeTestButtonInPlayer.isHidden = appContants.appName == .gac ? true : self.previewSecondsRemaining == 0 ? false : true
                }
            }
            
            self.navBarButtonsStackViewWidthConstraint?.constant = 240

         }else {
            self.navTitleLableWidthConstraint?.constant = 0
            if self.chatButton != nil {
                self.chatButton.isHidden = true
            }
            if self.suggestionsButton != nil {
                self.suggestionsButton.isHidden = true
            }
            if self.takeTestButtonInPlayer != nil {
                self.takeTestButtonInPlayer.isHidden = true
            }
            if self.settingsButton != nil {
                self.settingsButton.isHidden = true
            }
            if self.shareBtn != nil {
                self.shareBtn!.isHidden = true
            }
            if self.suggestionsView != nil{
                if self.suggestionsView.isVisible {
                    suggestionsView.isHidden = !suggestionsView.isVisible
                    suggestionsView.showOrHideSuggestions()
                }
            }
            self.navBarButtonsStackViewWidthConstraint?.constant = 140
        }
        if (isSeeking == true) || self.isMinimized{
            return
        }
        printLog(log: "Function1: \(#function),-------------- line: \(#line) testVal: \(testVal)" as AnyObject?)
        if self.player == nil {
            if self.sliderPlayer != nil {
                self.sliderPlayer.isHidden = true
                self.nextContentButton.isHidden = true
                self.infoButton.isHidden = true
                self.subtitlesBtn?.isHidden = true
                self.ccButton?.isHidden = true
                self.settingsButton.isHidden = true
                self.takeTestButtonInPlayer.isHidden = true
                self.fullScreenButton.isHidden = true
                self.favInPlayer?.isHidden = true
                self.lastChannelButton?.isHidden = true
                //if self.isGoLiveBtnAvailable {
                    if self.goLiveBtn != nil {
                        self.goLiveBtn?.isHidden = true
                    }
                //}
                self.startOverOrGoLiveButton?.isHidden = true
                self.recordButton?.isHidden = true
//                self.warningLbl?.isHidden =  true
                if self.playBtn != nil {
                    self.playBtn?.isHidden = true
                }
                if self.seekFwd != nil && self.seekBckwd != nil {
                    self.seekFwd.isHidden = true
                    self.seekBckwd.isHidden = true
                }
                if self.startTime != nil {
                self.startTime.isHidden = true
                }
                if self.endTime != nil {
                self.endTime.isHidden = true
                }
                if self.mQualityButton != nil {
                    self.mQualityButton!.isHidden = true
                }
                //Rajesh Nekk
                /*
                if self.chatButton != nil{
                self.chatButton.alpha = 0.0
                self.chatButton.isHidden = true
                }
                */
                if self.subtitlesBtn != nil {
                self.subtitlesBtn!.isHidden = true
                }
                if self.shareBtn != nil{
                self.shareBtn!.isHidden = true
                }
                if self.vodStartOverButton != nil {
                    self.vodStartOverButton!.isHidden = true
                }
                if self.playBtn != nil {
                self.playBtn?.alpha = 0.0
                }
                if self.seekFwd != nil && self.seekBckwd != nil {
                    self.seekFwd.alpha = 0.0
                    self.seekBckwd.alpha = 0.0
                }
                if self.navView != nil {
                self.navView.alpha = 0.0
                }
                if self.slideView != nil {
                self.slideView.alpha = 0.0
                    self.slideView.isHidden = true
                }
                if self.playerControlsView != nil {
                self.playerControlsView.alpha = 0.0
                self.playerControlsView.isHidden = true
                }
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = true
                }
                if self.startOverOrGoLiveButton != nil {
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                }
                if self.isWarningMessageDisplayed {
//                    self.warningLbl?.isHidden = false
                }
                if self.playerErrorCode != 0 {
                    if self.navView != nil {
                    self.navView.alpha = 1.0
                    }
                }
                
                return
            }
            else {
                return
            }
        }
        if self.playerObserver == nil {
            self.stopAnimating1(#line)
        }
        
        if self.player == nil && self.sliderPlayer != nil {
            self.sliderPlayer.isHidden = true
            self.nextContentButton.isHidden = true
            self.infoButton.isHidden = true
            self.subtitlesBtn?.isHidden = true
            self.ccButton?.isHidden = true
            self.settingsButton.isHidden = true
            self.takeTestButtonInPlayer.isHidden = true
            self.fullScreenButton.isHidden = true
            self.favInPlayer?.isHidden = true
            self.lastChannelButton?.isHidden = true
//            if self.isGoLiveBtnAvailable {
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = true
                }
//            }
            self.startOverOrGoLiveButton?.isHidden = true
            self.recordButton?.isHidden = true
//            self.warningLbl?.isHidden = !((self.pageDataResponse.streamStatus.hasAccess == false) && (self.pageDataResponse.streamStatus.previewStreamStatus == true))
            if self.playBtn != nil {
            self.playBtn?.isHidden = true
            }
            //                if self.showReplayButton {
            //                    self.replayBtn.isHidden = true
            //                    self.replayBtn.alpha = 0.0
            //                }
            if self.seekFwd != nil && self.seekBckwd != nil {
            self.seekFwd.isHidden = true
            self.seekBckwd.isHidden = true
            }
            if self.startTime != nil {
            self.startTime.isHidden = true
            }
            if self.endTime != nil {
                self.endTime.isHidden = true
                
            }
            if self.mQualityButton != nil {
            self.mQualityButton!.isHidden = true
            }
            //Rajesh Nekk
/*
            if self.chatButton != nil{
            self.chatButton.alpha = 0.0
            self.chatButton.isHidden = true
            }
 */
            if self.subtitlesBtn != nil {
            self.subtitlesBtn!.isHidden = true
            }
            if self.shareBtn != nil{
            self.shareBtn!.isHidden = true
            }
            if self.vodStartOverButton != nil {
                self.vodStartOverButton!.isHidden = true
            }
            if self.playBtn != nil {
            self.playBtn?.alpha = 0.0
            }
            if self.seekFwd != nil && self.seekBckwd != nil {
                self.seekFwd.alpha = 0.0
                self.seekBckwd.alpha = 0.0
            }
            if self.navView != nil {
            self.navView.alpha = 0.0
            }
            if self.slideView != nil {
            self.slideView.alpha = 0.0
            self.slideView.isHidden = true
            }
            if self.playerControlsView != nil {
            self.playerControlsView.alpha = 0.0
            self.playerControlsView.isHidden = true
            }
            if self.goLiveBtn != nil {
            self.goLiveBtn?.isHidden = true
            }
            if self.startOverOrGoLiveButton != nil {
                self.startOverOrGoLiveButton.isHidden = true
                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                
            }
            if self.isWarningMessageDisplayed {
//                self.warningLbl?.isHidden = false
            }
            return
        }
        if self.player.avplayer.isExternalPlaybackActive || _playBackMode == .remote{
            if self.sliderPlayer == nil {
                return;
            }
            if self.isMinimized {
                self.sliderPlayer.isHidden = true
                self.nextContentButton.isHidden = true
                self.infoButton.isHidden = true
                self.subtitlesBtn?.isHidden = true
                self.ccButton?.isHidden = true
                self.settingsButton.isHidden = true
                self.takeTestButtonInPlayer.isHidden = true
                self.fullScreenButton.isHidden = true
                self.favInPlayer?.isHidden = true
                self.lastChannelButton?.isHidden = true
                self.startOverOrGoLiveButton?.isHidden = true
                self.recordButton?.isHidden = true
//                self.warningLbl?.isHidden = !((self.pageDataResponse.streamStatus.hasAccess == false) && (self.pageDataResponse.streamStatus.previewStreamStatus == true))
                if self.playBtn != nil {
                    self.playBtn?.isHidden = true
                }
                //            if self.showReplayButton {
                //                self.replayBtn.isHidden = false
                //                self.replayBtn.alpha = 1.0
                //            }
                if self.analytics_info_contentType == "live" {
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        self.seekFwd.isHidden = true
                        self.seekBckwd.isHidden = true
                    }
                } else {
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        self.seekFwd.isHidden = true
                        self.seekBckwd.isHidden = true
                    }
                }
                if self.startTime != nil {
                    self.startTime.isHidden = true
                }
                if self.endTime != nil {
                    self.endTime.isHidden = true
                }
//                if bitRates.count > 0 {
                    if self.mQualityButton != nil {
                        self.mQualityButton!.isHidden = true
                    }
//                }
                //Rajesh Nekk
/*
                if self.chatButton != nil{
                self.chatButton.alpha = 0.0
                self.chatButton.isHidden = true
                }
 */
                if self.subtitlesBtn != nil {
                    self.subtitlesBtn!.isHidden = true
                }
                if self.shareBtn != nil{
                    self.shareBtn!.isHidden = true
                }
                if self.vodStartOverButton != nil {
                    self.vodStartOverButton!.isHidden = true
                }
                if self.playBtn != nil {
                    self.playBtn?.alpha = 0.0
                }
                if self.analytics_info_contentType == "live" {
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        self.seekFwd.alpha = 0.0
                        self.seekBckwd.alpha = 0.0
                    }
                } else {
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        self.seekFwd.alpha = 0.0
                        self.seekBckwd.alpha = 0.0
                    }
                }
                if self.navView != nil {
                    self.navView.alpha = 0.0
                }
                if self.slideView != nil {
                    self.slideView.alpha = 0.0
                    self.slideView.isHidden = true
                }
                if self.playerControlsView != nil {
                    self.playerControlsView.alpha = 0.0
                    self.playerControlsView.isHidden = true
                }
//                if self.isGoLiveBtnAvailable {
                    if self.goLiveBtn != nil {
                        self.goLiveBtn?.isHidden = true
                    }
//                }
                if self.startOverOrGoLiveButton != nil {
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                }
                if self.isWarningMessageDisplayed {
//                    self.warningLbl?.isHidden = false
                }
            } else {
                if !isDownloadContent {
                    self.sliderPlayer.isHidden = false
                    if appContants.appName == .gac {
                        if orientation().isLandscape {
                            self.nextContentButton.isHidden = false
                        }
                    } else {
                        self.nextContentButton.isHidden = self.isPreviewContent == false ? false : true
                    }
                    self.infoButton.isHidden = self.previewSecondsRemaining == 0 ? false : true
                    self.subtitlesBtn?.isHidden = self.previewSecondsRemaining == 0 ? false : true
                    if appContants.appName != .tsat {
                        
                        if appContants.appName == .gac {
                            if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                                self.ccButton?.isHidden = false
                            }
                        } else {
                            self.ccButton?.isHidden = self.isPreviewContent == false ? false : true
                        }
                    }
                    //self.settingsButton.isHidden = false
                    let showFavouriteBtn = (self.pageDataResponse?.pageButtons.showFavouriteButton) ?? false
                    if showFavouriteBtn {
                        self.favInPlayer?.isHidden = appContants.appName == .gac ? true : self.isPreviewContent == false ? false : true
                    }
                }
                self.fullScreenButton.isHidden = false
//                self.warningLbl?.isHidden = true

                
                if self.vodStartOverButton != nil {
                    if self.analytics_info_contentType != "live" && self.analytics_info_contentType != "channel" {
                        
                        self.vodStartOverButton!.isHidden = self.previewSecondsRemaining == 0 ? false : true
                        if appContants.appName == .gac {
                            if self.orientation().isPortrait {
                                self.vodStartOverButton!.isHidden = true
                            }
                        }
                    }
                }
                
                #warning("remove hard coded")
                //self.ccButton?.isHidden = true
                if self.analytics_info_contentType == "live" {
                    //self.favInPlayer?.isHidden = true
                }
                #warning("remove hard coded")
                
                
                if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) {
                    
                    if self.takeTestButtonInPlayer != nil && isTestButtonShown == true {
                        self.takeTestButtonInPlayer.isHidden = appContants.appName == .gac ? true : self.previewSecondsRemaining == 0 ? false : true
                    }
                }
                //                self.lastChannelButton?.isHidden = false
                self.lastChannelButton?.isHidden = true
                
                if self.isGoLiveBtnAvailable {
                    if self.goLiveBtn != nil {
                        self.goLiveBtn?.isHidden = true
                    }
                }
                if self.startOverOrGoLiveButton != nil {
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                }
                
                
                
                self.recordButton?.isHidden = !self.pageDataResponse.info.attributes.isRecordingAllowed
//                self.warningLbl?.isHidden = !((self.pageDataResponse.streamStatus.hasAccess == false) && (self.pageDataResponse.streamStatus.previewStreamStatus == true))
                if self.playBtn != nil {
                    self.playBtn?.isHidden = false
                }
                //            if self.showReplayButton {
                //                self.replayBtn.isHidden = false
                //                self.replayBtn.alpha = 1.0
                //            }
                /*if self.analytics_info_contentType == "live" {
                 if self.seekFwd != nil && self.seekBckwd != nil {
                 self.seekFwd.isHidden = true
                 self.seekBckwd.isHidden = true
                 }
                 } else {*/
                if self.seekFwd != nil && self.seekBckwd != nil {
                    self.seekFwd.isHidden = self.isPreviewContent ? true : false
                    self.seekBckwd.isHidden = self.isPreviewContent ? true : false
                }
                //}
                if self.startTime != nil {
                    self.startTime.isHidden = false
                }
                if self.endTime != nil {
                    self.endTime.isHidden = false
                }
                //                if bitRates.count > 0 {
                if self.mQualityButton != nil {
                    self.mQualityButton!.isHidden = false
                }
                //                }
                //Rajesh Nekk
                
                /*
                 if self.chatButton != nil{
                 if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) && self.analytics_info_contentType == "live" {
                 self.chatButton.alpha = 1.0
                 self.chatButton.isHidden = false
                 }
                 else{
                 self.chatButton.alpha = 0.0
                 self.chatButton.isHidden = true
                 }
                 
                 }
                 */
                if self.subtitlesBtn != nil {
                    self.subtitlesBtn!.isHidden = false
                }
                if self.shareBtn != nil{
                    self.shareBtn!.isHidden = ((appContants.appName == .gac  || self.isPreviewContent == false) ? false : true)
                    
                    self.shareBtn!.alpha = (self.shareBtn!.isHidden == false ? 1.0 : 0.0)
                }
                if self.playBtn != nil {
                    self.playBtn?.alpha = 1.0
                }
                /*if self.analytics_info_contentType == "live" {
                 if self.seekFwd != nil && self.seekBckwd != nil {
                 self.seekFwd.alpha = 0.0
                 self.seekBckwd.alpha = 0.0
                 }
                 } else {*/
                if self.seekFwd != nil && self.seekBckwd != nil {
                    if self.sliderPlayer != nil {
                        if self.sliderPlayer.disableFarwardSeek == false {
                            self.seekFwd.alpha = 1.0
                        }
                        else {
                            //                                self.seekFwd.alpha = (self.sliderPlayer.value < self.sliderPlayer.maxForwardValue) ? 1.0 : 0.0
                        }
                    }
                    else{
                        self.seekFwd.alpha = 1.0
                    }
                    self.seekBckwd.alpha = 1.0
                }
                //}
                if self.navView != nil {
                    self.navView.alpha = 1.0
                }
                if self.slideView != nil {
                    self.slideView.alpha = 1.0
                    self.slideView.isHidden = self.isPreviewContent ? true : false
                }
                if self.isWarningMessageDisplayed {
//                    self.warningLbl?.isHidden = false
                }
                if self.playerControlsView != nil {
                    self.playerControlsView.alpha = 1.0
                    self.playerControlsView.isHidden = self.previewSecondsRemaining == 0 ? false : true
                }
                if self.isGoLiveBtnAvailable {
                    if self.goLiveBtn != nil {
                        self.goLiveBtn?.isHidden = self.previewSecondsRemaining == 0 ? false : true
                    }
                }
                if self.analytics_info_contentType == "live" {
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        self.startOverOrGoLiveButton.isHidden = self.previewSecondsRemaining == 0 ? !self.goLiveBtn!.isHidden : true
                     self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                    else {
                    //MARK: as per client requirement startover button is not required
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
                else{
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                }
            }
        }
        else if ((self.playerIndicatorCustomView != nil && !(self.playerIndicatorCustomView?.isAnimating)!) || isMinimized) && hideControls == true && self.sliderPlayer != nil{
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.sliderPlayer.isHidden = true
                self.nextContentButton.isHidden = true
                self.infoButton.isHidden = true
                self.subtitlesBtn?.isHidden = true
                self.ccButton?.isHidden = true
                self.settingsButton.isHidden = true
                self.takeTestButtonInPlayer.isHidden = true
                self.fullScreenButton.isHidden = true
                self.favInPlayer?.isHidden = true
                self.lastChannelButton?.isHidden = true
                self.goLiveBtn?.isHidden = true
                self.startOverOrGoLiveButton?.isHidden = true
                self.recordButton?.isHidden = true
                if self.playBtn != nil {
                    self.playBtn?.isHidden = true
                }
                //                if self.showReplayButton {
                //                    self.replayBtn.isHidden = true
                //                    self.replayBtn.alpha = 0.0
                //                }
                if self.seekFwd != nil && self.seekBckwd != nil {
                    if self.sliderPlayer != nil {
                        if self.sliderPlayer.disableFarwardSeek == false {
                            self.seekFwd.isHidden = self.isPreviewContent ? true : false
                        }
                        else {
                            //                            self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
                        }
                    }
                    else{
                        self.seekFwd.isHidden = true
                    }
                    self.seekBckwd.isHidden = true
                }
                if self.startTime != nil {
                    self.startTime.isHidden = true
                }
                if self.endTime != nil {
                    self.endTime.isHidden = true
                }
                if self.mQualityButton != nil {
                    self.mQualityButton!.isHidden = true
                }
                //Rajesh Nekk
                /*
                 if self.chatButton != nil{
                 self.chatButton.alpha = 0.0
                 self.chatButton.isHidden = true
                 }
                 */
                if self.shareBtn != nil{
                    self.shareBtn!.isHidden = true
                }
                if self.vodStartOverButton != nil {
                    self.vodStartOverButton!.isHidden = true
                }
                if self.playBtn != nil {
                    self.playBtn?.alpha = 0.0
                }
                if self.seekFwd != nil && self.seekBckwd != nil {
                    self.seekFwd.alpha = 0.0
                    self.seekBckwd.alpha = 0.0
                }
                if self.navView != nil {
                    self.navView.alpha = 0.0
                }
                if self.slideView != nil {
                    self.slideView.alpha = 0.0
                    self.slideView.isHidden = true
                }
                if self.playerControlsView != nil {
                    self.playerControlsView.isHidden = true
                    self.playerControlsView.alpha = 0.0
                }
                
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = true
                }
                if self.analytics_info_contentType == "live" {
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                }
                if self.isWarningMessageDisplayed {
//                    self.warningLbl?.isHidden = true
                }
            }, completion: nil)
            
        }
        else {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
                if self.sliderPlayer != nil {
                    self.sliderPlayer.isHidden = false
                    if appContants.appName == .gac {
                        if self.orientation().isLandscape {
                            self.nextContentButton.isHidden = false
                        }
                    } else {
                        self.nextContentButton.isHidden = self.isPreviewContent == false ? false : true
                    }
                    self.infoButton.isHidden = false
                    self.subtitlesBtn?.isHidden = false
                    self.warningLbl?.isHidden = true
                    if appContants.appName != .tsat {
                        if appContants.appName == .gac {
                            if UIDevice.current.orientation.isLandscape || self.orientation().isLandscape || self.isFullscreen  {
                                self.ccButton?.isHidden = false
                            }
                        } else {
                            self.ccButton?.isHidden = self.isPreviewContent == false ? false : true
                        }
                    }
                    //self.settingsButton.isHidden = false
                    self.fullScreenButton.isHidden = false
                    let showFavouriteBtn = (self.pageDataResponse?.pageButtons.showFavouriteButton) ?? false
                    if showFavouriteBtn {
                        self.favInPlayer?.isHidden = appContants.appName == .gac ? true : self.isPreviewContent == false ? false : true
                    }
                    if self.vodStartOverButton != nil {
                        if self.analytics_info_contentType != "live" && self.analytics_info_contentType != "channel" {
                            self.vodStartOverButton!.isHidden = self.isPreviewContent == false ? false : true
                            if appContants.appName == .gac {
                                if self.orientation().isPortrait {
                                    self.vodStartOverButton!.isHidden = true
                                }
                            }
                        }
                    }
                    if self.isDownloadContent {
                        self.vodStartOverButton!.isHidden = true
                        self.nextContentButton.isHidden = true
                        self.ccButton?.isHidden = true
                        self.favInPlayer?.isHidden = true
                        self.navBarButtonsStackView.removeArrangedSubview(self.suggestionsButton)
                        self.navBarButtonsStackView.removeArrangedSubview(self.chatButton)
                        self.chatButton.removeFromSuperview()
                        self.suggestionsButton.removeFromSuperview()
                        self.navBarButtonsStackViewWidthConstraint?.constant = 140
                    }
                    #warning("remove hard coded")
                    //self.ccButton?.isHidden = true
                    if self.analytics_info_contentType == "live" {
                        //self.favInPlayer?.isHidden = true
                    }
                    #warning("remove hard coded")
                    
                    if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) {
                        
                        if self.takeTestButtonInPlayer != nil && self.isTestButtonShown == true {
                            self.takeTestButtonInPlayer.isHidden = appContants.appName == .gac ? true : self.previewSecondsRemaining == 0 ? false : true
                        }
                    }
//                    self.lastChannelButton?.isHidden = false
                    self.lastChannelButton?.isHidden = true
                    
                    if self.analytics_info_contentType == "live" && self.isGoLiveBtnAvailable == false {
                        if self.goLiveBtn != nil{
                            self.goLiveBtn?.isHidden = true
                        }
                    }
                    if self.startOverOrGoLiveButton != nil {
                        if appContants.appName == .tsat || appContants.appName == .aastha  {
                        self.startOverOrGoLiveButton.isHidden = self.previewSecondsRemaining == 0 ? !self.goLiveBtn!.isHidden : true
                         self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        else {
                        //MARK: as per client requirement startover button is not required
                        self.startOverOrGoLiveButton.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        
                    }
                        
                    self.recordButton?.isHidden = self.isDownloadContent ? true : !self.pageDataResponse.info.attributes.isRecordingAllowed
                    if self.isWarningMessageDisplayed {
                        self.warningLbl?.isHidden = true
                    }
                    if self.playBtn != nil {
                        self.playBtn?.isHidden = false
                    }
                    //                if self.showReplayButton{
                    //                    self.replayBtn.isHidden = false
                    //                    self.replayBtn.alpha = 1.0
                    //                }
                    /*if self.analytics_info_contentType == "live" {
                     if self.seekFwd != nil && self.seekBckwd != nil {
                     self.seekFwd.isHidden = true
                     self.seekBckwd.isHidden = true
                     }
                     } else {*/
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        if self.sliderPlayer != nil {
                            if self.sliderPlayer.disableFarwardSeek == false {
                                self.seekFwd.isHidden = self.isPreviewContent ? true : false
                            }
                            else {
//                                self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
                            }
                        }
                        else{
                            self.seekFwd.isHidden = self.sliderPlayer.disableFarwardSeek
                        }
                        self.seekBckwd.isHidden = self.isPreviewContent ? true : false
                    }
                    //}
                    if self.startTime != nil {
                        self.startTime.isHidden = false
                    }
                    if self.endTime != nil {
                        self.endTime.isHidden = false
                    }
//                    if self.bitRates.count > 0 {
                        if self.mQualityButton != nil {
                            self.mQualityButton!.isHidden = false
                        }
//                    }
    //Rajesh Nekk

    /*
                    if self.chatButton != nil{
                    if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) && self.analytics_info_contentType == "live" {
                    self.chatButton.alpha = 1.0
                    self.chatButton.isHidden = false
                    }
                    else{
                    self.chatButton.alpha = 0.0
                    self.chatButton.isHidden = true
                    }
                    }
 */

                    if self.shareBtn != nil{
                        self.shareBtn!.isHidden = ((appContants.appName == .gac  || self.isPreviewContent == false) ? false : true)
                        self.shareBtn!.alpha = (self.shareBtn!.isHidden == false ? 1.0 : 0.0)

                    }
                    if self.playBtn != nil {
                        self.playBtn?.alpha = 1.0
                    }
                    /*if self.analytics_info_contentType == "live" {
                     if self.seekFwd != nil && self.seekBckwd != nil {
                     self.seekFwd.alpha = 0.0
                     self.seekBckwd.alpha = 0.0
                     }
                     } else {*/
                    if self.seekFwd != nil && self.seekBckwd != nil {
                        if self.sliderPlayer != nil {
                            if self.sliderPlayer.disableFarwardSeek == false {
                                self.seekFwd.alpha = 1.0
                            }
                            else {
//                                self.seekFwd.alpha = (self.sliderPlayer.value < self.sliderPlayer.maxForwardValue) ? 1.0 : 0.0
                            }
                        }
                        else{
                           self.seekFwd.alpha = 1.0
                        }
                        self.seekBckwd.alpha = 1.0
                    }
                    //}
                    if self.navView != nil {
                        self.navView.alpha = 1.0
                    }
                    if self.slideView != nil {
                        self.slideView.alpha = 1.0
                        self.slideView.isHidden = self.isPreviewContent ? true : false
                    }
                    if self.playerControlsView != nil {
                        self.playerControlsView.alpha = 1.0
                        self.playerControlsView.isHidden = false
                    }
                    if self.isGoLiveBtnAvailable {
                        if self.goLiveBtn != nil {
                            self.goLiveBtn?.isHidden = self.previewSecondsRemaining == 0 ? !self.isGoLiveBtnAvailable : true
                        }
                    }
                    if self.analytics_info_contentType == "live"{
                        if appContants.appName == .tsat || appContants.appName == .aastha {
                            if UIDevice.current.orientation.isLandscape || self.orientation().isLandscape || self.isFullscreen {
                                
                                self.startOverOrGoLiveButton.isHidden = self.previewSecondsRemaining == 0 ? !self.goLiveBtn!.isHidden : true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                            }
                            else {
                                self.startOverOrGoLiveButton.isHidden = true
                                self.startOverOrGoLiveButtonWidthConstraint?.constant = 0
                            }
                        }
                        else {
                        
                        //MARK: as per client requirement startover button is not required
                        self.startOverOrGoLiveButton.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                    else{
                        self.startOverOrGoLiveButton.isHidden = true
                        self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
            }, completion: { (_) in
                self.hideControllsTimer?.invalidate()
                self.hideControllsTimer = nil
                self.hideControllsTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
                    self.hideControls = true
                    self.showHideControllers()
                }
            })
        }
        if !Utilities.hasConnectivity() && isDownloadContent == false {
            self.stopAnimating1(#line)
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr()){ (buttonTitle) in
                self.closePlayer()
            }
        }
    }
    
    func hideAllTheControls() {
        if self.sliderPlayer != nil {
            self.sliderPlayer.isHidden = true
            self.nextContentButton.isHidden = true
            self.infoButton.isHidden = true
            self.subtitlesBtn?.isHidden = true
            self.ccButton?.isHidden = true
            self.settingsButton.isHidden = true
            self.takeTestButtonInPlayer.isHidden = true
            self.fullScreenButton.isHidden = true
            self.favInPlayer?.isHidden = true
            self.lastChannelButton?.isHidden = true
            self.startOverOrGoLiveButton?.isHidden = true
            self.recordButton?.isHidden = true
            if self.comingUpNextView != nil {
                self.comingUpNextView.isHidden = true
            }
            if self.playBtn != nil {
            self.playBtn?.isHidden = true
            }
            //                if self.showReplayButton {
            //                    self.replayBtn.isHidden = true
            //                    self.replayBtn.alpha = 0.0
            //                }
            if self.seekFwd != nil && self.seekBckwd != nil {
            self.seekFwd.isHidden = true
            self.seekBckwd.isHidden = true
            }
            if self.startTime != nil {
            self.startTime.isHidden = true
            }
            if self.endTime != nil {
            self.endTime.isHidden = true
            }
            if self.mQualityButton != nil {
            self.mQualityButton!.isHidden = true
            }
            //Rajesh Nekk

            /*
            if self.chatButton != nil{
            self.chatButton.alpha = 0.0
            self.chatButton.isHidden = true
            }
            */
            if self.subtitlesBtn != nil {
                self.subtitlesBtn!.isHidden = true
            }
            if self.shareBtn != nil{
            self.shareBtn!.isHidden = true
            }
            if self.vodStartOverButton != nil {
                self.vodStartOverButton!.isHidden = true
            }
            if self.playBtn != nil {
            self.playBtn?.alpha = 0.0
            }
            if self.seekFwd != nil && self.seekBckwd != nil {
                self.seekFwd.alpha = 0.0
                self.seekBckwd.alpha = 0.0
            }
            if self.navView != nil {
            self.navView.alpha = 0.0
            }
            if self.slideView != nil {
            self.slideView.alpha = 0.0
            self.slideView.isHidden = true
            }
            if self.playerControlsView != nil {
            self.playerControlsView.alpha = 0.0
            self.playerControlsView.isHidden = true
            }
            if self.goLiveBtn != nil {
                self.goLiveBtn?.isHidden = true
            }
            if self.startOverOrGoLiveButton != nil {
                self.startOverOrGoLiveButton.isHidden = true
            }
            if self.playerErrorCode != 0 {
                if self.navView != nil {
                self.navView.alpha = 1.0
                }
            }
            
            return
        }
    }
    
    // MARK:  - slider
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        /*if self.sliderPlayer != nil && self.sliderPlayer.disableFarwardSeek == false &&  self.analytics_info_contentType != "live" {
            //self.sliderPlayer.maxForwardValue = self.sliderPlayer.value
        }
        else if let oldSliderValue = self.sliderPlayer.oldValue , self.sliderPlayer.disableFarwardSeek {
            if self.sliderPlayer.value > oldSliderValue {
                if self.sliderPlayer.maxForwardValue < oldSliderValue{
                    self.sliderPlayer.maxForwardValue = oldSliderValue
                }
                if self.sliderPlayer.value > self.sliderPlayer.maxForwardValue {
                    self.sliderPlayer.value = self.sliderPlayer.maxForwardValue
                }
            }
        }*/
        let seconds : Int64 = Int64(sliderPlayer.value)
        if self.startTime != nil {
            self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
        }
        if appContants.isEnabledAnalytics && isSeeking == false {
            logAnalytics.shared().triggerLogEvent(eventTrigger.trigger_seek_start, position: Int(Int32(seconds)))
        }
        isSeeking = true
    }
    @objc func sliderValueDidChangeEnd(_ sender:UISlider!)
    {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.printLog(log:"Slider step value \(Int(sender.value))" as AnyObject)
        if !isDownloadContent {
            self.pushEvents(true, "Player Seek")
        }
        var seconds : Int64 = Int64(sliderPlayer.value)
        if self.sliderPlayer != nil {
            self.sliderPlayer.value = Float(seconds)
//            if self.sliderPlayer.disableFarwardSeek == false {
//                self.sliderPlayer.maxForwardValue = self.sliderPlayer.value
//            }
//            else if self.sliderPlayer.value > self.sliderPlayer.maxForwardValue {
//                self.sliderPlayer.value = self.sliderPlayer.maxForwardValue
//                seconds = Int64(sliderPlayer.value)
//            }
        }
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        self.printLog(log:"targetTime:-\(targetTime)" as AnyObject)
        if self.startTime != nil {
            self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
            currentTime = self.startTime.text!
        }
        self.startAnimating1(#line, allowInteraction: false)
        self.showHideControllers()
        if (self.endTime.text? .isEmpty)! || (self.startTime.text == self.endTime.text) {
            self.stopAnimating1(#line)
        }
        if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected && castSession != nil && castSession.remoteMediaClient != nil {
            let gckOpt = GCKMediaSeekOptions.init()
            gckOpt.interval = Double(seconds)
            castSession.remoteMediaClient?.seek(with: gckOpt)
//            castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
            if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                castSession.remoteMediaClient?.play()
                if self.playBtn != nil {
                    self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                }
            }
            if self.player.avplayer.isExternalPlaybackActive {
                self.player!.seekToTime(targetTime)
            }
        } else {
            self.player!.seekToTime(targetTime)

            self.stopAnimating1(#line)
            isSeeking = false
            if self.analytics_info_contentType == "live" {
                if self.player.maximumDuration.isFinite {
                    if seconds == Int64(self.player.maximumDuration) {
                        self.isGoLiveBtnAvailable = false
                    }
                }
                
                if self.goLiveBtn != nil && self.isGoLiveBtnAvailable == true {
                    self.goLiveBtn?.isHidden = false
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                            self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        else {
                            self.startOverOrGoLiveButton.isHidden = true
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                    else {
                    //MARK: as per client requirement startover button is not required
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
                else{
                    self.goLiveBtn?.isHidden = true
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                            self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        else {
                            self.startOverOrGoLiveButton.isHidden = true
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                    else {
                    //MARK: as per client requirement startover button is not required
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
            }
        }
        if self.seekFwd != nil && self.sliderPlayer != nil {
            if self.sliderPlayer.disableFarwardSeek == false {
                self.seekFwd.isHidden = self.isPreviewContent ? true : false
            }
            else {
//                self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
            }
        }
        if appContants.isEnabledAnalytics {
            logAnalytics.shared().triggerLogEvent(eventTrigger.trigger_seek_end, position: Int(Int32(seconds)))
        }
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.showHideControllers()
        }

    }
    
    @objc func sliderTappedAction(_ g: UIGestureRecognizer) {
        let s = g.view as! UISlider
        printYLog(#function, "s.isHighlighted", s.isHighlighted, "self.isSeeking", self.isSeeking, "tag: ", s.tag)
        if (s.isHighlighted) /*|| self.isSeeking*/ {
            return
        }
        if !isDownloadContent {
            self.pushEvents(true, "Player Seek")
        }
        // tap on thumb, let slider deal with it
        let pt: CGPoint = g.location(in: s)
        let percentage: CGFloat = pt.x / (s.bounds.size.width)
        let delta: CGFloat = percentage * CGFloat((s.maximumValue - s.minimumValue))
        let value: CGFloat = CGFloat(s.minimumValue) + delta
        /*if Float(value) > self.sliderPlayer.value && self.sliderPlayer.disableFarwardSeek {
            if Float(value) > self.sliderPlayer.maxForwardValue {
                self.sliderPlayer.value = self.sliderPlayer.maxForwardValue
            }
            else{
                if Float(value) > self.sliderPlayer.value {
                    self.sliderPlayer.value = Float(value)
                }
                else{
                    self.sliderPlayer.value = self.sliderPlayer.oldValue ?? self.sliderPlayer.value
                }
            }
        }
        else {
            self.sliderPlayer.value = Float(value)
        }*/
        self.sliderPlayer.value = Float(value)
        if self.seekFwd != nil && self.sliderPlayer != nil {
            if self.sliderPlayer.disableFarwardSeek == false {
                self.seekFwd.isHidden = self.isPreviewContent ? true : false
            }
            else {
//                 self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
            }
        }
        let seconds : Int64 = Int64(sliderPlayer.value)
        if seconds > 0
        {
            var startSeconds: Int64 = 0
            if self.timeRangePlayer != nil && !(CMTimeGetSeconds(self.timeRangePlayer.start).isNaN) {
                startSeconds = Int64(CMTimeGetSeconds(self.timeRangePlayer.start))
            }
            if self.player.currentTime.isNaN {
                seekStartValue = Int64(sliderPlayer.value) - startSeconds
            } else {
                seekStartValue = Int64(self.player.currentTime) - startSeconds
            }
            seekEndValue = seconds - startSeconds
            
            printYLog("seekStartValue:4 ", seekStartValue!, seekEndValue!, startSeconds, self.sliderPlayer.minimumValue, self.sliderPlayer.maximumValue)
            printYLog("isSeeking:2 ", isSeeking)
            if self.playBtn != nil {
            self.playBtn?.isHidden = true
            }
//            printYLog("playBtn is hidden :4: ", self.playBtn?.isHidden, " isSeeking", self.isSeeking)
//            self.startActivity(4)
//            self.iconsShowAndHide(4)
            
//            if self.nex == true {
//                self.reloadBtn.isHidden = true
//                self.showReplayButton = false
//                if self.player != nil && self.player.playerItem != nil {
//                    self.player.playbackState = .stopped
//                }
//                self.playInNewSession()
//            }
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
            self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds - startSeconds)))"
            currentTime = self.startTime.text!
            /* self.getLogAnalyticsEventDict(eventType: PlayerEventType.SEEKING)
             if lastEvent != PlayerEventType.BUFFER_START {
             printYLog( "lastEvent:2- \(player.bufferingState)" as AnyObject)
             self.getLogAnalyticsEventDict(eventType: PlayerEventType.BUFFER_START)
             }*/
            if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
                castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
                if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                    castSession.remoteMediaClient?.play()
                    if self.playBtn != nil {
                    self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                    }
                }
                if self.player.avplayer.isExternalPlaybackActive {
//                    if (checkifUrlIsMp4() == true){
//                        self.player!.pause()
//                        self.playBtn?.isHidden = true
//                        printYLog("playBtn is hidden :5: ", self.playBtn?.isHidden, " isSeeking", self.isSeeking)
//                    }
                    self.reportSeekEvent(true)
                    isSeeking = true
                    self.reportSeekEvent(false)
                    self.player!.seekToTime(targetTime)
                    isSeeking = false
                }
            } else {
//                if (checkifUrlIsMp4() == true){
//                    self.player!.pause()
//                    self.playBtn?.isHidden = true
//                    printYLog("playBtn is hidden :6: ", self.playBtn?.isHidden, " isSeeking", self.isSeeking)
//                }
                self.reportSeekEvent(true)
                isSeeking = true
                self.reportSeekEvent(false)
                self.player!.seekToTime(targetTime)
                isSeeking = false
            }
        }
    }

    func updateSliderForwardStatus(){
        if self.sliderPlayer != nil {
            self.sliderPlayer.disableFarwardSeek = false
        }
        /*if (streamResponse.analyticsInfo.dataType == "channel") && (streamResponse.analyticsInfo.contentType == "live"){
            if self.sliderPlayer != nil {
                self.sliderPlayer.disableFarwardSeek = false
                self.sliderPlayer.maxForwardValue = 0.0
            }
        }
        else if (self.pageDataResponse != nil){
            if (streamResponse.analyticsInfo.dataType == "epg") && (streamResponse.analyticsInfo.contentType == "vod") && (self.pageDataResponse.info.attributes.isRecorded == false ){
                if self.sliderPlayer != nil {
                    self.sliderPlayer.disableFarwardSeek = false
                    self.sliderPlayer.maxForwardValue = 0.0
                }
            }
        }*/
        if self.seekFwd != nil && self.sliderPlayer != nil {
            self.seekFwd.isHidden = self.sliderPlayer.disableFarwardSeek
        }
    }
    
    func startAnimating1(_ line : Int = -1, allowInteraction:Bool) {
        if self.playerIndicatorView != nil {
            print("#load : start : \(line)")
            self.playerIndicatorCustomView?.removeFromSuperview()
            self.playerIndicatorCustomView = nil
            self.playerIndicatorCustomView = CustomActivityIndicatorView.init(image: UIImage(named:"loader_icon")!)
            self.playerIndicatorCustomView?.frame = CGRect.init(x: -2.0, y: -2.0, width: (self.playerIndicatorView?.frame.size.width)!, height: (self.playerIndicatorView?.frame.size.height)!)
            self.playerIndicatorView?.addSubview(self.playerIndicatorCustomView!)
            self.playerIndicatorCustomView?.startAnimatingFromPlayer()
                        
            if allowInteraction == false{
                self.changeSubViewInteractionTo(allowInteraction: allowInteraction)
            }
        }
    }
    
    func stopAnimating1(_ line : Int = 100) {
        if self.playerIndicatorCustomView?.isAnimating ?? false{
            print("#load : stop :\(line)" )
            self.playerIndicatorCustomView?.stopAnimating()
            self.changeSubViewInteractionTo(allowInteraction: true)
        }
    }
    
//    func stopAnimatingPlayer2(_ isMinimized: Bool) {
//        self.playerIndicatorCustomView?.stopAnimating()
//        //        self.playerIndicatorCustomView = nil
//        self.changeSubViewInteractionTo(allowInteraction: true)
//    }
    
    func changeSubViewInteractionTo(allowInteraction:Bool) {
        if self.playerHolderView != nil {
            for subView in self.playerHolderView.subviews {
                if subView is UIButton {
                    let button = subView as? UIButton
                    button?.isEnabled = allowInteraction
                }
                else {
                    for view in subView.subviews {
                        if view is UIButton {
                            let subButton = view as? UIButton
                            subButton?.isEnabled = allowInteraction
                        }
                        else if view is UISlider {
                            let subSlider = view as? UISlider
                            subSlider?.isEnabled = allowInteraction
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - ChromeCast delegate methods
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        self.printLog(log:"MediaViewController: sessionManager didStartSession \(session)" as AnyObject?)
        //        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        self.printLog(log:"MediaViewController: sessionManager didResumeSession \(session)" as AnyObject?)
        self.switchToRemotePlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, willEnd session: GCKSession) {
        print(#function)
        castTargetTime = CMTime.invalid
        if _playBackMode == .remote {
            if self.castSession != nil {
                if self.castSession.remoteMediaClient?.mediaStatus != nil {
                    if(self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem != nil) {
                        if(self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem?.mediaInformation.streamDuration.isFinite)! {
                            let playPosition = Int64(castMediaController.lastKnownStreamPosition)
                            print("playPosition: ", playPosition)
                            castTargetTime = CMTimeMake(value: Int64(playPosition), timescale: 1)
                        }
                    }
                }
            }
        }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.printLog(log:"session ended with error: \(String(describing: error))" as AnyObject?)
            //        var message = "The Casting session has ended.\n\(error!.description)"
            //        Toast.displayMessage(message, forTimeInterval: 3, inView: AppDelegate.getDelegate().window!)
            self.switchToLocalPlayback()
         }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        //        self.showAlert(withTitle: "Failed to start a session", message: error!.description)
    }
    
    // MARK: - ChromeCast Media Controll methods
    
    func contentInformation() -> (title : String, subTitle : String, imageUrl : String?,logo : String , contentCode : String, description : String, expiryDaysText : String, subTitle1 : String,cast:String, expiryElementSubtype:String,subTitle5 : String)  {
        var title = "", subTitle = "", imageUrl = "", contentCode = "", description = "", logo = "", expiryDaysText = "", tempSubTitle1 = "", tempSubTitle2 = "", tempSubTitle3 = "", cast = "", expiryElementSubtype = "",subTitle5 = ""
        for pageData in self.pageDataResponse.data {
            if pageData.paneType == .content {
                let content = pageData.paneData as? Content
                imageUrl =  content?.backgroundImage ?? ""
                for dataRow in (content?.dataRows)! {
                    for element in dataRow.elements {
                        if (element.elementType == .text) && (element.elementSubtype == "title"){
                            title = element.data;
                        }
                        else if element.elementType == .image {
                            logo = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "subtitle") {
                            subTitle = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "subtitle1") {
                            tempSubTitle1 = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "subtitle2") {
                            tempSubTitle2 = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "subtitle3") {
                            tempSubTitle3 = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "subtitle5") {
                            subTitle5 = element.data;
                        }
                        else if (element.elementType == .text) && (element.elementSubtype == "cast") {
                            cast = element.data;
                        }
                        else if element.elementType == .description {
                            description = element.data;
                        }
                        else if (element.elementType == .marker) && ((element.elementSubtype == "exipiryDays") || (element.elementSubtype == "expires") || (element.elementSubtype == "expires_day") || (element.elementSubtype == "expires_today") || (element.elementSubtype == "available_soon_label") || (element.elementSubtype == "availableUntil") || (element.elementSubtype == "expiry") || (element.elementSubtype == "expiring_soon") || (element.elementSubtype == "expires_hours") || (element.elementSubtype == "expires_minutes") || (element.elementSubtype == "expiry_time") ) { // exipiryDays is typo from backend. ignore
                            expiryDaysText = element.data;
                            expiryElementSubtype = element.elementSubtype
                        }
                        if contentCode.count == 0{
                            contentCode = element.contentCode
                        }
                    }
                }
            }
            else {
                continue
            }
        }
        let subTitle1 = tempSubTitle1 + tempSubTitle2 + tempSubTitle3
        return (title , subTitle, imageUrl, logo, contentCode, description, expiryDaysText,subTitle1,cast,expiryElementSubtype,subTitle5);
    }
    
    func buildMediaInformation() -> GCKMediaInformation {
        
        let contentInformation = self.contentInformation()
        let titleName = contentInformation.title
        
        let metadata = GCKMediaMetadata(metadataType: GCKMediaMetadataType.movie)
        metadata.addImage(GCKImage.init(url: NSURL.init(string: self.defaultPlayingItemUrl)! as URL, width: 480, height: 720))
        
        let auth_key = "\(PreferenceManager.sessionId)"
        let boxId = "\(PreferenceManager.boxId)"
        let locationinfo = [ "analytics_id" : Constants.OTTUrls.Analyticskey,"auth_key" :auth_key,"true_ip":AppDelegate.getDelegate().trueip,] as [String : Any]
        
        let userId: String = {
            if let userId_tmp = OTTSdk.preferenceManager.user?.userId {
                return "\(userId_tmp)"
            } else {
                return "-1"
            }
        }()
        let userSubscribed: String = {
            if (OTTSdk.preferenceManager.user?.packages.count) != nil {
                return "1"
            } else {
                return "0"
            }
        }()
        var autoPlay = "false"
        if let temp_autoPlay = self.analytics_meta_data["autoPlay"] {
            autoPlay = temp_autoPlay as! String
        }
        var tempEnv = ""
        switch appContants.serviceType {
            case .beta:
                tempEnv = "beta"
            case .beta2:
                tempEnv = "beta"
            case .UAT:
                tempEnv = "uat"
            case.live:
                tempEnv = "live"
        }
        let name = self.pageDataResponse?.shareInfo.name ?? (self.isDownloadContent ? (self.offLineDownloadAsset?.stream.name ?? "") : "")
        let description = self.pageDataResponse?.shareInfo.shareDescription ?? (self.isDownloadContent ? (self.offLineDownloadAsset?.stream.subTitle ?? "") : "")
        let url = self.videoUrlString_ChromeCast ?? (self.isDownloadContent ? (self.offLineDownloadAsset?.stream.playlistURL ?? "") : "")
        let custom_dict = [ "licenseUrl" : self.playerLicenseUrl,"deviceId" :PreferenceManager.deviceType,"appversion":Bundle.applicationVersionNumber,"locationinfo":locationinfo,"metaId":self.analytics_meta_id as String,"metaMap":"","navigationfrom":AppAnalytics.navigatingFrom,"boxId":boxId,"tenantCode":OTTSdk.preferenceManager.tenantCode ,"pollKey":self.streamResponse.sessionInfo.streamPollKey,"pollTime":self.streamResponse.sessionInfo.pollIntervalInMillis,"userId":userId,"isSubscribed":userSubscribed,"autoPlay":autoPlay,"contentType":self.analytics_info_contentType as String,"environment":tempEnv,"isCCEnabled":ccButton?.isSelected ?? false] as [String : Any]
        
        let mediaInfo = GCKMediaInformation.init(contentID: self.videoUrlString_ChromeCast, streamType: GCKMediaStreamType.buffered, contentType: "video/mp4", metadata: metadata, streamDuration: self.mediaInfo.streamDuration, mediaTracks: nil, textTrackStyle: GCKMediaTextTrackStyle.createDefault(), customData: custom_dict)
        
        metadata.setString(self.defaultPlayingItemUrl, forKey: kMediaKeyPosterURL)
        metadata.addImage(GCKImage.init(url: NSURL.init(string: self.defaultPlayingItemUrl)! as URL, width: 480, height: 720))
        
        metadata.setString(titleName, forKey: kGCKMetadataKeyTitle)
        metadata.setString("Show", forKey: kMediaKeyDescription)
        metadata.setString("Show", forKey: kGCKMetadataKeyStudio)
        
        //        var mediaInfo = GCKMediaInformation(contentID: self.mediaInfo.imageU, streamType: GCKMediaStreamType.buffered, contentType: "video/mp4", metadata: metadata, streamDuration: self.mediaInfo.duration, mediaTracks: nil, textTrackStyle: nil, customData: nil)
        return mediaInfo
    }
    
    func playSelectedItemRemotely() {
        self.castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
        if (castSession != nil) {
            self.mediaInfo = self.buildMediaInformation()
            let streamStatus = self.pageDataResponse.streamStatus
            if ((templateElement?.elementCode == "startover" || templateElement?.elementCode == "startover_past") && self.analytics_info_contentType != "live") {
                  self.watchedSeekPosition = 0
            }
            else {
                self.watchedSeekPosition = streamStatus.seekPositionInMillis
            }
            if self.watchedSeekPosition > 0 {

                self.isAlertBtnClicked = false
                let watchedTime = self.convertTime(miliseconds: self.watchedSeekPosition)
//                let message = String.init(format: "%@%@", "Would you like to continue from".localized,watchedTime)
                if watchedTime .isEmpty {
                    var seconds : Int64 = 0
                    if sliderPlayer != nil {
                        seconds = Int64(sliderPlayer.value)
                    }
                    let mOpt = GCKMediaLoadOptions.init()
                    mOpt.autoplay = true
                    mOpt.playPosition = Double(seconds)
                    castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, with: mOpt)
//                    castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                }
                else {
                    let seconds  = watchedSeekPosition / 1000
//                    if sliderPlayer != nil {
//                        seconds = Int64(sliderPlayer.value)
//                    }
                    let mOpt = GCKMediaLoadOptions.init()
                    mOpt.autoplay = true
                    mOpt.playPosition = Double(seconds)
                    castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, with: mOpt)
//                    castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                }
                
            }
            else {
                var seconds : Int64 = 0
                if sliderPlayer != nil {
                    seconds = Int64(sliderPlayer.value)
                }
                let mOpt = GCKMediaLoadOptions.init()
                mOpt.autoplay = true
                mOpt.playPosition = Double(seconds)
                castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, with: mOpt)
//                castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
            }

            self.castObserver()
        }
        else {
            self.printLog(log:"no castSession!" as AnyObject?)
        }
    }
    
    func switchToLocalPlayback() {
        self.printLog(log:"switchToLocalPlayback" as AnyObject?)
        if _playBackMode == .local {
            return
        }
        if self.playerCastObserver != nil {
            self.playerCastObserver.invalidate()
            self.playerCastObserver = nil
        }
        if self.castSession != nil {
            castSession.remoteMediaClient?.remove(self)
        }
        if self.videoUrlString == nil {
            return
        }
        var playPosition = 0
        //        var paused = false
        //        var ended = false
        if _playBackMode == .remote {
            if castMediaController.lastKnownStreamPosition.isFinite {
                playPosition = Int(castMediaController.lastKnownStreamPosition)
            }
            //            paused = (castMediaController.lastKnownPlayerState == GCKMediaPlayerState.paused)
            //            ended = (castMediaController.lastKnownPlayerState == GCKMediaPlayerState.idle)
        }
        castSession.remoteMediaClient?.remove(self)
        castTargetTime = CMTimeMake(value: Int64(playPosition), timescale: 1)
        if self.player == nil {
            self.player = Player()
            self.player.delegate = self
        }
        self.player.playbackState = PlaybackState.paused
        self.castSession = nil
        if self.playBtn != nil {
            self.playBtn?.setImage(UIImage(named:"playicon"), for: .normal)
        }
        self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(self.player.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
      
        self._playBackMode = .local
        testVal = 15
        showHideControllers()
        self.startAnimating1(#line, allowInteraction: true)
        if castTargetTime != CMTime.invalid {
            self.player.seekToTime(castTargetTime)
            castTargetTime = CMTime.invalid
            self.player.playFromCurrentTime()
        }
    }
    
    func switchToRemotePlayback() {
        self.printLog(log:"switchToRemotePlayback; mediaInfo is \(String(describing: self.mediaInfo))" as AnyObject?)
        if _playBackMode == .remote {
            return
        }
        if self.player != nil && self.videoUrlString_ChromeCast != nil && self.videoUrlString_ChromeCast != "" {
            self.castSession = GCKCastContext.sharedInstance().sessionManager.currentCastSession
            // If we were playing locally, load the local media on the remote player
            if (_playBackMode == .local) && (self.player.playbackState.rawValue != PlaybackState.stopped.rawValue) && (self.mediaInfo != nil) {
               /* let playPosition = self.player.currentTime
                let builder = GCKMediaQueueItemBuilder()
                builder.mediaInformation = self.buildMediaInformation()
                builder.autoplay = true
                builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
                let item = builder.build()
                castSession.remoteMediaClient?.queueLoad([item], start: 0, playPosition: playPosition, repeatMode: GCKMediaRepeatMode.off, customData: nil)
                */
                 self.mediaInfo = self.buildMediaInformation()
                var seconds : Int64 = 0
                if sliderPlayer != nil {
                    seconds = Int64(sliderPlayer.value)
                }
                castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(seconds))
                
            }
            self.castObserver()
        }
        if self.player != nil {
            if !self.player.avplayer.isExternalPlaybackActive {
                self.player.pause()
            }
        }
    }
    
    func castObserver(){
        if self.playBtn != nil {
            self.playBtn?.tag = 1
            self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
        }
        self._playBackMode = .remote
        //        showControls = false
        testVal = 16
        showHideControllers()
        //        showHideControllers(show: false)
        self.playerCastObserver = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playerCurrentTimeDidChange), userInfo: nil, repeats: true)
    }
    
    func mediaController(_ mediaController: GCKUIMediaController, didUpdate playerState: GCKMediaPlayerState, lastStreamPosition streamPosition: TimeInterval){
        
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.castingLastStreamPosition = streamPosition
        if playerState == GCKMediaPlayerState.playing {
            isSeeking = false
        }
    }
    func mediaController(_ mediaController: GCKUIMediaController, didBeginPreloadForItemID itemID: UInt){
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
    }
    func mediaController(_ mediaController: GCKUIMediaController, didUpdate mediaStatus: GCKMediaStatus){
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
   
        var endPlay = false
        if (mediaStatus.playerState.rawValue == 1 && mediaStatus.idleReason.rawValue == 1) {
            endPlay = true
        } else if (mediaStatus.playerState.rawValue == 4 && mediaStatus.idleReason.rawValue == 0) {
            if (self.castSession != nil && self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem != nil && (self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem?.mediaInformation.streamDuration.isInfinite)! == false) {
                let currentPosition = Int(castMediaController.lastKnownStreamPosition)
                let totalDuration = Int((self.castSession.remoteMediaClient?.mediaStatus?.currentQueueItem?.mediaInformation.streamDuration)!)
                printYLog(#function, "currentPosition: ", currentPosition, "totalDuration: ", totalDuration)
                if (currentPosition == totalDuration) {
                    self.castSession.remoteMediaClient?.stop()
                    endPlay = true
                }
            }
        } else if (mediaStatus.playerState.rawValue == 0 && mediaStatus.idleReason.rawValue == 0  && self.comingFromBackground == true) {
            self.comingFromBackground = false
            endPlay = true
        }
        if endPlay == true {
//            if self.playerCastObserver != nil {
//                self.playerCastObserver.invalidate()
//                self.playerCastObserver = nil
//            }
            self.playerPlaybackDidEnd(self.player)
        }
    }
    
    func continueAfterPlayButtonClicked() -> Bool {
        self.printLog(log:"continueAfterPlayButtonClicked" as AnyObject?)
        if _playBackMode == .remote {
            if self.nextVideoContent != nil {
                let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                if (self.mediaInfo != nil) && hasConnectedCastSession() {
                    if !self.isMidRollAdPlaying {
                        self.playSelectedItemRemotely()
                    }
                    return false
                }
            }
            return false
        }
        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
        if (self.mediaInfo != nil) && hasConnectedCastSession() {
            if !self.isMidRollAdPlaying {
                self.playSelectedItemRemotely()
            }
            return false
        }
        return true
    }

    //MARK: - Continue watching custom methods
    func getTotalPercentageWatched() -> Int {
        if self.player != nil {
            if sliderPlayer != nil {
                let presentWatchedTime : Int64 = Int64(sliderPlayer.value)
                var totalShowTime : Int64 = 0
                if self.player.maximumDuration.isFinite {
                    totalShowTime = Int64(self.player.maximumDuration)
                }
                let totalPercentWatched = (Float(presentWatchedTime) / Float(totalShowTime)) * 100
                if totalPercentWatched.isNaN {
                    return 0;
                }
                return Int(totalPercentWatched)
            }
            else{
                return 0
            }
        }
        else{
            return 0
        }
    }

    /*
     author : Chandrasekhar.J
     method : updateTheContinueWatchingLict
     return : void
     params : --
     description : this method is used to update the continue watching list
     */
    
    func updateTheContinueWatchingList(isAddingNextEpisode:Bool) {
        return;
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueWatchingList = NSMutableArray()
        var currentShowTimeList = NSMutableArray()
        var episodePlayedDict = [String:TimeInterval]()
        if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") != nil {
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
            let continueCurrentTimeList = continueDict["Current_Show_Time"]
            if continueCurrentTimeList != nil {
                if continueCurrentTimeList is NSArray {
                    currentShowTimeList = NSMutableArray.init(array: continueCurrentTimeList as! NSArray)
                }
                else {
                    currentShowTimeList = continueCurrentTimeList as! NSMutableArray
                }
            }
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            //                if isDuplicate(episodeDictArr: continueWatchingList) {
            //                    return
            //                }
            continueWatchingList = NSMutableArray.init(array: continueWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = NSMutableArray.init(array: currentShowTimeList.reverseObjectEnumerator().allObjects as NSArray)
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            
            var episodeIndex = 0
            for episodeDict in continueWatchingList {
                let tempEpisodeDict = episodeDict as! NSDictionary
                let presentplayingItemTargetPath = self.continueWatchDict["playingItemTargetPath"]
                let tempTvShowID = episodeDict as! [String:String]
                if (presentplayingItemTargetPath == tempTvShowID["playingItemTargetPath"]) {
                    continueWatchingList.remove(tempEpisodeDict)
                    currentShowTimeList.removeObject(at: episodeIndex)
                    break
                }
                episodeIndex = episodeIndex + 1
            }
            continueWatchingList = NSMutableArray.init(array: continueWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = NSMutableArray.init(array: currentShowTimeList.reverseObjectEnumerator().allObjects as NSArray)
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            if continueWatchingList.count == 10 {
                continueWatchingList.removeObject(at: 0)
                currentShowTimeList.removeObject(at: 0)
                if continueWatchingList.count == 0 {
                    self.addToUserDefaults(continueWatchingList, currentShowTimeList)
                    return
                }
            }
            continueWatchingList.add(self.continueWatchDict)
            if isAddingNextEpisode {
                episodePlayedDict.updateValue(TimeInterval.init(exactly: 0)!, forKey: "Current_Time")
                episodePlayedDict.updateValue(TimeInterval.init(exactly: 0)!, forKey: "Maximum_Time")
            }
            else {
                episodePlayedDict.updateValue(self.player.currentTime, forKey: "Current_Time")
                if (self.player.maximumDuration.isFinite) {
                    episodePlayedDict.updateValue(self.player.maximumDuration, forKey: "Maximum_Time")
                }
                else {
                    episodePlayedDict.updateValue(0, forKey: "Maximum_Time")
                }
            }
            currentShowTimeList.add(episodePlayedDict)
            self.addToUserDefaults(continueWatchingList, currentShowTimeList)
        }
        else {
            currentShowTimeList = NSMutableArray()
            continueWatchingList = NSMutableArray()
            continueWatchingList.add(self.continueWatchDict)
            episodePlayedDict.updateValue(self.player.currentTime, forKey: "Current_Time")
            episodePlayedDict.updateValue(self.player.maximumDuration, forKey: "Maximum_Time")
            currentShowTimeList.add(episodePlayedDict)
            
            self.addToUserDefaults(continueWatchingList, currentShowTimeList)
        }
        yuppFlixUserDefaults.synchronize()
        
    }
    
    /*
     author : Chandrasekhar.J
     method : removeTheShowEpisodeIfalreadyExists
     return : void
     params : --
     description : this method is used to remove the show episode if already exists
     */
    
    func removeTheShowEpisodeIfalreadyExists() {
        return;
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueWatchingList = NSMutableArray()
        var currentShowTimeList = NSMutableArray()
        if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List")  != nil {
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
            let continueCurrentTimeList = continueDict["Current_Show_Time"]
            if continueCurrentTimeList != nil {
                if continueCurrentTimeList is NSArray {
                    currentShowTimeList = NSMutableArray.init(array: continueCurrentTimeList as! NSArray)
                }
                else {
                    currentShowTimeList = continueCurrentTimeList as! NSMutableArray
                }
            }
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            continueWatchingList = NSMutableArray.init(array: continueWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = NSMutableArray.init(array: currentShowTimeList.reverseObjectEnumerator().allObjects as NSArray)
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            
            var episodeIndex = 0
            for episodeDict in continueWatchingList {
                let tempEpisodeDict = episodeDict as! NSDictionary
                let presentTvShowID = self.continueWatchDict["playingItemTargetPath"]
                let tempTvShowID = episodeDict as! [String:String]
                if (presentTvShowID == tempTvShowID["playingItemTargetPath"]) {
                    continueWatchingList.remove(tempEpisodeDict)
                    currentShowTimeList.removeObject(at: episodeIndex)
                    break
                }
                episodeIndex = episodeIndex + 1
            }
            continueWatchingList = NSMutableArray.init(array: continueWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            continueWatchingList = continueWatchingList.mutableCopy() as! NSMutableArray
            currentShowTimeList = NSMutableArray.init(array: currentShowTimeList.reverseObjectEnumerator().allObjects as NSArray)
            currentShowTimeList = currentShowTimeList.mutableCopy() as! NSMutableArray
            self.addToUserDefaults(continueWatchingList, currentShowTimeList)
        }
    }
    
    
    /*
     author : Chandrasekhar.J
     method : updateTheRecentlyWatchedList
     return : void
     params : --
     description : this method is used to update the recently watching list
     */
    
    func updateTheRecentlyWatchedList() {
        return;
        let yuppFlixUserDefaults = UserDefaults.standard
        var recentlyWatchingList = NSMutableArray()
        if yuppFlixUserDefaults.object(forKey: "Recently_Watching_List") != nil {
            let recentDict = self.getRecentlyWatchedDataFromUserDefaults()
            let continueList = recentDict["Recently_Watching_List"]
            if continueList != nil {
                if continueList is NSArray {
                    recentlyWatchingList = NSMutableArray.init(array: continueList as! NSArray)
                }
                else{
                    recentlyWatchingList = continueList as! NSMutableArray
                }
            }
            recentlyWatchingList = recentlyWatchingList.mutableCopy() as! NSMutableArray
            recentlyWatchingList = NSMutableArray.init(array: recentlyWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            recentlyWatchingList = recentlyWatchingList.mutableCopy() as! NSMutableArray
            
            for episodeDict in recentlyWatchingList {
                let tempEpisodeDict = episodeDict as! NSDictionary
                let presentplayingItemTargetPath = self.continueWatchDict["playingItemTargetPath"]
                let tempTvShowID = episodeDict as! [String:String]
                if (presentplayingItemTargetPath == tempTvShowID["playingItemTargetPath"]) {
                    recentlyWatchingList.remove(tempEpisodeDict)
                    break
                }
            }
            recentlyWatchingList = NSMutableArray.init(array: recentlyWatchingList.reverseObjectEnumerator().allObjects as NSArray)
            recentlyWatchingList = recentlyWatchingList.mutableCopy() as! NSMutableArray
            if recentlyWatchingList.count == 10 {
                recentlyWatchingList.removeObject(at: 0)
                if recentlyWatchingList.count == 0 {
                    self.addRecentlyWatchedToUserDefaults(recentlyWatchingList)
                    return
                }
            }
            recentlyWatchingList.add(self.continueWatchDict)
            self.addRecentlyWatchedToUserDefaults(recentlyWatchingList)
        }
        else {
            recentlyWatchingList = NSMutableArray()
            recentlyWatchingList.add(self.continueWatchDict)
            
            self.addRecentlyWatchedToUserDefaults(recentlyWatchingList)
        }
        yuppFlixUserDefaults.synchronize()
        
    }
    
    func addToUserDefaults(_ continueWatchingList:NSMutableArray,_ currentShowTimeList:NSMutableArray) {
        return;
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueWatchingDict = [String:Any]()
        continueWatchingDict["Continue_Watching_List"] = continueWatchingList
        continueWatchingDict["Current_Show_Time"] = currentShowTimeList
        
        if let userID = (OTTSdk.preferenceManager.user?.userId) {
            var userIDContinueWatchingDict = [String:[String:Any]]()
            userIDContinueWatchingDict.updateValue(continueWatchingDict, forKey: "\(userID)")
            var finalContinueWatchingList = [String:[String:[String:Any]]]()
            finalContinueWatchingList["Continue_Watching_List"] = userIDContinueWatchingDict
            
            yuppFlixUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: finalContinueWatchingList), forKey: "Continue_Watching_List")
            yuppFlixUserDefaults.synchronize()
        }
    }
    
    func addRecentlyWatchedToUserDefaults(_ continueWatchingList:NSMutableArray) {
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueWatchingDict = [String:Any]()
        continueWatchingDict["Recently_Watching_List"] = continueWatchingList
        if let userID = (OTTSdk.preferenceManager.user?.userId) {
            var userIDContinueWatchingDict = [String:[String:Any]]()
            userIDContinueWatchingDict.updateValue(continueWatchingDict, forKey: "\(userID)")
            
            var finalContinueWatchingList = [String:[String:[String:Any]]]()
            finalContinueWatchingList["Recently_Watching_List"] = userIDContinueWatchingDict
            
            yuppFlixUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: finalContinueWatchingList), forKey: "Recently_Watching_List")
            yuppFlixUserDefaults.synchronize()
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

    //MARK: - ComingUpNextViewDelegate
    func comingUpNextViewDidTap(){
        self.nextVideoPlayBtnCLicked(self.nextContentButton as Any)
    }
    func didSelectedOfflineSuggestion(stream : Stream) {
        self.hideSomePlayerControllers(status: false)
        self.delegate?.didSelectedOfflineSuggestion(stream: stream)
    }
    //MARK: - PlayerSuggestionsViewControllerDelegate
    func didSelectedSuggestion(card : Card){
        self.hideSomePlayerControllers(status: false)
//        if self.analytics_info_contentType != "live" {
//            self.addToContinueWatchingList(isAddingNextEpisode: false)
//        }
        let contentName = card.display.title
       if self.analytics_info_dataType == "tvshowepisode" || self.analytics_info_dataType == "episode" {
            LocalyticsEvent.tagEventWithAttributes("Player_Recommendations", ["Content Name":contentName,"Content_Type":self.analytics_info_contentType, "TV_Show":contentName])
        } else if self.analytics_info_dataType == "movie"{
            LocalyticsEvent.tagEventWithAttributes("Player_Recommendations", ["Content Name":contentName,"Content_Type":self.analytics_info_contentType, "Movies":contentName])
        } else if self.analytics_info_dataType == "channel"{
            LocalyticsEvent.tagEventWithAttributes("Player_Recommendations", ["Content Name":contentName,"Content_Type":self.analytics_info_contentType, "Live_TV":contentName])
        } else if self.analytics_info_dataType == "epg"{
            LocalyticsEvent.tagEventWithAttributes("Player_Recommendations", ["Content Name":contentName,"Content_Type":self.analytics_info_contentType, "Catchup":contentName])
        }

        var playableStatus:Bool = false
        if card.target.pageType == "player" {
            playableStatus = true
        }
        if playableStatus {
            self.loopNextVideo(card)
        } else {
            self.delegate?.didSelectedSuggestion(card: card)
        }
    }
    
    func loopNextVideo(_ card:Card){
        self.showWatchPartyMenu = false
    
        //self.startAnimating1(#line, allowInteraction: false)
        
        var nowPlayingStatus : Bool = false
        for marker in card.display.markers {
            if marker.markerType == .special && marker.value == "now_playing" {
                nowPlayingStatus = true
                break;
            }
        }
        if nowPlayingStatus {
            self.stopAnimating1(#line)
            return;
        }
        self.endPollAndStreamSession(pollKey: self.streamResponse.sessionInfo.streamPollKey)
        if appContants.isEnabledAnalytics {
            logAnalytics.shared().closeSession(false)
        }

        let qosClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        backgroundQueue.async(execute: {
            OTTSdk.mediaCatalogManager.pageContent(path: card.target.path, onSuccess: { (response) in
                if appContants.appName != .reeldrama {
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.loadingImageFromUrl(card.display.imageUrl, category: "banner")
                    }
                }
                else {
                    self.defaultPlayingItemView.isHidden = true
                }
                
                
                self.playBtn?.tag = 1
                self.countdown = 10
                if self.sliderPlayer != nil {
                    self.sliderPlayer.value = 0
                }
                self.templateElement = nil

                self.pageDataResponse = response
                
                self.skipIntroStartTime = -1
                self.skipIntroEndTime = -1
                
                if self.pageDataResponse.info.attributes.introStartTime > 0 {
                    self.skipIntroStartTime = self.pageDataResponse.info.attributes.introStartTime
                }
                if self.pageDataResponse.info.attributes.introEndTime > 0 {
                    self.skipIntroEndTime = self.pageDataResponse.info.attributes.introEndTime
                }
                
                self.updateFavoriteButtonUI()
                self.updateRecordButtonImage()
                self.updateSliderForwardStatus()
                if self.player != nil && self.player.avplayer.currentItem != nil{
                    self.playitem = (self.player?.avplayer.currentItem!)!
                }
                self.playitem?.remove(self.output)
                self.pollEventType = 1
                let contentInformation = self.contentInformation()
                self.navTitleLable?.text = contentInformation.title
                self.navSubTitleLable?.text = contentInformation.subTitle
                self.navExpiryLable?.isHidden = (contentInformation.expiryDaysText.count > 0 ? false : true)

                self.navExpiryLable?.text = contentInformation.expiryDaysText
                self.navExpiryLable?.sizeToFit()
                self.navExpiryLabelWidthConstraint?.constant = self.navExpiryLable?.frame.size.width ?? 0 + 20.0
                self.navExpiryLable?.viewCornerDesignWithBorder(.red)
                self.navExpiryLable?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                print ("\(response.info.attributes.contentType)")

                self.minimizedViewTitleLbl?.text = contentInformation.title
                self.minimizedSubtitleLbl?.text = contentInformation.subTitle
                let imageUrl = ((contentInformation.imageUrl?.count ?? 0) > 0) ?  contentInformation.imageUrl! : contentInformation.logo
                self.navImageView?.loadingImageFromUrl(imageUrl, category: "")
                self.playingItemTargetPath = card.target.path
                self.pageData = self.pageDataResponse.data
                if self.tapGestureRecognizer != nil {
                    self.player?.view.removeGestureRecognizer(self.tapGestureRecognizer!)
                }
                if self.indicatorViewTapGestureRecognizer != nil {
                    self.playerIndicatorView?.removeGestureRecognizer(self.indicatorViewTapGestureRecognizer!)
                }
                if self.playerControlTapGestureRecognizer != nil {
                    self.playerControlsView?.removeGestureRecognizer(self.playerControlTapGestureRecognizer!)
                }
                self.currentVideoContent = card
                if self.sliderPlayer != nil {
                    self.sliderPlayer.oldValue = 0.0
//                    self.sliderPlayer.maxForwardValue = 0.0
                }
                self.getPlayerStreamContent(streamPin: "")
                self.resetLastChannelButtonWidthConstraint()
                self.updateSliderForwardStatus()

                self.nextContentButtonWidthConstraint?.constant = 0
                if self.nextContentButtonWidthConstraint?.constant == 0 {
                    self.lastChnlBtnLeadConstraint?.constant = 0
                }
                if self.lastChannelButtonWidthConstraint?.constant == 0 {
                    self.startOverBtnLeadConstraint?.constant = 0
                }
                if self.startOverOrGoLiveButtonWidthConstraint?.constant == 0 {
                    self.goLiveBtnLeadConstraint?.constant = 0
                }
                if self.pageDataResponse != nil && self.pageDataResponse.adUrlResponse.adUrlTypes.count > 0{
                    // Url to play
                    for b in self.pageDataResponse.adUrlResponse.adUrlTypes{
                        print("b:\(b.urlType.rawValue) and \(b.url)")
                        if b.urlType == .preUrl {
                            if !b.url.isEmpty{
                                self.adUrlToPlay = b.url
                                self.adTypeToPlay = "0"
                                DispatchQueue.main.async {
                                    self.watchedTime = ""
                                    self.requestAds()
                                }
                            }
                            break
                        }
                    }
                }
                
                self.nextContentButtonWidthConstraint?.constant = 0
                self.lastChnlBtnLeadConstraint?.constant = 0
                self.nextContentButton.isHidden = true
                
                if self.pageDataResponse.info.attributes.nextButtonTitle.count > 0 {
                    self.nextContentButton.setTitle(self.pageDataResponse.info.attributes.nextButtonTitle, for: UIControl.State.normal)
                    
                    let attributes = self.pageDataResponse.info.attributes
                    OTTSdk.mediaCatalogManager.nextVideoContent(path: self.pageDataResponse.info.path, offset: -1, count: 1, onSuccess: { (response) in
                        if response.data.count > 0 {
                            self.nextVideoContent = response.data.first
                            self.updateNextVideoMetaData(card: response.data.first,headerLabelText: self.pageDataResponse.info.attributes.recommendationText)
                            if self.pageDataResponse.info.attributes.showNextButton == "true" {
                                self.nextContentButtonWidthConstraint?.constant = 95
                                self.lastChnlBtnLeadConstraint?.constant = 10
                                //self.nextContentButton.isHidden = false
                            }
                        } else {
                            self.nextVideoContent = nil
                        }
                    }, onFailure: { (error) in
                        print(error.message)
                        self.nextVideoContent = nil
                        self.stopAnimating1(#line)
                    })
                }
                else {
                    self.nextVideoContent = nil
                }
            }) { (error) in
                self.stopAnimating1(#line)
                self.nextVideoContent = nil
                self.showAlertWithText(message: error.message, completion: { (buttonTitle) in
                })
            }
        })
    }
    func updateNextVideoMetaData(card : Card?, headerLabelText:String = "") {
        if self.nextVideoContent != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(3000)) {
                self.comingUpNextView.initiate(card: card,headerLabelText: headerLabelText)
            }
        }
    }
    func openShareView() {
        self.shareButtonClicked(sender: UIButton())
    }
    func StartParty() {
        self.showWatchPartyMenu = true
        self.loadPlayerSuggestions(loginViewStatus: false)
    }
    func hideSomePlayerControllers(status:Bool) {
        if self.playerControlsView != nil && self.slideView != nil && self.seekFwd != nil && self.seekBckwd !== nil {
            self.slideView.isHidden = status
            self.playerControlsView.isHidden = status
            if status == true {
                self.seekFwd.isHidden = status
            }
            else {
                if self.sliderPlayer != nil {
                    if self.sliderPlayer.disableFarwardSeek == false {
                        self.seekFwd.isHidden = self.isPreviewContent ? true : false
                    }
                    else {
//                         self.seekFwd.isHidden = self.sliderPlayer.value > self.sliderPlayer.maxForwardValue
                    }
                }
                else{
                    self.seekFwd.isHidden = status
                }
            }
            self.seekBckwd.isHidden = status
            if self.isGoLiveBtnAvailable {
                if self.goLiveBtn != nil {
                    self.goLiveBtn?.isHidden = status
                    if appContants.appName == .tsat || appContants.appName == .aastha {
                        if UIDevice.current.orientation.isLandscape || orientation().isLandscape || self.isFullscreen {
                            self.startOverOrGoLiveButton.isHidden = !self.goLiveBtn!.isHidden
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                        else {
                            self.startOverOrGoLiveButton.isHidden = true
                            self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                        }
                    }
                    else {
                    //MARK: as per client requirement startover button is not required
                    self.startOverOrGoLiveButton.isHidden = true
                    self.startOverOrGoLiveButtonWidthConstraint?.constant = self.startOverOrGoLiveButton.isHidden ? 0 : 95
                    }
                }
            }
        }
    }
    
     func checkForMidRollAds() {
            
            /*if self.player != nil {
                print("self.avplayer.isMuted : \(self.player.avplayer.isMuted)")
                print("self.player.avplayer.volume : \(self.player.avplayer.volume)")
            }*/
            if AppDelegate.getDelegate().showVideoAds {
                if self.pageDataResponse != nil && self.pageDataResponse.adUrlResponse.adUrlTypes.count > 0{
                    // Url to play
                    for b in self.pageDataResponse.adUrlResponse.adUrlTypes {
                        if b.urlType == .midUrl {
                            let maxCount = Int(b.position.maxCount) ?? 100
                            
                            if (!b.url.isEmpty && (adDisplayPostionsArray.count < maxCount)) {
                                if (Int(self.player.currentTime)) > 1 {
                                    if ((Int(self.watchedSeekPosition/1000)) + (Int(b.position.offset) ?? 0) - (Int(self.player.currentTime))) == 0 {
                                        if adDisplayPostionsArray.contains(Int(self.player.currentTime)) {
                                            print ("already ad displayed")
                                        }
                                        else {
                                            adDisplayPostionsArray.append(Int(self.player.currentTime))
                                            self.adUrlToPlay = b.url
                                            self.adTypeToPlay = "1"
                                            DispatchQueue.main.async {
                                                self.watchedTime = ""
                                                self.requestAds()
                                            }
                                        }
                                    }
                                    else{
                                        let adPositionInterVal = Int(self.player.currentTime) -  (Int(b.position.offset) ?? 0) - (Int(self.watchedSeekPosition/1000))
                                        print ("adPositionInterVal : \(adPositionInterVal)")
                                        if (adPositionInterVal > 1) {
                                            if (adPositionInterVal % (Int(b.position.interval) ?? 200)) == 0 {
                                                if adDisplayPostionsArray.contains(Int(self.player.currentTime)) {
                                                    print ("already ad displayed")
                                                }
                                                else {
                                                    adDisplayPostionsArray.append(Int(self.player.currentTime))
                                                    self.adUrlToPlay = b.url
                                                    self.adTypeToPlay = "1"
                                                    DispatchQueue.main.async {
                                                        self.watchedTime = ""
                                                        self.requestAds()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
        func checkForPostRollAds() -> Bool {
            if AppDelegate.getDelegate().showVideoAds {
                if self.pageDataResponse != nil && self.pageDataResponse.adUrlResponse.adUrlTypes.count > 0{
                    // Url to play
                    for b in self.pageDataResponse.adUrlResponse.adUrlTypes{
                        if b.urlType == .postUrl {
                            if !b.url.isEmpty {
                                if adDisplayPostionsArray.contains(Int(self.player.currentTime)) {
                                    print ("already ad displayed")
                                    return false
                                }
                                else {
                                    adDisplayPostionsArray.append(Int(self.player.currentTime))
                                    self.adUrlToPlay = b.url
                                    self.adTypeToPlay = "3"
                                    DispatchQueue.main.async {
                                        self.watchedTime = ""
                                        self.requestAds()
                                    }
                                    return true
                                }
                            }
                            break
                        }
                    }
                }
            }
            return false
        }

    //MARK: - Pip delegate methods
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        // Restore user interface
        print("Restore user interface")
        isPipRestored = true
        completionHandler(true)
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide playback controls
        // show placeholder artwork
        isPipRestored = false
        print("WillStartPictureInPicture")
    }

    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        // hide placeholder artwork
        // show playback controls
        print("DidStopPictureInPicture")
        
        if isPipRestored == false {
            self.pictureInPictureController.stopPictureInPicture()
            self.closePlayer()
        }
        
        
        
        
    }
    
    
    // MARK: - IMAAdsLoaderDelegate
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        
        adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self
        
        // Create ads rendering settings and tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
//        adsRenderingSettings.webOpenerPresentingController = self
        
        // Initialize the ads manager.
        adsManager?.initialize(with: adsRenderingSettings)
        if self.player != nil{
            self.isMidRollAdPlaying = true
            self.player.pause()
            if self.previewTimer != nil{
                self.previewTimer?.invalidate()
                self.previewTimer = nil
            }
        }
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        print("AdsManager Error loading ads: \(adErrorData.adError.message)")
        //        self.player?.playFromCurrentTime()
        //        self.startAnimating1(#line, allowInteraction: true)
//        if self.player != nil {
//           self.player.playFromCurrentTime()
//        }
         self.handlePlayerAfterAdEnd()
    }
    
    // MARK: - IMAAdsManagerDelegate
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("AdsManager event received")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audio error \(error)")
        }

        if event.type == IMAAdEventType.LOADED {
            // When the SDK notifies us that ads have been loaded, play them.
            self.isMidRollAdPlaying = true
            //if !popUpOnceArrived {
            adsManager.start()
            self.handleGestureAddRemove()
            // }
            if self.player != nil {
                self.player.pause()
            }
            if self.previewTimer != nil{
                self.previewTimer?.invalidate()
                self.previewTimer = nil
            }
        }
        else if event.type == IMAAdEventType.STARTED{
            logAnalytics.shared().triggerLogEvent(.trigger_ad_start, position: 0)
        }
        else if event.type == IMAAdEventType.PAUSE{
            adsManager.pause()
        }
        else if event.type == IMAAdEventType.RESUME{
            //self.player.playFromCurrentTime()
            adsManager.resume()
        }
        else if event.type == IMAAdEventType.ALL_ADS_COMPLETED ||
            event.type == IMAAdEventType.SKIPPED {
            
            if event.type == IMAAdEventType.SKIPPED {
                logAnalytics.shared().triggerLogEvent(.trigger_ad_skipped, position: 0)
            }
            else{
                logAnalytics.shared().triggerLogEvent(.trigger_ad_completed, position: 0)
            }
            self.isMidRollAdPlaying = false

            if !self.isPlayBackEnd {
                if self.watchedTime .isEmpty {
                    let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                    if (self.mediaInfo != nil) && hasConnectedCastSession() {
                        self.playSelectedItemRemotely()
                    } else {
                         //self.handlePlayerAfterAdEnd()
                    }
                } else {
                    if !self.popUpOnceArrived{
                        if self.player != nil {
                            self.player.pause()
                        }
                        //                        let message = String.init(format: "%@%@", "Would you like to continue from".localized,self.watchedTime)
                        //                        self.showContinueWatchingAlertWithText(message: message)
                        self.isAlertBtnClicked = true
                        self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                        self.handlePlayerAfterAdEnd()
                    } else {
                        if isAlertBtnClicked {
                            let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                            if (self.mediaInfo != nil) && hasConnectedCastSession() {
                                self.castSession?.remoteMediaClient?.loadMedia(self.mediaInfo, autoplay: true, playPosition: Double(Int(self.watchedSeekPosition/1000)))
                            } else {
                                self.player.seekToTime(CMTimeMake(value: Int64(Int(self.watchedSeekPosition/1000)), timescale: 1))
                                self.handlePlayerAfterAdEnd()
                            }
                        }
                    }
                }
            }
        }
    }
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        print("AdsManager error: \(error.message ?? "")")
        //        if self.player != nil{
        //            self.player?.playFromCurrentTime()
        //        }
        self.isMidRollAdPlaying = false
         self.handlePlayerAfterAdEnd()
            
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        if self.player != nil{
            self.player?.pause()
        }
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        //        if !self.isPlayBackEnd {
        //            self.player?.playFromCurrentTime()
        //        }
        self.isMidRollAdPlaying = false
         self.handlePlayerAfterAdEnd()
    }
    func handlePlayerAfterAdEnd() {
        if self.isPlayBackEnd == true {
            if self.startTime != nil {
                self.startTime.text = "00:00"
            }
            if self.playBtn != nil {
                self.playBtn?.isHidden = true
            }
            self.isPlayBackEnd = true
            if !self.isMinimized {
                hideControls = false
                showHideControllers()
            }
            testVal = 13
            if self.playBtn != nil {
                self.playBtn?.isHidden = false
                self.playBtn?.setImage(UIImage(named:"reply_icon"), for: .normal)
                self.playBtn?.tag = 2
            }
            if self.sliderPlayer != nil {
                self.sliderPlayer.isUserInteractionEnabled = false
            }
            if appContants.isEnabledAnalytics {
                logAnalytics.shared().closeSession(true)
            }
            if self.nextVideoContent != nil {
                if self.nextVideoCloseBtn != nil {
                    self.nextVideoCloseBtn.isHidden = false
                }
                self.playNextVideo()
            }
        }
        else {
            if self.previewSecondsRemaining > 0 {
                self.previewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.previewSecondsRemaining), target: self, selector: #selector(PlayerViewController.handlePreviewEnd), userInfo: nil, repeats: false)
            }
            if self.templateElement != nil {
                if (templateElement?.elementCode == "startover_live") && self.shouldSeekToStartOver{
                    self.shouldSeekToStartOver = false
                    self.startOverTap(nil)
                }
                else{
                    if self.player != nil {
                        self.player?.playFromCurrentTime()
                        self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:"miniPlayer-Pause"), for: .normal)
                        if self.playBtn != nil {
                            self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                        }
                    }
                }
            }
            else{
                if self.player != nil {
                    self.player?.playFromCurrentTime()
                    self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:"miniPlayer-Pause"), for: .normal)
                    if self.playBtn != nil {
                        self.playBtn?.setImage(UIImage(named:"pauseicon"), for: .normal)
                    }
                }
            }
        }
    }
    // MARK: - Remote Control
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == UIEvent.EventType.remoteControl {
            switch (event?.subtype)! {
                
            case .none:
                break;
                
            case .motionShake:
                break;
                
            case .remoteControlPause:
                self.player?.pause()
                break;
            case .remoteControlStop:
                break;
            case .remoteControlTogglePlayPause:
                if player.playbackState == .playing {
                    self.player?.pause()
                } else {
                    self.player?.playFromCurrentTime()
                }
                break;
            case .remoteControlNextTrack:
                break;
                
            case .remoteControlPreviousTrack:
                break;
                
            case .remoteControlBeginSeekingBackward:
                break;
                
            case .remoteControlEndSeekingBackward:
                break;
                
            case .remoteControlBeginSeekingForward:
                break;
                
            case .remoteControlEndSeekingForward:
                break;
                
            case .remoteControlPlay:
                self.player?.playFromCurrentTime()
                break;
            }
        }
    }

}

class AssetLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
    // MARK: Properties
    
    /**
     Your custom scheme name that indicates how to obtain the content
     key. This value is specified in the URI attribute in the EXT-X-KEY
     tag in the playlist.
     */
    static let URLScheme = "skd"
    
    /// The application certificate that is retrieved from the server.
    var fetchedCertificate: NSData?
    
    // MARK: Functions
    
    /**
     ADAPT: YOU MUST IMPLEMENT THIS METHOD.
     
     - returns: Content Key Context (CKC) message data specific to this request.
     */
    var ckcData: NSData? {
        return nil
    }
    
    /**
     ADAPT: YOU MUST IMPLEMENT THIS METHOD.
     
     Sends the SPC to a Key Server that contains your Key Security
     Module (KSM). The KSM decrypts the SPC and gets the requested
     CK from the Key Server. The KSM wraps the CK inside an encrypted
     Content Key Context (CKC) message, which it sends to the app.
     
     The application may use whatever transport forms and protocols
     it needs to send the SPC to the Key Server.
     
     - returns: The CKC from the server.
     */
    
    /*
     streamResponseDict contains certificate deatails for DRM
     */
    
    var playerInstance = PlayerResultModel()
    func contentKeyFromKeyServerModuleWithRequestData(requestBytes: NSData, assetString: String, expiryDuration: TimeInterval) throws -> NSData {
        
        let fplic = playerInstance.streams.defaultFairplayStream.licenseKeys.license
        let reqUrl = URL(string: "\(fplic)\(assetString)")!
        var request = URLRequest(url: reqUrl)
        request.httpMethod = "POST"
        request.httpBody = requestBytes as Data
        
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-type")
        var response: URLResponse? = nil
        print("Sending license request")
        let responseData = try? NSURLConnection.sendSynchronousRequest(request, returning: &response)
        /* let session = URLSession.shared
         session.dataTask(with: request) { (data, response, error) -> Void in
         
         }*/
        
        
        //            if responseData == nil{
        //                YLog.log("No license response, error=\(errorOut)")
        //                return nil
        //            }
        
        
        if responseData != nil{
            return responseData! as NSData
        }
        
        /*
         Otherwise, the CKC was not provided by key server. Fail with bogus error.
         Generate an error describing the failure.
         */
        
        throw NSError(domain: "com.example.apple-samplecode", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Item cannot be played.",
            NSLocalizedFailureReasonErrorKey: "Could not get the content key from the Key Server."
            ])
    }
    
    /**
     ADAPT: YOU MUST IMPLEMENT THIS METHOD:
     
     Get the application certificate from the server in DER format.
     */
    /*
     func fetchAppCertificateDataWithCompletionHandler(handler: (NSData?) -> Void) {
     
     /*
     This needs to be implemented to conform to your protocol with the backend/key security module.
     At a high level, this function gets the application certificate from the server in DER format.
     */
     //    certificate = [NSData  dataWithContentsOfURL:[NSURL URLWithString:DRM_CERTIFICATE]];
     
     //        let fpcer = playerInstance.streams.defaultStream.licenseKeys.certificate
     
     let fpcer = Bundle.main.path(forResource: "fairplay", ofType: "cer")!
     
     //        loaderDelegate.fetchedCertificate = NSData(contentsOfFile: certPath)
     // This needs to be implemented to conform to your protocol with the backend/key security module.
     // At a high level, this function gets the application certificate from the server in DER format.
     
     // If the server provided an application certificate, return it.
     //        let url = URL(string: "\(fpcer)fairplay.cer")
     let url = URL(string: fpcer)
     if url != nil{
     if let fetchedCertificate = NSData(contentsOf: url!) {
     handler(fetchedCertificate)
     }
     }
     else{
     print("Fairplay Certificate not found")
     }
     
     
     // Otherwise, failed to get application certificate from the server.
     
     fetchedCertificate = NSData(contentsOf: URL(string: fpcer)!)
     
     // If the server provided an application certificate, return it.
     handler(fetchedCertificate)
     }
     */
    func fetchAppCertificateDataWithCompletionHandler(handler: (NSData?) -> Void) {
        
        /*
         This needs to be implemented to conform to your protocol with the backend/key security module.
         At a high level, this function gets the application certificate from the server in DER format.
         */
        //    certificate = [NSData  dataWithContentsOfURL:[NSURL URLWithString:DRM_CERTIFICATE]];
        /*     let fpcer = self.streamResponseDict?["fpcer"] as! String
         
         //        let certPath = NSBundle.mainBundle().pathForResource("fairplay", ofType: "cer")!
         
         //        loaderDelegate.fetchedCertificate = NSData(contentsOfFile: certPath)
         // This needs to be implemented to conform to your protocol with the backend/key security module.
         // At a high level, this function gets the application certificate from the server in DER format.
         
         // If the server provided an application certificate, return it.
         let url = NSURL(string: "\(fpcer)fairplay.cer")
         if url != nil{
         if let fetchedCertificate = NSData(contentsOfURL: url!) {
         handler(fetchedCertificate)
         }
         }
         else{
         YLog.log("asdfsadfs")
         
         }
         
         */
        
       /* let path = Bundle.main.path(forResource: "Countries", ofType: "enc")!
        let passEncryptedData = NSData(contentsOfFile: path)
        let pass = "yupptvasdf"
        fetchedCertificate = try! RNOpenSSLDecryptor.decryptData(passEncryptedData as! Data, with: kRNCryptorAES256Settings, password: pass) as NSData?*/
        
        let path = Bundle.main.path(forResource: "Countries", ofType: "cer")!
        fetchedCertificate = NSData(contentsOfFile: path)
        
        // Otherwise, failed to get application certificate from the server.
        
        //        fetchedCertificate = NSData(contentsOfURL: NSURL(string: "\(fpcer)fairplay.cer")!)
        
        // If the server provided an application certificate, return it.
        handler(fetchedCertificate)
    }
    /*
     resourceLoader:shouldWaitForLoadingOfRequestedResource:
     
     When iOS asks the app to provide a CK, the app invokes
     the AVAssetResourceLoader delegate’s implementation of
     its -resourceLoader:shouldWaitForLoadingOfRequestedResource:
     method. This method provides the delegate with an instance
     of AVAssetResourceLoadingRequest, which accesses the
     underlying NSURLRequest for the requested resource together
     with support for responding to the request.
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        // Get the URL request object for the requested resource.
        
        /*
         Your URI scheme must be a non-standard scheme for AVFoundation to invoke your
         AVAssetResourceLoader delegate for help in loading it.
         */
        let url = loadingRequest.request.url
        guard url?.scheme == AssetLoaderDelegate.URLScheme else {
            print("URI scheme name does not match our scheme.")
            return false
        }
        // Get the URI for the content key.
        var assetString = url?.path
        assetString = assetString?.replacingOccurrences(of: "/;", with: "")
        if assetString?.count == 0 {
            assetString = "DummmyLicense"
        }
        guard let assetID = assetString?.data(using: String.Encoding.utf8) else {
            return false
        }
        
        // Get the application certificate from the server.
        guard let fetchedCertificate = fetchedCertificate else {
            print("Failed to get Application Certificate from key server.")
            return false
        }
        
        do {
            // MARK: ADAPT: YOU MUST CALL: `streamingContentKeyRequestDataForApp(_:options:)`
            
            /*
             ADAPT: YOU MUST CALL : `streamingContentKeyRequestDataForApp(_:options:)`.
             to obtain the SPC message from iOS to send to the Key Server.
             */
            let requestedBytes = try loadingRequest.streamingContentKeyRequestData(forApp: fetchedCertificate as Data, contentIdentifier: assetID, options: nil)
            
            let expiryDuration: TimeInterval = 0.0
            
            let responseData = try contentKeyFromKeyServerModuleWithRequestData(requestBytes: requestedBytes as NSData, assetString: assetString!, expiryDuration: expiryDuration)
            
            guard let dataRequest = loadingRequest.dataRequest else {
                
                print("Failed to get instance of AVAssetResourceLoadingDataRequest (loadingRequest.dataRequest).")
                
                return false
            }
            
            /*
             The Key Server returns the CK inside an encrypted Content Key Context (CKC) message in response to
             the app’s SPC message.  This CKC message, containing the CK, was constructed from the SPC by a
             Key Security Module in the Key Server’s software.
             */
            
            // Provide the CKC message (containing the CK) to the loading request.
            dataRequest.respond(with: responseData as Data)
            
            // Get the CK expiration time from the CKC. This is used to enforce the expiration of the CK.
            let infoRequest = loadingRequest.contentInformationRequest
            if expiryDuration != 0.0 {
                /*
                 Set the date at which a renewal should be triggered.
                 Before you finish loading an AVAssetResourceLoadingRequest, if the resource
                 is prone to expiry you should set the value of this property to the date at
                 which a renewal should be triggered. This value should be set sufficiently
                 early enough to allow an AVAssetResourceRenewalRequest, delivered to your
                 delegate via -resourceLoader:shouldWaitForRenewalOfRequestedResource:, to
                 finish before the actual expiry time. Otherwise media playback may fail.
                 */
                infoRequest?.renewalDate = Date(timeIntervalSinceNow: expiryDuration)
                
                infoRequest?.contentType = "application/octet-stream"
                infoRequest?.contentLength = Int64(responseData.length)
                infoRequest?.isByteRangeAccessSupported = false
            }
            
            // Treat the processing of the requested resource as complete.
            loadingRequest.finishLoading()
            
            // The resource request has been handled regardless of whether the server returned an error.
            return true
            
        } catch let error as NSError {
            // Resource loading failed with an error.
            
            print("streamingContentKeyRequestDataForApp failure: \(error.localizedDescription)")
            loadingRequest.finishLoading(with: error)
            return false
        }
    }
    
    
    /*
     resourceLoader: shouldWaitForRenewalOfRequestedResource:
     
     Delegates receive this message when assistance is required of the application
     to renew a resource previously loaded by
     resourceLoader:shouldWaitForLoadingOfRequestedResource:. For example, this
     method is invoked to renew decryption keys that require renewal, as indicated
     in a response to a prior invocation of
     resourceLoader:shouldWaitForLoadingOfRequestedResource:. If the result is
     YES, the resource loader expects invocation, either subsequently or
     immediately, of either -[AVAssetResourceRenewalRequest finishLoading] or
     -[AVAssetResourceRenewalRequest finishLoadingWithError:]. If you intend to
     finish loading the resource after your handling of this message returns, you
     must retain the instance of AVAssetResourceRenewalRequest until after loading
     is finished. If the result is NO, the resource loader treats the loading of
     the resource as having failed. Note that if the delegate's implementation of
     -resourceLoader:shouldWaitForRenewalOfRequestedResource: returns YES without
     finishing the loading request immediately, it may be invoked again with
     another loading request before the prior request is finished; therefore in
     such cases the delegate should be prepared to manage multiple loading
     requests.
     */
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        return self.resourceLoader(resourceLoader, shouldWaitForRenewalOfRequestedResource: renewalRequest)
    }
}
/*
extension PlayerViewController {
    func setupGesture(){
        self.playerHolderView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleVolumeBrightnessGesture)))
    }

      @objc func handleVolumeBrightnessGesture(gesture: UIPanGestureRecognizer){
        let gesVelocity = gesture.velocity(in: playerHolderView)
        if abs(gesVelocity.y) < abs(gesVelocity.x) {
             if gesture.state == .ended {
                 pvViewMain.isHidden = true

            }
            return
        }
        if gesture.state == .began {
            panStartLocation = gesture.location(in: self.playerHolderView)
            if panStartLocation.x < self.playerHolderView.frame.width / 2 {
                // Brightness control
                pv.progressTintColor =  UIColor.init(red: 0.0/255.0, green: 173.0/255.0, blue: 80.0/255.0, alpha: 1.0)
                imgIcon.image = #imageLiteral(resourceName: "brightness_icon")
                isBrightnessChanging = true
                isVolumeChanging = false
                // Set brightness when value is changed at Contol Center
                pvViewMain.isHidden = !isBrightnessChanging

                pv.progress = Float(UIScreen.main.brightness)
            }else{
                // Volume control
                pv.progressTintColor =  UIColor.init(red: 76.0/255.0, green: 157.0/255.0, blue: 237.0/255.0, alpha: 1.0)
                imgIcon.image = #imageLiteral(resourceName: "volume_up-icon")
                isBrightnessChanging = false
                pvViewMain.isHidden = !isBrightnessChanging

                isVolumeChanging = true
                pvViewMain.isHidden = !isVolumeChanging

                guard let systemVolueViewSlider = self.systemVolumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {return}
                pv.progress = systemVolueViewSlider.value

            }

        }else if gesture.state == .changed {
                  panCount += 1
                  // % TOO MANY NOTIFICATION %
                  guard let systemVolueViewSlider = self.systemVolumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {return}

                  let velocity = gesture.velocity(in: self.playerHolderView)
                  // Volume control
                  if panCount % 2 == 0 {
                      if isVolumeChanging {
                          if velocity.y < 0 {
                              systemVolueViewSlider.value += 0.02
                              pv.progress = systemVolueViewSlider.value

                          }else if velocity.y > 0 {
                              systemVolueViewSlider.value -= 0.02
                              pv.progress = systemVolueViewSlider.value

                          }
                      }
                      if isBrightnessChanging {
                          if velocity.y < 0 {
                              UIScreen.main.brightness  += CGFloat(0.03)
                              pv.progress = Float(UIScreen.main.brightness)

                          }else if velocity.y > 0 {
                              UIScreen.main.brightness  -= CGFloat(0.03)
                              pv.progress = Float(UIScreen.main.brightness)

                          }
                      }
                      panCount = 0
                  }
                  
              }else if gesture.state == .ended {
                  if isVolumeChanging {
                      isVolumeChanging = false
                      pvViewMain.isHidden = !isVolumeChanging

                  }
                  if isBrightnessChanging {
                      isBrightnessChanging = false
                      pvViewMain.isHidden = !isVolumeChanging

                  }
              }
        
      }
    
    
       @objc func volumeChanged(notification: Notification){
           
           if let volume = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float {
               currentOutputVolume = volume // 0.0 ~ 1.0
           }
    
       }


}

*/
extension PlayerViewController : UITextFieldDelegate {
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
