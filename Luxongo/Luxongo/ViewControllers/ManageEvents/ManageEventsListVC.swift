//
//  ManageEventsListVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageEventsListVC: BaseViewController {
    
    enum currentTab:Int {
        case upComing
        case past
        case draft
    }
    
    //MARK: Variables
    var selectedTab: currentTab?
    
    //MARK: Properties
    static var storyboardInstance:ManageEventsListVC {
        return (StoryBoard.manageEvents.instantiateViewController(withIdentifier: ManageEventsListVC.identifier) as! ManageEventsListVC)
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ManageEventTC.nib, forCellReuseIdentifier: ManageEventTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var UpcomingList = [EventList]()
    var upcomingObj : UpcomingEventCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentVC = self.parent as? ManageEventsVC{
            parentVC.searchBar.text = ""
            parentVC.searchBar.delegate = self
        }
        callAPI()
        //Refresh if Event is modified
        NotificationCenter.default.addObserver(self, selector: #selector(eventModify), name: .eventModify, object: nil)
    }
    
    @objc func eventModify(notification: Notification) {
        let data = notification.object as! [String: Any]
        if data["flag"] as? Bool ?? false{
            print("Notification capture")
            if let parentVC = self.parent as? ManageEventsVC{
                parentVC.searchBar.text = ""
                parentVC.searchBar.delegate = self
            }
            self.upcomingObj = nil
            self.UpcomingList = []
            self.tableView.reloadData()
            callAPI()
        }
    }
    
    func callAPI() {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                getUpcomingEvents()
            case .past:
                getPastEvents()
            case .draft:
                getDraftEvents()
            }
        }
    }
    
    func getDraftEvents(){
        let nextPage = (upcomingObj?.page ?? 0 ) + 1
        if let parentVC = self.parent as? ManageEventsVC, let searchBar = parentVC.searchBar{
            let param: dictionary = ["page":nextPage,
                                     "limit":10,
                                     "userid":UserData.shared.getUser()!.userid,
                                     "search_title":searchBar.text ?? ""
            ]
            
            
            API.shared.call(with: .savedEvents, viewController: self, param: param) { (response) in
                self.upcomingObj = UpcomingEventCls(dictionary: response)
                if self.UpcomingList.count > 0{
                    self.UpcomingList += self.upcomingObj!.eventList
                }
                else{
                    self.UpcomingList = self.upcomingObj!.eventList
                }
                if self.UpcomingList.count != 0{
                    self.tableView.reloadData()
                }
                if let ele = self.UpcomingList.first{
                    parentVC.csv_url = ele.event_csv_download_link
                }
            }
        }
    }
    
    func getUpcomingEvents(){
        
        let nextPage = (upcomingObj?.page ?? 0 ) + 1
        if let parentVC = self.parent as? ManageEventsVC, let searchBar = parentVC.searchBar{
            let param = ["userid":UserData.shared.getUser()!.userid,
                         "page":nextPage,
                         "limit":"20",
                         "is_past":"n",
                         "search_title":searchBar.text ?? ""] as [String : Any]
            
            
            API.shared.call(with: .myCreatedEvents, viewController: self, param: param) { (response) in
                self.upcomingObj = UpcomingEventCls(dictionary: response)
                if self.UpcomingList.count > 0{
                    self.UpcomingList += self.upcomingObj!.eventList
                }
                else{
                    self.UpcomingList = self.upcomingObj!.eventList
                }
                if self.UpcomingList.count != 0{
                    self.tableView.reloadData()
                }
                //parentVC.csv_url = self.UpcomingList[0].event_csv_download_link
                if let ele = self.UpcomingList.first{
                    parentVC.csv_url = ele.event_csv_download_link
                }
            }
        }
        
    }
    
    func getPastEvents(){
        
        let nextPage = (upcomingObj?.page ?? 0 ) + 1
        if let parentVC = self.parent as? ManageEventsVC, let searchBar = parentVC.searchBar{
            let param = ["userid":UserData.shared.getUser()!.userid,
                         "page":nextPage,
                         "limit":"20",
                         "is_past":"y",
                         "search_title":searchBar.text ?? ""] as [String : Any]
            
            
            API.shared.call(with: .myCreatedEvents, viewController: self, param: param) { (response) in
                self.upcomingObj = UpcomingEventCls(dictionary: response)
                if self.UpcomingList.count > 0{
                    self.UpcomingList += self.upcomingObj!.eventList
                }
                else{
                    self.UpcomingList = self.upcomingObj!.eventList
                }
                if self.UpcomingList.count != 0{
                    self.tableView.reloadData()
                }
                //parentVC.csv_url = self.UpcomingList[0].event_csv_download_link
                if let ele = self.UpcomingList.first{
                    parentVC.csv_url = ele.event_csv_download_link
                }
            }
        }
        
    }
}

extension ManageEventsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageEventTC.identifier) as? ManageEventTC else {
            fatalError("Cell can't be dequeue")
        }
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        cell.upcomingData = UpcomingList[indexPath.row]
        cell.parentVC = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpcomingList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data = UpcomingList[indexPath.row].dictionaryRepresentation()
//        data.printDic()
//        let nextVC = CreateEventsVC.storyboardInstance
//        nextVC.eventData = CreateEvent(with: data)
//        nextVC.isEditMode = true
//        pushViewController(nextVC, animated: true)
        let nextVC = EventPreview.storyboardInstance
        nextVC.event_slug = UpcomingList[indexPath.row].event_slug
        //nextVC.isFromCreateMode = true
        
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}

extension ManageEventsListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        
        searchBar.resignFirstResponder()
        
        self.UpcomingList = [EventList]()
        self.upcomingObj = nil
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                self.getUpcomingEvents()
            case .past:
                self.getPastEvents()
            case .draft:
                self.getDraftEvents()
            }
        }
        
        
    }
}



