//
//  TVGuideCollectionCollectionViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 01/03/18.
//  Copyright © 2018 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

private let reuseIdentifier = "Cell"

class TVGuideCollectionCollectionViewController: UICollectionViewController,INSElectronicProgramGuideLayoutDataSource, INSElectronicProgramGuideLayoutDelegate, PlayerViewControllerDelegate, TVGuideDescPopUpProtocol,ProgramRecordConfirmationPopUpProtocol,ProgramStopRecordConfirmationPopUpUpProtocol,PartialRenderingViewDelegate {
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    static let reloadNotificationName = "TVGuideReloadNotificationName"
    
    var startDate: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: -10, to: Date(), options: [])!
    }
    
    var endDate: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: -5, to: Date(), options: [])!
    }
    
    var tvGuideDataArr = [ChannelObj]()
    var programsDataArr = [ChannelProgramsResponse]()
    var userProgramsDataArr = [UserProgramResponse]()
    var tvGuideDateArr = [TVGuideTab]()
    var nowLiveIndicatorView:UIView!
    var liveProgramsView:UIView!
    var nowLiveViewXPosition:CGFloat = 0.0
    var donotShowNowLiveIndicator:Bool = false
    var lastContentOffset:CGFloat = 0.0
    var scrollViewContentSize:CGFloat = 0.0
    var lastViewingIndexpath:IndexPath!
    var lastViewingDateToBeScrolled:Date!
    var goGetTheData:Bool = true
    var isFilterDataLoading:Bool = false
    var noMorePaginationData:Bool = false
    var noDataStartTime:String?
    var noDataEndTime:String?
    var oldContentOffset = CGPoint.zero
    var showcase:MaterialShowcase!
    var nowLiveFrame:CGRect!
    var recordingCardsArr = [String]()
    var recordingSeriesArr = [String]()
    var channelIdsStr = ""

    func collectionViewEPGLayout() -> INSElectronicProgramGuideLayout {
        return (collectionViewLayout as? INSElectronicProgramGuideLayout) ?? INSElectronicProgramGuideLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.collectionView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        //        // Uncomment the following line to preserve selection between presentations
        //        // self.clearsSelectionOnViewWillAppear = false
        //
        //        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        //        self.collectionView?.layer.shadowColor = UIColor.black.cgColor
        //        self.collectionView?.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        //        self.collectionView?.layer.shadowOpacity = 1
        //        self.collectionView?.layer.shadowRadius = 1.0
        //        self.collectionView?.clipsToBounds = false
        //        self.collectionView?.layer.masksToBounds = false
        
        self.collectionView?.reloadData()
        if self.nowLiveIndicatorView != nil {
            self.nowLiveIndicatorView.layer.shadowColor = UIColor.black.cgColor
            self.nowLiveIndicatorView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
            self.nowLiveIndicatorView.layer.shadowRadius = 1.0
            self.nowLiveIndicatorView.layer.shadowOpacity = 1.0
            self.nowLiveIndicatorView.layer.masksToBounds = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTheNowLiveViewFrame), name: NSNotification.Name(rawValue: "UpdateNowLiveViewFrame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goLiveBtnClicked), name: NSNotification.Name(rawValue: "GoLiveBtnClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideNowLiveView), name: NSNotification.Name(rawValue: "HideNowLiveIndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNowLiveView(_:)), name: NSNotification.Name(rawValue: "ShowNowLiveIndicator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollToSelectedDate), name: NSNotification.Name(rawValue: "ScrollToSelectedDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.channelBtnClicked(_:)), name: NSNotification.Name(rawValue: "ChannelButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollCollectionViewToEnd), name: NSNotification.Name(rawValue: "ScrollCollectionViewToEnd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAndGetData), name: NSNotification.Name(rawValue: "CheckAndGetData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDataWithFilter), name: NSNotification.Name(rawValue: "GetDataWithFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDataForSelectedTab), name: NSNotification.Name(rawValue: "GetDataForSelectedTab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showShowCaseView), name: NSNotification.Name(rawValue: "ShowChannelShowCaseView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPage), name: NSNotification.Name(rawValue: TVGuideCollectionCollectionViewController.reloadNotificationName), object: nil)

        //self.startAnimating(allowInteraction: false)
        
        self.collectionViewEPGLayout().dataSource = self;
        self.collectionViewEPGLayout().delegate = self;
        if self.nowLiveIndicatorView != nil {
            self.nowLiveIndicatorView.frame.origin.y = 34.0
        }
        self.collectionViewEPGLayout().shouldResizeStickyHeaders = false;
        self.collectionViewEPGLayout().shouldUseFloatingItemOverlay = true;
        self.collectionViewEPGLayout().floatingItemOffsetFromSection = 0.0;
        self.collectionViewEPGLayout().floatingItemOverlaySize = CGSize.init(width: 100.0, height: 50.0);
        self.collectionViewEPGLayout().currentTimeVerticalGridlineWidth = 2.0;
        self.collectionViewEPGLayout().currentTimeIndicatorSize = CGSize.init(width: 100.0, height: 50.0)
        self.collectionViewEPGLayout().currentTimeIndicatorShouldBeBehind = false
        self.collectionViewEPGLayout().sectionHeight = (productType.iPad ? 100 : 67.0);
        self.collectionViewEPGLayout().sectionHeaderWidth = (productType.iPad ? 160 : 90.0);
        self.collectionViewEPGLayout().sectionGap = 0.0
        self.collectionViewEPGLayout().headerLayoutType = .timeRowAboveDayColumn
        self.collectionViewEPGLayout().hourWidth = 300.0
        
//        if productType.iPad {
//            self.collectionViewEPGLayout().sectionHeight = (productType.iPad ? 100 : 125.0);
//            self.collectionViewEPGLayout().sectionHeaderWidth = (productType.iPad ? 160 : 90.0);
//        }
        
        let timeRowHeaderStringClass: String = NSStringFromClass(ISHourHeader.self)
        collectionView?.register(UINib(nibName: timeRowHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindHourHeader, withReuseIdentifier: timeRowHeaderStringClass)
        collectionView?.register(UINib(nibName: timeRowHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindHalfHourHeader, withReuseIdentifier: timeRowHeaderStringClass)
        
        let cellStringClass: String = NSStringFromClass(ISFloatingCell.self)
        collectionView?.register(UINib(nibName: cellStringClass, bundle: nil), forCellWithReuseIdentifier: cellStringClass)
        let dayColumnHeaderStringClass: String = NSStringFromClass(ISSectionHeader.self)
        collectionView?.register(UINib(nibName: dayColumnHeaderStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindSectionHeader, withReuseIdentifier: dayColumnHeaderStringClass)
        
        collectionViewEPGLayout().register(ISCurrentTimeGridlineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindCurrentTimeIndicatorVerticalGridline)
        collectionViewEPGLayout().register(ISGridlineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindVerticalGridline)
        collectionViewEPGLayout().register(ISHalfHourLineView.self, forDecorationViewOfKind: INSEPGLayoutElementKindHalfHourVerticalGridline)
        collectionViewEPGLayout().register(ISHeaderBackgroundView.self, forDecorationViewOfKind: INSEPGLayoutElementKindSectionHeaderBackground)
        collectionViewEPGLayout().register(ISHourHeaderBackgroundView.self, forDecorationViewOfKind: INSEPGLayoutElementKindHourHeaderBackground)
        
        
        let floatingCellOverlayStringClass: String = NSStringFromClass(ISFloatingCellOverlay.self)
        collectionView?.register(UINib(nibName: floatingCellOverlayStringClass, bundle: nil), forSupplementaryViewOfKind: INSEPGLayoutElementKindFloatingItemOverlay, withReuseIdentifier: floatingCellOverlayStringClass)
        
        if self.tvGuideDataArr.count > 0 {
            self.collectionView.isHidden = self.checkIsDataAvailableForAllChannels()
        }else {
            self.collectionView.isHidden = true
        }
        collectionView?.register(CollectionViewFooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewFooterClass.identifier)
    }
    
    func checkIsDataAvailableForAllChannels() -> Bool {
        var status : Bool = true
        for guideData in self.tvGuideDataArr {
            if guideData.programs.count > 0 {
                status = false
                break;
            }
        }
        return status
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if OTTSdk.preferenceManager.user == nil && AppDelegate.getDelegate().recordingCardsArr.count > 0{
            AppDelegate.getDelegate().recordingCardsArr.removeAll()
        }
        for tempStr in AppDelegate.getDelegate().recordingCardsArr{
            let tempVal = self.recordingCardsArr.firstIndex(of: tempStr)
            if tempVal == nil {
                self.recordingCardsArr.append(tempStr)
            } else {
                self.recordingCardsArr.remove(at: tempVal!)
            }
        }
        AppDelegate.getDelegate().recordingCardsArr.removeAll()

        if OTTSdk.preferenceManager.user == nil && AppDelegate.getDelegate().recordingSeriesArr.count > 0{
            AppDelegate.getDelegate().recordingSeriesArr.removeAll()
        }
        for tempStr in AppDelegate.getDelegate().recordingSeriesArr{
            let tempVal = self.recordingSeriesArr.firstIndex(of: tempStr)
            if tempVal == nil {
                self.recordingSeriesArr.append(tempStr)
            } else {
                self.recordingSeriesArr.remove(at: tempVal!)
            }
        }
        AppDelegate.getDelegate().recordingSeriesArr.removeAll()
        self.collectionViewEPGLayout().collectionView?.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                //self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            //self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            var goToCurrentTime:Bool = false
            for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                if AppDelegate.getDelegate().presentShowingDateTab != nil && AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue == tabObj.startTime.intValue && tabObj.isSelected {
                    goToCurrentTime = true
                    break;
                }
            }
            if goToCurrentTime {
                self.collectionViewEPGLayout().scrollToCurrentTime(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                if self.nowLiveIndicatorView != nil && self.liveProgramsView != nil && !self.donotShowNowLiveIndicator {
                    self.nowLiveIndicatorView.isHidden = false
                    self.liveProgramsView.isHidden = false
                    if productType.iPad {
                        if currentOrientation().landscape {
                            self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 490.0
                        }else {
                            self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 363.0
                        }
                        self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                        self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                        self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                        self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                    }
                    else {
                        if self.nowLiveFrame != nil {
                            self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                            self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                            self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                            self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                            self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                        }
                        else {
                            self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143.0
                            self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                            self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                            self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                            self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                        }

                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
                    var subViewsArr = (self.collectionView?.subviews)!
                    for subView in subViewsArr {
                        if subView.tag == 02 || subView.tag == 14 {
                            subView.removeFromSuperview()
                        }
                    }
                    subViewsArr = (self.collectionView?.subviews)!
                    for (index, subView) in subViewsArr.enumerated() {
                        subView.removeFromSuperview()
                        if index == 0 {
                            self.liveProgramsView.tag = 02
                            self.collectionView?.addSubview(self.liveProgramsView)
                            self.collectionView?.addSubview(subView)
                        }
                        else {
                            self.collectionView?.addSubview(subView)
                        }
                    }
                    self.nowLiveIndicatorView.tag = 14
                    self.collectionView?.addSubview(self.nowLiveIndicatorView)
                    if self.tvGuideDataArr.count != 0 {
                        //self.stopAnimating()
                        AppDelegate.getDelegate().window?.isUserInteractionEnabled = true
                        self.view.isUserInteractionEnabled = true
                    }
                    if productType.iPad {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                            self.goLiveBtnClicked()
                        })
                    }
                }
                else {
                    if self.tvGuideDataArr.count != 0 {
                        //self.stopAnimating()
                        AppDelegate.getDelegate().window?.isUserInteractionEnabled = true
                        self.view.isUserInteractionEnabled = true
                    }
                    self.view.setNeedsFocusUpdate()
                    self.view.updateFocusIfNeeded()
                }
            })
            
        })
    }
    
    @objc func updateTheNowLiveViewFrame() {
        
        //        self.collectionViewEPGLayout().currentTimeVerticalGridlineAttributes
        //        self.nowLiveViewXPosition = self.nowLiveViewXPosition + 7.0
        //        self.nowLiveIndicatorView.frame.origin.x = self.nowLiveViewXPosition
        if self.nowLiveIndicatorView != nil && isVisible(view: self.nowLiveIndicatorView) && !self.nowLiveIndicatorView.isHidden{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                self.collectionViewEPGLayout().scrollToCurrentTime(animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    if self.nowLiveIndicatorView != nil && self.liveProgramsView != nil && !self.donotShowNowLiveIndicator {
                        self.nowLiveIndicatorView.isHidden = false
                        self.liveProgramsView.isHidden = false
                        if productType.iPad {
                            if currentOrientation().landscape {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 490.0
                            }else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 363.0
                            }
                            self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                            self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                            self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                            self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                        }
                        else {
                            if self.nowLiveFrame != nil {
                                self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                            else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
                        var subViewsArr = (self.collectionView?.subviews)!
                        for subView in subViewsArr {
                            if subView.tag == 02 || subView.tag == 14 {
                                subView.removeFromSuperview()
                            }
                        }
                        subViewsArr = (self.collectionView?.subviews)!
                        for (index, subView) in subViewsArr.enumerated() {
                            subView.removeFromSuperview()
                            if index == 0 {
                                self.liveProgramsView.tag = 02
                                self.collectionView?.addSubview(self.liveProgramsView)
                                self.collectionView?.addSubview(subView)
                            }
                            else {
                                self.collectionView?.addSubview(subView)
                            }
                        }
                        self.nowLiveIndicatorView.tag = 14
                        self.collectionView?.addSubview(self.nowLiveIndicatorView)
                        self.collectionView?.reloadData()
                    }
                    else {
                        //self.stopAnimating()
                    }
                    if self.tvGuideDataArr.count > 0 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
                    }
                    self.view.setNeedsFocusUpdate()
                    self.view.updateFocusIfNeeded()
                })
                
            })
        }
    }
    
    @objc func goLiveBtnClicked() {
        for tabObj in self.tvGuideDateArr {
            if tabObj.isSelected {
                AppDelegate.getDelegate().presentShowingDateTab = tabObj
                break;
            }
        }
        if AppDelegate.getDelegate().getFullTVGuideData {
            AppDelegate.getDelegate().getFullTVGuideData = false
            self.loadLiveData()
            return;
        } else {
            if !self.checkDataAvailableForDate(AppDelegate.getDelegate().presentShowingDateTab.startTime) {
                self.getDataWithFilter()
                return;
            }
        }
        if self.tvGuideDataArr.count > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
        }
        if self.donotShowNowLiveIndicator {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                self.collectionViewEPGLayout().scrollToCurrentTime(animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    if self.nowLiveIndicatorView != nil && self.liveProgramsView != nil{
                        self.nowLiveIndicatorView.isHidden = false
                        self.liveProgramsView.isHidden = false
                        self.donotShowNowLiveIndicator = false
                        if productType.iPad {
                            if currentOrientation().landscape {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 490.0
                            }else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 363.0
                            }
                            self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                            self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                            self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                            self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                        }
                        else {
                            if self.nowLiveFrame != nil {
                                self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                            else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
                        var subViewsArr = (self.collectionView?.subviews)!
                        for subView in subViewsArr {
                            if subView.tag == 02 || subView.tag == 14 {
                                subView.removeFromSuperview()
                            }
                        }
                        subViewsArr = (self.collectionView?.subviews)!
                        for (index, subView) in subViewsArr.enumerated() {
                            subView.removeFromSuperview()
                            if index == 0 {
                                self.liveProgramsView.tag = 02
                                self.collectionView?.addSubview(self.liveProgramsView)
                                self.collectionView?.addSubview(subView)
                            }
                            else {
                                self.collectionView?.addSubview(subView)
                            }
                        }
                        self.nowLiveIndicatorView.tag = 14
                        self.collectionView?.addSubview(self.nowLiveIndicatorView)
                    }
                    else {
                        //self.stopAnimating()
                    }
                })
                
            })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                self.collectionViewEPGLayout().scrollToCurrentTime(animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    if self.nowLiveIndicatorView != nil && self.liveProgramsView != nil && !self.donotShowNowLiveIndicator {
                        self.nowLiveIndicatorView.isHidden = false
                        self.liveProgramsView.isHidden = false
                        if productType.iPad {
                            if currentOrientation().landscape {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 490.0
                            }else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 363.0
                            }
                            self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                            self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                            self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                            self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                        }
                        else {
                            if self.nowLiveFrame != nil {
                                self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                            else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
                        var subViewsArr = (self.collectionView?.subviews)!
                        for subView in subViewsArr {
                            if subView.tag == 02 || subView.tag == 14 {
                                subView.removeFromSuperview()
                            }
                        }
                        subViewsArr = (self.collectionView?.subviews)!
                        for (index, subView) in subViewsArr.enumerated() {
                            subView.removeFromSuperview()
                            if index == 0 {
                                self.liveProgramsView.tag = 02
                                self.collectionView?.addSubview(self.liveProgramsView)
                                self.collectionView?.addSubview(subView)
                            }
                            else {
                                self.collectionView?.addSubview(subView)
                            }
                        }
                        self.nowLiveIndicatorView.tag = 14
                        self.collectionView?.addSubview(self.nowLiveIndicatorView)
                    }
                    else {
                        //self.stopAnimating()
                    }
                })
                
            })
        }
    }
    
    @objc func showNowLiveView(_ notification:NSNotification) {
        if  notification != nil {
            if let indicatorFrameArr = notification.userInfo!["IndicatorFrame"] as? NSArray {
                self.nowLiveFrame = indicatorFrameArr[0] as? CGRect
            }
        }

        if self.nowLiveIndicatorView != nil{
            self.nowLiveIndicatorView.isHidden = false
        }
        if self.liveProgramsView != nil{
            self.liveProgramsView.isHidden = false
        }
        self.donotShowNowLiveIndicator = false
    }
    @objc func hideNowLiveView() {
        if self.nowLiveIndicatorView != nil{
            self.nowLiveIndicatorView.isHidden = true
        }
        if self.liveProgramsView != nil{
            self.liveProgramsView.isHidden = true
        }
        self.donotShowNowLiveIndicator = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnableGoLiveBtn"), object: nil)
    }
    
    @objc func scrollToSelectedDate() {
        self.collectionViewEPGLayout().scrollToSelectedTime(animated: true, selectedDate: AppDelegate.getDelegate().tvGuideSelectedTabDate)
        if self.dayDifference(from: AppDelegate.getDelegate().tvGuideSelectedTabDate) == "Today" {
            self.goLiveBtnClicked()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout, startTimeForItemAt indexPath: IndexPath) -> Date {
        
        if self.tvGuideDataArr.count == 0 {
            return Date()
        }
//        else if self.noDataStartTime != nil {
//            return self.getFullDate(self.noDataStartTime!)
//        }
        else {
            if self.tvGuideDataArr[indexPath.section].programs[indexPath.row].target.pageAttributes.startTime == "" {
                return Date()
            }
            return self.getFullDate(self.tvGuideDataArr[indexPath.section].programs[indexPath.row].target.pageAttributes.startTime)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout, endTimeForItemAt indexPath: IndexPath) -> Date {
        
        if self.tvGuideDataArr.count == 0 {
            return Date()
        }
//        else if self.noDataStartTime != nil {
//            return self.getFullDate(self.noDataEndTime!)
//        }
        else {
            if self.tvGuideDataArr[indexPath.section].programs[indexPath.row].target.pageAttributes.endTime == "" {
                return Date()
            }
            return self.getFullDate(self.tvGuideDataArr[indexPath.section].programs[indexPath.row].target.pageAttributes.endTime)
        }
    }
    
    func currentTime(for collectionView: UICollectionView, layout collectionViewLayout: INSElectronicProgramGuideLayout) -> Date {
        return Date()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view: UICollectionReusableView?
        if kind == INSEPGLayoutElementKindSectionHeader {
            if self.tvGuideDataArr.count == 0 {
                let dayColumnHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ISSectionHeader.self), for: indexPath) as? ISSectionHeader
                dayColumnHeader?.channelImgView.image = #imageLiteral(resourceName: "Default-TVShows")
                view = dayColumnHeader
            }
            else {
                let channelObj = self.tvGuideDataArr[indexPath.section]
                let dayColumnHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ISSectionHeader.self), for: indexPath) as? ISSectionHeader
                dayColumnHeader?.dayLabel.text = channelObj.display.title
                dayColumnHeader?.dayLabel.font = UIFont.ottRegularFont(withSize: 16)
                dayColumnHeader?.dayLabel.textColor = .purple
                dayColumnHeader?.channelImgView.loadingImageFromUrl(channelObj.display.imageUrl, category: "tv")
                dayColumnHeader?.channelBtn.tag = indexPath.section
//                dayColumnHeader?.layer.shadowColor = UIColor.black.cgColor
//                dayColumnHeader?.layer.shadowOffset = CGSize(width: 0.8, height: 0)
//                dayColumnHeader?.layer.shadowRadius = 1.0
//                dayColumnHeader?.layer.shadowOpacity = 1.0
//                dayColumnHeader?.layer.masksToBounds = false
                if indexPath.section == 2{
                    self.presentShowCaseView(withText: "Click on a channel to access it’s catch-up.".localized, forView: dayColumnHeader!)
                }
                if productType.iPad {
                    //dayColumnHeader?.channelImgViewWidthConstraint.constant = 130.0
                }
                dayColumnHeader?.backgroundColor = AppTheme.instance.currentTheme.tvGuideChannelBgColor
                view = dayColumnHeader
            }
        } else if kind == INSEPGLayoutElementKindHourHeader {
            let timeRowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ISHourHeader.self), for: indexPath) as? ISHourHeader
            timeRowHeader?.time = collectionViewEPGLayout().dateForHourHeader(at: indexPath)
            timeRowHeader?.setTextColor(AppTheme.instance.currentTheme.cardTitleColor)
          //  timeRowHeader?.backgroundColor = AppTheme.instance.currentTheme.tvGuideTimeBackgroundColor
            view = timeRowHeader
        } else if kind == INSEPGLayoutElementKindHalfHourHeader {
            let timeRowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ISHourHeader.self), for: indexPath) as? ISHourHeader
            timeRowHeader?.time = collectionViewEPGLayout().dateForHalfHourHeader(at: indexPath)
            timeRowHeader?.setTextColor(AppTheme.instance.currentTheme.cardTitleColor)
         //   timeRowHeader?.backgroundColor = AppTheme.instance.currentTheme.tvGuideTimeBackgroundColor
            view = timeRowHeader
        }  else if kind == UICollectionView.elementKindSectionFooter
        {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewFooterClass.identifier, for: indexPath)
            
            footerView.backgroundColor = UIColor.clear
            view = footerView
        }
        else if kind == INSEPGLayoutElementKindFloatingItemOverlay{
            let floatingItemOverlay = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ISFloatingCellOverlay.self), for: indexPath)
            if let floatingCell = (floatingItemOverlay as? ISFloatingCellOverlay){
                let channelObj = self.tvGuideDataArr[indexPath.section]
                if channelObj.programs.count > indexPath.row{
                    let program = channelObj.programs[indexPath.row]
                    floatingCell.titleLabel.text = program.display.title
                    floatingCell.titleLabel?.font = UIFont.ottRegularFont(withSize: 15)
                    floatingCell.titleLabel.numberOfLines = (productType.iPad ? 2 : 1)
                    floatingCell.titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.7)
                    
                }
            }
            
            view = floatingItemOverlay
        }
        
        
        return view!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: 80.0)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.tvGuideDataArr.count == 0 {
            return 0
        }
        return self.tvGuideDataArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tvGuideDataArr.count == 0 {
            return 0
        }
        print(self.tvGuideDataArr[section].programs.count)
        return self.tvGuideDataArr[section].programs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.tvGuideDataArr.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ISFloatingCell.self), for: indexPath) as? ISFloatingCell
            return cell!
        }
        else {
            if (self.tvGuideDataArr.count) > indexPath.section && self.tvGuideDataArr[indexPath.section].programs.count > indexPath.row {
                let programData = self.tvGuideDataArr[indexPath.section].programs[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ISFloatingCell.self), for: indexPath) as? ISFloatingCell
                //cell?.titleLabel?.text = programData.display.title
                cell?.titleLabel?.font = UIFont.ottRegularFont(withSize: 15)
                cell?.titleLabel.numberOfLines = (productType.iPad ? 2 : 1)
                cell?.recordingStatusImgView.isHidden = true
                
               /* let startTimeStr = programData.target.pageAttributes.startTime
                let endTimeStr = programData.target.pageAttributes.endTime

                if programData.target.pageAttributes.isRecorded {
                    if self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(endTimeStr)) == .orderedDescending {
                        cell?.recordingStatusImgView.image = UIImage.init(named: "group_999")
                        cell?.recordingStatusImgView.isHidden = false
                    } else if (self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(startTimeStr)) == .orderedAscending) || (self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(startTimeStr)) == .orderedDescending && self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(endTimeStr)) == .orderedAscending) {
                        cell?.recordingStatusImgView.image = UIImage.init(named: "group_998")
                        cell?.recordingStatusImgView.isHidden = false
                    }
                    
                }*/
                cell?.titleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.7)
                cell?.dateLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.7)
                cell?.viewWithTag(1)?.backgroundColor = AppTheme.instance.currentTheme.tvGuideContentCellBorderColor
                cell?.viewWithTag(2)?.backgroundColor = AppTheme.instance.currentTheme.tvGuideContentCellBorderColor
                cell?.contentView.backgroundColor = AppTheme.instance.currentTheme.tvGuideContentCellColor
                return cell!
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ISFloatingCell.self), for: indexPath) as? ISFloatingCell
                return cell!
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout electronicProgramGuideLayout: INSElectronicProgramGuideLayout, sizeForFloatingItemOverlayAt indexPath: IndexPath) -> CGSize {
        
        var text = ""
        if self.tvGuideDataArr.count > indexPath.section{
            if self.tvGuideDataArr.count > indexPath.section{
                let channelObj = self.tvGuideDataArr[indexPath.section]
                if channelObj.programs.count > indexPath.row{
                    
                    let program = channelObj.programs[indexPath.row]
                    text = program.display.title
                }
            }
        }
        
        return CGSize(width: text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]).width + 20, height: electronicProgramGuideLayout.sectionHeight)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let programData = self.tvGuideDataArr[indexPath.section].programs[indexPath.row]
        let card = Card()
        card.cardType = .overlay_poster
        card.display.imageUrl = programData.display.imageUrl
        card.display.title = programData.display.title
        card.display.subtitle1 = programData.display.subtitle1
        card.display.subtitle2 = programData.display.subtitle2
        card.display.isRecording = programData.target.pageAttributes.isRecorded
        card.metadata.id = programData.metadata.id
        card.target.path = programData.target.path
        card.template = programData.template
        var cardAttributes = [String:Any]()
        cardAttributes["recordingForm"] = programData.target.pageAttributes.recordingForm
        card.target.pageAttributes = cardAttributes
        self.tvGuideWatchNowClicked(programObj: card, channel : self.tvGuideDataArr[indexPath.section])
