//
//  ImageCheckBoxDetailCell.swift
//  ThumbPin
//
//  Created by NCT109 on 30/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class ImageCheckBoxDetailCell: UITableViewCell {

    @IBOutlet weak var collCheckBox: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collCheckBox.register(ImageCheckBoxColleCell.nib, forCellWithReuseIdentifier: ImageCheckBoxColleCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        //conTblvwCheckBoxHeight.constant = 0
       // tblvwCheckbox.estimatedRowHeight = 44
        //tblvwCheckbox.rowHeight = UITableViewAutomaticDimension
        collCheckBox.delegate = dataSourceDelegate
        collCheckBox.dataSource = dataSourceDelegate
        collCheckBox.tag = row
        collCheckBox.reloadData()
        //conTblvwCheckBoxHeight.constant = tblvwCheckbox.contentSize.height
    }
    
}
