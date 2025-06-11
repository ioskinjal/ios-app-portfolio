//
//  headerView.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 29/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
 
@IBDesignable
class headerView: UIView {
   
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            headerTitle.addTextSpacing(spacing: 1.5)
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                headerTitle.font = UIFont(name: "Cairo-SemiBold", size: headerTitle.font.pointSize)
            }
        }
    }
    @IBInspectable var opTitle: String? {
       didSet {
        self.headerTitle.text = opTitle
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
            let nib = UINib(nibName: "headerView", bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as? UIView
        }
}
