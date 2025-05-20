//
//  QuotePlacedCell.swift
//  ThumbPin
//
//  Created by NCT109 on 10/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class QuotePlacedCell: UITableViewCell {

    @IBOutlet weak var lbluotesAmount: UILabel!
    @IBOutlet weak var lblDeliveryDays: UILabel!
    @IBOutlet weak var lblMaterialName: UILabel!
    @IBOutlet weak var labelSubCategoryStatic: UILabel!
    @IBOutlet weak var labelCategoryStatic: UILabel!
    @IBOutlet weak var labelByStatic: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var labelSubCategory: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCustomername: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelServiceName: UILabel!
    
    var tap = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpLang()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpLang() {
        labelByStatic.text = localizedString(key: "By:")
        labelCategoryStatic.text = localizedString(key: "Category:")
        labelSubCategoryStatic.text = localizedString(key: "Sub Category:")
    }
}
