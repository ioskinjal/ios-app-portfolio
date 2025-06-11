//
//  CategoryTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 25/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var _lblCategoryName: UILabel!
    @IBOutlet weak var _imgArrow: UIImageView!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: _imgArrow)
            }
            else{
                Common.sharedInstance.rotateImage(aimg: _imgArrow)
            }
        }
    }
    @IBOutlet weak var _line: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
