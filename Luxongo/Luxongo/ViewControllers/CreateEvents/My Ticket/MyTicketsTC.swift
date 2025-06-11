//
//  MyTicketsTCTableViewCell.swift
//  Luxongo
//
//  Created by admin on 7/22/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyTicketsTC: UITableViewCell {

    
    @IBOutlet weak var lblTicketType: LabelSemiBold!
    @IBOutlet weak var lblPrice: LabelRegular!
    @IBOutlet weak var lblValPrice: LabelRegular!
    
    
    var ticketsData:MyTicketsCls.List?
    var parentVC = MyTicketsVC()
    
    
    func showTicketsData(){
        lblTicketType.text = ticketsData?.ticket_name
        lblValPrice.text = ( ticketsData?.ticket_price_type.lowercased() == "f" ? "Free".localized : ticketsData?.ticket_price )
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        deleteTicket()
    }
    
    func deleteTicket(){
        let alert = UIAlertController(title: "Remove Ticket", message: "Are You sure you want to remove this ticket ?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            
            let param = ["userid":UserData.shared.getUser()!.userid,
                         "id":self.ticketsData!.id] as [String : Any]
            
            API.shared.call(with: .deleteTickets, viewController: self.parentVC, param: param) { (response) in
                let str = Response.fatchDataAsString(res: response, valueOf: .message)
                let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.parentVC.present(alert, animated: true, completion: {
                    self.parentVC.ticketObj = nil
                    self.parentVC.ticketList = [MyTicketsCls.List]()
                    
                    self.parentVC.getMyTickets()
                })
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
        }))
        parentVC.present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
