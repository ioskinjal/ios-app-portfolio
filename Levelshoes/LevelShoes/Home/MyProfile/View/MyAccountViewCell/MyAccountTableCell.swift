//
//  MyAccountTableCell.swift
//  LevelShoes
//
//  Created by Maa on 20/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class MyAccountTableCell: UITableViewCell {

    @IBOutlet weak var _lblName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblName.font = UIFont(name: "Cairo-Regular", size: _lblName.font.pointSize)
            }
        }
    }
    @IBOutlet weak var imgNext: UIImageView!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalImage(aimg: imgNext)
               

            }
            else{
                Common.sharedInstance.rotateImage(aimg: imgNext)
                

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
