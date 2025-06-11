//
//  AddressNameCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

protocol AddrerssNameProtocol {
    func work()
    func home()
    func other()
}

class AddressNameCell: UITableViewCell {

    @IBOutlet weak var otherBtnOutlet: UIButton!
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var workBtnOutlet: UIButton!
    
    var delegate: AddrerssNameProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func workAction(_ sender: Any) {
        delegate?.work()
    }
    @IBAction func homeAction(_ sender: Any) {
        delegate?.home()
    }
    @IBAction func otherAction(_ sender: Any) {
        delegate?.other()
    }
}
