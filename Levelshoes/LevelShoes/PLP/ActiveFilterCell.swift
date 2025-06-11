//
//  ActiveFilterCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 20/05/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ActiveFilterCell: UICollectionViewCell {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblFilter: UILabel!{
        didSet{
            if UserDefaults.standard.value(forKey:string.language)as? String ?? "en" != "en"{
                lblFilter.font = UIFont(name: "Cairo-Regular", size: lblFilter.font.pointSize)

            }
        }
    }
}
