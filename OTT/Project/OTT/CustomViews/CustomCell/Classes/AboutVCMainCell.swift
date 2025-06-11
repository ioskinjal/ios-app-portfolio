//
//  AboutVCMainCell.swift
//  YuppFlix
//
//  Created by Ankoos on 10/10/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit

class AboutVCMainCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var Collection: UICollectionView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: UICollectionViewDelegate ,del:  UICollectionViewDataSource, index: NSInteger) {
        self.Collection.dataSource = del
        self.Collection.delegate = delegate
        self.Collection.tag = index
        self.Collection.reloadData()
    }
}
