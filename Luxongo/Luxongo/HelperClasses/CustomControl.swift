//
//  CustomControl.swift
//  Talabtech
//
//  Created by Nirav Sapariya on 06/04/18.
//  Copyright © 2018 NMS. All rights reserved.
//

import UIKit

//class TextField: UITextField {
//
//    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.font = Font.RobotoBold.size(.large) //MuliBold.size(.large)
//        self.backgroundColor = TextFieldBgColor
//        Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
//        //fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc private func loadUI() {
//        self.setRadius()
//    }
//
//}

class TextField: UITextField {
    
    var isPreventCaret:Bool = false
    var isPreventTextEntry = false
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = Font.SourceSerifProRegular.size(self.font!.pointSize) //MuliBold.size(.large)
        self.textColor = Color.grey.textFieldTextClr
        self.borderStyle = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        localize()
        //self.setPlaceHolderColor(color: Color.grey.placeHolder)
        //self.backgroundColor = TextFieldBgColor
        //Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(loadUI), userInfo: nil, repeats: false)
        //fatalError("init(coder:) has not been implemented")
        
        //self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //self.addTarget(self, action: #selector(textFieldDidEndChange), for: .editingDidEnd)
    }
    
//    func preventTextEntery(viewContriller vc: UIViewController) {
//        self.addTarget(vc, action: #selector(textFieldDidChange), for: .editingChanged)
//    }
    
    @objc func textFieldDidChange(_ sender: TextField) {
        if isPreventTextEntry{
            sender.isUserInteractionEnabled = false
        }
    }
    
    @objc func textFieldDidEndChange(_ sender: TextField) {
        if isPreventTextEntry{
            sender.isUserInteractionEnabled = true
        }
    }
    
    @objc private func loadUI() {
        //self.setRadius()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return  ( isPreventCaret ? CGRect.zero : super.caretRect(for: position) )
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isPreventCaret &&
            (action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) ) {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
    
}


class BlackTabButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.numberOfLines = 2
        titleLabel?.minimumScaleFactor = 0.5
        setTitleColor(Color.Black.tabSelected, for: .normal)
        setTitleColor(UIColor.darkText, for: .selected)
        titleLabel?.font = Font.SourceSerifProBold.size((self.titleLabel?.font.pointSize)!)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        
    }
    
}

class BlackButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(Color.Black.textColor, for: .normal)
        titleLabel?.font = Font.SourceSerifProBold.size((self.titleLabel?.font.pointSize)!)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
       
    }
    
}

class GreyButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(Color.grey.textColor, for: .normal)
        titleLabel?.font = Font.SourceSerifProBold.size((self.titleLabel?.font.pointSize)!)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        
    }
    
}

class OrangeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(Color.Orange.theme, for: .normal)
        titleLabel?.font = Font.SourceSerifProBold.size((self.titleLabel?.font.pointSize)!)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        
    }
    
}

class BlackBgButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.black
        titleLabel?.font = Font.SourceSerifProBold.size((self.titleLabel?.font.pointSize)!)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc private func loadUI() {
        self.setRadius(withRatio: 12.0)
    }
    
}


class LabelBold: UILabel {
    required init?(coder aDecoder: NSCoder) {
        // decode clientName and time if you want
        super.init(coder: aDecoder)
        self.font = Font.SourceSerifProBold.size(self.font.pointSize)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @objc private func loadUI() {
       
    }
}
class LabelRegular: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = Font.SourceSerifProRegular.size(self.font.pointSize)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @objc private func loadUI() {
        
    }
}
class LabelSemiBold: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = Font.SourceSerifProSemibold.size(self.font.pointSize)
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @objc private func loadUI() {
        
    }
}

class GreyView: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = Color.grey.bgView
        DispatchQueue.updateUI_WithDelay {
            self.loadUI()
        }
        localize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @objc private func loadUI() {
        self.setRadius(withRatio: 12.0)
    }
}


extension UILabel{
    func localize() {
        self.text = self.text?.localized
        //If current language is RTL then execute this code.
        if self.textAlignment == .natural{
            self.textAlignment = .left //default alignment
        }
        if UserData.shared.isRTL {
            if self.textAlignment == .right{
                self.textAlignment = .left
            }else if self.textAlignment == .left{
                self.textAlignment = .right
            }
        }
    }
}


extension UITextField{
    func localize() {
        self.placeholder = self.placeholder?.localized
        //If current language is RTL then execute this code.
        if self.textAlignment == .natural{
            self.textAlignment = .left //default alignment
        }
        if UserData.shared.isRTL {
            if self.textAlignment == .right{
                self.textAlignment = .left
            }else if self.textAlignment == .left{
                self.textAlignment = .right
            }
            self.semanticContentAttribute = .forceRightToLeft
        }
    }
}


extension UIButton{
    func localize() {
        //How to make a button glow when tapped with showsTouchWhenHighlighted
        //self.showsTouchWhenHighlighted = true
        
        setTitle(self.title(for: self.state)?.localized, for: self.state)
        //If current language is RTL then execute this code.
        if UserData.shared.isRTL {
            if self.contentHorizontalAlignment == .left{
                self.contentHorizontalAlignment = .right
            }else if self.contentHorizontalAlignment == .right{
                self.contentHorizontalAlignment = .left
            }
            //For image
            self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            if let img = self.backgroundImage(for: self.state){
                self.setBackgroundImage(img.imageFlippedForRightToLeftLayoutDirection(), for: self.state)
            }
            self.semanticContentAttribute = .forceRightToLeft
        }
    }
}





/*

fileprivate var selectedTextColorHandle: UInt8 = 0

extension UIButton{
    
    @IBInspectable
    var selectedTextColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedTextColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                objc_setAssociatedObject(self, &selectedTextColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.setTitleColor(color, for: .selected)
            } else {
                self.setTitleColor(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedTextColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
}

*/

/*

//https://spin.atomicobject.com/2018/04/25/uibutton-background-color/
// Declare a global var to produce a unique address as the assoc object handle
fileprivate var disabledColorHandle: UInt8 = 0
fileprivate var highlightedColorHandle: UInt8 = 0
fileprivate var selectedColorHandle: UInt8 = 0


extension UIButton {
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
    
    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var selectedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

*/
