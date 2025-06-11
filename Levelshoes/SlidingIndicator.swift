//
//  SlidingIndicator.swift
//  AnimationView
//
//  Created by Ruslan Musagitov on 19.06.2020.
//  Copyright © 2020 Ruslan Musagitov. All rights reserved.
//

import UIKit

class SlidingIndicator: UIView {
    @IBInspectable var ignoreRTL: Bool = true
    
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
        updateCenterX()
    }
    
    var numberOfItems: Int = 1 {
        didSet {
            //slider.frame.size.width = frame.width / CGFloat(numberOfItems)
            updateCenterX()
        }
    }
    
    var selectedItem: Int = 0 {
        didSet {
            updateCenterX()
        }
    }
    
    private func updateCenterX() {
        var sW:CGFloat = 0.0
        if numberOfItems < 1 {
            sW = frame.width
        }
        else{
            sW = frame.width / CGFloat(numberOfItems)
        }
        slider.frame.size.width = sW
        slider.frame.origin.y = 0
        slider.frame.size.height = bounds.size.height
        let centerX = stableCenterX
        UIView.animate(withDuration: 0.3, animations: {
            self.slider.center.x = centerX
        }) { _ in
            
        }
    }

    private var stableCenterX: CGFloat {
        // This has been added to stop crashing when no image was present in productDetail page
        var sW:CGFloat = 0.0
        if numberOfItems < 1 {
            sW = frame.width
        }
        else{
            sW = frame.width / CGFloat(numberOfItems)
        } // up to this
        if isRTL() && ignoreRTL == false {
           // let sW = frame.width / CGFloat(numberOfItems)
            var centerX = frame.width - CGFloat(selectedItem + 1) * sW + sW / 2
            let minCenterX = frame.width - slider.frame.width / 2
            centerX = centerX > frame.width ? minCenterX : centerX
            if self.selectedItem == 0 {
                return minCenterX
            }
            return centerX
        } else {
           // let sW = frame.width / CGFloat(numberOfItems)
            var centerX = CGFloat(selectedItem + 1) * sW - sW / 2
            let minCenterX = slider.frame.width / 2
            centerX = centerX > 0 ? centerX : minCenterX
            return centerX
        }
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
