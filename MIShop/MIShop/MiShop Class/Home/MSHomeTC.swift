//
//  MSHomeTC.swift
//  MIShop
//
//  Created by nct48 on 20/08/18.
//  Copyright © 2018 Ncrypted Technologies. All rights reserved.
//

import UIKit

class MSHomeTC: UITableViewCell {

    @IBOutlet var imgOneOfShop: UIImageView!
    @IBOutlet var imgTwoOfShop: UIImageView!
    @IBOutlet var lblShopNAme: UILabel!
    @IBOutlet var lblShopLocation: UILabel!
    @IBOutlet var btnListing: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
