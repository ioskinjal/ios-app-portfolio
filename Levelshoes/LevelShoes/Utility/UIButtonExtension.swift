//
//  UIButtonExtension.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func underlinesButton() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func drawCornerButton() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        self.clipsToBounds = true
//        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    
    }
}




