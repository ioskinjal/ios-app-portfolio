//
//  AnimationView.swift
//  AnimationView
//
//  Created by Ruslan Musagitov on 19.06.2020.
//  Copyright © 2020 Ruslan Musagitov. All rights reserved.
//

import UIKit

protocol AnimationViewDatasource: class {
    func numberOfViews(in animationView: AnimationView) -> Int
    func animationView(_ animationView: AnimationView, viewForRowAt index: Int) -> UIView
}

protocol AnimationViewDelegate: class {
    func animationViewScrolledToIndex(animationView: AnimationView, _ index: Int)
    func animationViewScrollProgress(progress: CGFloat)
}

class AnimationView: UIView {
    func getIndexRespectRTL(_ index: Int) -> Int {
        var i = index
        if isRTL() {
            var arr = [Int]()
            for i in stride(from: 0, to: numberOfViews, by: 1) {
                arr.append(i)
            }
            arr.reverse()
            i = arr[index]
        }
        return i
    }
    var hideSliderView = false
    var datasource: AnimationViewDatasource? {
        didSet {
            reloadData()
        }
    }
    
    @IBOutlet weak var overlayView: UIView?

    var delegate: AnimationViewDelegate?
    
    func reloadData() {
        guard let datasource = datasource else {
            setEmptyState()
            return
        }
        numberOfViews = datasource.numberOfViews(in: self)
        sliderView.numberOfItems = numberOfViews
        if currentIndex >= numberOfViews {
            currentIndex = numberOfViews - 1
        }
        if numberOfViews > 0 {
            let v = datasource.animationView(self, viewForRowAt: currentIndex)
            addSubview(v)
            if let overlay = overlayView {
                bringSubview(toFront: overlay)
            }
            currentView = v
        }
        sliderView.isHidden = numberOfViews == 0 || hideSliderView
    }

    func dequeueReusableView() -> UIView? {
        //print("dequeueing from queue with \(queue.count)")
        if queue.isEmpty {
            return nil
        }
        return queue.removeFirst()
    }

