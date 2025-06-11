//
//  PRHeaderTableViewCell.swift
//  OTT
//
//  Created by Muzaffar Ali on 24/06/19.
//  Copyright © 2019 Chandra Sekhar. All rights reserved.
//

import UIKit
@objc protocol PRHeaderTableViewCellDelegate {
    @objc func closeButtonTap()
}

class PRHeaderTableViewCell: UITableViewCell {
    static let identifier = "PRHeaderTableViewCell"
    static let nibName = "PRHeaderTableViewCell"
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var bitrateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var subtitle1Label: UILabel!
    @IBOutlet weak var subtitle2Label: UILabel!
    
    @IBOutlet weak var subtitleLabelTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLabel1TopConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLabel2TopConstraint: NSLayoutConstraint?
    @IBOutlet weak var subtitleLabel2HeightConstraint: NSLayoutConstraint?
    
    
    @IBOutlet weak var playerStatusLabel: UILabel!
    @IBOutlet weak var playerStatusLabelWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusLabelWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var statusLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusLabelTrailingConstraint: NSLayoutConstraint!
    weak var delegate : PRHeaderTableViewCellDelegate?
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightconstraint: NSLayoutConstraint!
    
    var isFromPlayerPage = false
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.layer.borderWidth = 1
        playerStatusLabel.layer.borderWidth = 1
        // Initialization code
        self.titleLabel.font = UIFont.ottRegularFont(withSize: 16)
        let fontVal = (productType.iPad ? 14 : 12)
        self.subtitleLabel.font = UIFont.ottRegularFont(withSize: CGFloat(fontVal))
        self.subtitle1Label.font = UIFont.ottRegularFont(withSize: CGFloat(fontVal))
        self.subtitle2Label.font = UIFont.ottRegularFont(withSize: CGFloat(fontVal))
        self.statusLabel.font = UIFont.ottRegularFont(withSize: 10)
        self.playerStatusLabel.font = UIFont.ottRegularFont(withSize: 10)
        let imageWidth = (isFromPlayerPage ? (productType.iPad ? 168 : 110)  : (productType.iPad ? 190 : 125))
        self.imageWidthConstraint.constant = CGFloat(imageWidth)
        self.imageHeightconstraint.constant = CGFloat((imageWidth * 9/16))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func closeButtonTap(_ sender: Any) {
        delegate?.closeButtonTap()
        self.delegate = nil
    }
    
    func setStatus(status : String?, statusElementSubtype : String? ){
        guard status != nil, statusElementSubtype != nil, status != "", statusElementSubtype != "" else {
            self.statusLabel.isHidden = true
            self.playerStatusLabel.isHidden = true
            return
        }
        
        let colorCode = (statusElementSubtype == "available_soon_label") ? "bbbbbb" : "e01d29" // expires, available_soon_label,availableUntil
        let borderColor : UIColor = UIColor.init(hexString: colorCode)
        
        if isFromPlayerPage {
            self.statusLabel.isHidden = true
            self.playerStatusLabel.isHidden = false
            playerStatusLabel.text = status!
            playerStatusLabel.layer.borderWidth = 1
            playerStatusLabel.layer.borderColor = borderColor.cgColor
            playerStatusLabel.layer.cornerRadius = 2
            playerStatusLabel.sizeToFit()
        }
        else {
            self.playerStatusLabel.isHidden = true
            self.statusLabel.isHidden = false
            statusLabel.text = status!
            statusLabel.layer.borderWidth = 1
            statusLabel.layer.borderColor = borderColor.cgColor
            statusLabel.layer.cornerRadius = 2
            statusLabel.sizeToFit()
        }
       
        
        var width = (isFromPlayerPage ? playerStatusLabel.frame.width : statusLabel.frame.width)
        width += 40
        if width > 180{
            //width = 180
        }
        if isFromPlayerPage {
            self.subtitle1Label.sizeToFit()
            self.playerStatusLabelWidthConstraints.constant = width
            self.statusLabelWidthConstraints.constant = 0
        }
        else {
            self.playerStatusLabelWidthConstraints.constant = 0
            self.statusLabelWidthConstraints.constant = width
            
            if (statusElementSubtype == "availableUntil") {
                statusLabelTopConstraint.constant = -13
                let ww = superview?.frame.size.width ?? (AppDelegate.getDelegate().window!.frame.size.width)
                statusLabelTrailingConstraint.constant = ww - width - self.imageWidthConstraint.constant - 25
            }
            else {
                statusLabelTopConstraint.constant = 3
                statusLabelTrailingConstraint.constant = 10
            }
        }
    }
    
    deinit {
        printYLog(#function);
    }
    
}
