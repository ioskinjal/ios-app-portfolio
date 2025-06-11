
//  playerHolderViewAnimation.swift
//  swippe
//
//  Created by Mohan on 6/26/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//
import UIKit

enum UIPanGestureRecognizerDirection {
    case undefined
    case up
    case down
    case left
    case right
}

extension PlayerViewController {
    
    
    //MARK: Video Animations
    
    func setPlayerToFullscreen(_ clicked: Int) {
        Log(message: "\(#function)")
        
        if self.isMinimized == true {
            self.minimizeViews()
            return;
        }
        self.hideControls = true
        self.showHideControllers()
        if self.playerErrorCode == -1000 {
            if self.navView != nil {
                self.navView.alpha = 1.0
                self.navView.isHidden = false
            }
        }
        if self.orientation() == UIDeviceOrientation.landscapeLeft {
            Log(message: "lsl")
            expandViews(isInitialSetUp: false, "right",11)
            self.changeSubtitleFontSizeTo(12.0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
            self.navBarButtonsStackViewBottomConstraint?.constant = 5
            self.navViewTopConstraint?.constant = 16
        } else if self.orientation() == UIDeviceOrientation.landscapeRight {
            Log(message: "lsr")
            expandViews(isInitialSetUp: false,"" ,12)
            self.changeSubtitleFontSizeTo(12.0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
            self.navBarButtonsStackViewBottomConstraint?.constant = 5
            self.navViewTopConstraint?.constant = 16
        } else if self.orientation() == UIDeviceOrientation.portrait {
            Log(message: "p")
            self.changeSubtitleFontSizeTo(12.0)
            if clicked == 1 {
                self.motionOrientation(completionHandler: { (orient) in
                    if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                        var value = 4
                        if (orient == 3 || orient == 4) {
                            value = orient
                        }
                        UIDevice.current.setValue(value, forKey: "orientation")
                        UIViewController.attemptRotationToDeviceOrientation()
                        UINavigationController.attemptRotationToDeviceOrientation()
                    } else {
                        self.expandViews(isInitialSetUp: false,"" ,13)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
                    }
                })
            } else {
                self.prevPlayerOrientation = UIDevice.current.orientation
                self.setPlayerToNormalScreen()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
            }
            if productType.iPhone && DeviceType.IS_IPHONE_X {
                self.navBarButtonsStackViewBottomConstraint?.constant = 0
                self.navViewTopConstraint?.constant = 20
            }
            else {
                self.navBarButtonsStackViewBottomConstraint?.constant = 5
                self.navViewTopConstraint?.constant = 16
            }
        } else if self.orientation() == UIDeviceOrientation.portraitUpsideDown {
            Log(message: "pud")
            self.changeSubtitleFontSizeTo(12.0)
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                self.prevPlayerOrientation = UIDevice.current.orientation
                self.setPlayerToNormalScreen()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
            }
            
            if productType.iPhone && DeviceType.IS_IPHONE_X {
                self.navBarButtonsStackViewBottomConstraint?.constant = 0
                self.navViewTopConstraint?.constant = 20
            }
            else {
                self.navBarButtonsStackViewBottomConstraint?.constant = 5
                self.navViewTopConstraint?.constant = 16
            }
            
        }
    }
    
