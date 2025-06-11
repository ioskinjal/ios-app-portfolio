//
//  miscCell.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 27/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import DTTextField
class miscCell: UITableViewCell {
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var flagWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var txtField: DTTextField!{
        didSet{
            txtField.dtLayer.isHidden = true
            txtField?.floatPlaceholderFont = BrandenFont.thin(with: 14.0)
            txtField?.floatPlaceholderActiveColor = .lightGray
            txtField?.floatPlaceholderColor = colorNames.placeHolderColor
        }
    }
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblError: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setName(name : String){
        //txtField.placeHolder(text:name, textfieldname: txtField)
        txtField.text = name
    }
}
