//
//  MyTicketsVC.swift
//  Luxongo
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTicketsVC: BaseViewController {

    
    //MARK: Properties
    static var storyboardInstance:MyTicketsVC {
        return StoryBoard.createEvent.instantiateViewController(withIdentifier: MyTicketsVC.identifier) as! MyTicketsVC
    }
    
    
    @IBOutlet weak var tableview: UITableView!{
        didSet{
            tableview.register(MyTicketsTC.nib, forCellReuseIdentifier: MyTicketsTC.identifier)
            tableview.dataSource = self
            tableview.delegate = self
            tableview.tableFooterView = UIView()
        }
    }
    
    var ticketList = [MyTicketsCls.List]()
    var ticketObj: MyTicketsCls?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ticketList = [MyTicketsCls.List]()
        ticketObj = nil
        getMyTickets()
    }
    
    func getMyTickets(){
        
        let nextPage = (ticketObj?.page ?? 0 ) + 1
        
        let param = ["page":nextPage,
                     "limit":10,
                     "userid":UserData.shared.getUser()!.userid] as [String : Any]
        
        API.shared.call(with: .getUserTickets, viewController: self, param: param) { (response) in
            self.ticketObj = MyTicketsCls(dictionary: response)
            if self.ticketList.count > 0{
                self.ticketList += self.ticketObj!.list
            }
            else{
                self.ticketList = self.ticketObj!.list
            }
            if self.ticketList.count != 0{
                self.tableview.reloadData()
            }
        }
    }

    @IBAction func onClickBack(_ sender: UIButton) {
         popViewController(animated: true)
    }
    @IBAction func onClickAdd(_ sender: UIButton) {
        pushViewController(AddTicketVC.storyboardInstance, animated: true)
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
extension MyTicketsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsTC.identifier) as? MyTicketsTC else {
            fatalError("Cell can't be dequeue")
        }
       cell.ticketsData = ticketList[indexPath.row]
        cell.showTicketsData()
        cell.parentVC = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //FIXME: Open ticket in edit mode
        let nextVC = AddTicketVC.storyboardInstance
        nextVC.ticketsData = ticketList[indexPath.row]
        pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
