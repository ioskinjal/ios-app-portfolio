//
//  UITableView+Extension.swift
//  logics
//
//  Created by Abhishek Rajput on 08/06/20.
//  Copyright © 2020 Abhishek Rajput. All rights reserved.
//

import Foundation
import UIKit

extension UITableView
{
    func register(_ nibs: [String])
    {
        for nib in nibs{
            self.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: nib)
        }
    }
    
    func registerHeader(_ nibs: [String])
    {
        for nib in nibs{
            self.register(UINib.init(nibName: nib, bundle: nil), forHeaderFooterViewReuseIdentifier: nib)
        }
    }
}

extension UICollectionView
{
    func registerCollection(_ nibs: [String])
    {
        for nib in nibs{
            self.register(UINib.init(nibName: nib, bundle: nil), forCellWithReuseIdentifier: nib)
        }
    }
    
    func registerHeaderCollection(_ nibs: [String])
    {
        for nib in nibs{
            self.register(UINib.init(nibName: nib, bundle: nil), forCellWithReuseIdentifier: nib)
        }
    }
}

