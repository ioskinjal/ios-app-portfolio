//
//  FAQCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 24/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblName.font = UIFont(name: "Cairo-Light", size: lblName.font.pointSize)
            }
        }
    }
    @IBOutlet weak var arrow: UIImageView!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: arrow)
            }
            else{
                Common.sharedInstance.rotateImage(aimg: arrow)
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
