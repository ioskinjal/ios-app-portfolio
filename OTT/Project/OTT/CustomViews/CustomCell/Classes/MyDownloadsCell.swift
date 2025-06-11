//
//  MyDownloadsCell.swift
//  OTT
//
//  Created by Pramodkumar on 27/04/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//

import UIKit

class MyDownloadsCell: UICollectionViewCell {
    @IBOutlet weak var downloadedImageView : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var downloadPercentage: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var downloadHoursLbl : UILabel!
    @IBOutlet weak var underlineLabelColor : UILabel!
    @IBOutlet weak var downloadImageviewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var durationLabel : UILabel!
    fileprivate var download_size = ""
    var fetchDetails : (()->Void)!
    var asset: Asset? {
        didSet {
            if let asset = asset {
                if #available(iOS 11.0, *) {
                    let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                    switch downloadState {
                    case .downloaded:
//                        durationLabel.isHidden = false
                        downloadPercentage.isHidden = true
                        self.downloadPercentage.isHidden = true
//                        self.checkBoxButton.isHidden = false
                        self.checkBoxButton.isUserInteractionEnabled = true
                        self.checkBoxButton.setImage(UIImage.init(named: "ic_mydownload_not_selected"), for: .normal)
                        self.blurOutView(false)
                    case .downloading:
//                        durationLabel.isHidden = true
                        if Utilities.hasConnectivity() {
                            downloadPercentage.isHidden = false
                            self.downloadPercentage.isHidden = false
//                            self.checkBoxButton.isHidden = true
                            self.checkBoxButton.isUserInteractionEnabled = true
                            self.checkBoxButton.setImage(UIImage.init(named: "icon_delete"), for: .normal)
                            self.blurOutView(true)
                            self.isUserInteractionEnabled = true
                        } else {
                            downloadPercentage.isHidden = true
                            self.downloadPercentage.isHidden = true
//                            self.checkBoxButton.isHidden = false
                            self.checkBoxButton.isUserInteractionEnabled = false
                            self.checkBoxButton.setImage(UIImage.init(named: "no_download"), for: .normal)
                            self.blurOutView(true)
                        }

                    case .notDownloaded:
//                        durationLabel.isHidden = true
                        downloadPercentage.isHidden = true
                        self.downloadPercentage.isHidden = true
//                        self.checkBoxButton.isHidden = false
                        self.checkBoxButton.isUserInteractionEnabled = false
                        self.checkBoxButton.setImage(UIImage.init(named: "no_download"), for: .normal)
                        self.blurOutView(true)
                        break
                    }

                    let notificationCenter = NotificationCenter.default
                    notificationCenter.addObserver(self,
                                                   selector: #selector(handleAssetDownloadStateChanged(_:)),
                                                   name: .AssetDownloadStateChanged, object: nil)
                    notificationCenter.addObserver(self, selector: #selector(handleAssetDownloadProgress(_:)),
                                                   name: .AssetDownloadProgress, object: nil)

                } else {
                    // Fallback on earlier versions
                }
            } else {
                downloadPercentage.isHidden = false
                self.downloadPercentage.isHidden = false
//                self.checkBoxButton.isHidden = true
//                durationLabel.isHidden = true
            }
        }
    }
    func blurOutView(_ status:Bool) {
        self.downloadedImageView.alpha = status ? 0.5 : 1.0
        self.nameLbl.alpha = status ? 0.5 : 1.0
        self.descLbl.alpha = status ? 0.5 : 1.0
        self.isUserInteractionEnabled = !status
    }
    // MARK: Notification handling

    @objc
    func handleAssetDownloadStateChanged(_ notification: Notification) {
        guard let assetStreamName = notification.userInfo![Asset.Keys.name] as? String,
            let downloadStateRawValue = notification.userInfo![Asset.Keys.downloadState] as? String,
            let downloadState = Asset.DownloadState(rawValue: downloadStateRawValue),
            let asset = asset, asset.stream.name == assetStreamName else { return }

        DispatchQueue.main.async {
            switch downloadState {
            case .downloading:
//                self.durationLabel.isHidden = true
                self.downloadPercentage.isHidden = false
//                self.checkBoxButton.isHidden = true
                self.blurOutView(true)
            case .downloaded, .notDownloaded:
//                self.durationLabel.isHidden = true
                if downloadState == .downloaded {
//                    self.durationLabel.isHidden = false
                    AppDelegate.getDelegate().updateExpiryDateForStream(streamName: asset.stream.name, download_size: self.download_size, video_download: true)
                    self.fetchDetails()
                }
                self.downloadPercentage.isHidden = true
//                self.checkBoxButton.isHidden = false
                self.blurOutView(false)
            }
        }
    }

    @objc
    func handleAssetDownloadProgress(_ notification: NSNotification) {
        guard let assetStreamName = notification.userInfo![Asset.Keys.name] as? String,
            let asset = asset, asset.stream.name == assetStreamName else { return }
        guard let progress = notification.userInfo![Asset.Keys.percentDownloaded] as? Double else { return }
        self.downloadPercentage.text = "Downlading… \(Int(progress*100))%"
        guard let d_size = notification.userInfo?["download_size"] as? String else {return}
        download_size = d_size
        descLbl.text = d_size
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        descLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        downloadHoursLbl.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        downloadHoursLbl.font = UIFont.ottRegularFont(withSize: 10.0)
        nameLbl.font = UIFont.ottRegularFont(withSize: 14.0)
        descLbl.font = UIFont.ottRegularFont(withSize: 12.0)
        durationLabel.font = UIFont.ottRegularFont(withSize: 12.0)
        durationLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
        downloadPercentage.textColor = AppTheme.instance.currentTheme.downloadingPercentageColor
        underlineLabelColor.backgroundColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
}
