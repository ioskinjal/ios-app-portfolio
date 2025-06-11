//
//  MovieDetailsTableViewCell.swift
//  sampleColView
//
//  Created by Ankoos on 20/06/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import OTTSdk

protocol DetailsTableViewCellProtocal {
    func selectedRollerPosterItem(item: Card) -> Void
    func programRecordSelected(item: Card) -> Void
    func bannerSelected(item: Banner) -> Void

}

class DetailsTableViewCell: UITableViewCell, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SectionCVCProtocal,DetailsChildViewControllerDelegate,tabMenuProtocal, BannerCVCProtocal,PlayerViewControllerDelegate,DefaultViewControllerDelegate {
    func retryTap() {
        
    }
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
    
    func programRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) {
        self.delegate?.programRecordSelected(item: item)
    }
    func programStopRecordClicked(item: Card, sectionIndex:Int, rowIndex:Int) {
    }

    
        
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var recommendationCV: UICollectionView!
    var sectionDetails:Section?
    var sectionArr = [Any]()
    var sectionHasMoreDataArr = [Section]()
    var newSectionHasMoreDataArr = [Section]()
    var sectionTabArr = [Card]()
    var pageContent:PageContentResponse?
    var viewController:UIViewController?
    var delegate : DetailsTableViewCellProtocal?
    weak var currentViewController: UIViewController?
    weak var updatingViewController: UIViewController?
    let secInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    static let nibname:String = "DetailsTableViewCell"
    static let identifier:String = "DetailsTableViewCell"
    var targetPath = ""
    var contentType = ""
    var tabMenuItemNumber:Int = 0
    var cVL: CustomFlowLayout!
    var goGetTheData:Bool = true
    var isPartnerWithTabs:Bool = false
    var partnerName = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.errorView.isHidden = true
        // Initialization code
    }

    func setUpData(section:Section?,pageContent:PageContentResponse) {
        sectionArr = [Any]()
        if recommendationCV != nil {
            
            self.recommendationCV.register(UINib(nibName: "MenuBarReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuBarReusableView")
            self.recommendationCV.register(UINib(nibName: "BannerCVC", bundle: nil), forCellWithReuseIdentifier: "bannerCellId")
        }
//        cVL = CustomFlowLayout()
//        cVL.cellRatio = false
//        cVL.secInset = secInsets
//        cVL.cellSize = cellSizes
//        cVL.interItemSpacing = (minLineSpacing/numColums) * (numColums-1)
//        cVL.minLineSpacing = minLineSpacing
//        cVL.scrollDir = scrollDir
//        cVL.sectionHeadersPinToVisibleBounds = true
//        self.calculateNumCols()
//        cVL.setupLayout()

        self.pageContent = pageContent
        self.contentType = self.pageContent?.info.attributes.contentType ?? ""
        if pageContent.tabsInfo.tabs.count > 0 {
            for subView in self.contentView.subviews {
                subView.removeFromSuperview()
            }
            let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
            let newViewController = homeStoryboard.instantiateViewController(withIdentifier: "DetailsChildViewController") as! DetailsChildViewController
            newViewController.targetPath = self.targetPath
            newViewController.isFromDetails = true
            self.currentViewController = newViewController
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController)
            newViewController.pageDataContent = pageContent
            newViewController.delegate = self
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.viewController?.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.contentView)

        }
        else if self.contentType == "network" {
            if pageContent.banners.count > 0 {
                self.sectionArr.append(pageContent)
            }
            if section != nil {
                self.sectionArr.append(section!)
            }
            /*for pageData in pageContent.data {
                if pageData.paneType == .section {
                    let section = pageData.paneData as! Section
                    if section.sectionInfo.dataType != "button"{
                        if section.sectionData.data.count > 0 {
                            self.sectionArr.append(section)
                        } else if section.sectionData.data.count == 0 && section.sectionData.hasMoreData {
                            self.sectionHasMoreDataArr.append(section)
                        }
                    } else {
                        if self.isPartnerWithTabs {
                            self.sectionTabArr = section.sectionData.data
                        }
                    }
                }
            }*/
            if self.isPartnerWithTabs {
                self.didSelectedItem(item: tabMenuItemNumber)
            }
            for (index, section) in self.sectionHasMoreDataArr.enumerated() {
                self.loadNextSectionContent(section: section, index: index)
            }
            if recommendationCV != nil {
                recommendationCV.alwaysBounceVertical = true
                
                recommendationCV.setContentOffset(CGPoint.zero, animated: true)
                recommendationCV.register(UINib(nibName: SectionCVC.nibname, bundle: nil), forCellWithReuseIdentifier: SectionCVC.identifier)
                recommendationCV.reloadData()
            }
        }
        else {
            self.sectionDetails = section
            
            if recommendationCV != nil {
                recommendationCV.alwaysBounceVertical = true
                
                recommendationCV.setContentOffset(CGPoint.zero, animated: true)
                recommendationCV.register(UINib(nibName: SectionCVC.nibname, bundle: nil), forCellWithReuseIdentifier: SectionCVC.identifier)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                    self.recommendationCV.reloadData()
                }
            }
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.contentType == "network" {
            return self.sectionArr.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuBarReusableView", for: indexPath) as! MenuBarReusableView
        header.tabIndex = tabMenuItemNumber
        header.titleCardArray = self.sectionTabArr
            header.isNetworkContent = self.contentType == "network" ? true : false
        header.setupViews()
        header.setIndexTabCell(index:tabMenuItemNumber)
        header.tabMenuDelegate = self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.contentType != "network" || self.sectionTabArr.count == 0 {
            return CGSize.zero
        }
        else{
            return CGSize(width: UIScreen.main.bounds.size.width, height: 47)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.contentType == "network" {
            if let pageContent = self.sectionArr[indexPath.row] as? PageContentResponse {
                if pageContent.data.count == 0 {
                    return CGSize.zero
                }
                else if productType.iPad {
                    return CGSize(width: self.frame.width, height: 300)
                }
                return CGSize(width: self.frame.width, height: 161)

            } else {
                let section = self.sectionArr[indexPath.row] as! Section
                if section.sectionInfo.dataType == "movie" {
                    if (section.sectionData.data.count) > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                        return CGSize(width: self.frame.width, height: 197)
                    }
                    else if (section.sectionData.data.count) > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                        return CGSize(width: self.frame.width, height: 177)
                    }
                    return CGSize(width: self.frame.width, height: 239)
                }
                else if section.sectionInfo.dataType == "epg" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                        return CGSize(width: self.frame.width, height: 197)
                    }
                    else if (section.sectionData.data.count) > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                        return CGSize(width: self.frame.width, height: 177)
                    }
                    return CGSize(width: self.frame.width, height: 219)
                }
                else if section.sectionInfo.dataType == "network" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                        return CGSize(width: self.frame.width, height: 145)
                    } else {
                        return CGSize(width: self.frame.width, height: 105)
                    }
                }
                else if section.sectionInfo.dataType == "button" {
                    return CGSize(width: self.frame.width, height: 62)
                }
                else if section.sectionInfo.dataType == "entity" {
                    return CGSize(width: self.frame.width, height: 197)
                }
                else{
                    if productType.iPad {
                        return CGSize(width: self.frame.width, height: 222)
                    }
                    else if (section.sectionData.data.count) > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                        return CGSize(width: self.frame.width, height: 177)
                    }
                    return CGSize(width: self.frame.width, height: 197)
                }
            }
        } else {
            if self.sectionDetails?.sectionInfo.dataType == "movie" {
                if (self.sectionDetails?.sectionData.data.count)! > 0 && (self.sectionDetails?.sectionData.data.first)!.cardType == .sheet_poster {
                    return CGSize(width: self.frame.width, height: 197)
                }
                else if ((self.sectionDetails?.sectionData.data.count)!) > 0 && (self.sectionDetails?.sectionData.data.first)!.cardType == .overlay_poster {
                    return CGSize(width: self.frame.width, height: 177)
                }else if ((self.sectionDetails?.sectionData.data.count)!) > 0 && (self.sectionDetails?.sectionData.data.first)!.cardType == .roller_poster, productType.iPad {
                    return CGSize(width: self.frame.width, height: 206 * 1.5)
                }
                return CGSize(width: self.frame.width, height: 239)
            }
            else {
                if productType.iPad{
                    return CGSize(width: self.frame.width, height: 220)
                }
                else if ((self.sectionDetails?.sectionData.data.count)!) > 0 && (self.sectionDetails?.sectionData.data.first)!.cardType == .overlay_poster {
                    return CGSize(width: self.frame.width, height: 177)
                }
                return CGSize(width: self.frame.width, height: 197)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.contentType == "network" {
            if let pageContent = self.sectionArr[indexPath.row] as? PageContentResponse {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCellId", for: indexPath) as! BannerCVC
                cell.isPartnerPage = true
                cell.partnerName = self.partnerName
                cell.banners = pageContent.banners
                //cell.scrollTheBanners(true)
                cell.bannerDelegate = self
                return cell

            } else {
                let section = self.sectionArr[indexPath.row] as! Section
                let sectionData = section.sectionData
                let sectionInfo = section.sectionInfo
                let sectionControls = section.sectionControls
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCVC.identifier, for: indexPath) as! SectionCVC
                if sectionInfo.dataType == "movie" {
                    if section.sectionData.data.count > 0 && ((section.sectionData.data.first)!.cardType == .sheet_poster || (section.sectionData.data.first)!.cardType == .overlay_poster) {
                        cell.collectionViewHeightConstraint.constant = 157.0
                    } else {
                        cell.collectionViewHeightConstraint.constant = 210.0
                    }
                    cell.isMovieCell = true
                }
                else if sectionInfo.dataType == "epg" {
                    if section.sectionData.data.count > 0 && ((section.sectionData.data.first)!.cardType == .sheet_poster || (section.sectionData.data.first)!.cardType == .overlay_poster) {
                        cell.collectionViewHeightConstraint.constant = 157.0
                    }
                    else {
                        cell.collectionViewHeightConstraint.constant = 179.0
                    }
                    cell.isMovieCell = false
                }
                else if sectionInfo.dataType == "network" {
                    if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                        cell.collectionViewHeightConstraint.constant = 99.0
                    } else {
                        cell.collectionViewHeightConstraint.constant = 65.0
                    }
                    cell.isMovieCell = false
                }
                else if sectionInfo.dataType == "button" {
                    cell.collectionViewHeightConstraint.constant = 42.0
                    cell.isMovieCell = false
                }
                else if sectionInfo.dataType == "entity" {
                    cell.collectionViewHeightConstraint.constant = 142.0
                    cell.isMovieCell = false
                }
                else {
                    cell.collectionViewHeightConstraint.constant = 157.0
                    cell.isMovieCell = false
                }

                if (sectionInfo.name .isEmpty) {
                    cell.myLbl.text = sectionInfo.code.capitalized
                }
                else {
                    cell.myLbl.text = sectionInfo.name
                }
                cell.setUpData(sectionData: sectionData, sectionInfo: sectionInfo,sectionControls: sectionControls, pageData: self.pageContent!)
//                cell.moreBtn.isHidden = true
                cell.delegate = self
                return cell
            }
        }else {
            let sectionData = self.sectionDetails?.sectionData
            let sectionInfo = self.sectionDetails?.sectionInfo
            let sectionControls = self.sectionDetails?.sectionControls
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCVC.identifier, for: indexPath) as! SectionCVC
            cell.isFromDetails = true
            if sectionInfo?.dataType == "movie" {
                if (sectionData?.data.count)! > 0 && ((sectionData?.data.first)!.cardType == .sheet_poster || (sectionData?.data.first)!.cardType == .overlay_poster) {
                    cell.collectionViewHeightConstraint.constant = 157.0
                } else {
                    cell.collectionViewHeightConstraint.constant = 199.0
                }
            }
            else {
                if productType.iPad {
                    cell.collectionViewHeightConstraint.constant = 180.0
                }
                else {
                    cell.collectionViewHeightConstraint.constant = 157.0
                    if appContants.appName == .gac {
                        cell.collectionViewHeightConstraint.constant = 182.0
                    }
                }
            }
            if sectionInfo?.code == "recommendations" {
                if self.contentType == "movie" {
                    cell.myLbl.text = AppDelegate.getDelegate().movieDetailsRecommendationText
                }
                else if self.contentType == "tvshowepisode" || self.contentType == "tvshow" {
                    cell.myLbl.text = AppDelegate.getDelegate().tvshowDetailsRecommendationText

                }
                else {
                    cell.myLbl.text = AppDelegate.getDelegate().channelRecommendationText
                }
            }
            else{
                if (sectionInfo?.name .isEmpty)! {
                    cell.myLbl.text = sectionInfo?.code.capitalized
                }
                else {
                    cell.myLbl.text = sectionInfo?.name
                }
            }
                
            cell.setUpData(sectionData: sectionData!, sectionInfo: sectionInfo!,sectionControls: sectionControls!, pageData: self.pageContent!)
