//
//  LeftMenuCell.swift
//  Talabtech
//
//  Created by NCT 24 on 05/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblMenuName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        let clearView = UIView()
//        clearView.backgroundColor = UIColor.clear // Whatever color you like
//        UITableViewCell.appearance().selectedBackgroundView = clearView
        
        // Configure the view for the selected state
    }
    
}
