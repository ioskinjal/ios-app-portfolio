//
//  EventOrganizerVC.swift
//  Luxongo
//
//  Created by admin on 7/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var navigation: UINavigationController?

class EventOrganizerVC: BaseViewController {
    
    static var storyboardInstance:EventOrganizerVC {
        return StoryBoard.eventDetails.instantiateViewController(withIdentifier: EventOrganizerVC.identifier) as! EventOrganizerVC
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(SelectOraganizerTC.nib, forCellReuseIdentifier: SelectOraganizerTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsHorizontalScrollIndicator = false
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    
    var orgenizerList = [MyOrgenizersCls.List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let parentVC = self.parent as? SlideUpVC, let eventData = parentVC.eventData{
            orgenizerList = eventData.organizersArray
            tableView.reloadData()
        }
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

extension EventOrganizerVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectOraganizerTC.identifier) as? SelectOraganizerTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = orgenizerList[indexPath.row]
        cell.btnCheckBox.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgenizerList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProfileVC.storyboardInstance
        nextVC.isForOrganizer = true
        nextVC.organizer_id = orgenizerList[indexPath.row].organizer_id
        if let parent = self.parent as? SlideUpVC{
           parent.dismiss(animated: true, completion: nil)
        }
        navigation?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
