//
//  DealOrderCell.swift
//  Happenings
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class DealOrderCell: UITableViewCell {
    @IBOutlet weak var imgdeal: CurvedUIImageView!
    @IBOutlet weak var lblDealTitle: UILabel!
    @IBOutlet weak var imgMerchant: UIImageView!{
        didSet{
            imgMerchant.setRadius()
        }
    }
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var stackViewReceivePayment: UIStackView!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnReceivedPayment: UIButton!
    
    @IBOutlet weak var lblPaid: UILabel!
    
    @IBOutlet weak var btnPDF: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
