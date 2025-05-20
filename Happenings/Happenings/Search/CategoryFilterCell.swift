//
//  CategoryFilterCell.swift
//  Reviews_And_Rattings
//
//  Created by NCrypted on 20/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class CategoryFilterCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
   
    @IBOutlet weak var viewPoint: UIView!
    @IBOutlet weak var imgRight: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
