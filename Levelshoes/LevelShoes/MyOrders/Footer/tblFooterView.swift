//
//  tblFooterView.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class tblFooterView: UIView {
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var btnNeedHelp: UIButton!
    @IBOutlet weak var lblNeedHelp: UILabel!{
            didSet{
                if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                    lblNeedHelp.font = UIFont(name: "Cairo-Regular", size: lblNeedHelp.font.pointSize)
                }
                lblNeedHelp.text = "Need Help".localized
                lblNeedHelp.addTextSpacing(spacing: 1.5)
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
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "tblFooterView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
