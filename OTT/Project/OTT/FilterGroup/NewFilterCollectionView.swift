//
//  NewFilterCollectionViewCell.swift
//  OTT
//
//  Created by Malviya Ishansh on 10/08/22.
//  Copyright © 2022 Chandra Sekhar. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class NewFilterCollectionView: UICollectionView {
    var isDynamicSizeRequired = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            
            if self.intrinsicContentSize.height > frame.size.height {
                self.invalidateIntrinsicContentSize()
            }
            if isDynamicSizeRequired {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

class NewFilterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        var leftMargin: CGFloat = self.sectionInset.left
        
        for attributes in attributesForElementsInRect! {
          if (attributes.frame.origin.x == self.sectionInset.left) {
            leftMargin = self.sectionInset.left
          } else {
            var newLeftAlignedFrame = attributes.frame
            
            if leftMargin + attributes.frame.width < self.collectionViewContentSize.width {
              newLeftAlignedFrame.origin.x = leftMargin
            } else {
              newLeftAlignedFrame.origin.x = self.sectionInset.left
            }
            
            attributes.frame = newLeftAlignedFrame
          }
          leftMargin += attributes.frame.size.width + 8
          newAttributesForElementsInRect.append(attributes)
        }
        
        return newAttributesForElementsInRect
    }
}

class NewFilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewFilterCell"
    
    var filter: FilterData? {
        didSet{
          guard let sender = self.filter else { return }
          self.titleLabel.text = sender.title
        }
    }
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.lineBreakMode = .byTruncatingMiddle
        lbl.textColor = .white
        return lbl
    }()
    
    func setupViews() {
        self.titleLabel.text = nil
        self.backgroundColor = UIColor(hexString: "323232")
        self.layer.cornerRadius = 0
        
        addSubview(titleLabel)
        self.addConstraints([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
}

struct FilterData {
    var title: String
    var id: Int
    var selected = false
}
