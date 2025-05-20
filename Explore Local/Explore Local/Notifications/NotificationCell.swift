//
//  NotificationCell.swift
//  Explore Local
//
//  Created by NCrypted on 15/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    //@IBOutlet weak var lblTime: UILabel!
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
            lblNotification.text = cellData.text
         //   lblTime.text = cellData.date
        }
        else{
            lblNotification.text = ""
           // lblTime.text =  ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        
    }
    
    
}
