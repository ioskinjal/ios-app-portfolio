//
//  saveAddressTableViewCell.swift
//  LevelShoes
//
//  Created by Naveen Wason on 22/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol saveAddressProceed:class{
    func saveAddress()
}
class saveAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    weak var delegate:saveAddressProceed!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.shadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        delegate.saveAddress()
    }
    
}
