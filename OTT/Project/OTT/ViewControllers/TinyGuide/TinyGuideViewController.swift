//
//  GuideViewController.swift
//  OTT
//
//  Created by YuppTV Ent on 10/10/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleMobileAds

class TinyGuideViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate,TinyGuideHeaderReusableViewProtocal,PlayerViewControllerDelegate,PartialRenderingViewDelegate,GADBannerViewDelegate {
    
    @IBOutlet weak var guideMainCollection: UICollectionView!
    var guideResponse : TVGuideResponse?
    
    @IBOutlet weak var noContentLbl: UILabel!
    
    @IBOutlet weak var collectionViewbottomConstarint: NSLayoutConstraint?
    @IBOutlet weak var adBannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerAdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 23.0/255.0, green: 25.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        noContentLbl.text = "No Epg found"
        self.noContentLbl.textColor = .white
        self.noContentLbl.textAlignment = .center
        noContentLbl.isHidden = true
        let layout = guideMainCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true

        guideMainCollection.register(UINib(nibName: TinyGuideHeaderReusableView.nibname, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TinyGuideHeaderReusableView.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerViewStatusChanged), name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        guideMainCollection.register(UINib(nibName: TinyGuideEpgCell.nibname, bundle: nil), forCellWithReuseIdentifier: TinyGuideEpgCell.identifier)
        
        guideMainCollection.delegate = self
        guideMainCollection.dataSource = self
        // Do any additional setup after loading the view.
        self.LoadGuideData()
        self.loadBannerAd()
        self.updateDocPlayerFrame()
    }
    var currentSelectedDate : TVGuideTab?
    var currentSelectedChannel : ChannelObj?
    
    @objc func playerViewStatusChanged() {
        if UIApplication.topVC() is TinyGuideViewController {
            self.updateDocPlayerFrame()
        }
    }
    func updateDocPlayerFrame() {
        if playerVC != nil {
            playerVC!.bannerAdFoundExceptPlayer = (self.adBannerViewHeightConstraint.constant == 0 ? false : true)
            if playerVC!.isMinimized {
                playerVC?.updateMinViewFrame()
            }
        }
    }
    func LoadGuideData() {
        self.noContentLbl.isHidden = true
        self.startAnimating(allowInteraction: true)
        
        OTTSdk.mediaCatalogManager.getTVGuideChannels(filter: "", skip_tabs: 0, time_zone: nil, onSuccess: { (response) in
            var chids = [String]()
            self.guideResponse = response
            for obj in self.guideResponse!.tabs{
                if obj.isSelected == true{
                    self.currentSelectedDate = obj
                    break
                }
            }
            
            for item in response.data{
                chids.append("\(item.channelID)")
            }
          let chidsArrayString = chids.joined(separator:",")
            self.currentSelectedChannel = response.data.first
            self.LoadChannelPrograms(channelID: chidsArrayString, selectedDate: self.currentSelectedDate!)
            
            print(response)
        }) { (error) in
            self.stopAnimating()
            print(error.description)
        }
    }
    var channelPrograms = [Program]()
    
