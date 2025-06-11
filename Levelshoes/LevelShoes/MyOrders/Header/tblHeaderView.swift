//
//  tblHeaderView.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class tblHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblOrdersTitle: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblOrdersTitle.font = UIFont(name: "Cairo-SemiBold", size: lblOrdersTitle.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblNumbersofOrder: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNumbersofOrder.font = UIFont(name: "Cairo-Light", size: lblNumbersofOrder.font.pointSize)
            }
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
        let nib = UINib(nibName: "tblHeaderVIew", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
