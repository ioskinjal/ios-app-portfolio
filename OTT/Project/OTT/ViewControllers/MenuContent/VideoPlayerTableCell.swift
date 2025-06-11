//
//  VideoPlayerTblCell.swift
//  SampleTikTok
//
//  Created by Apalya on 19/04/22.
//

import UIKit
import AVFoundation
import OTTSdk


@objc protocol shortsTableViewCellDelegate {
    @objc func playButtonTap(cardItem :Card)
    @objc func shareButtonTap(cardItem :Card,buttonSender: Any)
    @objc func muteButtonTap(isMuted:Bool)
}

class VideoPlayerTableCell: UITableViewCell {
    var playerLayer: AVPlayerLayer?
    weak  var shortsCelldelegate : shortsTableViewCellDelegate?
    var cardItem = Card()
    @IBOutlet weak var playpauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var videoPlayerView: UIView!
    
    
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var playPauseImageView: UIImageView!
    var isMuted : Bool = true
    var playpauseTimer : Timer?
    
    let url  = ""// Asset URL
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    @IBOutlet weak var playStaticLabel: UILabel!
    var playerObserver:AnyObject!

    public var maximumDuration: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.duration)
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }
    
    public var currentTime: TimeInterval {
        get {
            if let playerItem = self.playerItem {
                return CMTimeGetSeconds(playerItem.currentTime())
            } else {
                return CMTimeGetSeconds(CMTime.indefinite)
            }
        }
    }
    func resetTimer(){
        if self.playpauseTimer != nil {
            self.playpauseTimer?.invalidate()
        }
    }
    func configue(cardObject:Card,isMuted:Bool){
        self.cardItem = cardObject
        self.titleLabel.text = cardObject.display.title
        self.descriptionLabel.text = cardObject.display.subtitle1
        let urlstr = cardObject.metadata.previewUrl
        guard let url = URL(string: urlstr) else{ return }
        playerItem = AVPlayerItem(url: url)
        self.progressbar.progress = 0.0
        self.playerLayer?.player = AVPlayer(playerItem: playerItem)
        self.progressbar.isHidden = true
        self.isMuted = isMuted
        if self.isMuted == true {
            self.playerLayer?.player?.volume = 0
            self.muteButton.setImage(UIImage.init(named: "img_mute"), for: .normal)
        }
        else {
            self.playerLayer?.player?.volume = 100
            self.muteButton.setImage(UIImage.init(named: "img_unmute"), for: .normal)
        }
        self.resetTimer()
        let interval = CMTime(seconds: 0.2,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        self.playerObserver = self.playerLayer?.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.playerLayer?.player?.currentItem?.status == .readyToPlay {
                self.progressbar.isHidden = false
                
                let currentProgress = Float(self.currentTime / self.maximumDuration)
                if currentProgress > 0 {
                    self.progressbar.progress = Float(currentProgress)
                    if currentProgress >= 100 {
                        self.progressbar.isHidden = true
                    }
                    else {
                        self.progressbar.isHidden = false
                    }
                }
            }
            else if self.playerLayer?.player?.currentItem?.status == .failed{
                print("failed")
            }
        } as AnyObject?

        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

        self.playPauseImageView.alpha = 0.0
        self.progressbar.progressTintColor = AppTheme.instance.currentTheme.cardTitleColor
        self.playerLayer = AVPlayerLayer()
        self.playerLayer?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor.cgColor
        self.playerLayer!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.playerLayer!.videoGravity = .resizeAspectFill
        self.videoPlayerView.layer.insertSublayer(self.playerLayer!, at: 0)
        
        // Initialization code
        self.playpauseButton.backgroundColor = .clear
        self.progressbar.progress = 0.0
     }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func hidePlayPauseImageView() {
        UIView.animate(withDuration: 1, animations: { () -> () in
            self.playPauseImageView.alpha = 0.0
        })
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func muteButtonClicked(_ sender: Any) {
        
        self.isMuted = !self.isMuted
        
        if self.isMuted == true {
            self.playerLayer?.player?.volume = 0
            self.muteButton.setImage(UIImage.init(named: "img_mute"), for: .normal)
        }
        else {
            self.playerLayer?.player?.volume = 100
            self.muteButton.setImage(UIImage.init(named: "img_unmute"), for: .normal)
        }
        self.shortsCelldelegate?.muteButtonTap(isMuted: self.isMuted)
            
    }
    
    @IBAction func playPauseButtonAction(_ sender: Any) {
        self.resetTimer()
        self.playpauseTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hidePlayPauseImageView), userInfo: nil, repeats: false)
        self.playPauseImageView.alpha = 0.0

        if (sender as! UIButton).tag == 1{
            self.playpauseButton.tag = 0
            self.playPauseImageView.image = UIImage.init(named: "playicon")
            self.playerLayer?.player?.play()
        }else{
            self.playpauseButton.tag = 1
            self.playPauseImageView.image = UIImage.init(named: "pauseicon")
            self.playerLayer?.player?.pause()
        }
        UIView.animate(withDuration: 1, animations: { () -> () in
            self.playPauseImageView.alpha = 1.0
        })
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        self.shortsCelldelegate?.shareButtonTap(cardItem: self.cardItem,buttonSender: sender)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        self.shortsCelldelegate?.playButtonTap(cardItem: self.cardItem)
    }
}
