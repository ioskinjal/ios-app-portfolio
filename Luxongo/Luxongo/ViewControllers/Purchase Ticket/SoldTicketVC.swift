//
//  SoldTicketVC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SoldTicketVC: BaseViewController {
    
    //MARK: Variables
    
    
    //MARK: Properties
    static var storyboardInstance:SoldTicketVC {
        return (StoryBoard.purchaseTicket.instantiateViewController(withIdentifier: SoldTicketVC.identifier) as! SoldTicketVC)
    }
    
    @IBOutlet weak var lblTittle: LabelBold!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(SoldTicketTC.nib, forCellReuseIdentifier: SoldTicketTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var ticketList = [PaymentHistoryCls.HistoryList]()
    var ticketObj: PaymentHistoryCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSoldTickets()
    }
    
    func getSoldTickets(){
        let nextPage = (ticketObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10] as [String : Any]
        
        API.shared.call(with: .mySoldTickets, viewController: self, param: param) { (response) in
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
    
    @IBAction func onClickBack(_ sender: UIButton) {
        popViewController(animated: true)
    }
    
}

extension SoldTicketVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoldTicketTC.identifier) as? SoldTicketTC else {
            fatalError("Cell can't be dequeue")
        }
        cell.ticketData = ticketList[indexPath.row]
        cell.selectionStyle = .none
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if ticketList.count - 1 == indexPath.row &&
            (Int(ticketObj!.page) < ticketObj!.lastPage) {
            
            getSoldTickets()
            
        }
    }
    
}