    func LoadChannelPrograms(channelID : String,selectedDate : TVGuideTab ) {
        self.noContentLbl.isHidden = true
        self.startAnimating(allowInteraction: true)
        OTTSdk.mediaCatalogManager.tvGuideContent(start_time: selectedDate.startTime, end_time: selectedDate.endTime, filter: nil, skip_tabs: 1, page: 0, pagesize: 20, channel_ids: channelID, onSuccess: { (response) in

            self.stopAnimating()
            if response.data.count > 0{
                self.channelPrograms = response.data.first!.programs
                if self.channelPrograms.count == 0 {
                    self.noContentLbl.isHidden = false
                }
                self.guideMainCollection.reloadData()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            
                    let currentTimeStamp = NSDate.init().timeIntervalSince1970 * 1000
                    if TimeInterval(truncating: selectedDate.startTime) <= currentTimeStamp && currentTimeStamp < TimeInterval(truncating: selectedDate.endTime) {
                        for (index,programItem) in self.channelPrograms.enumerated() {
                            
                            var programStartTime = 0
                            var programEndTime = 0
                            
                            if let startTime = Int(programItem.target.pageAttributes.startTime)  {
                                programStartTime = Int(truncating: NSNumber(value:startTime))
                            }
                            if let endTime = Int(programItem.target.pageAttributes.endTime) {
                                programEndTime = Int(truncating: NSNumber(value:endTime))
                            }
                            
                            if programStartTime <= Int(currentTimeStamp) && Int(currentTimeStamp) < programEndTime {
                                let liveProgramIndex = (index <= 2 ? index : index - 2)
                                self.guideMainCollection.layoutIfNeeded()
                                self.guideMainCollection.scrollToItem(at: IndexPath(item: liveProgramIndex, section: 0), at: .top, animated: true)
                                break;
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error)
            self.noContentLbl.isHidden = false
            self.stopAnimating()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
     //MARK: -  PlayerViewControllerDelegate
     func didSelectedSuggestion(card: Card) {
         
     }
     
     func didSelectedOfflineSuggestion(stream: Stream) {
         
     }
    //MARK: - GuideHeaderReusableViewProtocal methods
    func didSelectedChannelItem(item: ChannelObj) {
        let chid = "\(item.channelID)"
        self.currentSelectedChannel = item
        self.LoadChannelPrograms(channelID: chid, selectedDate: self.currentSelectedDate!)
    }
    
    func didSelectedDateItem(item: TVGuideTab) {
        
        let chid = "\(self.currentSelectedChannel!.channelID)"
        self.currentSelectedDate = item
        self.LoadChannelPrograms(channelID: chid, selectedDate: self.currentSelectedDate!)
    }
    func getFullDate(_ timestamp:String) -> Date {
        let time = (timestamp as NSString).doubleValue/1000
        //        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let date:Foundation.Date = Foundation.Date(timeIntervalSince1970: TimeInterval(time))
        return date
    }
 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.guideResponse != nil ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.channelPrograms.count > 0 ? self.channelPrograms.count : 0)
       }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let obj = self.channelPrograms[indexPath.item]
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: TinyGuideEpgCell.identifier as String, for: indexPath) as! TinyGuideEpgCell
        
        cell1.titleLbl.text = obj.display.title
        cell1.subtitleLbl.text = obj.display.subtitle1
        cell1.programImageView.sd_setImage(with: URL(string: obj.display.imageUrl), placeholderImage: UIImage.init(named: "Default-TVShows"))
        
        let startTimeStr = obj.target.pageAttributes.startTime
        let endTimeStr = obj.target.pageAttributes.endTime
        
        let stdatee = Date().getFullDateWithFormatter(startTimeStr, inFormat: "hh:mm a")
        let string2 = Date().getFullDateWithFormatter(endTimeStr, inFormat: "hh:mm a")
        
        cell1.subtitleLbl2.text = "\(stdatee) - \(string2)"
        
        if (self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(startTimeStr)) == .orderedDescending) && (self.getFullDate("\(Date().getCurrentTimeStamp())").compare(self.getFullDate(endTimeStr)) == .orderedAscending) {
            
            cell1.backgroundColor = UIColor.guideProgramLiveSelected
            cell1.titleLbl.textColor = UIColor.init(red: 54.0/255.0, green:  55.0/255.0 , blue:  55.0/255.0, alpha: 1.0)
            cell1.subtitleLbl.textColor = UIColor.init(red: 54.0/255.0, green:  55.0/255.0 , blue:  55.0/255.0, alpha: 1.0)
            cell1.subtitleLbl2.textColor = UIColor.init(red: 158.0/255.0, green:  161.0/255.0 , blue:  170.0/255.0, alpha: 1.0)
            cell1.liveLbl.isHidden = false
            
        }else{
            cell1.liveLbl.isHidden = true
            cell1.backgroundColor = UIColor.guideProgramUnselected
            cell1.titleLbl.textColor = UIColor.init(red: 189.0/255.0, green:  193.0/255.0 , blue:  204.0/255.0, alpha: 1.0)
            cell1.subtitleLbl.textColor = UIColor.init(red: 158.0/255.0, green:  161.0/255.0 , blue:  170.0/255.0, alpha: 1.0)
            cell1.subtitleLbl2.textColor = UIColor.init(red: 158.0/255.0, green:  161.0/255.0 , blue:  170.0/255.0, alpha: 1.0)
        }
        cell1.timerView.backgroundColor = UIColor.init(red: 32.0/255.0, green:  33.0/255.0 , blue:  36.0/255.0, alpha: 1.0)
        return cell1
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: view.frame.width, height: 100)
        }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TinyGuideHeaderReusableView.identifier, for: indexPath) as! TinyGuideHeaderReusableView
        header.delegate = self
        header.SelectedCurrentDate = self.currentSelectedDate
        header.SelectedcurrentChannel = self.currentSelectedChannel
        header.setUpData(data : self.guideResponse!)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if productType.iPad {
            return CGSize(width: view.frame.width, height: 70)
        }
        else {
            return CGSize(width: view.frame.width, height: 70)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.startAnimating(allowInteraction: false)
        let item = self.channelPrograms[indexPath.item]
        
        if item.template.count > 0{
            
            let card = Card()
            card.cardType = .overlay_poster
            card.display.imageUrl = item.display.imageUrl
            card.display.title = item.display.title
            card.display.subtitle1 = item.display.subtitle1
            card.display.subtitle2 = item.display.subtitle2
            card.display.isRecording = item.target.pageAttributes.isRecorded
            card.metadata.id = item.metadata.id
            card.target.path = item.target.path
            card.template = item.template
            var cardAttributes = [String:Any]()
            cardAttributes["recordingForm"] = item.target.pageAttributes.recordingForm
            card.target.pageAttributes = cardAttributes
            
            if self.currentSelectedChannel != nil {
                self.tvGuideWatchNowClicked(programObj: card, channel: self.currentSelectedChannel!)
            }
            self.stopAnimating()
            return;
        }
        else {
            
            TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
                if let _ = viewController as? ContentViewController{
                }
                else if let vc = viewController as? PlayerViewController{
                    vc.delegate = self
                    vc.defaultPlayingItemUrl = item.display.imageUrl
                    AppDelegate.getDelegate().window?.addSubview(vc.view)
                }
                else{
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                    self.stopAnimating()
                }
            }
        }
    }
    func tvGuideWatchNowClicked(programObj:Card, channel : ChannelObj) {
        PartialRenderingView.instance.reloadFor(card: programObj, content: channel, partialRenderingViewDelegate: self)
        return;
    }
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        if card != nil && templateElement != nil{
            self.goToPage(card!, templateElement: templateElement)
        }
    }
    func record(confirm : Bool, content : Any?) {
        
    }
    fileprivate func goToPage(_ item: Card, templateElement: TemplateElement?) {
        
        TargetPage.getTargetPageObject(path: item.target.path) { (viewController, pageType) in
            if let _ = viewController as? ContentViewController{
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                vc.defaultPlayingItemUrl = item.display.imageUrl
                vc.templateElement = templateElement
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else{
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
                self.stopAnimating()
            }
        }
        
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
}
