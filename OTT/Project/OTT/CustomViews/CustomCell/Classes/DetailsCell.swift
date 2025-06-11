//
//  MovieDetailsCell.swift
//  YUPPTV
//
//  Created by Ankoos on 17/08/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSubTitleLabel: UILabel!
    @IBOutlet weak var movieDiscriptionLabel: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    
    @IBOutlet weak var expiryTitleLabel: UILabel!
    @IBOutlet weak var expiryTitleLabelHeightConstraint : NSLayoutConstraint?
    
    
    @IBOutlet weak var gr_overlayImageView: UIImageView!
    @IBOutlet weak var movieIconView: UIImageView!
    
    @IBOutlet weak var hdIconImageView: UIImageView!
    @IBOutlet weak var movieGradientView: UIView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var ccIconImageView: UIImageView!
    
    @IBOutlet weak var rentButton:UIButton?
    @IBOutlet weak var rentButtonWidthConstraint : NSLayoutConstraint?
    @IBOutlet weak var rentButtonHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var rentButtonTrailingConstraint : NSLayoutConstraint?
    
    @IBOutlet weak var rentInfoIcon:UIImageView?
    @IBOutlet weak var rentInfoLabel:UILabel?
    @IBOutlet weak var rentInfoHeightConstraint : NSLayoutConstraint?
    
    
    @IBOutlet weak var buttonsBgViewHeightConstraint : NSLayoutConstraint?
    
    
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var watchButtonHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var progressBar : UIProgressView?
    
    @IBOutlet weak var buttonsStackView : UIStackView?
    @IBOutlet weak var buttonsStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var trailerButton: UIButton?
    @IBOutlet weak var startOverButton: UIButton?
    @IBOutlet weak var watchlistButton: UIButton?
    
    @IBOutlet weak var watchPartyButton: UIButton?
    @IBOutlet weak var separatorLabel: UILabel?
    @IBOutlet weak var separatorLabel1: UILabel?
    @IBOutlet weak var separatorLabel2: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MovieDetailsCell: UITableViewCell {
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDiscriptionLabel: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var gr_overlayImageView: UIImageView!
    @IBOutlet weak var movieIconView: UIImageView!
    
    @IBOutlet weak var hdIconImageView: UIImageView!
    @IBOutlet weak var movieGradientView: UIView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var ccIconImageView: UIImageView!
    @IBOutlet weak var watchTrailerBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
