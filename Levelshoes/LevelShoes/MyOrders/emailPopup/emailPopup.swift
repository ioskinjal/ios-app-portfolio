//
//  emailPopup.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/09/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol emailPopupDelegate : class {
    func continuousBtnAction(emailPopupVC :emailPopupVC)
}
class emailPopup: UIView {
     weak var emailPopupDelegate : emailPopupDelegate?
    @IBOutlet weak var lblemailTitle: UILabel!
    @IBOutlet weak var lblEmalDesc: UILabel!{
        didSet{
            lblEmalDesc.addTextSpacing(spacing: 0.5)
        }
    }
    
    @IBOutlet weak var txtEmail: RMTextField!{
        didSet{
            txtEmail.floatPlaceholderActiveColor = colorNames.placeHolderColor
            txtEmail.dtLayer.isHidden = true
        }
    }
    
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
        let nib = UINib(nibName: "emailpopup", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
