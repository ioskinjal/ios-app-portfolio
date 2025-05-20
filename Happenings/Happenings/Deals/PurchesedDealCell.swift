//
//  PurchesedDealCell.swift
//  Happenings
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PurchesedDealCell: UITableViewCell {

    @IBOutlet weak var viewContact: UIView!{
        didSet{
            //            DispatchQueue.main.async {
            self.viewContact.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewContact.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewContact.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewContact.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
            //            }
        }
    }
    @IBOutlet weak var viewEmail: UIView!{
        didSet{
            //            DispatchQueue.main.async {
            self.viewEmail.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewEmail.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewEmail.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewEmail.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
            //            }
        }
    }
    @IBOutlet weak var viewDate: UIView!{
        didSet{
            //            DispatchQueue.main.async {
            self.viewDate.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewDate.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewDate.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewDate.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
            //            }
        }
    }
    @IBOutlet weak var viewMerchantName: UIView!{
        didSet{
            //            DispatchQueue.main.async {
            self.viewMerchantName.border(side: .left, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewMerchantName.border(side: .right, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewMerchantName.border(side: .top, color: UIColor.lightGray, borderWidth: 1.0)
            self.viewMerchantName.border(side: .bottom, color: UIColor.init(hexString: "E0171E"), borderWidth: 2.0)
            //            }
        }
    }
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgDeal: UIImageView!
    
    @IBOutlet weak var lblDealName: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblPriceReal: UILabel!
    
    @IBOutlet weak var lblOldPrice: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMerchantName: UILabel!
    
    @IBOutlet weak var lblMerchantEmail: UILabel!
    
    @IBOutlet weak var lblMerchantContact: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
