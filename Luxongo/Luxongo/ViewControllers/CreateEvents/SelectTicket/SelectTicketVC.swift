//
//  SelectTicketVC.swift
//  Luxongo
//
//  Created by admin on 6/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectTicketVC: BaseViewController {

    //MARK: Variables
    var ticketObj: MyTicketsCls?
    var listOfticket: [MyTicketsCls.List] = []{
        didSet{
            tableView.reloadData()
            self.displayPopUp(presentView: self.sceneDockTicketView, isPresent: self.listOfticket.count < 1 )
        }
    }
    
    //MARK: Properties
    static var storyboardInstance:SelectTicketVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: SelectTicketVC.identifier) as! SelectTicketVC
    }
    
    //TODO: PopUpView Ticket
    @IBOutlet var sceneDockTicketView: UIView!
    @IBOutlet weak var lblNoTicket: LabelRegular!
    @IBOutlet weak var btnAddTicket: BlackBgButton!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(SelectTicketTC.nib, forCellReuseIdentifier: SelectTicketTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetTicket()
    }
    
    //MARK: PopUp method
    @IBAction func onClickAddTicket(_ sender: UIButton) {
       openAddTicketVC()
    }
    
}

//MARK: Custom function
extension SelectTicketVC{
    
    func openAddTicketVC() {
        let nextVC = AddTicketVC.storyboardInstance
        nextVC.getCreatedTicket = {[weak self] (newOrg) in
            guard let self = self else { return }
            self.listOfticket.append(newOrg)
        }
        pushViewController(nextVC, animated: true)
    }

    func isValidated() -> Bool {
        var ErrorMsg = ""
        if (listOfticket.filter({ $0.isSelected == true })).count < 1 {
            ErrorMsg = "Please select Ticket"
        }
        
        if ErrorMsg != "" {
            UIApplication.alert(title: "Error", message: ErrorMsg, style: .destructive)
            return false
        }
        else {
            return true
        }
    }
    
    func saveDataWithOutValidate() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            let selectedTktIds = (listOfticket.filter({ $0.isSelected == true })).map({String($0.ticket_id)}).joined(separator: ",")
            eventData.ticket_ids = selectedTktIds
        }
    }
    
    private func saveData() -> dictionary {
        let selectedTktIds = (listOfticket.filter({ $0.isSelected == true })).map({String($0.ticket_id)}).joined(separator: ",")
        let param:dictionary = [
            "ticket_ids": selectedTktIds,
        ]
        return param
    }
    
    func setDataForEvent( eventData: inout CreateEvent) {
        let dic = saveData()
        eventData.ticket_ids = dic["ticket_ids",""]
    }
    
    func setUpPreLoadData() {
        if let parent = self.parent as? CreateEventsVC{
            let eventData = parent.eventData
            setPreSelected(ids: eventData.ticket_ids)
        }
    }
    
    func setPreSelected(ids: String) {
        if ids.isBlank {return}
        let idAry = ids.components(separatedBy: ",")
        for _id in idAry{
            let foundItems = listOfticket.filter { "\($0.ticket_id)" == _id }
            if let item = foundItems.first{
                item.isSelected = true
            }
        }
        tableView.reloadData()
    }
    
}

//MARK: API Methods
extension SelectTicketVC{
    
    func callGetTicket() {
        
        let nextPage = (ticketObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
         API.shared.call(with: .getUserTickets, viewController: self, param: param) { (response) in
            
        self.ticketObj = MyTicketsCls(dictionary: response)
        if self.listOfticket.count > 0{
            self.listOfticket += self.ticketObj!.list
        }
        else{
            self.listOfticket = self.ticketObj!.list
        }
        
            if self.listOfticket.count > 0{
                self.setUpPreLoadData()
            }
        }
    }
}

//MARK: UITableViewDelegates
extension SelectTicketVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectTicketTC.identifier) as? SelectTicketTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.cellData = listOfticket[indexPath.row]
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfticket.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
