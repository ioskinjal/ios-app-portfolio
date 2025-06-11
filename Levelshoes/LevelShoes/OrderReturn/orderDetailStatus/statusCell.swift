//
//  statusCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 13/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class statusCell: UITableViewCell {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblProductName.addTextSpacing(spacing: 1.07)
            }
        }
    }
    
    @IBOutlet weak var lblProductDesc: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblSizeValue: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblQtyValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
