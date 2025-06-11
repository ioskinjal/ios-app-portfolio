//
//  categorySelectionCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 23/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class categorySelectionCell: UITableViewCell {
    @IBOutlet var selectAddress: [UIButton]!
    @IBOutlet weak var lblCategoryHeader: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblCategoryHeader.font = UIFont(name: "Cairo-SemiBold", size: lblCategoryHeader.font.pointSize)
            }
            lblCategoryHeader.text = "accountCategory".localized
        }
    }
    @IBOutlet weak var btnMen: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnMen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            btnMen.setTitle("slideMen".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnWomen: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnWomen.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            btnWomen.setTitle("slideWomen".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnKids: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnKids.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            btnKids.setTitle("slidKids".localized, for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        UserDefaults.standard.setValue(CommonUsed.globalUsed.genderMen, forKey: "category")
//        UserDefaults.standard.setValue(CommonUsed.globalUsed.genderWomen, forKey: "category")
//        UserDefaults.standard.setValue(CommonUsed.globalUsed.genderKids, forKey: "category")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectAddress(_ sender: UIButton) {
        
        for item in selectAddress {
            
            if sender.tag == item.tag {

                UIView.animate(withDuration: 0.3) {
                    sender.backgroundColor = .black
                    sender.setTitleColor(.white, for: .normal)
                    
                }
                switch sender.tag {
                case 1:
                    UserDefaults.standard.setValue(CommonUsed.globalUsed.genderWomen, forKey: "category")
                case 2:
                    UserDefaults.standard.setValue(CommonUsed.globalUsed.genderMen, forKey: "category")
                case 3:
                    UserDefaults.standard.setValue(CommonUsed.globalUsed.genderKids, forKey: "category")
                default:
                    UserDefaults.standard.setValue(CommonUsed.globalUsed.genderWomen, forKey: "category")
                }
                
            }
            else{
                UIView.animate(withDuration: 0.3) {
                    item.backgroundColor = .white
                    item.setTitleColor(.black, for: .normal)
                    
                }
            
            }
        }
        NotificationCenter.default.post(name: Notification.Name(notificationName.changeCategory), object: nil)
    }
    func selectedCategory(aCategory : String){
         if aCategory == "women" {
            btnWomen.backgroundColor = .black
            btnWomen.setTitleColor(.white, for: .normal)
            selectAddress(btnWomen)
        }
        else if aCategory == "men" {
            btnMen.backgroundColor = .black
            btnMen.setTitleColor(.white, for: .normal)
            selectAddress(btnMen)
        }
        else if aCategory == "kids" {
            btnKids.backgroundColor = .black
            btnKids.setTitleColor(.white, for: .normal)
            selectAddress(btnKids)
        }
        else{
            btnWomen.backgroundColor = .black
            btnWomen.setTitleColor(.white, for: .normal)
        }
    }
}
