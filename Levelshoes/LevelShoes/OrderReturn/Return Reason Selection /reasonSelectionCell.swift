//
//  reasonSelectionCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 07/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class reasonSelectionCell: UITableViewCell {

    @IBOutlet weak var buttonSelect: UIButton!
    @IBOutlet weak var lblReason: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReason.font = UIFont(name: "Cairo-Light", size: lblReason.font.pointSize)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
      //  buttonSelect.isHidden =  selected ? false : true
      //  lblReason.font = selected ? UIFont(name:"BrandonGrotesque-Medium", size: 18) : UIFont(name:"BrandonGrotesque-Light", size: 18)

    }

}
