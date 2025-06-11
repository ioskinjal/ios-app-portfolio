//
//  PurchaseTicketTC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PurchaseTicketTC: UITableViewCell {
    
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblTittle: LabelSemiBold!
    @IBOutlet weak var lblOwnerName: LabelRegular!
    @IBOutlet weak var lblAdd: LabelRegular!
    @IBOutlet weak var lblDate: LabelRegular!
    @IBOutlet weak var lblPrice: LabelSemiBold!
    
    var ticketData:PaymentHistoryCls.HistoryList?{
        didSet{
            showData()
        }
    }
    
    
    
    
    func showData(){
        lblTittle.text = ticketData!.ticket_name
        lblOwnerName.text = ticketData?.title
        lblAdd.text = ticketData?.add_line_1
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = DateFormatter.appDateTimeFormat//"yyyy-MM-dd HH:mm:ss"
//        // let array = cellData.event_start_time.components(separatedBy: " ")
//        var str:String = ticketData?.event_start_time ?? ""
//
//        // dateformatter.dateFormat = "dd MMM, yyyy"
//        let date = dateformatter.date(from:str )
//        // let str1:String = array[1]
//        dateformatter.dateFormat = DateFormatter.appDateDisplayFormate//"dd MMM, yyyy | HH:mm"
//
//        str = dateformatter.string(from: date!)
//        //            let date1 = dateformatter.date(from: str)
//        //            dateformatter.dateFormat = "HH:mm"
//
//        lblDate.text = str
        
        if let ticketData = self.ticketData, let startDt = ticketData.event_start_time.convertDate(dateFormate: DateFormatter.appDateTimeFormat){
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = DateFormatter.appDateDisplayFormate
            self.lblDate.text = dateformatter.string(from: startDt)
        }else{
            self.lblDate.text = "N/A".localized
        }
        
        imgEvent.downLoadImage(url: ticketData!.logo)
        lblPrice.text = (ticketData?.ticket_price_type == "f" ? "Free" : ticketData?.ticket_price)
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
