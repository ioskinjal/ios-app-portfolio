//
//  MyLocationTableCell.swift
//  LevelShoes
//
//  Created by Maa on 19/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol MyLanguageTableViewCellDelegate {
//    func selectLanguage()
    func selectArabic()
    func selectEnglish()
}

class MyLanguageTableViewCell: UITableViewCell {

    var delegate: MyLanguageTableViewCellDelegate?

    @IBOutlet weak var _btnEnglish: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _btnEnglish.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 15)
            }
        }
    }
    @IBOutlet weak var _btnArbic: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _btnArbic.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 15)
            }
        }
    }
    @IBOutlet var _btnlanguege: [UIButton]!
//        {
//           didSet{
//
//            _btnArbic.setTitleColor(.black, for: .normal)
//            _btnArbic.setBackgroundColor(color: .white , forState: .normal)
//            _btnArbic.setTitleColor(.white, for: .selected)
//            _btnArbic.setBackgroundColor(color: UIColor(hexString: colorHexaCode.btnCreateNormal), forState: .selected)
//           }
//    }
    @IBOutlet weak var _lblLanguage: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                _lblLanguage.font = UIFont(name: "Cairo-SemiBold", size: _lblLanguage.font.pointSize)
            }
            _lblLanguage.text = "accountLanguage".localized
        }
    }
    
    
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
        _btnEnglish.drawCornerButton()
        _btnArbic.drawCornerButton()
//        _btnlanguege.drawCornerButton()
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        _btnlanguege.forEach({ $0.tintColor = UIColor.white })
        sender.tintColor = UIColor.black
    }
    
    @IBAction func tapToSelectEnglish(_ sender: Any) {
        /*
        if _btnEnglish.isSelected == !_btnEnglish.isSelected{
            _btnEnglish.layer.backgroundColor = UIColor.white.cgColor
            _btnEnglish.setTitleColor(.black, for: .normal)

        }else{
            _btnEnglish.layer.backgroundColor = UIColor.black.cgColor
            _btnEnglish.setTitleColor(.white, for: .normal)
            _btnArbic.isSelected = false
            _btnArbic.layer.backgroundColor = UIColor.white.cgColor
            _btnArbic.setTitleColor(.black, for: .normal)
            delegate?.selectEnglish()


        }
 */
        delegate?.selectEnglish()
    }
    @IBAction func tapToSelectArbic(_ sender: Any) {
        /*
        if _btnArbic.isSelected == !_btnArbic.isSelected {
            _btnArbic.layer.backgroundColor = UIColor.white.cgColor
            _btnArbic.setTitleColor(.black, for: .normal)

        }else{
            _btnArbic.layer.backgroundColor = UIColor.black.cgColor
            _btnArbic.setTitleColor(.white, for: .normal)
            _btnEnglish.isSelected = false
            _btnEnglish.layer.backgroundColor = UIColor.white.cgColor
            _btnEnglish.setTitleColor(.black, for: .normal)
            delegate?.selectArabic()


        }
 */
        delegate?.selectArabic()
    }
}
