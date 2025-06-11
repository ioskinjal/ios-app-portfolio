//
//  babysizeGuideHeader.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 22/10/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class babysizeGuideHeader: UIView {

    @IBOutlet weak var lblBabySizes: UILabel!{
        didSet{
            lblBabySizes.text = "babySize".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBabySizes.font = UIFont(name: "Cairo-SemiBold", size: lblBabySizes.font.pointSize)
            }
        }
    }
    @IBOutlet weak var viewSeprator: UIView!
    
    @IBOutlet weak var lblAge: UILabel!{
        didSet{
            lblAge.text = "age".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblAge.textAlignment = .right
                lblAge.font = UIFont(name: "Cairo-SemiBold", size: lblAge.font.pointSize)
            }
        }
    }
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
        let nib = UINib(nibName: "babysizeHeader", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }


}
