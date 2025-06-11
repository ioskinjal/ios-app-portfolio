//
//  CustomActivityIndicatorView.swift
//  kurs
//
//  Created by Sergey Yuryev on 22/01/15.
//  Copyright (c) 2015 syuryev. All rights reserved.
//

import UIKit
import QuartzCore

class CustomActivityIndicatorView: UIView {
    
    // MARK - Variables
    
    lazy var animationLayer : CALayer = {
        return CALayer()
    }()
    
    var isAnimating : Bool = false
    var hidesWhenStopped : Bool = true
//    var indicatorView: UIView? = nil
    // MARK - Init
    
    enum loaderSize {
        /// actual loader image size
        case full
        /// half of the loader image size
        case half
    }
    
    init(image : UIImage) {
        let frame : CGRect = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        super.init(frame: frame)

        animationLayer.frame = frame
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true

        self.layer.addSublayer(animationLayer)
        
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    func changeSize(image : UIImage, type : loaderSize = .full){
        var imageFrame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        if type == .half{
            imageFrame = CGRect(x: (image.size.width - (image.size.width / 2.0))/2.0, y:  (image.size.height - (image.size.height / 2.0))/2.0, width: image.size.width / 2.0, height: image.size.height/2.0)
        }
        let frame : CGRect = imageFrame
        //            CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        animationLayer.frame = frame
    }
    
    deinit {
        print("deinit activity view")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
//        print(#function)
        AppDelegate.getDelegate().activityIndicator.center = (UIApplication.shared.keyWindow?.center)!
    }
    
    func setIndicatorOrientation()  {
//        if indicatorView != nil {
//            indicatorView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//            indicatorView?.layer.cornerRadius = (indicatorView?.frame.size.width)!/2
//            let window = AppDelegate.getDelegate().window
//            indicatorView?.center.x = (window?.center.x)!
//            indicatorView?.center.y = (window?.center.y)!
//            
//        }
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(image: #imageLiteral(resourceName: "loader_icon"))
    }
    
    // MARK - Func
    
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: 3.14 * 2.0)
        
        layer.add(rotation, forKey: "rotate")
    }

    func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        isAnimating = false
    }

    func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
    }

    func startAnimating () {
        if UIApplication.shared.keyWindow == nil {
            return
        }
        AppDelegate.getDelegate().activityIndicator.center = (UIApplication.shared.keyWindow?.center)!
        if isAnimating {
            return
        }
//        let window =  UIApplication.shared.keyWindow
//        let window = AppDelegate.getDelegate().window
//        indicatorView = UIView()
//        indicatorView?.backgroundColor = UIColor.clear
//        indicatorView?.addSubview(self)
//        setIndicatorOrientation()
//        window?.addSubview(indicatorView!)
        if !(AppDelegate.getDelegate().activityIndicator.superview != nil) {
            UIApplication.shared.keyWindow?.addSubview(AppDelegate.getDelegate().activityIndicator)
        }
        UIApplication.shared.keyWindow?.bringSubviewToFront(AppDelegate.getDelegate().activityIndicator)

        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
        if playerVC != nil && playerVC?.isFullscreen == true {
            stopAnimating()
        }
    }
    
    func startAnimatingFromPlayer () {
        
        AppDelegate.getDelegate().activityIndicator.center = (UIApplication.shared.keyWindow?.center)!
        if isAnimating {
            return
        }
//        let window =  UIApplication.shared.keyWindow
//        let window = AppDelegate.getDelegate().window
//        indicatorView = UIView()
//        indicatorView?.backgroundColor = UIColor.clear
//        indicatorView?.addSubview(self)
//        setIndicatorOrientation()
//        window?.addSubview(indicatorView!)
        if !(AppDelegate.getDelegate().activityIndicator.superview != nil) {
            UIApplication.shared.keyWindow?.addSubview(AppDelegate.getDelegate().activityIndicator)
        }
        UIApplication.shared.keyWindow?.bringSubviewToFront(AppDelegate.getDelegate().activityIndicator)

        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }

    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(layer: animationLayer)
//        indicatorView?.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
