//
//  orderDetailCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class orderDetailCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    
     @IBOutlet weak var incrementBtn: UIButton!
    @IBOutlet weak var decrementBtn: UIButton!
    
    
    
   
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var viewSingleQty: UIView!
    @IBOutlet weak var viewMultiQty: UIView!
    
    @IBOutlet weak var lblProductName: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblProductName.addTextSpacing(spacing: 1.07)
            }else{
                lblProductName.font = UIFont(name: "Cairo-SemiBold", size: lblProductName.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblMaterailType: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMaterailType.font = UIFont(name: "Cairo-Light", size: lblMaterailType.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSizeTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSizeTitle.font = UIFont(name: "Cairo-Light", size: lblSizeTitle.font.pointSize)
            }
            lblSizeTitle.text = "basket_size".localized
        }
    }
    @IBOutlet weak var lblSizeNumber: UILabel!
    @IBOutlet weak var lblQtyTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblQtyTitle.font = UIFont(name: "Cairo-Light", size: lblQtyTitle.font.pointSize)
            }
            lblQtyTitle.text = "qty".localized
        }
    }
    @IBOutlet weak var lblQtyValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        

    }
    
}
