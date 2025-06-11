//
//  SimilarProductsPDPCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 30/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
protocol SimilarProductsPDPCellDelegate : class {
    func addToWishList(cell:SimilarProductsPDPCell)
}
class SimilarProductsPDPCell: UICollectionViewCell {
    var skuId = ""
    var product_id = ""
    weak var similarProductsdelagate : SimilarProductsPDPCellDelegate?
    var arrSimilarProduct = [Dictionary<String, Any>]()
    @IBOutlet weak var lblOldPrice: UILabel!
    
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var imgProduct: UIImageView!{
        didSet{
            imgProduct.contentMode=UIViewContentMode.scaleAspectFill
        }
    }
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            lblPrice.isSkeletonable = true
        }
    }
    @IBOutlet weak var lblProductNm: UILabel!{
        didSet{
            lblPrice.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblProductNm.font = UIFont(name: "Cairo-Light", size: 13)
            }
        }
    }
    @IBOutlet weak var imageView: UIView!{
        didSet{
            self.imageView.alpha = 0
            
            self.imageView.center.y -= self.imageView.center.y + 1
            self.imageView.alpha = 1
            imageView.isSkeletonable = true
            
        }
    }
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var lblBrand: UILabel!{
        didSet{
            lblBrand.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblBrand.addTextSpacing(spacing: 1.07)
            }
            else{
                    lblBrand.font = UIFont(name: "Cairo-SemiBold", size: lblBrand.font.pointSize)
            }
        }
    }
    

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
    @IBAction func addWishListButtonAction(_ sender:UIButton){
        self.similarProductsdelagate?.addToWishList(cell: self)
    }
}
