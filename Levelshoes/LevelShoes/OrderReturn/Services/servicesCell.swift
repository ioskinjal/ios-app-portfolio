//
//  servicesCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 07/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class servicesCell: UITableViewCell {

    @IBOutlet weak var coverView: UIView!{
        didSet{
            coverView.alpha = 0.5
            coverView.layer.cornerRadius = 2
            coverView.backgroundColor = UIColor.white
            coverView.layer.shadowOffset = CGSize(width: 0, height: 8)
            coverView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
            coverView.layer.shadowOpacity = 1
            coverView.layer.shadowRadius = 16
        }
    }
    @IBOutlet weak var viewShadow: UIView!{
        didSet{
           
            viewShadow.layer.cornerRadius = 2
            viewShadow.backgroundColor = UIColor.white
            viewShadow.layer.shadowOffset = CGSize(width: 0, height: 8)
            viewShadow.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.04).cgColor
            viewShadow.layer.shadowOpacity = 1
            viewShadow.layer.shadowRadius = 16

        }
    }
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
            
        }
    }
    @IBOutlet weak var lblMsg: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMsg.font = UIFont(name: "Cairo-Light", size: 14)
            }
            
        }
    }
    @IBOutlet weak var container: UIView!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
          //container.layer.cornerRadius = 2
          container.backgroundColor = UIColor.white
          container.layer.shadowOffset = CGSize(width: 0, height: 8)
          container.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
          container.layer.shadowOpacity = 1
          container.layer.shadowRadius = 16
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.5) { self.coverView.alpha = 0.5  }
        }
        else{
            UIView.animate(withDuration: 0.5) { self.coverView.alpha = 0.0  }
        }


    }

}
