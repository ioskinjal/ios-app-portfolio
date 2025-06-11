//
//  CategoryCC.swift
//  Luxongo
//
//  Created by admin on 8/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CategoryCC: UICollectionViewCell {

    var cellData: PopularCategory?{
        didSet{
            loadCellUI()
        }
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategoryNm: LabelBold!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadCellUI() {
        if let data = self.cellData{
            lblCategoryNm.text = data.category_name
            imgCategory.downLoadImage(url: data.category_avatar_100x_100)
        }
    }
    
}
