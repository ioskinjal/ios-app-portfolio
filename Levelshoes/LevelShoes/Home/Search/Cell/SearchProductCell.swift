//
//  SearchProductCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 01/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SearchProductCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
