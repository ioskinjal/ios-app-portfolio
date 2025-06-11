//
//  DeliveryCell.swift
//  LevelShoes
//
//  Created by Maa on 11/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class DeliveryCell: UITableViewCell {
    @IBOutlet weak var _lblAddressType: UILabel!{
        didSet{
            _lblAddressType.lineBreakMode = .byWordWrapping
            _lblAddressType.numberOfLines = 0
            _lblAddressType.textColor = UIColor.black
//            let textContent = "Home"
            let textString = NSMutableAttributedString(string: _lblAddressType.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 18)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblAddressType.attributedText = textString
            _lblAddressType.sizeToFit()
        }
    }
    @IBOutlet weak var _lblAddressDetails: UILabel!{
        didSet{
            _lblAddressDetails.lineBreakMode = .byWordWrapping
            _lblAddressDetails.numberOfLines = 0
            _lblAddressDetails.textColor = UIColor.black
            let textString = NSMutableAttributedString(string: _lblAddressDetails.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Light", size: 16)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.5
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblAddressDetails.attributedText = textString
            _lblAddressDetails.sizeToFit()
        }
    }
    @IBOutlet weak var _btnRadioHomeSelection: UIButton!
    @IBOutlet weak var _btnEditAddress: UIButton!{
        didSet{
            _btnEditAddress.setTitle("Edit your address".localized, for: .normal)
        }
    }
     @IBOutlet weak var _viewHome: UIView!
    var shouldSelectRow: ((DeliveryCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _btnEditAddress.underlinesButton()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        contentView.frame = contentView.frame.insetBy(dx: 20, dy: 40)
    }

}
