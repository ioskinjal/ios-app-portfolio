//
//  FullscreenImageViewController.swift
//  LevelShoes
//
//  Created by Ruslan Musagitov on 07.09.2020.
//  Copyright © 2020 Kinjal.Gadhia. All rights reserved.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    var backgroundView: UIView = {
    let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView
    }()
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var close: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_close")!, for: .normal)
        return btn
    }()

    var dismissCalled = false
    var callingViewFrame: CGRect = .zero
    
    var normalZoomScale: CGFloat = 0
    var lastZoomScale: CGFloat = 0
    
    var imageWidth: NSLayoutConstraint!
    var imageHeight: NSLayoutConstraint!

    var panGesture: UIPanGestureRecognizer!
    var startY: CGFloat! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .custom
        view.backgroundColor = .white
        
        view.addSubview(backgroundView)
        backgroundView.pinToSuperview()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.pinToSuperview()
        scrollView.delegate = self
        scrollView.contentSize = imageView.frame.size
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(panGesture)
        
        close.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(close)
        close.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        close.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
        
        scrollView.showsVerticalScrollIndicator = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlpha(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.setAlpha(1)
        }, completion: nil)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == normalZoomScale {
            let rect = zoomRectForScale(scale: scrollView.maximumZoomScale - 0.1, center: recognizer.location(in: recognizer.view))
            scrollView.zoom(to: rect, animated: true)
        }
        else {
            scrollView.setZoomScale(normalZoomScale, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    @IBAction
    func closeAction() {
        dismissAnimated()
    }
    
    @IBAction
    func pan(_ recognizer: UIPanGestureRecognizer) {
        let velocityY = recognizer.velocity(in: self.view).y
        let y = getNewY(for: recognizer.translation(in: self.view).y, startY: startY, velocity: velocityY, recognizerState: recognizer.state)
        let diff: CGFloat = abs(0 - y)
        let span: CGFloat = 200
        var alpha = 1 - (1 / (span / diff))
        if diff > span {
            alpha = 0
        }
        setAlpha(alpha)
        if recognizer.state.isFinishing == true {
            if diff > view.frame.height / 3 {
                self.dismissAnimated()
            } else {
                setAlpha(1)
                scrollView.frame.origin.y = 0
            }
        } else {
            scrollView.frame.origin.y = y
        }
    }
    
    private func dismissAnimated() {
        dismissCalled = true
        imageHeight.constant = callingViewFrame.size.height
        imageWidth.constant = callingViewFrame.size.width
        UIView.animate(withDuration: 0.66, animations: {
            self.scrollView.zoomScale = 1
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
        
        self.scrollView.contentInset.top = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()

            self.scrollView.frame.origin.x = self.callingViewFrame.origin.x
            self.scrollView.frame.origin.y = self.callingViewFrame.origin.y
            self.setAlpha(0)
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        }) { _ in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        if let image = imageView.image {
            imageView.frame.size = scrollView.contentSize
            imageWidth = imageView.widthAnchor.constraint(equalToConstant: image.size.width)
            imageHeight = imageView.heightAnchor.constraint(equalToConstant: image.size.height)
            imageWidth.isActive = true
            imageHeight.isActive = true
            let screenSize = UIApplication.shared.keyWindow?.frame.size ?? image.size
            let picSize = image.size
            let picRatio = picSize.width / picSize.height
            let screenRatio = screenSize.width / screenSize.height
            var scale: CGFloat = 0
            if picRatio > screenRatio {
                scale = screenSize.height / picSize.height
            } else {
                scale = screenSize.width / picSize.width
            }
            let _scale = scale * 0.65
            scrollView.minimumZoomScale = _scale
            scrollView.zoomScale = _scale
            normalZoomScale = _scale
            scrollView.maximumZoomScale = 1
            let x = (picSize.width * _scale - scrollView.frame.width) / 2
            scrollView.contentOffset.x = x
            setAlpha(1)
            scrollView.contentInset.top = getTopInset()
            scrollView.contentInset.bottom = getTopInset()
        }
    }
    
    func getTopInset() -> CGFloat {
        return (scrollView.frame.height - scrollView.contentSize.height) / 2
    }
}

extension FullscreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        func proceed() {
            let min = normalZoomScale * 0.8
            if lastZoomScale < min {
                if dismissCalled == false {
                    dismissAnimated()
                }
            } else {
                setAlpha(1)
            }
        }
        if let state = scrollView.pinchGestureRecognizer?.state, (state == .ended || state == .cancelled || state == .failed) {
            proceed()
        }
        lastZoomScale = scrollView.zoomScale
        if dismissCalled == false {
            setAlpha(scrollView.zoomScale / normalZoomScale)
        }
    }

    func setAlpha(_ alpha: CGFloat) {
        close.alpha = alpha
        backgroundView.alpha = alpha
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale > scale {
            scrollView.zoomScale = normalZoomScale
        }
        setAlpha(1)
        panGesture.isEnabled = true
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        panGesture.isEnabled = false
    }
    
    func getNewY(for translationY: CGFloat, startY: CGFloat, velocity: CGFloat, recognizerState: UIGestureRecognizer.State) -> CGFloat {
        let y = startY + translationY
        return y
    }
}

extension UIView {
    func pinToSuperview() {
        guard let superview = self.superview else { return }
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
}
