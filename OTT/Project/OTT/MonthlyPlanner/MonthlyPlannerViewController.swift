//
//  MonthlyPlannerViewController.swift
//  OTT
//
//  Created by YuppTV Ent on 19/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

protocol collectionCell_delegate {
    func didPressed(collectionViewIndexPath:IndexPath, tableViewIndexPath:IndexPath)
    func moveToNextCell(selectedItem: CGFloat)
    func moveToPreviousCell(selectedItem: CGFloat)
}

class MonthlyPlannerViewController: UIViewController, collectionCell_delegate,PartialRenderingViewDelegate, PlayerViewControllerDelegate {
    
    
    
    
    
    var plannerResponse: PlannerResponse?
    var arrayCard: Card?
    var arraySeason: SeasonInfo?
    
    var monthsArray: [MonthsData]?
    
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var arrowViewTransparentBtn: UIButton!
    @IBOutlet weak var gridCollectionView: UICollectionView! {
        didSet {
            gridCollectionView.bounces = false
        }
    }
    @IBOutlet weak var arrowView: UIView!
    
    @IBOutlet weak var monthSelectionView: UIView!
    @IBOutlet weak var lblSelectedWeek: UILabel!
    @IBOutlet weak var gridLayout: GridCollectionViewLayout! {
        didSet {
            
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 1
        }
    }
    
    
    @IBOutlet weak var scrollIconsBgView: UIView!
    @IBOutlet weak var leftScrollButton: UIButton!
    @IBOutlet weak var rightScrollButton: UIButton!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: gridCollectionView.contentOffset, size: gridCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = gridCollectionView.indexPathForItem(at: visiblePoint)
       //print("visibleIndexPath:\(visibleIndexPath)")
        
