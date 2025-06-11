//
//  ViewMoreHomeEventsVC.swift
//  Luxongo
//
//  Created by admin on 7/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ViewMoreHomeEventsVC: BaseViewController {

    //MARK:- properties
    
    static var storyboardInstance:ViewMoreHomeEventsVC {
        return StoryBoard.home.instantiateViewController(withIdentifier: ViewMoreHomeEventsVC.identifier) as! ViewMoreHomeEventsVC
    }
    
    @IBOutlet weak var lblNavTitle: LabelBold!
    @IBOutlet weak var tblEvents: UITableView!{
        didSet{
            tblEvents.register(EventTC.nib, forCellReuseIdentifier: EventTC.identifier)
            tblEvents.dataSource = self
            tblEvents.delegate = self
            tblEvents.tableFooterView = UIView()
          //  tblEvents.isScrollEnabled = false
            tblEvents.separatorStyle = .none
        }
    }
    
    var eventList = [EventList]()
    var eventObj : UpcomingEventCls?
    var navTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNavTitle.text = navTitle
        if navTitle == "Upcoming Events"{
            getUpcomingEvents()
        }else{
            getPopularEvents()
        }
    }
    
    //MARK:- API FUNCTIONS
    
    func getUpcomingEvents(){
        let nextPage = (eventObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .upcomingEvents, viewController: self, param: param) { (response) in
            self.eventObj = UpcomingEventCls(dictionary: response)
            if self.eventList.count > 0{
                self.eventList += self.eventObj!.eventList
            }
            else{
                self.eventList = self.eventObj!.eventList
            }
            if self.eventList.count != 0{
                self.tblEvents.reloadData()
            }
        }
       
        
    }
    
    func getPopularEvents(){
        
        let param = ["page":1,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .popualrEvents, viewController: self, param: param) { (response) in
            self.eventObj = UpcomingEventCls(dictionary: response)
            if self.eventList.count > 0{
                self.eventList += self.eventObj!.eventList
            }
            else{
                self.eventList = self.eventObj!.eventList
            }
            if self.eventList.count != 0{
                self.tblEvents.reloadData()
            }
        }
    }

    //MARK:- UIBUTTON Events
    @IBAction func onClickback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ViewMoreHomeEventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTC.identifier) as? EventTC else {
            fatalError("Cell can't be dequeue")
        }
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        cell.parentVCViewMore = self
        cell.popularData = eventList[indexPath.row]
        cell.showPopularData()
        cell.btnfavorite.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = EventPreview.storyboardInstance
        nextVC.event_slug = eventList[indexPath.row].event_slug
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if eventList.count - 1 == indexPath.row &&
            (Int(eventObj!.page) < eventObj!.lastPage) {
            if navTitle == "Upcoming Events"{
                getUpcomingEvents()
            }else{
                getPopularEvents()
            }
        }
    }
    
}
