//
//  SearchViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 14/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast
import GoogleMobileAds

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PlayerViewControllerDelegate,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate,PartialRenderingViewDelegate,GADBannerViewDelegate,SectionCVCProtocal, DefaultViewControllerDelegate {
    func retryTap() {
        
    }
    
   
   
    @IBOutlet weak var catergoryBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchResultsLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchResultsLbl: UILabel!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var dropdownImage: UIImageView!
    @IBOutlet weak var collectionViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchSuggestionsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var searchedContentCV: UICollectionView!
    
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20
    
    var searchActive : Bool = false
    var suggestionsData = [String]()
    var searchedContentData = [SearchDataType]()
    var selectedDataTypeObj = SearchDataType()
    var searchString = String()
    var cVL: CustomFlowLayout!
    var secInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    var cellSizes: CGSize = CGSize(width: 120, height: (productType.iPad ? 93 :73))
    var numColums: CGFloat = (productType.iPad ? 2 : 1)
    var interItemSpacing: CGFloat = (productType.iPad ? 20 : 10)
    var minLineSpacing: CGFloat = (productType.iPad ? 20 : 10)
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    
    let refreshControl = UIRefreshControl()
    var tempNavigationFrom = "-1"
    var pageNum: Int = 0
    var pageCount: Int = 10
    var selectedDataType:String? = nil
    var goGetTheData : Bool = true
    var delegate : PartialRenderingViewDelegate?
    var searchHistoryArray = [SearchHistoryData]()
    
    var recommendationsCollectionView: UICollectionView!
    var pageContentResponse : PageContentResponse!
    var pageData = [PageData]()
    
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerAdView: UIView!

    struct SearchDataType {
        var dataType = ""
        var displayName = ""
        var pageNum = 0
        var cards = [Card]()
        var isPaginationAvailable:Bool = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            ccHeight = miniMediaControlsViewController.minHeight
        }
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryBtn.isHidden = true
        self.dropdownImage.isHidden = true
        self.backButton.isHidden = true
        self.backButtonWidthConstraint.constant = 0
        
        self.searchHistoryArray = CoreDataManager.shared.fetchRetriveData(predicate: nil)
        if #available(iOS 15.0, *) {
            searchSuggestionsTableView.sectionHeaderTopPadding = 0
        }
        if appContants.appName == .supposetv {
            self.backButton.isHidden = false
            self.backButtonWidthConstraint.constant = 52
        }
