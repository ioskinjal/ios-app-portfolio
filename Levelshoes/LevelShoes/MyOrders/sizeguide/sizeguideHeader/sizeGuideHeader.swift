//
//  sizeGuideHeader.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 20/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class sizeGuideHeader: UIView {
    
    @IBOutlet weak var lblMenWomenSizes: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblMenWomenSizes.font = UIFont(name: "Cairo-SemiBold", size: lblMenWomenSizes.font.pointSize)
            }
        }
    }
    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet weak var lblEU: UILabel!{
        didSet{
            lblEU.text = "EU".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblEU.textAlignment = .right
                lblEU.font = UIFont(name: "Cairo-SemiBold", size: lblEU.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblUK: UILabel!{
        didSet{
            lblUK.text = "UK".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblUK.font = UIFont(name: "Cairo-SemiBold", size: lblUK.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblUS: UILabel!{
        didSet{
            lblUS.text = "US".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblUS.textAlignment = .left
                lblUS.font = UIFont(name: "Cairo-SemiBold", size: lblUS.font.pointSize)
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
        let nib = UINib(nibName: "sizeHeader", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
