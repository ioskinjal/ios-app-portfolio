//
//  MyWalletCell.swift
//  Talabtech
//
//  Created by NCT 24 on 21/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class MyWalletCell: UITableViewCell {
   
 
    @IBOutlet weak var lblMerchantName: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblAmmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lbltransactionId: UILabel!
    @IBOutlet weak var lblDealName: UILabel!
    
//    var cellData : RedeemHistory? {
//        didSet{
//            loadData()
//        }
//    }
    
//    var depositeData : DepositHistory?{
//        didSet{
//            loadDepositeData()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.contentView.border(side: .bottom, color: Color.grey.lightDeviderColor, borderWidth: 1.0)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickInfo(_ sender: UIButton) {
        
//        if isProviderWallet{
//            if let cellData = self.cellData{
//                let parentVC = (self.viewController!)
//                guard let nextVC = RedeemedAmountVC.storyboardInstance else {return}
//                nextVC.redeemHistoryData = cellData
//                nextVC.presentAsPopUp(parentVC: parentVC)
//            }
//        }
//        else{
//            if let depositeData = self.depositeData{
//                let parentVC = (self.viewController!)
//                guard let nextVC = AmountPopUpVC.storyboardInstance else {return}
//                nextVC.depostiteHistoryData = depositeData
//                nextVC.presentAsPopUp(parentVC: parentVC)
//            }
//        }
        
    }
    
//    func setProviderRelatedData() {
//        if isProviderWallet{
//            self.lblDate.text = "Requested Date"
//        }
//        else{
//            self.lblDate.text = "Date"
//        }
//    }
    
    //For Provider side
//    func loadData() {
//        if let cellData = self.cellData{
//            lblDateAns.text = cellData.requested_date
//            lblAmountAns.text = cellData.requested_amount
//        }
//        else{
//            lblDateAns.text = ""
//            lblAmountAns.text = ""
//        }
//    }
    
    //For Customer side
//    func loadDepositeData() {
//        if let depositeData = self.depositeData{
//            lblDateAns.text = depositeData.date
//            lblAmountAns.text = depositeData.amount
//        }
//        else{
//            lblDateAns.text = ""
//            lblAmountAns.text = ""
//        }
//    }
    
}
