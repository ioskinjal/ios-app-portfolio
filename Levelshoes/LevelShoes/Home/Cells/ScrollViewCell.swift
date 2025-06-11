//
//  ScrollViewCell.swift
//  LevelShoes
//
//  Created by Kinjal.Gadhia on 02/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class ScrollViewCell: UITableViewCell {
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var source: SourceLanding.DataList? {
        didSet {
            guard let source = source else { return }
            let language = UserDefaults.standard.value(forKey: string.language) as? String
            lblTitle.text = source.title.uppercased()
            lblSubTitle.text = source.subtitle.uppercased()
            if language == "en" {
                lblTitle.addTextSpacing(spacing: 1.0)
                lblSubTitle.addTextSpacing(spacing: 1.5)
            }
        }
    }
}
