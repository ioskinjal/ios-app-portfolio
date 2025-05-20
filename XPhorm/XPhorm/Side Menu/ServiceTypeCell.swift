//
//  ServiceTypeCell.swift
//  XPhorm
//
//  Created by admin on 6/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ServiceTypeCell: UITableViewCell {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPerVisitCharges: UILabel!
    @IBOutlet weak var lblAdditionalRate: UILabel!
    @IBOutlet weak var lblDurationHour: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
