//
//  orderDetailFooter.swift
//  LevelShoes
//
//  Created by chhavi  kaushik on 03/07/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

@IBDesignable
class orderDetailFooter: UIView {
@IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var discountHieghtConstant: NSLayoutConstraint!
    @IBOutlet weak var viewShipping: UIView!
    @IBOutlet weak var viewShippingHieghtConstant: NSLayoutConstraint!
    
    @IBOutlet weak var lblDiscount: UILabel!{
        didSet{
            lblDiscount.text = "Discount".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblDiscount.textAlignment = .left
                
            }
            else{
                lblDiscount.font = UIFont(name: "Cairo-Light", size: lblDiscount.font.pointSize)
                lblDiscount.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblDiscountValue: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblDiscountValue.textAlignment = .right
                
            }
            else{
                lblDiscountValue.font = UIFont(name: "Cairo-Light", size: lblDiscountValue.font.pointSize)
                lblDiscountValue.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var viewGiftcard: UIView!
    @IBOutlet weak var giftcardHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lblGiftcard: UILabel!{
        didSet{
            lblGiftcard.text = "Gift Card".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblGiftcard.textAlignment = .left
                
            }
            else{
                lblGiftcard.font = UIFont(name: "Cairo-Light", size: lblGiftcard.font.pointSize)
                lblGiftcard.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblGiftcardValue: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblGiftcardValue.textAlignment = .right
                
            }
            else{
                lblGiftcardValue.font = UIFont(name: "Cairo-Light", size: lblGiftcardValue.font.pointSize)
                lblGiftcardValue.textAlignment = .left
            }
        }
    }
    
    @IBOutlet weak var lblOrderSummary: UILabel!{
        didSet{
            lblOrderSummary.text = "Order Summary".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblOrderSummary.textAlignment = .left
                
            }
            else{
                lblOrderSummary.font = UIFont(name: "Cairo-SemiBold", size: lblOrderSummary.font.pointSize)
                lblOrderSummary.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblSummaryItems: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblSummaryItems.textAlignment = .right
                
            }
            else{
                lblSummaryItems.font = UIFont(name: "Cairo-Light", size: lblSummaryItems.font.pointSize)
                lblSummaryItems.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var viewNewReturn: UIView!
    @IBOutlet weak var btnNewReturn: UIButton!
    
    @IBOutlet weak var lblNewReturn: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNewReturn.font =  UIFont(name: "Cairo-Regular", size: lblNewReturn.font.pointSize)
                
            }
            lblNewReturn.text = "requestReturn".localized
            lblNewReturn.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblNeedHelp: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblNeedHelp.font =  UIFont(name: "Cairo-Regular", size: lblNeedHelp.font.pointSize)
                
            }
            lblNeedHelp.text = "Need Help".localized
            lblNeedHelp.addTextSpacing(spacing: 1.5)
        }
    }
    @IBOutlet weak var lblCartSubTotal: UILabel!{
        didSet{
            lblCartSubTotal.text = "Cart Subtotal".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblCartSubTotal.textAlignment = .left
                
            }
            else{
                lblCartSubTotal.font = UIFont(name: "Cairo-Light", size: lblCartSubTotal.font.pointSize)
                lblCartSubTotal.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblCartSubtotalPrice: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblCartSubtotalPrice.textAlignment = .right
                
            }
            else{
                lblCartSubtotalPrice.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var lblShipping: UILabel!{
        didSet{
            lblShipping.text = "Shipping".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblShipping.textAlignment = .left
                
            }
            else{
                lblShipping.font = UIFont(name: "Cairo-Light", size: lblShipping.font.pointSize)
                lblShipping.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblShippingPrice: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblShippingPrice.textAlignment = .right
                
            }
            else{
                lblShippingPrice.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var lblVat: UILabel!{
        didSet{
            lblVat.text = getVatName()
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblVat.textAlignment = .left
                
            }
            else{
                lblVat.font = UIFont(name: "Cairo-Light", size: lblVat.font.pointSize)
                lblVat.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblVatPrice: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblVatPrice.textAlignment = .right
                
            }
            else{
                lblVatPrice.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var lblGrandtotal: UILabel!{
        didSet{
            lblGrandtotal.text = "Grand Total".localized
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblGrandtotal.textAlignment = .left
                
            }
            else{
                lblGrandtotal.font = UIFont(name: "Cairo-SemiBold", size: lblGrandtotal.font.pointSize)
                lblGrandtotal.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var lblGrandtotalPrice: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblGrandtotalPrice.textAlignment = .right
                
            }
            else{
                lblGrandtotalPrice.textAlignment = .left
            }
        }
    }
    @IBOutlet weak var btnneedHelp: UIButton!
    
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
        let nib = UINib(nibName: "orderDetailFooter", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
