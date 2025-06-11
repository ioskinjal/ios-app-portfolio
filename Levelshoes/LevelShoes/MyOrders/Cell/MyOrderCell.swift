//
//  MyOrderCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var ordersImage: UIImageView!
    @IBOutlet weak var lblViewOrders: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblViewOrders.font = UIFont(name: "Cairo-Light", size: lblViewOrders.font.pointSize)
            }
            lblViewOrders.text = "viewOrderDetails".localized
            lblViewOrders.underline()
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDate.font = UIFont(name: "Cairo-Light", size: lblDate.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblItemsCount: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblItemsCount.addTextSpacing(spacing: 1.07)
            }else{
                lblItemsCount.font = UIFont(name: "Cairo-Regular", size: lblItemsCount.font.pointSize)
            }
        }
    }

    @IBOutlet weak var lblOrderMode: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblOrderMode.font = UIFont(name: "Cairo-Light", size: lblOrderMode.font.pointSize)
            }
            lblOrderMode.text = "online_order".localized
        }
    }
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblStatus: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblStatus.addTextSpacing(spacing: 1.0)
            }
            else{
                lblStatus.font = UIFont(name: "Cairo-SemiBold", size: lblStatus.font.pointSize)
            }
        }
    }
    @IBOutlet weak var viewIndicator: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
