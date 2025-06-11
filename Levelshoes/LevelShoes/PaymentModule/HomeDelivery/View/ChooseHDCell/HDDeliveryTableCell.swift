//
//  HDDeliveryTableCell.swift
//  LevelShoes
//
//  Created by Maa on 10/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol HDDeliverySelectionProtocol {
    //func selectAddress(index: Int, isChecked: Bool)
    func didToggleRadioButton(_ cell: HDDeliveryTableCell)
    //func editAcdres()
}


class HDDeliveryTableCell: UITableViewCell {
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var _lblAddressType: UILabel!{
        didSet{
            _lblAddressType.text = "home".localized
        }
    }
    @IBOutlet weak var datailAddressLabel: UILabel!
    @IBOutlet weak var radioBtnOutlet: UIButton!
    
    @IBOutlet weak var lblEditYourAddress: UILabel!{
        didSet{
            lblEditYourAddress.text = "edit_address".localized
            lblEditYourAddress.underline()
        }
    }
    @IBOutlet weak var _viewHome: UIView!
    var delegate: HDDeliverySelectionProtocol?
    var rowNo: Int?
    var isCheck: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func cellConfiguration(rowNumber: Int, isSelected: Bool){
        rowNo = rowNumber
        isCheck = isSelected
            radioBtnOutlet.setImage(UIImage(named: "radio_on"), for: .selected)
            radioBtnOutlet.setImage(UIImage(named: "radio_off"), for: .normal)
    }
    
    @IBAction func buttonHomeSelectAction(_ sender: UIButton) {
        delegate?.didToggleRadioButton(self)
        self._viewHome.backgroundColor = UIColor(hexString: "FFFFFF")
    }
    @IBAction func editAddressAction(_ sender: UIButton) {
       // delegate?.editAcdres()
    }
}
