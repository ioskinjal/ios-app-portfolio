//
//  AttachedFileCollectionViewCell.swift
//  Nlance
//
//  Created by admin on 02/03/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AttachedFileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAttachedFile: UIImageView!{
        didSet{
            self.imgAttachedFile.isUserInteractionEnabled = true
            self.imgAttachedFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickImgAttached)))
        }
    }
//    @IBOutlet weak var lblName:UILabel!{
//        didSet{
//            lblName.numberOfLines = 0
//        }
//    }
    @IBOutlet weak var imgDelete:UIImageView!{
        didSet{
            self.imgDelete.isUserInteractionEnabled = true
            self.imgDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickImgDelete)))
        }
    }
    
    var data:DocumentPicker?{
        didSet{
            self.setupUI()
        }
    }
    
    fileprivate func setupUI(){
        guard let data = data else { return }
        self.imgAttachedFile.image = data.image
       // self.lblName.text = data.name
    }
    
    
    
    var clickImgAttached:(()->())?
    var clickImgDelete:(()->())?
    
    @objc private func onClickImgAttached(_ sender:UITapGestureRecognizer){
        self.clickImgAttached?()
    }
    @objc private func onClickImgDelete(_ sender:UITapGestureRecognizer){
       self.clickImgDelete?()
    }
    
}