    func setPlayerToNormalScreen() {
        Log(message: "\(#function)")
        
        if productType.iPhone && DeviceType.IS_IPHONE_X {
            self.navBarButtonsStackViewBottomConstraint?.constant = 0
            self.navViewTopConstraint?.constant = 20
        }
        else {
            self.navBarButtonsStackViewBottomConstraint?.constant = 5
            self.navViewTopConstraint?.constant = 16
        }
        
//        UIApplication.shared.isStatusBarHidden = false
        let tmpHeight = self.playerHeightActual()
//        print("##", tmpHeight)
//        print(self.playerHolderView.frame)
//        print(self.containerView.frame)
        if self.fullScreenButton != nil {
            //self.itemHideShow(self.fullScreenButton, hidden: true)
        }

        if self.playerHolderView != nil {
//            self.playerHolderView.translatesAutoresizingMaskIntoConstraints = false
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            
//            print("######")
//            print(self.playerHolderView.frame)
//            print(self.containerView.frame)
            if self.playerWidth != nil{
                self.playerWidth.constant = (self.winFrm?.size.width)!
            }
            if self.playerControlsWidth != nil{
                self.playerControlsWidth.constant = (self.winFrm?.size.width)!
            }
            if self.isFullscreen {
                //                self.playerHolderView.frame = self.view.frame
                if self.playerHolderView != nil{
                    if self.playerHeight != nil{
                self.playerHeight.constant = (self.winFrm?.size.height)!
                    }
                self.playerHolderView.frame.origin = CGPoint(x: 0.0, y: 0.0)
                    if self.playerIndicatorView != nil {
                self.playerIndicatorView?.center = self.playerHolderView.center
                    }
                    if self.defaultPlayingItemViewViewHeightConstraint != nil {
                        self.defaultPlayingItemViewViewHeightConstraint.constant = (self.winFrm?.size.height)!
                    }
/*
                    self.suggestionsButton.isHidden = false
                    self.suggestionsButton.alpha = 1.0
 */
//                UIApplication.shared.isStatusBarHidden = true
                }
            } else {
                if self.playerHeight != nil{
                if self.playerHolderView != nil{
                self.playerHeight.constant = tmpHeight
                    }
                    if self.playerControlsHeight != nil {
                        self.playerControlsHeight.constant = tmpHeight
                    }
                self.playerHolderView.frame.origin = CGPoint(x: 0.0, y: 20.0)
                    if self.playerIndicatorView != nil {
                self.playerIndicatorView?.center = self.playerHolderView.center
                    }
                    if self.defaultPlayingItemViewViewHeightConstraint != nil {
                        self.defaultPlayingItemViewViewHeightConstraint.constant = tmpHeight
                    }
//                UIApplication.shared.isStatusBarHidden = false
                }
                /*
                self.suggestionsButton.isHidden = true
                self.suggestionsButton.alpha = 0.0
                */
            }
            self.view.frame.origin = CGPoint(x: 0.0, y: 0.0)
//            print("-----")
//            print(self.playerHolderView.frame)
//            print(self.containerView.frame)
            if self.containerView != nil {
            self.containerView.alpha = 1.0
            }
        }, completion: { finished in
//            print("############")
//            print(self.playerHolderView.frame)
//            print(self.containerView.frame)
            self.changeSubtitleFontSizeTo(12.0)
            if self.fullScreenButton != nil {
                //self.itemHideShow(self.fullScreenButton, hidden: false)
            }

            self.handleGestureAddRemove()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeAutoResizingMaskConstraints"), object: nil)
        })
    }
    
    func itemHideShow(_ sender: UIButton, hidden: Bool) -> Void {
        sender.isHidden = hidden
    }
    
    @objc func panAction(_ recognizer: UIPanGestureRecognizer) {
        print(#function)
        let yPlayerLocation = recognizer.location(in: self.view?.window).y
        print("yPlayerLocation: ", yPlayerLocation)
        self.isPlayerDragging = true
        switch recognizer.state {
        case .began:
            onRecognizerStateBegan(yPlayerLocation, recognizer: recognizer)
            break
        case .changed:
            onRecognizerStateChanged(yPlayerLocation, recognizer: recognizer)
            break
        default:
            onRecognizerStateEnded(yPlayerLocation, recognizer: recognizer)
        }
    }
    
    func onRecognizerStateBegan(_ yPlayerLocation: CGFloat, recognizer: UIPanGestureRecognizer) {
        print(#function)
        //        containerView.backgroundColor = UIColor.darkGray
        self.hideControls = true
        self.viewInTransition = true
        self.showHideControllers()
        if self.playerErrorCode == -1000 {
            if self.navView != nil {
            self.navView.alpha = 1.0
            self.navView.isHidden = false
            }
        }
        panGestureDirection = UIPanGestureRecognizerDirection.undefined
        initialGestureDirection = UIPanGestureRecognizerDirection.undefined
        
        let velocity = recognizer.velocity(in: recognizer.view)
        detectPanDirection(velocity)
        initialGestureDirection = panGestureDirection
//        self.playerHolderViewMinimizedFrame = self.playerHolderView.frame
        self.viewMinimizedFrame = self.view.frame
        if self.playerHolderView != nil{

        print("playerHolderViewMinimizedFrame: \(viewMinimizedFrame!): \(playerHolderView.frame)")
        
        touchPositionStartX = recognizer.location(in: self.playerHolderView).x
        touchPositionStartY = recognizer.location(in: self.playerHolderView).y
        }
        print("touchPositionStart 1 : ", touchPositionStartX as Any, touchPositionStartY as Any)
        if self.isMinimized == false {
//            self.view.backgroundColor = UIColor.clear
        }
    }
    
    func onRecognizerStateChanged(_ yPlayerLocation: CGFloat, recognizer: UIPanGestureRecognizer) {
        //printYLog(#function)
        self.winFrm = UIApplication.shared.keyWindow?.frame
        if (panGestureDirection == UIPanGestureRecognizerDirection.down ||
            panGestureDirection == UIPanGestureRecognizerDirection.up) {
            if isMinimized && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone && (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight){
                return
            }
            let trueOffset = yPlayerLocation - touchPositionStartY!
            let xOffset = trueOffset * self.scaleFactor
            
            let dyRat = ((ScreenSize.SCREEN_MIN_LENGTH - trueOffset) * (productType.iPad ? 0.45 : 0.55)) / 16
            
            print("trueOffset : \(xOffset), \(trueOffset), width : \(dyRat * 16), height : \(dyRat * 9), \(ScreenSize.SCREEN_MIN_LENGTH)")
            adjustViewOnVerticalPan(yPlayerLocation, trueOffset: trueOffset, xOffset: xOffset, recognizer: recognizer)
            
        } else {
            //printYLog(self.playerHolderView.frame)
            //printYLog(self.view.frame)
            adjustViewOnHorizontalPan(recognizer)
        }
    }
    
    
    func onRecognizerStateEnded(_ yPlayerLocation: CGFloat, recognizer: UIPanGestureRecognizer) {
        print(#function)/*
        let velocity: CGPoint = recognizer.velocity(in: view)
        print("fast velocity: \(abs(velocity.x)) \(abs(velocity.y))")
        if (panGestureDirection == UIPanGestureRecognizerDirection.down ||
            panGestureDirection == UIPanGestureRecognizerDirection.up) {
            if (self.view.frame.origin.y < 0) {
                print("fast swipe 111")
                expandViews(isInitialSetUp: false,"",14)
                return
                
            } else {
                if (self.view.frame.origin.y > ((self.winFrm?.size.height)! / 2) || (abs(velocity.y) > 1000)) {
                    if isMinimized == true && (abs(velocity.y) > 1000){
                        print("fast swipe 222")
                        expandViews(isInitialSetUp: false, " ", 15)
                    } else {
                        print("fast swipe 444")
                        minimizeViews()
                    }
                    return
                } else {
                    print("fast swipe 333")
                    expandViews(isInitialSetUp: false, " ", 16)
                    return
                }
            }
        } else if (panGestureDirection == UIPanGestureRecognizerDirection.left) {
            if self.containerView != nil {
            if (containerView.alpha <= 0) {
                if self.playerHolderView != nil{
                    if ((self.view.frame.origin.x + self.playerHolderView.frame.origin.x < removeViewOffset!)) || abs(velocity.x) > 800 {
                    finishViewAnimated(true)
                } else {
                    animateViewToRightOrLeft(recognizer)
                }
                }
                else {
                    animateViewToRightOrLeft(recognizer)
                }
            }
            }
        } else {
            if self.containerView != nil {
            if (containerView.alpha <= 0) {
                if self.playerHolderView != nil{
                    if ((self.playerHolderView?.frame.origin.x)! > (self.view.frame.size.width) - 50) || abs(velocity.x) > 800 {
                    removeViews()
                } else {
                    animateViewToRightOrLeft(recognizer)
                }
                }
                else{
                    animateViewToRightOrLeft(recognizer)
                }
            }
            }
        }*/
    }
    
    func detectPanDirection(_ velocity: CGPoint) {
        print(#function)
        let isVerticalGesture = abs(velocity.y) > abs(velocity.x)
        
        if (isVerticalGesture) {
            
            if (velocity.y > 0) {
                panGestureDirection = UIPanGestureRecognizerDirection.down
            } else {
                panGestureDirection = UIPanGestureRecognizerDirection.up
            }
            
        } else {
            
            if (velocity.x > 0) {
                panGestureDirection = UIPanGestureRecognizerDirection.right
            } else {
                panGestureDirection = UIPanGestureRecognizerDirection.left
            }
        }
    }
    
    func adjustViewOnVerticalPan(_ yPlayerLocation: CGFloat, trueOffset: CGFloat, xOffset: CGFloat, recognizer: UIPanGestureRecognizer) {
        print(#function)
        self.view.backgroundColor = UIColor.clear
//        var factor = (abs(recognizer.translation(in: recognizer.view).y) / (UIScreen.main.bounds.height-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? ((productType.iPad ? 75 : 65) + (DeviceType.IS_IPHONE_X ? 15 : 0)) : 0)))
        var factor = (abs(recognizer.translation(in: recognizer.view).y) / (UIScreen.main.bounds.height-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? 0 : 0)))

        if !isFullscreen {
            let velocity = recognizer.velocity(in: recognizer.view)
            print("velocity:: ", velocity, floor(self.playerHolderView.frame.size.width),  floor(self.initialFirstViewFrame.size.width))
            if (velocity.y >= 0) {
                panGestureDirection = UIPanGestureRecognizerDirection.down
                //printYLog("Direction Down: \(self.playerHolderView.frame)")
                if floor(self.playerHolderView.frame.size.width) <= floor(self.initialFirstViewFrame.size.width) {
                    //printYLog("Direction Down returning")
                    return
                }
            } else {
                panGestureDirection = UIPanGestureRecognizerDirection.up
                //printYLog("Direction up: \(self.playerHolderView.frame)")
                if floor(self.view.frame.origin.y) <= 20 {
                    print("Direction up returning")
                    self.expandViews(isInitialSetUp: false, " ", 17)
                    return
                }
            }
     
            if self.playerHolderView != nil {
                if (((self.winFrm?.size.height)! - 60) < CGFloat(floor(self.view.frame.origin.y + self.playerHolderView.frame.size.height + 10))) || self.view.frame.origin.x < 0 {
                    if panGestureDirection == UIPanGestureRecognizerDirection.down {
                        print("player returning", self.view.frame, self.playerHolderView.frame)
                        self.minimizeViews()
                        return
                    }
                }
            }
            
            print("adjustViewOnVerticalPan not fulscreen \(factor)")
            if isMinimized {
                print("adjustViewOnVerticalPan isMinimized \(factor)")
                factor = 1 - factor
            }
        }
        
        viewMinimizedFrame?.origin.x = xOffset
        viewMinimizedFrame?.origin.y = xOffset / self.scaleFactor
        if (viewMinimizedFrame?.origin.x)! <= CGFloat(0) {
            return
        }
        if self.playerHolderView != nil {
            playerHolderView.changeBorderWidthWith(factor: 1.5 * factor)
        }
        
        let tmpW = self.view.bounds.size.width - xOffset - (10 * factor)
        var tmpH = tmpW / 16 * 9
        if tmpH > playerHeightActual() {
            print("tmpW 1: \(tmpW) tmpH: \(tmpH)")
            tmpH = playerHeightActual()
        }
        
        print("tmpW: \(tmpW) tmpH: \(tmpH)")
        if self.playerWidth != nil && self.playerHeight != nil{
        playerWidth.constant = tmpW
        playerHeight.constant = tmpH
        }
        if self.defaultPlayingItemViewViewHeightConstraint != nil {
            self.defaultPlayingItemViewViewHeightConstraint.constant = tmpH
        }
        if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
            playerControlsWidth.constant = tmpW
            playerControlsHeight.constant = tmpH
        }

        printYLog("playerHolderViewMinimizedFrame: \(viewMinimizedFrame!) : \(ceil(playerWidth.constant)) : \(ceil(playerHeight.constant))")
        //        self.playerHolderView.frame = self.playerHolderViewMinimizedFrame!
        self.view.frame = self.viewMinimizedFrame!
        //printYLog("--------------------")
    }
    
    func adjustViewOnHorizontalPan(_ recognizer: UIPanGestureRecognizer) {
        print(#function)/*
        if isMinimized {
            let x = self.playerHolderView.frame.origin.x + self.playerHolderView.frame.size.width
            
            if (panGestureDirection == UIPanGestureRecognizerDirection.left ||
                panGestureDirection == UIPanGestureRecognizerDirection.right) {
                if self.containerView != nil {
                    if (self.containerView.alpha <= 0) {
                        let velocity = recognizer.velocity(in: recognizer.view)
                        
                        let isVerticalGesture = abs(velocity.y) > abs(velocity.x)
                        
                        let translation = recognizer.translation(in: self.view)
                        print("\ntranslation:", translation, self.view.frame.origin, self.playerHolderView.frame.origin)
                        self.playerHolderView?.center = CGPoint(x: self.playerHolderView!.center.x + translation.x, y: self.playerHolderView!.center.y)
                        self.view.frame.origin = CGPoint(x: (self.view.frame.origin.x + translation.x), y: self.view.frame.origin.y)
                        if (!isVerticalGesture) {
                            recognizer.view?.alpha = detectHorizontalPanRecognizerViewAlpha(x, velocity: velocity, recognizer: recognizer)
                        }
                        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
                    }
                }
            }
        }*/
    }
    
    func detectHorizontalPanRecognizerViewAlpha(_ x: CGFloat, velocity: CGPoint, recognizer: UIPanGestureRecognizer) -> CGFloat {
        print(#function)
        self.winFrm = UIApplication.shared.keyWindow?.frame
        
        if (panGestureDirection == UIPanGestureRecognizerDirection.left) {
            let originX = self.view.frame.origin.x + self.playerHolderView.frame.origin.x + self.initialFirstViewFrame.size.width
            let percentage = originX / (self.view.frame.origin.x + self.initialFirstViewFrame.size.width)
            print("percentage 1: ", originX, self.view.frame, self.playerHolderView.frame, percentage)
            if percentage >= 1 {
                panGestureDirection = UIPanGestureRecognizerDirection.right
            }
            return percentage
            
        } else {
            let originX = self.view.frame.size.width - self.playerHolderView.frame.origin.x
            let percentage = originX / (self.playerHolderView.frame.size.width + 10)
            if (velocity.x > 0) {
                print("percentage 2: ", originX, self.playerHolderView.frame, percentage)
                return percentage
            } else {
                if percentage >= 1 {
                    panGestureDirection = UIPanGestureRecognizerDirection.left
                }
                print("percentage 3: ", originX, self.playerHolderView.frame, percentage)
                return percentage
            }
        }
    }
    
    func animateViewToRightOrLeft(_ recognizer: UIPanGestureRecognizer) {
        print(#function)
        if isMinimized {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                self.winFrm = UIApplication.shared.keyWindow?.frame
                self.playerHolderView.frame.origin = CGPoint(x: 0, y: 0)
                if self.playerIndicatorView != nil {
                    self.playerIndicatorView?.center = self.playerHolderView.center
                }
                if self.playerHolderView != nil {
                    self.playerHolderView.alpha = 1.0
                }
                let iPhoneXadjustWidth: CGFloat = (DeviceType.IS_IPHONE_X ? (self.orientation() == .landscapeRight ? 22.0 : 10.0) : 0)
//                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? ((productType.iPad ? 75 : 65) + (DeviceType.IS_IPHONE_X ? 15 : 0)) : 0)))
                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? 0 : 0)))

            }, completion: nil)
            
            recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            
        }
    }
    
    func minimizeViews() {
        print(#function)
        UIApplication.shared.statusBarStyle = .lightContent
        self.playerIndicatorCustomView?.changeSize(image: UIImage(named:"loader_icon")!, type: .half)
        self.defaultPlayingItemView.isHidden = true
        if player == nil{
            closePlayer()
            return;
        }
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        UIApplication.shared.showSB()
        if player != nil && playerVC != nil {
            if playerVC?.isNavigatingToBrowser == false{
                self.onMinView.isHidden = false
            }
        }
        if self.playBtn == nil || self.sliderPlayer == nil || self.playerHeight == nil {
            return
        }
        self.playPauseButtonOnDockPlayer.setImage(UIImage(named:(self.player.playbackState == .paused) ? "player-play-icon" : "miniPlayer-Pause"), for: .normal)
        self.hideControls = true
        self.showHideControllers()
        if self.comingUpNextView != nil {
            self.comingUpNextView.updateStates()
        }
        self.hideAllTheControls()
        if (self.playBtn != nil && self.playBtn?.tag == 2) {
//            self.nextVideoIconView.isHidden = true
//            self.nextVideoTitleLbl.isHidden = true
//            self.comingUpVdoLblTpConstraint.constant = 10.0
            self.playBtn?.isHidden = false
            if self.nextVDOTimer != nil {
                self.nextVDOTimer?.invalidate()
            }
        }
        AppDelegate.getDelegate().isPlayerPage = false
        self.subtitleLabel?.isHidden = true
        if self.vodStartOverButton != nil {
                self.vodStartOverButton!.isHidden = true
         }
        if self.waterMarkImgView != nil {
        self.waterMarkImgView.isHidden = true
        }
        if self.skipButton != nil {
            self.skipButton.alpha = 0.0
        }
//        UIApplication.shared.isStatusBarHidden = false
        //        print(self.view.frame)
        //        print(self.playerHolderView.frame)
        //        print(self.playerHolderViewMinimizedFrame!)
        //        print(self.containerView.frame)
        //        print(self.containerViewMinimizedFrame!)
        
        winFrm = UIApplication.shared.keyWindow?.frame
        
//        if AppDelegate.getDelegate().isTabsPage {
//            if self.playerWidth != nil && self.playerHeight != nil{
//                self.view.frame.size.height = self.playerHeight.constant
//                self.view.frame.size.width = self.playerWidth.constant
//            }
//            if self.playerHolderView != nil {
//                if self.playerWidth != nil {
//                    self.playerHolderView.frame.size.width = self.playerWidth.constant
//                }
//            }
//        }
//        else {
//            if self.isMinimized {
//                if self.playerWidth != nil && self.playerHeight != nil{
//                    self.view.frame.size.height = self.playerHeight.constant
//                    self.view.frame.size.width = self.playerWidth.constant
//                }
//                if self.playerHolderView != nil {
//                    if self.playerWidth != nil && self.playerHeight != nil{
//                        self.playerHolderView.frame.size.width = self.playerWidth.constant
//                        self.playerHolderView.frame.size.height = self.playerHeight.constant
//                    }
//                }
//            } else {
//                self.view.frame.size.height = (self.winFrm?.height)!
//                self.view.frame.size.width = (self.winFrm?.width)!
//                if self.playerHolderView != nil {
//                    self.playerHolderView.frame.size.width = (self.winFrm?.width)!
//                }
//            }
//        }

        UIView.animate(withDuration: 0, delay: 0.0, options: .curveEaseOut, animations: {
//            self.view.frame.origin = CGPoint(x: 10, y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? ((productType.iPad ? 75 : 65) + (DeviceType.IS_IPHONE_X ? 15 : 0)) : 0)))
            
            self.view.frame.origin = CGPoint(x: 10, y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? 0 : 0)))

            
            
//            if self.isMinimized == true {
//            } else {
            
            let iPhoneXadjustWidth: CGFloat = (DeviceType.IS_IPHONE_X ? (self.orientation() == .landscapeRight ? 22.0 : 10.0) : 0)
            print("--orientation---", self.orientation())
            let deviceModel = UIDevice.modelName
            let xorigin:CGFloat = self.analytics_info_contentType == "live" ? 10 : 10
//            if AppDelegate.getDelegate().isTabsPage {
//                if AppDelegate.getDelegate().isChangedToLandscapeMode {
//                    AppDelegate.getDelegate().isChangedToLandscapeMode = false
//                    if self.isPlayerDragging {
//                        if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                            self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                        } else {
//                            self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-45-self.initialFirstViewFrame.size.height))
//                        }
//                    } else {
//                        if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                            self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-105-self.initialFirstViewFrame.size.height))
//                        } else {
//                            self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-65-self.initialFirstViewFrame.size.height))
//                        }
//                    }
//                }
//                else {
//                    if self.isMinimized || self.isChangedToLandscapeOnce {
//                        if self.isChangedToLandscapeOnce {
//                            if self.isPlayerDragging {
//                                if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                                } else {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-45-self.initialFirstViewFrame.size.height))
//                                }
//                            } else {
//                                if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                                } else {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-65-self.initialFirstViewFrame.size.height))
//                                }
//                            }
//                        } else {
//                            if self.isPlayerDragging {
//                                if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-105-self.initialFirstViewFrame.size.height))
//                                } else {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-65-self.initialFirstViewFrame.size.height))
//                                }
//                            } else {
//                                if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-125-self.initialFirstViewFrame.size.height))
//                                } else {
//                                    self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                                }
//                            }
//                        }
//                    } else {
//                        if self.isPlayerDragging {
//                            if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                            } else {
////                                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-xorigin-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-65-self.initialFirstViewFrame.size.height))
//                                if self.playerWidth != nil && self.playerHeight != nil{
//                                    self.view.frame.size.height = self.playerHeight.constant
//                                    self.view.frame.size.width = self.playerWidth.constant
//                                }
//                            }
//                        } else {
//                            if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-130-self.initialFirstViewFrame.size.height))
//                            } else {
//                                self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-85-self.initialFirstViewFrame.size.height))
//                            }
//                        }
//                    }
//                }
//            } else {
//                if deviceModel == "iPhone X" || deviceModel == "iPhone XS" || deviceModel == "iPhone XS Max" || deviceModel == "iPhone XR" {
//                    if self.isPlayerDragging {
//                        self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height))
//                    } else {
//                        self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-70-self.initialFirstViewFrame.size.height))
//                    }
//                } else {
//                    if self.isPlayerDragging {
//                        self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height))
//                    } else {
//                        self.view.frame.origin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width-iPhoneXadjustWidth), y: CGFloat((self.winFrm?.size.height)!-30-self.initialFirstViewFrame.size.height))
//                    }
//                }
//            }
            if self.playerWidth != nil && self.playerHeight != nil{

                self.playerWidth.constant = ScreenSize.SCREEN_MIN_LENGTH * 0.30
                self.playerHeight.constant = self.playerWidth.constant / 1.77 //self.initialFirstViewFrame.size.height
                
                self.titleControlsWidth.constant = ScreenSize.SCREEN_MIN_LENGTH - self.playerWidth.constant - 15
                self.titleControlsHeight.constant = self.playerHeight.constant
                
//                self.view.frame.size.height = self.playerHeight.constant
//                self.view.frame.size.width = self.playerWidth.constant
            }
            if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
                
                self.playerControlsWidth.constant = self.initialFirstViewFrame.size.width
                self.playerControlsHeight.constant = self.initialFirstViewFrame.size.height
            }
            if self.playerHolderView != nil {
                self.playerHolderView.viewBorderWithOne(cornersRequired: false)
                self.playerHolderView.frame.size = self.initialFirstViewFrame.size
            }
//            }
            print("-----", self.playerHolderView.frame)
            if self.containerView != nil {
                self.containerView.alpha = 0.0
                self.containerView.frame.origin = CGPoint(x: 0, y: self.playerHolderView.frame.height+self.playerHolderView.frame.origin.y)
            }
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if self.minimizeButton != nil {
            self.minimizeButton.isHidden = true
            }
            if self.fullScreenButton != nil {
                //self.itemHideShow(self.fullScreenButton, hidden: false)
            }

//            if self.playerHolderView != nil {
//            self.playerHolderView.isHidden = false
//            }
            
            if self.isMinimized == true {
//                self.playerHolderViewMinimizedFrame = self.view.frame
//                self.containerViewMinimizedFrame?.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + self.view.frame.size.height)
            } else {
//                self.playerHolderViewMinimizedFrame = self.playerHolderView.frame
//                self.containerViewMinimizedFrame = self.containerView.frame
            }
            self.isMinimized = true
            self.hideControls = true
            self.showHideControllers()
            self.hideAllTheControls()
            if self.playerErrorCode == -1000 {
                if self.navView != nil {
                self.navView.alpha = 1.0
                self.navView.isHidden = false
                }
            }
            self.isFullscreen = false
            self.handleGestureAddRemove()
            self.suggestionsView.isHidden = true
//            if AppDelegate.getDelegate().isTabsPage {
//                if self.playerWidth != nil && self.playerHeight != nil{
//                self.view.frame.size.height = self.playerHeight.constant
//                self.view.frame.size.width = self.playerWidth.constant
//                }
//                if self.playerHolderView != nil {
//                    if self.playerWidth != nil {
//                self.playerHolderView.frame.size.width = self.playerWidth.constant
//                    }
//                }
//            }
//            else {
//                if self.isMinimized {
//                    if self.playerWidth != nil && self.playerHeight != nil{
//                    self.view.frame.size.height = self.playerHeight.constant
//                    self.view.frame.size.width = self.playerWidth.constant
//                    }
//                    if self.playerHolderView != nil {
//                        if self.playerWidth != nil && self.playerHeight != nil{
//                    self.playerHolderView.frame.size.width = self.playerWidth.constant
//                    self.playerHolderView.frame.size.height = self.playerHeight.constant
//                        }
//                    }
//                } else {
//                    self.view.frame.size.height = (self.winFrm?.height)!
//                    self.view.frame.size.width = (self.winFrm?.width)!
//                    if self.playerHolderView != nil {
//                    self.playerHolderView.frame.size.width = (self.winFrm?.width)!
//                    }
//                }
//            }
            //                    self.view.frame.size.height = (self.winFrm?.height)!
            //                    self.view.frame.size.width = (self.winFrm?.width)!

            //            print(#function)
                        print(self.view.frame)
//                        print(self.playerHolderView.frame)
            //            print(self.playerHolderViewMinimizedFrame!)
            //            print(self.containerView.frame)
            //            print(self.containerViewMinimizedFrame!)
            
            self.view.backgroundColor = UIColor.clear
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadSuggestions"), object: nil, userInfo: nil)
            self.viewInTransition = false
            if productType.iPhone && self.minBtnTouched == true {
                let appDelegate = AppDelegate.getDelegate()
                appDelegate.shouldRotate = false
                let value = self.orientation().rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
                let value1 = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value1, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            self.minBtnTouched = false
            if self.playerHeight != nil {
                self.view.frame.size = CGSize.init(width: (self.winFrm?.size.width)!, height: self.playerHeight.constant)
                self.onMinViewLeadingConstraint?.isActive = true
            }
            self.updateMinViewFrame()
            self.view.isHidden = self.shouldHideMinimizedPlayer
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectTab"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerViewStatusChanged"), object: nil)
        })
    }
    func updateMinViewFrame() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
