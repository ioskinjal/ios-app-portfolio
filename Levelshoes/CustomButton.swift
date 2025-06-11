//
//  CustomButton.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 30.06.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    @IBInspectable var disabledBackgroundColor: UIColor = .lightGray
    private var _backgroundColor: UIColor?

    override var backgroundColor: UIColor? {
        didSet {
            _backgroundColor = backgroundColor
        }
    }
    override var isEnabled: Bool  {
        didSet {
            if let bgColor = _backgroundColor {
                backgroundColor = isEnabled ? bgColor : disabledBackgroundColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        _backgroundColor = backgroundColor
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let bgColor = _backgroundColor {
            backgroundColor = isEnabled ? bgColor : disabledBackgroundColor
        }
    }
    
}
