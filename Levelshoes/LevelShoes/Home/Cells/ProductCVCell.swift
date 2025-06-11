//
//  ProductCVCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 06/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol ProductCVCellDelegate :class {
    func updateWishListProduct(productCVCell:ProductCVCell)
}
class ProductCVCell: UICollectionViewCell {
    var isVisible = false
    weak var scrollView : UIScrollView?
    weak var productCVCellDelegate : ProductCVCellDelegate?
    
    @IBOutlet weak var lblTag: InsetLabel!{
        didSet{
            lblTag.addTextSpacing(spacing: 1)
        }
    }
    @IBOutlet weak var lblTag2: InsetLabel!{
        didSet{
            lblTag2.addTextSpacing(spacing: 1)
        }
    }
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrand: UILabel! {
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblBrand.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var constCenter: NSLayoutConstraint!
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnMark: UIButton!
    
    var parentCell : CollectionCell?
    
    @IBAction func onClickMark(_ sender: UIButton) {
        self.productCVCellDelegate?.updateWishListProduct(productCVCell: self)
    }
    
    func setBookmark(selected: Bool) {
        if selected {
            guard let image = UIImage(named: "Selected") else { return }
            btnMark.set_image(image, animated: true)
        } else {
            guard let image = UIImage(named: "Default") else { return }
            btnMark.set_image(image, animated: true)
        }
    }
}