//                self.view.frame.origin = CGPoint(x: 10, y: CGFloat((self.winFrm?.size.height)!-10-(self.initialFirstViewFrame.size.height/2)-(AppDelegate.getDelegate().isTabsPage ? ((productType.iPad ? 145 : 105) + (DeviceType.IS_IPHONE_X ? 15 : 0)) : 45)))
            
            var yy:CGFloat = 0.0
            if AppDelegate.getDelegate().isTabsPage {
                yy = yy  + 55
                if UIDevice.current.hasNotch {
                    yy = yy  + 40
                }
            }
            if AppDelegate.getDelegate().showBannerAds == true && self.bannerAdFoundExceptPlayer == true {
                if let topVC = UIApplication.topVC() {
                    if topVC.navigationController != nil, topVC.navigationController?.viewControllers.count ?? 0 > 0 {
                        if (topVC.navigationController!.viewControllers.last!.isKind(of: TabsViewController.self)) || (topVC.navigationController!.viewControllers.last!.isKind(of: ListViewController.self)) || (topVC.navigationController!.viewControllers.last!.isKind(of: DetailsViewController.self)) {
                            yy = yy  + 50
                        }
                    }
                }
            }
            if self.winFrm != nil {
                self.view.frame.origin = CGPoint(x: 10, y: CGFloat((self.winFrm!.size.height)-10-(self.initialFirstViewFrame.size.height/2)-yy))
            }
            print("origin:- ", self.view.frame.origin)
        }
    }
    @objc func expandViewsIntermediate() {
         print(#function)
        self.expandViews(isInitialSetUp: false, "", 2)
        self.warningLbl?.isHidden = true
    }
    @objc func expandViews(isInitialSetUp:Bool, _ orientation: String = "left", _ line : Int = 0) {
        print(#function ,line)
        self.previewLblView.isHidden = isPreviewContent ? false : true
        AppDelegate.getDelegate().handleSupportButton(isHidden: true, isFromTabVC: false,chromeCastHeight:0)

        self.comingUpNextView.isPlayerMinimized = false
        self.comingUpNextView.updateStates()
        self.playerIndicatorCustomView?.changeSize(image: UIImage(named:"loader_icon")!, type: .full)
        if self.playerHeight == nil {
            return
        }
        UIApplication.shared.hideSB()
        AppDelegate.getDelegate().removeStatusBarView()
        self.onMinViewLeadingConstraint.isActive = false
//        UIApplication.shared.statusBarStyle = .default
        self.isMinimized = false
//        let appDelegate = AppDelegate.getDelegate()
//        appDelegate.shouldRotate = true
//        let value = (orientation == "left") ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.landscapeRight.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        if self.fullScreenButton != nil {
            //self.itemHideShow(self.fullScreenButton, hidden: false)
        }

        if self.waterMarkImgView != nil {
        self.waterMarkImgView.isHidden = false
        }
        if self.skipButton != nil {
            skipButton.alpha = 1.0
        }
        if self.vodStartOverButton != nil {
            if self.analytics_info_contentType != "live" && self.analytics_info_contentType != "channel"  {
                //self.vodStartOverButton!.isHidden = false
            }
        }
        self.subtitleLabel?.isHidden = !(ccButton?.isSelected ?? true)
        if ((self.orientation() == UIDeviceOrientation.landscapeRight || self.orientation() == UIDeviceOrientation.landscapeLeft) /*&& UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone*/) {
            self.isFullscreen = true
            AppDelegate.getDelegate().isChangedToLandscapeMode = true
            self.isChangedToLandscapeOnce = true
        }
        if self.isFullscreen {
//            UIApplication.shared.isStatusBarHidden = true
        } else {
//            UIApplication.shared.isStatusBarHidden = false
        }
        //        print(self.view.frame)
        //        print(self.playerHolderView.frame)
        //        print(self.playerHolderViewMinimizedFrame!)
        //        print(self.containerView.frame)
        //        print(self.containerViewMinimizedFrame!)

        self.winFrm = UIApplication.shared.keyWindow?.frame
        var animationDuration_tmp = animationDuration
        AppDelegate.getDelegate().isPlayerPage = true
        if isOpen == false {
            animationDuration_tmp = 0
            isOpen = true
        }
        if !isInitialSetUp && self.playerHolderView != nil {
//        self.playerHolderView.translatesAutoresizingMaskIntoConstraints = true
        }
        UIView.animate(withDuration: animationDuration_tmp, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = self.winFrm!
            if (self.orientation() == UIDeviceOrientation.landscapeLeft || self.orientation() == UIDeviceOrientation.landscapeRight) && self.isFullscreen == true {
                print("lsr")
                /*
                self.suggestionsButton.isHidden = false
                self.suggestionsButton.alpha = 1.0
 */
                if self.playerWidth != nil && self.playerHeight != nil{
                self.playerWidth.constant = DeviceType.IS_IPHONE_X ?  (self.winFrm?.size.width)! - 0.0 : (self.winFrm?.size.width)!
                self.playerHeight.constant = (self.winFrm?.size.height)!
                }
                self.fullScreenButtonTrailingConstraint?.constant =  DeviceType.IS_IPHONE_X ? 13 : 3
                
                if self.defaultPlayingItemViewViewHeightConstraint != nil {
                    self.defaultPlayingItemViewViewHeightConstraint.constant = (self.winFrm?.size.height)!
                }
                if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
                    self.playerControlsWidth.constant = (self.winFrm?.size.width)!
                    self.playerControlsHeight.constant = (self.winFrm?.size.height)!
                }
                if self.playerHolderView != nil {
                    self.playerHolderView.frame = self.view.frame
                    if self.playerIndicatorView != nil {
                        self.playerIndicatorView?.center = self.playerHolderView.center
                    }
                }
                
            } else {
                print("pp")
                if self.playerWidth != nil && self.playerHeight != nil{
                    self.playerWidth.constant = (self.winFrm?.size.width)!
                    self.playerHeight.constant = self.playerHeightActual()
                }
                if self.playerHolderView != nil{
                    self.playerHolderView.frame.origin = CGPoint(x: 0.0, y: 20.0)
                    if self.playerIndicatorView != nil {
                        self.playerIndicatorView?.center = self.playerHolderView.center
                    }
                }
                if self.defaultPlayingItemViewViewHeightConstraint != nil {
                    self.defaultPlayingItemViewViewHeightConstraint.constant = self.playerHeightActual()
                }
                self.fullScreenButtonTrailingConstraint?.constant =  3
                
                if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
                    self.playerControlsWidth.constant = (self.winFrm?.size.width)!
                    self.playerControlsHeight.constant = self.playerHeightActual()
                }
                self.view.frame.origin = CGPoint(x: 0.0, y: 0.0)
                self.navViewTopConstraint?.constant = 20.0
            }
            if self.containerView != nil {
            self.containerView.alpha = 1.0
            }

            //            print(self.view.frame)
            //            print(self.playerHolderView.frame)
            //            print(self.containerView.frame)
            //            print("-----")
        }, completion: { finished in
            if self.playerHeight != nil {
                print("winFrm: ", (self.winFrm?.size.height)!)
                if self.playerHeight.constant == (self.winFrm?.size.height)!{
                    if self.fullScreenButton != nil {
                        self.fullScreenButton.setImage(UIImage(named: "unfullscreen"), for: UIControl.State())
                    }
                    if self.minimizeButton != nil {
                        if appContants.appName == .gac {
                            if let yourBackImage = UIImage(named: "group_3988") {
                                self.minimizeButton?.setImage(yourBackImage, for: .normal)
                                self.minimizeButton?.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 3, right: 8)
                            }
                        } else {
                            self.minimizeButton.setImage(UIImage(named: "minimize"), for: UIControl.State())
                        }
                    }
                } else {
                    if self.fullScreenButton != nil {
                        self.fullScreenButton.setImage(UIImage(named: "fullscreen"), for: UIControl.State())
                    }
                    if self.minimizeButton != nil {
                        if appContants.appName == .gac {
                            if let yourBackImage = UIImage(named: "group_3988") {
                                self.minimizeButton?.setImage(yourBackImage, for: .normal)
                                self.minimizeButton?.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 3, right: 8)
                            }
                        } else {
                            self.minimizeButton.setImage(UIImage(named: "minimize"), for: UIControl.State())
                        }
                    }
                }
                if self.fullScreenButton != nil {
                    //self.itemHideShow(self.fullScreenButton, hidden: false)
                }
                self.viewInTransition = false
                self.isMinimized = false
                if self.player != nil {
                    if self.player.playbackState == .stopped {
                        self.hideControls = false
                    }
                    else {
                        self.hideControls = true
                    }
                }
                else {
                    self.hideControls = true
                }
                if self.playerErrorCode == -1000 {
                    if self.navView != nil {
                    self.navView.alpha = 1.0
                    self.navView.isHidden = false
                    }
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.isHidden = false
                    }
                }
                else if self.playerErrorCode == 402 || self.playerErrorCode == -14 || self.playerErrorCode == -15 {
                    self.hideControls = false
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.isHidden = false
                    }
                } else {
                    if self.defaultPlayingItemView != nil {
                        self.defaultPlayingItemView.isHidden = !isInitialSetUp
                    }
                }
                
                if self.playerHolderView != nil {
                self.playerHolderView.zeroBorderWidth()
                }
                if self.minimizeButton != nil {
                self.minimizeButton.isHidden = false
                }
                if self.fullScreenButton != nil {
                    //self.itemHideShow(self.fullScreenButton, hidden: false)
                }

                self.handleGestureAddRemove()
                self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                
                let appDelegate = AppDelegate.getDelegate()
                appDelegate.shouldRotate = true
                UIDevice.current.setValue(self.orientation().rawValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ViewTransit"), object: nil, userInfo: nil)
                if self.orientation() == .portrait {
                    //                    if self.analytics_info_contentType != "live" {
                    if self.playerHolderView != nil {
//                    self.playerHolderView.translatesAutoresizingMaskIntoConstraints = false
                    }
                    //                    }
                }
                
                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                //                    self.playerHolderView.frame.size.height = self.playerHeight.constant
                //                }

            }
            //            print(#function)
