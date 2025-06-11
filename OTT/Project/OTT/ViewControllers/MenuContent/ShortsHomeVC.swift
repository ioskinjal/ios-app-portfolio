//
//  HomeVC.swift
//  SampleTikTok
//
//  Created by Apalya on 19/04/22.
//

import UIKit
import OTTSdk
class ShortsHomeVC: UIViewController,shortsTableViewCellDelegate, PlayerViewControllerDelegate {
    
    
   
    
    struct CellID{
        static let videoPlayerTableCell  = "VideoPlayerTableCell"
    }
    var pageResponse : PageContentResponse!
    var targetPath = ""
    var cardsData = [Card]()
    var section:Section?
    var sectionTitle = ""
    var lastIndex = -1
    var isMuted = true
    @IBOutlet var shortsVideoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        shortsVideoTableView.backgroundColor = UIColor.clear
        tableNibRegister(view: shortsVideoTableView, cell: CellID.videoPlayerTableCell)
        // Do any additional setup after loading the view.
        getShortsData()
    }
    func getShortsData() {
        self.startAnimating(allowInteraction: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            OTTSdk.mediaCatalogManager.pageContent(path: self.targetPath, onSuccess: { (response) in
                self.pageResponse = response
                self.setResponseData()
                self.stopAnimating()
            }) { (error) in
                self.showAlertWithText(message: error.message)
                print(error.message)
                self.stopAnimating()
            }
        
        }
    }
    func setResponseData() {
        if pageResponse == nil {
            return
        }
        if pageResponse.data.count == 0{
            return
        }
        guard let _section = pageResponse.data[0].paneData as? Section else{
            return
        }
       
        cardsData = _section.sectionData.data
        sectionTitle = _section.sectionInfo.name
        self.lastIndex = _section.sectionData.lastIndex
        self.section = _section
        
        if cardsData.count > 0 {
//            self.showHideErrorView(true)
            self.shortsVideoTableView.reloadData()
        }
        
    }
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
        self.view.frame.size = size
        self.shortsVideoTableView.reloadData()
        }
    
    
    //Table NIB Register
    public func tableNibRegister(view : UITableView, cell : String){
        view.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
    }
    //MARK: - shorts delegates
    func playButtonTap(cardItem: Card) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.goToPage(cardItem, templateElement: nil)
    }
    fileprivate func goToPage(_ item: Card, templateElement: TemplateElement?) {
        var path = ""
        if templateElement != nil {
            path = templateElement!.target
        }
        else if item.target.pageAttributes != nil {
            if let _pageSubtype = item.target.pageAttributes!["pageSubtype"] as? String, _pageSubtype == "pdf" {
                gotoPdfPage(path: item.target.path,title:item.display.title)
                return
            }
            else{
                path = item.target.path
            }
        }
        else {
            path = item.target.path
        }
        gotoTargetedPathWith(path: path, cardItem: item, bannerItem: nil, templateElement: templateElement)
       
    }
    
    private func gotoTargetedPathWith(path : String, cardItem : Card?, bannerItem : Banner?,templateElement: TemplateElement?) {
        if let item = bannerItem, item.target.path == "packages" {
            self.showAlertWithText(message: AppDelegate.getDelegate().configs?.iosBuyMessage ?? "Payments are not available in iOS ...")
          
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
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(view1, animated: true)
            return
        }
        TargetPage.getTargetPageObject(path: path) { (viewController, pageType) in
            self.stopAnimating()
            var vc : UIViewController!
            if let tempController = viewController as? PlayerViewController {
                tempController.delegate = self
                if let item = cardItem {
                    tempController.defaultPlayingItemUrl = item.display.imageUrl
                    tempController.playingItemTitle = item.display.title
                    tempController.playingItemSubTitle = item.display.subtitle1
                    tempController.playingItemTargetPath = item.target.path
                    tempController.templateElement = templateElement
                }else if let item = bannerItem {
                    tempController.defaultPlayingItemUrl = item.imageUrl
                    tempController.playingItemTitle = item.title
                    tempController.playingItemSubTitle = item.subtitle
                    tempController.playingItemTargetPath = item.target.path
                }
                if templateElement != nil {
                    tempController.templateElement =  templateElement
                }
                AppDelegate.getDelegate().window?.addSubview(tempController.view)
            }else if let tempController = viewController as? ContentViewController {
                tempController.isToViewMore = true
                if let item = cardItem {
                    tempController.sectionTitle = item.display.title
                }else if let item = bannerItem {
                    tempController.sectionTitle = item.title
                }
                vc = tempController
            }else if let tempController = viewController as? DetailsViewController {
                if let item = cardItem {
                    tempController.navigationTitlteTxt = item.display.title
                    tempController.isCircularPoster = item.cardType == .circle_poster ? true : false
                }else if let item = bannerItem {
                    tempController.navigationTitlteTxt = item.title
                }
                vc = tempController
            }else if let tempController = viewController as? ListViewController {
                tempController.isToViewMore = true
                vc = tempController
            }else {
                vc = viewController
            }
            guard vc != nil else {return}
            guard let topVc = UIApplication.topVC() else {return}
            topVc.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func shareButtonTap(cardItem: Card,buttonSender: Any) {
        let title = cardItem.display.title
        //Set the link to share.
        var linkString = ""
        if AppDelegate.getDelegate().configs?.siteURL.last == "/" {
            linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")\(cardItem.target.path)"
        } else {
            linkString = "\(AppDelegate.getDelegate().configs?.siteURL ?? "")/\(cardItem.target.path)"
        }
        
        if let link = NSURL(string: linkString)
        {
//            self.isSharingFlowClicked = true
            let objectsToShare = [title,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            if  productType.iPad   {
                activityVC.excludedActivityTypes = []
                activityVC.popoverPresentationController?.sourceView = self.view
                let tempShareBtn:UIButton = buttonSender as! UIButton
                activityVC.popoverPresentationController?.sourceRect = tempShareBtn.frame
            }
//            self.stopAnimating1(#line)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func muteButtonTap(isMuted: Bool) {
        self.isMuted = isMuted
    }
    //MARK: - playerviewcontroller delegates
    func didSelectedSuggestion(card: Card) {
        
    }
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
}
extension ShortsHomeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.videoPlayerTableCell, for: indexPath) as! VideoPlayerTableCell
        cell.videoPlayerView.frame = cell.bounds
        cell.playerLayer?.frame = cell.bounds
        cell.videoPlayerView.layoutIfNeeded()
        cell.shortsCelldelegate = self
        let card = self.cardsData[indexPath.row]
        cell.configue(cardObject: card,isMuted:self.isMuted)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoPlayerTableCell else{ return }
        videoCell.playerLayer?.player?.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoCell.playerLayer!.player?.currentItem, queue: .main) { [weak videoCell]_ in
            guard let _ = videoCell else{ return }
            let indexcell = indexPath.row + 1
            if  indexcell < self.cardsData.count{
                tableView.scrollToRow(at: IndexPath(row: indexcell, section: 0), at: .bottom, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoPlayerTableCell else{ return }
        videoCell.playerLayer?.player?.pause()
    }
}
