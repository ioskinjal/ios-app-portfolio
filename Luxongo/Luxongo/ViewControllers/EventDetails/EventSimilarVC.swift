//
//  EventSimilarVC.swift
//  Luxongo
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EventSimilarVC: UIViewController {
    
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:EventSimilarVC {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: EventSimilarVC.identifier) as! EventSimilarVC
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
    
    
    var similarList = [EventList]()
    var similarObj: UpcomingEventCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSimilarEvents()
        
    }
    
    func getSimilarEvents(){
        
        if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
            let nextPage = (similarObj?.page ?? 0 ) + 1
            
            let param:dictionary = ["page":nextPage,
                         "limit":10,
                         "userid":UserData.shared.getUser()!.userid,
                         "event_slug":eventData.event_slug]
            
            API.shared.call(with: .similarEvents, viewController: self, param: param) { (response) in
                self.similarObj = UpcomingEventCls(dictionary: response)
                if self.similarList.count > 0{
                    self.similarList += self.similarObj!.eventList
                }
                else{
                    self.similarList = self.similarObj!.eventList
                }
                if self.similarList.count != 0{
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
}

extension EventSimilarVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = similarList[indexPath.row]
        cell.indexPath = indexPath
//        cell.popularData = similarList[indexPath.row]
//        cell.parentVCSimilarEvents = self
//        cell.showPopularData()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
