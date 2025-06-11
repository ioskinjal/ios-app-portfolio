//
//  SortByCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 20/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SortByCell: UITableViewCell {

    @IBOutlet weak var btnClick: UIButton!
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblSort: UILabel!
    @IBOutlet weak var viewSeprator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
