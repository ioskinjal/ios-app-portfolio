//
//  GuideEpgCell.swift
//  OTT
//
//  Created by YuppTV Ent on 10/10/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit

class TinyGuideEpgCell: UICollectionViewCell {
    
    
    static let nibname:String = "TinyGuideEpgCell"
    static let identifier:String = "TinyGuideEpgCell"
    
    @IBOutlet weak var programImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var subtitleLbl2: UILabel!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var timerView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timerView.viewCornerRadiusWithTwo()
    }
    
    override func prepareForReuse() {
        titleLbl.text = ""
        subtitleLbl.text = ""
        subtitleLbl2.text = ""
        programImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLbl.font = UIFont.ottBoldFont(withSize: 14.0)
        subtitleLbl.font = UIFont.ottRegularFont(withSize: 12.0)
        subtitleLbl2.font = UIFont.ottRegularFont(withSize: 10.0)
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
  /*
    override var isSelected: Bool {
              willSet {
                  if newValue {
//                      self.channelNameLbl.textColor = UIColor.white
                      self.backgroundColor = UIColor.guideProgramLiveSelected
                  } else {
//                      self.channelNameLbl.textColor = UIColor.channelUnselectedTextColor
                      self.backgroundColor = UIColor.guideProgramUnselected
                  }
              }
          }
          
          override var isHighlighted: Bool {
              willSet {
                  if newValue {
                      self.backgroundColor = UIColor.guideProgramLiveSelected
                  } else {
                      self.backgroundColor = UIColor.guideProgramUnselected
                  }
              }
          }
 */
}
