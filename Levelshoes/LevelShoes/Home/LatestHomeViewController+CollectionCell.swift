//
//  LatestHomeViewController+CollectionCell.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 09.07.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import UIKit

extension LatestHomeViewController {
    
    func getCollectionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let source = landingData?._sourceLanding?.dataList[indexPath.section] else { return UITableViewCell() }
        let cell:CollectionCell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier) as! CollectionCell
        cell.parentVC = self
        
        cell.senderTag = indexPath.section

        cell.contentOffsetKey = "\(SelectedCat)_\(indexPath.section)_\(indexPath.item)"
        cell.productData = nil
        DispatchQueue.global().async {
            cell.getProducts(category_id: source.category_id,
                             product_id: source.products?.primary_vpn ?? [String](),
                             gender: self.strgen)
        }
        return cell
    }
}
