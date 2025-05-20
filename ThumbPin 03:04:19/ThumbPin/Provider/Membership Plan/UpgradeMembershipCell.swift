//
//  UpgradeMembershipCell.swift
//  ThumbPin
//
//  Created by NCT109 on 14/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class UpgradeMembershipCell: UICollectionViewCell {

    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationHead: UILabel!
    @IBOutlet weak var lblMsgHead: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var labelPriceStatic: UILabel!
    @IBOutlet weak var labelTotalCreditsStatic: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelTotalCredit: UILabel!
    @IBOutlet weak var labelPlaneName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLang()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.addSubview(testLabel)
//        testLabel.center = contentView.center
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // contentView.addSubview(labelCount)
    }
    func setUpLang() {
        labelTotalCreditsStatic.text = localizedString(key: "Total Credits")
        labelPriceStatic.text = localizedString(key: "Price")
        lblMsgHead.text = localizedString(key: "Messages")
        lblDurationHead.text = localizedString(key: "Plan Duration")
    }
}
