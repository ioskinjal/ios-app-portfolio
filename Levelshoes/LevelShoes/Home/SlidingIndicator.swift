//
//  SlidingIndicator.swift
//  AnimationView
//
//  Created by Ruslan Musagitov on 19.06.2020.
//  Copyright © 2020 Ruslan Musagitov. All rights reserved.
//

import UIKit

class SlidingIndicator: UIView {
    var slider: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        slider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(slider)
        slider.backgroundColor = .black
        selectedItem = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slider.frame.size.height = bounds.size.height
        slider.layer.cornerRadius = bounds.size.height / 2
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
    
    var numberOfItems: Int = 1 {
        didSet {
            slider.frame.size.width = frame.width / CGFloat(numberOfItems)
        }
    }
    
    var selectedItem: Int = 0 {
        didSet {
            let sW = frame.width / CGFloat(numberOfItems)
            slider.frame.size.width = sW
            slider.frame.origin.y = 0
            slider.frame.size.height = bounds.size.height
            let centerX = stableCenterX
            UIView.animate(withDuration: 0.3, animations: {
                self.slider.center.x = centerX
            }) { _ in
                
            }
            
        }
    }

    private var stableCenterX: CGFloat {
        let sW = frame.width / CGFloat(numberOfItems)
        var centerX = CGFloat(selectedItem + 1) * sW - sW / 2
        let minCenterX = slider.frame.width / 2
        centerX = centerX > 0 ? centerX : minCenterX
        return centerX
    }
    
    override var frame: CGRect {
        didSet {
            guard oldValue.width != frame.width else { return }
            let val = selectedItem
            selectedItem = val
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            slider.center.x = stableCenterX + slider.bounds.width * progress
        }
    }
}
