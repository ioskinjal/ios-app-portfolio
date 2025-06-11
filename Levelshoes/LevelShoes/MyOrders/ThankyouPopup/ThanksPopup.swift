//
//  ThanksPopup.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 25/08/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ThanksPopup: UIView {

    @IBOutlet weak var thanksImage: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDesc: UILabel!{
        didSet{
            lblDesc.addTextSpacing(spacing: 0.5)
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
        let nib = UINib(nibName: "thanks", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
