//
//  ComingUPCollectionViewCell.swift
//  OTT
//
//  Created by YuppTV Ent on 26/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit

class ComingUPCollectionViewCell: UICollectionViewCell {
    
    static let nibname:String = "ComingUPCollectionViewCell"
    static let identifier:String = "ComingUPCollectionViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    var delegate:collectionCell_delegate?
    var arrayItems: [Card]?
    
//    public var isPlaying: Bool = false
//    public var videolink: URL?
    
    //        public var videolink: URL? = nil {
    //            didSet {
    //                guard let link = videolink, oldValue != link else { return }
    //
    //            }
    //        }
//    private var queuePlayer = AVQueuePlayer()
//    private var playerLayer = AVPlayerLayer()
//    private var looperPlayer: AVPlayerLooper?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        commonInit()
//    }
//
//    @IBAction func btnPlayVideClicked(_ sender: Any) {
//        guard let link = videolink else { return }
//        loadVideoUsingURL(link)
//    }
//    private func commonInit() {
//
//        queuePlayer.volume = 0.0
//        queuePlayer.actionAtItemEnd = .none
//
//        playerLayer.videoGravity = .resizeAspect
//        playerLayer.name = "videoLoopLayer"
//        playerLayer.cornerRadius = 5.0
//        playerLayer.masksToBounds = true
//        contentView.layer.addSublayer(playerLayer)
//        playerLayer.player = queuePlayer
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        /// Resize video layer based on new frame
//        //            playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.width))
//        playerLayer.frame = playerView.frame
//    }
//
//    private func loadVideoUsingURL(_ url: URL) {
//        /// Load asset in background thread to avoid lagging
//        DispatchQueue.global(qos: .background).async {
//            let asset = AVURLAsset(url: url)
//            /// Load needed values asynchronously
//            asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
//                /// UI actions should executed on the main thread
//                DispatchQueue.main.async { [weak self] in
//                    guard let `self` = self else { return }
//                    let item = AVPlayerItem(asset: asset)
//                    if self.queuePlayer.currentItem != item {
//                        self.queuePlayer.replaceCurrentItem(with: item)
//                        self.looperPlayer = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
//                        self.startPlaying()
//                    }
//                }
//            }
//        }
//    }
//
//    public func startPlaying() {
//        queuePlayer.play()
//        isPlaying = true
//    }
//
//    public func stopPlaying() {
//        queuePlayer.pause()
//        isPlaying = false
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = UIFont.ottRegularFont(withSize: 12)
        lblDescription.font = UIFont.ottRegularFont(withSize: 10)
        lblTime.font = UIFont.ottRegularFont(withSize: 12)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = AppTheme.instance.currentTheme.lineColor.cgColor
        self.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.numberOfLines = 0
    }
    
    static func registerToCollectionView(collectionView : UICollectionView){
        collectionView.register(ComingUPCollectionViewCell.self, forCellWithReuseIdentifier: ComingUPCollectionViewCell.identifier)
        collectionView.register(UINib.init(nibName: ComingUPCollectionViewCell.nibname, bundle: nil), forCellWithReuseIdentifier: ComingUPCollectionViewCell.identifier)
    }
    
    func setUpData(data: Any, type: String) {
        
        arrayItems = data as? [Card]
        if arrayItems?.count ?? 0 > 0 {
            lblTitle.text = arrayItems?.first?.display.title
            lblDescription.text = arrayItems?.first?.display.subtitle1
            lblTime.text = arrayItems?.first?.display.subtitle2
            imgView.sd_setImage(with: URL(string: (arrayItems?.first?.display.imageUrl ?? "")), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            
            imgView.isHidden = false
            lblTitle.isHidden = false
            lblDescription.isHidden = false
            lblTime.isHidden = false
            btnPlayVideo.isHidden = false
        }
        else {
            imgView.isHidden = true
            lblTitle.isHidden = true
            lblDescription.isHidden = true
            lblTime.isHidden = true
            btnPlayVideo.isHidden = true
        }
    }
}
