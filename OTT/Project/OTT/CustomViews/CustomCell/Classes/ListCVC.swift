//
//  ListCVC.swift
//  OTT
//
//  Created by Muzaffar on 15/05/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
class ListCVC: UICollectionViewCell {
    
    static let size = CGSize.init(width: 232, height: 61)
    static let nibname:String = "ListCVC"
    static let identifier:String = "ListCVC"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
        title?.text = ""
        subTitle?.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
