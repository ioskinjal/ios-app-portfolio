//
//  PostedBusinessCell.swift
//  Explore Local
//
//  Created by NCrypted on 25/10/18.
//  Copyright © 2018 NCrypted. All rights reserved.
//

import UIKit
import Cosmos
class PostedBusinessCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblView: UIView!
    @IBOutlet weak var btnUseful: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblfunny: UILabel!
    @IBOutlet weak var lblCool: UILabel!
    @IBOutlet weak var lblUseful: UILabel!
    @IBOutlet weak var lblPostedDate: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.border(side: .all, color: UIColor.lightGray, borderWidth: 1.0)
        }
    }
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnCool: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btncategory: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgBusiness: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
