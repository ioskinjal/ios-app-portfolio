//
//  MyRequestCell.swift
//  ThumbPin
//
//  Created by NCT109 on 21/11/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class MyRequestCell: UITableViewCell {

    @IBOutlet weak var btnPDF: UIButton!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var collViewProviderList: UICollectionView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var llbMetrialName: UILabel!
    @IBOutlet weak var btnReOpen: UIButton!
    @IBOutlet weak var labelServiceStatus: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLang()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setColleViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        collViewProviderList.delegate = dataSourceDelegate
        collViewProviderList.dataSource = dataSourceDelegate
        collViewProviderList.register(ProviderListCell.nib, forCellWithReuseIdentifier: ProviderListCell.identifier)
        collViewProviderList.tag = row
        collViewProviderList.reloadData()
    }
    func setUpLang() {
        btnReOpen.setTitle(localizedString(key: "Reopen"), for: .normal)
        btnUpdate.setTitle("  \(localizedString(key: "Update"))  ", for: .normal)
    }
    
}
