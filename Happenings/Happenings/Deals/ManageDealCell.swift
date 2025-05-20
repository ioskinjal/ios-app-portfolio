//
//  ManageDealCell.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ManageDealCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnDelete: UIButton!{
        didSet{
            btnDelete.border(side: .all, color: UIColor.init(hexString: "E0171E"), borderWidth: 1.0)
        }
    }
    
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDealTitle: UILabel!
    
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    @IBOutlet weak var lblDesc: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
