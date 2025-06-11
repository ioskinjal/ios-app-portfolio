//
//  Extenstion+UIVIew.swift
//  Luxongo
//
//  Created by admin on 6/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

enum BorderSide: Int {
    case all = 0, top, bottom, left, right, customRight, customBottom
}
extension UIView {
    //https://stackoverflow.com/questions/37903124/set-background-gradient-on-button-in-swift
    typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
    
    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint : CGPoint {
            return points.startPoint
        }
        
        var endPoint : CGPoint {
            return points.endPoint
        }
        
        var points : GradientPoints {
            get {
                switch(self) {
                case .topRightBottomLeft:
                    return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
                case .horizontal:
                    return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
                case .vertical:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
                }
            }
        }
    }
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
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
    
    func removeBorder() {
        self.layer.sublayers?.first?.removeFromSuperlayer()
    }
    
    func shadow(Offset: CGSize = CGSize(width: 0, height: 0), redius: CGFloat = 2, opacity:Float = 0.5, color:UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = Offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = redius
        layer.masksToBounds = false
    }
    
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func setRadius(withRatio radius: CGFloat? = nil) {
        if let radius = radius{
            self.layer.cornerRadius = (self.frame.height*(radius/100))
        }else{
            self.layer.cornerRadius = self.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    func setRadius(_ radius: CGFloat? = nil, borderWidth:CGFloat = 1.0, color:UIColor) {
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    func shadow(isCorner:Bool = false, radius:CGFloat? = nil) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
        if isCorner == false {
            self.layer.masksToBounds = true
        }
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = <scale> ? UIScreen.main.scale : 1
    }
    
    //    func parentView<T: UIView>(of type: T.Type) -> T? {
    //        guard let view = self.superview else {
    //            return nil
    //        }
    //        return (view as? T) ?? view.parentView(of: T.self)
    //    }
    
    func viewController(forView view: UIView) -> UIViewController? {
        var responder: UIResponder? = view
        repeat {
            responder = responder?.next
            if let vc = responder as? UIViewController {
                return vc
            }
        } while responder != nil
        return nil
    }
    
    func bringToFront() {
        self.superview?.bringSubviewToFront(self)
    }
    
    func sendToBack(view: UIView) {
        self.sendSubviewToBack(view)
    }
    
}



//https://stackoverflow.com/questions/31232689/how-to-set-cornerradius-for-only-bottom-left-bottom-right-and-top-left-corner-te/41217791
extension UIView {
    enum CornerBorderSide {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    //@available(iOS 11.0, *)
    func setCornersRadious(withRadious radius: CGFloat = 10.0, cornerBorderSides: [CornerBorderSide]){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var cornerMask: CACornerMask = [.layerMinXMaxYCorner]
        cornerMask.remove(.layerMinXMinYCorner)
        forLoop: for side in cornerBorderSides{
            switch side{
            case .bottomLeft:
                cornerMask.insert(.layerMinXMaxYCorner)
            case .bottomRight:
                cornerMask.insert(.layerMaxXMaxYCorner)
            case .topLeft:
                cornerMask.insert(.layerMinXMinYCorner)
            case .topRight:
                cornerMask.insert(.layerMaxXMinYCorner)
            }
        }
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = cornerMask
        } else {
            // Fallback on earlier versions
            //If not iOS 11 then apply below code
            var borderSides:[UIRectCorner] = []
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            forLoop: for side in cornerBorderSides{
                switch side{
                case .bottomLeft:
                    borderSides.append(.bottomLeft)
                case .bottomRight:
                    borderSides.append(.bottomRight)
                case .topLeft:
                    borderSides.append(.topLeft)
                case .topRight:
                    borderSides.append(.topRight)
                }
            }
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight , .topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = rectShape
        }
    }
   
    func topLeftCornerSet() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight , .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.mask = rectShape
    }
    
    func setCornerRadious(withRadious radius: CGFloat = 10.0, cornerBorderSides sides: UIRectCorner) {
        DispatchQueue.updateUI_WithDelay {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: sides, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = rectShape
        }
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: sides, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = rectShape
        }*/
    }
    
}



extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}


extension UIView {
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
            
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    // MARK: - Border

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    @IBInspectable public var borderColor: UIColor {
        get{
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    private func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                           shadowOpacity: Float = 0.18,
                           shadowRadius: CGFloat = 12.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class PassthroughImage: UIImageView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}


extension UIButton{
    func setEnable(state: Bool) {
        if state{
            self.alpha = 1.0
            self.isEnabled = true
        }else{
            self.alpha = 0.5
            self.isEnabled = false
        }
    }
}


enum AnimationDirection: Int {
    case topToBottom = 0, bottomToTop, rightToLeft, leftToRight
}

extension UIView {
    func swipeAnimation(direction: AnimationDirection = AnimationDirection.rightToLeft, duration: TimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        switch direction {
        case .topToBottom:
            leftToRightTransition.subtype =  CATransitionSubtype.fromTop
        case .bottomToTop:
            leftToRightTransition.subtype =  CATransitionSubtype.fromBottom
        case .rightToLeft:
            leftToRightTransition.subtype =  CATransitionSubtype.fromRight
        case .leftToRight:
            leftToRightTransition.subtype =  CATransitionSubtype.fromLeft
        }
        leftToRightTransition.type = CATransitionType.push
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        leftToRightTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
        //print("count:\(self.layer.sublayers!.count)")
    }
    
}

