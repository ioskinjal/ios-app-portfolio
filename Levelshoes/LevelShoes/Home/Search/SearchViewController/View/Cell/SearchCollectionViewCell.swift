//
//  SearchCollectionViewCell.swift
//  LevelShoes
//
//  Created by Maa on 26/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!{
        didSet{

            _lblTitle.lineBreakMode = .byWordWrapping
            _lblTitle.numberOfLines = 0
            _lblTitle.textColor = UIColor.white
            let textString = NSMutableAttributedString(string: _lblTitle.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 12)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.5
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.kern, value: 1.07, range: textRange)
            _lblTitle.attributedText = textString
            _lblTitle.sizeToFit()
        }
    }
    @IBOutlet weak var _lblSubTitle: UILabel!{
        didSet{
            _lblSubTitle.lineBreakMode = .byWordWrapping
            _lblSubTitle.numberOfLines = 0
            _lblSubTitle.textColor = UIColor.white
            let textString = NSMutableAttributedString(string: _lblSubTitle.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 14)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.57
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblSubTitle.attributedText = textString
            _lblSubTitle.sizeToFit()
        }
    }
    @IBOutlet weak var _lblPrice: UILabel!{
        didSet{
            _lblPrice.lineBreakMode = .byWordWrapping
            _lblPrice.numberOfLines = 0
            _lblPrice.textColor = UIColor.white
            let textString = NSMutableAttributedString(string: _lblPrice.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 12)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2.25
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblPrice.attributedText = textString
            _lblPrice.sizeToFit()
        }
        
    }
    
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var _lblexclusiv: UILabel!{
        didSet{
            _lblexclusiv.layer.cornerRadius = 2
            _lblexclusiv.backgroundColor = UIColor.white
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
