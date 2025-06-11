//
//  footerOrderReturn.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
@IBDesignable
class footerOrderReturn: UIView {
@IBOutlet weak var contentView: UIView!
    

  
    @IBOutlet weak var headerTitle: UILabel!{
        didSet{
            headerTitle.text = "select_return_item".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                headerTitle.font = UIFont(name: "Cairo-SemiBold", size: headerTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblMsg: UILabel!{
        didSet{
            lblMsg.text = "timeDesc".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMsg.font = UIFont(name: "Cairo-Light", size: lblMsg.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblNeedHelp: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNeedHelp.font = UIFont(name: "Cairo-Regular", size: lblNeedHelp.font.pointSize)
            }
            lblNeedHelp.text = "Need Help".localized.uppercased()
            lblNeedHelp.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var btnNeedhelp: UIButton!
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnContinue.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnContinue.setTitle("CONTINUE".localized, for: .normal)
            btnContinue.addTextSpacing(spacing: 1.5, color: Common.whiteColor)
        }
    }

    
       required init?(coder aDecoder: NSCoder) {
             super.init(coder: aDecoder)
             commonInit()
         }
         override init(frame: CGRect) {
             super.init(frame: frame)
             commonInit()
         }
         override func prepareForInterfaceBuilder() {
             super.prepareForInterfaceBuilder()
             commonInit()
         }
         func commonInit() {
             guard let view = loadViewFromNib() else { return }
             view.frame = self.bounds
             self.addSubview(view)
             contentView = view
         }
         func loadViewFromNib() -> UIView? {
             let bundle = Bundle(for: type(of: self))
             let nib = UINib(nibName: "footerOrderReturn", bundle: bundle)
             return nib.instantiate(withOwner: self, options: nil).first as? UIView
         }
}
