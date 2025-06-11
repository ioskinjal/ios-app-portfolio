//
//  MoviesVC.swift
//  sampleColView
//
//  Created by Ankoos on 30/05/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk
class FavouritesListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PlayerViewControllerDelegate,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol {
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noContentLbl: UILabel!
    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var navigationBarView: UIView!
    
    @IBOutlet weak var navigationBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorView: UIView!
    
    var goGetTheData:Bool = true
    var noContentFlag:Bool = false
    var sections = [Card]()
    var section:Section?
    var pageFilters = [Filter]()
    var isToViewMore = false
    var sectionTitle = ""
    var bannerData = [Banner]()
    var lastIndex = -1
    var secInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 5.0, right: 5.0)
    var numColums: CGFloat = 3
    var interItemSpacing: CGFloat = 0
    var minLineSpacing: CGFloat = 13
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var cCFL: CustomFlowLayout!
    var pageResponse : PageContentResponse!
    var targetPath = ""
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    
    public class var instance: FavouritesListViewController {
        struct Singleton {
            static let obj = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "FavouritesListViewController") as! FavouritesListViewController
        }
        return Singleton.obj
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
    @IBAction func Refresh(_ sender: Any) {
        /**/
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            OTTSdk.mediaCatalogManager.pageContent(path: self.targetPath, onSuccess: { (response) in
                print(response)
                self.pageResponse = response
                self.sections.removeAll()
                self.bannerData.removeAll()
                self.setResponseData()
                self.refreshControl.endRefreshing()
                self.moviesCollection.reloadData()
            }) { (error) in
                self.refreshControl.endRefreshing()
                print(error.message)
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.noContentLbl.text = "No Content available".localized
        self.sectionLabel.text = "Favorites".localized
        self.sectionLabel.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        if self.sections.count > 0 {
            moviesCollection.reloadData()
            self.errorView.isHidden = true
        }
        else {
            self.errorView.isHidden = false
            moviesCollection.reloadData()
        }
        //        LocalyticsEvent.tagEventWithAttributes("Favorites_Menu", [String:String]())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.getDelegate().sourceScreen = "Favorites_Page"
    }
    
    func getUserFavoritesList(isFinished : @escaping (Bool) -> Void) {
        self.startAnimating(allowInteraction: false)
        self.sections = [Card]()
        OTTSdk.userManager.getUserFavouritesList(onSuccess: { (response) in
            if response.count > 0 {
                if let cardsResponse = response.first{
                    self.lastIndex =  cardsResponse.lastIndex
                    if cardsResponse.data.count > 0{
                        self.goGetTheData = true
                        self.sections.append(contentsOf: cardsResponse.data)
                        self.moviesCollection.reloadData()
                    }
                    else {
                        self.sections.removeAll()
                    }
                }
                
                if self.sections.count > 0 {
                    self.errorView.isHidden = true
                    self.moviesCollection.isHidden = false
                }
                else {
                    self.errorView.isHidden = false
                    DispatchQueue.main.async {
                        self.moviesCollection.reloadData()
                        self.moviesCollection.isHidden = true
                    }
                }
            }
            else {
                self.errorView.isHidden = false
                self.moviesCollection.isHidden = true
            }
            self.stopAnimating()
            isFinished(true)
            
        }) { (error) in
            print(error.message)
            self.stopAnimating()
            isFinished(true)
        }
    }
    
    func setResponseData() {
        if pageResponse.data.count == 0{
            return
        }
        guard let _section = pageResponse.data[0].paneData as? Section else{
            return
        }
        sections = _section.sectionData.data
        self.lastIndex = _section.sectionData.lastIndex
        self.section = _section
        if sections.count > 0 {
            self.errorView.isHidden = true
        }
        else {
            self.errorView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationBarView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        //        self.view.backgroundColor = UIColor.appBackgroundColor
        self.noContentLbl.text = "No Content available".localized
        self.noContentLbl.textColor = AppTheme.instance.currentTheme.noContentAvailableTitleColor
        self.sectionLabel.text = "Favorites".localized
        self.noContentLbl.textColor = UIColor.init(hexString:"37393c")
        self.noContentLbl.font = UIFont.ottBoldFont(withSize: 20.0)
        self.navigationBarView.isHidden = false
        self.moviesCollection.delegate = self
        self.moviesCollection.dataSource = self
        //        if isToViewMore {
        //            self.sectionLabel.text = sectionTitle
        //            self.collectionViewTopConstraint.constant = 67.0
        //            self.navigationBarView.isHidden = false
        //            self.pageFilters = pageResponse.filters
        //            if self.pageFilters.count > 0 {
        //                self.collectionViewTopConstraint.constant = 127.0
        //            }
        //        }
        //        else {
        //            self.navigationBarViewHeightConstraint.constant = 0
        //            self.pageFilters = pageResponse.filters
        //            if self.pageFilters.count > 0 {
        //                self.collectionViewTopConstraint.constant = 60.0
        //            }
        //        }
        
        refreshControl.tintColor = UIColor.activityIndicatorColor()
        refreshControl.addTarget(self, action: #selector(Refresh(_:)), for: .valueChanged)
        moviesCollection.addSubview(refreshControl)
        
        moviesCollection.register(UINib(nibName: SearchCommonPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLV.identifier)
        moviesCollection.register(UINib(nibName: SearchCommonPosterCellLViPad.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLViPad.identifier)
        
        
        cCFL = CustomFlowLayout()
        cCFL.interItemSpacing = interItemSpacing
        cCFL.secInset = secInsets
        cCFL.minLineSpacing = minLineSpacing
        self.calculateNumCols()
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        moviesCollection.collectionViewLayout = cCFL
        
        self.title = "Home".localized
        
        secInsets = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 15.0)
        numColums = 2
        interItemSpacing = 10
        minLineSpacing = 10
        
        //        self.getBannerData()
        // Do any additional setup after loading the view.
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
    
    func calculateNumCols() {
        if productType.iPad {
            if currentOrientation().portrait {
                numColums = 5
            } else if currentOrientation().landscape {
                numColums = 7
            }
            for card in sections {
                if card.cardType == .roller_poster {
                    if currentOrientation().portrait {
                        numColums = 5
                    } else if currentOrientation().landscape {
                        numColums = 7
                    }
                }
                else {
                    if currentOrientation().portrait {
                        numColums = 2
                    } else if currentOrientation().landscape {
                        numColums = 3
                    }
                }
            }
        } else {
            if currentOrientation().portrait {
                numColums = 3
            } else if currentOrientation().landscape {
                numColums = 5
            }
            for card in sections {
                if card.cardType == .roller_poster {
                    if currentOrientation().portrait {
                        numColums = 3
                    } else if currentOrientation().landscape {
                        numColums = 5
                    }
                }
                else {
                    numColums = 1
                }
            }
        }
        
        cCFL.numberOfColumns = numColums
        print("numColums: ", self.numColums)
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
        return self.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let channelObj = self.sections[indexPath.item]
        if channelObj.cardType == .roller_poster {
            collectionView.register(UINib(nibName: "RollerPosterGV", bundle: nil), forCellWithReuseIdentifier: "RollerPosterGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterGV.identifier, for: indexPath) as! RollerPosterGV
            cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "potrait")
            cell.name.text = channelObj.display.title
            cell.desc.text = channelObj.display.subtitle1
            cell.expiryInfoLbl.text = ""
            cell.expiryInfoLbl.isHidden = true
            cell.leftOverTimeLabel.isHidden = true
            cell.leftOverLabelHeightConstraint.constant = 0.0
            cell.gradientImageView.isHidden = true
            cell.tagLbl.isHidden = true
            cell.tagImgView.isHidden = true
            if (indexPath as NSIndexPath).row + 1 == self.sections.count
            {
                if self.noContentFlag == false {
                    self.sectionsMetadata()
                }
            }
            cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
            cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
            cell.recordBtn.isHidden = true
            cell.stopRecordingBtn.isHidden = true
            for marker in channelObj.display.markers {
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
                    cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
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
                cell.iconView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
            }else {
                cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            }
            cell.imageView.layer.cornerRadius = 4.0
            cell.visulEV.blurRadius = 5
            cell.layer.cornerRadius = 4.0
            
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
                    cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                        cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                        cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                    }
                }
            }
            
            return cell
            
        }
        else if channelObj.cardType == .sheet_poster {
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
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
            }else {
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            }
            cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
            cell.imageView.layer.cornerRadius = 4.0
            cell.watchedProgressView.isHidden = true
            cell.layer.cornerRadius = 4.0
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
                    cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
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
            if appContants.appName != .aastha && appContants.appName != .gac {
                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
            }
            let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
            let tempHeight = tempWidth * 0.5625
            cell.imageViewHeightConstraint.constant = tempHeight
            cell.cornerDesignForCollectionCell()
            return cell
            
        }
        else if channelObj.cardType == .overlay_poster {
            
            if productType.iPad {
                let cardDisplay = channelObj.display
                collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                //                cell.backgroundColor = UIColor.red
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
                    }
                    
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else {
                let cardDisplay = channelObj.display
                collectionView.register(UINib(nibName: "OverlayPosterGV", bundle: nil), forCellWithReuseIdentifier: "OverlayPosterGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverlayPosterGV", for: indexPath) as! OverlayPosterGV
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                cell.badgeLbl.text = ""
                cell.badgeLbl.isHidden = true
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                cell.iconImageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                if cardDisplay.parentIcon .isEmpty {
                    cell.iconImageView.isHidden = true
                } else {
                    cell.iconImageView.isHidden = false
                }
                cell.watchedProgressView.isHidden = true
                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                cell.cornerDesignForCollectionCell()
                cell.liveTagLbl.isHidden = true
                for marker in cardDisplay.markers {
                    if marker.markerType == .badge {
                        cell.liveTagLbl.isHidden = false
                        cell.liveTagLbl.text = marker.value
                        cell.liveTagLbl.sizeToFit()
                        cell.liveTagLblWidthConstraint.constant = (cell.liveTagLbl.frame.size.width + 20) < cell.frame.size.width ? cell.liveTagLbl.frame.size.width + 20 : cell.frame.size.width
                        cell.liveTagLbl.backgroundColor = UIColor.init(hexString: marker.bgColor)
                    }
                    if marker.markerType == .exipiryInfo || marker.markerType == .expiryInfo {
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
                return cell
            }
        }        else if channelObj.cardType == .box_poster {
            collectionView.register(UINib(nibName: "BoxPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "BoxPosterCellLV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellLV.identifier, for: indexPath) as! BoxPosterCellLV
            let cardInfo = channelObj.display
            if !cardInfo.parentIcon .isEmpty {
                cell.imageView.loadingImageFromUrl(cardInfo.parentIcon, category: "tv")
            }else {
                cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
            }
            cell.imageView.layer.cornerRadius = 4.0
            cell.name.text = cardInfo.title
            cell.desc.text = cardInfo.subtitle1
            cell.layer.cornerRadius = 4.0
            return cell
            
        }
        else if channelObj.cardType == .pinup_poster {
            let cardDisplay = channelObj.display
            collectionView.register(UINib(nibName: "PinupPosterCellLV", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellLV")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellLV", for: indexPath) as! PinupPosterCellLV
            cell.desc.text = cardDisplay.title
            cell.name.text = cardDisplay.subtitle1
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
            }else {
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            }
            cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            cell.imageView.viewCornerDesign()
            cell.viewWithTag(1)?.viewCornerDesign()
            cell.visulEV.blurRadius = 5
            cell.viewCornerDesign()
            return cell
            
        }
            //        else if channelObj.cardType == .content_poster {
            //            collectionView.register(UINib(nibName: ContentPosterCellEpgGV.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgGV.identifier)
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgGV.identifier, for: indexPath) as! ContentPosterCellEpgGV
            //            let cardInfo = channelObj.display
            //            if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
            //                cell.imageView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            //            }
            //            else {
            //                cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
            //            }
            //            cell.markerLbl.isHidden = true
            //            cell.nowPlayingStrip.isHidden = true
            //            for marker in cardInfo.markers {
            //                if marker.markerType == .badge {
            //                    cell.markerLbl.isHidden = false
            //                    cell.markerLbl.text = marker.value
            //                    cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
            //                    cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
            //                }
            //                else if marker.markerType == .special && marker.value == "now_playing" {
            //                    cell.nowPlayingStrip.isHidden = false
            //                }
            //            }
            //            cell.name.text = cardInfo.title
            //            if cardInfo.parentName .isEmpty {
            //                cell.desc.text = cardInfo.subtitle1
            //            }
            //            else {
            //                if channelObj.cardType == .live_poster {
            //                    cell.desc.text = cardInfo.parentName
            //                }
            //                else {
            //                    cell.desc.text = cardInfo.subtitle1
            //                }
            //            }
            //                            cell.layer.cornerRadius = 5.0
            //                return cell
            //
            //        }
        else if channelObj.cardType == .live_poster || channelObj.cardType == .content_poster{
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
                    cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                    if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
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
            cell.layer.cornerRadius = 4.0
            return cell
        }
        else if channelObj.cardType == .icon_poster {
            let cardDisplay = channelObj.display
            collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
            cell.name.text = cardDisplay.title
            if !cardDisplay.parentIcon .isEmpty {
                cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
            }else {
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
            }
            cell.viewCornerDesign()
            return cell
            
        }
        else {
            if productType.iPad {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLViPad.identifier, for: indexPath) as! SearchCommonPosterCellLViPad
                cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "tv")
                cell.name.text = channelObj.display.title
                cell.desc.text = channelObj.display.subtitle1
                cell.subDesc.text = channelObj.display.subtitle2
                
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in channelObj.display.markers {
                    if marker.markerType == .badge {
                        cell.viewWithTag(1)?.isHidden = false
                        cell.viewWithTag(1)?.backgroundColor = UIColor.init(hexString: marker.bgColor)
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.markerLabel.text = marker.value
                        cell.redDotView.isHidden = true
                        break
                    }
                    else if marker.markerType == .special {
                        cell.viewWithTag(1)?.isHidden = true
                        
                        if marker.value == "live_dot" {
                            cell.redDotView.isHidden = false
                            cell.nameXPositionConstraint.constant = 20.0
                            cell.redDotView.layer.cornerRadius = cell.redDotView.frame.size.width/2.0
                        }
                    }
                    else if (marker.markerType == .duration || marker.markerType == .leftOverTime) && !(marker.value .isEmpty) {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else if marker.markerType == .tag {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else if marker.markerType == .rating {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
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
                        cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                        cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                        if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                if channelObj.display.markers.count == 0 {
                    cell.viewWithTag(1)?.isHidden = true
                }
                else {
                    cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                }
                cell.imageView.layer.cornerRadius = 4.0
                cell.layer.cornerRadius = 4.0
                return cell
                
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLV.identifier, for: indexPath) as! SearchCommonPosterCellLV
                cell.imageView.loadingImageFromUrl(channelObj.display.imageUrl, category: "tv")
                cell.name.text = channelObj.display.title
                cell.desc.text = channelObj.display.subtitle1
                cell.subDesc.text = channelObj.display.subtitle2
                
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in channelObj.display.markers {
                    if marker.markerType == .badge {
                        cell.viewWithTag(1)?.isHidden = false
                        cell.viewWithTag(1)?.backgroundColor = UIColor.init(hexString: marker.bgColor)
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.markerLabel.text = marker.value
                        cell.redDotView.isHidden = true
                        break
                    }
                    else if marker.markerType == .special {
                        cell.viewWithTag(1)?.isHidden = true
                        
                        if marker.value == "live_dot" {
                            cell.redDotView.isHidden = false
                            cell.nameXPositionConstraint.constant = 20.0
                            cell.redDotView.layer.cornerRadius = cell.redDotView.frame.size.width/2.0
                        }
                    }
                    else if (marker.markerType == .duration || marker.markerType == .leftOverTime) && !(marker.value .isEmpty) {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else if marker.markerType == .tag {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
                    }
                    else if marker.markerType == .rating {
                        cell.nameXPositionConstraint.constant = 9.0
                        cell.redDotView.isHidden = true
                        cell.viewWithTag(1)?.isHidden = true
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
                        cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                        cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for:UIControl.Event.touchUpInside)
                        if self.recordingCardsArr.contains(channelObj.display.subtitle5) || self.recordingSeriesArr.contains(channelObj.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                if channelObj.display.markers.count == 0 {
                    cell.viewWithTag(1)?.isHidden = true
                }
                else {
                    cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                }
                cell.imageView.layer.cornerRadius = 4.0
                cell.layer.cornerRadius = 4.0
                return cell
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.bannerData.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: view.frame.width, height: 159)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "bannerCellId", for: indexPath) as! BannerCVC
            //            header.banners = self.bannerData
            // header.bannerDelegate = self
            return header
            
        }else{
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionCard = self.sections[indexPath.item]
        
        if sectionCard.cardType == .roller_poster {
            return CGSize(width: 116, height: 206)
        }
        if sectionCard.cardType == .icon_poster {
            return CGSize(width: 179, height: 132)
        }
        if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster{
            return CGSize(width: 333, height: 73)
        } else if sectionCard.cardType == .sheet_poster {
            let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
            let tempHeight = tempWidth * 0.5625
            if appContants.appName == .gac {
                return CGSize(width: tempWidth, height: tempHeight + 52.0 + 25.0)
            }
            return CGSize(width: tempWidth, height: tempHeight + 52.0)
        } else if sectionCard.cardType == .overlay_poster {
            let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
            let tempHeight = tempWidth * 0.5625
            return CGSize(width: tempWidth, height: tempHeight)
        }
        else {
            if productType.iPad {
                return CGSize(width: 333, height: 123)
            }
            return CGSize(width: 333, height: 73)
        }
    }
    
    //cv delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.startAnimating(allowInteraction: false)
        let channelObj = self.sections[indexPath.item]
        self.didSelectCard(item: channelObj)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.sections.count
        {
            if self.goGetTheData {
                self.goGetTheData = false
                return;
                if (self.section?.sectionData.hasMoreData)! {
                    self.loadMoreData(filterString: nil)
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateNumCols()
        moviesCollection.collectionViewLayout.invalidateLayout()
        moviesCollection.reloadData()
    }
    func getBannerData() {
        /*
         self.startAnimating(allowInteraction: false)
         YuppTVSDK.mediaCatalogManager.banners(sourceType: .yuppTVHome, promoType: .yuppTVPromo, sourceSubtype: "", count: "10", onSuccess: { (bannerList) in
         self.stopAnimating()
         self.bannerData = bannerList
         self.sectionsMetadata()
         }) { (error) in
         print(error.message)
         self.stopAnimating()
         self.sectionsMetadata()
         }
         */
    }
    func sectionsMetadata() {
        /*
         self.noContentFlag = false
         self.startAnimating(allowInteraction: false)
         YuppTVSDK.mediaCatalogManager.premiumMoviesList(count: 20, lastIndex: self.lastIndex, onSuccess: { (result) in
         
         if result.movies.count > 0
         {
         self.sections .append(contentsOf: result.movies)
         self.lastIndex = result.lastIndex
         }else{
         self.noContentFlag = true
         }
         
         self.moviesCollection.isHidden = false
         
         self.moviesCollection.reloadData()
         self.stopAnimating()
         }) { (error) in
         self.stopAnimating()
         self.moviesCollection.reloadData()
         }*/
    }
    func didSelectedSuggestion(card : Card) {
        self.didSelectCard(item: card)
        AppDelegate.getDelegate().sourceScreen = "Favorites_Page"
    }
    
    func didSelectCard(item:Card)  {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        LocalyticsEvent.tagEventWithAttributes("Favorites_Page", ["Language":OTTSdk.preferenceManager.selectedLanguages, "Partners" : "", "Content Name":item.display.title])
        TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
            self.stopAnimating()
            if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = item.display.imageUrl
                vc.playingItemTitle = item.display.title
                vc.playingItemSubTitle = item.display.subtitle1
                vc.playingItemTargetPath = item.target.path
                AppDelegate.getDelegate().window?.addSubview(vc.view)
                //                self.navigationController?.popViewController(animated: true)
            }
            else if viewController is DefaultViewController {
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Content you are looking for is not available".localized)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = item.display.title
                vc.isCircularPoster = item.cardType == .circle_poster ? true : false
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let topVC = UIApplication.topVC()!
                AppDelegate.getDelegate().detailsTabMenuIndex = 0
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        self.Refresh(sender)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
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
                    self.lastIndex =  cardsResponse.lastIndex
                    if cardsResponse.data.count > 0{
                        self.goGetTheData = true
                        self.sections.append(contentsOf: cardsResponse.data)
                        self.moviesCollection.reloadData()
                    }
                }
                
                if self.sections.count > 0 {
                    self.errorView.isHidden = true
                    self.moviesCollection.isHidden = false
                }
                else {
                    self.errorView.isHidden = false
                    self.moviesCollection.isHidden = true
                }
            }
            else {
                self.errorView.isHidden = false
                self.moviesCollection.isHidden = true
            }
            self.stopAnimating()
        }) { (error) in
            self.stopAnimating()
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
        //
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
        //            let alert = UIAlertController(title: String.getAppName(), message: error.message, preferredStyle:UIAlertController.Style.alert)
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
        //
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
    
    func programStopRecordCancelClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
    }
    
}
