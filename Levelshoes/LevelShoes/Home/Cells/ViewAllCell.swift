//
//  ViewAllCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 23/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ViewAllCell: UICollectionViewCell {
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblViewAll: UILabel!{
           didSet{
               lblViewAll.addTextSpacing(spacing: 1.5)
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblViewAll.font = UIFont(name: "Cairo-SemiBold", size: lblViewAll.font.pointSize)
            }
           }
       }
    
}
