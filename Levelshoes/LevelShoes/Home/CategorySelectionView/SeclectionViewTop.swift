//
//  SeclectionViewTop.swift
//  LevelShoes
//
//  Created by Maa on 23/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import Foundation

class SeclectionViewTop: UIView {

    @IBOutlet weak var _lblYouARe: UILabel!{
        didSet{
            
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
             _lblYouARe.addTextSpacing(spacing: 1.0)
            }
            else{
                _lblYouARe.text = validationMessage.youAreIn.localized
            }
        }
    }
    @IBOutlet weak var _lblContryName: UILabel!{
        didSet{
            _lblContryName.textColor = UIColor(hexString: "FFFFFF")
        }
    }
    @IBOutlet weak var imgFlag: UIImageView!

    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
       }
       override func layoutSubviews() {
           super.layoutSubviews()
       }
    
    func commonInit() {
        _lblYouARe.alpha = 1.0
        _lblContryName.alpha = 1.0
//        let layer = CALayer()
//      let layer1 =  layer.applyGradient(of: UIColor.yellow, UIColor.blue, atAngle: 180)
//        self.layer.addSublayer(layer1)
    }
}
