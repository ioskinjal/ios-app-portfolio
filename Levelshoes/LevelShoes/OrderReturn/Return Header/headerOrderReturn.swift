//
//  headerOrderReturn.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 06/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

@IBDesignable
class headerOrderReturn: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblSelectItems: UILabel!{
        didSet{
            lblSelectItems.text = "selectItem".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblSelectItems.font = UIFont(name: "Cairo-SemiBold", size: lblSelectItems.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblPickup: UILabel!{
        didSet{
            lblPickup.text = "pickup".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblPickup.font = UIFont(name: "Cairo-SemiBold", size: lblPickup.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblReturn: UILabel!{
        didSet{
            lblReturn.text = "returned".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblReturn.font = UIFont(name: "Cairo-SemiBold", size: lblReturn.font.pointSize)
                lblReturn.textAlignment = .left
            }
        }
    }
    
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
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMsg.font = UIFont(name: "Cairo-Light", size: lblMsg.font.pointSize)
            }
            lblMsg.text = "returnDesc".localized
            lblMsg.addTextSpacing(spacing: 0.5)
        }
    }
    
    
    @IBOutlet weak var btnSelectitem: UIButton!
    @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    
    
    @IBInspectable var opTitle: String? {
       didSet {
        self.headerTitle.text = opTitle
       }
    }
    @IBInspectable var opMessage: String? {
       didSet {
        self.lblMsg.text = opMessage
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
            let nib = UINib(nibName: "headerOrderReturn", bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as? UIView
        }


}