        if visibleIndexPath != nil {
            if visibleIndexPath!.row == 1 {
                self.leftScrollButton.isHidden = true
                self.rightScrollButton.isHidden = false
            }
            else if visibleIndexPath!.row == 2 {
                self.leftScrollButton.isHidden = false
                self.rightScrollButton.isHidden = false
            }
            else if visibleIndexPath!.row == 3 {
                self.leftScrollButton.isHidden = false
                self.rightScrollButton.isHidden = true
            }
        }
        
    }
   
    
    @IBAction func leftScrollButtonClicked(sender: AnyObject) {
       
    }
    @IBAction func rightScrollButtonClicked(sender: AnyObject) {
 
       
        
    }
    @IBAction func arrowBtnClicked(sender: AnyObject)
    {
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: "", message: "Select Month/Week", preferredStyle: alertStyle)
        
        for dic in monthsArray!{
            alert.addAction(UIAlertAction(title: dic.key, style: .default, handler: { [self] (UIAlertAction) in
                getMonthlyData(path: dic.value)
                lblSelectedWeek.text = dic.key
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        scrollIconsBgView.backgroundColor = .clear
        leftScrollButton.setTitle("", for: .normal)
        leftScrollButton.setTitle("", for: .highlighted)
        leftScrollButton.setTitle("", for: .selected)
        
        rightScrollButton.setTitle("", for: .normal)
        rightScrollButton.setTitle("", for: .highlighted)
        rightScrollButton.setTitle("", for: .selected)
        
        self.leftScrollButton.isUserInteractionEnabled = false
        self.rightScrollButton.isUserInteractionEnabled = false
        self.scrollIconsBgView.isUserInteractionEnabled = false
        self.leftScrollButton.isHidden = true
        self.rightScrollButton.isHidden = true
        
        let leftSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
        leftSwipeGest.direction = .left
        leftSwipeGest.delegate = self
        self.view.addGestureRecognizer(leftSwipeGest)
        
        let rightSwipeGest = UISwipeGestureRecognizer(target: self, action: #selector(funcForGesture))
        rightSwipeGest.direction = .right
        rightSwipeGest.delegate = self
        self.view.addGestureRecognizer(rightSwipeGest)
        
        getMonths()
        MonthlyCollectionViewCell.registerToCollectionView(collectionView: gridCollectionView)
        HeaderCollectionViewCell.registerToCollectionView(collectionView: gridCollectionView)
        ComingUPCollectionViewCell.registerToCollectionView(collectionView: gridCollectionView)
//        getMonthlyData(path: "oct2022")
        arrowView.layer.borderWidth = 1.0
        arrowView.layer.borderColor = AppTheme.instance.currentTheme.lineColor.cgColor
        arrowView.layer.cornerRadius = 5.0
        lblSelectedWeek.font = UIFont.ottRegularFont(withSize: 12)
        arrowBtn.setTitle("", for: .normal)
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        monthSelectionView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.arrowViewTransparentBtn.setTitle("", for: .normal)
        self.arrowViewTransparentBtn.setTitle("", for: .highlighted)
        self.arrowViewTransparentBtn.setTitle("", for: .selected)
    }
    func getMonths(){
        
        OTTSdk.mediaCatalogManager.monthsList(path: "monthly_planner_months", onSuccess: { (response) in
            
            
            self.monthsArray = response.monthsData
            
            if self.monthsArray?.count ?? 0 > 0 {
                var tempIndex = -1
                for (index,item) in self.monthsArray!.enumerated() {
                    if item.params.isDefault == true {
                        tempIndex = index
                        break;
                    }
                }
                
                if tempIndex == -1 {
                    tempIndex = 0
                }
                
                if let dic = self.monthsArray?[tempIndex] {
                    self.lblSelectedWeek.text = dic.key
                    self.getMonthlyData(path: dic.value)
                }
            }
        }) { (error) in
            print(error.message)
        }
        
    }
    func getMonthlyData(path: String) {
        
        OTTSdk.mediaCatalogManager.plannerContent(path: path, onSuccess: { (response) in
            
            print(response)
            self.plannerResponse = response
            self.gridCollectionView.reloadData()
            
        }) { (error) in
            print(error.message)
        }
        
    }
    
    func didPressed(collectionViewIndexPath:IndexPath, tableViewIndexPath:IndexPath) {
        
        arrayCard = nil
        arraySeason = nil
        let section = plannerResponse?.monthlyPlannerData?[collectionViewIndexPath.section - 1]
        if collectionViewIndexPath.row == 1 {
            
            let featureArray = section?.featureInfoArray
            if tableViewIndexPath.row < featureArray?.count ?? 0 {
                if let item = featureArray?[tableViewIndexPath.row] as? Card {
                    print(item.display.title)
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
                        gotoTargetedWith(path: item.target.path, cardItem: item, analytics: "monthlyPlanner")
                    }
                }
            }
        }else if collectionViewIndexPath.row == 2 {
            
            let seasonArray = section?.seasonInfoArray
            if tableViewIndexPath.row < seasonArray?.count ?? 0 {
                arraySeason = seasonArray?[tableViewIndexPath.row]
            }
        }else if collectionViewIndexPath.row == 3 {
            let comingUpArray = section?.comingUpInfoArray
            if tableViewIndexPath.row < comingUpArray?.count ?? 0 {
                arrayCard = comingUpArray?[tableViewIndexPath.row]
            }
        }
    }
    
    func moveToNextCell(selectedItem: CGFloat) {
        
        let rect = CGRect(x:  (screenWidth * selectedItem), y: 0, width: (screenWidth - 120), height: gridCollectionView.frame.size.height)
        gridCollectionView.scrollRectToVisible(rect, animated: true);
        print(rect)
    }
    func moveToPreviousCell(selectedItem: CGFloat) {
        
        let rect = CGRect(x:  ((screenWidth * selectedItem) - 120), y: 0, width: (screenWidth), height: gridCollectionView.frame.size.height)
        gridCollectionView.scrollRectToVisible(rect, animated: true);
        print(rect)
    }
}

extension MonthlyPlannerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.plannerResponse?.monthlyPlannerData?.count ?? 0 > 0 ? ((self.plannerResponse?.monthlyPlannerData?.count ?? 0) + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as? HeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = AppTheme.instance.currentTheme.submenuBgColor
            cell.delegate = self
            cell.setTopBtnsVisibility(imgNext: true, imgPrev: true, btnNxt: true, btnPrev: true)
            if indexPath.item == 0 {
                cell.lblTitle.text = "Weeks"
                cell.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
            }
            if indexPath.item == 1 {
                cell.lblTitle.text = plannerResponse?.featuredTitle
                cell.setTopBtnsVisibility(imgNext: false, imgPrev: true, btnNxt: false, btnPrev: true)
            }
            else if indexPath.item == 2 {
                cell.lblTitle.text = plannerResponse?.seasonTitle
                cell.setTopBtnsVisibility(imgNext: false, imgPrev: false, btnNxt: false, btnPrev: false)
            }
            else if indexPath.item == 3 {
                cell.lblTitle.text = plannerResponse?.comingUpTitle
                cell.setTopBtnsVisibility(imgNext: true, imgPrev: false, btnNxt: true, btnPrev: false)
            }
            return cell
        }else {
            
            let section = indexPath.section - 1
            let plan = plannerResponse?.monthlyPlannerData?[section]
            
            if (indexPath.item == 1) {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCollectionViewCell.identifier, for: indexPath) as? MonthlyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                //cell.section = indexPath.section
                cell.delegate = self
                cell.setUpData(data: plan?.featureInfoArray as Any, type: "Feature")
                return cell
            }else if (indexPath.item == 2) {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCollectionViewCell.identifier, for: indexPath) as? MonthlyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.delegate = self
                cell.setUpData(data: plan?.seasonInfoArray as Any, type: "Season")
                return cell
            }
            else if (indexPath.item == 3) {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComingUPCollectionViewCell.identifier, for: indexPath) as? ComingUPCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.delegate = self
                cell.setUpData(data: plan?.comingUpInfoArray as Any, type: "Feature")
                return cell
            }
            else{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as? CollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                if let monthlyData = plannerResponse?.monthlyPlannerData?[section] as? MonthlyPlannerData {
                    cell.titleLabel.text = monthlyData.title
                    cell.subTitleLabel.text = monthlyData.weeksDescription
                    cell.dateLabel.text = monthlyData.subtitle
                    cell.backgroundImgView.sd_setImage(with: URL(string: (monthlyData.imageUrl ?? "")), placeholderImage: #imageLiteral(resourceName: "img_popCorn"))
                }
                else {
                    cell.titleLabel.text = ""
                    cell.dateLabel.text = ""
                    cell.subTitleLabel.text = ""
                }
            
             

                if indexPath.item == 0 {
                    cell.backgroundColor = UIColor.gray
                }else {
                    cell.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.item)
        if indexPath.section > 0 {
            if indexPath.item == 3 {
                if plannerResponse?.monthlyPlannerData?.count ?? 0 > indexPath.section {
                    let section = plannerResponse?.monthlyPlannerData?[indexPath.section - 1]
                    let comingUpArray = section?.comingUpInfoArray
                    if comingUpArray?.count ?? 0 > 0 {
                        let item = comingUpArray![0]
                        print(item.display.title)
                       
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
                                gotoTargetedWith(path: item.target.path, cardItem: item, analytics: "monthlyPlanner")
                                
                            }
                        
                    }
                }
            }
        }
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
    
    func gotoPdfPage(path:String,title:String) {
        self.stopAnimating()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Content", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "PdfFileViewController") as! PdfFileViewController
        view1.pdfPath = path
        view1.pageString = title
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
    }
    //MARK: - PartialRenderingViewDelegate
    
    func didSelected(card : Card?, content : Any?, templateElement : TemplateElement? ){
        if card != nil && templateElement != nil{
            self.gotoTargetedWith(path: templateElement!.target, cardItem: card!, analytics: "monthlyPlanner")

        }
    }
    
    func record(confirm : Bool, content : Any?){
        if confirm == true{
            
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
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
}

extension MonthlyPlannerViewController: UICollectionViewDelegateFlowLayout {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            if indexPath.item == 0{
                return CGSize(width: 120, height: 48)
            }
            return CGSize(width: (screenWidth - 120), height: 48)
        }
        else if indexPath.item == 0 {
            return CGSize(width: 120, height: 280)
        }
        return CGSize(width: (screenWidth - 120), height: 280)
    }
}
extension MonthlyPlannerViewController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
  
    @objc func funcForGesture(sender: UISwipeGestureRecognizer){
        var selectedIndex:CGFloat = 0.0
        if sender.direction == .left {
            //scroll to next item
            let cellItems = self.gridCollectionView.indexPathsForVisibleItems
            cellItems.forEach({ Element in
                print(Element.row)
                if (Int(selectedIndex) < Element.row) {
                    selectedIndex = CGFloat(Element.row)
                }
            })
            moveToNextCell(selectedItem: selectedIndex)
        }else if sender.direction == .right {
            let cellItems = self.gridCollectionView.indexPathsForVisibleItems
            cellItems.forEach({ Element in
                print(Element.row)
                if (Int(selectedIndex) < Element.row) {
                    selectedIndex = CGFloat(Element.row)
                }
            })
            moveToPreviousCell(selectedItem: (selectedIndex - 2))
        }
    }
}
