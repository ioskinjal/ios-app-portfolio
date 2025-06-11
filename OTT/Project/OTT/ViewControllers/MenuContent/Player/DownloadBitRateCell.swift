//
//  DownloadBitRateCell.swift
//  OTT
//
//  Created by Pramodkumar on 03/06/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//

import UIKit

class DownloadBitRateCell: UITableViewCell {
    @IBOutlet weak var frameAndBitRateLabel : UILabel!
    @IBOutlet weak var circleImageView : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        frameAndBitRateLabel.font = UIFont.ottRegularFont(withSize: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func nib()->UINib {
        return UINib(nibName: "DownloadBitRateCell", bundle: nil)
    }
}