//                        print(self.view.frame)
//                        print(self.playerHolderView.frame)
            //            print(self.playerHolderViewMinimizedFrame!)
//                        print(self.containerView.frame)
            //            print(self.containerViewMinimizedFrame!)
        })
    }
    
    func handleGestureAddRemove() {
        if let playerGesture = self.playerTapGesture {
            print("gesture tap removing 1")
            if self.playerHolderView != nil {
            self.playerHolderView.removeGestureRecognizer(playerGesture)
            }
            if self.adsDisplayContainer != nil {
                self.adsDisplayContainer.adContainer.removeGestureRecognizer(playerGesture)
            }
            self.playerTapGesture = nil
        }
        if let playerGesture = self.playerPanGesture {
            print("gesture pan removing 2")
            if self.playerHolderView != nil {
            self.playerHolderView.removeGestureRecognizer(playerGesture)
                if self.adsDisplayContainer != nil {
                    self.adsDisplayContainer.adContainer.removeGestureRecognizer(playerGesture)
                }
                if self.playerHeight != nil{
            self.playerHolderView.frame.size.height = self.playerHeight.constant
                }
            }
            self.playerPanGesture = nil
        }
        if isMinimized == true {
            print("gesture tap adding 1")
            self.playerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureRecognizer(_:)))
            let playerTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.expandViewsIntermediate))
            if AppDelegate.getDelegate().showVideoAds == true && self.adsDisplayContainer != nil {
                self.playerTapGesture?.delegate = self
                self.adsDisplayContainer.adContainer.addGestureRecognizer(self.playerTapGesture!)
            }  else if self.playerHolderView != nil {
                self.playerHolderView.addGestureRecognizer(self.playerTapGesture!)
                self.onMinView.addGestureRecognizer(playerTapGesture2)
                self.playPauseButtonOnDockPlayer?.setImage(UIImage(named:(self.player.playbackState == .paused) ? dockPlayIconName : dockPauseIconName), for: .normal)
            }
            AppDelegate.getDelegate().removeStatusBarView()
        }
        /*
        if self.isFullscreen == false {
            print("gesture pan adding 3")
            self.playerPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panAction(_:)))
//            if self.playerHolderView != nil {
//            self.playerHolderView.addGestureRecognizer(self.playerPanGesture!)
//            }
            if AppDelegate.getDelegate().showVideoAds == true && (self.adsDisplayContainer != nil) {
                self.playerPanGesture?.delegate = self
                if self.adsDisplayContainer != nil {
                    self.adsDisplayContainer.adContainer.addGestureRecognizer(self.playerPanGesture!)
                }
                
            } else {
                if self.playerHolderView != nil {
                    self.playerHolderView.addGestureRecognizer(self.playerPanGesture!)
                }
            }
        }
         */
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if AppDelegate.getDelegate().showVideoAds == true {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.isFullscreen == true {
            if NSStringFromClass((touch.view?.classForCoder)!) == "UISlider" {
                return false
            }
        }
        return true
    }

    func finishViewAnimated(_ animated: Bool) {
        print(#function)
        if (animated) {
            self.view.frame.origin = CGPoint(x: self.view!.frame.origin.x + self.playerHolderView!.frame.origin.x, y: self.view!.frame.origin.y)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                self.view.frame = CGRect(x: 0.0, y: self.view!.frame.origin.y, width: self.view!.frame.size.width, height: self.view!.frame.size.height)
                self.view.alpha = 0.0
                
            }, completion: { finished in
                self.removeViews()
            })
        } else {
            removeViews()
        }
    }
    
    func removeViews() {
        if self.streamResponse.sessionInfo.streamPollKey != nil{
            self.endPollAndStreamSession(pollKey: self.streamResponse.sessionInfo.streamPollKey)
        }
        print(#function)
        if UIApplication.topVC() is DetailsViewController {
//            UIApplication.shared.statusBarStyle = .lightContent
//            UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(hexString: "232326")
        } else {
//            UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
//            UIApplication.shared.statusBarStyle = .default
        }
        self.view.layer.removeAllAnimations()
        self.backAction()
        if self.playerHolderView != nil {
            self.playerHolderView.removeFromSuperview()
        }
        if self.containerView != nil {
            self.containerView.removeFromSuperview()
        }
        self.view.removeFromSuperview()
        if otherPlayerVC != nil {
            otherPlayerVC = nil
        } else if playerVC != nil {
            playerVC = nil
            self.isDownloadContent = false
        }
        if self.adsManager != nil {
            self.adsManager?.destroy()
        }
    }
    
    func showHidePlayerView(_ status:Bool) {
        print(#function)
        if playerVC != nil {
            if self.playerHolderView != nil  { //&& self.containerView != nil
                self.playerHolderView.isHidden = status
                self.containerView.isHidden = status
                self.onMinView.isHidden = status
                if self.comingUpNextView != nil {
                    self.comingUpNextView.updateStates()
                }
                AppDelegate.getDelegate().isPlayerPage = !status
                AppDelegate.getDelegate().isFromPlayerPage = !status
                if self.isMinimized {
                    self.hideAllTheControls()
                    AppDelegate.getDelegate().isPlayerPage = false
                    AppDelegate.getDelegate().isFromPlayerPage = false
                }
                if status{
                    let messageDataDict:[String: Bool] = ["status": false]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
//                    self.minBtnTouched = true
//                    self.minimizeViews()
                }
                else{
                    let messageDataDict:[String: Bool] = ["status": true]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
                }

//                if productType.iPhone{
//                    let appDelegate = AppDelegate.getDelegate()
//                    var value = UIInterfaceOrientation.portrait.rawValue
//                    if status{
//                        appDelegate.shouldRotate = false
//                        value = UIInterfaceOrientation.portrait.rawValue
//                        let messageDataDict:[String: Bool] = ["status": false]
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
//                    }
//                    else{
//                        if self.isMinimized == false{
//                            appDelegate.shouldRotate = true
//                            value = UIInterfaceOrientation.landscapeRight.rawValue
//                        }
//                        let messageDataDict:[String: Bool] = ["status": true]
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil, userInfo: messageDataDict)
//                    }
//                    UIDevice.current.setValue(value, forKey: "orientation")
//                }
            }
            self.view.isHidden = status
            self.view.isUserInteractionEnabled = !status
        }
    }

    func changeSubtitleFontSizeTo(_ size:CGFloat) {
        subtitleLabel?.font = UIFont.ottBoldFont(withSize: productType.iPad ? 24.0 : size)
    }

}
