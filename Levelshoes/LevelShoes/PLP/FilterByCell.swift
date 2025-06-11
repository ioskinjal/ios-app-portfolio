//
//  FilterByCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 20/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class FilterByCell: UITableViewCell {

    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var btnArrow: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnArrow)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnArrow)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
