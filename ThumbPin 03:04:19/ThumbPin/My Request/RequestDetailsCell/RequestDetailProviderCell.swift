//
//  ProviderCell.swift
//  ThumbPin
//
//  Created by NCT109 on 19/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class RequestDetailProviderCell: UITableViewCell {

    @IBOutlet weak var lblMaterials: UILabel!
    @IBOutlet weak var lblDeliveryDays: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var imgvwProfile: UIImageView!{
        didSet {
            imgvwProfile.createCorenerRadiuss()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLang()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpLang() {
        btnReply.setTitle(localizedString(key: "Reply"), for: .normal)
    }
    
}
