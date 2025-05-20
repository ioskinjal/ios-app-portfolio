//
//  StatusBarView.swift
//  Talabtech
//
//  Created by NCT 24 on 07/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class StatusBarView: UIView {

    @IBOutlet var viewStatus: UIView!{didSet{
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad{ viewStatus.backgroundColor = .white}
        }}
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
