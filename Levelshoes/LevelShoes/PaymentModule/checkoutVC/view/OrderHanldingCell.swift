//
//  OrderHanldingCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

protocol HomeDeliveryProtocol {
    func homeDelivery()
}

class OrderHanldingCell: UITableViewCell {
    @IBOutlet weak var lblHomeDelivery: UILabel!{
        didSet{
            lblHomeDelivery.text = "home_delivery".localized
        }
    }
    @IBOutlet weak var btnArrow: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                Common.sharedInstance.backtoOriginalButton(aBtn: btnArrow)
                 
            }
            else{
                Common.sharedInstance.rotateButton(aBtn: btnArrow)
                
            }
        }
    }
    
    @IBOutlet weak var lblYouCanGet: UILabel!{
        didSet{
            lblYouCanGet.text = "get_on_time".localized
        }
    }
    @IBOutlet weak var lblUaeDelivery: UILabel!{
        didSet{
            lblUaeDelivery.text = "uaeDelivery".localized
        }
    }
    
    @IBOutlet weak var lblGccDelivery: UILabel!{
        didSet{
            lblGccDelivery.text = "gccDelivery".localized
        }
    }
    @IBOutlet weak var lblOrderHandling: UILabel!{
        didSet{
            lblOrderHandling.text = "Order_handling".localized
        }
    }
    
    @IBOutlet weak var backView:UIView!
    var delegate: HomeDeliveryProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.shadowRadius = 2
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func homeDeliveryButtonAction(_ sender: Any) {
        delegate?.homeDelivery()
    }
}
