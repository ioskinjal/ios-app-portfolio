//
//  ViewAllProCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 17/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
 
class ViewAllProCell: UICollectionViewCell {
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblViewAll: UILabel!{
        didSet{
             //   lblViewAll.text = validationMessage.viewAllCollection.localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                customizeForEn()
            }
            else{
                lblViewAll.text = validationMessage.viewAllCollection.localized
            }
        }
    }
    
    func customizeForEn() {
        let textLayer = lblViewAll
        textLayer?.lineBreakMode = .byWordWrapping
        textLayer?.numberOfLines = 0
        textLayer?.textColor = UIColor.black
        let textContent = "VIEW ALL COLLECTION"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedStringKey.font: UIFont(name: "BrandonGrotesque-Medium", size: 14)!
        ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.43
        textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: textRange)
        textLayer?.attributedText = textString
        textLayer?.sizeToFit()
    }
}
