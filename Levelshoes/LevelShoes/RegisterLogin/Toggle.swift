//
//  Toggle.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 10.07.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

protocol ToggleDelegate: class {
    func toggleChanged(_ toggle: Toggle)
}

class Toggle: UIView {
    weak var delegate: ToggleDelegate?

    private var startX: CGFloat = 0
    private var button = UIButton(type: .custom)
    private (set) var isOn = true
    
    override var backgroundColor: UIColor? {
        didSet {
            layer.borderColor = backgroundColor?.cgColor
        }
    }
    
    private var indicator: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @IBAction
    private func tap() {
        setOn(!isOn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
        indicator.frame.origin.y = 2
        indicator.frame.size.height = bounds.size.height - 4
    }
    
    func commonInit() {
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        addSubview(button)
        let img = UIImage(named: "Grip-trimmed")!
        indicator = UIImageView(image: img)
        layer.borderWidth = 2
        layer.cornerRadius = 2
        layer.masksToBounds = true
        addSubview(indicator)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        addGestureRecognizer(gesture)
    }
    
    private func getColor(for x: CGFloat) -> UIColor {
        var w = (maxIndX - x)/maxIndX
        w = min(w, 0.95)
        print("w \(w)")
        return UIColor(white: w, alpha: 1)
    }
    
    @IBAction
    func pan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            startX = indicator.frame.origin.x
        }
        let x = getNewX(for: recognizer.translation(in: self).x, startX: startX, recognizerState: recognizer.state)
        indicator.frame.origin.x = x
        setColor(getColor(for: x))
        if recognizer.state.isFinishing {
            isOn = indicator.frame.origin.x != (0 + layer.borderWidth)
            self.delegate?.toggleChanged(self)
        }
    }
    
    private func setColor(_ color: UIColor) {
        backgroundColor = color
        layer.borderColor = color.cgColor
    }
    
    func setOn(_ value: Bool) {
        isOn = value
        let x = value == true ? maxIndX : (0 + layer.borderWidth)
        UIView.animate(withDuration: 0.3, animations: {
            self.indicator.frame.origin.x = x
            self.setColor(self.getColor(for: x))
        }) { _ in
            self.delegate?.toggleChanged(self)
        }
    }
    
    var maxIndX: CGFloat {
        return bounds.width - indicator.frame.width - layer.borderWidth
    }
    
    var minIndX: CGFloat {
        return layer.borderWidth
    }
    
    private func getNewX(for translationX: CGFloat, startX: CGFloat, recognizerState: UIGestureRecognizer.State) -> CGFloat {
        var x = startX + translationX
        let midIndX = x + indicator.frame.width / 2
        if recognizerState.isFinishing == true {
            if midIndX < (bounds.width - layer.borderWidth) / 2 {
                x = minIndX
            } else {
                x = maxIndX
            }
        } else {
            if x < 0 {
                x = minIndX
            } else if x > maxIndX  {
                x = maxIndX
            }
        }
        return x
    }
    
}
