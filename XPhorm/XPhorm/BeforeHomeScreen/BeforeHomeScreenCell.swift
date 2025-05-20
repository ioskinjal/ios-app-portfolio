//
//  BeforeHomeScreenCell.swift
//  XPhorm
//
//  Created by admin on 6/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos
class BeforeHomeScreenCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewrate: CosmosView!
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var mainView:UIView!{
        didSet{
            mainView.setRadius(4)
            mainView.border()
        }
    }
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
         imgProfile.setRadius()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