    let sliderView = SlidingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 5))

    private var numberOfViews: Int = 0
    private var newIndex: Int?
    private var movingStarted = false
    private var showing = false
    
    var currentView: UIView?
    private var newView: UIView?
    
    private (set) var currentIndex = 0 {
        didSet {
            sliderView.selectedItem = currentIndex
        }
    }
    var currentImage: UIImage? {
        return (currentView as? UIImageView)?.image
    }
    private var queue = [UIView]()
    private var startX: CGFloat = 0
    private var animationStarted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    private func commonInit() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        gesture.delegate = self
        addGestureRecognizer(gesture)
        if overlayView == nil {
            overlayView = viewWithTag(1001)
        }
        sliderView.ignoreRTL = false
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview?.addSubview(sliderView)
    }
    
    private func setEmptyState() {
        let array = subviews
        for v in array {
            v.removeFromSuperview()
        }
        sliderView.isHidden = true
    }
        
    private func getNewX(for translationX: CGFloat, startX: CGFloat, velocity: CGFloat, recognizerState: UIGestureRecognizer.State) -> CGFloat {
        var x = startX + translationX
        if recognizerState.isFinishing == true {
            if (x < bounds.width / 2 || velocity < -1000) && velocity < 1000 {
                x = 0
            } else {
                x = bounds.width
            }
        } else {
            if x < 0 {
                x = 0
            } else if x > bounds.width + 1 {
                x = bounds.width
            }
        }
        return x
    }
    
    func scroll(to ind: Int, animated: Bool = true, completion:@escaping(() -> Void)) {
        let index = getIndexRespectRTL(ind)
        let curIndex = currentIndex
        if animated {
            guard ind < numberOfViews && ind >= 0 else  {
                return completion()
            }
        }
        guard let cView = currentView else { return completion() }
        guard animationStarted == false else { return completion() }
        if isRTL() {
            newIndex = index
            print("ind \(ind) currentIndex \(currentIndex)")
            showing = ind > currentIndex
        } else {
            newIndex = ind
            showing = index > currentIndex
        }
        
        newView = datasource?.animationView(self, viewForRowAt: index)
        newView?.layer.borderColor = UIColor.red.cgColor
        guard var nView = newView else { return completion() }
        nView.frame = bounds
        if showing == true {
            guard movingStarted == false && currentIndex + 1 < numberOfViews else { return completion() }
            insertSubview(nView, belowSubview: cView)
            nView = cView
        } else {
            setView(nView, x: bounds.width)
            addSubview(nView)
        }
        if let overlay = overlayView {
            bringSubview(toFront: overlay)
        }
        movingStarted = true
        startX = nView.frame.origin.x
        let x = showing ? bounds.width : 0
        currentIndex = index
        animationStarted = true
        if animated {
            let duration: TimeInterval = 0.5
            UIView.animate(withDuration: duration, animations: {
                self.setView(nView, x: x, duration)
            }) { _ in
                self.handleFinish(x, isGesture: false)
                self.sliderView.selectedItem = index
                completion()
            }
        } else {
            setView(nView, x: x)
            self.handleFinish(x, isGesture: false)
            self.sliderView.selectedItem = index
            completion()
        }
    }
    
    private func setView(_ view: UIView, x: CGFloat, _ duration: TimeInterval? = nil) {
//        if duration == nil {
//            NSLog("setView \(x)")
//        } else if let val = duration {
//            NSLog("setView \(x) duration \(val)")
//        }
        view.frame.origin.x = x
    }
    
    @IBAction
    private func pan(_ recognizer: UIPanGestureRecognizer) {
        let _index = currentIndex
        guard let cView = currentView else { return }
        guard animationStarted == false else { return }
        guard _index < numberOfViews else {
            return }
        let velocityX = recognizer.velocity(in: self).x
        if recognizer.state == .began {
            let isAllowedToGoBack = (velocityX > 0 && _index > 0)
            let isAllowedToGoForward = (velocityX < 0 && _index + 1 < numberOfViews)
            guard isAllowedToGoBack || isAllowedToGoForward else {
                return }
            let index: Int
            if velocityX > 0 && _index > 0 {
                index = _index - 1
            } else {
                index = _index + 1
            }
            newView = datasource?.animationView(self, viewForRowAt: index)
        }
        guard var nView = newView else {
            return
        }
        func handleHiding() {
            if movingStarted == false && _index - 1 < numberOfViews && _index > 0 {
                newIndex = _index - 1
                nView.frame = bounds
                insertSubview(nView, belowSubview: cView)
                nView = cView
                showing = false
            } else {
                nView = cView
            }
        }
        func handleShowing() {
            guard movingStarted == false && _index + 1 < numberOfViews else { return }
            newIndex = _index + 1
            nView.frame = bounds
            nView.frame.origin.x += bounds.width
            addSubview(nView)
            showing = true
        }
        
        if movingStarted == false && velocityX > 0 {
            handleHiding()
        } else if movingStarted == false {
            handleShowing()
        } else if movingStarted == true && showing {
            handleShowing()
        } else {
            handleHiding()
        }
        if let overlay = overlayView {
            bringSubview(toFront: overlay)
        }
        movingStarted = true
        
        if recognizer.state == .began {
            startX = nView.frame.origin.x
        }
        let x = getNewX(for: recognizer.translation(in: self).x, startX: startX, velocity: velocityX, recognizerState: recognizer.state)
        
        var progress: CGFloat = 0
        if showing {
            progress = 1 - x / frame.width
        } else {
            progress = -x / frame.width
        }
        delegate?.animationViewScrollProgress(progress: progress)
        sliderView.progress = progress
        
        if recognizer.state.isFinishing == true {
            animationStarted = true
            let duration: TimeInterval = 0.3
            UIView.animate(withDuration: duration, animations: {
                self.setView(nView, x: x, duration)
            }) { _ in
                self.handleFinish(x, isGesture: true)
            }
        } else {
            setView(nView, x: x)
        }
    }
    
    private func handleFinish(_ x: CGFloat, isGesture: Bool = true) {
        guard movingStarted else {
            return
        }
        var subviewsMoreThanOne = subviews.filter {
            $0 != self.overlayView
        }.count > 1
        while subviewsMoreThanOne == true {
            if (showing == true && startX != x) || (showing == false && startX == x) {
                if isGesture {
                    removeBack()
                } else {
                    removeFront()
                }
            } else {
                if isGesture {
                    removeFront()
                } else {
                    removeBack()
                }
            }
            subviewsMoreThanOne = subviews.filter {
                $0 != self.overlayView
                }.count > 1
        }
        if startX != x {
            currentIndex = newIndex!
            currentView = newView
            if isGesture {
                delegate?.animationViewScrolledToIndex(animationView: self, currentIndex)
            }
        }
        movingStarted = false
        startX = 0
        newView = nil
        newIndex = nil
        animationStarted = false
    }
    
    
    private func removeFront() {
        var v = subviews.last
        if v == overlayView {
            v = subviews[subviews.count - 2]
        }
        guard let _v = v else { return }
        queue.append(_v)
        _v.removeFromSuperview()
    }
    
    private func removeBack() {
        var v = subviews.first
        if v == overlayView {
            v = subviews[1]
        }
        guard let _v = v else { return }
        queue.append(_v)
        _v.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if currentView?.bounds.size != bounds.size {
            currentView?.frame = bounds
        }
        let padding: CGFloat = 10
        sliderView.frame = CGRect(x: padding, y: frame.height - 40, width: frame.width - 2 * padding, height: 5)
    }
}

extension UIGestureRecognizer.State {
    var description: String {
        switch self {
            case .possible:
                return "possible"
            case .began:
                return "began"
            case .changed:
                return "changed"
            case .ended:
                return "ended"
            case .cancelled:
                return "cancelled"
            case .failed:
                return "failed"
        }
    }
    var isFinishing: Bool {
        switch self {
            case .ended, .failed, .cancelled:
                return true
            default:
                return false
        }
    }
}

extension AnimationView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
}
