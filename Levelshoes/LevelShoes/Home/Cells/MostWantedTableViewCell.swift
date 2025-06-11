//
//  MostWantedTableViewCell.swift
//  Level Shoes
//
//  Created by Zing Mobile on 07/04/20.
//  Copyright © 2020 IDSLogic. All rights reserved.
//

import UIKit

class MostWantedTableViewCell: UITableViewCell {

  //  @IBOutlet weak var upShadow: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductNm: UILabel!
    @IBOutlet weak var lblBrand: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                lblBrand.addTextSpacing(spacing: 1.5)
            }
        }
    }
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet var countLbl: UILabel!{
        didSet {
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" == "en"{
                countLbl.addTextSpacing(spacing: 1.5)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       let brandFontName = lblBrand.font.fontName
        let prdFontName = lblProductNm.font.fontName
       if deviceIsSmallerThanIphone7() {
           lblBrand.font = UIFont(name: brandFontName, size: 12)
           lblProductNm.font = UIFont(name: prdFontName, size:14)
       } else {
            lblBrand.font = UIFont(name: brandFontName, size: 14)
            lblProductNm.font = UIFont(name: prdFontName, size:16)
       }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imgProduct.sd_cancelCurrentImageLoad()
    }
}
