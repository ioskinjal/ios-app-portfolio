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

enum PlaybackMode : Int {
    case none = 0
    case local
    case remote
}
class PlayerViewController: UIViewController, PlayerDelegate,UIGestureRecognizerDelegate,BitRateProtocol {

    
    
    @IBOutlet weak var navViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    
    
    
    @IBOutlet weak var playerHolderHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var playerHolderView: UIView!
    @IBOutlet weak var sliderPlayer: UISlider!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mQualityButton: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var seekFwd: UIButton!
    @IBOutlet weak var seekBckwd: UIButton!
    
    let pageString = "TVSHOWS"
    var episodeObj :Episode!
    var videoUrlString:String!
    var videoUrlString_ChromeCast:String!
    
    var isPlayerAddedToView : Bool = false
    var showControls: Bool = false
    var isSeeking: Bool = false
    var myTimer: Timer? = nil
    var connectivityTimer: Timer? = nil
    var testVal: Int = 1
    private var player: Player!
    var playerObserver:AnyObject!
    var currentTime:String = "00:00"
    
    var bitRates = NSMutableArray()
    
    let playerInstance = PlayerResultModel()
    var loaderDelegate = AssetLoaderDelegate()
    var _playBackMode = PlaybackMode(rawValue: 0)
    
    
    var seekStartValue:Int!
    var seekEndValue:Int!
    
    
    let
    resourceRequestDispatchQueue = DispatchQueue(label: "com.example.apple-samplecode.resourcerequests")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.episodeObj != nil{
            didStartDisplay()
        }
    }
    func didStartDisplay()  {
        //#warning
        if self.episodeObj != nil{
            self.getPlayerStreamContent()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
        if fromInterfaceOrientation == .portrait {
            self.playerHolderView.frame = UIScreen.main.bounds
            print(UIScreen.main.bounds)
             self.playerHolderHeightConstraint.constant = UIScreen.main.bounds.height
            self.view.bringSubview(toFront: self.playerHolderView)
            self.view.bringSubview(toFront: self.navView)
        }else{
            self.playerHolderHeightConstraint.constant = 260
//            self.navViewHeightConstraint.constant = 80
            self.view.bringSubview(toFront: self.navView)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.stopAnimating()
        if self.player != nil {
            self.player.pause()
        }
        self.removeObserver()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func seekFwdAction(_ sender: AnyObject) {
        var seconds : Int64 = Int64(sliderPlayer.value)
        if seconds > 0 {
            seconds = seconds + 10
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            if self.player != nil {
                if !self.player.maximumDuration.isLess(than: Double(seconds))
                {
                    self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
                    currentTime = self.startTime.text!
                    self.startAnimating(allowInteraction: true)
                    seekEndValue = Int(seconds)
//                    self.getLogAnalyticsEventDict(eventType: PlayerEventType.SEEKING)
//                    if lastEvent != PlayerEventType.BUFFER_START {
//                        printLog(log: "lastEvent:2- \(player.bufferingState)" as AnyObject)
//                        self.getLogAnalyticsEventDict(eventType: PlayerEventType.BUFFER_START)
//                    }
//                    if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
//                        castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
//                        if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
//                            castSession.remoteMediaClient?.play()
//                            self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
//                        }
//                        if self.player.avplayer.isExternalPlaybackActive {
//                            self.player!.seekToTime(targetTime)
//                        }
//                    } else {
                        self.player!.seekToTime(targetTime)
//                    }
                }
                else {
                    if Int64(sliderPlayer.value) == 0 {
                        self.startTime.text = "00:00"
                    }
                    self.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func seekBackAction(_ sender: AnyObject) {
        var seconds : Int64 = Int64(sliderPlayer.value)
        if seconds > 0 && seconds > 10{
            seconds = seconds - 10
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            
            self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
            currentTime = self.startTime.text!
            self.startAnimating(allowInteraction: true)
            seekEndValue = Int(seconds)
           /* self.getLogAnalyticsEventDict(eventType: PlayerEventType.SEEKING)
            if lastEvent != PlayerEventType.BUFFER_START {
                printLog(log: "lastEvent:2- \(player.bufferingState)" as AnyObject)
                self.getLogAnalyticsEventDict(eventType: PlayerEventType.BUFFER_START)
            }
            if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
                castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
                if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                    castSession.remoteMediaClient?.play()
                    self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
                }
                if self.player.avplayer.isExternalPlaybackActive {
                    self.player!.seekToTime(targetTime)
                }
            } else {
 */
                self.player!.seekToTime(targetTime)
//            }
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
                self.player.asset = newAsset
                self.playerItem = AVPlayerItem(asset: newAsset)
                
                //                self.addObservers()
                /* self.convivaSession?.attachStreamer(self.player)*/
                
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
                if let playlistURL = NSURL(string: playerInstance.streams.defaultFairplayStream.url) {
                    let asset = AVURLAsset(url: playlistURL as URL, options: .none)
                    self.asset = asset
                    if self.player.playbackState == .playing {
                        self.player.pause()
                    }
                    self.player.setupPlayerItem(nil)
                    self.player.setupAsset(asset)
                }
            }
        }
        else{
            if let playlistURL = NSURL(string: playerInstance.streams.defaultStream.url) {
                
                if self.player.playbackState == .playing {
                    self.player.pause()
                }
                self.player.setupPlayerItem(nil)
                let asset = AVURLAsset(url: playlistURL as URL, options: .none)
                self.player.setupAsset(asset)
                
            }
        }
        
        
    }
    
    
    func getPlayerStreamContent() {
//        let encIV = "9EHYACllZ_tnn2Vw"
//        let keychain = KeychainSwift()
//        let key = keychain.get("SERVER")
        
        if pageString == "TVSHOWS" {
            
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            
            let showid   = self.episodeObj.tvShowId
            let epiId  = self.episodeObj.episodeId
            
           self.startAnimating(allowInteraction: false)
            
            YuppTVSDK.mediaCatalogManager.episodeStream(tvshowId: showid, episodeId: epiId, onSuccess: { (response) in
                print(response)
                self.stopAnimating()
                // self.playerInstance.contentType = ContentType.tvShow
                
                
                let streamsArray = response
                
                self.playerInstance.contentType = ContentType.tvShow
                
                for streamResponse in streamsArray{
                    var streamings = StreamResult()
                    streamings.sType =  streamResponse.sType
                    streamings.url =  streamResponse.url
                    let isDefault = streamResponse.isDefault
                    streamings.isDefault = isDefault
                    
                    streamings.licenseKeys.certificate = streamResponse.licenseKeys.certificate
                    streamings.licenseKeys.license = streamResponse.licenseKeys.license
                    
                    //#warning to test DRM --------------------------------
                    //                            stream.url = "http://od1.mpd.yuppcdn.net/mpd/yuppflix/tamil/chennaiwatermark/fairplay/eX82iTRkJgZG1x1E.m3u8?hdnea=ip=121.244.63.137~st=1486371401~exp=1486373201~acl=*~data=504672_yuppFlix~hmac=816da89fb0066a9da50847fc1f550ef900d0f10f9cdb3e2b9d31db9a457922fc"
                    //                            stream.licenseKeys.certificate = "http://static.aka.yupp.yuppcdn.net/staticstorage/jwplayer/jw_7_6_1/"
                    //                            stream.licenseKeys.license = "http://fps.ezdrm.com/api/licenses/"
                    //--------------------------------------------------
                    
                    if streamings.sType == "fairplay"{
                        self.playerInstance.streams.defaultFairplayStream = streamings
                    }else{
                        self.playerInstance.streams.defaultStream = streamings
                    }
                    self.playerInstance.streams.allStreams.append(streamings)
                }
                
                
                
                
                let predicate2 = NSPredicate(format: "SELF.sType = %@ OR SELF.sType = %@", "hls","fairplay")
                let filteredarr = streamsArray.filter { predicate2.evaluate(with: $0) };
                var urlString:String = ""
                if filteredarr.count > 0
                {
                    let dict = filteredarr[0]
                    self.printLog(log:dict)
                    urlString = dict.url
                    
                }
                let predicate_cc = NSPredicate(format: "sType = 'mpd'")
                let filteredarr_cc = streamsArray.filter { predicate_cc.evaluate(with: $0) };
                if filteredarr_cc.count > 0
                {
                    let dict_cc = filteredarr_cc[0]
                    self.printLog(log:dict_cc)
                    self.videoUrlString_ChromeCast = dict_cc.url
                } else {
                    self.videoUrlString_ChromeCast = urlString
                }
                
                self.loadVideo(urlString: urlString)
                
                
                
                
            
            })
            { (error) in
                self.stopAnimating()
                print(error.message)
                
                let messageString = error.message
                
                let alert = UIAlertController(title: "YuppTV", message: messageString, preferredStyle: UIAlertControllerStyle.alert)
                    let errorCode = error.code
                    if errorCode == 402 {
                        
                        let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            
                            //self.payForMovie(episodeItem:self.episodeObj)
                            //                            AppDelegate.getDelegate().checkIn_AppProductDetails(movieid: showid, navControllerName: "TVShowsVC", nav: self.navigationController!, showType: "TVSHOWS")
                        })
                        alert.addAction(messageAlertAction)
                    }
                    else  if errorCode == 401
                    {
                        let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            //                            AppDelegate.getDelegate().viewControllerName = "TVShowsVC"
                            //                            AppDelegate.getDelegate().loadSignInPage(nav: self.navigationController!)
                        })
                        alert.addAction(messageAlertAction)
                    }
                    else if errorCode == -14 {
                        let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            if YuppTVSDK.preferenceManager.user?.mobile .isEmpty == true{
                                
                                let verifyMobileView = storyBoard.instantiateViewController(withIdentifier: "VerifyMobileVC") as! VerifyMobileVC
                                verifyMobileView.viewControllerName = "TVShowsVC"
                                self.navigationController?.isNavigationBarHidden = true
                                self.navigationController?.pushViewController(verifyMobileView, animated: true)
                            }
                                
                            else if YuppTVSDK.preferenceManager.user?.mobile .isEmpty == false {
                                //OTP Page
                                
                                let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                                otpVC.mobileNumber = YuppTVSDK.preferenceManager.user?.mobile
                                otpVC.otpSent = false
                                otpVC.isSubscribing = true
                                otpVC.viewControllerName = "TVShowsVC"
                                
                                otpVC.navigationController?.isNavigationBarHidden = true
                                self.navigationController?.pushViewController(otpVC, animated: true)
                            }
                        })
                        alert.addAction(messageAlertAction)
                    }
                    else
                    {
                        let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        alert.addAction(messageAlertAction)
                    }
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
        }else{
            
        }
    }
    
    func loadVideo(urlString:String) {
        //            printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
       
        if isPlayerAddedToView {
            let videoUrl = URL(string: urlString)
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            
            self.getBitRate(from: videoUrl!)
            
            self.player.setUrl(videoUrl!)
            self.play()
            return
        }
        if self.player != nil {
            self.removeObserver()
            self.player = nil
        }
        
        
        videoUrlString = urlString
        printLog(log: "videoUrlString: \(urlString)" as AnyObject?)
        
        let thumbImageNormal = UIImage(named: "player_scrubicon")  // normal state image (untouched)
        sliderPlayer.setThumbImage(thumbImageNormal, for: .normal)
        
         let thumbImageHighlighted = UIImage(named: "player_scrubicon") // press down image
         sliderPlayer.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        if let trackLeftImage = UIImage(named: "scrubber_primary") { //this is the selected area (blue) on the left side of the slider
            let trackLeftResizable =
                trackLeftImage.resizableImage(withCapInsets: insets)
            sliderPlayer.setMinimumTrackImage(trackLeftResizable, for: .normal)
        }
    
        if let trackRightImage = UIImage(named: "scrubber_track") { // and the right side, unselected area, grey
            let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
            sliderPlayer.setMaximumTrackImage(trackRightResizable, for: .normal)
        }
        
        
        
        self.view.autoresizingMask = ([UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight])
        
        self.player = Player()
        self.player.delegate = self
        self.printLog(log:self.view.bounds as AnyObject?)
        
        self.player.view.frame = self.playerHolderView.bounds
        self.player.view.autoresizesSubviews = true
        
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChangeEnd(_:)), for: .touchUpInside)
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChangeEnd(_:)), for: .touchUpOutside)
        sliderPlayer.addTarget(self, action: #selector(PlayerViewController.sliderValueDidChange(_:)), for: .valueChanged)
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
        
        playBtn.setImage(UIImage(named:"playicon"), for: .normal)
        playBtn.center = self.view.center
        playBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.playBtn.tag = 1
        
//        self.movieTvName.text = self.movieName
//        self.movieTvYear.text = self.movieYear
        
        
//        let castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(54), height: CGFloat(44)))
//        castButton.tintColor = UIColor.white
//        
//        let myVolumeView = MPVolumeView(frame: CGRect(x: castButton.frame.size.width + 5.0, y: castButton.frame.origin.y, width: CGFloat(54), height: CGFloat(44)))
//        myVolumeView.showsVolumeSlider = false
//        
//        self.airPlayView.addSubview(castButton)
//        self.airPlayView.addSubview(myVolumeView)
        
        self.player.avplayer.allowsExternalPlayback = true
        
        self.startAnimating(allowInteraction: false)
        self.startTime.text = "00:00"
        
        self.playerObserver = self.player.avplayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
//            if self.showReplayButton == true || self.playBtn.tag == 2 {
//                return
//            }
            //                self.printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
            if self.player.avplayer.currentItem?.status == .readyToPlay {
                //                self.player.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                //                                   options: NSKeyValueObservingOptions.new, context: self.playbackLikelyToKeepUpContext)
                
                let duration: Int = Int(self.player.maximumDuration)
                self.view.isUserInteractionEnabled = true
                if self.player.avplayer.isExternalPlaybackActive {
                    let duration : CMTime = CMTimeMake(Int64(self.player.maximumDuration), 1)
                    let seconds : Float64 = CMTimeGetSeconds(duration)
                    self.sliderPlayer.maximumValue = Float(seconds)
                } else {
                   /* let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
                    if (self.mediaInfo != nil) && hasConnectedCastSession() && (self.player.playbackState.rawValue == PlaybackState.paused.rawValue || self.player.playbackState.rawValue == PlaybackState.playing.rawValue) {
                        self.player.pause()
                    }
                     */
                }
                
                let minValue: Int = Int(self.sliderPlayer.minimumValue)
                let maxValue: Int = Int(self.sliderPlayer.maximumValue)
                let time: Float64 = self.player.currentTime
//
                if self.isSeeking == false {
                    self.sliderPlayer.value = Float(Int((maxValue - minValue) * Int(time) / duration + minValue))
                    self.printLog(log:"sliderPlayer value:\(self.sliderPlayer.value)" as AnyObject?)
                }
//
                if (self.player.playbackState.rawValue == PlaybackState.playing.rawValue) && self.sliderPlayer.isHidden == false && self.showControls == false{
                    self.testVal = 1
                    self.showControls = true
                    self.myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers(show:)), userInfo: nil, repeats: false)
                }
                
                if self.currentTime != self.startTime.text! {
                    self.stopAnimating()
                }
                self.playBtn.isHidden = false
                self.seekFwd.isHidden = false
                self.seekBckwd.isHidden = false