//            cell.moreBtn.isHidden = true
            cell.delegate = self
            return cell

        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func loadNextSectionContent(section:Section,index:Int) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        OTTSdk.mediaCatalogManager.sectionContent(path: self.pageContent!.info.path, code: section.sectionInfo.code, offset: section.sectionData.lastIndex, count: nil, filter: nil, onSuccess: { (response) in
//            self.stopAnimating()
            if response.count > 0 {
                if (response.first?.data.count)! > 0 {
                    section.sectionData = response.first!
                    self.sectionArr.append(section)
                    self.goGetTheData = true
                }
                else {
                    if self.sectionHasMoreDataArr.indices.contains(index) {
                        self.sectionHasMoreDataArr.remove(at: index)
                    } else {
                        self.goGetTheData = false
                    }
                }
                if self.sectionArr.count > 0 {
                    self.errorView.isHidden = true
                    self.recommendationCV.isHidden = false
                } else {
                    self.errorView.isHidden = false
                    self.recommendationCV.isHidden = false
                }
                self.recommendationCV.reloadData()
            }
            else {
                if self.sectionHasMoreDataArr.indices.contains(index) {
                    self.sectionHasMoreDataArr.remove(at: index)
                }
                if self.sectionArr.count > 0 {
                    self.errorView.isHidden = true
                    self.recommendationCV.isHidden = false
                } else {
                    self.errorView.isHidden = false
                    self.recommendationCV.isHidden = false
                }
            }
        }) { (error) in
//            self.stopAnimating()
            Log(message: error.message)
        }
    }

    //MARK: - Custom Methods
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        if oldViewController == newViewController {
            return
        }
        oldViewController.willMove(toParent: nil)
        self.currentViewController?.addChild(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.contentView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        updatingViewController = newViewController
        UIView.animate(withDuration: 0.5, animations: {
            if newViewController == self.updatingViewController{
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            }
        },
                       completion: { finished in
                        if newViewController == self.updatingViewController{
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParent()
                            newViewController.didMove(toParent: self.viewController)
                        }
        })
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

    func didSelectedSuggestion(card: Card) {
        self.delegate?.selectedRollerPosterItem(item: card)
    }
    //MARK: - movie custom delegate methods
    func didSelectedRollerPosterItem(item: Card) -> Void{
        self.delegate?.selectedRollerPosterItem(item: item)
    }
    func rollerPoster_moreClicked(sectionData:SectionData,sect_data:SectionInfo,sectionControls:SectionControls){
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
//        self.startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path: sectionControls.viewAllTargetPath) { (viewController, pageType) in
            if let vc = viewController as? ContentViewController{
                
                vc.isToViewMore = true
                vc.targetedMenu = sectionControls.viewAllTargetPath
                vc.sectionTitle = sect_data.name
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = sect_data.name
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
            else if (viewController is DefaultViewController){
                let defaultViewController = viewController as! DefaultViewController
                defaultViewController.delegate = self
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                if let vc = viewController as? ListViewController{
                    vc.isToViewMore = true
                    vc.sectionTitle = sect_data.name
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                    
                }
            }
//            self.stopAnimating()
        }
    }


    //MARK: - recommendations delegate methods
    func didSelectedRecommendation(card : Card) {
        self.delegate?.selectedRollerPosterItem(item: card)
    }
    //    //MARK: - banner delegate Methods
    func didSelectedBannerItem(bannerItem: Banner) -> Void
    {
        self.delegate?.bannerSelected(item: bannerItem)
    }
    // MARK: - Tabmenu protocol methods
    func didSelectedItem(item: Int){
        tabMenuItemNumber = item
        let card = self.sectionTabArr[item]
        OTTSdk.mediaCatalogManager.pageContent(path: card.target.path, onSuccess: { (response) in
            self.sectionArr.removeAll()
            self.sectionHasMoreDataArr.removeAll()
            if response.banners.count > 0 {
                self.sectionArr.append(response)
            }
            if response.data.count > 0 {
                for pageData in response.data {
                    if pageData.paneType == .section {
                        let section = pageData.paneData as! Section
                        if section.sectionInfo.dataType != "button" {
                            if section.sectionData.data.count > 0 {
                                self.sectionArr.append(section)
                            } else if section.sectionData.data.count == 0 && section.sectionData.hasMoreData {
                                self.sectionHasMoreDataArr.append(section)
                            }
                        }
                    }
                }
                for (index, section) in self.sectionHasMoreDataArr.enumerated() {
                    self.loadNextSectionContent(section: section, index: index)
                }
                if self.sectionArr.count > 0 {
                    self.errorView.isHidden = true
                    self.recommendationCV.isHidden = false
                } else {
                    self.errorView.isHidden = false
                    self.recommendationCV.isHidden = false
                }
                self.recommendationCV.reloadData()
                    
            } else {
                self.errorView.isHidden = false
                self.recommendationCV.isHidden = false
                self.recommendationCV.reloadData()
            }
        }) { (error) in
            self.sectionArr.removeAll()
            self.errorView.isHidden = false
            self.recommendationCV.isHidden = false
            self.recommendationCV.reloadData()
        }
//        AppDelegate.getDelegate().detailsTabMenuIndex = item
//        if item == 0 {
//            var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 113)
//            tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
//            cVL.cellSize = tmpCellsize
//
//        }else if item == 1{
//            var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 219)
//            tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
//            cVL.cellSize = tmpCellsize
//        }else{
//            var tmpCellsize = CGSize(width: UIScreen.main.bounds.size.width, height: 219)
//            tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
//            cVL.cellSize = tmpCellsize
//        }
//        var index = 0
//        for pageData in (pageDataContent?.data)! {
//            if pageData.paneType == .section {
//                let section = pageData.paneData as? Section
//                if section?.sectionData.section == sectionList[tabMenuItemNumber].code || (sectionList[tabMenuItemNumber].sectionCodes.contains((section?.sectionData.section)!) && tabMenuItemNumber == index) {
//                    self.sectionDataList = (section?.sectionData.data)!
//                    self.hasMoreData = (section?.sectionData.hasMoreData)!
//                    self.lastIndex = (section?.sectionData.lastIndex)!
//                }
//                index = index + 1
//            }
//            if self.sectionDataList.count == 0 {
//                self.errorView.isHidden = false
//                self.view.sendSubview(toBack: errorView)
//            }
//            else {
//                self.errorView.isHidden = true
//                self.recommendationsCV.isHidden = false
//            }
//        }
//        self.goGetTheData = true
//        self.recommendationsCV.setContentOffset(CGPoint.zero, animated: false)
//        self.recommendationsCV.reloadData()
    }

}
