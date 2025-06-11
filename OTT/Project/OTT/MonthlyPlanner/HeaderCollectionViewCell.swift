//
//  HeaderCollectionViewCell.swift
//  OTT
//
//  Created by YuppTV Ent on 24/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    static let nibname:String = "HeaderCollectionViewCell"
    static let identifier:String = "HeaderCollectionViewCell"
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgPrevious: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate:collectionCell_delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.font = UIFont.ottRegularFont(withSize: 14)
        lblTitle.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.layer.borderWidth = 0.5
        self.layer.borderColor = AppTheme.instance.currentTheme.lineColor.cgColor
        self.btnNext.setTitle("", for: .normal)
    }

    func setTopBtnsVisibility(imgNext: Bool, imgPrev: Bool, btnNxt: Bool, btnPrev: Bool) {
//        self.btnNext.isHidden = btnNxt
//        self.btnPrevious.isHidden = btnPrev
//        self.imgNext.isHidden = imgNext
//        self.imgPrevious.isHidden = imgPrev
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UITableView - getIndexPath")
            return
        }
        
        guard let collIndexPath = superView.indexPath(for: self) else { return }
        let row = collIndexPath.item
        if let del = delegate{
            del.moveToNextCell(selectedItem: CGFloat(row))
        }
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        
        guard let superView = self.superview as? UICollectionView else {
            print("superview is not a UITableView - getIndexPath")
            return
        }
        
        guard let collIndexPath = superView.indexPath(for: self) else { return }
        let row = collIndexPath.item
        if let del = delegate{
            del.moveToPreviousCell(selectedItem: CGFloat(row - 2))
        }
    }
    static func registerToCollectionView(collectionView : UICollectionView){
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
        collectionView.register(UINib.init(nibName: HeaderCollectionViewCell.nibname, bundle: nil), forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
    }
}
