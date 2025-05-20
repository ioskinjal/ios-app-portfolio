//
//  UiView+Layer.swift
//  BooknRide
//
//  Created by NCrypted on 06/11/17.
//  Copyright © 2017 NCrypted Technologies. All rights reserved.
//

import Foundation
import UIKit

 extension UIView{

 func applyBorder(color:UIColor,width:CGFloat){
    
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = width
}
    
    func applyCorner(radius:CGFloat){
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

}
