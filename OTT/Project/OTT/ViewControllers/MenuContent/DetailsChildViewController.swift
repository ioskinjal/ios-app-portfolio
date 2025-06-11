//
//  ContentRecommendationsViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 14/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol DetailsChildViewControllerDelegate {
    func didSelectedRecommendation(card : Card)
}

struct MainMenuTitle {
    var title : String{
        set{
            barTitle = newValue
            
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 47)
            let boundingBox = barTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
            answerHeight = boundingBox.width + 10
        }
        get{
            return barTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var barTitle = ""
}

class DetailsChildViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,tabMenuProtocal,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol, PartialRenderingViewDelegate, PlayerViewControllerDelegate {
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noRelatedVideosLbl: UILabel!
    var cVL: CustomFlowLayout!
    var secInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    var cellSizes: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 113)
    var numColums: CGFloat = 1
    var interItemSpacing: CGFloat = 0
    var minLineSpacing: CGFloat = 14
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var tabMenuItemNumber:Int = 0
    var delegate : DetailsChildViewControllerDelegate?
    var sectionList = [Tab]()
    var sectionDataList = [Card]()
    var pageDataContent:PageContentResponse?
    var hasMoreData:Bool = false
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var recommendationsCV: UICollectionView!
    var goGetTheData:Bool = true
    var lastIndex:Int = 0
    var tabTitleArr = [String]()
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    @IBOutlet weak var headersCollectionView: UICollectionView!
    @IBOutlet weak var headerColllectionViewHeightConstraint: NSLayoutConstraint!
    var headersList = [Tab]()
    var headersTitleList = [MainMenuTitle]()
    var selectedHeaderRow:Int = 0
    var targetPath = ""
    var isFromDetails = false
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
        recommendationsCV.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.collectionViewLeftConstraint.constant = 5.0
        self.collectionViewRightConstraint.constant = 5.0
        
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        self.recommendationsCV.dataSource = self
        self.recommendationsCV.delegate = self
        
        self.headersCollectionView.dataSource = self
        self.headersCollectionView.delegate = self
        
        self.initData()
        
        self.recommendationsCV.register(UINib(nibName: "MenuBarReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuBarReusableView")
        
        cVL = CustomFlowLayout()
        cVL.cellRatio = false
        cVL.secInset = secInsets
        cVL.cellSize = cellSizes
        cVL.interItemSpacing = (minLineSpacing/numColums) * (numColums-1)
        cVL.minLineSpacing = minLineSpacing
        cVL.scrollDir = scrollDir
        cVL.sectionHeadersPinToVisibleBounds = true
        self.calculateNumCols()
        cVL.setupLayout()
        self.recommendationsCV.collectionViewLayout = cVL
        self.recommendationsCV.isHidden = true
        self.recommendationsCV.isHidden = false
        self.recommendationsCV.reloadData()
        self.headersCollectionView.reloadData()
        self.headerColllectionViewHeightConstraint.constant = 0.0
        self.headersCollectionView.selectItem(at: IndexPath.init(row: selectedHeaderRow, section: 0), animated: true, scrollPosition: .left)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(detailPageRecordButtonStatusChanged(notification:)), name: NSNotification.Name(rawValue: "detailPageRecordButtonStatusChanged"), object: nil)
        
        secInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        numColums = 2
        interItemSpacing = 10
        minLineSpacing = 10
        
        self.recommendationsCV.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
        
