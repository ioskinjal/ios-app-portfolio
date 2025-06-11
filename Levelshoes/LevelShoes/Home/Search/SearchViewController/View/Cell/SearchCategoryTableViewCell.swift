//
//  SearchCategoryTableViewCell.swift
//  LevelShoes
//
//  Created by Maa on 26/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol SearchCategoryTableViewCellDelegate :class {
    func selectedProduct(product:ProductList, atIndex:IndexPath, cell: SearchCategoryTableViewCell  )
    
}
class SearchCategoryTableViewCell: UITableViewCell {
    weak var delegate: SearchCategoryTableViewCellDelegate?;
    @IBOutlet weak var tableViewCell: UITableView!
    @IBOutlet weak var noIteamView: UIView!
    var FirstTableArray = ["Sneakers", "Bags","Boots","S18","White trend"]
    var searchProductArray: [ProductList] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initCollectionView()
        
    }
    func initCollectionView(){
        let cells = [SubCategoryTableViewCell.className]
        tableViewCell.register(cells)
    }
    
    func isShowNoIteamView(isShow:Bool){
        if isShow {
            noIteamView.isHidden = false
            tableViewCell.isHidden = true
        } else {
            noIteamView.isHidden = true
            tableViewCell.isHidden = false
        }
    }
}

extension SearchCategoryTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProductArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTableViewCell", for: indexPath) as? SubCategoryTableViewCell else {return UITableViewCell() }
        if self.searchProductArray[indexPath.row].parentCatId == "0" {
            cell._lblSearchCategory.text =  self.searchProductArray[indexPath.row].catName!
        } else {
            cell._lblSearchCategory.text = self.searchProductArray[indexPath.row].parentCatName! + " > " + self.searchProductArray[indexPath.row].catName!
        }
        cell._lblSearchCategory.font = UIFont(name: "BrandonGrotesque-Light", size: 16)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedProduct(product: searchProductArray[indexPath.row], atIndex: indexPath, cell: self)
    }
}