/*
        if AppDelegate.getDelegate().enableNdvr{
            self.tvGuideWatchNowClicked(programObj: programData, channel : self.tvGuideDataArr[indexPath.section])
            return;
            
            var recordStatus = false
            for marker in programData.display.markers {
                if marker.markerType == .record || marker.markerType == .stoprecord{
                    recordStatus = true
                }
            }
            var labelStr = ""
            for programObjMarkers in programData.display.markers {
                if programObjMarkers.markerType == .tag {
                    labelStr = programObjMarkers.value
                }
            }
            if labelStr.lowercased().contains(AppDelegate.getDelegate().recordStatusRecorded.lowercased()) || labelStr.lowercased().contains(AppDelegate.getDelegate().recordStatusRecording.lowercased()) {
                recordStatus = true
            }
            /*
            if recordStatus {
                let cell = collectionView.cellForItem(at: indexPath) as! ISFloatingCell
                if OTTSdk.preferenceManager.user != nil {
                    if cell.recordingStatusLbl.text == AppDelegate.getDelegate().buttonRecord {
                        self.showRecordPopUp(programData: programData, indexPath: indexPath)
                    }
                    else if cell.recordingStatusLbl.text!.lowercased().contains(AppDelegate.getDelegate().recordStatusScheduled.lowercased()) {
                        self.showStopRecordPopUp(programData: programData, indexPath: indexPath)
                    }
                    else if cell.recordingStatusLbl.text!.lowercased().contains( AppDelegate.getDelegate().recordStatusRecording.lowercased()) || cell.recordingStatusLbl.text!.lowercased().contains(AppDelegate.getDelegate().recordStatusRecorded.lowercased()){
                        let vc = TVGuideDescPopUpViewController()
                        vc.delegate = self
                        vc.programObj = programData
                        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
                        })
                    }
                } else if cell.recordingStatusLbl.text!.count > 0 {
                    let alert = UIAlertController(title: String.getAppName(), message: "You are not logged in".localized, preferredStyle: UIAlertController.Style.alert)
                    let cancelAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    alert.addAction(cancelAlertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                var startTimeStr = ""
                var endTimeStr = ""
                for programObjMarkers in programData.display.markers {
                    if programObjMarkers.markerType == .startTime {
                        startTimeStr = programObjMarkers.value
                    } else if programObjMarkers.markerType == .endTime {
                        endTimeStr = programObjMarkers.value
                    }
                }
                if self.getFullDate(startTimeStr).compare(self.getFullDate("\(Date().getCurrentTimeStamp())")) == .orderedAscending && self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(endTimeStr)) == .orderedAscending{
                    
                    let vc = TVGuideDescPopUpViewController()
                    vc.delegate = self
                    vc.programObj = programData
                    self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
                    })
                }
            }
            */
        }
        else{
//            let vc = TVGuideDescPopUpViewController()
//            vc.delegate = self
//            vc.programObj = programData
//            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
//            })
            self.tvGuideWatchNowClicked(programObj: programData)
        }*/
}
    
    func showRecordPopUp(programData:Card, indexPath:IndexPath) {
        let vc = ProgramRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = indexPath.section
        vc.rowIndex = indexPath.row
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }


    func showStopRecordPopUp(programData:Card, indexPath:IndexPath) {
        let vc = ProgramStopRecordConfirmationPopUp()
        vc.delegate = self
        vc.programObj = programData
        vc.sectionIndex = indexPath.section
        vc.rowIndex = indexPath.row
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })
    }
    //    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        let programData = self.tvGuideDataArr[indexPath.section].programs[indexPath.row]
    //        var startTimeStr = ""
    //        for programObjMarkers in programData.display.markers {
    //            if programObjMarkers.markerType == .startTime {
    //                startTimeStr = programObjMarkers.value
    //                break;
    //            }
    //        }
    //        for (index, tabObj) in self.tvGuideDateArr.enumerated() {
    //            if self.compareDate(date1: self.getFullDate(startTimeStr), date2: self.getFullDate("\(tabObj.startTime)")){
    //                if AppDelegate.getDelegate().tvGuideSelectedTabDate != nil {
    //                    if (self.compareDate(date1: self.getFullDate(startTimeStr), date2: AppDelegate.getDelegate().tvGuideSelectedTabDate)) {
    //                        AppDelegate.getDelegate().tvGuideTabSelected = index
    //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
    //                        return;
    //                    }
    //                    AppDelegate.getDelegate().tvGuideSelectedTabDate = self.getFullDate(startTimeStr)
    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
    //                    break;
    //                }
    //                else {
    //                    AppDelegate.getDelegate().tvGuideTabSelected = index
    //                    AppDelegate.getDelegate().tvGuideSelectedTabDate = self.getFullDate(startTimeStr)
    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
    //                    break;
    //                }
    //            }
    //        }
    //        if (self.compareDate(date1: self.getFullDate(startTimeStr), date2: AppDelegate.getDelegate().tvGuideSelectedTabDate)) && self.dayDifference(from: self.getFullDate(startTimeStr)) == "Today" {
    //            self.nowLiveIndicatorView.isHidden = false
    //            self.liveProgramsView.isHidden = false
    //        }
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        return;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
        var presentViewingDate:Date!
        var tabPresentViewingDate:Date!
        if elementKind == INSEPGLayoutElementKindHourHeader {
            presentViewingDate = collectionViewEPGLayout().dateForHourHeader(at: indexPath)
            
            if self.nowLiveIndicatorView != nil && self.isVisible(view: self.nowLiveIndicatorView) {
                if presentViewingDate != nil && AppDelegate.getDelegate().presentShowingDateTab != nil{
                    presentViewingDate = self.convertToDate(dateString: presentViewingDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss"))
                    tabPresentViewingDate = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime)")
                    if !self.compareDate(date1: presentViewingDate, date2: tabPresentViewingDate){
                        presentViewingDate = tabPresentViewingDate
                    }
                }
            }
            if presentViewingDate != nil && AppDelegate.getDelegate().presentShowingDateTab != nil {
                presentViewingDate = self.convertToDate(dateString: presentViewingDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss"))
//                self.lastViewingDateToBeScrolled = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue)")
                tabPresentViewingDate = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime)")
                self.lastViewingIndexpath = indexPath
                for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                    if self.compareDate(date1: collectionViewEPGLayout().dateForHourHeader(at: indexPath), date2: self.getFullDate("\(tabObj.startTime)")){
                        if !AppDelegate.getDelegate().isScrollToTop {
                            AppDelegate.getDelegate().tvGuideTabSelected = index
                            if self.compareDate(date1: presentViewingDate, date2: tabPresentViewingDate) {
                                AppDelegate.getDelegate().tvGuideSelectedTabDate = presentViewingDate
                            }
                            else {
                                AppDelegate.getDelegate().tvGuideSelectedTabDate = tabPresentViewingDate
                            }
                            for tabObj_ in AppDelegate.getDelegate().alreadyLoadedTabDataArr {
                                if tabObj_.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue {
                                    AppDelegate.getDelegate().presentShowingDateTab = tabObj_
                                }
                            }
                        }
                        break;
                    }
                }
                if AppDelegate.getDelegate().tvGuideSelectedTabDate != nil && (self.compareDate(date1: presentViewingDate, date2: AppDelegate.getDelegate().tvGuideSelectedTabDate)) && self.dayDifference(from: presentViewingDate) == "Today" && self.dayDifference(from: tabPresentViewingDate) == "Today"{
                    if self.nowLiveIndicatorView != nil{
                        self.nowLiveIndicatorView.isHidden = false
                    }
                    if self.liveProgramsView != nil {
                        self.liveProgramsView.isHidden = false
                    }
                }
                else {
                    if self.dayDifference(from: AppDelegate.getDelegate().tvGuideSelectedTabDate) == "Today" {
//                        self.goLiveBtnClicked()
                        if self.nowLiveIndicatorView != nil{
                            self.nowLiveIndicatorView.isHidden = false
                        }
                        if self.liveProgramsView != nil {
                            self.liveProgramsView.isHidden = false
                        }
                    }
                    else {
                        let tabDateObj = self.tvGuideDateArr[AppDelegate.getDelegate().tvGuideTabSelected]
                        if tabDateObj.isSelected && self.dayDifference(from: self.getFullDate("\(tabDateObj.startTime)")) == "Today" {
                            if self.nowLiveFrame != nil {
                                self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                            else {
                                self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143
                                self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                            }
                            var subViewsArr = (self.collectionView?.subviews)!
                            for subView in subViewsArr {
                                if subView.tag == 02 || subView.tag == 14 {
                                    subView.removeFromSuperview()
                                }
                            }
                            subViewsArr = (self.collectionView?.subviews)!
                            for (index, subView) in subViewsArr.enumerated() {
                                subView.removeFromSuperview()
                                if index == 0 {
                                    self.liveProgramsView.tag = 02
                                    self.collectionView?.addSubview(self.liveProgramsView)
                                    self.collectionView?.addSubview(subView)
                                }
                                else {
                                    self.collectionView?.addSubview(subView)
                                }
                            }
                            self.nowLiveIndicatorView.tag = 14
                            self.collectionView?.addSubview(self.nowLiveIndicatorView)

                            if self.nowLiveIndicatorView != nil{
                                self.nowLiveIndicatorView.isHidden = false
                            }
                            if self.liveProgramsView != nil {
                                self.liveProgramsView.isHidden = false
                            }
                            self.donotShowNowLiveIndicator = false
                        } else {
                            if self.nowLiveIndicatorView != nil{
                                self.nowLiveIndicatorView.isHidden = true
                            }
                            if self.liveProgramsView != nil {
                                self.liveProgramsView.isHidden = true
                            }
                        }
                    }
                }
            }
        }
        else if elementKind == INSEPGLayoutElementKindSectionHeader {
            if indexPath.section == self.tvGuideDataArr.count - 1 && !self.noMorePaginationData{
                AppDelegate.getDelegate().pageNumber = AppDelegate.getDelegate().pageNumber + 1
                self.getPaginationData()
            }
        }
    }
    
    fileprivate func gotoNextPage(_ card: Card, path : String, content : Any?, templateElement : TemplateElement?) {
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            //self.stopAnimating()
            AppAnalytics.navigatingFrom = "search"
            if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.partialRenderingViewDelegate = self
                vc.contentObj = content
                vc.defaultPlayingItemUrl = card.display.imageUrl
                vc.playingItemTitle = card.display.title
                vc.playingItemSubTitle = card.display.subtitle1
                vc.playingItemTargetPath = path
                vc.currentVideoContent = card
                vc.templateElement = templateElement
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if viewController is DefaultViewController {
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Content you are looking for is not available".localized)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = card.display.title
                vc.isCircularPoster = card.cardType == .circle_poster ? true : false
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
    
    func didSelectedSuggestion(card: Card) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        //self.startAnimating(allowInteraction: false)
        var userID = OTTSdk.preferenceManager.user?.email
        if userID != nil && (userID? .isEmpty)! {
            userID = OTTSdk.preferenceManager.user?.phoneNumber
        }
        else {
            userID = "NA"
        }
        gotoNextPage(card, path: card.target.path, content: nil, templateElement: nil)
    }
    
    func convertUTCToLocal(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let timeUTC = dateFormatter.date(from: timeString)
        
        if timeUTC != nil {
            dateFormatter.timeZone = NSTimeZone.local
            
            let localTime = dateFormatter.string(from: timeUTC!)
            return localTime
        }
        
        return nil
    }
    
    func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // Your date format
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let localTime = dateFormatter.string(from: serverDate)
        return dateFormatter.date(from: localTime)!
    }
    
    //    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    //        collectionViewEPGLayout().invalidateLayoutCache()
    //        collectionView?.reloadData()
    //    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x != self.oldContentOffset.x)
        {
            scrollView.isPagingEnabled = false;
            scrollView.contentOffset = CGPoint.init(x: scrollView.contentOffset.x, y: (self.oldContentOffset.y))
        }
        else
        {
            scrollView.isPagingEnabled = false;
        }

        if (self.lastContentOffset > scrollView.contentOffset.y) || (self.lastContentOffset < scrollView.contentOffset.y)
        {
            self.nowLiveIndicatorView.frame.origin.y = scrollView.contentOffset.y + 34.0
        }
