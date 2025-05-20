//
//  SeachBusinessCell.swift
//  Explore Local
//
//  Created by NCrypted on 02/11/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit

class SeachBusinessCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var stackViewCat: UIStackView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgRound: UIImageView!
    @IBOutlet weak var stackViewEdit: UIStackView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btncategory: UIButton!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblrateCount: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
