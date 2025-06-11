//
//  AboutUsMoreView.swift
//  LevelShoes
//
//  Created by Maa on 08/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import Foundation


class AboutUsMoreView: UIView {

    @IBOutlet weak var _lblVisit : UILabel!{
        didSet{
            _lblVisit.text = validationMessage.aboutVisitUs.localized
            _lblVisit.lineBreakMode = .byWordWrapping
            _lblVisit.numberOfLines = 0
            _lblVisit.textColor = UIColor.black
            let textString = NSMutableAttributedString(string: _lblVisit.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 20)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.35
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblVisit.attributedText = textString
            _lblVisit.sizeToFit()
        }
    }
    @IBOutlet weak var _lblStoreHour : UILabel!{
        didSet{
            _lblStoreHour.text = validationMessage.aboutStoreHour.localized
//            let textLayer = UILabel(frame: CGRect(x: 30, y: 375, width: 82, height: 24))
            _lblStoreHour.lineBreakMode = .byWordWrapping
            _lblStoreHour.numberOfLines = 0
            _lblStoreHour.textColor = UIColor.black
//            let textContent = "Store hours"
            let textString = NSMutableAttributedString(string: _lblStoreHour.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 18)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblStoreHour.attributedText = textString
            _lblStoreHour.sizeToFit()
//            self.view.addSubview(textLayer)
        }
    }
    @IBOutlet weak var _lblWorkingDay : UILabel!{
        didSet{
            _lblWorkingDay.text = validationMessage.aboutWorkingDay.localized
        }
    }
    @IBOutlet weak var _lblWorkingHours : UILabel!{
        didSet{
            _lblWorkingHours.text  = validationMessage.aboutWorkingHour.localized
        }
    }
    @IBOutlet weak var _lblPhoneNumber : UILabel!{
        didSet{
            _lblPhoneNumber.text = validationMessage.aboutPhoneNumber.localized
//            let textLayer = UILabel(frame: CGRect(x: 30, y: 503, width: 105, height: 24))
            _lblPhoneNumber.lineBreakMode = .byWordWrapping
            _lblPhoneNumber.numberOfLines = 0
            _lblPhoneNumber.textColor = UIColor.black
//            let textContent = "Phone number"
            let textString = NSMutableAttributedString(string: _lblPhoneNumber.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 18)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
            _lblPhoneNumber.attributedText = textString
            _lblPhoneNumber.sizeToFit()
        }
    }
    @IBOutlet weak var _lblTollFree : UILabel!{
        didSet{
            _lblTollFree.text = validationMessage.aboutTollFree.localized
        }
    }
    @IBOutlet weak var _lblGuestService : UILabel!{
        didSet{
            _lblGuestService.text = validationMessage.aboutGuestService.localized
        }
    }
    @IBOutlet weak var _lblGuestHour : UILabel!{
        didSet{
            _lblGuestHour.text = validationMessage.aboutGuestHour.localized
        }
    }
    @IBOutlet weak var _lblAddressTitle : UILabel!{
        didSet{
            _lblAddressTitle.text = validationMessage.aboutAddress.localized
//            let textLayer = UILabel(frame: CGRect(x: 30, y: 660, width: 57, height: 24))
            _lblAddressTitle.lineBreakMode = .byWordWrapping
            _lblAddressTitle.numberOfLines = 0
            _lblAddressTitle.textColor = UIColor.black
            let textString = NSMutableAttributedString(string: _lblAddressTitle.text!, attributes: [
                NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 18)!
            ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.33
            textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)

            _lblAddressTitle.attributedText = textString
            _lblAddressTitle.sizeToFit()
        }
    }
    @IBOutlet weak var _lblAddressDetails : UILabel!
    @IBOutlet weak var _btnTollFree : UIButton!{
        didSet{
//            _btnTollFree.titleLabel?.text = validationMessage.
            _btnTollFree.underlinesButton()
        }
    }
    @IBOutlet weak var _btnCloseButton : UIButton!
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
       }
       override func layoutSubviews() {
           super.layoutSubviews()
           commonInit()
       }
       
       func commonInit() {
           
       }
}
