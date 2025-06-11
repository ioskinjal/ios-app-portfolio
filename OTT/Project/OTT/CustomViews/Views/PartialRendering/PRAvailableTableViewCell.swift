//
//  PRAvailableTableViewCell.swift
//  OTT
//
//  Created by Muzaffar Ali on 28/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit

class PRAvailableTableViewCell: UITableViewCell {
    static let identifier = "PRAvailableTableViewCell"
    static let nibName = "PRAvailableTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContentView: UIView!
    @IBOutlet weak var infoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.font = UIFont.ottMediumFont(withSize: 12)
        self.titleContentView.layer.borderColor = UIColor.init(hexString: "3e3e4a").cgColor
        self.titleContentView.layer.borderWidth = 1
        self.titleContentView.layer.cornerRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
