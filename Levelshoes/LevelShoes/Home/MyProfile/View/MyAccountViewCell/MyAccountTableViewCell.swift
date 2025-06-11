//
//  MyAccountTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class MyAccountTableViewCell: UITableViewCell {

//    static let identifier = MyAccountTableViewCell.name
//    static let nib = UINib(nibName: MyAccountTableViewCell.name, bundle: nil)
    
    @IBOutlet weak var btnOrderreturn: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnOrderreturn)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnOrderreturn)
            
            }
        }
    }
    @IBOutlet weak var btnNotification: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnNotification)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnNotification)
            
            }
        }
    }
    @IBOutlet weak var btnDetail: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnDetail)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnDetail)
            
            }
        }
    }
    @IBOutlet weak var btnPrefs: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnPrefs)

            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnPrefs)
            
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
    @IBAction func orderReturnsSelector(_ sender: UIButton) {
        print("Inside Order and Return selector!")
        let storyboard = UIStoryboard(name: "Myorders", bundle: Bundle.main)
        let changeVC: MyOrdersVC! = storyboard.instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC
        let nav = UINavigationController()
        nav.pushViewController(changeVC, animated: true)
    
    }
    
}
