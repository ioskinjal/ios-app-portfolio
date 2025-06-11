//
//  InformationCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit
protocol InformationProtocol {
    func showInformation()
}

class InformationCell: UITableViewCell {

    var delegate: InformationProtocol?
    
    @IBOutlet weak var lblStoreInfo: UILabel!{
        didSet{
            lblStoreInfo.text = "store_info".localized
            lblStoreInfo.underline()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func dubaiMallInformationAction(_ sender: Any) {
        delegate?.showInformation()
    }
}
