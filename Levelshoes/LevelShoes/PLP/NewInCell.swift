//
//  NewInCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 19/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit
import SkeletonView
protocol NewInCellDelegate :class {
    func updateWishListProduct(newInCell:NewInCell)
}

class NewInCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblOldPrice: UILabel!
    weak var newInCellDelegate : NewInCellDelegate?
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var imgProduct: UIImageView!{
        didSet{
       //     imgProduct.contentMode=UIViewContentMode.scaleAspectFill
        }
    }
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
         //   lblPrice.isSkeletonable = true
        }
    }
    @IBOutlet weak var lblProductNm: UILabel!{
        didSet{
          //  lblPrice.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblProductNm.font = UIFont(name: "Cairo-Light", size: lblProductNm.font.pointSize)
            }
        }
    }
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imageView: UIView!{
        didSet{
            
            //Modified by Nitikesh , comment may be removed after confirmation. Remove after shimmer
            self.imageView.alpha = 0
            self.animateFilterLabel()
            
           // imageView.isSkeletonable = true
            
        }
    }
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var lblBrand: UILabel!{
        didSet{
          //  lblBrand.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblBrand.addTextSpacing(spacing: 1.07)
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblBrand.font = UIFont(name: "Cairo-SemiBold", size: lblBrand.font.pointSize)
            }
        }
    }
    
    @IBOutlet weak var lblTag: UILabel!{
        
        didSet{
            //lblTag.adjustsFontSizeToFitWidth = true
            lblTag.sizeToFit()
          //  lblTag.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblTag.addTextSpacing(spacing: 1.0)
                
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTag.font = UIFont(name: "Cairo-SemiBold", size: lblTag.font.pointSize)
            }

        }
    }
    
    @IBOutlet weak var lblTag2: InsetLabel!{
        
        didSet{
            //lblTag.adjustsFontSizeToFitWidth = true
            lblTag2.sizeToFit()
           // lblTag2.isSkeletonable = true
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblTag2.addTextSpacing(spacing: 1.0)
                
            }
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblTag2.font = UIFont(name: "Cairo-SemiBold", size: lblTag2.font.pointSize)
            }
        }
    }
    
    
    func animateFilterLabel(){
        
        //Image View Content Animation
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.imageView.center.y -= self.imageView.center.y + 1
                        self.imageView.alpha = 1
        }, completion: nil)
        
        
    }
    
    @IBAction func bookMarkSelector(_ sender: UIButton) {
        self.newInCellDelegate?.updateWishListProduct(newInCell: self)
    }
}

