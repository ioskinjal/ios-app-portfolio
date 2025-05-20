//
//  FavoriteServiceCell.swift
//  XPhorm
//
//  Created by admin on 6/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class FavoriteServiceCell: UITableViewCell {

    @IBOutlet weak var btnrequestBook: UIButton!
    @IBOutlet weak var lblTotalServiceHead: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblReportIssue: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotalService: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var lblServiceCat: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
