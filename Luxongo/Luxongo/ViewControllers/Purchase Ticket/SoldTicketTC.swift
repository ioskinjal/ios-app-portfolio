//
//  SoldTicketTC.swift
//  Luxongo
//
//  Created by admin on 6/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SoldTicketTC: UITableViewCell {
    
    @IBOutlet weak var lblTransID: LabelBold!
    @IBOutlet weak var lblDescr: UILabel!
    @IBOutlet weak var lblPrice: LabelBold!
    
    
    
    var ticketData:PaymentHistoryCls.HistoryList?{
        didSet{
            showData()
        }
    }
    
    
    
    
    func showData(){
        lblTransID.text = "Ticket ID: " + ticketData!.txt_id
        lblDescr.text = "\(String(describing: ticketData!.buyer_user_name)) Booked \(String(describing: ticketData!.ticket_booked_qty)) \(String(describing: ticketData!.title))"
        
        lblPrice.text = ticketData?.ticket_price
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        deleteTicket()
    }
    
    func deleteTicket(){
        if let parentVC = self.viewController as? SoldTicketVC {
            let alert = UIAlertController(title: "Remove Ticket", message: "Are You sure you want to remove this ticket ?",         preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                
                let param = ["userid":UserData.shared.getUser()!.userid,
                             "ticket_id":self.ticketData!.id] as [String : Any]
                
                API.shared.call(with: .deleteSoldTickets, viewController: parentVC, param: param) { (response) in
                    let str = Response.fatchDataAsString(res: response, valueOf: .message)
                    let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    parentVC.present(alert, animated: true, completion: {
                        parentVC.ticketObj = nil
                        parentVC.ticketList = [PaymentHistoryCls.HistoryList]()
                        
                        parentVC.getSoldTickets()
                    })
                }
                
            }))
            alert.addAction(UIAlertAction(title: "No",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            
            }))
            parentVC.present(alert, animated: true, completion: nil)
        }
    }
    
}
