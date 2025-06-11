//
//  CustomFlowLayout.swift
//  myColView
//
//  Created by Mohan Agadkar on 22/05/17.
//  Copyright © 2015 com.cv. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    var pageType : String = "none"
    var numberOfColumns: CGFloat = 2
    var cellSize: CGSize = CGSize(width: 50, height: 50)
    var secInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var interItemSpacing: CGFloat = 5
    var minLineSpacing: CGFloat = 5
    var scrollDir: UICollectionView.ScrollDirection = .vertical
    var cellRatio: Bool = true
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            return calc(numCells: numberOfColumns)
        }
    }
    
    override var sectionInset: UIEdgeInsets {
        set {
            
        }
        get {
            return self.secInset
        }
    }
    /*
    override var minimumLineSpacing: CGFloat {
        set {
            
        }
        get {
            return self.minimumLineSpacing
        }
    }
    
    override var minimumInteritemSpacing: CGFloat {
        set {
            
        }
        get {
            return self.minimumInteritemSpacing
        }
    }
    */
    func calc(numCells: CGFloat) -> CGSize {
        
        print("UIScreen size: ", UIScreen.main.bounds.size)
        if self.scrollDir == .horizontal {
            print("newCellSize 1: ", self.cellSize)
            return self.cellSize
        }
        let newW = (UIScreen.main.bounds.size.width - (numCells * minimumInteritemSpacing) - self.sectionInset.left - self.sectionInset.right) / numCells
        
         if pageType == "list"{
             let returnHeight = (newW * 9/16)
            let newCellSize = CGSize(width: newW, height: returnHeight)
            print("newCellSize 3: ", newCellSize)
            return newCellSize
         }else{
            let imageSize = self.cellSize
            let returnHeight = (newW / imageSize.width) * imageSize.height
            var newCellSize = CGSize(width: newW, height: returnHeight)
            if self.cellRatio == false {
                newCellSize = CGSize(width: newW + 9, height: imageSize.height)
                if productType.iPad {
                    newCellSize = CGSize(width: newW, height: imageSize.height)
                }
            }
            print("newCellSize 2: ", newCellSize)
            return newCellSize
        }
        
    }
    
    func getCellSizeFromWidth (newW: CGFloat) -> CGSize {
        let imageSize = self.cellSize
        let returnHeight = (newW / imageSize.width) * imageSize.height
        return CGSize(width: newW, height: returnHeight)
    }
    
    func setupLayout() {
        minimumInteritemSpacing = self.interItemSpacing
        minimumLineSpacing = self.minLineSpacing
        scrollDirection = self.scrollDir
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
