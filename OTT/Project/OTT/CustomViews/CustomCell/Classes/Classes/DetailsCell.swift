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
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDiscriptionLabel: UITextView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var favouriteBtn: UIButton!
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
