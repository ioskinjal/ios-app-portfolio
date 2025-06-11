//
//  HomeVC.swift
//  Luxongo
//
//  Created by admin on 6/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:HomeVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: HomeVC.identifier) as! HomeVC
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
            searchBar.layer.borderWidth = 0
            searchBar.layer.borderColor = UIColor.clear.cgColor
            self.searchBar.backgroundImage = UIImage()
            
        }
    }
    
    @IBOutlet weak var upComingPanelView: UIView!{
        didSet{
            self.upComingPanelView.isHidden = true
        }
    }
    @IBOutlet weak var popularEventPanelView: UIView!{
        didSet{
            //self.popularEventPanelView.isHidden = true
        }
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var lblUpComing: LabelBold!
    @IBOutlet weak var lblPopular: LabelBold!
    @IBOutlet weak var btnViewAllUpCom: GreyButton!
    @IBOutlet weak var btnViewAllPop: GreyButton!
    
    @IBOutlet weak var popularClnViewHeight: NSLayoutConstraint!
    
//    @IBOutlet weak var tableView: UITableView!{
//        didSet{
//            tableView.register(EventTC.nib, forCellReuseIdentifier: EventTC.identifier)
//            tableView.dataSource = self
//            tableView.delegate = self
//            tableView.tableFooterView = UIView()
//            tableView.isScrollEnabled = false
//            tableView.separatorStyle = .none
//        }
//    }
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.isHidden = true
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(EventCC.nib, forCellWithReuseIdentifier: EventCC.identifier)
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }
    }
    
    @IBOutlet weak var popularClnView: UICollectionView!{
        didSet{
            //popularClnView.isHidden = true
            popularClnView.delegate = self
            popularClnView.dataSource = self
            popularClnView.register(CategoryCC.nib, forCellWithReuseIdentifier: CategoryCC.identifier)
            popularClnView.showsVerticalScrollIndicator = false
            popularClnView.showsHorizontalScrollIndicator = false
//            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.scrollDirection = .horizontal
//            }
        }
    }
    
    
    var upcomingEventList = [EventList](){
        didSet{
            self.upComingPanelView.isHidden = self.upcomingEventList.count <= 0
            self.collectionView.isHidden = self.upcomingEventList.count <= 0
        }
    }
    var upcomingEventObj: UpcomingEventCls?
    
//    var popularEventList = [EventList](){
//        didSet{
//            //self.popularEventPanelView.isHidden = self.popularEventList.count <= 0
//        }
//    }
//    var popularEventObj: UpcomingEventCls?
    
    var popularCategoryList = [PopularCategory](){
        didSet{
            self.popularEventPanelView.isHidden = self.popularCategoryList.count <= 0
            self.popularClnView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK:- API FUNCTIONS
    
    func getUpcomingEvents(){
        let nextPage = (upcomingEventObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":5,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .upcomingEvents, viewController: self, param: param, failer: { (errStr) in
            print(errStr)
            self.getPopularCategories()
            //self.getPopularEvents()
        }) { (response) in
            //self.getPopularEvents()
            self.getPopularCategories()
            self.upcomingEventObj = UpcomingEventCls(dictionary: response)
            if self.upcomingEventList.count > 0{
                self.upcomingEventList += self.upcomingEventObj!.eventList
            }
            else{
                self.upcomingEventList = self.upcomingEventObj!.eventList
            }
            self.collectionView.reloadData()
        }
    }
    /*
    func getPopularEvents(){
        
        let param = ["page":1,
                     "limit":5,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .popualrEvents, viewController: self, param: param) { (response) in
            self.popularEventObj = UpcomingEventCls(dictionary: response)
            if self.popularEventList.count > 0{
                self.popularEventList += self.popularEventObj!.eventList
            }
            else{
                self.popularEventList = self.popularEventObj!.eventList
            }
            self.tableView.reloadData()
        }
    }*/
    
    func getPopularCategories(){
        API.shared.call(with: .getPopularCategories, viewController: self, param: [:]) { (response) in
            self.popularCategoryList = ResponseHandler.fatchDataAsArray(res: response, valueOf: .data).map({ PopularCategory(dictionary: $0 as! dictionary) })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //searchBar.addRightView(icon: #imageLiteral(resourceName: "ic_filter"), selector: #selector(didTapBtnFilter(_:)))
        upcomingEventList = []
        upcomingEventObj = nil
//        popularEventList = []
//        popularEventObj = nil
        getUpcomingEvents()
        self.searchBar.layoutIfNeeded()
        collectionViewHeight.constant =  DeviceType.IS_IPHONE_5_OR_5SE ? 250.0 : 260.0
    }
    
    @IBAction func onClickViewUpCom(_ sender: UIButton) {
        guard self.upcomingEventList.count > 0 else {return}
        let nextVC = ViewMoreHomeEventsVC.storyboardInstance
        nextVC.navTitle = "Upcoming Events"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func onClickViewPop(_ sender: UIButton) {
//        guard self.popularEventList.count > 0 else {return}
//        let nextVC = ViewMoreHomeEventsVC.storyboardInstance
//        nextVC.navTitle = "Popular Events"
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapBtnFilter(_ sender:UIButton){
//        if let _ = sender.superview as? UITextField{
//            print("Click Filter")
//            self.navigationController?.pushViewController(FilterByVC.storyboardInstance, animated: true)
//        }
        pushViewController(ManageEventsListVC.storyboardInstance, animated: true)
    }
    
    func autoDynamicHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.popularClnViewHeight.constant = self.popularClnView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
}

/*
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.indexPath = indexPath
        cell.cellData = popularEventList[indexPath.row]
        autoDynamicHeight()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularEventList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let nextVC = EventPreview.storyboardInstance
        nextVC.event_slug = popularEventList[indexPath.row].event_slug
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        autoDynamicHeight()
    }
    
}
*/

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ( collectionView == popularClnView ? popularCategoryList.count : upcomingEventList.count )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularClnView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCC.identifier, for: indexPath) as? CategoryCC else {
                fatalError("Cell can't be dequeue")
            }
            cell.cellData = popularCategoryList[indexPath.row]
            autoDynamicHeight()
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCC.identifier, for: indexPath) as? EventCC else {
                fatalError("Cell can't be dequeue")
            }
            cell.parentVC = self
            cell.indexPath = indexPath
            cell.cellData = upcomingEventList[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if collectionView == popularClnView{
            
        }else{
            let nextVC = EventPreview.storyboardInstance
            //nextVC.eventData = upcomingEventList[indexPath.row]
            nextVC.event_slug = upcomingEventList[indexPath.row].event_slug
            pushViewController(nextVC, animated: true)
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: CGFloat(screenSize.width) * 0.85,
        //height: CGFloat(screenSize.width) * 0.68)
        //let width = ScreenSize.SCREEN_WIDTH * 270/320, height = ScreenSize.SCREEN_WIDTH * 250/370
       
        if collectionView == popularClnView{
            let padding: CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: (collectionViewSize/2) + 0)
        }else{
            return CGSize(width: DeviceType.IS_IPHONE_5_OR_5SE ? 270.0 : 320.0,height: DeviceType.IS_IPHONE_5_OR_5SE ? 250.0 : 260.0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == popularClnView{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
    
    
}

extension HomeVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        searchBar.resignFirstResponder()
        let nextVC = SearchResultListVC.storyboardInstance
        nextVC.serachText = searchBar.text
        searchBar.text = nil
        pushViewController(nextVC, animated: true)
    }
    
}
