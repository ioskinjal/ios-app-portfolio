//
//  DealOptionCell.swift
//  Happenings
//
//  Created by admin on 2/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class DealOptionCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblDiscountPer: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDealOpt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