//                self.airPlayActiveViewSub.center = self.playBtn.center
            }
            } as AnyObject!
        
        if !self.isPlayerAddedToView {
            self.addChildViewController(self.player)
            
            self.playerHolderView.addSubview(self.player.view)
            self.playerHolderView.sendSubview(toBack: self.player.view)
            self.player.view.autoresizingMask = ([UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight])
            self.player.didMove(toParentViewController: self)
            
            let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.player.view.addGestureRecognizer(tapGestureRecognizer)
//            self.player.view.addSubview(brightnessimage)
//            self.player.view.addGestureRecognizer(panGesture)
//            brightnessimage.center = self.view.center
            self.player.fillMode = "AVLayerVideoGravityResizeAspect"
            
            
            self.view.bringSubview(toFront:sliderPlayer)
            
            testVal = 2
            self.isPlayerAddedToView = true
        }
        let videoUrl = URL(string: urlString)
        
        if videoUrl != nil {
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            self.getBitRate(from: videoUrl!)
            //3 // self.player.setUrl(videoUrl!)
            
            self.play()
            self.player.playbackLoops = false
            self._playBackMode = .local
            
//            self.perform(#selector(PlayerVC.showHideControllers(show:)), with: NSNumber.init(value: true), afterDelay: 5)
        }
        else{
            self.stopAnimating()
            self.showAlertWithText(message: "Failed to load Video")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func removeObserver() -> Void {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if (self.playerObserver != nil) {
            self.player.avplayer.removeTimeObserver(self.playerObserver)
            self.playerObserver = nil
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }

 // MARK: - getBitRate
    func bitRateSelected(selected: String) {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        let playitem:AVPlayerItem = self.player.avplayer.currentItem!
        let bitRateValue = Double(selected)!
        playitem.preferredPeakBitRate = floor(bitRateValue*1024)
    }
    func getBitRate(from urlToParse: URL) {
       
        self.bitRates.removeAllObjects()
//        bitRateSwithing = false
        if (urlToParse.absoluteString as NSString).range(of: ".m3u8", options: .caseInsensitive).location == NSNotFound {
            // for mp4 links
            self.mQualityButton.alpha = 0
            self.mQualityButton.isHidden = true
            return
        }
       // self.mediaInfo = GCKMediaInformation()
        UserDefaults.standard.removeObject(forKey: "channelQuality")
        UserDefaults.standard.synchronize()
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
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
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
        }
        
        // first, separate by new line
        let allLinedStrings = fileContents.components(separatedBy: CharacterSet.newlines)
        for strsInOneLine: String in allLinedStrings {
            // then break down even further
            if (strsInOneLine as NSString).range(of: "BANDWIDTH", options: .caseInsensitive).location != NSNotFound {
                let singleStrs = strsInOneLine.components(separatedBy: ",")
                var bandWidthStr = ""
                for chkBW: String in singleStrs {
                    if (chkBW as NSString).range(of: "BANDWIDTH", options: .caseInsensitive).location != NSNotFound {
                        bandWidthStr = chkBW
                    }
                }
                let bitRateT = bandWidthStr.replacingOccurrences(of: "BANDWIDTH=", with: "")
                if Double(bitRateT) != nil {
                    let bitRate: Double = Double(bitRateT)! / 1024
                    //                let convertedBitRate = NSNumber.init(integerLiteral: Int(bitRate))
                    if !bitRates.contains("\(bitRate)") {
                        bitRates.add("\(bitRate)")
                    }
                }
            }
        }
        if bitRates.count > 1 {
            self.mQualityButton.alpha = 1
            self.mQualityButton.isHidden = false
        }
        else {
            self.mQualityButton.alpha = 0
            self.mQualityButton.isHidden = true
        }
    }
    
    // MARK: - UIGestureRecognizer
    
    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer?) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        if self.myTimer != nil{
            self.myTimer?.invalidate()
            self.myTimer = nil
//            showControls = false
        }
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            if !showControls {
                if !self.sliderPlayer.isHidden {
                    showControls = true
                    testVal = 6
                    showHideControllers(show: false)
                }
            }
            else {
                if self.sliderPlayer.isHidden {
                    showControls = false
                    testVal = 7
                    showHideControllers(show: true)
                }
            }
            
            break
        case PlaybackState.paused.rawValue:
            if !showControls {
                if !self.sliderPlayer.isHidden {
                    showControls = true
                    testVal = 8
                    showHideControllers(show: false)
                }
            }
            else {
                if self.sliderPlayer.isHidden {
                    showControls = false
                    testVal = 9
                    showHideControllers(show: true)
                }
            }
            break
        case PlaybackState.playing.rawValue:
