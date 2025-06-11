//
//  returnItemHeader.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 17/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class returnItemHeader: UIView {
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblTitle.addTextSpacing(spacing: 1.0)
            }else{
                lblTitle.font = UIFont(name: "Cairo-SemiBold", size: lblTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblSizeTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSizeTitle.font = UIFont(name: "Cairo-Light", size: lblSizeTitle.font.pointSize)
            }
            lblSizeTitle.text = "basket_size".localized
        }
    }
    @IBOutlet weak var lblQtytitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblQtytitle.font = UIFont(name: "Cairo-Light", size: lblQtytitle.font.pointSize)
            }

            lblQtytitle.text = "qty".localized
        }
    }
    
    @IBOutlet weak var lblSelect: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSelect.font = UIFont(name: "Cairo-SemiBold", size: lblSelect.font.pointSize)
            }
            lblSelect.text = "select_reason".localized
        }
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSubtitle.font = UIFont(name: "Cairo-Light", size: lblSubtitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblQty: InsetLabel!
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
            
         }
         func loadViewFromNib() -> UIView? {
             let bundle = Bundle(for: type(of: self))
             let nib = UINib(nibName: "returnitemheader", bundle: bundle)
             return nib.instantiate(withOwner: self, options: nil).first as? UIView
         }
}
