//
//  MenuBarReusableView.swift
//  sampleColView
//
//  Created by Ankoos on 08/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleMobileAds
import CoreData
@objc protocol tabMenuProtocal {
    func didSelectedItem(item: Int)
    @objc optional func goToSignUp()
    @objc optional func goToSubscribePage()
    @objc optional func goToSignIn()
    @objc optional func goToShare()
    @objc optional func updateTableview(height:CGFloat,showHide:Bool)
    @objc optional func favbtnClicked()
    @objc optional func HideKeyboardButtonClicked()
    @objc optional func RateNowButtonClickedInHeader()
    @objc optional func ShowHideDescriptionInHeader(showHide:Bool,descHeight:CGFloat)
    @objc optional func DisplayWatchPartyView()
    @objc optional func downloadBtnClicked()
}
class MenuBarReusableView: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,CastTableViewCellProtocal, ExpandableLabelDelegate {
    func selectedCast(castModel: CastCrewModel) {
    }
    

    
    func willExpandLabel(_ label: ExpandableLabel) {
        self.detailTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.detailTableView)
        if (self.detailTableView.indexPathForRow(at: point) as IndexPath?) != nil {
            states[0] = false
        }
        UIView.animate(withDuration: 0.0, animations: {
            
            self.currentScrollPos = self.detailTableView.contentOffset.y
            self.layoutIfNeeded()
            self.detailTableView.endUpdates()
            self.currentScrollPos = nil
        }, completion: nil)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.detailTableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: self.detailTableView)
        if (self.detailTableView.indexPathForRow(at: point) as IndexPath?) != nil {
            states[0] = true
        }
        UIView.animate(withDuration: 0.01, animations: {
            
            self.currentScrollPos = self.detailTableView.contentOffset.y
            self.layoutIfNeeded()
            self.detailTableView.endUpdates()
            self.currentScrollPos = nil
        }, completion: nil)
    }

    var currentScrollPos : CGFloat?
    
    
    struct ItemDescrition {
        
        var description : String{
            set{
                localAnswer = newValue
                
                let constraintRect = CGSize(width: UIScreen.main.bounds.size.width - 39, height: CGFloat.greatestFiniteMagnitude)
                let boundingBox = localAnswer.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 13)], context: nil)
                descriptionHeight = boundingBox.height + 20
            }
            get{
                return localAnswer
            }
        }
        
        var descriptionHeight : CGFloat = 0
        var localAnswer = ""
    }

    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var playerCouchScreen: UIView!
    @IBOutlet weak var favouriteBtn: UIButton!

    @IBOutlet weak var showMoreViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showMoreBtnTitleBtn: UIButton!
    
    @IBOutlet weak var showMoreIconBtn: UIButton!
    @IBOutlet weak var popupLblHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerInfoViewBottomConstraint: NSLayoutConstraint!
    var toolBarTitlesArray = [ToolbarTitle]()
    var titlearray = [Section]()
    var titleCardArray = [Card]()
    var tabTitlearray = [Tab]()
    var showLoginView:Bool = false
    var isNetworkContent:Bool = false
    var tabIndex = 0
    var errorCode = 0
    var tabTitles = [String]()
    var showWatchPartyButton = false
    var sectionDetailsObjArr = [Any]()
    var contentDetailResponse: PageContentResponse?
    var startOverButtonElement:Element!
    var playButtonElement:Element!
    var trailerButtonElement:Element!
    var movieDescriptionText = ""
    var isFavourite:Bool = false
    var isButtonVisisble:Bool = false
    var targetPath = ""
    var contentCellHeight:CGFloat = 430.0
    var tvShowCellHeight:CGFloat = 0
    var states : Array<Bool>!
    var isFromErrorFlow:Bool = false
    var isDescriptionNA:Bool = true
    var isSubscriptionBtn:Bool = false
    var favButton = false
    var downloadButton = false
    var shareButton = false
    var isRecipe = false
    var playerHeight: CGFloat?
    @IBOutlet weak var signIntrailingContraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInLeadingBtnConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    var tabMenuDelegate: tabMenuProtocal!
    
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 2.0)
    var cellSizes: CGSize = CGSize(width: 120, height: 47)
    let numColums: CGFloat = 1
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 2
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    
    var currentObj :Any!
    var showhide:Bool = true
    var showLeftAlignment:Bool = false
    var itemDes = ItemDescrition()
    var castInfo:Section?
    var isFav:Bool = false
    var showFav:Bool = false
    var contentType = ""
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var playerInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCollection: UICollectionView!
    @IBOutlet weak var tabCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabCollectionTrailingConstraint: NSLayoutConstraint?
    @IBOutlet weak var tabCollectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playerInfoView: UIView!
    @IBOutlet weak var watchPartyButton:UIButton?
    @IBOutlet weak var watchPartyButtonWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var downloadProgressLbl: UILabel!
    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet weak var castTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var castTableViewBottomConstraint: NSLayoutConstraint!
    var castCrewArray = [CastCrewModel]()
       
       
    /*player dock*/
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var showHideButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expiryLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expiryLabelHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var popupHeightconstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var popupLabel: UILabel!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    var popUpViewHeight = 109
    
    @IBOutlet weak var HideKeyBoardButton : UIButton?
    
    @IBOutlet weak var ShowHideDescriptionButton : UIButton?
    
    
   fileprivate var download_size = ""
    fileprivate var video_download = false
   var showUserRatingView:Bool = false
   var userRatingVal:Int = 0
    @IBOutlet weak var userRatingView: UIView!
    @IBOutlet weak var userRatingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userRatingTextLabel : UILabel!
    @IBOutlet weak var rateNowButton:UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var downloadHeightConstraint : NSLayoutConstraint!
    var asset: Asset? {
        didSet {
            if let asset = asset {
                if #available(iOS 11.0, *) {
                    let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                    switch downloadState {
                    case .downloaded:
                        downloadProgressView.isHidden = true
                        downloadProgressLbl.isHidden = true
                        self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_already_donwload"), for: UIControl.State.normal)
                    case .downloading:
                        downloadProgressView.isHidden = false
                        downloadProgressLbl.isHidden = false
                        self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_donwload"), for: UIControl.State.normal)
                    case .notDownloaded:
                        downloadProgressView.isHidden = true
                        downloadProgressLbl.isHidden = true
                        self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_donwload"), for: UIControl.State.normal)
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
                downloadProgressView.isHidden = true
                downloadProgressLbl.isHidden = true
            }
        }
    }
    var showDownload:Bool = false
    var isDownloaded:Bool = false
    // MARK: Notification handling
    
    @objc
    func handleAssetDownloadStateChanged(_ notification: Notification) {
        guard let assetStreamName = notification.userInfo![Asset.Keys.name] as? String,
            let downloadStateRawValue = notification.userInfo![Asset.Keys.downloadState] as? String,
            let downloadState = Asset.DownloadState(rawValue: downloadStateRawValue),
            let asset = asset, asset.stream.name == assetStreamName else { return }
            var downloadErrorMsg = ""
        if let message = notification.userInfo!["DownloadError"] as? String {
            downloadErrorMsg = message
        }
        DispatchQueue.main.async { [self] in
            switch downloadState {
            case .downloading:
                self.downloadProgressView.isHidden = false
                self.downloadProgressLbl.isHidden = false
                if self.showDownload {
                    self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_donwload"), for: UIControl.State.normal)
                }
                break
            case .downloaded:
                self.downloadProgressView.isHidden = true
                self.downloadProgressView.progress = 0.0
                self.downloadProgressLbl.isHidden = true
                if self.showDownload {
                    self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_already_donwload"), for: UIControl.State.normal)
                }
                self.updateExpiryDateInOfflineData(streamName: assetStreamName)
                break
            case .notDownloaded:
                self.downloadProgressView.isHidden = true
                self.downloadProgressLbl.isHidden = true
                if self.showDownload {
                    self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_donwload"), for: UIControl.State.normal)
                }
                if !(downloadErrorMsg .isEmpty) {
                    var userInfo = [String: Any]()
                    userInfo["DownloadError"] = downloadErrorMsg
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowDownloadAlertError"), object: nil, userInfo: userInfo)
                }
                break
            }
            
            //            self.delegate?.assetListTableViewCell(self, downloadStateDidChange: downloadState)
        }
    }
    private func updateExpiryDateInOfflineData(streamName : String) {
        AppDelegate.getDelegate().updateExpiryDateForStream(streamName: streamName, download_size: download_size, video_download: true)
    }
    @objc
    func handleAssetDownloadProgress(_ notification: NSNotification) {
        guard let assetStreamName = notification.userInfo![Asset.Keys.name] as? String,
            let asset = asset, asset.stream.name == assetStreamName else { return }
        guard let progress = notification.userInfo![Asset.Keys.percentDownloaded] as? Double else { return }
        Log(message: "\(progress)")
        self.downloadProgressView.isHidden = false
        self.downloadProgressLbl.isHidden = false
        self.downloadProgressView.setProgress(Float(progress), animated: true)
        self.downloadProgressLbl.text = "\(Int(progress*100))%"
        guard let d_size = notification.userInfo?["download_size"] as? String else {return}
        download_size = d_size
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    func setupViews()  {
        if self.castInfo?.sectionData.data.count ?? 0 > 0 {
            self.castTableView.isHidden = false
            self.castTableView.reloadData()
            self.castTableViewBottomConstraint.constant = 10
            self.castTableViewHeightConstraint.constant = 75
        }
        else{
            self.castTableView.isHidden = true
            self.castTableViewBottomConstraint.constant = 0
            self.castTableViewHeightConstraint.constant = 0
        }
        self.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.playerInfoView.backgroundColor = .black.withAlphaComponent(0.32)
        self.downloadProgressLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.popupLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.channelNameLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.expiryLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.programLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.descLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        if appContants.appName == .gac {
            self.detailTableView.register(UINib(nibName: "buttonstack", bundle: nil), forCellReuseIdentifier: "buttonstack")
            self.detailTableView.register(UINib(nibName: "morewebview", bundle: nil), forCellReuseIdentifier: "morewebview")
            self.detailTableView.register(UINib(nibName: "descriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCell")
            self.detailTableView.register(ExpandableCell.self, forCellReuseIdentifier: "ExpandableCell")
            self.detailTableView.delegate = self
            self.detailTableView.dataSource = self
            self.detailTableView.register(UINib.init(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
            self.detailTableView.backgroundColor = .white
            self.detailTableViewHeight.constant = isRecipe ? 220 : 154
            self.detailTableView.backgroundColor = .black.withAlphaComponent(0.16)
            self.detailTableView.showsVerticalScrollIndicator = false
            self.detailTableView.showsHorizontalScrollIndicator = false
            self.isFavourite = self.contentDetailResponse?.pageButtons.isFavourite ?? false
            
            
        }
        self.expiryLabel.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshFavoriteContent), name: NSNotification.Name(rawValue: "RefreshFavoriteContent"), object: nil)
        self.expiryLabel.font = UIFont.ottRegularFont(withSize: 11)
        self.castTableView.backgroundColor = .clear
        self.descLabel.backgroundColor = UIColor.clear
        self.descLabel.font = UIFont.ottRegularFont(withSize: 13)
        self.popupView.backgroundColor = UIColor.init(hexString: "373737")
        self.signUpBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        self.userRatingView.backgroundColor = AppTheme.instance.currentTheme.playerRecommedationsHeaderBgColor
        self.userRatingView.viewCornerDesignWithBorder(AppTheme.instance.currentTheme.rateNowViewBgColor)
        self.rateNowButton.backgroundColor = AppTheme.instance.currentTheme.rateNowViewBgColor
        self.rateNowButton.buttonCornerDesignWithBorder(AppTheme.instance.currentTheme.rateNowButtonBgColor)
        self.userRatingTextLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.userRatingTextLabel.font = UIFont.ottRegularFont(withSize: 10)
        self.rateNowButton.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
        self.rateNowButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 11)
        
        if self.isNetworkContent {
            self.menuCollection.backgroundColor = UIColor.init(hexString: "232326")
        } else {
            self.menuCollection.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        }
        if self.showUserRatingView == true {
            self.userRatingViewHeightConstraint.constant = 50
            self.userRatingView.isHidden = false
            self.userRatingTextLabel.isHidden = false
            self.rateNowButton.isHidden = false
            if self.userRatingVal == 0 {
                self.rateNowButton.setImage(UIImage.init(named: "img_star_normal"), for: .normal)
                self.rateNowButton.setTitle("Rate Now", for: .normal)
            }
            else {
                self.rateNowButton.setImage(UIImage.init(named: "img_star_highlight"), for: .normal)
                self.rateNowButton.setTitle("\(userRatingVal) Star Rating", for: .normal)
            }
        }
        else{
            self.userRatingView.isHidden = true
            self.userRatingTextLabel.isHidden = true
            self.rateNowButton.isHidden = true
            self.userRatingViewHeightConstraint.constant = 0
        }
        self.popupView.layer.cornerRadius = 4.0
        self.playerInfoView.isHidden = true
        self.popupLabel.numberOfLines = 0
        //        self.playerInfoViewHeightConstraint.constant = 0
        self.tabCollectionHeightConstraint.constant = 47
        self.tabCollectionTopConstraint.constant = 15
        if self.showLoginView {
            self.popupView.isHidden = false
            if self.errorCode == 402 {
                self.signInBtn.isHidden = true
                self.signUpBtn.isHidden = true
                self.subscribeBtn.isHidden = false
                self.popupLabel.text = "Please subscribe to watch the content"
            } else {
                self.signInBtn.isHidden = false
                self.signUpBtn.isHidden = false
                self.subscribeBtn.isHidden = true
                self.popupLabel.text = "Please Sign in to watch the content"
            }
        }
        else {
            self.popupView.isHidden = true
        }
        let showFavouriteBtn = self.showFav
        if showFavouriteBtn {
            self.favouriteBtn.isHidden = false
            if self.isFav {
                self.favouriteBtn.setImage( #imageLiteral(resourceName: "fav_selected"), for:UIControl.State.normal)
            }
            else {
                self.favouriteBtn.setImage( #imageLiteral(resourceName: "fav_deselected"), for:UIControl.State.normal)
            }
        }
        else {
            self.favouriteBtn.isHidden = true
        }
        if self.showhide == true {
            self.ShowHideDescriptionButton?.setImage(UIImage.init(named: "cellDropDownArrow"), for: .normal)
            self.castTableView.isHidden = false
        }
        else {
            self.ShowHideDescriptionButton?.setImage(UIImage.init(named: "cellDropDownUpArrow"), for: .normal)
            self.castTableView.isHidden = true
        }
        self.setUpCommonly()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidePlayerCouchScreen), name: NSNotification.Name(rawValue: "HidePlayerCouchScreen"), object: nil)
        #warning("Overriding showWatchPartyButton value")
        self.showWatchPartyButton = false
        #warning("Overriding showWatchPartyButton value")
        if self.showWatchPartyButton == true{
            self.watchPartyButton?.backgroundColor = .clear
            self.watchPartyButton?.isHidden = false
            self.watchPartyButtonWidthConstraint?.constant = 45
            self.tabCollectionTrailingConstraint?.constant = 50
        }
        else{
            self.watchPartyButton?.isHidden = true
            self.watchPartyButtonWidthConstraint?.constant = 0
            self.tabCollectionTrailingConstraint?.constant = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.playerInfoViewHeightConstraint.constant = 500.0// CGFloat(self.calculateMenuBarHeight())
        }
    }
    func calculateMenuBarHeight() -> Int {
        var defaultHeight = 71 + 20
        if self.showUserRatingView == true {
            defaultHeight = defaultHeight + 50 + 15
        }
        if self.expiryLabel.text?.count ?? 0 > 0 {
            defaultHeight = defaultHeight + 18 + 6
        }
        if self.showhide == true {
            self.descLabelHeightConstraint.constant = 0
            self.descLabelTopConstraint.constant = 0
            self.castTableViewHeightConstraint.constant = 0
            self.castTableViewBottomConstraint.constant = 0
            descLabel.text = ""
            descLabel.isHidden = self.showhide
            descLabel.sizeToFit()
        }
        else{
            descLabel.text = itemDes.description
            descLabel.isHidden = self.showhide
            self.descLabel.sizeToFit()
            self.descLabelHeightConstraint.constant = self.itemDes.descriptionHeight
            self.descLabelTopConstraint.constant = 0
            defaultHeight = defaultHeight + Int(self.descLabelHeightConstraint.constant)
            if castInfo != nil && castInfo?.sectionData.data.count ?? 0 > 0 {
                defaultHeight = defaultHeight + 100
                self.castTableViewHeightConstraint.constant = 75
                self.castTableViewBottomConstraint.constant = 10
            }
            else{
                self.castTableViewHeightConstraint.constant = 0
                self.castTableViewBottomConstraint.constant = 0
            }
        }
        if self.showLoginView {
            defaultHeight = defaultHeight + 109
        }
        defaultHeight = defaultHeight + 30
        return defaultHeight
    }
    func setUpCommonly() {
        self.toolBarTitlesArray.removeAll()
        if isNetworkContent {
            for item in titleCardArray{
                var toolBarTitleObj = ToolbarTitle()
                toolBarTitleObj.title = item.display.title
                self.toolBarTitlesArray.append(toolBarTitleObj)
                self.showLeftAlignment = true
            }
        } else {
            for item in titlearray{
                var toolBarTitleObj = ToolbarTitle()
//                                if item.sectionInfo.name .isEmpty {
//                                    toolBarTitleObj.title = item.sectionInfo.code.capitalized
//                                }
//                                else {
//                toolBarTitleObj.title = item.sectionInfo.name
//                                }
                if item.sectionInfo.code == "recommendations" {
                    if self.contentType == "movie" {
                        toolBarTitleObj.title = AppDelegate.getDelegate().moviePlayerRecommendationText
                    }
                    else if self.contentType == "tvshowepisode" ||  item.sectionInfo.code == "tvshow" {
                        toolBarTitleObj.title = AppDelegate.getDelegate().tvshowPlayerRecommendationText
                    }else if self.contentType == "" {
                        if item.sectionInfo.name.isEmpty {
                            toolBarTitleObj.title = item.sectionInfo.code.capitalized
                        }
                        else {
                            toolBarTitleObj.title = item.sectionInfo.name
                        }
                    }
                    else{
                        toolBarTitleObj.title = AppDelegate.getDelegate().channelRecommendationText
                    }
                    if toolBarTitleObj.title == "" {
                        toolBarTitleObj.title = item.sectionInfo.name
                    }
                }
                else if item.sectionInfo.code == "recipe" {
                    self.isRecipe = true
                }
                else {
                    toolBarTitleObj.title = item.sectionInfo.name
                }
                
                
                self.toolBarTitlesArray.append(toolBarTitleObj)
                self.showLeftAlignment = true
            }
            for (index, item) in tabTitlearray.enumerated(){
                var toolBarTitleObj = ToolbarTitle()
                if item.sectionCodes.count > 0 && item.sectionCodes.contains(item.code) {
                    toolBarTitleObj.title = tabTitles[index].capitalized
                }
                else {
                    toolBarTitleObj.title = item.title.capitalized
                }
                self.toolBarTitlesArray.append(toolBarTitleObj)
            }

        }
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        
        menuCollection.delegate = self
        menuCollection.dataSource = self
        
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        menuCollection.collectionViewLayout = cCFL
        menuCollection.register(UINib(nibName: "tabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tabCollectionViewCell")
        menuCollection.register(UINib(nibName: "subMenuTabColViewCell", bundle: nil), forCellWithReuseIdentifier: "subMenuTabColViewCell")
        menuCollection.register(UINib(nibName: "subMenuTabColViewCell-iPad", bundle: nil), forCellWithReuseIdentifier: "subMenuTabColViewCell-iPad")
        menuCollection.register(UINib(nibName: "langCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "langCollectionViewCell")
        self.menuCollection.register(UINib(nibName: "tabCollectionViewCell-iPad", bundle: nil), forCellWithReuseIdentifier:"tabCollectionViewCelliPad")
        menuCollection.register(UINib(nibName: "titleCell", bundle: nil), forCellWithReuseIdentifier: "titleCell")
        
        self.castTableView.register(UINib.init(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        self.castTableView.delegate = self
        self.castTableView.dataSource = self
        
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 1))
        footerView.backgroundColor = .clear
        self.castTableView.tableFooterView = footerView
        self.castTableView.showsVerticalScrollIndicator = false
        
        self.signUpBtn.setTitle("Register".localized, for: .normal)
        self.signInBtn.setTitle("Sign-in".localized, for: .normal)
        self.subscribeBtn.setTitle("Subscribe".localized, for: .normal)
        self.subscribeBtn.backgroundColor = self.signUpBtn.backgroundColor
        self.downloadBtn.isHidden = true
        self.downloadHeightConstraint.constant = 0.0
        if #available(iOS 11.0, *) {
            if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .reeldrama{
                self.downloadBtn.isHidden = false
                self.downloadHeightConstraint.constant = 28.0
                if !self.showDownload {
                    self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_not_support"), for: UIControl.State.normal)
                    self.downloadBtn.isUserInteractionEnabled = false
                } else {
                    if self.isDownloaded {
                        self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_already_donwload"), for: UIControl.State.normal)
                    } else {
                        self.downloadBtn.setImage(#imageLiteral(resourceName: "ic_offline_donwload"), for: UIControl.State.normal)
                    }
                    self.downloadBtn.isUserInteractionEnabled = true
                }
            }
        }
        if !AppDelegate.getDelegate().iosAllowSignup {
            self.signUpBtn.isHidden = true
            self.signIntrailingContraint.constant = 100.0
            self.signInLeadingBtnConstraint.constant = -60.0
        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
//            if self.tabIndex == 0 {
//                self.menuCollection.scrollRectToVisible(CGRect.infinite, animated: false)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
//                    self.menuCollection.contentOffset = CGPoint.zero
//                }
//            }
//        }
    }
    func loadOfflinePlayerItemDetails() {
        infoBtn.isHidden = true
        self.popupHeightconstraint.constant = 60
        self.playerInfoView.isHidden = false
        self.tabCollectionHeightConstraint.constant = 0.0
        self.downloadBtn.isHidden = true
        if let stream = AppDelegate.getDelegate().selectedContentStream {
            self.iconImageView.image = UIImage.init(data: stream.imageData! as Data)
            self.programLabel.text = stream.name
            channelNameLabel.isHidden = false
            self.channelNameLabel.text = stream.subTitle
        }
        if (self.popupLabel.text? .isEmpty)! {
            self.popUpViewHeight = 60
            self.popupLblHeightConstraint.constant = 0
            self.playerInfoViewHeightConstraint.constant = 234
        }
        else {
            self.popUpViewHeight = 109
            self.popupLblHeightConstraint.constant = 50.5
            self.playerInfoViewHeightConstraint.constant = 283
        }
        self.popupHeightconstraint.constant = CGFloat(self.popUpViewHeight)
    }
    
    // MARK: - get Attributed Text from Desc
    func getAttributedText(timeString:String,desc:String) ->  NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        //            paragraphStyle.paragraphSpacing = 0.5;
        paragraphStyle.alignment = NSTextAlignment.left
        
        //Title
        var tempDesc = desc
        if timeString.count > 0{
            let titleAttribute = [NSAttributedString.Key.font:
                UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                  NSAttributedString.Key.foregroundColor: UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0),NSAttributedString.Key.paragraphStyle : paragraphStyle]
            let titleAttributedString = NSMutableAttributedString(
                string: " " + desc,
                attributes: titleAttribute)
            let totalDescStr = NSMutableAttributedString(
                string: timeString + "  ",
                attributes: titleAttribute)
            let textAttachment = NSTextAttachment.init()
            textAttachment.image = #imageLiteral(resourceName: "details_clock_icon")
            textAttachment.bounds = CGRect.init(x: 0, y: -1, width: 12, height: 12)
            let attachment = NSAttributedString.init(attachment: textAttachment)
            attributedString.append(totalDescStr)
            attributedString.append(attachment)
            attributedString.append(titleAttributedString)
//            attributedString.append(NSAttributedString.init(string: "\n"))
            tempDesc = ""
        }
        
        //desc
        
        
        if tempDesc.count > 0{
            let contentAttribute = [NSAttributedString.Key.font:
                UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular),
                                    NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "666666"),NSAttributedString.Key.paragraphStyle : paragraphStyle]
            let contentAttributedString = NSMutableAttributedString(
                string: " " + tempDesc,
                attributes: contentAttribute)
            let textAttachment = NSTextAttachment.init()
            textAttachment.image = #imageLiteral(resourceName: "info_icon")
            textAttachment.bounds = CGRect.init(x: 0, y: -1.5, width: 12, height: 12)
            let attachment = NSAttributedString.init(attachment: textAttachment)
            attributedString.append(NSAttributedString.init(string: " "))
            attributedString.append(attachment)
            attributedString.append(contentAttributedString)
            attributedString.append(NSAttributedString.init(string: "\n"))
        }
        
        return attributedString
        
    }
    // MARK: - loading suggestion specific View
    func loadPlayerItemDetails(playItemObj:PageContentResponse) {
        infoBtn.isHidden = true
        self.popupHeightconstraint.constant = 60
        for pageData in playItemObj.data {
            if pageData.paneType == .content {
                let content = pageData.paneData as? Content
                iconImageView.loadingImageFromUrl(content?.posterImage ?? "", category: "tv")
                self.programLabel.text = content?.title
                //                var row = 1
                channelNameLabel.isHidden = false
                self.channelNameLabel.text = ""
                for dataRow in (content?.dataRows)! {
                   
                        self.iconWidthConstraint.constant = 0
                        for element in dataRow.elements {
                            if element.elementType == .image {
                                self.iconImageView.loadingImageFromUrl(element.data, category: "tv")
                                self.iconWidthConstraint.constant = 43
                            }
                            else if element.elementType == .description {
                                itemDes.description = element.data
                                self.descLabel.text = element.data
                            }
                            else if element.elementType == .text {
                                if element.elementSubtype == "title" {
                                    self.programLabel.text = element.data
                                }
                                else if element.elementSubtype == "subtitle" {
                                    self.channelNameLabel.text = element.data;
                                }
                                if element.elementSubtype == "expiryInfo" && !(element.data .isEmpty) {
                                    self.expiryLabel.text = element.data
                                }
                            }
                        }
                    
                  
                       /* for element in dataRow.elements {
                            if element.elementType == .text && !(element.data .isEmpty) {
                                self.popupLabel.attributedText = getAttributedText(timeString: "", desc: element.data)
                                self.popupLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                                infoBtn.isHidden = true
                                self.popupLabel.sizeToFit()
                            }
                            else {
                                self.popupLabel.attributedText = getAttributedText(timeString: "", desc: "Please Sign in to continue".localized)
                                infoBtn.isHidden = true
                                self.popupLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                                self.popupLabel.sizeToFit()
                            }
                        }*/
                   
                    
                }
                break
            }
        }
        if let channelName = (self.channelNameLabel.text?.last), channelName == "|" {
            self.channelNameLabel.text = self.channelNameLabel.text?.dropLast().description
        }
        
        if self.expiryLabel.text?.count ?? 0 > 0 {
            
            var splitArray = self.expiryLabel!.text!.components(separatedBy: "@")
            
            if splitArray.count > 1 {
                let string1 = splitArray[0]
                splitArray.remove(at: 0)
                let string2 = splitArray.joined(separator:" ")
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (string1 + string2))
                let range1: NSRange = attributedString.mutableString.range(of: string1, options: .caseInsensitive)
                let range2: NSRange = attributedString.mutableString.range(of: string2, options: .caseInsensitive)
                attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.expireTextColor!, range: range1)
                attributedString.addAttribute(.foregroundColor, value: AppTheme.instance.currentTheme.cardTitleColor!, range: range2)
                self.expiryLabel.attributedText = attributedString
            }
            self.expiryLabelTopConstraint.constant = 3
            self.expiryLabelHeightConstraint.constant = 18
            self.expiryLabel.isHidden = false
        }
        else {
            self.expiryLabelTopConstraint.constant = 0
            self.expiryLabelHeightConstraint.constant = 0
            self.expiryLabel.isHidden = true
        }
        
        /*if (self.popupLabel.text? .isEmpty)! {
            self.popupLabel.attributedText = getAttributedText(timeString: "", desc: "Please Sign in to watch the content".localized)
            infoBtn.isHidden = true
            self.popupLabel.sizeToFit()

            self.popUpViewHeight = 109
            self.popupLblHeightConstraint.constant = 50.5
            self.playerInfoViewHeightConstraint.constant = 283
        }
        else {
            self.popUpViewHeight = 109
            self.popupLblHeightConstraint.constant = 50.5
            self.playerInfoViewHeightConstraint.constant = 283
        }
        self.popupHeightconstraint.constant = CGFloat(self.popUpViewHeight)
        */
        
        
        if (self.descLabel.text? .isEmpty)! {
            self.showMoreBtnTitleBtn.isHidden = true
            self.showMoreIconBtn.isHidden = true
        }
        else {
            self.showMoreBtnTitleBtn.isHidden = false
            self.showMoreIconBtn.isHidden = false
            self.descLabel.sizeToFit()
            self.descLabelHeightConstraint.constant = self.itemDes.descriptionHeight
        }
        /*
        if channelObj is Channel {
            programLabel.text = (channelObj as! Channel).programName
            channelNameLabel.text = (channelObj as! Channel).channelName
            self.iconImageView.loadingImageFromUrl((channelObj as! Channel).iconUrl, category: "show")
            
            
            itemDes.description = (channelObj as! Channel).channelDescription
            let timeStr = Date().timeFormattedWithDayName(String( describing: (channelObj as! Channel).programStartTime as NSNumber))
            self.descLabel.attributedText = getAttributedText(timeString: timeStr, desc: (channelObj as! Channel).channelDescription)
            
        }else if channelObj is Epg {
            programLabel.text = (channelObj as! Epg).programName
            channelNameLabel.text = (channelObj as! Epg).channelName
        }
        else if channelObj is ProgramEPG {
            programLabel.text = (channelObj as! ProgramEPG).name
            channelNameLabel.text = (channelObj as! ProgramEPG).langCode
        }
 */
    }
    func setupPlayerItemView(obj:PageContentResponse)
    {

        
        loadPlayerItemDetails(playItemObj:obj)
        
        if self.showhide == true {
            self.descLabelHeightConstraint.constant = 0
        }
        else{
            self.descLabel.sizeToFit()
            self.descLabelHeightConstraint.constant = self.itemDes.descriptionHeight + 1
        }
        
        
        //        showHideButton.addTarget(self, action: #selector(MenuBarReusableView.showHideClicked), for: UIControl.Event.touchUpInside)
        showMoreIconBtn.addTarget(self, action: #selector(MenuBarReusableView.showHideClicked), for: UIControl.Event.touchUpInside)
        showMoreBtnTitleBtn.addTarget(self, action: #selector(MenuBarReusableView.showHideClicked), for: UIControl.Event.touchUpInside)
        //self.popupView.isHidden =
        self.playerInfoView.isHidden = false
        
        /*if showhide == false {
            self.descLabel.isHidden = true
            self.descLabelHeightConstraint.constant = 0
            //            UIView.animate(withDuration:0.1, animations: {
            //                self.showHideButton.transform = CGAffineTransform(rotationAngle: 0)
            /*self.showMoreBtnTitleBtn.setTitle("Show More".localized, for: UIControl.State.normal)
             self.showMoreIconBtn.setImage(#imageLiteral(resourceName: "show_more"), for: UIControl.State.normal)
             self.showMoreViewTopConstraint.constant = 4.0*/
            
            //            })
            //            self.descLabel.backgroundColor = UIColor.green
        }else{
            //            UIView.animate(withDuration:0.1, animations: {
            //                self.showHideButton.transform = CGAffineTransform(rotationAngle: .pi)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(00)) {
                
                self.showMoreBtnTitleBtn.setTitle("Show Less".localized, for: UIControl.State.normal)
                self.showMoreIconBtn.setImage(#imageLiteral(resourceName: "show_less"), for: UIControl.State.normal)
                //            })
                self.descLabelHeightConstraint.constant = self.itemDes.descriptionHeight + 5
                self.showMoreViewTopConstraint.constant = self.itemDes.descriptionHeight
                self.descLabel.isHidden = false
            }
            //            self.descLabel.backgroundColor = UIColor.red
        }*/
        //        self.playerInfoViewHeightConstraint.constant = 113
        self.popupHeightconstraint.constant = CGFloat(self.popUpViewHeight)
        self.tabCollectionHeightConstraint.constant = 47
        self.setUpCommonly()
        
    }
    // MARK: - showHide button action Clicked
    
    @objc func showHideClicked() {
       
    }
    @IBAction func ShowHideDescriptionButtonClicked(_ sender: Any) {
       
        var tempDescLabelHeight = 0.0
        if self.showhide == true {
            self.showhide = false
            self.ShowHideDescriptionButton?.setImage(UIImage.init(named: "cellDropDownArrow"), for: .normal)
            self.descLabel.sizeToFit()
            tempDescLabelHeight = Double(itemDes.descriptionHeight)
            self.descLabelHeightConstraint.constant = self.itemDes.descriptionHeight + 1
            if self.castInfo?.sectionData.data.count ?? 0 > 0 {
                self.castTableView.isHidden = false
                self.castTableView.reloadData()
                self.castTableViewBottomConstraint.constant = 10
                self.castTableViewHeightConstraint.constant = 75
            }
            else{
                self.castTableView.isHidden = true
                self.castTableViewBottomConstraint.constant = 0
                self.castTableViewHeightConstraint.constant = 0
            }
        }
        else {
            self.showhide = true
            self.ShowHideDescriptionButton?.setImage(UIImage.init(named: "cellDropDownUpArrow"), for: .normal)
            self.descLabelHeightConstraint.constant = 0
            self.castTableView.isHidden = true
            self.castTableViewBottomConstraint.constant = 0
            self.castTableViewHeightConstraint.constant = 0
        }
        self.tabMenuDelegate.ShowHideDescriptionInHeader?(showHide: self.showhide, descHeight: CGFloat(tempDescLabelHeight))
    }
    @IBAction func signUpClicked(_ sender: Any) {
        self.tabMenuDelegate.goToSignUp!()
    }
    
    @IBAction func downloadBtnClicked(_ sender: Any) {
        self.tabMenuDelegate.downloadBtnClicked?()
    }
    @IBAction func signInClicked(_ sender: Any) {
        self.tabMenuDelegate.goToSignIn!()
    }
    
    @IBAction func subscribeClicked(_ sender: Any) {
        self.tabMenuDelegate.goToSubscribePage!()
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject)
    {
        self.tabMenuDelegate.goToShare!()
    }
    @IBAction func hideKeyBoardButtonClicked(sender: AnyObject) {
        self.tabMenuDelegate.HideKeyboardButtonClicked?()
    }
    @IBAction func RateNowButtonClicked() {
        self.tabMenuDelegate.RateNowButtonClickedInHeader?()
    }
    
    @IBAction func WatchPartyButtonClicked(_ sender: Any) {
        self.tabMenuDelegate.DisplayWatchPartyView?()
    }
    func setIndexTabCell(index:Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            if self.toolBarTitlesArray.count > 0 {
                self.menuCollection.reloadData()
                self.menuCollection.selectItem(at: NSIndexPath.init(item: index, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
                self.menuCollection.scrollToItem(at: NSIndexPath.init(item: index, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
            }
        }
        if AppDelegate.getDelegate().isPlayerPage {
            let yuppFLixUserDefaults = UserDefaults.standard
            yuppFLixUserDefaults.set(true, forKey: "PlayerShowCaseView")
            if yuppFLixUserDefaults.object(forKey: "PlayerShowCaseView") == nil {
                self.playerCouchScreen.isHidden = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowPlayerCouchScreen"), object: nil, userInfo: nil)
//                self.presentShowCaseView(withText: "Navigate through the channel’s catch-up right from the player page.", forView: self.menuCollection)
                yuppFLixUserDefaults.set(true, forKey: "PlayerShowCaseView")
            }
        }
    }
    
    @IBAction func favouriteBtnClicked(_ sender: Any) {
        self.tabMenuDelegate.favbtnClicked!()
    }

    @objc func hidePlayerCouchScreen() {
        self.playerCouchScreen.isHidden = true
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

    // MARK: - Navigation
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.toolBarTitlesArray.count > 0 ? self.toolBarTitlesArray.count : 0)
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if productType.iPad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuTabColViewCell-iPad", for: indexPath) as! subMenuTabColViewCelliPad
            Log(message: "cellForItemAt 1 \(indexPath.item)")
            cell.titleLabel.text = self.toolBarTitlesArray[indexPath.item].title
            if cell.isSelected {
                cell.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
                cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
            }
            else {
                cell.titleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                cell.bottomBar.backgroundColor = UIColor.clear
            }
            if cell.titleLabel.text == "" {
                cell.cvImageView?.isHidden = true
                cell.cvImageView?.image = UIImage.init(named: "img_watchparty_circle")
                cell.bottomBar.backgroundColor = .clear
            }
            else{
                cell.cvImageView?.isHidden = true
                cell.cvImageView?.image = UIImage.init(named: "")
            }
            
//            if cell.isSelected {
//                if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
//                    if self.isNetworkContent {
//                        cell.titleLabel.textColor = UIColor.white
//                        cell.bottomBar.backgroundColor = UIColor.white
//                    } else {
//                        cell.titleLabel.textColor = UIColor.init(hexString: "0f1214")
//                        cell.bottomBar.backgroundColor = UIColor.init(hexString: "d90738")
//                    }
//                }
//                else {
//                    cell.titleLabel.textColor = UIColor.white
//                    cell.bottomBar.backgroundColor = UIColor.white
//                }
//            }
//            else {
//                if AppDelegate.getDelegate().isPlayerPage{
//                    cell.titleLabel.textColor = UIColor.tabBarDimGray
//                    cell.bottomBar.backgroundColor = UIColor.clear
//                } else if AppDelegate.getDelegate().isDetailsPage {
//                    if self.isNetworkContent {
//                        cell.titleLabel.textColor = UIColor.white.withAlphaComponent(0.4)
//                        cell.bottomBar.backgroundColor = UIColor.clear
//                    } else {
//                        cell.titleLabel.textColor = UIColor.tabBarDimGray
//                        cell.bottomBar.backgroundColor = UIColor.clear
//                    }
//                }
//                else {
//                    cell.titleLabel.textColor = UIColor.tabBarDimGray
//                    cell.bottomBar.backgroundColor = UIColor.clear
//                }
//            }
            return cell
        }
        else {
            
            if isNetworkContent {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "langCollectionViewCell", for: indexPath) as! langColViewCell
                Log(message: "cellForItemAt 1 \(indexPath.item)")
                cell.titleLabel.text = self.toolBarTitlesArray[indexPath.item].title
                if cell.isSelected {
                    cell.titleLabel.textColor = UIColor.white
                    cell.bottomBar.backgroundColor = UIColor.white
                }
                else {
                    cell.titleLabel.textColor = UIColor.tabBarDimGray
                    cell.bottomBar.backgroundColor = UIColor.clear
                }
                return cell

            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuTabColViewCell", for: indexPath) as! subMenuTabColViewCell
                Log(message: "cellForItemAt 1 \(indexPath.item)")
                cell.titleLabel.text = self.toolBarTitlesArray[indexPath.item].title
                if cell.isSelected {
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.themeColor
                    cell.bottomBar.backgroundColor = AppTheme.instance.currentTheme.lineColor
                    if appContants.appName == .gac {
                        cell.titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                        cell.bottomBar.backgroundColor = .clear
                        cell.contentMode = .left
                        cell.titleLabel.textAlignment = .left
                        cell.titleLabel.font = UIFont.ottRegularFont(withSize: 14)
                    }
                }
                else {
                    cell.titleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                    cell.bottomBar.backgroundColor = UIColor.clear
                }
                if cell.titleLabel.text == "" {
                    cell.cvImageView?.isHidden = true
                    cell.cvImageView?.image = UIImage.init(named: "img_watchparty_circle")
                    cell.bottomBar.backgroundColor = .clear
                }
                else{
                    cell.cvImageView?.isHidden = true
                    cell.cvImageView?.image = UIImage.init(named: "")
                }

//                if cell.isSelected {
//                    if AppDelegate.getDelegate().isPlayerPage || AppDelegate.getDelegate().isDetailsPage{
//                        if self.isNetworkContent {
//                            cell.titleLabel.textColor = UIColor.white
//                            cell.bottomBar.backgroundColor = UIColor.white
//                        } else {
//                            cell.titleLabel.textColor = UIColor.init(hexString: "0f1214")
//                            cell.bottomBar.backgroundColor = UIColor.init(hexString: "d90738")
//                        }
//                    }
//                    else {
//                        cell.titleLabel.textColor = UIColor.white
//                        cell.bottomBar.backgroundColor = UIColor.white
//                    }
//                }
//                else {
//                    if AppDelegate.getDelegate().isPlayerPage{
//                        cell.titleLabel.textColor = UIColor.tabBarDimGray
//                        cell.bottomBar.backgroundColor = UIColor.clear
//                    } else if AppDelegate.getDelegate().isDetailsPage {
//                        if self.isNetworkContent {
//                            cell.titleLabel.textColor = UIColor.white.withAlphaComponent(0.4)
//                            cell.bottomBar.backgroundColor = UIColor.clear
//                        } else {
//                            cell.titleLabel.textColor = UIColor.tabBarDimGray
//                            cell.bottomBar.backgroundColor = UIColor.clear
//                        }
//                    }
//                    else {
//                        cell.titleLabel.textColor = UIColor.tabBarDimGray
//                        cell.bottomBar.backgroundColor = UIColor.clear
//                    }
//                }
                return cell

            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if productType.iPad {
            return CGSize(width: 180, height: 47)
        }
        else {
            let width = self.toolBarTitlesArray[indexPath.item].answerHeight
            Log(message: "menu size: \(CGSize(width: width, height: 47))")
            return CGSize(width: width, height: 47)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.menuCollection.reloadData()
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.tabMenuDelegate.didSelectedItem(item: indexPath.item)
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        print("menu secInsets: ", secInsets)
        return  secInsets
    }
 */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let elements_count = self.titlearray.count
        
        let cellCount = CGFloat(elements_count)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 && !self.showLeftAlignment{
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
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 2)
            }
        }
        if tabTitlearray.count > 0 || titlearray.count > 0{
            // Tabs
            return secInsets
        }
        return UIEdgeInsets.zero
    }
    

    
    // MARK: - TableView methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == detailTableView {
            return 1
        } else {
            return (castInfo?.sectionData.data.count ?? 0 > 0 ? 1: 0)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == detailTableView {
            if isRecipe {
                return 3
            }
            return 2
            
        } else {
            return 1
        }
    }
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == detailTableView {
            if indexPath.row == 0 {
                let cell = detailTableView.dequeueReusableCell(withIdentifier: "buttonstack") as! gacTopTableViewCell
                if self.isFavourite {
                    cell.favImage.image = UIImage(named: "group_4302")
                } else {
                    cell.favImage.image = UIImage(named: "group_4303")
                }
                cell.fav.addTarget(self, action: #selector(self.favouriteTap), for: .touchUpInside)
                cell.download.addTarget(self, action: #selector(self.downloadTap), for: .touchUpInside)
                cell.share.addTarget(self, action: #selector(self.cellShareTap) , for: .touchUpInside)
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                self.buttonsFlag(cell: cell, isFavNA: !favButton, isDownloadNA: !downloadButton, isShareNA: !shareButton)
                return cell
                
            } else if indexPath.row == 1 {
                
                let cell = detailTableView.dequeueReusableCell(withIdentifier: "descriptionCell") as! gacMiddleTableViewCell
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
                                    if element.elementType == .description {
                                        self.isDescriptionNA = false
                                        let paragraphStyle = NSMutableParagraphStyle()
                                        paragraphStyle.lineSpacing = 1.5
                                        let descriptionAttributes = [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 12.0),NSAttributedString.Key.foregroundColor: AppTheme.instance.currentTheme.cardSubtitleColor,NSAttributedString.Key.paragraphStyle : paragraphStyle]
                                        let descriptionAttributedString = NSMutableAttributedString(string: element.data, attributes: descriptionAttributes as [NSAttributedString.Key : Any])
                                        let attrString = NSMutableAttributedString()
                                        attrString.append(descriptionAttributedString)
                                        self.movieDescriptionText = attrString.string
                                    }
                                }
                            }
                        }
                    }
                }
                cell.describe.text = String(reflecting:movieDescriptionText)
                cell.describe.textColor = AppTheme.instance.cardSubtitleColor
                cell.describe.font = UIFont.ottRegularFont(withSize: 10)
                cell.selectionStyle = .none
                return cell
                
            } else if indexPath.row == 2 {
                
                let cell = detailTableView.dequeueReusableCell(withIdentifier: "morewebview") as! gacBottomTableViewCell
                cell.moreBtn.backgroundColor = AppTheme.instance.currentTheme.submenuBgColor
                cell.moreBtn.titleLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
                cell.moreBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
                cell.moreBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .highlighted)
                cell.moreBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .selected)
                cell.moreBtn.addTarget(self, action: #selector(MenuBarReusableView.more), for: .touchUpInside)
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: cell.contentView.bounds.width, bottom: 0, right: 0)
                return cell
            }
        } else {
            let identifier = "CastTableViewCell"
            
            let cell = castTableView.dequeueReusableCell(withIdentifier: identifier) as! CastTableViewCell
            
            if castInfo?.sectionInfo.dataType == "actor" {
                
                if self.castCrewArray.count > 0 {
                    self.castCrewArray.removeAll()
                }
                for card in (castInfo?.sectionData.data)! {
                    let display = card.display
                    let castCrewObj = CastCrewModel.init(withImageUrl: display.imageUrl, castName: display.title, castType: display.subtitle1, castCode: card.target.path)
                    self.castCrewArray.append(castCrewObj)
                }
                cell.setUpData(cast: self.castCrewArray)
                castTableView.isHidden = false
                castTableView.backgroundColor = .clear
                cell.delegate = self
            }
            return cell
        }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.detailTableView {
            
            if indexPath.row == 0 {
                return 90.0
            } else if indexPath.row == 1 {
                return 64.0
            } else if indexPath.row == 2 {
                return 66.0
            }
        } else {
        
            if castInfo?.sectionInfo.dataType == "actor" {
                return 75
            }
            return 0
        }
        return 0
    }
    
    
    
    @objc func more() {
        let newVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "PartialWebViewViewController") as! PartialWebViewViewController
        newVC.contentDetailResponse = self.contentDetailResponse
        let nav = UINavigationController.init(rootViewController: newVC)
        nav.navigationBar.isHidden = true
        let controller = self.getCurrentViewController()
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        newVC.viewHeight = UIScreen.main.bounds.height - statusBarHeight - self.playerHeight!
        controller?.present(nav, animated: true, completion: nil)
    }
    @objc func cellShareTap() {
        self.tabMenuDelegate.goToShare!()
    }
    
    @objc func shareTap(sender: AnyObject) {
        let title = self.contentDetailResponse?.shareInfo.name
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
                activityVC.popoverPresentationController?.sourceView = self
                let tempShareBtn:UIButton = sender as! UIButton
                activityVC.popoverPresentationController?.sourceRect = tempShareBtn.frame
            }
            self.parentViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func downloadTap() {
        print("download")
    }
    
    @objc func downloadPDF() {
        
    }
    @objc func favouriteTap() {
        if OTTSdk.preferenceManager.user != nil {
            AppDelegate.isFavouriteClicked = true
            if self.isFavourite {
                self.startAnimating(allowInteraction: false)
                LocalyticsEvent.tagEventWithAttributes("Favourite_CTA", ["Partners":"", "Language":OTTSdk.preferenceManager.selectedLanguages, "Actions":"Removed"])
                OTTSdk.userManager.deleteUserFavouriteItem(pagePath: (self.contentDetailResponse?.info.path)!, onSuccess: { (response) in
                    self.stopAnimating()
                    self.isFavourite = false
                    AppDelegate.getDelegate().isListPageReloadRequired = true
                    self.detailTableView.reloadData()
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
                    self.detailTableView.reloadData()
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
        self.detailTableView.reloadData()
    }
    
    
    func startAnimating(allowInteraction:Bool) {
        self.isUserInteractionEnabled = allowInteraction
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = allowInteraction
        AppDelegate.getDelegate().activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.isUserInteractionEnabled = true
        AppDelegate.getDelegate().window?.isUserInteractionEnabled = true
        AppDelegate.getDelegate().activityIndicator.stopAnimating()
    }
    
    func showAlert(_ header : String = String.getAppName(),  message : String) {
        self.parentViewController?.errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    func showAlertWithText (_ header : String = String.getAppName(),  message : String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let messageAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.parentViewController?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(messageAlertAction)
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSignInWithText (_ header : String = String.getAppName(),  message : String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let messageAlertAction = UIAlertAction(title: "Sign in", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let storyBoard = UIStoryboard(name: "Account", bundle: nil)
            let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            storyBoardVC.viewControllerName = "PlayerVC"
            if playerVC != nil{
                playerVC?.showHidePlayerView(true)
                playerVC?.player.pause()
            }
            DispatchQueue.main.async {
                if playerVC != nil && playerVC!.adsManager != nil{
                    playerVC!.adsManager!.pause()
                }
            }
            UIApplication.shared.showSB()
            let topVC = UIApplication.topVC()!
            topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
        })
        alert.addAction(messageAlertAction)
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        alert.addAction(cancelAlertAction)
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func RefreshFavoriteContent() {
        
        self.sectionDetailsObjArr.removeAll()
        self.refreshData()
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
//            self.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.detailTableView.reloadData()
            }
        }) { (error) in
            self.stopAnimating()
        }
    }
    func getCurrentViewController() -> UIViewController? {

        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil

    }
    
    func buttonsFlag(cell: gacTopTableViewCell, isFavNA: Bool, isDownloadNA: Bool, isShareNA: Bool) {
        
        var totalButton = 3
        
        if isFavNA {
            totalButton = totalButton - 1
        }
        if isDownloadNA {
            totalButton = totalButton - 1
        }
        if isShareNA {
            totalButton = totalButton - 1
        }
        
        switch totalButton {
        case 3:
            cell.seperators.isHidden = false
            cell.seperator.isHidden = true
        case 2:
            cell.seperators.isHidden = true
            cell.seperator.isHidden = false
            
            if isFavNA {
                cell.favImage.image = cell.downloadImage.image
                cell.favLbl.text = cell.downloadLbl.text
                cell.fav.removeTarget(self, action: #selector(self.favouriteTap), for: .touchUpInside)
                cell.fav.addTarget(self, action: #selector(self.downloadTap), for: .touchUpInside)
            } else if isShareNA {
                cell.shareImage.image = cell.downloadImage.image
                cell.shareLbl.text = cell.downloadLbl.text
                cell.share.removeTarget(self, action: #selector(self.cellShareTap) , for: .touchUpInside)
                cell.share.addTarget(self, action: #selector(self.downloadTap), for: .touchUpInside)
            }
            cell.downloadView.isHidden = true
        case 1:
            
            if !isFavNA {
                cell.downloadImage.image = cell.favImage.image
                cell.downloadLbl.text = cell.favLbl.text
                cell.download.removeTarget(self, action: #selector(self.downloadTap), for: .touchUpInside)
                cell.download.addTarget(self, action: #selector(self.favouriteTap), for: .touchUpInside)
            } else if !isShareNA {
                cell.downloadImage.image = cell.shareImage.image
                cell.downloadLbl.text = cell.shareLbl.text
                cell.download.removeTarget(self, action: #selector(self.downloadTap), for: .touchUpInside)
                cell.download.addTarget(self, action: #selector(self.cellShareTap), for: .touchUpInside)
            }
            cell.shareView.isHidden = true
            cell.favView.isHidden = true
            cell.seperator.isHidden = true
            cell.seperators.isHidden = true
        default:
            cell.seperators.isHidden = true
            cell.seperator.isHidden = true
        }
    }
}
