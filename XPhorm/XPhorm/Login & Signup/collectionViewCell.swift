
//
//  collectionViewCell.swift
//  Xphorm
//
//  Created by admin on 5/29/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class collectionViewCell: UICollectionViewCell {
    
     @IBOutlet weak var imageView:UIImageView!
     @IBOutlet weak var lbldescription:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    
 
    
    
    var data:DataModel?{
        didSet{
            self.setupUI()
        }
    }

    
    
    private func setupUI(){
        guard let data = data else { return }
        self.imageView.image = data.image
        self.lbldescription.text = data.description
        self.lblTitle.text = data.title
    }
}

