//
//  NotificationCell.swift
//  BooknRide
//
//  Created by NCrypted on 31/10/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var lblNotificationDescription: UILabel!
    @IBOutlet weak var lblNotificationDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayData(notification:Notifications){
        
        self.lblNotificationDescription.text = notification.notifyMessage
        self.lblNotificationDate.text = notification.notificationDateTime
        
        if notification.notifyType.lowercased() == "s" {
            self.notificationIcon.image = #imageLiteral(resourceName: "success_icon")
            self.notificationTitle.text = appConts.const.lBL_SUCCESS
            self.notificationTitle.textColor = UIColor.init(red: 0x00, green: 0x8C, blue: 0x70)
            
        }
        else if notification.notifyType.lowercased() == "d" {
            self.notificationIcon.image = #imageLiteral(resourceName: "cancel_icon")
            self.notificationTitle.text = appConts.const.lBL_CANCELATION
            self.notificationTitle.textColor = UIColor.init(red: 0xF7, green: 0x60, blue: 0x61)
            
        }
        else{
            self.notificationIcon.image = #imageLiteral(resourceName: "information_icon")
            self.notificationTitle.text = appConts.const.lBL_INFO
            self.notificationTitle.textColor = UIColor.init(red: 0x41, green: 0x95, blue: 0xE9)
        }
    }
    
}
