//
//  TwoImageCell.swift
//  Explore Local
//
//  Created by NCrypted on 17/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class TwoImageCell: UITableViewCell {

    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var llbName2: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
