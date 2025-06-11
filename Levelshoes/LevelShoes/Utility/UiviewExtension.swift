//
//  UiviewExtension.swift
//  LevelShoes
//
//  Created by Maa on 17/06/20.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import Foundation
import  UIKit

func deviceIsSmallerThanIphone7() -> Bool {
    return UIApplication.shared.keyWindow?.frame.size.width ?? 0 <=  375
}
extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)

        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
        
        //use of this methed
//        let view = CustomView.loadFromXib()
//        let view = CustomView.loadFromXib(withOwner: self)
//        let view = CustomView.loadFromXib(withOwner: self, options: [UINibExternalObjects: objects])
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}


extension UIView{
    
    //        var viewToImage: UIImage? {
    //            let renderer = UIGraphicsImageRenderer(bounds: bounds)
    //            return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    //        }
    
    
    
    //        convenience init(view: UIView) {
    //            UIGraphicsBeginImageContext(view.frame.size)
    //            view.layer.render(in:UIGraphicsGetCurrentContext()!)
    //            let image = UIGraphicsGetImageFromCurrentImageContext()
    //            UIGraphicsEndImageContext()
    //            self.init(frame: image!.cgImage! as! CGRect)
    //        }
    
    
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
