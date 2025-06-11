//
//  TVGuideViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 28/02/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast

struct TVDateTitle {
    var title : String{
        set{
            barTitle = newValue
            
            let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50)
            let boundingBox = barTitle.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.ottRegularFont(withSize: 16.0)], context: nil)
            answerHeight = boundingBox.width + 10
        }
        get{
            return barTitle
        }
    }
    
    var answerHeight : CGFloat = 0
    var barTitle = ""
}

class TVGuideViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,TVGuideFilterSelectionProtocol,MaterialShowcaseDelegate,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate {
    
    @IBOutlet weak var selectedDateLbl: UILabel!
    @IBOutlet weak var tvGuideCollectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftGradientArrow: UIImageView?
    @IBOutlet weak var rightGradientArrow: UIImageView?
    
 
    
    @IBOutlet weak var leftGradientBgView: UIView?
    @IBOutlet weak var rightGradientBgView: UIView?
    
    @IBOutlet weak var nowLiveLbl: UILabel?
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tvGuideDateCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTVGuideHeaderLbl: UILabel!
    @IBOutlet weak var mainTVGuideHeaderLangBtn: UIButton!
    @IBOutlet weak var mainTVGuideHeaderCategoryBtn: UIButton!
    @IBOutlet weak var mainTVHeaderCategoryDropDownBtn: UIButton!
    @IBOutlet weak var tvGuideDateCollectionView: UICollectionView!
    @IBOutlet weak var tvGuideCollectionView: UIView!
    @IBOutlet weak var nowLiveView: UIView!
    @IBOutlet weak var liveProgramView: UIView!
    var selectedCatgFilterArr = NSMutableArray()
    var selectedLanguageFilterArr = NSMutableArray()

    
    var cCFL: CustomFlowLayout!
    var secInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    var numColums: CGFloat = 4
    let interItemSpacing: CGFloat = 10
    let minLineSpacing: CGFloat = 1
    let scrollDir: UICollectionView.ScrollDirection = .horizontal
    weak var currentViewController: UIViewController?
    var tvGuideDateArr = [TVGuideTab]()
    var tvGuideDataArr = [ChannelObj]()
    var programsDataArr = [ChannelProgramsResponse]()
    var userProgramsDataArr = [UserProgramResponse]()
    var tvGuideTabSelected:Bool = false
    var tvGuideFilterArr = [Filter]()
    var nodataFound:Bool = false
    var selectedIndexpath = 0
    var tvDateTitlesArray = [TVDateTitle]()
    var channelIDStr = ""

    @IBOutlet weak var chromeButtonView: UIView!
    
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint : NSLayoutConstraint!
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
    var miniMediaControlsViewEnabled = true
    let kCastControlBarsAnimationDuration = 0.20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.tvGuideDateCollectionView.backgroundColor = AppTheme.instance.currentTheme.tvGuideDateCellColor
        self.tvGuideCollectionView.backgroundColor = AppTheme.instance.currentTheme.guideTimeBgColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableGoLiveBtn), name: NSNotification.Name(rawValue: "EnableGoLiveBtn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableGoLiveBtn), name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showErrorView), name: NSNotification.Name(rawValue: "ShowErrorView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideErrorView), name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goNowLive), name: NSNotification.Name(rawValue: "GoNowLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectTab), name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTabData), name: NSNotification.Name(rawValue: "GetTabData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NSNotification.Name(rawValue: "UpdateUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNextShowCaseView(notification:)), name: NSNotification.Name(rawValue: "ShowNextShowCaseView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeBottomConstraint(notification:)), name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil)
        self.nowLiveLbl?.text = "Live".localized
        self.mainTVGuideHeaderCategoryBtn.setTitle("Filters".localized, for: .normal)
        self.nowLiveView.isHidden = true
