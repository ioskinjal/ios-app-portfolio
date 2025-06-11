//
//  NeedHelpBtn.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

protocol NeedHelpProtocol {
    func needHelp()
}

class NeedHelpBtn: UITableViewCell {
    
    @IBOutlet weak var btnNeedHelp: UIButton!{
        didSet{
            btnNeedHelp.setTitle("Need Help".localized.uppercased(), for: .normal)
            btnNeedHelp.addTextSpacing(spacing: 1.5, color: Common.blackColor)
        }
    }
    var delegate: NeedHelpProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func needHelp(_ sender: Any) {
        delegate?.needHelp()
    }
}
