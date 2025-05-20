//
//  UiView+Layer.swift
//  BooknRide
//
//  Created by NCrypted on 06/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import Foundation
import UIKit

enum BorderSide: Int {
    case all = 0, top, bottom, left, right, customRight, customBottom
}

 extension UIView{

 func applyBorder(color:UIColor,width:CGFloat){
    
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = width
}
    
    
    func applyCorner(radius:CGFloat){
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func border(side: BorderSide = .all, color:UIColor = UIColor.black, borderWidth:CGFloat = 1.0) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = borderWidth
        
        switch side {
        case .all:
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = color.cgColor
        case .top:
            border.frame = CGRect(x: 0, y: 0, width:self.frame.size.width ,height: borderWidth)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:self.frame.size.width ,height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        case .customRight:
            border.frame = CGRect(x: self.frame.size.width - borderWidth - 8, y: 8, width: borderWidth, height: self.frame.size.height - 16)
        case .customBottom:
            border.frame = CGRect(x: 8, y: self.frame.size.height - borderWidth , width:self.frame.size.width - 16 ,height: borderWidth)
        }
        
        if side.rawValue != 0 {
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
        
    }

}