//        if currentOrientation().portrait && self.nowLiveIndicatorView != nil && ((!isVisible(view: self.nowLiveIndicatorView) || self.nowLiveIndicatorView.isHidden)) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnableGoLiveBtn"), object: nil)
//        }
//        else {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
//        }
        self.lastContentOffset = scrollView.contentOffset.y
        
        let scrollViewWidth = scrollView.frame.size.width
        let scrollContentSizeWidth = scrollView.contentSize.width
        self.scrollViewContentSize = scrollView.contentSize.width
        let scrollOffset = scrollView.contentOffset.x
        
//        if (scrollOffset + scrollViewWidth) == scrollContentSizeWidth ||  (scrollContentSizeWidth - (scrollOffset + scrollViewWidth)) <= 100.0{
//            for (index, tabDateObj) in self.tvGuideDateArr.enumerated() {
//                if !self.checkDataAvailableForDate(tabDateObj.startTime) {
//                    AppDelegate.getDelegate().tvGuideTabSelected = index
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
//                    break;
//                }
//            }
//        }
        
        if  scrollView is UICollectionView {
            let threshold:CGFloat = 100.0 ;
            let contentOffset:CGFloat = scrollView.contentOffset.x;
            let maximumOffset:CGFloat = scrollView.contentSize.width - scrollView.frame.size.width;
            if ((maximumOffset - contentOffset <= threshold) && (maximumOffset - contentOffset != -5.0) && !self.isFilterDataLoading){
                for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                    if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue && self.goGetTheData {
                        self.lastViewingDateToBeScrolled = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue)")
                        var tabIndex = index
                        if tabIndex != AppDelegate.getDelegate().tvGuideTabSelected {
                            tabIndex = AppDelegate.getDelegate().tvGuideTabSelected - 1
                            if tabIndex >= 0 {
                                self.lastViewingDateToBeScrolled = self.getFullDate("\(self.tvGuideDateArr[tabIndex].startTime.intValue)")
                            }
                        }
                        if tabIndex + 1 < self.tvGuideDateArr.count {
                            AppDelegate.getDelegate().presentShowingDateTab = self.tvGuideDateArr[tabIndex + 1]
                        }
                        else {
                            AppDelegate.getDelegate().presentShowingDateTab = self.tvGuideDateArr[tabIndex]
                        }
                        var skipGettingData = false
                        for tabObj_ in AppDelegate.getDelegate().alreadyLoadedTabDataArr {
                            if tabObj_.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue {
                                skipGettingData = true
                                break;
                            }
                        }
                        if AppDelegate.getDelegate().alreadyLoadedTabDataArr.count == 0 {
                            skipGettingData = true
                        }
                        AppDelegate.getDelegate().isScrollToTop = false
                        if !skipGettingData && self.goGetTheData {
                            self.getTabData(addFront: false, startTime: AppDelegate.getDelegate().presentShowingDateTab.startTime, endTime: AppDelegate.getDelegate().presentShowingDateTab.endTime)
                            break;
                        }
                    }
                }
            }
            else if contentOffset == 0.0 {
                for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                    if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue {
                        self.lastViewingDateToBeScrolled = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue)")
                        var tabIndex = index
                        if tabIndex != AppDelegate.getDelegate().tvGuideTabSelected {
                            tabIndex = AppDelegate.getDelegate().tvGuideTabSelected + 1
                            if self.tvGuideDateArr.indices.contains(tabIndex) {
                            self.lastViewingDateToBeScrolled = self.getFullDate("\(self.tvGuideDateArr[tabIndex].startTime.intValue)")
                            }
                        }
                        if tabIndex != 0 {
                            AppDelegate.getDelegate().presentShowingDateTab = self.tvGuideDateArr[tabIndex - 1]
                        }
                        else {
                            AppDelegate.getDelegate().presentShowingDateTab = self.tvGuideDateArr[tabIndex]
                        }
                        var skipGettingData = false
                        for tabObj_ in AppDelegate.getDelegate().alreadyLoadedTabDataArr {
                            if tabObj_.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue {
                                skipGettingData = true
                                break;
                            }
                        }
                        if AppDelegate.getDelegate().alreadyLoadedTabDataArr.count == 0 {
                            skipGettingData = true
                        }
                        if !skipGettingData && self.goGetTheData {
                            self.getTabData(addFront: true, startTime: AppDelegate.getDelegate().presentShowingDateTab.startTime, endTime: AppDelegate.getDelegate().presentShowingDateTab.endTime)
                            break;
                        }
                    }
                }
            }
        }
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.oldContentOffset = scrollView.contentOffset
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.oldContentOffset = scrollView.contentOffset
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let scrollViewWidth = scrollView.frame.size.width
        let scrollContentSizeWidth = scrollView.contentSize.width
        let scrollOffset = scrollView.contentOffset.x
        
        if (scrollOffset + scrollViewWidth) == scrollContentSizeWidth ||  (scrollContentSizeWidth - (scrollOffset + scrollViewWidth)) <= 100.0{
            //            print("reached total right")
            //            for (index, tabDateObj) in self.tvGuideDateArr.enumerated() {
            //                if !self.checkDataAvailableForDate("\(tabDateObj.startTime)") {
            //                    AppDelegate.getDelegate().tvGuideTabSelected = index
            //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
            //                    break;
            //                }
            //            }
        }
        else if (scrollOffset + scrollViewWidth) == scrollContentSizeWidth ||  ((scrollOffset + scrollViewWidth) - scrollContentSizeWidth) <= 100.0 {
            //            print("reached total left")
        }
        
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let scrollContentSizeWidth = scrollView.contentSize.width
        let scrollOffset = scrollView.contentOffset.x
        
        if (scrollOffset + scrollViewWidth) == scrollContentSizeWidth ||  (scrollContentSizeWidth - (scrollOffset + scrollViewWidth)) <= 100.0{
            //            for (index, tabDateObj) in self.tvGuideDateArr.enumerated() {
            //                if !self.checkDataAvailableForDate("\(tabDateObj.startTime)") {
            //                    AppDelegate.getDelegate().tvGuideTabSelected = index
            //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
            //                    break;
            //                }
            //            }
        }
        for tabObj in self.tvGuideDateArr {
            if AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue == tabObj.startTime.intValue && tabObj.isSelected {
                self.goLiveBtnClicked()
                break;
            }
        }
    }
    
    func getFullDate(_ timestamp:String) -> Date {
        let time = (timestamp as NSString).doubleValue/1000
//        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        //        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let localTime = dateFormatter.string(from: date)
        let dateFormatter_ = DateFormatter()
        dateFormatter_.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter_.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter_.timeZone = .current
        return dateFormatter_.date(from: localTime)!
    }
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Your date format
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let localTime = dateFormatter.string(from: date2)
        
        let order = Calendar.current.compare(date1, to: dateFormatter.date(from: localTime)!, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func compareDateWithHour(date1:Date, date2:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Your date format
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let localTime = dateFormatter.string(from: date2)
        
        let order = Calendar.current.compare(date1, to: dateFormatter.date(from: localTime)!, toGranularity: .hour)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func isVisible(view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
    
    func dayDifference(from date : Date) -> String
    {
        let calendar = NSCalendar.current
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
    
    @objc func channelBtnClicked(_ notification:NSNotification) {
        return;
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        if self.tvGuideDataArr.count > 0 {
            if let channelIndex = notification.userInfo!["channelIndex"] as? NSNumber {
                let channelObj = self.tvGuideDataArr[channelIndex.intValue]
                //self.startAnimating(allowInteraction: false)
                TargetPage.getTargetPageObject(path: channelObj.target.path) { (viewController, pageType) in
                    //self.stopAnimating()
                    if let vc = viewController as? PlayerViewController{
                        vc.delegate = self
                        vc.defaultPlayingItemUrl = channelObj.display.imageUrl
                        vc.playingItemTitle = channelObj.display.title
                        vc.playingItemSubTitle = channelObj.display.subtitle1
                        vc.playingItemTargetPath = channelObj.target.path
                        AppDelegate.getDelegate().window?.addSubview(vc.view)
                    }
                    else if viewController is DefaultViewController {
                        if !Utilities.hasConnectivity() {
                            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                            return
                        }
                        AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Content you are looking for is not available".localized)
                    }
                    else if let vc = viewController as? DetailsViewController {
                        vc.navigationTitlteTxt = channelObj.display.title
                        let topVC = UIApplication.topVC()!
                        AppDelegate.getDelegate().detailsTabMenuIndex = 0
                        topVC.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        let topVC = UIApplication.topVC()!
                        AppDelegate.getDelegate().detailsTabMenuIndex = 0
                        topVC.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func scrollCollectionViewToEnd() {
        self.collectionView?.setContentOffset(CGPoint.init(x: (self.scrollViewContentSize - 100.0), y: 0.0), animated: true)
    }
    
    @objc func checkAndGetData() {
        var presentShowingTabIndex = 0
        for (index, tabObj) in self.tvGuideDateArr.enumerated() {
            if AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue == tabObj.startTime.intValue {
                presentShowingTabIndex = index
                break;
            }
        }
        for (index, tabObj) in self.tvGuideDateArr.enumerated() {
            if AppDelegate.getDelegate().tvGuideTabSelected == index {
                AppDelegate.getDelegate().presentShowingDateTab = tabObj
                self.lastViewingDateToBeScrolled = self.getFullDate("\(AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue)")
                break;
            }
        }
        if !self.checkDataAvailableForDate(AppDelegate.getDelegate().presentShowingDateTab.startTime) {
            if (AppDelegate.getDelegate().tvGuideTabSelected - presentShowingTabIndex) < 0 {
                
                var startTime:NSNumber?
                var endTime:NSNumber?
                for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                    if (index == AppDelegate.getDelegate().tvGuideTabSelected) {
                        startTime = tabObj.startTime
                    }
                    else if index == presentShowingTabIndex - 1 {
                        endTime = tabObj.endTime
                        break;
                    }
                }
                
                self.getTabData(addFront: true, startTime: startTime, endTime: endTime)
            }
            else {
                
                var startTime:NSNumber?
                var endTime:NSNumber?
                for (index, tabObj) in self.tvGuideDateArr.enumerated() {
                    if (index == presentShowingTabIndex + 1) {
                        startTime = tabObj.startTime
                    }
                    else if index == AppDelegate.getDelegate().tvGuideTabSelected {
                        endTime = tabObj.endTime
                        break;
                    }
                }
                
                self.getTabData(addFront: false, startTime: startTime, endTime: endTime)
            }
        }
        else {
            self.scrollToSelectedDate()
        }
    }
    
    func getPaginationData() {
        return;
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            //self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
        OTTSdk.mediaCatalogManager.getProgramForChannels(channel_ids: self.channelIdsStr, start_time: AppDelegate.getDelegate().presentShowingDateTab!.startTime.stringValue, end_time: AppDelegate.getDelegate().presentShowingDateTab!.endTime.stringValue, time_zone: nil, onSuccess: { (programResponse) in
            var tempTVGuideDataArr = [ChannelObj]()
            for channel in self.tvGuideDataArr {
                let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
                let filteredarr = programResponse.filter { predicate.evaluate(with: $0) };
                if filteredarr.count > 0 {
                    let dict = filteredarr[0]
                    channel.programs = dict.programs
                }
                tempTVGuideDataArr.append(channel)
            }
            self.tvGuideDataArr.removeAll()
            self.tvGuideDataArr.append(contentsOf: tempTVGuideDataArr)
            
            OTTSdk.mediaCatalogManager.getUserProgramForChannels(channel_ids: self.channelIdsStr, start_time: AppDelegate.getDelegate().presentShowingDateTab!.startTime.stringValue, end_time: AppDelegate.getDelegate().presentShowingDateTab!.endTime.stringValue, time_zone: nil, onSuccess: { (userProgramResponse) in
                var tempTVGuideDataArr = [ChannelObj]()
                for channel in self.tvGuideDataArr {
                    let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
                    let filteredarr = userProgramResponse.filter { predicate.evaluate(with: $0) };
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
                    tempTVGuideDataArr.append(channel)
                }
                self.tvGuideDataArr.removeAll()
                self.tvGuideDataArr.append(contentsOf: tempTVGuideDataArr)
                if self.tvGuideDataArr.count == 0 {
                    self.noMorePaginationData = true
                }
                else {
                    self.collectionViewEPGLayout().invalidateLayoutCache()
                    self.collectionViewEPGLayout().collectionView?.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
                        self.collectionViewEPGLayout().collectionView?.reloadData()
                    }
                    self.updateTheNowLiveViewFrame()
                    self.stopAnimating()
                }
            }) { (error) in
                print(error.message)
                self.stopAnimating()
            }
            
        }) { (error) in
            print(error.message)
            self.stopAnimating()
        }
    }
    
    func getTabData(addFront:Bool, startTime:NSNumber?, endTime:NSNumber?) {
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.goGetTheData = false
        self.appendPrograms(channelIDStr: self.channelIdsStr, startTime: startTime!.stringValue, endTime: endTime!.stringValue, isPaginationData: true, addFront: addFront, isRecordingFlow: false)
    }
    
    @objc func getDataWithFilter() {
        if AppDelegate.getDelegate().tvGuideFilterString?.count == 0 {
            AppDelegate.getDelegate().tvGuideFilterString = nil
        }

        self.isFilterDataLoading = true
        self.noMorePaginationData = false
        self.goGetTheData = false
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
//        self.lastViewingDateToBeScrolled = nil
        self.appendPrograms(channelIDStr: self.channelIdsStr, startTime: AppDelegate.getDelegate().presentShowingDateTab!.startTime.stringValue, endTime: AppDelegate.getDelegate().presentShowingDateTab!.endTime.stringValue, isPaginationData: false, addFront: false, isRecordingFlow: false)
    }
    
    func loadLiveData() {
        if AppDelegate.getDelegate().tvGuideFilterString?.count == 0 {
            AppDelegate.getDelegate().tvGuideFilterString = nil
        }
        //self.collectionViewEPGLayout().collectionView?.setContentOffset(CGPoint.zero, animated: false)
        
        self.isFilterDataLoading = true
        self.noMorePaginationData = false
        //self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            //self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        var pageNum = AppDelegate.getDelegate().pageNumber
        let pageSize = (AppDelegate.getDelegate().pageSize * (pageNum + 1))
        pageNum = 0
        
        OTTSdk.mediaCatalogManager.getProgramForChannels(channel_ids: self.channelIdsStr, start_time: AppDelegate.getDelegate().presentShowingDateTab!.startTime.stringValue, end_time: AppDelegate.getDelegate().presentShowingDateTab!.endTime.stringValue, time_zone: nil, onSuccess: { (programResponse) in
            var tempTVGuideDataArr = [ChannelObj]()
            for channel in self.tvGuideDataArr {
                let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
                let filteredarr = programResponse.filter { predicate.evaluate(with: $0) };
                if filteredarr.count > 0 {
                    let dict = filteredarr[0]
                    channel.programs = dict.programs
                }
                tempTVGuideDataArr.append(channel)
            }
            self.tvGuideDataArr.removeAll()
            self.tvGuideDataArr.append(contentsOf: tempTVGuideDataArr)
            
            OTTSdk.mediaCatalogManager.getUserProgramForChannels(channel_ids: self.channelIdsStr, start_time: AppDelegate.getDelegate().presentShowingDateTab!.startTime.stringValue, end_time: AppDelegate.getDelegate().presentShowingDateTab!.endTime.stringValue, time_zone: nil, onSuccess: { (userProgramResponse) in
                var tempTVGuideDataArr = [ChannelObj]()
                for channel in self.tvGuideDataArr {
                    let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
                    let filteredarr = userProgramResponse.filter { predicate.evaluate(with: $0) };
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
                    tempTVGuideDataArr.append(channel)
                }
                self.tvGuideDataArr.removeAll()
                self.tvGuideDataArr.append(contentsOf: tempTVGuideDataArr)
                if self.tvGuideDataArr.count > 0 {
                    AppDelegate.getDelegate().alreadyLoadedTabDataArr.append(AppDelegate.getDelegate().presentShowingDateTab)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
                    self.recordingCardsArr.removeAll()
                    AppDelegate.getDelegate().recordingCardsArr.removeAll()
                    self.recordingSeriesArr.removeAll()
                    AppDelegate.getDelegate().recordingSeriesArr.removeAll()
                    AppDelegate.getDelegate().getFullTVGuideData = false
                    //self.stopAnimating()
                    self.collectionViewEPGLayout().invalidateLayoutCache()
                    self.collectionViewEPGLayout().collectionView?.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                        self.collectionViewEPGLayout().scrollToCurrentTime(animated: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                            if self.nowLiveIndicatorView != nil && self.liveProgramsView != nil{
                                self.nowLiveIndicatorView.isHidden = false
                                self.liveProgramsView.isHidden = false
                                self.donotShowNowLiveIndicator = false
                                if productType.iPad {
                                    if currentOrientation().landscape {
                                        self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 490.0
                                    }else {
                                        self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 363.0
                                    }
                                    self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                    self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                    self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                    self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                                }
                                else {
                                    if self.nowLiveFrame != nil {
                                        self.nowLiveIndicatorView.frame.origin.x = self.nowLiveFrame.origin.x - 22.0
                                        self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                        self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                        self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                        self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                                    }
                                    else {
                                        self.nowLiveIndicatorView.frame.origin.x = (self.collectionView?.contentOffset.x)! + 143
                                        self.liveProgramsView.frame.origin.x = self.nowLiveIndicatorView.frame.origin.x + 34.0
                                        self.liveProgramsView.frame.size.width = (self.collectionView?.contentSize.width)!
                                        self.liveProgramsView.frame.size.height = (self.collectionView?.contentSize.height)!
                                        self.nowLiveViewXPosition = self.nowLiveIndicatorView.frame.origin.x
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DisableGoLiveBtn"), object: nil)
                                var subViewsArr = (self.collectionView?.subviews)!
                                for subView in subViewsArr {
                                    if subView.tag == 02 || subView.tag == 14 {
                                        subView.removeFromSuperview()
                                    }
                                }
                                subViewsArr = (self.collectionView?.subviews)!
                                for (index, subView) in subViewsArr.enumerated() {
                                    subView.removeFromSuperview()
                                    if index == 0 {
                                        self.liveProgramsView.tag = 02
                                        self.collectionView?.addSubview(self.liveProgramsView)
                                        self.collectionView?.addSubview(subView)
                                    }
                                    else {
                                        self.collectionView?.addSubview(subView)
                                    }
                                }
                                self.nowLiveIndicatorView.tag = 14
                                self.collectionView?.addSubview(self.nowLiveIndicatorView)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
                                    self.collectionViewEPGLayout().collectionView?.reloadData()
                                }
                            }
                            else {
                                //self.stopAnimating()
                            }
                        })
                        
                    }
                }
                else {
                    //self.stopAnimating()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorView"), object: nil)
                }
            }) { (error) in
                print(error.message)
                self.stopAnimating()
                AppDelegate.getDelegate().getFullTVGuideData = false
                self.goLiveBtnClicked()
            }
            
        }) { (error) in
            print(error.message)
            self.stopAnimating()
            AppDelegate.getDelegate().getFullTVGuideData = false
            self.goLiveBtnClicked()
        }
    }
    
    func appendPrograms(channelIDStr : String, startTime : String, endTime:String, isPaginationData:Bool , addFront:Bool, isRecordingFlow:Bool){
        let programsOperation = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            OTTSdk.mediaCatalogManager.getProgramForChannels(channel_ids: channelIDStr, start_time: startTime, end_time: endTime, time_zone: nil, onSuccess: { (programResponse) in
                self.programsDataArr = programResponse
                group.leave()
            }) { (error) in
                group.leave()
            }
            
            group.enter()
            OTTSdk.mediaCatalogManager.getUserProgramForChannels(channel_ids: channelIDStr, start_time: startTime, end_time: endTime, time_zone: nil, onSuccess: { (userProgramResponse) in
                self.userProgramsDataArr = userProgramResponse
                group.leave()
            }) { (error) in
                group.leave()
            }
            group.notify(queue: .main) {
                if isPaginationData {
                    self.formPaginationData(addFront: addFront)
                }
                else if isRecordingFlow {
                    self.formRecordingFlowData()
                }
                else {
                    self.formGuideData()
                }
            }
        }
        programsOperation.start()
    }

    func formGuideData() {
        var tempProgramDataArr = [ChannelObj]()
        for channel in self.tvGuideDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
            let filteredarr = self.programsDataArr.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let dict = filteredarr[0]
                channel.programs = dict.programs
            }
            tempProgramDataArr.append(channel)
        }
        self.tvGuideDataArr.removeAll()
        self.tvGuideDataArr.append(contentsOf: tempProgramDataArr)
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

        if self.tvGuideDataArr.count > 0 {
            
            if !self.checkIsDataAvailableForAllChannels() {
                AppDelegate.getDelegate().alreadyLoadedTabDataArr.append(AppDelegate.getDelegate().presentShowingDateTab)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
                self.recordingCardsArr.removeAll()
                AppDelegate.getDelegate().recordingCardsArr.removeAll()
                self.recordingSeriesArr.removeAll()
                AppDelegate.getDelegate().recordingSeriesArr.removeAll()
                AppDelegate.getDelegate().getFullTVGuideData = true
                self.stopAnimating()
                DispatchQueue.main.async {
                    if self.lastViewingDateToBeScrolled != nil {
                        var isToday:Bool = false
                        for tabObj in self.tvGuideDateArr {
                            if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue && tabObj.isSelected{
                                isToday = true
                                break;
                            }
                        }
                        if isToday {
                            self.goLiveBtnClicked()
                        }
                        else {
                            self.hideNowLiveView()
                            self.collectionViewEPGLayout().scrollToFilterTime(animated: false, selectedDate: AppDelegate.getDelegate().tvGuideSelectedTabDate)
                        }
                        DispatchQueue.main.async {
                            self.collectionViewEPGLayout().invalidateLayoutCache()
                            self.collectionViewEPGLayout().collectionView?.reloadData()
                        }
                        self.isFilterDataLoading = false
                        self.goGetTheData = true
                        AppDelegate.getDelegate().isScrollToTop = true
                    }
                    else {
                        var isToday:Bool = false
                        for tabObj in self.tvGuideDateArr {
                            if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue && tabObj.isSelected{
                                isToday = true
                                break;
                            }
                        }
                        if isToday {
                            self.goLiveBtnClicked()
                        }
                        else {
                            self.hideNowLiveView()
                        }
                        DispatchQueue.main.async {
                            self.collectionViewEPGLayout().invalidateLayoutCache()
                            self.collectionViewEPGLayout().collectionView?.reloadData()
                        }
                        self.isFilterDataLoading = false
                        self.goGetTheData = true
                        AppDelegate.getDelegate().isScrollToTop = true
                    }
                    self.collectionView.isHidden = false

                }
            } else {
                self.stopAnimating()
                self.goGetTheData = true
                self.collectionView.isHidden = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorView"), object: nil)
            }
        }
        else {
            self.stopAnimating()
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorView"), object: nil)
        }
    }
    
    func formPaginationData(addFront:Bool) {
        var totalTVGuideDataArr = [ChannelProgramsResponse]()
        for channel in self.programsDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channel.channelId)
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
            totalTVGuideDataArr.append(channel)
        }
        self.programsDataArr.removeAll()
        self.programsDataArr.append(contentsOf: totalTVGuideDataArr)
        var totalGuideData = [ChannelObj]()
        var scrollToIndex = 0
        for channel in self.tvGuideDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channel.channelID)
            let filteredarr = self.programsDataArr.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                let dict = filteredarr[0]
                if addFront {
                    channel.programs.insert(contentsOf: dict.programs, at: 0)
                    if (channel.programs.count - 1) > scrollToIndex {
                        scrollToIndex = channel.programs.count - 1
                    }
                } else {
                    channel.programs.insert(contentsOf: dict.programs, at: channel.programs.count != 0 ? (channel.programs.count - 1) : 0)
                }
            }
            print(channel.programs.count)
            totalGuideData.append(channel)
        }
        var totalTempChannels = [ChannelObj]()
        totalTempChannels = totalGuideData
        if self.tvGuideDataArr.count != totalGuideData.count {
            for tabOjct in self.tvGuideDataArr {
                var channelContains:Bool = false
                for tempTabObjct in  totalGuideData {
                    if tabOjct.channelID == tempTabObjct.channelID {
                        channelContains = true
                        break;
                    }
                }
                if !channelContains {
                    totalTempChannels.append(tabOjct)
                }
            }
        }
        self.tvGuideDataArr.removeAll()
        self.tvGuideDataArr.append(contentsOf: totalTempChannels)
        AppDelegate.getDelegate().getFullTVGuideData = false
        AppDelegate.getDelegate().alreadyLoadedTabDataArr.append(AppDelegate.getDelegate().presentShowingDateTab)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
            if self.lastViewingDateToBeScrolled != nil {
                if addFront {
                    self.collectionViewEPGLayout().scrollToLastTime(animated: false, selectedDate: self.lastViewingDateToBeScrolled)
                }
                self.stopAnimating()
                self.collectionViewEPGLayout().invalidateLayoutCache()
                self.collectionViewEPGLayout().collectionView?.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
                    self.collectionViewEPGLayout().invalidateLayoutCache()
                    self.collectionViewEPGLayout().collectionView?.reloadData()
                    self.collectionView.reloadData()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
                    self.hideNowLiveView()
                }
            }
        }
        self.goGetTheData = true

    }
    
    func formRecordingFlowData() {
        let tempProgramsDataArr = self.tvGuideDataArr
        
        for channelObj in self.tvGuideDataArr {
            let predicate = NSPredicate(format: "channelId == %d", channelObj.channelID)
            let filteredarr = self.programsDataArr.filter { predicate.evaluate(with: $0) };
            if filteredarr.count > 0 {
                channelObj.programs.removeAll()
                channelObj.programs.append(contentsOf: filteredarr[0].programs)
                break;
            }
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

        self.collectionViewEPGLayout().invalidateLayoutCache()
        self.collectionViewEPGLayout().collectionView?.reloadData()
        
    }
    
    @objc func getDataForSelectedTab() {
        if AppDelegate.getDelegate().tvGuideFilterString?.count == 0 {
            AppDelegate.getDelegate().tvGuideFilterString = nil
        }
        self.isFilterDataLoading = true
        //self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            //self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
        /*
         #TODO: - new APIs for TVGuide to be implemented
         
        OTTSdk.mediaCatalogManager.tvGuideContent(start_time: AppDelegate.getDelegate().presentShowingDateTab.startTime, end_time: AppDelegate.getDelegate().presentShowingDateTab.endTime, filter: AppDelegate.getDelegate().tvGuideFilterString, skip_tabs: 1, page: AppDelegate.getDelegate().pageNumber, pagesize: AppDelegate.getDelegate().pageSize, onSuccess: { (response) in
//            if response.data.count > 0 {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideErrorView"), object: nil)
            self.recordingCardsArr.removeAll()
            AppDelegate.getDelegate().recordingCardsArr.removeAll()
            self.recordingSeriesArr.removeAll()
            AppDelegate.getDelegate().recordingSeriesArr.removeAll()
                self.tvGuideDataArr = response.data
            AppDelegate.getDelegate().getFullTVGuideData = true
                //self.stopAnimating()
                self.collectionViewEPGLayout().invalidateLayoutCache()
                self.collectionViewEPGLayout().collectionView?.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(200)) {
                    //                    self.scrollToSelectedDate()
                    //                    self.collectionViewEPGLayout().collectionView?.reloadData()
                    if self.lastViewingDateToBeScrolled != nil {
                        var isToday:Bool = false
                        for tabObj in self.tvGuideDateArr {
                            if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue && tabObj.isSelected{
                                isToday = true
                                break;
                            }
                        }
                        if isToday {
                            self.goLiveBtnClicked()
                        }
                        else {
                            self.collectionViewEPGLayout().scrollToFilterTime(animated: false, selectedDate: AppDelegate.getDelegate().tvGuideSelectedTabDate)
                        }
                        self.collectionViewEPGLayout().collectionView?.reloadData()
                        self.isFilterDataLoading = false
                    }
                    else {
                        var isToday:Bool = false
                        for tabObj in self.tvGuideDateArr {
                            if tabObj.startTime.intValue == AppDelegate.getDelegate().presentShowingDateTab.startTime.intValue && tabObj.isSelected{
                                isToday = true
                                break;
                            }
                        }
                        if isToday {
                            self.goLiveBtnClicked()
                        }
                        self.collectionViewEPGLayout().collectionView?.reloadData()
                        self.isFilterDataLoading = false
                    }
                }
//            }
//            else {
//                self.stopAnimating()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorView"), object: nil)
//            }
        }) { (error) in
            //self.stopAnimating()
            print(error.message)
        }*/
    }

    func checkDataAvailableForDate(_ startTime:NSNumber) -> Bool {
        var dataStatus:Bool = false
        for channelObj in self.tvGuideDataArr {
            for programObj in channelObj.programs {
                if startTime.stringValue == programObj.target.pageAttributes.startTime || self.dayDifference(from: self.getFullDate(programObj.target.pageAttributes.startTime)) == "Today" {
                    dataStatus = true
                    break;
                }
            }
        }
        return dataStatus
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentShowCaseView(withText:String, forView:UIView) {
        showcase = MaterialShowcase()
        showcase.setTargetView(view: forView) // always required to set targetView
        showcase.backgroundPromptColor = UIColor.black.withAlphaComponent(0.5)
        showcase.backgroundPromptColorAlpha = 0.96
        showcase.setDefaultProperties()
        showcase.primaryText = withText
        showcase.secondaryText = ""
    }
    @objc func showShowCaseView() {
        if showcase != nil {
            showcase.show(completion: {
            })
        }
    }
    
    @objc func reloadPage() {
        self.getDataWithFilter()
    }
    // MARK: - TVGuide PopUP Delegate
    func tvGuideWatchNowClicked(programObj:Card) {
        
    }
    func tvGuideWatchNowClicked(programObj:Card, channel : ChannelObj) {
        if (programObj.template.count > 0) {
            PartialRenderingView.instance.reloadFor(card: programObj, content: channel, partialRenderingViewDelegate: self)
        }
        else {
            if popupViewController != nil {
                self.dismissPopupViewController(.bottomBottom)
            }
            if !Utilities.hasConnectivity() {
                AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                return
            }
            self.startAnimating(allowInteraction: false)
            TargetPage.getTargetPageObject(path: programObj.target.path) { (viewController, pageType) in
                if let vc = viewController as? PlayerViewController{
                    vc.delegate = self
                    vc.defaultPlayingItemUrl = programObj.display.imageUrl
                    vc.playingItemTitle = programObj.display.title
                    vc.playingItemSubTitle = programObj.display.subtitle1
                    vc.playingItemTargetPath = programObj.target.path
                    AppDelegate.getDelegate().window?.addSubview(vc.view)
                    self.stopAnimating()
                }
                else if viewController is DefaultViewController {
                    self.stopAnimating()
                    if !Utilities.hasConnectivity() {
                        AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                        return
                    }
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: "Content you are looking for is not available".localized)
                }
                else{
                    self.stopAnimating()
                    let topVC = UIApplication.topVC()!
                    AppDelegate.getDelegate().detailsTabMenuIndex = 0
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func tvGuideDescPopUpCancelled() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
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

       // self.startAnimating(allowInteraction: true)
        
//        OTTSdk.mediaCatalogManager.startStopRecord(content_type: content_type, content_id: content_id, action: "1", onSuccess: { (response) in
//            //self.stopAnimating()
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
//                self.getDataForSelectedTab()
//            }
//
//            self.collectionView?.reloadData()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
//            if self.popupViewController != nil {
//                self.dismissPopupViewController(.bottomBottom)
//            }
//        }) { (error) in
//            print(error.message)
//            //self.stopAnimating()
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

        //self.startAnimating(allowInteraction: true)
        
//        OTTSdk.mediaCatalogManager.startStopRecord(content_type: content_type, content_id: content_id, action: "0", onSuccess: { (response) in
//            //self.stopAnimating()
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
//                self.getDataForSelectedTab()
//            }
//
//            self.collectionView?.reloadData()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshRecordingsContent"), object: nil)
//            if self.popupViewController != nil {
//                self.dismissPopupViewController(.bottomBottom)
//            }
//        }) { (error) in
//            print(error.message)
//            //self.stopAnimating()
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
    
    //MARK: - PartialRenderingViewDelegate
    
    func didSelected(card : Card?, content : Any?, templateElement : TemplateElement? ){
        if card != nil && templateElement != nil{
            self.gotoNextPage(card!, path: templateElement!.target, content : content, templateElement: templateElement)
        }
    }
    
    func record(confirm : Bool, content : Any?){
        if confirm == true{
            if let _channelObj = content as? ChannelObj {
                let pageNum = 0// AppDelegate.getDelegate().pageNumber
                let pageSize = (AppDelegate.getDelegate().pageSize * (pageNum + 1))
                
                self.appendPrograms(channelIDStr: "\(_channelObj.channelID)", startTime: AppDelegate.getDelegate().presentShowingDateTab.startTime.stringValue, endTime: AppDelegate.getDelegate().presentShowingDateTab.endTime.stringValue, isPaginationData: false, addFront: false, isRecordingFlow: true)
            }
            else{
                self.getDataWithFilter()
            }
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
