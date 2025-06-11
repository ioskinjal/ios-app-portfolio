//
//  faqServiceCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class faqServiceCell: UITableViewCell {
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var sepratorLine: UIView!
    @IBOutlet weak var lblQuestion: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblQuestion.font = UIFont(name: "Cairo-Regular", size: 17)
            }else{
                lblQuestion.font = UIFont(name: "BrandonGrotesque-Regular", size: 18)
            }//
        }
    }
    @IBOutlet weak var lblDetail: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDetail.font = UIFont(name: "Cairo-Light", size: 17)
            }else{
                lblDetail.font = Common.sharedInstance.brandonLight(asize: 18)
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

