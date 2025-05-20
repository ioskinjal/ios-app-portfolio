//
//  LineCustomTextField.swift
//  ThumbPin
//
//  Created by Dhruv on 09/12/18.
//  Copyright © 2018 NCT109. All rights reserved.
//

import UIKit

class LineCustomTextField: UITextField,UITextFieldDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    var bottomBorder = UIView()
    
    var bottomCon = NSLayoutConstraint()
    var leadingCons = NSLayoutConstraint()
    var trailinCons = NSLayoutConstraint()
    var heightCons = NSLayoutConstraint()
    
    var isEditingField: Bool = false {
        didSet {
            
            if (isEditingField) {
                bottomBorder.backgroundColor = Color.Custom.mainColor
                heightCons.constant = 2
            } else {
                bottomBorder.backgroundColor = Color.Custom.darkGrayColor
                heightCons.constant = 1
            }
        }
    }
    
    
    override func awakeFromNib() {
        
        // Setup Bottom-Border
        delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.gray // Set Border-Color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomBorder)
        
        bottomCon = NSLayoutConstraint.init(item: bottomBorder, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        leadingCons = NSLayoutConstraint.init(item: bottomBorder, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        trailinCons = NSLayoutConstraint.init(item: bottomBorder, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        heightCons = NSLayoutConstraint(item: bottomBorder, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 1)
        self.addConstraints([bottomCon, leadingCons, trailinCons, heightCons])
        
        //        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        //        bottomBorder.heightAnchor.constraint(equalToConstant: 10).isActive = false
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingField = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditingField = false
    }
    
}
