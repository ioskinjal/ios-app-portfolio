//
//  BagCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 22/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol MainCartProtocol {
    func sizeDropDownAction(_ cell:BagCell)
    func previousAction(_ cell:BagCell)
    func nextAction(_ cell:BagCell)
    func selectItems(_ cell:BagCell)
    func deleteProduct(_ cell:BagCell)
    func addToWishList(_ cell:BagCell)
}

class BagCell: UITableViewCell {

    @IBOutlet weak var lblTag: UILabel!
    @IBOutlet weak var btnRemove: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                btnRemove.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            btnRemove.setTitle("Remove".localized, for: .normal)
        }
    }
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var btnAddToWishlist: UIButton!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                btnAddToWishlist.titleLabel?.font = UIFont(name: "Cairo-Regular", size: 16)
            }
            btnAddToWishlist.setTitle("Add to wishlist".localized, for: .normal)
        }
    }
    @IBOutlet weak var lblSize: InsetLabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProduct: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblProduct.font = UIFont(name: "Cairo-Light", size: lblProduct.font.pointSize)
            }
        }
    }
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrand: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblBrand.font = UIFont(name: "Cairo-SemiBold", size: lblBrand.font.pointSize)
            }
        }
    }
    @IBOutlet weak var lblsizeHeading: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblsizeHeading.font = UIFont(name: "Cairo-Light", size: lblsizeHeading.font.pointSize)
            }
            lblsizeHeading.text = "basket_size".localized
        }
    }
    @IBOutlet weak var lblQtyHeading: UILabel!
    {
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en" {
                lblQtyHeading.font = UIFont(name: "Cairo-Light", size: lblQtyHeading.font.pointSize)
            }
            lblQtyHeading.text = "basket_qty".localized
        }
    }
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
     var skuSourseData = [String : Any]()
    var product_id = 0
    var product_Sku_id = ""
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var bottomButtonStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonSeperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkUncheckedImg: UIImageView!
    
    var delegate: MainCartProtocol?
    var rowNumber: Int?
    var qtyValue: Int?
    var isState: Bool?
    
    var selectedSize = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   /* func cellConfiguration(index: Int, size: String, qty: Int, isCurrentState: Bool){
        rowNumber = index
        isState = isCurrentState
        lblSize.text = size
        qtyValue = qty
        if isState == true{
             lblQty.text = "\(qtyValue ?? 0)"
        }else{
             lblQty.text = "\(qtyValue ?? 0)"
        }
    }*/
    
    func cellConfiguration(_ model:CartItem){
        lblSize.text = selectedSize
        lblQty.text = String(model.qty!)
        //lblBrand.text = model.name?.uppercased()
        lblProduct.text = model.name?.uppercased()
        //lblPrice.text = String(format:"%.2f",model.price as? Double ?? 0.0)
     
    }
    
    @IBAction func sizeSelectionAction(_ sender: UIButton) {
        delegate?.sizeDropDownAction(self)
    }
    @IBAction func qtyReduceAction(_ sender: UIButton) {
        let quentity:Int? = Int.init(lblQty.text!)
        if quentity! > 1 {
        lblQty.text = String(quentity! - 1)
        }
        delegate?.previousAction(self)
    }
    @IBAction func qtyIncreaseAction(_ sender: UIButton) {
        let quentity:Int? = Int.init(lblQty.text!)
        lblQty.text = String(quentity! + 1)
        delegate?.nextAction(self)
    }
    
    @IBAction func selectItems(_ sender : UIButton){
        delegate?.selectItems(self)
    }
    
    @IBAction func deleteProduct(_ sender:UIButton){
        delegate?.deleteProduct(self)
    }
    
    @IBAction func addToWishList(_ sender:UIButton){
        delegate?.addToWishList(self)
    }
}
