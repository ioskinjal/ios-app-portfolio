//
//  orderDetailHeader.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

@IBDesignable
class orderDetailHeader: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var lblDeliveryStatus: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblDeliveryStatus.font = UIFont(name: "Cairo-SemiBold", size: lblDeliveryStatus.font.pointSize)
            }
            lblDeliveryStatus.addTextSpacing(spacing: 1.0)
        }
    }
    
    @IBOutlet weak var btnTrackReturn: UIButton!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                btnTrackReturn.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 14)
            }
            btnTrackReturn.setTitle("trackReturn".localized, for: .normal)
            btnTrackReturn.addTextSpacing(spacing: 1.5, color: Common.blackColor)
        }
    }
    @IBOutlet weak var lblOrderStatus: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblOrderStatus.font = UIFont(name: "Cairo-SemiBold", size: lblOrderStatus.font.pointSize)
            }
            lblOrderStatus.text = "orderStatus".localized
        }
    }
    @IBOutlet weak var lblOrderTitle: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblOrderTitle.font = UIFont(name: "Cairo-SemiBold", size: lblOrderTitle.font.pointSize)
            }
            lblOrderTitle.text = "yourOrderno".localized
            lblOrderTitle.addTextSpacing(spacing: 1.0)
        }
    }
    @IBOutlet weak var lblOrderNo: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblOrderNo.addTextSpacing(spacing: 1.0)
            }else{
            lblOrderNo.font = UIFont(name: "Cairo-SemiBold", size: lblOrderNo.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblHome: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblHome.font = UIFont(name: "Cairo-SemiBold", size: lblHome.font.pointSize)
            }
            lblHome.text = "home".localized.uppercased()
        }
    }
    @IBOutlet weak var lblBillinghome: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBillinghome.font = UIFont(name: "Cairo-SemiBold", size: lblBillinghome.font.pointSize)
            }
            lblBillinghome.text = "home".localized.uppercased()
        }
    }
    @IBOutlet weak var lblBillingAdd: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBillingAdd.font = UIFont(name: "Cairo-SemiBold", size: lblBillingAdd.font.pointSize)
            }
            lblBillingAdd.text = "billing_Add".localized.uppercased()
        }
    }
    @IBOutlet weak var lblUsername: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblUsername.font = UIFont(name: "Cairo-Light", size: lblUsername.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblCountry: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblCountry.font = UIFont(name: "Cairo-Light", size: lblCountry.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblAddress: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblAddress.font = UIFont(name: "Cairo-Light", size: lblAddress.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblOrderMode: UILabel!
    @IBOutlet weak var lblYouritems: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblYouritems.font = UIFont(name: "Cairo-SemiBold", size: lblYouritems.font.pointSize)
            }
            lblYouritems.text = "yourItems".localized
        }
    }
    @IBOutlet weak var lblItemsCount: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblItemsCount.font = UIFont(name: "Cairo-Light", size: lblItemsCount.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblHeaderShipppingAddress: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblHeaderShipppingAddress.font = UIFont(name: "Cairo-SemiBold", size: lblHeaderShipppingAddress.font.pointSize)
            }
            lblHeaderShipppingAddress.text = "shipping_add".localized.uppercased()
        }
    }
    @IBOutlet weak var lblBillingUser: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBillingUser.font = UIFont(name: "Cairo-Light", size: lblBillingUser.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblBillingAddress: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBillingAddress.font = UIFont(name: "Cairo-Light", size: lblBillingAddress.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblBillingCountry: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBillingCountry.font = UIFont(name: "Cairo-Light", size: lblBillingCountry.font.pointSize)
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
        contentView = view
    }
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "orderDetailHeader", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