//        if appContants.appName == .aastha {
//            self.backButton.isHidden = false
//            self.backButtonWidthConstraint.constant = 52
//            if appContants.appName == .aastha {
//                backButton.setImage(#imageLiteral(resourceName: "leftNavigation").withRenderingMode(.alwaysTemplate), for: .normal)
//                backButton.tintColor = AppTheme.instance.currentTheme.cardTitleColor
//                if let buttonItem = searchBar.subviews.first?.subviews.last as? UIButton {
//                    buttonItem.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
//                }
//            }
//        }
        if let buttonItem = searchBar.subviews.first?.subviews.last as? UIButton {
            buttonItem.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        }
        
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.collectionViewRightConstraint.constant = 0.0
        self.collectionViewLeftConstraint.constant = 0.0
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.tempNavigationFrom = AppAnalytics.navigatingFrom
        AppAnalytics.navigatingFrom = "search"
        AppDelegate.getDelegate().taggedScreen = "Search"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        //        self.view.backgroundColor = UIColor.appBackgroundColor
        self.searchSuggestionsTableView.delegate = self
        self.searchSuggestionsTableView.dataSource = self
        self.searchSuggestionsTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "suggestionsCell")
        self.searchSuggestionsTableView.separatorColor = UIColor.init(red: 158.0/255.0, green: 162.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        self.searchResultsLbl.text = ""
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        textFieldInsideSearchBar?.changeBorder(color: AppTheme.instance.currentTheme.cardTitleColor)
        textFieldInsideSearchBar?.viewBorderWithOne(cornersRequired: true)
        
        
        refreshControl.tintColor = UIColor.activityIndicatorColor()
        refreshControl.addTarget(self, action: #selector(Refresh(_:)), for: .valueChanged)
        self.searchedContentCV.addSubview(refreshControl)
        self.searchedContentCV.alwaysBounceVertical = true
        
        self.searchedContentCV.setContentOffset(CGPoint.zero, animated: true)

        self.searchedContentCV.dataSource = self
        self.searchedContentCV.delegate = self
        self.searchedContentCV.register(UINib(nibName: SearchCommonPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLV.identifier)
        self.searchedContentCV.register(UINib(nibName: RollerPosterLV.nibname, bundle: nil), forCellWithReuseIdentifier: RollerPosterLV.identifier)
        self.searchedContentCV.register(UINib(nibName: SheetPosterCellLV.nibname, bundle: nil), forCellWithReuseIdentifier: SheetPosterCellLV.identifier)
        self.searchedContentCV.register(UINib(nibName: SheetPosterCellGV.nibname, bundle: nil), forCellWithReuseIdentifier: SheetPosterCellGV.identifier)
        self.searchedContentCV.register(UINib(nibName: SearchCommonPosterCellLViPad.nibname, bundle: nil), forCellWithReuseIdentifier: SearchCommonPosterCellLViPad.identifier)
      
        cVL = CustomFlowLayout()
        cVL.interItemSpacing = interItemSpacing
        cVL.secInset = secInsets
        cVL.cellRatio = false
        cVL.interItemSpacing = (minLineSpacing/numColums) * (numColums-1)
        if (scrollDir == .vertical) {
            if !productType.iPad {
                cVL.interItemSpacing = interItemSpacing
            }
        }
        cVL.cellSize = cellSizes
        cVL.minLineSpacing = minLineSpacing
        self.calculateNumCols()
        cVL.scrollDir = scrollDir
        cVL.setupLayout()
        self.searchedContentCV.collectionViewLayout = cVL
                
        let recommendationsCFL = CustomFlowLayout()
        recommendationsCFL.cellRatio = false
        recommendationsCFL.scrollDir = .horizontal
         
        
        recommendationsCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 187), collectionViewLayout: recommendationsCFL)
        recommendationsCollectionView.isScrollEnabled = false
        recommendationsCollectionView.setContentOffset(CGPoint.zero, animated: false)
         
         recommendationsCollectionView.register(UINib(nibName: SectionCVC.nibname, bundle: nil), forCellWithReuseIdentifier: SectionCVC.identifier)
         recommendationsCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifier")
        self.recommendationsCollectionView.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
        self.recommendationsCollectionView.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewFooterClass.identifier)
 
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self

        recommendationsCollectionView.isHidden = true
        
        if productType.iPad {
            secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        } else {
            secInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
            numColums = 2
            interItemSpacing = 10
            minLineSpacing = 10
        }
        
        
        self.searchedContentCV.isHidden = true
        self.searchBar.delegate = self
      
        if appContants.appName == .tsat {
            self.searchBar.placeholder = "Search_tsat".localized
        }
        else if appContants.appName == .gac {
            self.searchBar.placeholder = "Search_gac".localized
        }
        else{
            self.searchBar.placeholder = "Search".localized
        }
        self.searchBar.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        //self.searchBar.becomeFirstResponder()
        self.searchBar.showsCancelButton = true
        
        let cancelButton = self.searchBar.value(forKey: "cancelButton") as! UIButton
        cancelButton.setTitle("cancel".localized, for: .normal)
        cancelButton.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal)
        
        self.searchBar.showsCancelButton = false
         
       
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
            
            let placeholder = textFieldInsideSearchBar.placeholder ?? ""
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : AppTheme.instance.currentTheme.cardTitleColor as Any])
        }
        
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
        
        self.errorLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.searchResultsLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.searchedContentCV.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        self.loadBannerAd()
        self.updateDocPlayerFrame()
        self.loadDefaultData()
    }
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is SearchViewController {
            self.updateDocPlayerFrame()
            var ccHeight:CGFloat = 0.0
            if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
                ccHeight = miniMediaControlsViewController.minHeight
            }
            AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false,chromeCastHeight:ccHeight)
        }
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    @IBAction func BackButtonClicked(_ sender: Any) {
        AppAnalytics.navigatingFrom = self.tempNavigationFrom
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func loadDefaultData() {
        self.startAnimating(allowInteraction: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            OTTSdk.mediaCatalogManager.pageContent(path: "search", onSuccess: { (response) in
                self.pageContentResponse = response
                if self.pageData.count > 0 {
                    self.pageData.removeAll()
                }
                if self.pageContentResponse != nil && self.pageContentResponse.data.count > 0{
                    for section in self.pageContentResponse.data {
                        if section.paneType == .section {
                            self.pageData.append(section)
                            break;
                        }
                    }
                }
                if self.pageData.count > 0 {
                    self.recommendationsCollectionView.dataSource = nil
                    self.recommendationsCollectionView.delegate = nil
                    self.recommendationsCollectionView.dataSource = self
                    self.recommendationsCollectionView.delegate = self
                    self.recommendationsCollectionView.setContentOffset(CGPoint.zero, animated: false)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                        self.recommendationsCollectionView.reloadData()
                        self.recommendationsCollectionView.backgroundColor = .clear
                        if self.searchBar.text?.count == 0 {
                            self.searchSuggestionsTableView.tableHeaderView = self.recommendationsCollectionView
                            self.recommendationsCollectionView.reloadData()
                            self.recommendationsCollectionView.isHidden = false
                            self.searchSuggestionsTableView.reloadData()
                        }
                        else {
                            self.searchSuggestionsTableView.tableHeaderView = nil
                            self.searchSuggestionsTableView.reloadData()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                            self.recommendationsCollectionView.reloadData()
                        }
                    }
                }
               
                self.stopAnimating()
            }) { (error) in
                print(error.message)
                self.stopAnimating()
            }
        }
    }
    
    @IBAction func categoryBtnClicked(_ sender: Any) {
        
        if self.searchedContentData.count > 0 {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            let titleAttrString = NSMutableAttributedString(string: "Category", attributes: [NSAttributedString.Key.font: UIFont.ottBoldFont(withSize: 20.0)])
            let messageAttrString = NSMutableAttributedString(string: "Please Select your desired Category", attributes: [NSAttributedString.Key.font: UIFont.ottSemiBoldFont(withSize: 15.0)])
            titleAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppTheme.instance.currentTheme.applicationBGColor as Any, range: NSRange(location:0,length:titleAttrString.length))
            messageAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppTheme.instance.currentTheme.applicationBGColor as Any, range: NSRange(location:0,length:titleAttrString.length))
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            alert.setValue(messageAttrString, forKey: "attributedMessage")
            
            
            for (index,responseObj) in self.searchedContentData.enumerated() {
                alert.addAction(UIAlertAction(title: responseObj.displayName, style: .default , handler:{ (UIAlertAction)in
                    self.selectedCategory(index)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        self.Refresh(self)
                    }
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
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
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectedCategory(_ categoryIndex:Int) {
        self.selectedDataTypeObj.cards.removeAll()
        self.searchedContentCV.reloadData()
        self.selectedDataTypeObj = self.searchedContentData[categoryIndex]
        //        self.catergoryBtnWidthConstraint.constant = 80.0
        self.categoryBtn.setTitle("", for: .normal)
        self.categoryBtn.setTitle(self.selectedDataTypeObj.displayName, for: .normal)
        self.categoryBtn.sizeToFit()
        self.categoryBtn.frame.size.height = 30
        self.categoryBtn.frame.size.width = self.categoryBtn.frame.size.width + 40
        self.catergoryBtnWidthConstraint.constant =  self.categoryBtn.frame.size.width
        self.searchResultsLabelWidthConstraint.constant = AppDelegate.getDelegate().window!.frame.size.width - self.catergoryBtnWidthConstraint.constant - 40
        
        self.selectedDataType = self.selectedDataTypeObj.dataType
        print("self.selectedDataTypeObj.cards.count : \(self.selectedDataTypeObj.cards.count)")
        if self.selectedDataTypeObj.cards.count > 0{
            self.searchResultsLbl.text = "\(self.selectedDataTypeObj.cards.count) results for: '\(self.searchString)'"
            self.searchedContentCV.isHidden = false
            self.searchSuggestionsTableView.isHidden = true
            self.searchedContentCV.reloadData()
        }
        else{
            self.errorLabel.text = "Sorry, no results matching".localized + " ‘" + self.searchString + "’"
            self.searchResultsLbl.text = ""
            self.errorLabel.isHidden = false
            self.searchSuggestionsTableView.isHidden = true
            self.searchedContentCV.isHidden = true
        }
    }
    
    func updateCellSizes(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        
        if appContants.appName == .gac {
        let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*15))/numColums
        let tempHeight = tempWidth * 0.5625
        return CGSize(width: tempWidth, height: (tempHeight + 52.0))
        }
        else {
            
            let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
            
            if cardObj.cardType == .overlay_poster {
                if productType.iPad {
                    let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                    let ratioheight = newW * 9/16
                    let newCellSize = CGSize(width: newW, height: 93 )
                    printYLog("newCellSize vertical: ", newCellSize)
                    return newCellSize
                }
                else {
                    let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                    let newCellSize = CGSize(width: newW, height: 73 )
                    printYLog("newCellSize Width: ", newCellSize)
                    return newCellSize
                }
            }else if cardObj.cardType == .sheet_poster {
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*20))/numColums
                let tempHeight = tempWidth * 0.5625
                if appContants.appName == .gac {
                    return CGSize(width: tempWidth, height: tempHeight + 52.0 + 25.0)
                }
                return CGSize(width: tempWidth, height: (tempHeight + 52.0))
            }
            else {
                if productType.iPad {
                    return CGSize(width: 333, height: 123)
                }
                return CGSize(width: 333, height: 73)
            }
        }
    }
    func calculateNumCols() {
        if productType.iPad {
            if currentOrientation().portrait {
                if selectedDataTypeObj.cards.count > 0, selectedDataTypeObj.cards[0].cardType == .sheet_poster {
                    numColums = 3
                }else {
                    numColums = 2
                }
            } else if currentOrientation().landscape {
                if selectedDataTypeObj.cards.count > 0, selectedDataTypeObj.cards[0].cardType == .sheet_poster {
                    numColums = 4
                }else {
                    numColums = 3
                }
            }else {
                if selectedDataTypeObj.cards.count > 0, selectedDataTypeObj.cards[0].cardType == .sheet_poster {
                    numColums = 3
                }else {
                    numColums = 2
                }
            }
        } else {
            if appContants.appName == .gac {
                numColums = 2
            }
            else {
                if selectedDataTypeObj.cards.count > 0, selectedDataTypeObj.cards[0].cardType == .sheet_poster {
                    numColums = 2
                    //cVL.interItemSpacing = (minLineSpacing/numColums) * (numColums-1)
                }else {
                    numColums = 1
                }
            }
        }
        cVL.numberOfColumns = numColums
        print("numColums: ", self.numColums)
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation){
        if productType.iPad {
            self.calculateNumCols()
            self.searchedContentCV.reloadData()
            //            MovieCV.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    // MARK: - Navigation
    
    @IBAction func Refresh(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.searchedContentCV.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        if collectionView == self.recommendationsCollectionView {
           return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
        }
        else {
            return secInsets
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recommendationsCollectionView {
            return self.pageData.count
        }
        else {
            return (self.selectedDataTypeObj.cards.count)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("rendering cell: ", indexPath.item)
        if collectionView == self.recommendationsCollectionView {
            let pageDataItem = self.pageData[indexPath.item]
            //self.indexPath = indexPath.item
            //if pageDataItem.paneType == .section {
            let section = pageDataItem.paneData as? Section
            return getSectionCell(collectionView, cellForItemAt: indexPath, section: section!)
            //}
        }
        else {
            cellSizes = self.updateCellSizes(collectionView: searchedContentCV, indexPath: indexPath)
            self.calculateNumCols()
            cVL.cellSize = cellSizes
            cVL.scrollDir = scrollDir
            cVL.setupLayout()
            searchedContentCV.collectionViewLayout = cVL
            let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
            if appContants.appName == .gac {
                if cardObj.cardType == .circle_poster {
                    let cardDisplay = cardObj.display
                    
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
                    print("yay")
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SheetPosterCellGV.identifier, for: indexPath) as! SheetPosterCellGV
                if productType.iPad {
                    cell.imageView.contentMode = .topLeft
                    cell.imageViewHeightConstraint.constant = 250
                }
                let cardInfo = cardObj.display
                cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                cell.name.text = cardInfo.title
                cell.titleHeight.constant = 35
                cell.titleTopConstraint.constant = 3.0
                cell.name.font = UIFont.ottRegularFont(withSize: 12)
                cell.subtitleTop.constant = 1.0
                cell.name.lineBreakMode = .byWordWrapping
                cell.name.numberOfLines = 2
                cell.desc.text = cardInfo.subtitle1
                cell.watchedProgressView.isHidden = true
                //            cell.imageView.layer.cornerRadius = 5.0
                cell.tagLbl.isHidden = true
                cell.tagImgView.isHidden = true
                cell.nowPlayingStrip.isHidden = true
                cell.nowPlayingHeightConstraint.constant = 0.0
                cell.durationLabel.isHidden = true
                cell.durationLblBottomConstraint.constant = 5.0
                for marker in cardObj.display.markers {
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
                if appContants.appName != .aastha {
                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                }
                //let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                //let tempHeight = tempWidth * 0.5625
                //            cell.imageViewHeightConstraint.constant = tempHeight
                cell.cornerDesignForCollectionCell()
                return cell
            }
            else {
                let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
                if cardObj.cardType == .roller_poster {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RollerPosterLV.identifier, for: indexPath) as! RollerPosterLV
                    let cardInfo = cardObj.display
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    cell.name.text = cardInfo.title
                    cell.desc.text = cardInfo.subtitle1
                    cell.expiryInfoLbl.isHidden = true
                    cell.expiryInfoLbl.text = ""
                    cell.watchedProgressView.isHidden = true
                    cell.badgeLbl.isHidden = true
                    for marker in cardObj.display.markers {
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
                    }
                    
                    
                    return cell
                }
                else if cardObj.cardType == .band_poster {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BandPosterCellLV.identifier, for: indexPath) as! BandPosterCellLV
                    let cardInfo = cardObj.display
                    cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    if !cardInfo.parentIcon.isEmpty {
                        cell.imageView.loadingImageFromUrl(cardInfo.parentIcon, category: "tv")
                    }else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.desc.text = cardInfo.title
                    cell.name.text = cardInfo.subtitle1
                    cell.visulEV.blurRadius = 5
                    return cell
                }
                else if cardObj.cardType == .sheet_poster {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SheetPosterCellGV.identifier, for: indexPath) as! SheetPosterCellGV
                    let cardInfo = cardObj.display
                    cell.backgroundColor = AppTheme.instance.currentTheme.cellBackgorundColor
                    cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
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
                    //            cell.imageView.layer.cornerRadius = 5.0
                    cell.tagLbl.isHidden = true
                    cell.tagImgView.isHidden = true
                    cell.nowPlayingStrip.isHidden = true
                    cell.nowPlayingHeightConstraint.constant = 0.0
                    cell.durationLabel.isHidden = true
                    cell.durationLblBottomConstraint.constant = 5.0
                    for marker in cardObj.display.markers {
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
                    if appContants.appName != .aastha {
                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    }
                    //let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                    //let tempHeight = tempWidth * 0.5625
                    //            cell.imageViewHeightConstraint.constant = tempHeight
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else if cardObj.cardType == .overlay_poster || cardObj.cardType == .channel_poster{
                    
                    let cardDisplay = cardObj.display
                    collectionView.register(UINib(nibName: "OverlayPosterLV", bundle: nil), forCellWithReuseIdentifier: "OverlayPosterLV")
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverlayPosterLV", for: indexPath) as! OverlayPosterLV
                    cell.name.text = cardDisplay.title
                    cell.desc.text = cardDisplay.subtitle1
                    cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                    cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
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
                    cell.imageView.contentMode = .scaleAspectFit
                    cell.liveTagLbl.isHidden = true
                    cell.badgeSubLbl.isHidden = true
                    cell.badgeSubLbl.text = ""
                    if cardObj.display.markers.count > 0 {
                        for marker in cardObj.display.markers {
                            if marker.markerType == .seek {
                                cell.watchedProgressView.isHidden = false
                                cell.watchedProgressView.progress = Float.init(marker.value)!
                                cell.watchedProgressView.tintColor = AppTheme.instance.currentTheme.watchedProgressTintColor
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
                    cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                    cell.cornerDesignForCollectionCell()
                    return cell
                }
                else if cardObj.cardType == .sheet_poster {
                    if productType.iPad {
                        let cardDisplay = cardObj.display
                        collectionView.register(UINib(nibName: "SheetPosterCellGV-iPad", bundle: nil), forCellWithReuseIdentifier: "SheetPosterCellGViPad")
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SheetPosterCellGViPad", for: indexPath) as! SheetPosterCellGViPad
                        cell.name.text = cardDisplay.title
                        cell.desc.text = cardDisplay.subtitle1
                        if !cardDisplay.parentIcon .isEmpty && cardDisplay.parentIcon.contains("https") {
                            cell.imageView.loadingImageFromUrl(cardDisplay.parentIcon, category: "tv")
                        }else {
                            cell.imageView.loadingImageFromUrl(cardDisplay.imageUrl, category: "tv")
                        }
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
                            }
                        }
                        cell.imageView.viewCornersWithFive()
                        //                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                        //                    let tempHeight = tempWidth * 0.5625
                        //                    cell.imageViewHeightConstraint.constant = tempHeight
                        return cell
                    }
                    else {
                        let cardDisplay = cardObj.display
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
                        cell.stopRecordingBtn.setTitle(AppDelegate.getDelegate().buttonStopRecord, for: .normal)
                        cell.recordBtn.isHidden = true
                        cell.stopRecordingBtn.isHidden = true
                        cell.tagLbl.isHidden = true
                        cell.tagImgView.isHidden = true
                        cell.nowPlayingStrip.isHidden = true
                        cell.nowPlayingHeightConstraint.constant = 0.0
                        cell.durationLabel.isHidden = true
                        cell.durationLblBottomConstraint.constant = 5.0
                        
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
                        
                        cell.imageView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5.0)
                        let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*10))/numColums
                        let tempHeight = tempWidth * 0.5625
                        cell.imageViewHeightConstraint.constant = tempHeight
                        cell.cornerDesignForCollectionCell()
                        return cell
                    }
                }
                
                else if cardObj.cardType == .box_poster {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxPosterCellLV.identifier, for: indexPath) as! BoxPosterCellLV
                    let cardInfo = cardObj.display
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
                else if cardObj.cardType == .pinup_poster {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinupPosterCellLV.identifier, for: indexPath) as! PinupPosterCellLV
                    let cardInfo = cardObj.display
                    cell.iconView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    if !cardInfo.parentIcon .isEmpty {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    else {
                        cell.imageView.loadingImageFromUrl(cardInfo.imageUrl, category: "tv")
                    }
                    cell.name.text = cardInfo.subtitle1
                    cell.desc.text = cardInfo.title
                    return cell
                }
                else {
                    if productType.iPad {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLViPad.identifier, for: indexPath) as! SearchCommonPosterCellLViPad
                        cell.imageView.loadingImageFromUrl(cardObj.display.imageUrl, category: "tv")
                        cell.name.text = cardObj.display.title
                        cell.desc.text = cardObj.display.subtitle1
                        cell.subDesc.text = cardObj.display.subtitle2
                        
                        for marker in cardObj.display.markers {
                            if marker.markerType == .badge {
                                cell.viewWithTag(1)?.isHidden = false
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
                                break
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
                        }
                        if cardObj.display.markers.count == 0 {
                            cell.viewWithTag(1)?.isHidden = true
                        }
                        else {
                            cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                        }
                        return cell
                        
                    }
                    else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCommonPosterCellLV.identifier, for: indexPath) as! SearchCommonPosterCellLV
                        cell.imageView.loadingImageFromUrl(cardObj.display.imageUrl, category: "tv")
                        cell.name.text = cardObj.display.title
                        cell.desc.text = cardObj.display.subtitle1
                        cell.subDesc.text = cardObj.display.subtitle2
                        
                        //            var dotWidthConstraint : NSLayoutConstraint?
                        //            for constraint in cell.redDotView.constraints as [NSLayoutConstraint] {
                        //                if constraint.identifier == "dotWidthConstraint" {
                        //                    dotWidthConstraint = constraint
                        //                }
                        //            }
                        //            dotWidthConstraint?.constant = 0
                        
                        for marker in cardObj.display.markers {
                            if marker.markerType == .badge {
                                cell.viewWithTag(1)?.isHidden = false
                                if cell.nameXPositionConstraint != nil {
                                    cell.nameXPositionConstraint.constant = 9.0
                                }
                                cell.markerLabel.text = marker.value
                                cell.redDotView.isHidden = true
                                break
                            }
                            else if marker.markerType == .special {
                                cell.viewWithTag(1)?.isHidden = true
                                
                                if marker.value == "live_dot" {
                                    //                        dotWidthConstraint?.constant = 6
                                    if cell.nameXPositionConstraint != nil {
                                        cell.nameXPositionConstraint.constant = 20.0
                                    }
                                    cell.redDotView.isHidden = false
                                    cell.redDotView.layer.cornerRadius = cell.redDotView.frame.size.width/2.0
                                }
                                //                        break
                            }
                            else if (marker.markerType == .duration || marker.markerType == .leftOverTime) && !(marker.value .isEmpty) {
                                if cell.nameXPositionConstraint != nil {
                                    cell.nameXPositionConstraint.constant = 9.0
                                }
                                cell.viewWithTag(1)?.isHidden = true
                                cell.redDotView.isHidden = true
                            }
                            else if marker.markerType == .tag {
                                if cell.nameXPositionConstraint != nil {
                                    cell.nameXPositionConstraint.constant = 9.0
                                }
                                cell.viewWithTag(1)?.isHidden = true
                                cell.redDotView.isHidden = true
                            }
                            else if marker.markerType == .rating {
                                if cell.nameXPositionConstraint != nil {
                                    cell.nameXPositionConstraint.constant = 9.0
                                }
                                cell.viewWithTag(1)?.isHidden = true
                                cell.redDotView.isHidden = true
                            }
                        }
                        if cardObj.display.markers.count == 0 {
                            cell.viewWithTag(1)?.isHidden = true
                        }
                        else {
                            cell.viewWithTag(1)?.layer.cornerRadius = 1.0
                        }
                        return cell
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (productType.iPad ? 20 : 10)
    }
     
    
    func gotoPdfPage(path:String,title:String) {
        self.stopAnimating()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Content", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "PdfFileViewController") as! PdfFileViewController
        view1.pdfPath = path
        view1.pageString = title
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
    }
    
    private func gotoTargetedWith(path : String, cardItem : Card?, analytics : String?) {
        
        if cardItem != nil && cardItem!.target.pageAttributes != nil {
            if let _pageSubtype = cardItem!.target.pageAttributes!["pageSubtype"] as? String, _pageSubtype == "pdf" {
                gotoPdfPage(path: path,title:cardItem?.display.title ?? "")
                return
            }
        }
        
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            self.stopAnimating()
            if let a = analytics {
                AppAnalytics.navigatingFrom = a
            }
            var vc : UIViewController!
            if let tempController = viewController as? PlayerViewController {
                tempController.delegate = self
                if let item = cardItem {
                    tempController.defaultPlayingItemUrl = item.display.imageUrl
                    tempController.playingItemTitle = item.display.title
                    tempController.playingItemSubTitle = item.display.subtitle1
                    tempController.playingItemTargetPath = path
                }
               
                AppDelegate.getDelegate().window?.addSubview(tempController.view)
                return
            }else if let tempController = viewController as? ContentViewController {
                tempController.isToViewMore = true
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                }
                vc = tempController
            }else if let tempController = viewController as? DetailsViewController {
                if let item = cardItem {
                    tempController.navigationTitlteTxt = item.display.title
                    tempController.isCircularPoster = item.cardType == .circle_poster ? true : false
                }
                vc = tempController
            }else if let tempController = viewController as? ListViewController{
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                    tempController.isToViewMore = true
                }
                vc = tempController
            }else {
                vc = viewController
            }
            guard vc != nil else {return}
            guard let topVc = UIApplication.topVC() else {return}
            topVc.navigationController?.pushViewController(vc, animated: true)

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.recommendationsCollectionView {
        }
        else {
            self.startAnimating(allowInteraction: false)
            let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
            if cardObj.template != "" {
                PartialRenderingView.instance.reloadFor(card: cardObj, content: nil, partialRenderingViewDelegate: self)
                self.stopAnimating()
                return;
            }
            else {
                var contentType = ""
                for marker in cardObj.display.markers {
                    if marker.markerType == .badge {
                        contentType = marker.value
                        break;
                    }
                }
                LocalyticsEvent.tagEventWithAttributes("Search_Results", ["Content_Type":contentType])
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    self.stopAnimating()
                    return
                }
                gotoTargetedWith(path: cardObj.target.path, cardItem: cardObj, analytics: "search")
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView != self.recommendationsCollectionView {
            if indexPath.row + 1 == self.selectedDataTypeObj.cards.count && self.selectedDataTypeObj.isPaginationAvailable && self.goGetTheData
            {
                self.pageNum = self.pageNum + 1
                self.goGetTheData = false
                self.getSelectedSuggestionContent(searchText: self.searchString, genre: nil, language: nil, dataType: nil, page: self.pageNum, pageSize: self.pageCount)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == self.recommendationsCollectionView {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
            
            footerView.backgroundColor = UIColor.clear
            return footerView
        }
        else {
            switch kind {
                
            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
                
                footerView.backgroundColor = UIColor.clear
                return footerView
            default:
                return UICollectionReusableView()
                assert(false, "Unexpected element kind")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == self.recommendationsCollectionView {
            return CGSize.zero
        }
        else {
            return CGSize(width: self.view.frame.size.width , height: productType.iPad ? 150.0 :  80.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.recommendationsCollectionView {
            let pageDataItem = self.pageData[indexPath.item]
            if pageDataItem.paneType == .adContent {
                return CGSize(width: 350, height: 120)
            }
            else if pageDataItem.paneType == .section {
                if let section = pageDataItem.paneData as? Section {
                    if section.sectionInfo.dataType == "movie" || section.sectionInfo.dataType == "hetro"{
                        if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                            return CGSize(width: view.frame.width, height: 197)
                        }else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                            return CGSize(width: view.frame.width, height: 177)
                        }else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .roller_poster && productType.iPad {
                            return CGSize(width: view.frame.width, height: (206 * 1.3) + 40)
                        }
                        return CGSize(width: view.frame.width, height: 250)
                    }
                    else if section.sectionInfo.dataType == "epg" {
                        if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                            return CGSize(width: view.frame.width, height: 197)
                        }
                        return CGSize(width: view.frame.width, height: (productType.iPad ? 222 : 197))
                    }
                    else if section.sectionInfo.dataType == "network" {
                        if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                            return CGSize(width: view.frame.width, height: 155)
                        } else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .square_poster {
                            return CGSize(width: view.frame.width, height: 181)
                        }
                        else {
                            return CGSize(width: view.frame.width, height: (productType.iPad ? 166 : 159))
                        }
                    }
                    else if section.sectionInfo.dataType == "button" {
                        return CGSize(width: view.frame.width, height: 62)
                    }
                    else if section.sectionInfo.dataType == "entity" {
                        if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                            return CGSize(width: view.frame.width, height: 177)
                        }
                        else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster, productType.iPad, appContants.appName == .tsat {
                            return CGSize(width: view.frame.width, height: 220)
                        }
                        return CGSize(width: view.frame.width, height: (productType.iPad ? 230 : 197))
                    }
                    else {
                        if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                            return CGSize(width: view.frame.width, height: 190)
                        }
                        return CGSize(width: view.frame.width, height: (productType.iPad ? 230 : 197)) //222
                    }
                }
                return CGSize(width: view.frame.width, height: 239)
            }
            
            return CGSize(width: view.frame.width, height: 0)
        }
        else {
            if appContants.appName == .gac {
                let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
                let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*20))/numColums
                let tempHeight = tempWidth * 0.5625
                if cardObj.cardType == .circle_poster {
                    return CGSize(width: tempWidth - 15, height: (tempHeight + 90))
                }
                return CGSize(width: tempWidth, height: (tempHeight + 52.0 + 25))
            }
            else {
                let cardObj = self.selectedDataTypeObj.cards[indexPath.item]
                
                if cardObj.cardType == .overlay_poster {
                    if productType.iPad {
                        let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                        let ratioheight = newW * 9/16
                        let newCellSize = CGSize(width: newW, height: 93 )
                        printYLog("newCellSize vertical: ", newCellSize)
                        return newCellSize
                    }
                    else {
                        let newW = floor((UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - self.secInsets.left - self.secInsets.right) / numColums)
                        let newCellSize = CGSize(width: newW, height: 73 )
                        printYLog("newCellSize Width: ", newCellSize)
                        return newCellSize
                    }
                }else if cardObj.cardType == .sheet_poster {
                    let tempWidth = ((AppDelegate.getDelegate().window?.frame.size.width)! - ((numColums + 1)*20))/numColums
                    let tempHeight = tempWidth * 0.5625
                    return CGSize(width: tempWidth, height: (tempHeight + 52.0))
                }
                else {
                    if productType.iPad {
                        return CGSize(width: 333, height: 123)
                    }
                    return CGSize(width: 333, height: 73)
                }
            }
        }
    }
    
    func getSectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, section:Section) -> UICollectionViewCell {
        
        let sectionData = section.sectionData
        let sectionInfo = section.sectionInfo
        let sectionControls = section.sectionControls
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCVC.identifier, for: indexPath) as! SectionCVC
        cell.sectionIndex = indexPath.row
        cell.cCV.setContentOffset(CGPoint.zero, animated: false)
        if sectionInfo.dataType == "movie" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = 210.0
            }
            cell.isMovieCell = true
        }
        else if sectionInfo.dataType == "epg" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .sheet_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .overlay_poster {
                cell.collectionViewHeightConstraint.constant = 157.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 157.0)
            }
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "network" {
            if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .circle_poster {
                cell.collectionViewHeightConstraint.constant = 110
            } else if section.sectionData.data.count > 0 && (section.sectionData.data.first)!.cardType == .square_poster {
                cell.collectionViewHeightConstraint.constant = 134.0
            }
            else {
                cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 119.0)
            }
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "artist" {
            if appContants.appName == .gac {
                cell.collectionViewHeightConstraint.constant = 199.0
                cell.isMovieCell = false
            }
        }
        else if sectionInfo.dataType == "button" {
            cell.collectionViewHeightConstraint.constant = 42.0
            cell.isMovieCell = false
        }
        else if sectionInfo.dataType == "entity" {
            if appContants.appName == .gac {
                cell.collectionViewHeightConstraint.constant = 167.0
            }
            cell.collectionViewHeightConstraint.constant = 142.0
            cell.isMovieCell = false
        }
        else {
            cell.collectionViewHeightConstraint.constant = (productType.iPad ? 126 : 157.0)
            cell.isMovieCell = false
        }
        cell.myLbl.text = sectionInfo.name
        if sectionInfo.iconUrl.count > 0 {
            cell.channelImageView.contentMode = .scaleAspectFit
            cell.channelImageView.loadingImageFromUrl(sectionInfo.iconUrl, category: "partner")
            cell.channelImageView.isHidden = false
            cell.channelImageViewWidthConstraint.constant = 36.0
            cell.channelImageView.viewBorderWithOne(cornersRequired: true)
            cell.channelImageView.layer.borderColor = AppTheme.instance.currentTheme.cardSubtitleColor.cgColor
            cell.myLblLeftConstraint.constant = 40.0
        }
        else{
            cell.channelImageViewWidthConstraint.constant = 0.0
            cell.myLblLeftConstraint.constant = 10.0
            cell.channelImageView.isHidden = true
        }
      
        cell.isLivePath = false
        
        cell.isViewMore = true
        cell.setUpData(sectionData: sectionData, sectionInfo: sectionInfo,sectionControls: sectionControls, pageData: self.pageContentResponse)
        cell.delegate = self
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.searchedContentCV.collectionViewLayout.invalidateLayout()
            if productType.iPad {
                self.calculateNumCols()
            }
            if AppDelegate.getDelegate().isPartialViewLoaded == true{
                PartialRenderingView.instance.reloadDataWithFrameUpdate()
            }
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - UISearchBar Delagates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.categoryBtn.isHidden = true
        self.dropdownImage.isHidden = true
        self.searchResultsLbl.text = ""
        if (searchedContentData.count > 0) || (self.selectedDataTypeObj.cards.count > 0){
            self.selectedDataTypeObj = SearchDataType()
            self.searchedContentData.removeAll()
            self.searchedContentCV.reloadData()
        }
        
        suggestionsData.removeAll()
        self.searchSuggestionsTableView.reloadData()
        if appContants.appName == .gac {
            self.searchSuggestionsTableView.isHidden = false
            self.searchSuggestionsTableView.tableHeaderView = self.recommendationsCollectionView
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                self.recommendationsCollectionView.reloadData()
            }
            self.searchSuggestionsTableView.reloadData()
        }
        else {
            self.searchSuggestionsTableView.isHidden = true
        }
        return
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        if ((searchBar.text?.count ?? 0) < 3) {
            searchBar.resignFirstResponder()
            return;
        }
        else {
            self.pageNum = 0
            self.selectedDataTypeObj = SearchDataType()
            self.searchedContentData.removeAll()
            self.searchedContentCV.reloadData()
            self.selectedDataType = nil
            getSelectedSuggestionContent(searchText: searchBar.text!, genre: nil, language: nil, dataType: selectedDataType, page: pageNum, pageSize: pageCount)
            searchActive = false;
            self.searchBar.showsCancelButton = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.categoryBtn.isHidden = true
        self.dropdownImage.isHidden = true
         self.errorLabel.text = ""
         self.errorLabel.isHidden = true
        self.searchResultsLbl.text = ""
        if (searchedContentData.count > 0) || (self.selectedDataTypeObj.cards.count > 0){
            self.selectedDataTypeObj = SearchDataType()
            self.searchedContentData.removeAll()
            self.searchedContentCV.reloadData()
        }
        //        searchBar.perform(#selector(self.becomeFirstResponder), with: nil, afterDelay: 0.1)
        if searchText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty{
            suggestionsData.removeAll()
            self.searchSuggestionsTableView.reloadData()
            if appContants.appName == .gac {
                self.searchSuggestionsTableView.isHidden = false
                self.searchSuggestionsTableView.tableHeaderView = self.recommendationsCollectionView
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                    self.recommendationsCollectionView.reloadData()
                }
                self.searchSuggestionsTableView.reloadData()
            }
            else {
                self.searchSuggestionsTableView.isHidden = true
            }
            return
        }
        
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if searchedContentData.count > 0 || searchBar.text?.count ?? 0 > 0 {
            self.searchSuggestionsTableView.tableHeaderView = nil
            self.searchSuggestionsTableView.reloadData()
        }
        self.startAnimating1(allowInteraction: false)
        self.errorLabel.isHidden = true
        
        
        OTTSdk.mediaCatalogManager.suggestions(query: searchText, onSuccess: { (response) in
            self.stopAnimating1()
            self.suggestionsData = response
            if response.count > 0{
                self.searchSuggestionsTableView.isHidden = false
                self.searchedContentCV.isHidden = true
                self.searchSuggestionsTableView.reloadData()
            }
            else{
                self.errorLabel.text = ""
                self.errorLabel.isHidden = true
                self.searchSuggestionsTableView.isHidden = true
                self.searchedContentCV.isHidden = true
            }
            
        }) { (error) in
            print(error.message)
            self.stopAnimating1()
            
            self.errorLabel.text = error.message
            self.errorLabel.isHidden = true
            self.searchSuggestionsTableView.isHidden = true
            self.searchedContentCV.isHidden = true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text?.count ?? 0 > 0 {
            return suggestionsData.count;
        }
        else {
            return searchHistoryArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionsCell")
        if self.searchBar.text?.count ?? 0 > 0 {
            cell?.textLabel?.text = suggestionsData[indexPath.row];
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.font = UIFont.ottRegularFont(withSize: 18.0)
            cell?.textLabel?.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }
        else {
            let tempData = searchHistoryArray[indexPath.row]
            if tempData != nil && tempData.query != nil {
                cell?.textLabel?.text = tempData.query
            }
            else {
                cell?.textLabel?.text = ""
            }
            if (indexPath.row % 2 == 1) {
                cell?.backgroundColor = UIColor.clear
            }
            else {
                cell?.backgroundColor = UIColor.init(red: 28.0/255.0, green:  28.0/255.0, blue:  28.0/255.0, alpha:  41.0/255.0)
            }
            cell?.textLabel?.numberOfLines = 2
            cell?.textLabel?.font = UIFont.ottRegularFont(withSize: 12.0)
            cell?.textLabel?.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        }
        
        cell?.selectionStyle = .none
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchBar.text?.count ?? 0 > 0 {
            self.searchedContentData.removeAll()
            self.searchedContentCV.reloadData()
            self.selectedDataTypeObj = SearchDataType()
            self.pageNum = 0
            self.selectedDataType = nil
            self.searchBar.text = suggestionsData[indexPath.row]
            self.searchHistoryArray = CoreDataManager.shared.addSearchHistoryData(query: suggestionsData[indexPath.row], time: Date()) ?? [SearchHistoryData]()
            self.getSelectedSuggestionContent(searchText: suggestionsData[indexPath.row], genre: nil, language: nil, dataType: self.selectedDataType, page: pageNum, pageSize: pageCount)
        }
        else {
            let tempData = searchHistoryArray[indexPath.row]
            if tempData != nil && tempData.query != nil {
                self.searchBar.text = tempData.query
                self.searchBarSearchButtonClicked(self.searchBar)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchBar.text?.count ?? 0 > 0 {
            return 44
        }
        else {
            return 48
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchBar.text?.count == 0 && self.searchHistoryArray.count > 0 {
            return 50
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchBar.text?.count == 0 && self.searchHistoryArray.count > 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            
            let titleLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 200, height: 50))
            titleLabel.text = "Recent Searches"
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.ottRegularFont(withSize: 18)
            titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
            titleLabel.backgroundColor = .clear
            
            let clearHistoryButton = UIButton.init(type: .custom)
            clearHistoryButton.frame = CGRect.init(x: tableView.frame.size.width-90, y: 8, width: 80, height: 35)
            clearHistoryButton .setTitle("Clear History", for: .normal)
            clearHistoryButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 10)
            clearHistoryButton.setTitleColor(AppTheme.instance.currentTheme.navigationBarColor, for: .normal)
            clearHistoryButton.titleLabel?.textAlignment = .right
            clearHistoryButton.addTarget(self, action: #selector(clearHistoryButtonTapped) , for: .touchUpInside)
  
            headerView.addSubview(titleLabel)
            headerView.addSubview(clearHistoryButton)
            return headerView
        }
        else {
            return UIView.init(frame: .zero)
        }
    }
    
    
    @objc func clearHistoryButtonTapped() {
        CoreDataManager.shared.deleteAllData()
        self.searchHistoryArray = CoreDataManager.shared.fetchRetriveData(predicate: nil)
        self.searchSuggestionsTableView.reloadData()
    }
    func startAnimating1(allowInteraction: Bool) {
        AppDelegate.getDelegate().activityIndicator.startAnimating()
    }
    
    func stopAnimating1() {
        AppDelegate.getDelegate().activityIndicator.stopAnimating()
    }
    
    // MARK: - Chrome Cast Device Scanner Delegates -
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            self._miniMediaControlsHeightConstraint.constant = miniMediaControlsViewController.minHeight
            self.view.bringSubviewToFront(_miniMediaControlsContainerView)
            if playerVC != nil {
                playerVC?.showHidePlayerView(true)
            }
        }
        else {
            self._miniMediaControlsHeightConstraint.constant = 0
            if playerVC != nil {
                playerVC?.showHidePlayerView(false)
            }
        }
        self.view.setNeedsLayout()
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
    
    // MARK: - API Calls
    
    func getSelectedSuggestionContent(searchText:String, genre: String?, language: String?, dataType: String?, page: Int?, pageSize: Int?) {
        
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.searchBar.resignFirstResponder()
        self.startAnimating(allowInteraction: false)
        var userID = OTTSdk.preferenceManager.user?.email
        if userID != nil && (userID? .isEmpty)! {
            userID = OTTSdk.preferenceManager.user?.phoneNumber
        }
        else {
            userID = "NA"
        }
        self.searchString = searchText
        LocalyticsEvent.tagEventWithAttributes("Search_Results", ["Suggestions":searchText])
        self.errorLabel.isHidden = true
        OTTSdk.mediaCatalogManager.search(query: searchText, genre: genre, language: language, dataType: dataType, page: page, pageSize: pageSize, onSuccess: { (response) in
            self.stopAnimating()
            if self.searchedContentData.count > 0 {
                var tempSearchedContentData = [SearchDataType]()
                for prevSearchObj in self.searchedContentData {
                    var tempPrevSearchObj = prevSearchObj
                    for (index, searchResponseObj) in response.enumerated() {
                        if prevSearchObj.dataType == searchResponseObj.sourceType {
                            tempPrevSearchObj.dataType = searchResponseObj.sourceType
                            tempPrevSearchObj.displayName = searchResponseObj.displayName
                            tempPrevSearchObj.cards.append(contentsOf: searchResponseObj.data)
                            tempPrevSearchObj.pageNum = (tempPrevSearchObj.cards.count/self.pageCount)
                            tempPrevSearchObj.isPaginationAvailable = searchResponseObj.data.count == 0 ? false : true
                        }
                    }
                    tempSearchedContentData.append(tempPrevSearchObj)
                }
                
                self.searchedContentData.removeAll()
                self.searchedContentData.append(contentsOf: tempSearchedContentData)
                
                for searchResponseObj in response {
                    var newContentStatus : Bool = false
                    for prevSearchObj in self.searchedContentData {
                        if searchResponseObj.sourceType == prevSearchObj.dataType {
                            newContentStatus = false
                            break;
                        } else {
                            newContentStatus = true
                        }
                    }
                    if newContentStatus {
                        var searchDataTypeObj = SearchDataType()
                        searchDataTypeObj.dataType = searchResponseObj.sourceType
                        searchDataTypeObj.displayName = searchResponseObj.displayName
                        searchDataTypeObj.cards.append(contentsOf: searchResponseObj.data)
                        searchDataTypeObj.pageNum = (searchDataTypeObj.cards.count/self.pageCount)
                        searchDataTypeObj.isPaginationAvailable = searchResponseObj.data.count == 0 ? false : true
                        self.searchedContentData.append(searchDataTypeObj)
                    }
                }
                
            } else {
                for searchResponseObj in response {
                    var searchDataTypeObj = SearchDataType()
                    searchDataTypeObj.dataType = searchResponseObj.sourceType
                    searchDataTypeObj.displayName = searchResponseObj.displayName
                    searchDataTypeObj.cards.append(contentsOf: searchResponseObj.data)
                    searchDataTypeObj.pageNum = (searchDataTypeObj.cards.count/self.pageCount)
                    searchDataTypeObj.isPaginationAvailable = searchResponseObj.data.count == 0 ? false : true
                    self.searchedContentData.append(searchDataTypeObj)
                }
                
            }
            if self.selectedDataType == nil && self.searchedContentData.count > 0{
                self.selectedDataTypeObj = self.searchedContentData.first!
                self.categoryBtn.setTitle("", for: .normal)
                self.categoryBtn.setTitle(self.selectedDataTypeObj.displayName, for: .normal)
                self.categoryBtn.sizeToFit()
                self.categoryBtn.frame.size.height = 30
                self.categoryBtn.frame.size.width = self.categoryBtn.frame.size.width + 40
                self.catergoryBtnWidthConstraint.constant =  self.categoryBtn.frame.size.width
                self.searchResultsLabelWidthConstraint.constant = AppDelegate.getDelegate().window!.frame.size.width - self.catergoryBtnWidthConstraint.constant - 40
                self.categoryBtn.isHidden = false
                self.dropdownImage.isHidden = false
                self.selectedDataType = self.selectedDataTypeObj.dataType
            } else {
                for searchObj in self.searchedContentData {
                    if searchObj.dataType == self.selectedDataType {
                        self.selectedDataTypeObj = searchObj
                        self.categoryBtn.setTitle("", for: .normal)
                        self.categoryBtn.setTitle(self.selectedDataTypeObj.displayName.capitalized, for: .normal)
                        self.categoryBtn.sizeToFit()
                        self.categoryBtn.frame.size.height = 30
                        self.categoryBtn.frame.size.width = self.categoryBtn.frame.size.width + 40
                        self.catergoryBtnWidthConstraint.constant =  self.categoryBtn.frame.size.width
                        self.searchResultsLabelWidthConstraint.constant = AppDelegate.getDelegate().window!.frame.size.width - self.catergoryBtnWidthConstraint.constant - 40
                        self.selectedDataType = self.selectedDataTypeObj.dataType
                        break;
                    }
                }
            }
            //            self.searchBar.text = nil
            if self.selectedDataTypeObj.cards.count > 0{
                self.calculateNumCols()
                self.categoryBtn.isHidden = false
                self.dropdownImage.isHidden = false
                let totalResults = self.selectedDataTypeObj.cards.count
                self.searchResultsLbl.text = "\(totalResults) \(totalResults == 1 ? "Result" : "Results") for '\(searchText)'"
                self.searchSuggestionsTableView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    self.searchedContentCV.reloadData()
                    self.searchedContentCV.isHidden = false
                }
                self.searchedContentCV.reloadData()
            }
            else{
                self.errorLabel.text = "Sorry, no results matching".localized + "‘" + searchText + "’"
                self.errorLabel.isHidden = false
                self.searchSuggestionsTableView.isHidden = true
                self.searchedContentCV.isHidden = true
            }
            self.goGetTheData = true
        }) { (error) in
            print(error.message)
            self.stopAnimating()
            if self.selectedDataTypeObj.cards.count == 0 {
                self.searchResultsLbl.text = ""
                self.errorLabel.text = error.message
                self.errorLabel.isHidden = false
                self.searchSuggestionsTableView.isHidden = true
                self.searchedContentCV.isHidden = true
            } else {
                var tempSearchedContentData = [SearchDataType]()
                for prevSearchObj in self.searchedContentData {
                    if prevSearchObj.dataType == self.selectedDataType {
                        self.selectedDataTypeObj = prevSearchObj
                    }
                    var tempPrevSearchObj = prevSearchObj
                    tempPrevSearchObj.isPaginationAvailable = false
                    tempSearchedContentData.append(tempPrevSearchObj)
                }
                self.searchedContentData.removeAll()
                self.searchedContentData.append(contentsOf: tempSearchedContentData)
            }
            
        }
    }
    
    //MARK: - PlayerSuggestionsViewControllerDelegate
    fileprivate func goToPage(_ card: Card, path : String) {
        gotoTargetedWith(path: path, cardItem: card, analytics: nil)
    }
    
    func didSelectedSuggestion(card: Card) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: true)
        goToPage(card, path: card.target.path)
    }
    
    //MARK: - PartialRenderingViewDelegate
    
    func didSelected(card : Card?, content : Any?, templateElement : TemplateElement? ){
        if card != nil && templateElement != nil{
            self.goToPage(card!, path: templateElement!.target)
        }
    }
    
    func record(confirm : Bool, content : Any?){
        if confirm == true{
            
        }
    }
    
    func didSelectedRollerPosterItem(item: Card) {
        self.startAnimating(allowInteraction: false)
       
        if item.template != "" {
            PartialRenderingView.instance.reloadFor(card: item, content: nil, partialRenderingViewDelegate: self)
            self.stopAnimating()
            return;
        }
        else {
            var contentType = ""
            for marker in item.display.markers {
                if marker.markerType == .badge {
                    contentType = marker.value
                    break;
                }
            }
            LocalyticsEvent.tagEventWithAttributes("Search_Results", ["Content_Type":contentType])
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                self.stopAnimating()
                return
            }
            gotoTargetedWith(path: item.target.path, cardItem: item, analytics: "search")
            
        }
    }
    
    func rollerPoster_moreClicked(sectionData: SectionData, sect_data: SectionInfo, sectionControls: SectionControls) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        gotoTargetWith(path: sectionControls.viewAllTargetPath, cardItem: nil, bannerItem: nil, sectionData: sectionData, sect_data: sect_data, sectionControls: sectionControls, templateElement: nil)
    }
    private func gotoTargetWith(path : String, cardItem : Card?, bannerItem : Banner?, sectionData : SectionData?, sect_data : SectionInfo?, sectionControls : SectionControls?, templateElement: TemplateElement?) {
        if let item = bannerItem, item.target.path == "packages" {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ...")
            return
        }else if let item = bannerItem, !item.isInternal {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            if  playerVC != nil{
                playerVC?.isNavigatingToBrowser = true
                playerVC?.showHidePlayerView(true)
                playerVC?.player.pause()
            }
            view1.urlString = item.target.path
            view1.pageString = item.title
            view1.viewControllerName = "ListViewController"
            self.stopAnimating()
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(view1, animated: true)
            return
        }
 
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
         
            var vc : UIViewController!
            if let tempController = viewController as? PlayerViewController {
                tempController.delegate = self
                if let item = cardItem {
                    tempController.defaultPlayingItemUrl = item.display.imageUrl
                    tempController.playingItemTitle = item.display.title
                    tempController.playingItemSubTitle = item.display.subtitle1
                    tempController.playingItemTargetPath = item.target.path
                }else if let item = bannerItem {
                    tempController.defaultPlayingItemUrl = item.imageUrl
                    tempController.playingItemTitle = item.title
                    tempController.playingItemSubTitle = item.subtitle
                    tempController.playingItemTargetPath = item.target.path
                }
                if templateElement != nil {
                    tempController.templateElement = templateElement
                }
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                AppDelegate.getDelegate().window?.addSubview(tempController.view)
                return
            }else if let tempController = viewController as? ContentViewController {
                tempController.isToViewMore = true
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                }else if let item = bannerItem {
                    tempController.sectionTitle = item.title
                    tempController.targetedMenu = path
                    AppDelegate.getDelegate().presentTargetedMenu = path
                }else {
                    tempController.targetedMenu = path
                    if let data = sect_data {
                        tempController.sectionTitle = data.name
                    }
                }
                vc = tempController
            }else if let tempController = viewController as? DetailsViewController {
                if let item = cardItem {
                    tempController.navigationTitlteTxt = item.display.title
                    tempController.isCircularPoster = item.cardType == .circle_poster ? true : false
                }else if let item = bannerItem {
                    tempController.navigationTitlteTxt = item.title
                }else if let data = sect_data {
                    tempController.navigationTitlteTxt = data.name
                }
                vc = tempController
            }else if let tempController = viewController as? DefaultViewController {
                tempController.delegate = self
                vc = tempController
            }else if let tempController = viewController as? ListViewController {
                tempController.isToViewMore = true
                if let data = sect_data {
                    tempController.sectionTitle = data.name
                }
                vc = tempController
            }else {
                vc = viewController
            }
           
            guard vc != nil else {
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                return
            }
            guard let topVc = UIApplication.topVC() else {
                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                    rootViewController.stopAnimating()
                }
                self.stopAnimating()
                return
            }
            topVc.navigationController?.pushViewController(viewController: vc, animated: true, completion: {
                
            })
            if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
                rootViewController.stopAnimating()
            }
            self.stopAnimating()
        }
    }
    
    func programRecordClicked(item: Card, sectionIndex: Int, rowIndex: Int) {
        
    }
    
    func programStopRecordClicked(item: Card, sectionIndex: Int, rowIndex: Int) {
        
    }
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
    func loadBannerAd(){
        
        var tempBannerUnitId = ""
        tempBannerUnitId = AppDelegate.getDelegate().defaultBannerAdTag
        
        if AppDelegate.getDelegate().showBannerAds && !tempBannerUnitId.isEmpty{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                let bannerView = DFPBannerView(adSize:kGADAdSizeBanner)
                let request = DFPRequest()
                //#warning("comment test devices")
                //                request.testDevices = [kGADSimulatorID,"46805d24bda9feaa573e40056cd97b73"]
                bannerView.adUnitID = tempBannerUnitId
                bannerView.rootViewController = self
                bannerView.delegate = self
                bannerView.load(request)
                self.bannerAdView.addSubview(bannerView)
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                
                // Layout constraints that align the banner view to the bottom center of the screen.
                self.bannerAdView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal,
                                                                   toItem: self.bannerAdView, attribute: .top, multiplier: 1, constant: 0))
                self.bannerAdView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .centerX, relatedBy: .equal,
                                                                   toItem: self.bannerAdView, attribute: .centerX, multiplier: 1, constant: 0))
                
            })
        }
        else{
            self.hideBannerAd()
        }
        
    }
    func hideBannerAd(){
        self.adBannerViewHeightConstraint.constant = 0.0
        self.collectionViewbottomConstarint?.constant = 5.0
        self.updateDocPlayerFrame()
    }
    func updateDocPlayerFrame() {
        if playerVC != nil {
            playerVC!.bannerAdFoundExceptPlayer = (self.adBannerViewHeightConstraint.constant == 0 ? false : true)
            if playerVC!.isMinimized {
                playerVC?.updateMinViewFrame()
            }
        }
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        self.hideBannerAd()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.adBannerViewHeightConstraint.constant = 50.0
        self.collectionViewbottomConstarint?.constant = 5.0
        self.updateDocPlayerFrame()
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat
        var posY: CGFloat
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height * (width/height)
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width  * (height/width)
        }
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        return UIImage(cgImage: imageRef)
        }
}
