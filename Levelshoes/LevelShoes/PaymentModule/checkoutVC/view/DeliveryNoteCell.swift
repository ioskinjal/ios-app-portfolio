//
//  DeliveryNoteCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

protocol DeliveryNotesProtocol {
    func collectAndPayAction()
}

class DeliveryNoteCell: UITableViewCell {
    
    @IBOutlet weak var lblcolectItem: UILabel!{
        didSet{
            lblcolectItem.text = "collect_item".localized
        }
    }
    @IBOutlet weak var lblClickCollect: UILabel!{
        didSet{
            lblClickCollect.text = "click_connect".localized
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
    @IBOutlet weak var lblSomthing: UILabel!{
        didSet{
            lblSomthing.text = "keepinMind".localized
        }
    }
    @IBOutlet weak var lblStandardDeliveries: UILabel!{
        didSet{
            lblStandardDeliveries.text = "delivery_time".localized
        }
    }
    var delegate: DeliveryNotesProtocol?
    @IBOutlet weak var collectBackView:UIView!
    @IBOutlet weak var lblSomething: UILabel!{
        didSet{
            lblSomething.text = "Some things to keep in mind:".localized
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectBackView.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func collectAndPayAction(_ sender: UIButton) {
        delegate?.collectAndPayAction()
    }
}
