//
//  PurchaseTicketListVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PurchaseTicketListVC: BaseViewController {
    
    //MARK: Variables
    enum currentTab:Int {
        case upComing
        case past
    }
    
    //MARK: Variables
    var selectedTab: currentTab?
     var selected = ""
    var ticketList = [PaymentHistoryCls.HistoryList]()
    var ticketObj: PaymentHistoryCls?
    
    var ticketPastList = [PaymentHistoryCls.HistoryList]()
    var ticketPastObj: PaymentHistoryCls?
    
    
    //MARK: Properties
    static var storyboardInstance:PurchaseTicketListVC {
        return (StoryBoard.purchaseTicket.instantiateViewController(withIdentifier: PurchaseTicketListVC.identifier) as! PurchaseTicketListVC)
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(PurchaseTicketTC.nib, forCellReuseIdentifier: PurchaseTicketTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentVC = self.parent as? PurchaseTicketVC{
            parentVC.searchBar.text = ""
            parentVC.searchBar.delegate = self
        }
        callAPI()
    }
    
}

//MARK: API methods
extension PurchaseTicketListVC{
   
    func callAPI() {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                selected = "u"
                getUpComingTickets()
            case .past:
                selected = "p"
                getPastTickets()
            }
        }
    }
    
    
    func getUpComingTickets(){
        let nextPage = (ticketObj?.page ?? 0 ) + 1
        if let parentVC = self.parent as? PurchaseTicketVC, let searchBar = parentVC.searchBar{
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "is_past":"n",
                     "search_title":searchBar.text ?? ""] as [String : Any]
        
        API.shared.call(with: .myPurchasedTickets, viewController: self, param: param) { (response) in
            self.ticketObj = PaymentHistoryCls(dictionary: response)
            if self.ticketList.count > 0{
                self.ticketList += self.ticketObj!.list
            }
            else{
                self.ticketList = self.ticketObj!.list
            }
            if self.ticketList.count != 0{
                self.tableView.reloadData()
            }
        }
        }
    }
    
    func getPastTickets(){
        let nextPage = (ticketPastObj?.page ?? 0 ) + 1
        if let parentVC = self.parent as? PurchaseTicketVC, let searchBar = parentVC.searchBar{
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "is_past":"y",
                     "search_title":searchBar.text ?? ""] as [String : Any]
        
        API.shared.call(with: .myPurchasedTickets, viewController: self, param: param) { (response) in
            self.ticketPastObj = PaymentHistoryCls(dictionary: response)
            if self.ticketPastList.count > 0{
                self.ticketPastList += self.ticketPastObj!.list
            }
            else{
                self.ticketPastList = self.ticketPastObj!.list
            }
            if self.ticketPastList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    }
    
}



extension PurchaseTicketListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTicketTC.identifier) as? PurchaseTicketTC else {
            fatalError("Cell can't be dequeue")
        }
       
        if selected == "u"{
            cell.ticketData = ticketList[indexPath.row]
            cell.selectionStyle = .none
            //cell.cellData = notificationList[indexPath.row]
            //reloadMoreData(indexPath: indexPath)
            //cell.lblTittle.text = menuNameList[indexPath.row]
            return cell
        }else{
            cell.ticketData = ticketPastList[indexPath.row]
            cell.selectionStyle = .none
            //cell.cellData = notificationList[indexPath.row]
            //reloadMoreData(indexPath: indexPath)
            //cell.lblTittle.text = menuNameList[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected == "u"{
            return ticketList.count
        }else{
        return ticketPastList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //FIXME: Open popup
        if selected == "u"{
            let nextVC = TicketPopUpVC.storyboardInstance
            nextVC.history = ticketList[indexPath.row]
            present(asPopUpView: nextVC)
        }else{
            let nextVC = TicketPopUpVC.storyboardInstance
            nextVC.history = ticketPastList[indexPath.row]
            present(asPopUpView: nextVC)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selected == "u"{
            if ticketList.count - 1 == indexPath.row &&
                (Int(ticketObj!.page) < ticketObj!.lastPage) {
                
                getUpComingTickets()
                
            }
        }else{
            if ticketPastList.count - 1 == indexPath.row &&
                (Int(ticketPastObj!.page) < ticketPastObj!.lastPage) {
                
                getPastTickets()
                
            }
        }
       
    }
   
    
}


extension PurchaseTicketListVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Serach Click")
        
        searchBar.resignFirstResponder()
        
        
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .upComing:
                self.ticketList = [PaymentHistoryCls.HistoryList]()
                self.ticketObj = nil
                self.getUpComingTickets()
            case .past:
                self.ticketPastList = [PaymentHistoryCls.HistoryList]()
                self.ticketPastObj = nil
                self.getPastTickets()
                
            }
        }
        
        
    }
}
