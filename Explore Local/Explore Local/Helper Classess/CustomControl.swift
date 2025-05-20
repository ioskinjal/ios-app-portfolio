//
//  CustomControl.swift
//  Talabtech
//
//  Created by NCT 24 on 06/04/18.
//  Copyright © 2018 NCT 24. All rights reserved.
//

import UIKit

class WhiteBorderButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        //backgroundColor = appColor.greenColor
        setTitleColor(Color.white, for: .normal)
        titleLabel?.font = RobotoFont.regular(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(self.bounds.height * 0.2, borderWidth: 1.0, color: Color.white)
    }
    
}

class GreenButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        backgroundColor = Color.green.theam
        setTitleColor(Color.white, for: .normal)
        titleLabel?.font = RobotoFont.medium(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(self.bounds.height * 0.1)
    }
    
}

