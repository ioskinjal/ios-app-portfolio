//
//  InfoHelpTableCell.swift
//  LevelShoes
//
//  Created by Maa on 20/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class InfoHelpTableCell: UITableViewCell {

    @IBOutlet weak var _lblInfoName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblInfoName.font = UIFont(name: "Cairo-Regular", size: _lblInfoName.font.pointSize)
            }
        }

    }
    @IBOutlet weak var icNext: UIImageView!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: icNext)
               

            }
            else{
                Common.sharedInstance.rotateImage(aimg: icNext)
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
    override func layoutSubviews() {
          super.layoutSubviews()

    }
}
