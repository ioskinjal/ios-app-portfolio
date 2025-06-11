//
//  ActiveStreamTableViewCell.swift
//  OTT
//
//  Created by Muzaffar Ali on 12/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

@objc protocol ActiveStreamTableViewCellDelegate {
    @objc func closeScreenTap(for cell:ActiveStreamTableViewCell, streamActiveSession : StreamActiveSession)
}

class ActiveStreamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var closeScreenButton : UIButton!
    @IBOutlet weak var iconImageView: UIImageView?
    weak var delegate : ActiveStreamTableViewCellDelegate?
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    lazy var streamActiveSession = StreamActiveSession.init([:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setStreamActiveSession(streamActiveSession : StreamActiveSession){
        self.streamActiveSession = streamActiveSession
        self.titleLabel?.text = streamActiveSession.deviceName
        self.iconImageView?.loadingImageFromUrl(streamActiveSession.deviceIconUrl, category: "device")
    }
    
    @IBAction func closeScreenTap(_ sender: UIButton) {
        self.delegate?.closeScreenTap(for: self, streamActiveSession: self.streamActiveSession)
        printYLog(#function)
    }
}


