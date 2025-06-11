//
//  PaymentHistoryTC.swift
//  Luxongo
//
//  Created by admin on 6/24/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PaymentHistoryTC: UITableViewCell {
    
    
    @IBOutlet weak var lblTransaction: LabelBold!
    @IBOutlet weak var lblBookedFor: LabelRegular!
    @IBOutlet weak var lblEventNm: LabelSemiBold!
    @IBOutlet weak var lblDate: LabelRegular!
    @IBOutlet weak var lblValDate: LabelRegular!
    @IBOutlet weak var lblPrice: LabelBold!
    @IBOutlet weak var imgTicket: UIImageView!
    
    var historyData:PaymentHistoryCls.HistoryList?{
        didSet{
            showHistoryData()
        }
    }
    
    func showHistoryData(){
        lblTransaction.text = historyData?.txt_id
        lblEventNm.text = historyData?.title
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let array = historyData?.created_at.components(separatedBy: " ")
        let str:String = array![0]
        let date = dateformatter.date(from: str)
        dateformatter.dateFormat = "dd MMM, yyyy"
        lblValDate.text = dateformatter.string(from: date!)
        lblPrice.text = historyData?.ticket_price
        
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
