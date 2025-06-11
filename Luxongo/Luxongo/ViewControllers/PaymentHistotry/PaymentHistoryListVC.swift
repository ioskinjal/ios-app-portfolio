//
//  PaymentHistoryListVC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PaymentHistoryListVC: BaseViewController {
    
    //MARK: Variables
    //MARK: Variables
    enum currentTab:Int {
        case paid
        case received
    }
    
    //MARK: Variables
    var selectedTab: currentTab?
    
    
    //MARK: Properties
    static var storyboardInstance:PaymentHistoryListVC {
        return (StoryBoard.paymentHistory.instantiateViewController(withIdentifier: PaymentHistoryListVC.identifier) as! PaymentHistoryListVC)
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(PaymentHistoryTC.nib, forCellReuseIdentifier: PaymentHistoryTC.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var historyList = [PaymentHistoryCls.HistoryList]()
    var historyObj: PaymentHistoryCls?
    
    var historyReceivedList = [PaymentHistoryCls.HistoryList]()
    var historyReceivedObj: PaymentHistoryCls?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //callReceivedPaymentHistory()
        callAPI()
    }
    
    
    
    
}

//MARK: API methods
extension PaymentHistoryListVC{
    
    func callAPI() {
        if let selectedTab = self.selectedTab{
            switch selectedTab{
            case .paid:
                callPaidPaymentHistory()
            case .received:
                callReceivedPaymentHistory()
            }
        }
    }
 
    
    func callPaidPaymentHistory(){
        
        let nextPage = (historyObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "is_paid":"y"] as [String : Any]
        
        API.shared.call(with: .paymentHistory, viewController: self, param: param) { (response) in
            self.historyObj = PaymentHistoryCls(dictionary: response)
            if self.historyList.count > 0{
                self.historyList += self.historyObj!.list
            }
            else{
                self.historyList = self.historyObj!.list
            }
            if self.historyList.count != 0{
                self.tableView.reloadData()
            }
            
        }
    }
    
    func callReceivedPaymentHistory(){
        
        let nextPage = (historyReceivedObj?.page ?? 0 ) + 1
        
        let param = ["userid":UserData.shared.getUser()!.userid,
                     "page":nextPage,
                     "limit":10,
                     "is_paid":"n"] as [String : Any]
        
        API.shared.call(with: .paymentHistory, viewController: self, param: param) { (response) in
            self.historyReceivedObj = PaymentHistoryCls(dictionary: response)
            if self.historyReceivedList.count > 0{
                self.historyReceivedList += self.historyReceivedObj!.list
            }
            else{
                self.historyReceivedList = self.historyReceivedObj!.list
            }
            if self.historyReceivedList.count != 0{
                self.tableView.reloadData()
            }
        }
    }
    
}

extension PaymentHistoryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentHistoryTC.identifier) as? PaymentHistoryTC else {
            fatalError("Cell can't be dequeue")
        }
        //cell.cellData = notificationList[indexPath.row]
        //reloadMoreData(indexPath: indexPath)
        //cell.lblTittle.text = menuNameList[indexPath.row]
        cell.historyData = historyReceivedList[indexPath.row]
        cell.imgTicket.image = #imageLiteral(resourceName: "greenPriceShape")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyReceivedList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadMoreData(indexPath: indexPath)
    }
    
    func reloadMoreData(indexPath: IndexPath) {
        if historyReceivedList.count - 1 == indexPath.row &&
            (Int(historyReceivedObj!.page) < historyReceivedObj!.lastPage) {
            
            callReceivedPaymentHistory()
            
        }
    }
    
}
