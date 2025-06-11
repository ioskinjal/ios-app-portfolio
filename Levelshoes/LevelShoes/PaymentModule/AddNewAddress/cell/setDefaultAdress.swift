//
//  setDefaultAdress.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit
protocol DefaultAddressProtocol {
    func defaultAddress()
}

class setDefaultAdress: UITableViewCell {
    
    @IBOutlet weak var defaultAddressBtnOutlet: UIButton!
    var delegate: DefaultAddressProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func defaultBillingAddressSwitch(_ sender: Any) {
        delegate?.defaultAddress()
    }
}
