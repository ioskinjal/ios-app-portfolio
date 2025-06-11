//
//  ApplePayTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 18/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol applePayProtocol {
    func applePayEnable()
}

class ApplePayTableViewCell: UITableViewCell {

    @IBOutlet weak var applePayCheckBtnOutlet: UIButton!
    
    @IBOutlet weak var viewBg: UIView!
    
    var delegate: applePayProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func applePayAction(_ sender: UIButton) {
        delegate?.applePayEnable()
    }
}
