//
//  needHelp.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 02/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
@IBDesignable
 class needHelp: UIView {
    
    @IBInspectable var nibName:String?
    /*@IBInspectable var title : string? {
        get{
            return title.t
        }
    }*/

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTittle: UILabel!{
        didSet{
            lblTittle.text = "Need Help".localized
        }
    }
    @IBOutlet weak var lblWorkingHrs: UILabel!{
        didSet{
            lblWorkingHrs.text = "working_hrs".localized
            lblWorkingHrs.addTextSpacing(spacing: 1.33)
        }
    }
    @IBOutlet weak var lblCallUs: UILabel!{
        didSet{
            lblCallUs.text = "callus".localized
            lblCallUs.addTextSpacing(spacing: 1.33)
        }
    }
    @IBOutlet weak var lblRegulatDays: UILabel!{
        didSet{
            lblRegulatDays.text = "regularDays".localized
           lblRegulatDays.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblRegulatTime: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblRegulatTime.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblweekDays: UILabel!{
        didSet{
            lblweekDays.text = "weekDays".localized
            lblweekDays.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblWeekTime: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblWeekTime.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblTollFree: UILabel!{
        didSet{
            lblTollFree.text = "tollFree".localized
            lblTollFree.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblTollFreeNo: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblTollFreeNo.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var lblGuestServiceHrs: UILabel!{
        didSet{
            lblGuestServiceHrs.text = "gservice".localized
            lblGuestServiceHrs.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblGuestServiceTime: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
            lblGuestServiceTime.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var btnFaq: UIButton!{
        didSet{
            btnFaq.setTitle("faq".localized, for: .normal)
            btnFaq.addTextSpacing(spacing: 1.5, color: Common.blackColor)
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
        let nib = UINib(nibName: "needHelp", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
