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

class SignInButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        backgroundColor = Color.cyan.theam
        setTitleColor(self.titleLabel?.textColor, for: .normal)
        titleLabel?.font = RobotoFont.regular(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(6.0)
    }
    
}

class weekButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        backgroundColor = UIColor.clear
        setTitleColor(self.titleLabel?.textColor, for: .normal)
        titleLabel?.font = RobotoFont.medium(with: (self.titleLabel?.font.pointSize)!)
        self.border(side: .all, color: UIColor(red: 228/255.0, green: 233/255.0, blue: 234/255.0, alpha: 1.0), borderWidth: 1.0)
        //self.setRadius(6.0)
    }
    
}

class Textfield: UITextField {
    
    fileprivate let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.inset(by: padding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.inset(by: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
       
        //text?.font = RobotoFont.regular(with: (self.titleLabel?.font.pointSize)!)
        self.setRadius(6.0)
       // self.setPlaceHolderColor(color: UIColor(red: 57/255.0, green: 66/255.0, blue: 75/255.0, alpha: 1.0))
        self.border(side: .all, color: UIColor(red: 230/255.0, green: 233/255.0, blue: 234/255.0, alpha: 100), borderWidth: 1.0)
    }
    
}

