//
//  MyServiceCC.swift
//  XPhorm
//
//  Created by admin on 8/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyServiceCC: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!{
        didSet{
            viewMain.setRadius(4)
            viewMain.border()
        }
    }
    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var imgService: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