        // Do any additional setup after loading the view.
    }
    func initData(){
        headersList = (pageDataContent?.tabsInfo.tabs)!
        self.headersTitleList.removeAll()
        for (index,headerObj) in headersList.enumerated() {
            var toolBarTitleObj = MainMenuTitle()
            toolBarTitleObj.title = headerObj.title
            self.headersTitleList.append(toolBarTitleObj)
            if pageDataContent?.tabsInfo.selectedTab == headerObj.code {
                selectedHeaderRow = index
            }
        }
        self.headersCollectionView.reloadData()
        self.headersCollectionView.selectItem(at: IndexPath.init(row: selectedHeaderRow, section: 0), animated: true, scrollPosition: .left)
        self.loadHeaderData()
    }
    @objc func detailPageRecordButtonStatusChanged(notification: NSNotification){
        let targetPath = notification.userInfo?["targetPath"] as? String
        OTTSdk.mediaCatalogManager.pageContent(path: targetPath!, onSuccess: { (response) in
            self.pageDataContent = response
            self.initData()
            self.stopAnimating()
        }) { (error) in
            
        }
        
    }
    func loadHeaderData(){
        if headersList.count > 0{
            
            //            var tempHeadersList = [Tab]()
            //            tempHeadersList.append(headersList[selectedHeaderRow])
            
            sectionList = headersList
            var tempSectionList = [Tab]()
            var changeSectionList:Bool = false
            if tabMenuItemNumber != AppDelegate.getDelegate().detailsTabMenuIndex {
                tabMenuItemNumber = AppDelegate.getDelegate().detailsTabMenuIndex
            }
            tabMenuItemNumber = 0
            for tab in sectionList {
                if tab.sectionCodes.count > 0 && !tab.sectionCodes.contains(tab.code) {
                    changeSectionList = true
                    for sectionCode in tab.sectionCodes {
                        let tabDetails = Tab()
                        tabDetails.code = sectionCode
                        tabDetails.title = tab.title
                        tabDetails.sectionCodes = tab.sectionCodes
                        tabDetails.infiniteScroll = tab.infiniteScroll
                        tempSectionList.append(tabDetails)
                    }
                }
                else {
                    tempSectionList.append(tab)
                }
            }
            if changeSectionList {
                sectionList = tempSectionList
            }
            tabTitleArr.removeAll()
            self.noRelatedVideosLbl.text = "No suggestions found".localized
            if sectionList.count > 0 {
                var index = 0
                for pageData in (pageDataContent?.data)! {
                    if pageData.paneType == .section {
                        let section = pageData.paneData as? Section
                        if section?.sectionData.section == sectionList[tabMenuItemNumber].code || (sectionList[tabMenuItemNumber].sectionCodes.contains((section?.sectionData.section)!) && tabMenuItemNumber == index) {
                            self.lastIndex = (section?.sectionData.lastIndex)!
                            self.sectionDataList = (section?.sectionData.data)!
                            self.hasMoreData = (section?.sectionData.hasMoreData)!
                            tabTitleArr.append((section?.sectionInfo.name)!)
                        }
                        else if section?.sectionData.section == sectionList[tabMenuItemNumber].code || sectionList[tabMenuItemNumber].sectionCodes.contains((section?.sectionData.section)!){
                            tabTitleArr.append((section?.sectionInfo.name)!)
                        } else {
                            tabTitleArr.append((section?.sectionInfo.name)!)
                        }
                        index = index + 1
                    }
                    print("tabTitleArr \(tabTitleArr)")
                    print("sectionList[tabMenuItemNumber].sectionCodes \(sectionList[tabMenuItemNumber].sectionCodes)")
                    print("headersList[selectedHeaderRow].sectionCodes \(headersList[selectedHeaderRow].sectionCodes)")
                }
                if self.sectionDataList.count == 0 {
                    self.errorView.isHidden = false
                    self.view.sendSubviewToBack(errorView)
                }
                else {
                    self.errorView.isHidden = true
                    self.recommendationsCV.isHidden = false
                }
            }
            else{
                errorView.isHidden = false
            }
        }
        else{
            errorView.isHidden = false
        }
        
        recommendationsCV.reloadData()
        
        
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    // MARK: - Collectionview methods
    func calculateNumCols() {
        if productType.iPad {
            if isFromDetails {
                if currentOrientation().portrait {
                    numColums = 3
                }else if currentOrientation().landscape {
                    numColums = 4
                }else {
                    numColums = 3
                }
            }else {
                if currentOrientation().portrait {
                    numColums = 2
                } else if currentOrientation().landscape {
                    numColums = 3
                }
            }
        }else {
            if currentOrientation().portrait {
                numColums = 3
            } else if currentOrientation().landscape {
                numColums = 5
            }
            for card in self.sectionDataList {
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
        
        cVL.numberOfColumns = numColums
        print("numColums: ", self.numColums)
    }
    
    func setCvFrm() -> Void {
        if scrollDir == .horizontal {
            //            let htCnstr: CGFloat = secInsets.top + secInsets.bottom + cellSizes.height + 20
            //            cVHtCnstr.constant = htCnstr
            //            print("htCnstr", htCnstr)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if productType.iPad {
            if collectionView == headersCollectionView {
                return UIEdgeInsets.zero
            }
            return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 0.0)
        }
        else if collectionView == headersCollectionView {
            return UIEdgeInsets.zero
        }
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headersCollectionView{
            return headersTitleList.count
        }
        else{
            return self.sectionDataList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("rendering cell: ", indexPath.item)
        if collectionView == headersCollectionView{
            if productType.iPad {
                collectionView.register(UINib(nibName: "tabCollectionViewCell-iPad", bundle: nil), forCellWithReuseIdentifier: "tabCollectionViewCelliPad")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCollectionViewCelliPad", for: indexPath) as! tabColViewCelliPad
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = headersTitleList[indexPath.item].title
                return cell
            }
            else {
                
                collectionView.register(UINib(nibName: "subMenuTabColViewCell", bundle: nil), forCellWithReuseIdentifier: "subMenuTabColViewCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subMenuTabColViewCell", for: indexPath) as! subMenuTabColViewCell
                print("cellForItemAt 1", indexPath.item)
                cell.titleLabel.text = headersList[indexPath.item].title
                return cell
            }
        }
        else{
            if self.sectionDataList.count > 0
            {
                let sectionCard = self.sectionDataList[indexPath.item]
                if sectionCard.cardType == .roller_poster {
                    let cardDisplay = sectionCard.display
                    
                    collectionView.register(UINib(nibName: RollerPosterGV.nibname, bundle: nil), forCellWithReuseIdentifier: RollerPosterGV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterGV.identifier, for: indexPath) as! RollerPosterGV
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.expiryInfoLbl.text = ""
                    cell.expiryInfoLbl.isHidden = true
                    cell.gradientImageView.isHidden = true
                    cell.leftOverTimeLabel.isHidden = true
                    cell.leftOverLabelHeightConstraint.constant = 0.0
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "potrait")
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.watchedProgressView.isHidden = true
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
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
                            if self.recordingCardsArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
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
                    return cell
                }
                else if sectionCard.cardType == .band_poster {
                    collectionView.register(UINib(nibName: BandPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: BandPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandPosterCellLV.identifier, for: indexPath) as! BandPosterCellLV
                    let cardInfo = sectionCard.display
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.desc.text = cardInfo.title
                    cell.name.text = cardInfo.subtitle1
                    cell.visulEV.blurRadius = 5
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
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
                else if sectionCard.cardType == .icon_poster {
                    let cardDisplay = sectionCard.display
                    collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
                    cell.name.text = cardDisplay.title
                    if !cardDisplay.parentIcon .isEmpty {
                        cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                    }
                    else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    return cell
                }
                else if sectionCard.cardType == .sheet_poster {
                    if productType.iPad {
                        collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                        let cardInfo = sectionCard.display
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                        cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                        cell.name.text = cardInfo.title
                        cell.desc.text = cardInfo.subtitle1
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        for marker in sectionCard.display.markers {
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
                        cell.imageView.viewCornersWithFive()
//                        let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
//                        let tempHeight = tempWidth * 0.5625
//                        cell.imageViewHeightConstraint.constant = tempHeight
                        return cell
                    }
                    else {
                        collectionView.register(UINib(nibName: SheetPosterCellGV.nibname, bundle: nil), forCellWithReuseIdentifier: SheetPosterCellGV.identifier)
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SheetPosterCellGV.identifier, for: indexPath) as! SheetPosterCellGV
                        let cardInfo = sectionCard.display
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                        cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                        cell.name.text = cardInfo.title
                        if appContants.appName == .gac {
                            cell.titleHeight.constant = 35
                            cell.titleTopConstraint.constant = 3.0
                            cell.name.font = UIFont.ottRegularFont(withSize: 12)
                            cell.subtitleTop.constant = 1.0
                            cell.name.lineBreakMode = .byWordWrapping
                            cell.name.numberOfLines = 2
                        }
                        cell.desc.text = cardInfo.subtitle1
                        cell.watchedProgressView.isHidden = true
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        cell.tagLbl.isHidden = true
                        cell.tagImgView.isHidden = true
                        cell.nowPlayingStrip.isHidden = true
                        cell.nowPlayingHeightConstraint.constant = 0.0
                        cell.durationLabel.isHidden = true
                        cell.durationLblBottomConstraint.constant = 5.0
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
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
                        if appContants.appName != .aastha && appContants.appName != .gac {
                            cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                        }
                        let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                        let tempHeight = tempWidth * 0.5625
                        cell.imageViewHeightConstraint.constant = tempHeight
                        cell.cornerDesignForCollectionCell()
                        return cell
                    }
                }
                else if sectionCard.cardType == .overlay_poster {
                    
                    if productType.iPad {
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
                        if productType.iPad{
                            let height = (productType.iPad ? 93 : 73)
                            cell.imagViewWidthConstraint.constant = CGFloat(height * 16/9)
                            cell.imageViewHeightConstraint.constant = CGFloat(height)
                        }
                        cell.watchedProgressView.isHidden = true
                        cell.badgeLbl.isHidden = true
                        cell.badgeImgView.isHidden = true
                        cell.liveTagLbl.isHidden = true
                        cell.badgeSubLbl.isHidden = true
                        cell.badgeSubLbl.text = ""
                        if sectionCard.display.markers.count > 0 {
                            for marker in sectionCard.display.markers {
                                if marker.markerType == .seek {
                                    cell.watchedProgressView.isHidden = false
                                    cell.watchedProgressView.progress = Float.init(marker.value)!
                                    cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
//                                    cell.watchedProgressView.progress = 0.0
//                                    cell.watchedProgressView.isHidden = true
                                }
                                if marker.markerType == .available_soon {
                                    cell.badgeSubLbl.isHidden = false
                                    cell.badgeImgView.isHidden = false
                                    cell.badgeSubLbl.text = marker.value
                                    cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "bbbbbb"))
                                    cell.badgeImgView.image = UIImage.init(named: "rectangle_128")
                                } else if marker.markerType == .exipiryDays {
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
                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                        cell.cornerDesignForCollectionCell()
                        return cell
                    }
                    else {
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
                        if productType.iPad{
                            let height = (productType.iPad ? 93 : 73)
                            cell.imagViewWidthConstraint.constant = CGFloat(height * 16/9)
                            cell.imageViewHeightConstraint.constant = CGFloat(height)
                        }
                        cell.watchedProgressView.isHidden = true
                        cell.badgeLbl.isHidden = true
                        cell.badgeImgView.isHidden = true
                        cell.liveTagLbl.isHidden = true
                        cell.badgeSubLbl.isHidden = true
                        cell.badgeSubLbl.text = ""
                        if sectionCard.display.markers.count > 0 {
                            for marker in sectionCard.display.markers {
                                if marker.markerType == .seek {
                                    cell.watchedProgressView.isHidden = false
                                    cell.watchedProgressView.progress = Float.init(marker.value)!
                                    cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
//                                    cell.watchedProgressView.progress = 0.0
//                                    cell.watchedProgressView.isHidden = true
                                }
                                if marker.markerType == .available_soon {
                                    cell.badgeSubLbl.isHidden = false
                                    cell.badgeImgView.isHidden = false
                                    cell.badgeSubLbl.text = marker.value
                                    cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "bbbbbb"))
                                    cell.badgeImgView.image = UIImage.init(named: "rectangle_128")
                                } else if marker.markerType == .exipiryDays {
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
                                }
                            }
                        }
//                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
//                        cell.cornerDesignForCollectionCell()
                        return cell
                    }
                }                else if sectionCard.cardType == .common_poster {
                    if productType.iPad {
                        collectionView.register(UINib(nibName: SearchCommonPosterCellLViPad.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLViPad.identifier)
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLViPad.identifier, for: indexPath) as! SearchCommonPosterCellLViPad
                        cell.imageView.loadingImageFromUrl(sectionCard.display.imageUrl, category: "tv")
                        cell.name.text = sectionCard.display.title
                        cell.desc.text = sectionCard.display.subtitle1
                        cell.subDesc.text = sectionCard.display.subtitle2
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        
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
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        
                        
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
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
                    }
                    else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.name.text = cardInfo.title
                    cell.desc.text = cardInfo.subtitle1
                    return cell
                }
                else if sectionCard.cardType == .pinup_poster {
                    collectionView.register(UINib(nibName: PinupPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: PinupPosterCellLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinupPosterCellLV.identifier, for: indexPath) as! PinupPosterCellLV
                    let cardInfo = sectionCard.display
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.name.text = cardInfo.subtitle1
                    cell.desc.text = cardInfo.title
                    return cell
                }
                    //            else if sectionCard.cardType == .content_poster {
                    //                collectionView.register(UINib(nibName: ContentPosterCellEpgLV.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgLV.identifier)
                    //                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgLV.identifier, for: indexPath) as! ContentPosterCellEpgLV
                    //                let cardInfo = sectionCard.display
                    //                if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                    //                    cell.imageView.sd_setImage(with: URL(string: cardInfo.parentIcon), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
                    //                }
                    //                else {
                    //                    cell.imageView.sd_setImage(with: URL(string: cardInfo.imageUrl), placeholderImage: #imageLiteral(resourceName: "Default-TVShows"))
                    //                }
                    //                cell.markerLbl.isHidden = true
                    //                cell.nowPlayingStrip.isHidden = true
                    //                for marker in cardInfo.markers {
                    //                    if marker.markerType == .badge {
                    //                        cell.markerLbl.isHidden = false
                    //                        cell.markerLbl.text = marker.value
                    //                        cell.markerLbl.backgroundColor = UIColor.init(hexString: "FFFF0000")
                    //                        cell.markerLbl.textColor = UIColor.init(hexString: "FFFFFFFF")
                    //                    }
                    //                    else if marker.markerType == .special && marker.value == "now_playing" {
                    //                        cell.nowPlayingStrip.isHidden = false
                    //                    }
                    //                }
                    //                cell.name.text = cardInfo.title
                    //                if cardInfo.parentName .isEmpty {
                    //                    cell.desc.text = cardInfo.subtitle1
                    //                }
                    //                else {
                    //                    if sectionCard.cardType == .live_poster {
                    //                        cell.desc.text = cardInfo.parentName
                    //                    }
                    //                    else {
                    //                        cell.desc.text = cardInfo.subtitle1
                    //                    }
                    //                }
                    //                return cell
                    //            }
                else if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster {
                    collectionView.register(UINib(nibName: LivePosterLV.nibname, bundle: nil), forCellWithReuseIdentifier: LivePosterLV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePosterLV.identifier, for: indexPath) as! LivePosterLV
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.markerLbl.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
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
                        cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        if indexPath.row == 2 {
                            print("markerType : \(marker.markerType.rawValue)")
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
                    cell.layer.cornerRadius = 4.0
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
                
                //tvshows or episodes
                collectionView.register(UINib(nibName: PinupPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: PinupPosterCellLV.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinupPosterCellLV.identifier, for: indexPath) as! PinupPosterCellLV
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if collectionView == headersCollectionView{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBarReusableView", for: indexPath) as! MenuBarReusableView
                return header
            }
            else{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBarReusableView", for: indexPath) as! MenuBarReusableView
                header.tabIndex = tabMenuItemNumber
                header.tabTitlearray = sectionList
                header.tabTitles = tabTitleArr
                header.setupViews()
                header.setIndexTabCell(index:tabMenuItemNumber)
                header.tabMenuDelegate = self
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
            
            footerView.backgroundColor = UIColor.clear
            return footerView
        default:
            return UICollectionReusableView()
            assert(false, "Unexpected element kind")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == headersCollectionView{
            return CGSize.zero
        }
        else{
            return CGSize(width: UIScreen.main.bounds.size.width, height: 47)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: productType.iPad ? 150.0 :  80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headersCollectionView{
            selectedHeaderRow = indexPath.row
            
            loadHeaderData()
        }
        else{
            print("playesugestions VC", indexPath)
            self.startAnimating(allowInteraction: true)
            let cardObj = self.sectionDataList[indexPath.item]
            //            var userID = OTTSdk.preferenceManager.user?.email
            //            if userID != nil && (userID? .isEmpty)! {
            //                userID = OTTSdk.preferenceManager.user?.phoneNumber
            //            }
            //            else {
            //                userID = "NA"
            //            }
            //            let attributes = ["User ID":userID,"TimeStamp":"\(Int64(Date().timeIntervalSince1970 * 1000))","Show Name":cardObj.display.title]
            //            LocalyticsEvent.tagEventWithAttributes("\(AppDelegate.getDelegate().taggedScreen)>Section>\(sectionList[tabMenuItemNumber].title)", attributes as! [String : String])
            //        tabMenuItemNumber = 0
            //        AppDelegate.getDelegate().detailsTabMenuIndex = 0
            if cardObj.template.count > 0{
                PartialRenderingView.instance.reloadFor(card: cardObj, content: nil, partialRenderingViewDelegate: self)
                self.stopAnimating()
                return;
            }
            
            AppDelegate.getDelegate().isFromPlayerPage = false
            self.delegate?.didSelectedRecommendation(card: cardObj)
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
        
        if collectionView == headersCollectionView{
            return CGSize(width: self.headersTitleList[indexPath.item].answerHeight, height: 47)
        }
        else{
            let sectionCard = self.sectionDataList[indexPath.item]
            
            if sectionCard.cardType == .roller_poster {
                return CGSize(width: 116, height: 206)
            }
            if sectionCard.cardType == .live_poster || sectionCard.cardType == .content_poster{
                return CGSize(width: 333, height: 73)
            } else if sectionCard.cardType == .sheet_poster {
//                if isFromDetails {
//                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
//                    let tempHeight = tempWidth * 0.5625
//                    if currentOrientation().portrait {
//                        return CGSize(width: collectionView.frame.size.width/3, height: tempHeight + 52.0)
//                    }else if currentOrientation().landscape {
//                        return CGSize(width: collectionView.frame.size.width/4, height: tempHeight + 52.0)
//                    }else {
//                        return CGSize(width: collectionView.frame.size.width/3, height: tempHeight + 52.0)
//                    }
//                }
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                let tempHeight = tempWidth * 0.5625
                if productType.iPad {
                    if appContants.appName == .gac {
                        return CGSize(width: tempWidth - 10, height: tempHeight + 52.0 + 35)

                    }
                    return CGSize(width: tempWidth - 10, height: tempHeight + 52.0)
                }
                return CGSize(width: tempWidth, height: tempHeight + 52.0)
            } else if sectionCard.cardType == .overlay_poster {
                if productType.iPad {
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                    return CGSize(width: tempWidth, height: 73.0)
                } else {
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - 20.0)
                    return CGSize(width: tempWidth, height: 73)
                }
            }
            else {
                if productType.iPad {
                    return CGSize(width: 360, height: 123)
                }
                return CGSize(width: 333, height: 73)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == headersCollectionView{
            if indexPath.row + 1 == self.sectionDataList.count
            {
                if self.goGetTheData {
                    self.goGetTheData = false
                    for pageData in (pageDataContent?.data)! {
                        if pageData.paneType == .section {
                            let section = pageData.paneData as? Section
                            if section?.sectionData.section == sectionList[tabMenuItemNumber].code {
                                if self.hasMoreData {
                                    self.loadNextSectionContent(section: section!)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        else{
            if indexPath.row + 1 == self.sectionDataList.count
            {
                if self.goGetTheData {
                    self.goGetTheData = false
                    for pageData in (pageDataContent?.data)! {
                        if pageData.paneType == .section {
                            let section = pageData.paneData as? Section
                            if section?.sectionData.section == sectionList[tabMenuItemNumber].code {
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
        OTTSdk.mediaCatalogManager.sectionContent(path: (self.pageDataContent?.info.path)!, code: section.sectionInfo.code, offset: self.lastIndex, count: nil, filter: nil, onSuccess: { (response) in
            self.stopAnimating()
            if response.count > 0 {
                self.hasMoreData = (response.first?.hasMoreData)!
                self.lastIndex = (response.first?.lastIndex)!
                if (response.first?.data.count)! > 0 {
                    
                    for card in (response.first?.data)! {
                        self.sectionDataList.append(card)
                    }
                    self.recommendationsCV.reloadData()
                    self.goGetTheData = true
                }
            }
        }) { (error) in
            self.stopAnimating()
            print(error.message)
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if (coordinator as UIViewControllerTransitionCoordinator?) != nil {
            recommendationsCV.collectionViewLayout.invalidateLayout()
            printLog(log: UIDevice.current.orientation as AnyObject)
            if productType.iPad {
                self.calculateNumCols()
            }
            self.recommendationsCV.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        recommendationsCV.collectionViewLayout.invalidateLayout()
        printLog(log: UIDevice.current.orientation as AnyObject)
        if productType.iPad {
            self.calculateNumCols()
        }
        //        self.suggestionsCV.reloadData()
        self.recommendationsCV.layoutIfNeeded()
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
    
    func didSelectedSuggestion(card: Card) {
        self.goToPage(card, path: card.target.path)
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
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
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
        //                self.stopAnimating()
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
        //                self.stopAnimating()
        //            }
        //            else{
        //                self.sectionDataList.removeAll()
        //                self.sectionList.removeAll()
        //                self.headersList.removeAll()
        //                self.headersTitleList.removeAll()
        //                self.recommendationsCV.reloadData()
        //                self.headersCollectionView.reloadData()
        //                NotificationCenter.default.post(name: Notification.Name("detailPageRecordButtonStatusChanged"), object: nil, userInfo: ["targetPath": self.targetPath])
        //            }
        //
        //
        //            self.recommendationsCV.reloadData()
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
        
        //        self.startAnimating(allowInteraction: true)
        //
        //        OTTSdk.mediaCatalogManager.startStopRecord(content_type: content_type, content_id: content_id, action: "0", onSuccess: { (response) in
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
        //                self.stopAnimating()
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
        //                self.stopAnimating()
        //            }
        //            else{
        //                self.sectionDataList.removeAll()
        //                self.sectionList.removeAll()
        //                self.headersList.removeAll()
        //                self.headersTitleList.removeAll()
        //                self.recommendationsCV.reloadData()
        //                self.headersCollectionView.reloadData()
        //                NotificationCenter.default.post(name: Notification.Name("detailPageRecordButtonStatusChanged"), object: nil, userInfo: ["targetPath": self.targetPath])
        //            }
        //
        //
        //            self.recommendationsCV.reloadData()
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
    
    // MARK: - Tabmenu protocol methods
    func didSelectedItem(item: Int){
        tabMenuItemNumber = item
        AppDelegate.getDelegate().detailsTabMenuIndex = item
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
        var index = 0
        for pageData in (pageDataContent?.data)! {
            if pageData.paneType == .section {
                let section = pageData.paneData as? Section
                if section?.sectionData.section == sectionList[tabMenuItemNumber].code || (sectionList[tabMenuItemNumber].sectionCodes.contains((section?.sectionData.section)!) && tabMenuItemNumber == index) {
                    self.sectionDataList = (section?.sectionData.data)!
                    self.hasMoreData = (section?.sectionData.hasMoreData)!
                    self.lastIndex = (section?.sectionData.lastIndex)!
                }
                index = index + 1
            }
            if self.sectionDataList.count == 0 {
                self.errorView.isHidden = false
                self.view.sendSubviewToBack(errorView)
            }
            else {
                self.errorView.isHidden = true
                self.recommendationsCV.isHidden = false
            }
        }
        self.goGetTheData = true
        self.recommendationsCV.setContentOffset(CGPoint.zero, animated: false)
        self.recommendationsCV.reloadData()
    }
    
}
