//
//  SubCate/Users/narayanmohapatra/ls-search/levelshoes/LevelShoes/MyOrdersgoryTableViewCell.swift
//  Lev/Users/narayanmohapatra/ls-search/levelshoes/LevelShoes/PLPelShoes
///Users/narayanmohapatra/ls-search/levelshoes/LevelShoes/Utility
//  Created by Maa on 27/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var _lblSearchCategory: UILabel! {
        didSet {
            _lblSearchCategory.lineBreakMode = .byWordWrapping
            _lblSearchCategory.numberOfLines = 0
            _lblSearchCategory.textColor = UIColor.white
            
            let textString = NSMutableAttributedString(string: _lblSearchCategory.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 16)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.5
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblSearchCategory.attributedText = textString
            _lblSearchCategory.sizeToFit()
        }
    }
}
