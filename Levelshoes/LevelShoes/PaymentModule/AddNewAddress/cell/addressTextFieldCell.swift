//
//  addressTextFieldCell.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import UIKit

protocol addressTextDelegate : class {
    func addressText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
}

class addressTextFieldCell: UITableViewCell {
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var dropDownIcon: UIImageView!
    @IBOutlet weak var dropDownBtnOutlet: UIButton!
    
    weak var delegate:addressTextDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension addressTextFieldCell:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.delegate.addressText(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        return true
    }
}
