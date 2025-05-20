//
//  AddNewServiceImageCell.swift
//  Talabtech
//
//  Created by NCT 24 on 21/06/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class AddNewServiceImageCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var indexPath: IndexPath?

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//                self.imgUser.setRadius()
//            }
        }
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        if let parentVC = self.viewController as? AddNewBusinessVC {
                parentVC.pickedImageAry.remove(at: self.indexPath!.row)
                parentVC.pickedImageNameAry.remove(at: self.indexPath!.row)
                parentVC.collectionViewImage.reloadData()
                parentVC.setAutoHeight()
        }
    }
    
    
//    var cellData:
    

}
