//
//  PushNotificationsTableViewCell.swift
//  LevelShoes
//
//  Created by kanhiya kumar jha on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class PushNotificationsTableViewCell: UITableViewCell {


    @IBOutlet weak var lblPushnotificationHeader: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblPushnotificationHeader.font = UIFont(name: "Cairo-SemiBold", size: lblPushnotificationHeader.font.pointSize)
            }
            lblPushnotificationHeader.text = "accountNotification".localized
        }
    }
    @IBOutlet weak var lblNotificationDesc: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNotificationDesc.font = UIFont(name: "Cairo-Light", size: lblNotificationDesc.font.pointSize)
            }
            lblNotificationDesc.text = "accountNotificationDesc".localized
        }
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
