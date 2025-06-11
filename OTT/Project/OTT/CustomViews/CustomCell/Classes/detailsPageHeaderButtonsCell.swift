//
//  detailsPageHeaderButtonsCell.swift
//  OTT
//
//  Created by Srikanth on 10/12/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//



class detailsPageHeaderButtonsCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
}
