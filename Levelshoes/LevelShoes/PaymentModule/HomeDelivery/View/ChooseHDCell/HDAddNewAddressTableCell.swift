//
//  HDAddNewAddressTableCell.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol AddNewAddressProtocol {
    func addNewAddress()
}

class HDAddNewAddressTableCell: UITableViewCell {
    @IBOutlet weak var _btnAddNewAddress: UIButton!{
        didSet{
            _btnAddNewAddress.setTitle("addAddress".localized, for: .normal)
            _btnAddNewAddress.addTextSpacing(spacing: 1.5, color: Common.blackColor)
            //_btnAddNewAddress.addTextSpacingButton(spacing: 1.5)
        }
    }
    var delegate: AddNewAddressProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addNewAddressAction(_ sender: UIButton) {
        delegate?.addNewAddress()
    }
}
