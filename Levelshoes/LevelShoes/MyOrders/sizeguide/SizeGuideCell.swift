//
//  SizeGuideCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 15/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SizeGuideCell: UITableViewCell {
    @IBOutlet weak var lblEUsize: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEUsize.textAlignment = .right
                //lblEUsize.font = UIFont(name: "Cairo-Light", size: lblEUsize.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblUKsize: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                //lblUKsize.font = UIFont(name: "Cairo-Light", size: lblUKsize.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblUSsize: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblUSsize.textAlignment = .left
                //lblUSsize.font = UIFont(name: "Cairo-Light", size: lblUSsize.font.pointSize)
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
    
     public func setdata(eu:String , uk:String , us:String) {
        //Update all data Here
        lblEUsize.text = eu
        lblUKsize.text = uk
        lblUSsize.text = us
    }

}
