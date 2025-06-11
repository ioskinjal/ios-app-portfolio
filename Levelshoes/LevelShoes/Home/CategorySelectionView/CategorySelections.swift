//
//  CategorySelections.swift
//  LevelShoes
//
//  Created by Maa on 23/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class CategorySelections: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if isRTL() {
            var font = _btnWomen.titleLabel?.font
            if let fn = font?.fontName, let pointSize = font?.pointSize {
                font = UIFont(name: fn, size: pointSize * 2)
                _btnWomen.titleLabel?.font = font
                _btnKids.titleLabel?.font = font
                _btnMen.titleLabel?.font = font
            }
        }
        _btnMen.layer.cornerRadius = 2
        _btnMen.layer.masksToBounds = true
        _btnWomen.layer.cornerRadius = 2
        _btnWomen.layer.masksToBounds = true
        _btnKids.layer.cornerRadius = 2
        _btnKids.layer.masksToBounds = true
    }
    
    @IBOutlet weak var _btnWomen: UIButton!{
        didSet{
            _btnWomen.setTitle(validationMessage.slideWomen.localized, for: .normal)
            _btnWomen.setTitleColor(UIColor(hexString: colorHexaCode.btnCreateNormal), for: .normal)
            
            //            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            //                _btnWomen.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            //            }
        }
    }
    @IBOutlet weak var _btnMen: UIButton!{
        didSet{
            _btnMen.setTitle(validationMessage.slideMen.localized, for: .normal)
            _btnMen.setTitleColor(UIColor(hexString: colorHexaCode.btnCreateNormal), for: .normal)
            //            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            //                _btnMen.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            //            }
        }
    }
    @IBOutlet weak var _btnKids: UIButton!{
        didSet{
            _btnKids.setTitle(validationMessage.slidKids.localized, for: .normal)
            _btnKids.setTitleColor(UIColor(hexString: colorHexaCode.btnCreateNormal), for: .normal)
            //            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            //                _btnKids.addTextSpacing(spacing: 1.5, color: colorHexaCode.addTextSpacing)
            //            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        spacingtext()
        commonInit()
    }
    func spacingtext(){
        if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            _btnKids.addTextSpacing(spacing: 1.5,color: "000000")
            _btnMen.addTextSpacing(spacing: 1.5, color:"000000")
            _btnWomen.addTextSpacing(spacing: 1.5, color:"000000")
            
        }
    }
    func commonInit() {
        _btnKids.titleLabel?.alpha = 1
        _btnMen.titleLabel?.alpha = 1
        _btnWomen.titleLabel?.alpha = 1
        
    }
    
    
}
