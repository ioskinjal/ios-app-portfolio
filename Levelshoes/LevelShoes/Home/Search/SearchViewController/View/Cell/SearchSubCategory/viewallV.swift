//
//  viewallV.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 22/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class viewallV: UIView {
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var lblViewAll: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblViewAll.font = UIFont(name: "Cairo-Regular", size: lblViewAll.font.pointSize)
            }
            lblViewAll.addTextSpacing(spacing: 1.5)
            
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
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "viewall", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
