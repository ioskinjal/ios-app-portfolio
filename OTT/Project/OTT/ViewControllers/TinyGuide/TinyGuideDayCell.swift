//
//  GuideEpgCell.swift
//  OTT
//
//  Created by YuppTV Ent on 10/10/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit

class TinyGuideDayCell: UICollectionViewCell {
    
    
    static let nibname:String = "TinyGuideDayCell"
    static let identifier:String = "TinyGuideDayCell"
    
    @IBOutlet weak var dateTitleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateTitleLbl.font = UIFont.ottRegularFont(withSize: 12.0)
        // Initialization code
    }
    
    override func prepareForReuse() {
         dateTitleLbl.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateTitleLbl.font = UIFont.ottRegularFont(withSize: 12.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.dateTitleLbl.textColor = UIColor.white
            } else {
                self.dateTitleLbl.textColor = UIColor.channelUnselectedTextColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                self.dateTitleLbl.textColor = UIColor.white
            } else {
                self.dateTitleLbl.textColor = UIColor.channelUnselectedTextColor
            }
        }
    }
}
