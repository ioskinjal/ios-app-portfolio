//
//  StatusBarView.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class StatusBarView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   
    
}
