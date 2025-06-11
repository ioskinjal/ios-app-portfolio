//
//  DetailCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var customLine: UIView!
    @IBOutlet weak var productImage: UIImageView!
       
       @IBOutlet weak var lblProductName: UILabel!{
           didSet{
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                 lblProductName.addTextSpacing(spacing: 1.07)
               }else{
                lblProductName.font = UIFont(name: "Cairo-SemiBold", size: lblProductName.font.pointSize)
            }
           }
       }
    @IBOutlet weak var lblQty: InsetLabel!
       @IBOutlet weak var btnInc: UIButton!
       @IBOutlet weak var btnDec: UIButton!
       @IBOutlet weak var lblMaterailType: UILabel!{
           didSet{
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    lblMaterailType.font = UIFont(name: "Cairo-Light", size: lblMaterailType.font.pointSize)
               }
           }
       }
       @IBOutlet weak var lblPrice: UILabel!{
           didSet{
               if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                    lblPrice.font = UIFont(name: "Cairo-Light", size: lblPrice.font.pointSize)
               }
           }
       }
       @IBOutlet weak var lblSizeTitle: UILabel!{
           didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                 lblSizeTitle.font = UIFont(name: "Cairo-Light", size: lblSizeTitle.font.pointSize)
            }
               lblSizeTitle.text = "basket_size".localized
           }
       }
    @IBOutlet weak var lblSizeNumber: InsetLabel!
    @IBOutlet weak var lblQtyTitle: UILabel! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                 lblQtyTitle.font = UIFont(name: "Cairo-Light", size: lblQtyTitle.font.pointSize)
            }
            lblQtyTitle.text = "qty".localized
        }
    }
    @IBOutlet weak var lblQtyValue: UILabel!
    @IBOutlet weak var btnPrev: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnPrev)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnPrev)
            }
        }
    }
    @IBOutlet weak var btnNext: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnNext)
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnNext)
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