//        if !showControls {
            if !self.sliderPlayer.isHidden {
                showControls = true
                testVal = 10
                showHideControllers(show: false)
            }
//        }
        else {
                if self.sliderPlayer.isHidden {
                    showControls = false
                    testVal = 11
                    showHideControllers(show: true)
                    showControls = true
                    testVal = 12
                    myTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlayerViewController.showHideControllers(show:)), userInfo: nil, repeats: false)
                }
            }
        case PlaybackState.failed.rawValue:
            self.player.pause()
            self.playBtn.setImage(UIImage(named:"playicon"), for: .normal)
        default:
            self.player.pause()
            self.playBtn.setImage(UIImage(named:"playicon"), for: .normal)
        }
    }
    

    
    
    // MARK: - PlayerDelegate
   
    func playerReady(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        
//        if self.showReplayButton == true || self.playBtn.tag == 2 {
//            return
//        }
        let duration : CMTime = CMTimeMake(Int64(self.player.maximumDuration), 1)
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        sliderPlayer.maximumValue = Float(seconds)
        self.printLog(log:"sliderPlayer.minimumValue:-\(sliderPlayer.minimumValue)" as AnyObject?)
        self.printLog(log:"sliderPlayer.maximumValue:-\(sliderPlayer.maximumValue)" as AnyObject?)
//        if self.continueAfterPlayButtonClicked() || self.player.avplayer.isExternalPlaybackActive {
//            if castTargetTime != kCMTimeInvalid {
//                self.player.seekToTime(castTargetTime)
//                castTargetTime = kCMTimeInvalid
//                self.player.playFromCurrentTime()
//            }  else {
//                if self.isFromContinueWatching {
//                    self.isAlertBtnClicked = false
//                    let presentWatchedTime : Int64 = Int64(self.continueWatchingCurrentTime)
//                    let message = String.init(format: "%@%@", "Would you like to continue from ",self.getContinueWathingTime(seconds: Int(presentWatchedTime)))
//                    self.showContinueWatchingAlertWithText(message: message)
//                    self.player.pause()
//                }
//                else {
                    self.player.playFromBeginning()
//                }
//            }
//        }
        
        self.stopAnimating()
        self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
    }
    
    func playerPlaybackStateDidChange(_ playeraa: Player) {
       self.printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.printLog(log: "playeraa.avplayer.currentItem?.status: \(String(describing: playeraa.avplayer.currentItem?.status.rawValue))" as AnyObject?)
        self.printLog(log: "playeraa.playbackState.rawValue: \(playeraa.playbackState.rawValue)" as AnyObject?)
//        printLog(log: "self.showReplayButton 1: \(self.showReplayButton) self.playBtn.tag: \(self.playBtn.tag)" as AnyObject?)
        if !Utilities.hasConnectivity() {
//            if self.connectivityTimer != nil{
//                self.connectivityTimer?.invalidate()
//                self.connectivityTimer = nil
//            }
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
        }
//        if self.showReplayButton == true || self.playBtn.tag == 2 {
//            self.removeObserver()
//            return
//        }
        if playeraa.playbackState.rawValue == PlaybackState.failed.rawValue{
            self.stopAnimating()
            if !Utilities.hasConnectivity() {
//                if self.connectivityTimer != nil{
//                    self.connectivityTimer?.invalidate()
//                    self.connectivityTimer = nil
//                }
               self.stopAnimating()
                self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            }
            else {
                self.showAlertWithText(message: "Failed to load Video")
            }
        }
        if playeraa.playbackState.rawValue == PlaybackState.playing.rawValue {
            isSeeking = false
//            isPlayingActual = false
        }
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
//        if self.showReplayButton == true || self.playBtn.tag == 2 {
//            self.removeObserver()
//            return
//        }
        if self.playerObserver == nil {
            self.startAnimating(allowInteraction: true)
        }
        self.player.pause()
//        if self.isFromContinueWatching {
//            if isAlertBtnClicked {
//                self.player.playFromCurrentTime()
//            }
//        }
//        else{
            self.player.playFromCurrentTime()
//        }
        self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
                    self.playBtn.isHidden = true
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.startTime.text = "00:00"
        self.playBtn.isHidden = true
        showControls = false
        testVal = 13
        showHideControllers(show: false)
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
                    self.playBtn.isHidden = false
                    self.playBtn.setImage(UIImage(named:"reply_icon"), for: .normal)
                    self.playBtn.tag = 2
                }
            }
            else {
                self.recommendedMoviesList()
            }
        }*/
 
    }
    
    func playerCurrentTimeDidChange(_ player: Player) {
        if _playBackMode == .remote {
           /* if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected && castMediaController.lastKnownStreamPosition.isFinite{
                self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(castMediaController.lastKnownStreamPosition)))"
                if isSeeking == false {
                    self.sliderPlayer.value = Float(Int(castMediaController.lastKnownStreamPosition))
                }
            }*/
            if self.player != nil {
                if self.player.avplayer.isExternalPlaybackActive {
//                    self.airPlayActiveView.isHidden = false
//                    self.airPlayActiveViewSub.isHidden = false
                }
            }
        } else {
         
            if currentTime != self.startTime.text! {
                self.stopAnimating()
            }
            if self.player != nil {
                if self.player.avplayer.isExternalPlaybackActive {
//                    self.airPlayActiveView.isHidden = false
//                    self.airPlayActiveViewSub.isHidden = false
                    testVal = 14
                    showHideControllers(show: false)
                    
                } else {
//                    self.airPlayActiveView.isHidden = true
//                    self.airPlayActiveViewSub.isHidden = true
                }
                
            }
            if isSeeking == false {
//                if isPlayingActual == false {
//                    isPlayingActual = true
//                }
//                else {
                    if  player.currentTime.isFinite {
                        self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(player.currentTime)))"
                    }
//                }
            }
            if  player.maximumDuration.isFinite {
                self.endTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(player.maximumDuration)))"
            }
        }
    }
    
    func playerWillComeThroughLoop(_ player: Player) {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        
    }
    
    // MARK:  - Custom
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
    // MARK: -  printLog
    override func printLog(log: AnyObject?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print(formatter.string(from: NSDate() as Date), terminator: "")
        if log == nil {
            print("nil")
        }
        else {
            print(log!)
        }
    }
    func showAlertWithText (_ header : String = "YuppTV", message : String) {
        //        if self.connectivityTimer != nil{
        //            self.connectivityTimer?.invalidate()
        //            self.connectivityTimer = nil
        //        }
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let messageAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //            self.backToDetailPage()
        })
        alert.addAction(messageAlertAction)
        self.present(alert, animated: true, completion: nil)
    }

      // MARK: -  Bitrate popup
    @IBAction func settingsClicked(_ sender: AnyObject) {
        
        let vc = BitRatesVC()
        vc.delegate = self
        if bitRates.count > 0 {
            vc.bitRateArry = bitRates
        }
        if self.player != nil {
            if self.player.avplayer.currentItem != nil {
                let playitem:AVPlayerItem = self.player.avplayer.currentItem!
                let prefferedBitRate:String = String(format:"%.1f", (playitem.preferredPeakBitRate/1024))
                vc.prefferedBitRate = prefferedBitRate
                self.presentpopupViewController(vc, animationType: .bottomBottom, completion: { () -> Void in
                })
            }
        }
        
    }
    // MARK: - PLAY / PAUSE
    @IBAction func buttonAction(sender: UIButton) {
        if sender.tag == 1 {
           /* if _playBackMode == .remote {
                if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
                    castSession.remoteMediaClient?.play()
                    self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
                    if self.player.avplayer.isExternalPlaybackActive {
                        self.player.playFromCurrentTime()
                        self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
                    }
                }
                else {
                    castSession.remoteMediaClient?.pause()
                    self.playBtn.setImage(UIImage(named:"playicon"), for: .normal)
                    if self.player.avplayer.isExternalPlaybackActive {
                        self.player.pause()
                        self.playBtn.setImage(UIImage(named:"playicon"), for: .normal)
                    }
                }
            }
            else{
              */
            if (self.player.playbackState.rawValue == PlaybackState.paused.rawValue) {
                    self.player.playFromCurrentTime()
                    self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
                    showControls = true
                    testVal = 3
                    showHideControllers(show: true)
                }
                else {
                    self.player.pause()
                    self.playBtn.setImage(UIImage(named:"playicon"), for: .normal)
                    showControls = false
                    testVal = 4
                    showHideControllers(show: false)
                }
           // }
        }
        else{
           // self.showReplayButton = false
            self.playBtn.tag = 1
            self.player.playFromBeginning()
            self.playBtn.isHidden = false
           // self.replayBtn.isHidden = true
            self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
            showControls = true
            testVal = 5
            showHideControllers(show: true)
        }
    }
    func showHideControllers(show:Bool) {
        printLog(log: "Function: \(#function),-------------- line: \(#line) testVal: \(testVal)" as AnyObject?)
        if self.playerObserver == nil {
            self.stopAnimating()
        }
        if self.player == nil {
            return
        }
        if self.player.avplayer.isExternalPlaybackActive || _playBackMode == .remote{
            self.sliderPlayer.isHidden = false
            self.playBtn.isHidden = false
//            if self.showReplayButton {
//                self.replayBtn.isHidden = false
//                self.replayBtn.alpha = 1.0
//            }
            self.seekFwd.isHidden = false
            self.seekBckwd.isHidden = false
            self.startTime.isHidden = false
            self.endTime.isHidden = false
            self.mQualityButton.isHidden = false
//            self.movieTvNameView.isHidden = false
//            self.backButton.isHidden = false
//            self.airPlayView.isHidden = false
            self.playBtn.alpha = 1.0
            self.seekFwd.alpha = 1.0
            self.seekBckwd.alpha = 1.0
            
        }
        else if showControls == true{
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.sliderPlayer.isHidden = true
                self.playBtn.isHidden = true
//                if self.showReplayButton {
//                    self.replayBtn.isHidden = true
//                    self.replayBtn.alpha = 0.0
//                }
                self.seekFwd.isHidden = true
                self.seekBckwd.isHidden = true
                self.startTime.isHidden = true
                self.endTime.isHidden = true
                self.mQualityButton.isHidden = true
//                self.movieTvNameView.isHidden = true
//                self.backButton.isHidden = true
//                self.airPlayView.isHidden = true
                self.playBtn.alpha = 0.0
                self.seekFwd.alpha = 0.0
                self.seekBckwd.alpha = 0.0
            }, completion: nil)
            
        }
        else {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.sliderPlayer.isHidden = false
                self.playBtn.isHidden = false
//                if self.showReplayButton{
//                    self.replayBtn.isHidden = false
//                    self.replayBtn.alpha = 1.0
//                }
                self.seekFwd.isHidden = false
                self.seekBckwd.isHidden = false
                self.startTime.isHidden = false
                self.endTime.isHidden = false
                self.mQualityButton.isHidden = false
//                self.movieTvNameView.isHidden = false
//                self.backButton.isHidden = false
//                self.airPlayView.isHidden = false
                self.playBtn.alpha = 1.0
                self.seekFwd.alpha = 1.0
                self.seekBckwd.alpha = 1.0
            }, completion: nil)
        }
        if !Utilities.hasConnectivity() {
//            if self.connectivityTimer != nil{
//                self.connectivityTimer?.invalidate()
//                self.connectivityTimer = nil
//            }
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
        }
    }
    // MARK:  - slider
    
    func sliderValueDidChange(_ sender:UISlider!)
    {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        let seconds : Int64 = Int64(sliderPlayer.value)
        self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
        isSeeking = true
    }
    func sliderValueDidChangeEnd(_ sender:UISlider!)
    {
        printLog(log: "Function: \(#function), line: \(#line)" as AnyObject?)
        self.printLog(log:"Slider step value \(Int(sender.value))" as AnyObject)
        let seconds : Int64 = Int64(sliderPlayer.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        self.printLog(log:"targetTime:-\(targetTime)" as AnyObject)
        self.startTime.text = "\(secondsToHoursMinutesSeconds(seconds: Int(seconds)))"
        currentTime = self.startTime.text!
//        self.startAnimating(allowInteraction: true)
//        if self.sessionManager.currentCastSession?.connectionState == GCKConnectionState.connected {
//            castSession.remoteMediaClient?.seek(toTimeInterval: Double(seconds))
//            if castSession.remoteMediaClient?.mediaStatus?.playerState == GCKMediaPlayerState.paused {
//                castSession.remoteMediaClient?.play()
//                self.playBtn.setImage(UIImage(named:"pauseicon"), for: .normal)
//            }
//            if self.player.avplayer.isExternalPlaybackActive {
//                self.player!.seekToTime(targetTime)
//            }
//        } else {
            self.player!.seekToTime(targetTime)
//        }
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
        
        let path = Bundle.main.path(forResource: "Countries", ofType: "enc")!
        let passEncryptedData = NSData(contentsOfFile: path)
        let pass = "yupptvasdf"
        fetchedCertificate = try! RNOpenSSLDecryptor.decryptData(passEncryptedData as Data!, with: kRNCryptorAES256Settings, password: pass) as NSData?
        
        
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












