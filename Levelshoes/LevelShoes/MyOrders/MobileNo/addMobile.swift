//
//  addMobile.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 20/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class addMobile: UIView {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.addTextSpacing(spacing: 0.5)
        }
    }
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgCountryflag: UIImageView!
    @IBOutlet weak var txtIsdCode: UITextField!
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lblMobileError: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            btnContinue.addTextSpacingButton(spacing: 1.5)
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
        
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "addmobile", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