//        self.nowLiveView.frame = CGRect.init(x: self.nowLiveView.frame.origin.x, y: self.nowLiveView.frame.origin.y, width: self.nowLiveLbl.frame.size.width + 10.0, height: self.nowLiveView.frame.size.height)
//        self.nowLiveLbl.frame = CGRect.init(x: 5, y: 0, width: self.nowLiveLbl.frame.size.width, height: self.nowLiveView.frame.size.height)
        self.tvGuideDateCollectionView.delegate = self
        self.tvGuideDateCollectionView.dataSource = self
        self.tvGuideDateCollectionView.allowsMultipleSelection = false
        self.tvGuideDateCollectionView.layer.shadowColor = UIColor.black.cgColor
        self.tvGuideDateCollectionView.layer.shadowOffset = CGSize.init(width: 0.8, height: 0)
        self.tvGuideDateCollectionView.layer.shadowOpacity = 0.0
        self.tvGuideDateCollectionView.layer.shadowRadius = 0.0
        self.tvGuideDateCollectionView.clipsToBounds = false
        self.tvGuideDateCollectionView.layer.masksToBounds = false
        
        if productType.iPad {
            self.tvGuideDateCollectionViewHeightConstraint.constant = 60.0
            self.liveProgramView.frame.size.height = self.view.frame.size.height
            self.liveProgramView.frame.size.width = self.view.frame.size.width
        } else {
        }
        cCFL = CustomFlowLayout()
        cCFL.interItemSpacing = interItemSpacing
        cCFL.secInset = secInsets
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.itemSize = CGSize(width: 93, height: 50)
        cCFL.setupLayout()
        self.tvGuideDateCollectionView.collectionViewLayout = cCFL
        self.tvGuideDateCollectionView.reloadData()
        self.loadPlayerSuggestions(loginViewStatus: true)
        self.startAnimating(allowInteraction: true)
        self.mainTVGuideHeaderCategoryBtn.isHidden = true
        self.mainTVHeaderCategoryDropDownBtn.isHidden = true

        self.getTVGuideEPGContent(start_time: nil, end_time: nil)
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateUI() {
        self.nowLiveLbl?.text = "Live".localized
        self.mainTVGuideHeaderCategoryBtn.setTitle("Filters".localized, for: .normal)

    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    func loadPlayerSuggestions(loginViewStatus:Bool) {
        
        if self.currentViewController is TVGuideCollectionCollectionViewController {
            if self.tvGuideCollectionView.subviews.count > 0 {
                self.tvGuideCollectionView.subviews[0].removeFromSuperview()
                self.currentViewController?.removeFromParent()
            }
        }
        
        let homeStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        let newViewController = homeStoryboard.instantiateViewController(withIdentifier: "TVGuideCollectionCollectionViewController") as! TVGuideCollectionCollectionViewController
        newViewController.tvGuideDataArr = self.tvGuideDataArr
        newViewController.channelIdsStr = self.channelIDStr
        newViewController.tvGuideDateArr = self.tvGuideDateArr
        newViewController.nowLiveIndicatorView = self.nowLiveView
        newViewController.liveProgramsView = self.liveProgramView
        self.currentViewController = newViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.tvGuideCollectionView)
        self.stopAnimating()
    }
    
    func getTVGuideEPGContent(start_time:NSNumber?, end_time:NSNumber?) {
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.tvGuideDateArr.removeAll()
        self.tvDateTitlesArray.removeAll()

        OTTSdk.mediaCatalogManager.getTVGuideChannels(filter: nil, skip_tabs: 0, time_zone: nil, onSuccess: { (response) in
            self.tvGuideDateArr = response.tabs
            self.tvDateTitlesArray = [TVDateTitle]()
            var startTime = ""
            var endTime = ""
            for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                var tvDateTitleObj = TVDateTitle()
                tvDateTitleObj.title = "\(tabObj.title) \(tabObj.subtitle)"
                self.tvDateTitlesArray.append(tvDateTitleObj)
                if tabObj.isSelected {
                    startTime = tabObj.startTime.stringValue
                    endTime = tabObj.endTime.stringValue
                    self.selectedIndexpath = index
                    AppDelegate.getDelegate().presentShowingDateTab = tabObj
                    AppDelegate.getDelegate().alreadyLoadedTabDataArr.append(tabObj)
                    AppDelegate.getDelegate().tvGuideSelectedTabDate = self.getFullDate("\(tabObj.startTime)")
                }
            }
            self.tvGuideDataArr = response.data
            let channelIdArray : [String] = self.tvGuideDataArr.map({ (channel: ChannelObj) -> String in
                "\(channel.channelID)"
            })
            self.channelIDStr = channelIdArray.joined(separator:",")
            self.appendPrograms(startTime: startTime, endTime: endTime)
        }) { (error) in
            print(error.message)
            self.stopAnimating()
//            self.getTVGuideEPGContent(start_time: start_time, end_time: end_time)
        }
    }
    
    func appendPrograms(startTime : String, endTime:String){
        let programsOperation = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            OTTSdk.mediaCatalogManager.getProgramForChannels(channel_ids: self.channelIDStr, start_time: startTime, end_time: endTime, time_zone: nil, onSuccess: { (programResponse) in
                self.programsDataArr = programResponse
                group.leave()
            }) { (error) in
                group.leave()
            }
            
            group.enter()
            OTTSdk.mediaCatalogManager.getUserProgramForChannels(channel_ids: self.channelIDStr, start_time: startTime, end_time: endTime, time_zone: nil, onSuccess: { (userProgramResponse) in
                self.userProgramsDataArr = userProgramResponse
                group.leave()
            }) { (error) in
                group.leave()
            }
            group.notify(queue: .main) {
                self.formGuideData()
            }
        }
        programsOperation.start()
    }
    
    func formGuideData() {
        var tempProgramsDataArr = [ChannelObj]()
        for channel in self.tvGuideDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
            let filteredarr = self.programsDataArr.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let dict = filteredarr[0]
                channel.programs = dict.programs
            }
            tempProgramsDataArr.append(channel)
        }
        self.tvGuideDataArr.removeAll()
        self.tvGuideDataArr.append(contentsOf: tempProgramsDataArr)

        var tempUserProgramDataArr = [ChannelObj]()
        for channel in self.tvGuideDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
            let filteredarr = self.userProgramsDataArr.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let dict = filteredarr[0]
                var tempProgramDataArr = [Program]()
                for program in channel.programs {
                    let predicate = NSPredicate(format: "programId == %d", program.programID)
                    let filteredarr = dict.programs.filter { predicate.evaluate(with: $0) };
                    if filteredarr.count > 0 {
                        program.target.pageAttributes.isRecorded = true
                    }
                    tempProgramDataArr.append(program)
                }
                channel.programs = tempProgramDataArr
            }
            tempUserProgramDataArr.append(channel)
        }
        self.tvGuideDataArr.removeAll()
        self.tvGuideDataArr.append(contentsOf: tempUserProgramDataArr)
        if !self.tvGuideTabSelected {
            self.tvGuideDateCollectionView.reloadData()
        }
        if self.tvGuideDataArr.count > 0 {
            self.loadPlayerSuggestions(loginViewStatus: true)
            self.nodataFound = false
            self.errorView.isHidden = true
            self.tvGuideDateCollectionView.isHidden = false
            self.tvGuideCollectionView.isHidden = false
        }
        else {
            self.stopAnimating()
            self.nodataFound = true
            self.errorView.isHidden = false
            self.tvGuideDateCollectionView.isHidden = true
            self.tvGuideCollectionView.isHidden = true
        }

    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        for subView in parentView.subviews{
            if subView.tag != 1 && subView.tag != 2 && subView.tag != 3 && subView.tag != 4{
                subView.removeFromSuperview()
            }
        }
        parentView.addSubview(subView)
         
       
        
        
        if let gradientBgView = self.leftGradientBgView {
            self.leftGradientBgView!.alpha = 0.6
            self.leftGradientBgView!.backgroundColor = .clear
            self.leftGradientBgView!.applyGradient(colors: [AppTheme.instance.currentTheme.guideArrowsBgGradientColor.cgColor, UIColor.clear.cgColor],
                                                   locations: [0.0, 1.0],
                                                   direction: .leftToRight)
            parentView.bringSubviewToFront(gradientBgView)
        }
        if let gradientBgView = self.rightGradientBgView {
            self.rightGradientBgView!.alpha = 0.6
            self.rightGradientBgView!.backgroundColor = .clear
            self.rightGradientBgView!.applyGradient(colors: [UIColor.clear.cgColor, AppTheme.instance.currentTheme.guideArrowsBgGradientColor.cgColor],
                                                   locations: [0.0, 1.0],
                                                   direction: .leftToRight)

            parentView.bringSubviewToFront(gradientBgView)
        }
        
        if let gradientarrow = self.leftGradientArrow {
            gradientarrow.image = gradientarrow.image?.withRenderingMode(.alwaysTemplate)
            gradientarrow.tintColor = AppTheme.instance.currentTheme.cardTitleColor
            parentView.bringSubviewToFront(gradientarrow)
            self.leftGradientBgView?.bringSubviewToFront(self.leftGradientArrow!)
        }
        if let gradientarrow = self.rightGradientArrow {
            parentView.bringSubviewToFront(gradientarrow)
            gradientarrow.image = gradientarrow.image?.withRenderingMode(.alwaysTemplate)
            gradientarrow.tintColor = AppTheme.instance.currentTheme.cardTitleColor
            self.rightGradientBgView?.bringSubviewToFront(self.rightGradientArrow!)
        }
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.startAnimating(allowInteraction: false)
        if nodataFound {
            self.stopAnimating()
        }
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        let yuppFLixUserDefaults = UserDefaults.standard
        yuppFLixUserDefaults.set(true, forKey: "TVGuideShowCaseView")
        if yuppFLixUserDefaults.object(forKey: "TVGuideShowCaseView") == nil {
            TabsViewController.instance.showCouchScreen()
            //            self.enableGoLiveBtn()
            
            //            self.presentShowCaseView(withText: "Click on go live to know what is currently playing in every channel.", forView: self.goLiveBtnView)
            yuppFLixUserDefaults.set(true, forKey: "TVGuideShowCaseView")
        }
        var ccHeight:CGFloat = 0.0
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            ccHeight = miniMediaControlsViewController.minHeight
        }
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true,chromeCastHeight:ccHeight)
    }
    
    func presentShowCaseView(withText:String, forView:UIView) {
        
        let focusPoint = forView.convert(forView.bounds, to: self.view)
        let pointInWindow = CGPoint.init(x: focusPoint.origin.x + 45.0, y: focusPoint.midY + 64.0)
        var portraitPoint = pointInWindow;
        var landscapePoint = pointInWindow;

        if  currentOrientation().landscape{
            portraitPoint.y = portraitPoint.y + 10.0
        }
        else {
            landscapePoint.y = landscapePoint.y - 10.0
        }
        CastInstructionsViewController.showHelperOverViewController(self, atFocus: portraitPoint, focuspointInLandscape: landscapePoint, withMessage: withText) {
            
        }
        
//        let showcase = MaterialShowcase()
//        showcase.setTargetView(view: forView) // always required to set targetView
//        showcase.backgroundPromptColor = UIColor.black.withAlphaComponent(0.5)
//        showcase.backgroundPromptColorAlpha = 0.96
//        showcase.setDefaultProperties()
//        showcase.primaryText = withText
//        showcase.secondaryText = ""
//        showcase.delegate = self
//        showcase.show(completion: {
//            // You can save showcase state here
//            // Later you can check and do not show it again
//        })
    }
    
    @IBAction func tvGuideLangBtnClicked(_ sender: Any) {
    }
    
    @IBAction func tvGuideCatgBtnClicked(_ sender: Any) {
        let vc = TVGuideFiltersViewController()
        vc.delegate = self
        vc.tvGuideFilters = self.tvGuideFilterArr
        vc.initFilterArr(catgArr: self.selectedCatgFilterArr, langArr: self.selectedLanguageFilterArr)
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tvDateTitlesArray.count == 0 {
            return 5
        }
        return self.tvDateTitlesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: TVGuideDateCell.nibname, bundle: nil), forCellWithReuseIdentifier: TVGuideDateCell.identifier)
        if self.tvGuideDateArr.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVGuideDateCell.identifier, for: indexPath) as! TVGuideDateCell
            return cell
        }
        else {
            let tvGuideDateData = self.tvGuideDateArr[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVGuideDateCell.identifier, for: indexPath) as! TVGuideDateCell
            if tvGuideDateData.isSelected {
                cell.tvShowGuideDateLbl.text = tvGuideDateData.title
            } else {
                cell.tvShowGuideDateLbl.text = "\(tvGuideDateData.title), \(tvGuideDateData.subtitle)"
            }
            if self.selectedIndexpath == indexPath.row {
                cell.isSelected = true
                collectionView.selectItem(at: NSIndexPath.init(item: self.selectedIndexpath, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.bottom)
            }
            else {
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: false)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.tvDateTitlesArray.count == 0 {
            return CGSize(width: 93, height: 50)
        } else {
            let width = self.tvDateTitlesArray[indexPath.item].answerHeight + 10
            if productType.iPad {
                return CGSize(width: width, height: 60.0)
            }
            else {
                return CGSize(width: width, height: 50)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.tvGuideDateArr.count > indexPath.row {
            let tvGuideDateData = self.tvGuideDateArr[indexPath.row]
            self.tvGuideTabSelected = true
            AppDelegate.getDelegate().tvGuideDataNAIndex = indexPath.row
            AppDelegate.getDelegate().tvGuideTabSelected = indexPath.row
            self.selectedIndexpath = indexPath.row
            AppDelegate.getDelegate().tvGuideSelectedTabDate = self.getFullDate("\(tvGuideDateData.startTime)")
            AppDelegate.getDelegate().presentShowingDateTab = tvGuideDateData
            //        var skipGettingData = false
            //        for tabObj_ in AppDelegate.getDelegate().alreadyLoadedTabDataArr {
            //            if tabObj_.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue {
            //                skipGettingData = true
            //            }
            //        }
            //        if !self.checkDataAvailableForDate(tvGuideDateData.startTime) {
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CheckAndGetData"), object: nil)
            //AppDelegate.getDelegate().alreadyLoadedTabDataArr.removeAll()
            AppDelegate.getDelegate().isScrollToTop = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetDataWithFilter"), object: nil)
            //        }
            //        else {
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollToSelectedDate"), object: nil)
            //        }
            //        if !self.checkDataAvailableForDate(tvGuideDateData.startTime) {
            //            if indexPath.row <= self.tvGuideDateArr.count / 2 || indexPath.row == (self.tvGuideDateArr.count - 1){
            //                AppDelegate.getDelegate().isScrollToTop = true
            //            }
            //            else {
            //                AppDelegate.getDelegate().isScrollToTop = false
            //            }
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollCollectionViewToEnd"), object: nil)
            //        }
            //        else {
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollToSelectedDate"), object: nil)
            //        }
            //        self.getTVGuideEPGContent(start_time: tvGuideDateData.startTime, end_time: tvGuideDateData.endTime)
        }
    }
    
    @objc func enableGoLiveBtn() {
          let yuppFLixUserDefaults = UserDefaults.standard
        if yuppFLixUserDefaults.object(forKey: "GoLiveShowCaseView") == nil {
            yuppFLixUserDefaults.set(true, forKey: "GoLiveShowCaseView")
        }
    }
    
    @objc func disableGoLiveBtn() {
    }
    
    @objc func goNowLive() {
        for tvGuideDateObj in self.tvGuideDateArr {
            if self.dayDifference(from: "\(tvGuideDateObj.startTime)") == "Today" {
                self.tvGuideTabSelected = true
                AppDelegate.getDelegate().tvGuideSelectedTabDate = self.getFullDate("\(tvGuideDateObj.startTime)")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollToSelectedDate"), object: nil)
                break;
            }
        }
    }
    
    @objc func selectTab() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.selectedIndexpath = AppDelegate.getDelegate().tvGuideTabSelected
//            self.selectedDateLbl.text = "\(self.tvGuideDateArr[AppDelegate.getDelegate().tvGuideTabSelected].title), \(self.tvGuideDateArr[AppDelegate.getDelegate().tvGuideTabSelected].subtitle)"
            if self.tvGuideDateArr[AppDelegate.getDelegate().tvGuideTabSelected].isSelected {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowNowLiveIndicator"), object: nil, userInfo: [String:String]())
            }
            self.tvGuideDateCollectionView.selectItem(at: NSIndexPath.init(item: AppDelegate.getDelegate().tvGuideTabSelected, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            //            if productType.iPad {
            //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateNowLiveViewFrame"), object: nil)
            //            }
        }
 
    }
    @objc func getTabData() {
        
    }
    @objc func showNextShowCaseView(notification: NSNotification) {
        
        if let message = notification.userInfo?["message"] as? String {
            if message == "Click on go live to know what is currently playing in every channel." {
                self.presentShowCaseView(withText: "Catch up of your favourite channel is now just a click away.".localized, forView: self.tvGuideDateCollectionView)
            }
            else if message == "Catch up of your favourite channel is now just a click away." {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowChannelShowCaseView"), object: nil)
            }
        }
    }

    @objc func changeBottomConstraint(notification: NSNotification) {
        
        if let status = notification.userInfo?["status"] as? Bool {
            if status {
                self.tvGuideCollectionViewBottomConstraint.constant = productType.iPad ? 140 : 80.0
            }
            else {
                self.tvGuideCollectionViewBottomConstraint.constant = 0.0
            }
        }
    }
    
    @IBAction func goLiveBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GoLiveBtnClicked"), object: nil)
    }
    
    func dayDifference(from interval : String) -> String
    {
        let calendar = NSCalendar.current
        let date = self.getFullDate(interval)
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    func getFullDate(_ timestamp:String) -> Date {
        let time = (timestamp as NSString).doubleValue/1000
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
        return date
    }
    
    func checkDataAvailableForDate(_ startTime:NSNumber) -> Bool {
        var dataStatus:Bool = false
        for channelObj in self.tvGuideDataArr {
            for programObj in channelObj.programs {
//                for markerObj in programObj.display.markers {
//                    if markerObj.markerType == .startTime {
//                        let date1 = self.getFullDate("\(startTime)")
//                        let date2 = self.getFullDate(markerObj.value)
//                        if self.compareDate(date1: date1, date2: date2) {
//                            dataStatus = true
//                            break;
//                        }
//                    }
//                }
            }
        }
        return dataStatus
    }
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    @objc func showErrorView() {
        self.errorView.isHidden = false
    }

    @objc func hideErrorView() {
        self.errorView.isHidden = true
    }
    
    
    @IBAction func couchOkBtnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
        }
        else if sender.tag == 2 {
            self.disableGoLiveBtn()
            self.tvGuideDateCollectionView.isUserInteractionEnabled = true
        }
        else if sender.tag == 3 {
            self.tvGuideDateCollectionView.isUserInteractionEnabled = true
            TabsViewController.instance.hideCouchScreen()
        }
    }
    
    // MARK: - TVGuide Filters Delegate
    func tvGuidefilterSelected(filterDic:[String:Any]) {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
//        self.selectedCatgFilterArr.removeAllObjects()
//        self.selectedLanguageFilterArr.removeAllObjects()
        var filterString = ""
        for (key, value) in filterDic {
            let filterCodeList = value as! NSMutableArray
            if key == "genreCode" {
                self.selectedCatgFilterArr = NSMutableArray.init(array: filterCodeList)
            }
            else {
                self.selectedLanguageFilterArr = NSMutableArray.init(array: filterCodeList)
            }
            if filterCodeList.count > 0 {
                filterString = filterString + (filterString.count > 0 ? ";" : "") + key + ":"
                for filterCode in filterCodeList {
                    if filterCodeList.lastObject as! String == filterCode as! String {
                        filterString = "\(filterString)\(filterCode)"
                    }
                    else {
                        filterString = "\(filterString)\(filterCode),"
                    }
                }
            }
        }
        AppDelegate.getDelegate().tvGuideFilterString = filterString
        //AppDelegate.getDelegate().alreadyLoadedTabDataArr.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetDataWithFilter"), object: nil)
    }
    
    func tvGuidefilterCancelled() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
    }
    
    // MARK: - Material Show Case Delegates

    func showCaseWillDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        print("Showcase \(String(describing: showcase.primaryText)) will dismiss.")
    }
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        print("Showcase \(String(describing: showcase.primaryText)) dimissed.")
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            if AppDelegate.getDelegate().isPartialViewLoaded == true{
                PartialRenderingView.instance.reloadDataWithFrameUpdate()
            }
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
