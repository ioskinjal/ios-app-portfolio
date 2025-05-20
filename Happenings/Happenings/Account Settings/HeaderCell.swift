//
//  HeaderCell.swift
//  Happenings
//
//  Created by admin on 2/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {

    @IBOutlet weak var viewPoint: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    static let locationNameFont:UIFont = TitilliumWebFont.regular(with: 17.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
