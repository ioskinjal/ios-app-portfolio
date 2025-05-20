//
//  NotificationCell.swift
//  Talabtech
//
//  Created by NCT 24 on 23/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class NotificationListCell: UITableViewCell {
    
   
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    
    var cellData: NotificationCls.NotificationList? {
        didSet{
            loadUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadUI() {
        if let cellData = self.cellData{
            //lblTime.text = cellData.notification_date
            lblNotification.text = cellData.notification
            lblTime.text = cellData.date
        }
        else{
            lblNotification.text = ""
            lblTime.text =  ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    @IBAction func onClickDelete(_ sender: UIButton) {
        
    }
    
    
}
