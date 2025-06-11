//
//  LiveCVC.swift
//  myColView
//
//  Created by Mohan on 5/21/17.
//  Copyright © 2017 com.cv. All rights reserved.
//

import UIKit
import OTTSdk
import Bluuur

protocol SectionCVCProtocal {
    func didSelectedRollerPosterItem(item: Card) -> Void
    func rollerPoster_moreClicked(sectionData:SectionData,sect_data:SectionInfo,sectionControls:SectionControls)
    func programRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) -> Void
    func programStopRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) -> Void
}

class SectionCVC: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    static let nibname:String = "SectionCVC"
    static let identifier:String = "SectionCVC"
    @IBOutlet weak var titleLblHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var channelImageView : UIImageView!
    @IBOutlet weak var channelImageViewWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var myLbl: UILabel!
    @IBOutlet weak var myLblLeftConstraint : NSLayoutConstraint!
    @IBOutlet weak var cCV: UICollectionView!
    @IBOutlet weak var viewAllButton : UIButton!
    @IBOutlet weak var rightArrow : UIImageView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var arrowImageViewGreaterthanConstraint : NSLayoutConstraint!
    @IBOutlet var viewAllButtonRightConstraint : NSLayoutConstraint!
    @IBOutlet var viewAllButtonWidthConstraint : NSLayoutConstraint!
    @IBOutlet var viewAllButtonLeftConstraint : NSLayoutConstraint!
    @IBOutlet weak var noContentFoundLbl: UILabel!
    var delegate : SectionCVCProtocal?
    var sectionsData = [Card]()
    var sectionData: SectionData?
    var section_Info : SectionInfo?
    var section_Controls : SectionControls?
    var goGetTheData:Bool = true
    var pageData:PageContentResponse?
    var isViewMore:Bool = false
    var isLivePath:Bool = false
    var isIndexZero:Bool = false
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    let numColums: CGFloat = 1
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 13
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    var currentWatchedTimeArr = NSMutableArray()
    var isMovieCell:Bool = false
    var sectionIndex: Int = 0
    var recordingsProgramArr = [String]()
    var recordingSeriesArr = [String]()
    var isFromDetails = false


    override func awakeFromNib() {
        super.awakeFromNib()
//        viewAllButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
//        viewAllButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
        if appContants.appName == .aastha  || appContants.appName == .supposetv {
            rightArrow.image = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
            rightArrow.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        viewAllButton.setTitle(AppDelegate.getDelegate().showViewAll == ">" ? "" : AppDelegate.getDelegate().showViewAll, for: .normal)
        viewAllButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        viewAllButton.titleLabel?.font = UIFont.ottBoldFont(withSize: 12)
        myLbl.font = UIFont.ottRegularFont(withSize: 15)
        channelImageViewWidthConstraint.constant = 0.0
        myLblLeftConstraint.constant = 10.0
        channelImageView.isHidden = true
        setupViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func prepareForReuse() {
        myLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    @IBAction func moreClicked(_ sender: UIButton) {
        LocalyticsEvent.tagEventWithAttributes("Sections", ["Section_name":(self.section_Info?.name)!, "Partners":"", "View All":(self.section_Info?.name)!])
        self.delegate?.rollerPoster_moreClicked(sectionData: self.sectionData!, sect_data: self.section_Info!,sectionControls: self.section_Controls!)
    }
    @objc func recordBtnClicked(sender:UIButton) {
        let programData = self.sectionsData[sender.tag]
        self.delegate?.programRecordClicked(item: programData, sectionIndex: self.sectionIndex, rowIndex: sender.tag)
    }

    @objc func stopRecordBtnClicked(sender:UIButton) {
        let programData = self.sectionsData[sender.tag]
        self.delegate?.programStopRecordClicked(item: programData, sectionIndex: self.sectionIndex, rowIndex: sender.tag)
    }
    func setUpData(sectionData:SectionData ,sectionInfo:SectionInfo, sectionControls:SectionControls, pageData:PageContentResponse) {
        self.pageData = pageData
        sectionsData = sectionData.data
        self.sectionData = sectionData
        section_Info = sectionInfo
        self.section_Controls = sectionControls
    
        if let _ = UIApplication.topVC() as? DetailsViewController {
            myLbl.font = UIFont.ottRegularFont(withSize: 15)
            myLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
            myLbl.alpha = 0.80
        }
        else {
            myLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }

        print(section_Info as Any)
        if sectionData.data.count == 0 {
            self.noContentFoundLbl.isHidden = false
        }
        else {
            self.noContentFoundLbl.isHidden = true
        }
        if section_Info?.dataType == "button" {
            self.titleLblHeightContraint.constant = 0.0
            self.myLbl.isHidden = true
            self.viewAllButton.isHidden = true
        } else {
            self.titleLblHeightContraint.constant = 40.0
            self.myLbl.isHidden = false
            if (self.section_Controls?.showViewAll)! && self.sectionsData.count > 6 {
                self.viewAllButton.isHidden = false
            }
            else {
                self.viewAllButton.isHidden = true
            }
        }
 
        rightArrow.isHidden = viewAllButton.isHidden
        if viewAllButton.isHidden == false {
            if AppDelegate.getDelegate().showViewAll == ">" {
                viewAllButtonLeftConstraint.isActive = true
                viewAllButtonRightConstraint.isActive = false
                viewAllButtonWidthConstraint.isActive = false
                arrowImageViewGreaterthanConstraint.constant = 8.0
                rightArrow.isHidden = false
            }else {
                viewAllButtonLeftConstraint.isActive = false
                viewAllButtonRightConstraint.isActive = true
                viewAllButtonRightConstraint.constant = 8.0
                viewAllButtonWidthConstraint.isActive = true
                viewAllButton.titleLabel?.sizeToFit()
                viewAllButtonWidthConstraint.constant = (viewAllButton.titleLabel?.frame.size.width)!
                arrowImageViewGreaterthanConstraint.constant = 0.0
                rightArrow.isHidden = true
            }
        }else {
            viewAllButtonLeftConstraint.isActive = true
            viewAllButtonRightConstraint.isActive = false
            viewAllButtonWidthConstraint.isActive = false
            arrowImageViewGreaterthanConstraint.constant = 8.0
        }
       

        if rightArrow.isHidden == false && myLbl.text == "" {
            rightArrow.isHidden = true
        }
         cCV.reloadData()
    }
    func setupViews() {
//        var tmpCellsize = cellSizes
//        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
//        cellSizes = tmpCellsize
        
        cCV.dataSource = self
        cCV.delegate = self
        
        self.viewAllButton.tag = ButtonTags.buttonLive.rawValue
        
        myLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.noContentFoundLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor

        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
//        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        cCV.collectionViewLayout = cCFL
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let sectionCard = sectionsData[indexPath.item]
        print("sectionCard.cardType:\(sectionCard.cardType)")
        if section_Info?.dataType == "network" || sectionCard.cardType == .network_poster {
            if sectionCard.cardType == .circle_poster {
                let cardDisplay = sectionCard.display
                
                collectionView.register(UINib(nibName: "CirclePosterCell", bundle: nil), forCellWithReuseIdentifier: "CirclePosterCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CirclePosterCell", for: indexPath) as! CirclePosterCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0
                cell.imageView.clipsToBounds = true
                cell.nameLbl.text = cardDisplay.title
                cell.nameLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
                
                cell.subTitleLabel.text = cardDisplay.subtitle1
                cell.subTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                
                
                cell.backgroundColor = UIColor.clear
//                cell.cornerDesignForCollectionCell()
                return cell
            } else if sectionCard.cardType == .square_poster {
                let cardDisplay = sectionCard.display
                
                collectionView.register(UINib(nibName: "SquarePosterCell", bundle: nil), forCellWithReuseIdentifier: "SquarePosterCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquarePosterCell", for: indexPath) as! SquarePosterCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                cell.nameLbl.text = cardDisplay.title
                cell.backgroundColor = UIColor.clear
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else {
                let cardDisplay = sectionCard.display
                
                collectionView.register(UINib(nibName: "PartnerCell", bundle: nil), forCellWithReuseIdentifier: "PartnerCell")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as! PartnerCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                cell.imageView.layer.cornerRadius = 5.0
                cell.cornerDesignForCollectionCell()
                cell.backgroundColor = UIColor.init(hexString: "2b2b36")
                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                return cell
            }

        }
        else if section_Info?.dataType == "button" {
            let cardDisplay = sectionCard.display
            
            collectionView.register(UINib(nibName: "MenuTabCell", bundle: nil), forCellWithReuseIdentifier: "MenuTabCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuTabCell", for: indexPath) as! MenuTabCell
            cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "potrait")
            cell.name.text = cardDisplay.title
            cell.imageView.viewCornerDesign()
            cell.cornerDesignForCollectionCell()
            return cell
        }
        else {
            if sectionCard.cardType == .roller_poster {
                let cardDisplay = sectionCard.display
                
                collectionView.register(UINib(nibName: "RollerPosterGV", bundle: nil), forCellWithReuseIdentifier: "RollerPosterGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RollerPosterGV", for: indexPath) as! RollerPosterGV
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                cell.expiryInfoLbl.text = ""
                cell.expiryInfoLbl.isHidden = true
                cell.leftOverTimeLabel.isHidden = true
                cell.leftOverLabelHeightConstraint.constant = 0.0
                cell.gradientImageView.isHidden = true
                cell.badgeLbl.isHidden = true
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "potrait")
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)

                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.watchedProgressView.isHidden = true
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                cell.tagLbl.isHidden = true
                cell.tagImgView.isHidden = true

                                    
                
                for marker in cardDisplay.markers {
                    if marker.markerType == .seek {
                        cell.watchedProgressView.isHidden = false
                        cell.watchedProgressView.progress = Float.init(marker.value)!
                        cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                    }
                    else if marker.markerType == .badge {
                        cell.badgeLbl.isHidden = false
                        cell.badgeLbl.text = marker.value
                        cell.badgeLbl.backgroundColor = UIColor.init(hexString: marker.bgColor)
                        cell.badgeLbl.textColor = UIColor.init(hexString: marker.textColor)
                        cell.badgeLbl.sizeToFit()
                        cell.badgeLblWidthConstraint.constant = (cell.badgeLbl.frame.size.width + 20) < cell.frame.size.width ? cell.badgeLbl.frame.size.width + 12 : cell.frame.size.width
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
                        if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4){
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
                            let string2 = splitArray.joined(separator:" ")
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
                //cell.cornerDesignForCollectionCell()
                cell.backgroundColor = UIColor.clear
                return cell
            }
            else if sectionCard.cardType == .band_poster {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
                cell.name.text = cardDisplay.title
                cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                if !cardDisplay.parentIcon .isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in sectionCard.display.markers {
                    if marker.markerType == .tag && marker.value == "Premium" {
                        cell.premiumView.isHidden = false
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
                        if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                    
                }
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.visulEV.blurRadius = 5
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if sectionCard.cardType == .sheet_poster || sectionCard.cardType == .common_poster {
                
                if productType.iPad {
                    let cardDisplay = sectionCard.display
                    collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.tagLbl.isHidden = true
                    cell.tagImgView.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    cell.nowPlayingHeightConstraint.constant = 0.0
                    cell.durationLabel.isHidden = true
                    cell.tvshowMarketTagView.isHidden = true
                    cell.durationLblBottomConstraint.constant = 5.0
                    cell.watchedProgressView.isHidden = true
                    cell.episodeMarkupTagView.isHidden = true
//                    if self.section_Info?.code == "continue_watching" || self.section_Info?.name == "Continue Watching" {
                        if sectionCard.display.markers.count > 0 {
                            for marker in sectionCard.display.markers {
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
                                else if (marker.markerType == .duration || marker.markerType == .leftOverTime)  && !(marker.value .isEmpty) {
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
                                    if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                        cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                        cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                    }
                                }else if marker.markerType == .tag {
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
                                if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
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
                    }
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    if appContants.appName != .aastha && appContants.appName != .gac {
                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else {
                    let cardDisplay = sectionCard.display
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
                    cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                    cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                    cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                    cell.recordBtn.isHidden = true
                    cell.stopRecordingBtn.isHidden = true
                    cell.tagLbl.isHidden = true
                    cell.tagImgView.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    cell.nowPlayingHeightConstraint.constant = 0.0
                    cell.durationLabel.isHidden = true
                    cell.tvshowMarketTagView.isHidden = true
                    cell.durationLblBottomConstraint.constant = 5.0
                    cell.watchedProgressView.isHidden = true
                    cell.episodeMarkupTagView.isHidden = true
//                    if self.section_Info?.code == "continue_watching" || self.section_Info?.name == "Continue Watching" {
                        if sectionCard.display.markers.count > 0 {
                            for marker in sectionCard.display.markers {
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
                                    cell.durationLabel.sizeToFit()
                                    cell.durationLabel.textColor = UIColor.init(hexString: marker.textColor)
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
                                    if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                        cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                        cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                    }
                                }else if marker.markerType == .tag {
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
                                if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
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
                    }
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    if appContants.appName != .aastha && appContants.appName != .gac {
                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
            }
            else if sectionCard.cardType == .overlay_poster {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "OverlayPosterGV", bundle: nil), forCellWithReuseIdentifier: "OverlayPosterGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverlayPosterGV", for: indexPath) as! OverlayPosterGV
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                cell.name.text = cell.name.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                cell.desc.text = cell.desc.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                cell.iconImageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                if cardDisplay.parentIcon .isEmpty {
                    cell.iconImageViewWidthConstraint.constant = 0.0
                    cell.iconImageViewLeadingConstraint.constant = 0.0
                } else {
                    cell.iconImageViewWidthConstraint.constant = 42.0
                    cell.iconImageViewLeadingConstraint.constant = 5.0
                }
                cell.watchedProgressView.isHidden = true
                cell.badgeLbl.isHidden = true
                cell.badgeImgView.isHidden = true
                cell.liveTagLbl.isHidden = true
                cell.badgeSubLbl.isHidden = true
                cell.badgeSubLbl.text = ""
//                if self.section_Info?.code == "continue_watching" || self.section_Info?.name == "Continue Watching" {
                    if sectionCard.display.markers.count > 0 {
                        for marker in sectionCard.display.markers {
                            if marker.markerType == .seek {
                                cell.watchedProgressView.isHidden = false
                                cell.watchedProgressView.progress = Float.init(marker.value)!
                                cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
                            } else if marker.markerType == .available_soon {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeImgView.isHidden = false
                                cell.badgeSubLbl.text = marker.value
                                cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "bbbbbb"))
                                cell.badgeImgView.image = UIImage.init(named: "rectangle_128")
                            } else if marker.markerType == .exipiryDays {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeImgView.isHidden = false
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
                            }
                        }
                    //}
                }
                else {
                    cell.watchedProgressView.isHidden = true
                    if sectionCard.display.markers.count > 0 {
                        for marker in sectionCard.display.markers {
                            if marker.markerType == .available_soon {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeImgView.isHidden = false
                                cell.badgeSubLbl.text = marker.value
                                cell.badgeSubLbl.changeBorder(color: UIColor.init(hexString: "bbbbbb"))
                                cell.badgeImgView.image = UIImage.init(named: "rectangle_128")
                            } else if marker.markerType == .exipiryDays {
                                cell.badgeSubLbl.isHidden = false
                                cell.badgeImgView.isHidden = false
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
                }
//                cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
//                cell.cornerDesignForCollectionCell()
                if (cell.name.text! .isEmpty) && (cell.desc.text! .isEmpty) {
                    cell.gradientImageView.isHidden = true
                } else {
                    cell.gradientImageView.isHidden = false
                }
                return cell
            }
            else if sectionCard.cardType == .box_poster {
                collectionView.register(UINib(nibName: "BoxPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BoxPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellGV.identifier, for: indexPath) as! BoxPosterCellGV
                let cardInfo = sectionCard.display
                cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                if !cardInfo.parentIcon .isEmpty {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.iconViewWidthConstraint.constant = 0
                }
                cell.name.text = cardInfo.title
                cell.desc.text = cardInfo.subtitle1
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
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
                        if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                    
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if sectionCard.cardType == .pinup_poster {
                
                if productType.iPad{
                    let cardDisplay = sectionCard.display
                    collectionView.register(UINib(nibName: "PinupPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellGViPad")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellGViPad", for: indexPath) as! PinupPosterCellGViPad
                    cell.name.text = cardDisplay.title
                    cell.subTitle.text = cardDisplay.subtitle1
                    if cardDisplay.subtitle1 .isEmpty {
                        cell.nameLblBottomConstraint.constant = 6.0
                    }
                    else {
                        cell.nameLblBottomConstraint.constant = 12.0
                    }
                    cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    if !cardDisplay.parentIcon.isEmpty {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    cell.visulEV.blurRadius = 5
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else {
                    let cardDisplay = sectionCard.display
                    collectionView.register(UINib(nibName: "PinupPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "PinupPosterCellGV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinupPosterCellGV", for: indexPath) as! PinupPosterCellGV
                    cell.name.text = cardDisplay.title
                    cell.iconView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                    if !cardDisplay.parentIcon.isEmpty {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    }
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
            }
            else if sectionCard.cardType == .content_poster {
                
                if productType.iPad{
                    collectionView.register(UINib(nibName: ContentPosterCellEpgGVIpad.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgGVIpad.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgGVIpad.identifier, for: indexPath) as! ContentPosterCellEpgGVIpad
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                        cell.iconView.loadingImageFromUrl(cardInfo.parentIcon, category: "tv")
                        //                cell.iconViewWidthConstraint.constant = 35.0
                    }
                    else {
                        //                cell.iconViewWidthConstraint.constant = 0.0
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
                            if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.name.text = cardInfo.title
                    if cardInfo.parentName .isEmpty {
                        cell.desc.text = cardInfo.subtitle1
                    }
                    else {
                        if sectionCard.cardType == .live_poster {
                            cell.desc.text = cardInfo.parentName
                        }
                        else {
                            cell.desc.text = cardInfo.subtitle1
                        }
                    }
                    cell.layer.cornerRadius = 4.0
                    cell.iconView.layer.cornerRadius = 4.0
                    cell.imageView.viewCornersWithFive()
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else {
                    collectionView.register(UINib(nibName: ContentPosterCellEpgGV.nibname, bundle: nil), forCellWithReuseIdentifier: ContentPosterCellEpgGV.identifier)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentPosterCellEpgGV.identifier, for: indexPath) as! ContentPosterCellEpgGV
                    let cardInfo = sectionCard.display
                    if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                        cell.iconView.loadingImageFromUrl(cardInfo.parentIcon, category: "tv")
                        //                cell.iconViewWidthConstraint.constant = 35.0
                    }
                    else {
                        //                cell.iconViewWidthConstraint.constant = 0.0
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
                            if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                    }
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.name.text = cardInfo.title
                    if cardInfo.parentName .isEmpty {
                        cell.desc.text = cardInfo.subtitle1
                    }
                    else {
                        if sectionCard.cardType == .live_poster {
                            cell.desc.text = cardInfo.parentName
                        }
                        else {
                            cell.desc.text = cardInfo.subtitle1
                        }
                    }
                    cell.iconView.layer.cornerRadius = 4.0
                    cell.iconView.layer.masksToBounds = true
                    cell.imageView.viewCornersWithFive()
                    if self.isLivePath && self.isIndexZero{
                        if indexPath.row == 0 {
                            AppDelegate.getDelegate().liveCouchScreenCell = cell
                        }
                    }
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
            }
            else if sectionCard.cardType == .live_poster {
                collectionView.register(UINib(nibName: LivePosterGV.nibname, bundle: nil), forCellWithReuseIdentifier: LivePosterGV.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePosterGV.identifier, for: indexPath) as! LivePosterGV
                let cardInfo = sectionCard.display
                if !cardInfo.parentIcon .isEmpty && cardInfo.parentIcon.contains("https") {
                    cell.iconView.loadingImageFromUrl(cardInfo.parentIcon, category: "tv")
                    //                cell.iconViewWidthConstraint.constant = 35.0
                }
                else {
                    //                cell.iconViewWidthConstraint.constant = 0.0
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
                        if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                cell.name.text = cardInfo.title
                if cardInfo.parentName .isEmpty {
                    cell.desc.text = cardInfo.subtitle1
                }
                else {
                    cell.desc.text = cardInfo.parentName
                }
                cell.layer.cornerRadius = 4.0
                cell.iconView.layer.cornerRadius = 4.0
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if sectionCard.cardType == .band_poster {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "BandPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "BandPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BandPosterCellGV", for: indexPath) as! BandPosterCellGV
                cell.name.text = cardDisplay.title
                cell.iconView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                if !cardDisplay.parentIcon.isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                cell.visulEV.blurRadius = 5
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
                for marker in sectionCard.display.markers {
                    if marker.markerType == .tag && marker.value == "Premium" {
                        cell.premiumView.isHidden = false
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
                        if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                            cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                            cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                        }
                    }
                }
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if sectionCard.cardType == .icon_poster {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "IconPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "IconPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPosterCellGV", for: indexPath) as! IconPosterCellGV
                cell.name.text = cardDisplay.title
                if !cardDisplay.parentIcon.isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else if sectionCard.cardType == .circle_poster{
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "CirclePosterCell", bundle: nil), forCellWithReuseIdentifier: "CirclePosterCell")
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CirclePosterCell", for: indexPath) as! CirclePosterCell
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "partner")
                if productType.iPad {
                    cell.imageView.layer.cornerRadius = cell.bounds.width / 2
                    cell.imageView.layer.masksToBounds = true
                    cell.nameLbl.font = UIFont.ottRegularFont(withSize: 13)
                    cell.subTitleLabel.font = UIFont.ottRegularFont(withSize: 13)
                } else {
                    cell.imageView.layer.cornerRadius = cell.imageViewHeightConstraint.constant / ((cell.frame.height-12)/cell.frame.width)
                    cell.imageView.clipsToBounds = true
                }
                cell.nameLbl.text = cardDisplay.title
                cell.backgroundColor = UIColor.clear
                cell.nameLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
                
                cell.subTitleLabel.text = cardDisplay.subtitle1
                cell.subTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                return cell
            }
            else if sectionCard.cardType == .info_poster {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "InfoPosterLandscapeCellGV", bundle: nil), forCellWithReuseIdentifier: "InfoPosterLandscapeCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPosterLandscapeCellGV", for: indexPath) as! InfoPosterLandscapeCellGV
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                if !cardDisplay.parentIcon.isEmpty {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }else {
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                }
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else {
                let cardDisplay = sectionCard.display
                collectionView.register(UINib(nibName: "SheetPosterCellGV", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGV")
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGV", for: indexPath) as! SheetPosterCellGV
                cell.name.text = cardDisplay.title
                cell.desc.text = cardDisplay.subtitle1
                cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                cell.recordBtn.setTitle(AppDelegate.getDelegate().buttonRecord, for: .normal)
                cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                cell.recordBtn.isHidden = true
                cell.stopRecordingBtn.isHidden = true
//                if self.section_Info?.code == "continue_watching" {
                    if sectionCard.display.markers.count > 0 {
                        for marker in sectionCard.display.markers {
                            if marker.markerType == .badge {
                                cell.episodeMarkupTagView.isHidden = false
                                cell.episodeMarkupLbl.text = marker.value
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
                                if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                    cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                    cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                                }
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
                            cell.recordBtn.addTarget(self, action: #selector(self.recordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            cell.stopRecordingBtn.addTarget(self, action: #selector(self.stopRecordBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                            if self.recordingsProgramArr.contains(sectionCard.display.subtitle5) || self.recordingSeriesArr.contains(sectionCard.display.subtitle4) {
                                cell.recordBtn.isHidden = !cell.recordBtn.isHidden
                                cell.stopRecordingBtn.isHidden = !cell.stopRecordingBtn.isHidden
                            }
                        }
                        
                    }
                }
                if self.isLivePath && self.isIndexZero{
                    if indexPath.row == 0 {
                        AppDelegate.getDelegate().liveCouchScreenCell = cell
                    }
                }
                cell.cornerDesignForCollectionCell()
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionCard = sectionsData[indexPath.item]
        
        if section_Info?.dataType == "network" || sectionCard.cardType == .network_poster{
            if sectionCard.cardType == .circle_poster {
                return CGSize(width: 64, height: 94)
            } else if sectionCard.cardType == .square_poster {
                return CGSize(width: 100, height: 130)
            }
            else {
                return CGSize(width: (productType.iPad ? 224 : 192), height: (productType.iPad ? 126 :108))
            }
        }
        else if section_Info?.dataType == "button" {
            return CGSize(width: 95, height: 40)
        }
        else {
            if sectionCard.cardType == .roller_poster {
                if productType.iPad {
                    if isFromDetails {
                        return CGSize(width: 116 * 1.3, height: 206 * 1.4)
                    }
                    return CGSize(width: 116 * 1.3, height: 206 * 1.3)
                }
                return CGSize(width: 116, height: 206)
            }
            else if sectionCard.cardType == .live_poster {
                if productType.iPad {
                    return CGSize(width: 229, height: 182)
                }
                return CGSize(width: 179, height: 132)
            }
            else if sectionCard.cardType == .content_poster {
                if productType.iPad {
                    return CGSize(width: 229, height: 182)
                }
                return CGSize(width: 179, height: 142)
            }
            else if sectionCard.cardType == .sheet_poster || sectionCard.cardType == .common_poster {
                if productType.iPad {
                    if appContants.appName == .mobitel || appContants.appName == .pbns || appContants.appName == .airtelSL {
                        return CGSize(width: 179 * 1.0, height: 152 * 1.0)
                    }
                    else if appContants.appName == .gac {
                        return CGSize(width: 231, height: 180)
                    }
                    else {
                        return CGSize(width: 179 * 1.3, height: 152 * 1.2)
                    }
                }
                else {
                    if appContants.appName == .gac {
                        return CGSize(width: 179, height: 177)
                    }
                    return CGSize(width: 179, height: 162)
                }
            }
            else if sectionCard.cardType == .circle_poster {
                if appContants.appName == .gac {
                    if productType.iPad {
                        return CGSize(width: 160, height: 200)
                    }
                }
                return CGSize(width: 104, height: 141)
            }
            else if sectionCard.cardType == .overlay_poster {
                return CGSize(width: (productType.iPad ? 224 : 215), height: (productType.iPad ? 126 :121))
//                CGSize(width: 215, height: 121)
            } else {
                if productType.iPad {
                    return CGSize(width: 229, height: 182)
                }
                return CGSize(width: 179, height: 132)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Live CVC", indexPath)
        
       let channelItem = sectionsData[indexPath.item]
//        var userID = OTTSdk.preferenceManager.user?.email
//        if userID != nil && (userID? .isEmpty)! {
//            userID = OTTSdk.preferenceManager.user?.phoneNumber
//        }
//        else {
//            userID = "NA"
//        }
//
//        LocalyticsEvent.tagEventWithAttributes("Sections", ["Section_name":(self.section_Info?.name)!, "Partners":"", ])
        
        AppDelegate.getDelegate().isFromPlayerPage = false
        self.delegate?.didSelectedRollerPosterItem(item: channelItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.sectionsData.count {
            if self.goGetTheData {
                if (self.sectionData?.hasMoreData)! {
                    self.goGetTheData = false
                    self.loadMoreData(filterString: nil)
                }
            }
        }
    }
    
    func getDataFromUserDefaults() -> [String:Any] {
        let yuppFlixUserDefaults = UserDefaults.standard
        var continueDict = [String:Any]()
        if let userID = (OTTSdk.preferenceManager.user?.userId) {
            if yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") != nil {
                let data = yuppFlixUserDefaults.object(forKey: "Continue_Watching_List") as! Data
                let finalContinueWatchingList = NSKeyedUnarchiver.unarchiveObject(with: data)
                if finalContinueWatchingList is  [String:[String:[String:Any]]]{
                    let tempFinalContinueWatchingList = finalContinueWatchingList as! [String:[String:[String:Any]]]
                    let userIDContinueWatchingDict = tempFinalContinueWatchingList["Continue_Watching_List"]
                    let continueWatchingDict = userIDContinueWatchingDict!["\(userID)"]
                    continueDict = continueWatchingDict!
                }
            }
        }
        return continueDict
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

    // MARK: - API Calls
    func loadMoreData(filterString:String?) {
        OTTSdk.mediaCatalogManager.sectionContent(path: (self.pageData?.info.path)!, code: (self.section_Info?.code)!, offset: self.sectionData?.lastIndex, count: nil, filter: filterString == nil ? nil:(filterString? .isEmpty)! ? nil:filterString, onSuccess: { (response) in
            if let cards = response.first?.data{
                if cards.count > 0 {
                    self.goGetTheData = true
                    self.sectionData?.lastIndex = (response.first?.lastIndex)!
                    self.sectionsData.append(contentsOf: cards)
                    self.cCV.reloadData()
                }
            }
            else{
                
            }
        }) { (error) in
            print(error.message)
        }
        
    }
    
    @available(iOS 13.0, *)
    func fiveCellLayout() -> UICollectionViewCompositionalLayout{
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitem: item, count: 5)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

}

class RollerPosterGV: UICollectionViewCell {
    static let nibname:String = "RollerPosterGV"
    static let identifier:String = "RollerPosterGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var fdfsMarkerTagView: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var expiryInfoLbl : UILabel!
    @IBOutlet weak var gradientImageView : UIImageView!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var badgeLbl : UILabel!
    @IBOutlet weak var badgeLblWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var leftOverTimeLabel : UILabel!
    @IBOutlet weak var leftOverLabelHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var tagImgView: UIImageView!
    @IBOutlet weak var tagWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 12)
        desc.font = UIFont.ottRegularFont(withSize: 12)
        leftOverTimeLabel.font = UIFont.ottRegularFont(withSize: 10)
        expiryInfoLbl.font = UIFont.ottItalicFont(withSize: 12)
        badgeLbl.font = UIFont.ottRegularFont(withSize: 12)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class RollerPosterLV: UICollectionViewCell {
    static let nibname:String = "RollerPosterLV"
    static let identifier:String = "RollerPosterLV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var expiryInfoLbl : UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var badgeLbl : UILabel!
    @IBOutlet weak var badgeLblWidthConstraint : NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 12)
        desc.font = UIFont.ottRegularFont(withSize: 12)
        expiryInfoLbl.font = UIFont.ottRegularFont(withSize: 10)
        badgeLbl.font = UIFont.ottRegularFont(withSize: 12)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
class ContentPosterCellEpgGV: UICollectionViewCell { 
    static let nibname:String = "ContentPosterCellEpgGV"
    static let identifier:String = "ContentPosterCellEpgGV"
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class ContentPosterCellEpgLV: UICollectionViewCell {
    
    static let nibname:String = "ContentPosterCellEpgLV"
    static let identifier:String = "ContentPosterCellEpgLV"
    
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class ContentPosterCellEpgGVIpad: UICollectionViewCell {
    static let nibname:String = "ContentPosterCellEpgGVIpad"
    static let identifier:String = "ContentPosterCellEpgGVIpad"
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class ContentPosterCellEpgLVIpad: UICollectionViewCell {
    
    static let nibname:String = "ContentPosterCellEpgLVIpad"
    static let identifier:String = "ContentPosterCellEpgLVIpad"
    
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class LivePosterGV: UICollectionViewCell {
    static let nibname:String = "LivePosterGV"
    static let identifier:String = "LivePosterGV"
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class LivePosterLV: UICollectionViewCell {
    
    static let nibname:String = "LivePosterLV"
    static let identifier:String = "LivePosterLV"
    
    @IBOutlet weak var markerLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!

    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class BoxPosterCellGV: UICollectionViewCell {
    static let nibname:String = "BoxPosterCellGV"
    static let identifier:String = "BoxPosterCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var bazaarmarketTagView: UIView!
    @IBOutlet weak var iconViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class BoxPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "BoxPosterCellLV"
    static let identifier:String = "BoxPosterCellLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class IconPosterCellGV: UICollectionViewCell {
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    static let nibname:String = "IconPosterCellGV"
    static let identifier:String = "IconPosterCellGV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class InfoPosterLandscapeCellGV: UICollectionViewCell {
    
    static let nibname:String = "InfoPosterLandscapeCellGV"
    static let identifier:String = "InfoPosterLandscapeCellGV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var genre: UIView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var newMarkerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class SearchCommonPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "SearchCommonPosterCellLV"
    static let identifier:String = "SearchCommonPosterCellLV"
    
    @IBOutlet weak var redDotView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var subDesc: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameXPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerLabelBgView: UIView!
    @IBOutlet weak var markerLabelBgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerLabel: UILabel!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subDesc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        subDesc.text = ""
        markerLabel.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subDesc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class SearchCommonPosterCellLViPad: UICollectionViewCell {
    
    static let nibname:String = "SearchCommonPosterCellLV-iPad"
    static let identifier:String = "SearchCommonPosterCellLViPad"
    
    @IBOutlet weak var redDotView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var subDesc: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameXPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerLabel: UILabel!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subDesc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        subDesc.text = ""
        markerLabel.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subDesc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}


class BandPosterCellGV: UICollectionViewCell {
    static let nibname:String = "BandPosterCellGV"
    static let identifier:String = "BandPosterCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class BandPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "BandPosterCellLV"
    static let identifier:String = "BandPosterCellLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
class SheetPosterCellGV: UICollectionViewCell {
    
    @IBOutlet weak var durationLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var nowPlayingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var tagImgView: UIImageView!
    @IBOutlet weak var tagWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    static let nibname:String = "SheetPosterCellGV"
    static let identifier:String = "SheetPosterCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedStrip: UIView!
    @IBOutlet weak var nowPlayingStrip: UIView!

    @IBOutlet weak var tvshowMarkupLbl: UILabel!
    @IBOutlet weak var episodeMarkupLbl: UILabel!
    
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var tvshowMarketTagView: UIView!
    @IBOutlet weak var episodeMarkupTagView: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var subtitleTop: NSLayoutConstraint!
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 14)
        desc.font = UIFont.ottRegularFont(withSize: 12)
        tvshowMarketTagView.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc.text = ""
        episodeMarkupLbl.text = ""
        episodeMarkupTagView.backgroundColor = UIColor.clear
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 14)
        desc.font = UIFont.ottRegularFont(withSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

class SheetPosterCellGViPad: UICollectionViewCell {
    static let nibname:String = "SheetPosterCellGViPad"
    static let identifier:String = "SheetPosterCellGViPad"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedStrip: UIView!
    @IBOutlet weak var tvshowMarketTagView: UIView!
    @IBOutlet weak var episodeMarkupTagView: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var nowPlayingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var tagImgView: UIImageView!
    @IBOutlet weak var tagWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvshowMarkupLbl: UILabel!
    @IBOutlet weak var episodeMarkupLbl: UILabel!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 16)
        desc.font = UIFont.ottRegularFont(withSize: 14)
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 16)
        desc.font = UIFont.ottRegularFont(withSize: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

class RectanglePosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "RectanglePosterCellLV"
    static let identifier:String = "RectanglePosterCellLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
}

class SheetPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "SheetPosterCellLV"
    static let identifier:String = "SheetPosterCellLV"
    
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var tagWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagImgView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var episodeMarkupLbl: UILabel!
    @IBOutlet weak var watchedStrip: UIView!
    @IBOutlet weak var latestEpisodeMarkupView: UIView!
    @IBOutlet weak var watchedProgressView: UIProgressView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var downloadPercentage: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var downloadHoursView : UIView!
    @IBOutlet weak var downloadHoursLbl : UILabel!
    fileprivate var download_size = ""
    var asset: Asset? {
        didSet {
            if let asset = asset {
                if #available(iOS 11.0, *) {
                    let downloadState = AssetPersistenceManager.sharedManager.downloadState(for: asset)
                    switch downloadState {
                    case .downloaded:

                        downloadProgressView.isHidden = true
                        self.downloadPercentage.isHidden = true
                        self.deleteBtn.isHidden = false
                        self.deleteBtn.isUserInteractionEnabled = true
                        self.deleteBtn.setImage(UIImage.init(named: "icon_delete"), for: .normal)
                        self.blurOutView(false)
                    case .downloading:
                        if Utilities.hasConnectivity() {
                            downloadProgressView.isHidden = false
                            self.downloadPercentage.isHidden = false
                            self.deleteBtn.isHidden = true
                            self.deleteBtn.isUserInteractionEnabled = true
                            self.deleteBtn.setImage(UIImage.init(named: "icon_delete"), for: .normal)
                            self.blurOutView(true)
                            self.isUserInteractionEnabled = true
                        } else {
                            downloadProgressView.isHidden = true
                            self.downloadPercentage.isHidden = true
                            self.deleteBtn.isHidden = false
                            self.deleteBtn.isUserInteractionEnabled = false
                            self.deleteBtn.setImage(UIImage.init(named: "no_download"), for: .normal)
                            self.blurOutView(true)
                        }

                    case .notDownloaded:
                        downloadProgressView.isHidden = true
                        self.downloadPercentage.isHidden = true
                        self.deleteBtn.isHidden = false
                        self.deleteBtn.isUserInteractionEnabled = false
                        self.deleteBtn.setImage(UIImage.init(named: "no_download"), for: .normal)
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
                downloadProgressView.isHidden = false
                self.downloadPercentage.isHidden = false
                self.deleteBtn.isHidden = true
            }
        }
    }
    func blurOutView(_ status:Bool) {
        self.imageView.alpha = status ? 0.5 : 1.0
        self.name.alpha = status ? 0.5 : 1.0
        self.desc.alpha = status ? 0.5 : 1.0
        self.watchedStrip.alpha = status ? 0.5 : 1.0
        self.latestEpisodeMarkupView.alpha = status ? 0.5 : 1.0
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
                self.downloadProgressView.isHidden = false
                self.downloadPercentage.isHidden = false
                self.deleteBtn.isHidden = true
                self.blurOutView(true)
            case .downloaded, .notDownloaded:
                if downloadState == .downloaded {
                    AppDelegate.getDelegate().updateExpiryDateForStream(streamName: asset.stream.name, download_size: self.download_size, video_download: true)
                }
                self.downloadProgressView.isHidden = true
                self.downloadPercentage.isHidden = true
                self.downloadProgressView.progress = 0.0
                self.deleteBtn.isHidden = false
                self.blurOutView(false)
            }
        }
    }

    @objc
    func handleAssetDownloadProgress(_ notification: NSNotification) {
        guard let assetStreamName = notification.userInfo![Asset.Keys.name] as? String,
            let asset = asset, asset.stream.name == assetStreamName else { return }
        guard let progress = notification.userInfo![Asset.Keys.percentDownloaded] as? Double else { return }

        self.downloadProgressView.setProgress(Float(progress), animated: true)
        self.downloadPercentage.text = "\(Int(progress*100))%"
        guard let d_size = notification.userInfo?["download_size"] as? String else {return}
        download_size = d_size
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        downloadHoursLbl.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        downloadHoursLbl.font = UIFont.ottRegularFont(withSize: 10.0)
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
        downloadPercentage.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        episodeMarkupLbl.text = ""
        latestEpisodeMarkupView.backgroundColor = UIColor.clear
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class OverlayPosterGV: UICollectionViewCell {
    
    @IBOutlet weak var badgeImgView: UIImageView!
    @IBOutlet weak var badgeSubLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var liveTagLbl: UILabel!
    @IBOutlet weak var iconImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveTagLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    static let nibname:String = "OverlayPosterGV"
    static let identifier:String = "OverlayPosterGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var nowPlayingStrip: UIView!

    @IBOutlet weak var watchedProgressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
//        14 12
        name.font = UIFont.ottRegularFont(withSize: 14)
        desc.font = UIFont.ottRegularFont(withSize: 12)
        badgeSubLbl.font = UIFont.ottRegularFont(withSize: 10)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
class OverlayPosterLV: UICollectionViewCell {
    
    
    @IBOutlet weak var channelLogoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var channelLogoViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var badgeImgView: UIImageView!
    @IBOutlet weak var badgeSubLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var liveTagLbl: UILabel!
    @IBOutlet weak var liveTagLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagViewWidthConstraint: NSLayoutConstraint!
    static let nibname:String = "OverlayPosterLV"
    static let identifier:String = "OverlayPosterLV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nowPlayingStrip: UIView!
    @IBOutlet weak var nowPlayingHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var watchedProgressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        let height = (productType.iPad ? 93 : 73)
        self.imagViewWidthConstraint.constant = CGFloat(height * 16/9)
        self.imageViewHeightConstraint.constant = CGFloat(height)
        
        name.font = UIFont.ottRegularFont(withSize: 14)
        desc.font = UIFont.ottRegularFont(withSize: 12)
        badgeLbl.font = UIFont.ottItalicFont(withSize: 12)
        badgeSubLbl.font = UIFont.ottRegularFont(withSize: 10)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
class PinupPosterCellGV: UICollectionViewCell {
    static let nibname:String = "PinupPosterCellGV"
    static let identifier:String = "PinupPosterCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var redDot: UIView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var nameLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveBatchTagView: UIView!
    @IBOutlet weak var nameLblBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var catchupBatchTagView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class PinupPosterViewlistCellGV: UICollectionViewCell {
    static let nibname:String = "PinupPosterViewlistCellGV"
    static let identifier:String = "PinupPosterViewlistCellGV"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var redDot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}


class PinupPosterCellLV: UICollectionViewCell {
    
    static let nibname:String = "PinupPosterCellLV"
    static let identifier:String = "PinupPosterCellLV"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var redDot: UIView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class SheetPosterCellLViPad: UICollectionViewCell {
    
    static let nibname:String = "SheetPosterCellLV-iPad"
    static let identifier:String = "SheetPosterCellLViPad"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var watchedStrip: UIView!
    @IBOutlet weak var latestEpisodeMarkupView: UIView!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class PinupPosterCellGViPad: UICollectionViewCell {
    static let nibname:String = "PinupPosterCellGV-iPad"
    static let identifier:String = "PinupPosterCellGViPad"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var redDot: UIView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var nameLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLblBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveBatchTagView: UIView!
    @IBOutlet weak var catchupBatchTagView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class PinupPosterCellLViPad: UICollectionViewCell {
    
    static let nibname:String = "PinupPosterCellLV-iPad"
    static let identifier:String = "PinupPosterCellLViPad"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var redDot: UIView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var visulEV: MLWBluuurView!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    @IBOutlet weak var ImageHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
        premiumView?.isHidden = true
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class TVGuideDateCell: UICollectionViewCell {
    
    static let nibname:String = "TVGuideDateCell"
    static let identifier:String = "TVGuideDateCell"
    
    @IBOutlet weak var tvShowGuideDateLbl: UILabel!
    @IBOutlet weak var bottomBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tvShowGuideDateLbl.text = ""
        self.backgroundColor = AppTheme.instance.currentTheme.tvGuideDateCellColor
    }
    
    override func prepareForReuse() {
        tvShowGuideDateLbl.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected && !(self.tvShowGuideDateLbl.text?.isEmpty)! {
                self.tvShowGuideDateLbl.textColor = AppTheme.instance.currentTheme.guideDatesTextColor
                  self.bottomBar.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
            } else {
                if appContants.appName == .pbns {
                        self.tvShowGuideDateLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
                }
                else {
                    self.tvShowGuideDateLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                }
                self.bottomBar.backgroundColor =  AppTheme.instance.currentTheme.tvGuideDateCellColor
            }
        }
    }
}

class MenuTabCell: UICollectionViewCell {
    static let nibname:String = "MenuTabCell"
    static let identifier:String = "MenuTabCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class PartnerCell: UICollectionViewCell {
    static let nibname:String = "PartnerCell"
    static let identifier:String = "PartnerCell"
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class CirclePosterCell: UICollectionViewCell {
    static let nibname:String = "CirclePosterCell"
    static let identifier:String = "CirclePosterCell"
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}

class SquarePosterCell: UICollectionViewCell {
    static let nibname:String = "SquarePosterCell"
    static let identifier:String = "SquarePosterCell"
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}
class MockTestCell: UICollectionViewCell {
    static let nibname:String = "MockTestCell"
    static let identifier:String = "MockTestCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = AppTheme.instance.currentTheme.cardTitleColor
        desc.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        name.font = UIFont.ottRegularFont(withSize: 14)
        desc.font = UIFont.ottRegularFont(withSize: 12)
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        name?.text = ""
        desc?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

class PlayerBannerAdCell: UICollectionViewCell {
    static let nibname:String = "PlayerBannerAdCell"
    static let identifier:String = "PlayerBannerAdCell"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}


