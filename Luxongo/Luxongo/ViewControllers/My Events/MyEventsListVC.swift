//
//  MyEventsListVC.swift
//  Luxongo
//
//  Created by admin on 6/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyEventsListVC: BaseViewController {
    
    //MARK: Variables
    enum currentTab:Int {
        case upComing
        case past
    }
    
    //MARK: Properties
    static var storyboardInstance:MyEventsListVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: MyEventsListVC.identifier) as! MyEventsListVC
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(EventTC.nib, forCellReuseIdentifier: EventTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsHorizontalScrollIndicator = false
            tableView.showsVerticalScrollIndicator = false
        }
    }
    var navTitle = ""
    var savedList = [EventList]()
    var savedObj: UpcomingEventCls?
    var selectedTab: currentTab?
    var upcominList = [EventList]()
    var upcomingObj: UpcomingEventCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentVC = self.parent as? MyEventsVC{
            navTitle = parentVC.lblTittle.text ?? ""
            if parentVC.lblTittle.text == "My Flyers"{
                callAPI()
                
            }else{
                callFavApi()
            }
        }
        
    }
    
    func callAPI() {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                upcominList = [EventList]()
                upcomingObj = nil
                getSavedEvents()
            case .past:
                savedList = [EventList]()
                savedObj = nil
                getUpcominEvents()
            }
        }
    }
    
    func callFavApi() {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                upcominList = [EventList]()
                upcomingObj = nil
                getUpcominFavEvents()
            case .past:
                savedList = [EventList]()
                savedObj = nil
                getPastFav()
            }
        }
    }
    
    func getPastFav(){
        let nextPage = (savedObj?.page ?? 0 ) + 1
        
        let param:dictionary = ["page":nextPage,
                                "limit":10,
                                "userid":UserData.shared.getUser()!.userid,
                                "is_past":"y",
        ]
        
        API.shared.call(with: .myFavEvent, viewController: self, param: param) { (response) in
            self.savedObj = UpcomingEventCls(dictionary: response)
            if self.savedList.count > 0{
                self.savedList += self.savedObj!.eventList
            }
            else{
                self.savedList = self.savedObj!.eventList
            }
            if self.savedList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    
    
    func getSavedEvents(){
        let nextPage = (savedObj?.page ?? 0 ) + 1
        
        let param:dictionary = ["page":nextPage,
                                "limit":10,
                                "userid":UserData.shared.getUser()!.userid,
                                "is_past":"y",
        ]
        
        API.shared.call(with: .myPurchasedEvents, viewController: self, param: param) { (response) in
            self.savedObj = UpcomingEventCls(dictionary: response)
            if self.savedList.count > 0{
                self.savedList += self.savedObj!.eventList
            }
            else{
                self.savedList = self.savedObj!.eventList
            }
            if self.savedList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    
    func getUpcominFavEvents(){
        
        let nextPage = (upcomingObj?.page ?? 0 ) + 1
        
        let param:dictionary = ["page":nextPage,
                                "limit":10,
                                "userid":UserData.shared.getUser()!.userid,
                                "is_past":"n",
        ]
        
        API.shared.call(with: .myFavEvent, viewController: self, param: param) { (response) in
            self.upcomingObj = UpcomingEventCls(dictionary: response)
            if self.upcominList.count > 0{
                self.upcominList += self.upcomingObj!.eventList
            }
            else{
                self.upcominList = self.upcomingObj!.eventList
            }
            if self.upcominList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    
    func getUpcominEvents(){
        
        let nextPage = (upcomingObj?.page ?? 0 ) + 1
        
        let param:dictionary = ["page":nextPage,
                                "limit":10,
                                "userid":UserData.shared.getUser()!.userid,
                                "is_past":"n",
        ]
        
        API.shared.call(with: .myPurchasedEvents, viewController: self, param: param) { (response) in
            self.upcomingObj = UpcomingEventCls(dictionary: response)
            if self.upcominList.count > 0{
                self.upcominList += self.upcomingObj!.eventList
            }
            else{
                self.upcominList = self.upcomingObj!.eventList
            }
            if self.upcominList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MyEventsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
                    fatalError("Cell can't be dequeue")
                }
                //cell.cellData = notificationList[indexPath.row]
                //reloadMoreData(indexPath: indexPath)
                //cell.lblTittle.text = menuNameList[indexPath.row]
                cell.popularData = upcominList[indexPath.row]
                cell.parentVCMyevents = self
                cell.showPopularData()
                cell.selectionStyle = .none
                return cell
            case .past:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
                    fatalError("Cell can't be dequeue")
                }
                //cell.cellData = notificationList[indexPath.row]
                //reloadMoreData(indexPath: indexPath)
                //cell.lblTittle.text = menuNameList[indexPath.row]
                cell.popularData = savedList[indexPath.row]
                cell.parentVCMyevents = self
                cell.showPopularData()
                cell.selectionStyle = .none
                return cell
            }
        }else{
            return UITableViewCell()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                return upcominList.count
            case .past:
                return savedList.count
            }
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                if upcominList.count - 1 == indexPath.row &&
                    (Int(upcomingObj!.page) < upcomingObj!.lastPage) {
                    if let parentVC = self.parent as? MyEventsVC{
                        if parentVC.lblTittle.text == "My Flyers"{
                            callAPI()
                        }else{
                            callFavApi()
                        }
                    }
                }
                
            case .past:
                if savedList.count - 1 == indexPath.row &&
                    (Int(savedObj!.page) < savedObj!.lastPage) {
                    if let parentVC = self.parent as? MyEventsVC{
                        if parentVC.lblTittle.text == "My Flyers"{
                            callAPI()
                        }else{
                            callFavApi()
                        }
                    }
                }
            }
        }
    }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
        }
        
}
