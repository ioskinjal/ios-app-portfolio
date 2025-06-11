//
//  GuideEpgCell.swift
//  OTT
//
//  Created by YuppTV Ent on 10/10/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit

class TinyGuideChannelCell: UICollectionViewCell {
    
    
    static let nibname:String = "TinyGuideChannelCell"
    static let identifier:String = "TinyGuideChannelCell"
    
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        channelNameLbl.font = UIFont.ottRegularFont(withSize: 14.0)
    }
    
    override func prepareForReuse() {
         channelNameLbl.text = ""
        channelImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        channelNameLbl.font = UIFont.ottRegularFont(withSize: 14.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
           willSet {
               if newValue {
                   self.channelNameLbl.textColor = UIColor.white
                   self.backgroundColor = UIColor.whiteWithOpacity22
               } else {
                   self.channelNameLbl.textColor = UIColor.channelUnselectedTextColor
                   self.backgroundColor = UIColor.whiteWithOpacity008
               }
           }
       }
       
       override var isHighlighted: Bool {
           willSet {
               if newValue {
                   self.channelNameLbl.textColor = UIColor.white
                   self.backgroundColor = UIColor.whiteWithOpacity22
               } else {
                   self.channelNameLbl.textColor = UIColor.channelUnselectedTextColor
                   self.backgroundColor = UIColor.whiteWithOpacity008
               }
           }
       }
    
}
