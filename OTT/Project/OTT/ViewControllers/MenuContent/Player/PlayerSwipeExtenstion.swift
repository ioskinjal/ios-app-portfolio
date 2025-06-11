//
//  ViewController.swift
//  swippe
//
//  Created by Mohan on 6/26/17.
//  Copyright © 2017 Mohan Agadkar. All rights reserved.
//

import UIKit
import CoreMotion
import OTTSdk

extension PlayerViewController {

    
    func viewDidLoadSwipe() {
        print(#function)
//        self.winFrm = UIApplication.shared.keyWindow?.frame
        self.view.backgroundColor = UIColor.clear
        self.view.frame.origin = CGPoint(x: (self.winFrm?.size.width)!, y: (self.winFrm?.size.height)!)
        if self.playerHolderView != nil {
            self.view.bringSubviewToFront(self.playerHolderView)
        }
        if self.playerWidth != nil && self.playerHeight != nil{
            self.playerHeight.constant = self.playerHeightActual()
            self.playerWidth.constant = (self.winFrm?.size.width)!
        }
        if self.playerControlsWidth != nil && self.playerControlsHeight != nil{
            self.playerControlsHeight.constant = self.playerHeightActual()
            self.playerControlsWidth.constant = (self.winFrm?.size.width)!
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
        prevPlayerOrientation = UIDevice.current.orientation
        playerPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_:)))
        adPanGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_:)))
        if self.playerHolderView != nil {
//        self.playerHolderView.addGestureRecognizer(playerPanGesture!)
            self.playerHolderView.changeBorder(color: .clear)
        }
        
//        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
//            initialFirstViewFrame = CGRect(x: 0, y: 0, width: 256, height: 144)
        
        let dyRat = (ScreenSize.SCREEN_MIN_LENGTH * (productType.iPad ? 0.50 : 0.55)) / 16
        initialFirstViewFrame = CGRect(x: 0, y: 0, width: dyRat * 16, height: dyRat * 9)
//        }
        self.setScaleFactor()
        self.setRemoveViewOffset()
        // Do any additional setup after loading the view, typically from a nib.
//
//        playerHolderView.translatesAutoresizingMaskIntoConstraints = true
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.testRotation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
            self.setInitialView()
        })
        rotateMM = CMMotionManager()
        rotateMM.accelerometerUpdateInterval = 0.01
    }
    func setScaleFactor() {
        let minViewOrigin = CGPoint(x: CGFloat((self.winFrm?.size.width)!-10-self.initialFirstViewFrame.size.width), y: CGFloat((self.winFrm?.size.height)!-10-self.initialFirstViewFrame.size.height-(AppDelegate.getDelegate().isTabsPage ? (65 + (UIDevice.current.hasNotch ? 15 : 0)) : 0)))
        self.scaleFactor = minViewOrigin.x / minViewOrigin.y
        print("scaleFactor: \(scaleFactor), \(initialFirstViewFrame)")
    }
    func setInitialView() {
        print(#function)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) && (orientation() == UIDeviceOrientation.landscapeLeft || orientation() == UIDeviceOrientation.landscapeRight) {
            self.isFullscreen = true
        }
        self.expandViews(isInitialSetUp: true,"",30)
        
        if appContants.appName != .reeldrama {
            if self.defaultPlayingItemView != nil  {
                defaultPlayingItemView.loadingImageFromUrl(defaultPlayingItemUrl, category: "banner")
                self.defaultPlayingItemView.isHidden = false
            }
        }
        else {
            self.defaultPlayingItemView.isHidden = true
        }
    }
    func playerHeightActual() -> CGFloat {
        print(#function)
        self.winFrm = UIApplication.shared.keyWindow?.frame
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            if isFullscreen {
                /*
                self.suggestionsButton.isHidden = false
                self.suggestionsButton.alpha = 1.0
 */
                return (self.winFrm?.size.height)!
            } else {
                /*
                self.suggestionsButton.isHidden = true
                self.suggestionsButton.alpha = 0.0
 */
                return ((self.winFrm?.size.width)! * 0.5625)
//                return ScreenSize.SCREEN_MIN_LENGTH / 16 * 9
            }
        } else {
            if orientation() == UIDeviceOrientation.landscapeLeft || orientation() == UIDeviceOrientation.landscapeRight{
                /*
                self.suggestionsButton.isHidden = false
                self.suggestionsButton.alpha = 1.0
 */
                return (self.winFrm?.size.height)!
            }
            /*
            self.suggestionsButton.isHidden = true
            self.suggestionsButton.alpha = 0.0
 */
            return ((self.winFrm?.size.width)! * 0.7051)
//            return ScreenSize.SCREEN_MIN_LENGTH / 16 * 9
        }
    }
    
    @IBAction func minimizeButtonTouched(_ sender: Any) {
        print(#function)
        self.previewLblView?.isHidden = true
        self.warningLbl?.isHidden = true
        self.comingUpNextView.isPlayerMinimized = true
        self.comingUpNextView.updateStates()
        //        let appDelegate = AppDelegate.getDelegate()
        //        appDelegate.shouldRotate = false
        //        let value = UIInterfaceOrientation.portrait.rawValue
        //        UIDevice.current.setValue(value, forKey: "orientation")
        self.isPlayerDragging = false
//        self.containerView.alpha = 0.0
        self.viewInTransition = true
        self.pushEvents(true, "Dock")
        self.minBtnTouched = true
        UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationBarColor
        self.minimizeViews()
    }
    
    @IBAction func fullScreenTouched(_ sender: AnyObject) {
        print(#function)
        if (isFullscreen) {
            print("setting to normal screen")
            isFullscreen = false
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
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                //                let appDelegate = AppDelegate.getDelegate()
                //                appDelegate.shouldRotate = false
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            } else {
                if orientation() == .landscapeLeft || orientation() == .landscapeRight {
                    let value = UIInterfaceOrientation.portrait.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
                    UIViewController.attemptRotationToDeviceOrientation()
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
                else{
                    setPlayerToNormalScreen()
                }
            }
            self.pushEvents(true, "Full screen collapse")
        } else {
            print("setting to full screen")
            isFullscreen = true
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
            if productType.iPad{
                let value = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
                UINavigationController.attemptRotationToDeviceOrientation()
            }
            else {
                setPlayerToFullscreen(1)
            }
            self.pushEvents(true, "Full Screen")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            print(#function)
            if self.isMinimized == true {
                if self.playerHolderView != nil {
                self.playerHolderView.isHidden = true
                }
            }
        }) { (UIViewControllerTransitionCoordinatorContext) in
            print(#function)
            self.setPlayerToFullscreen(0)
        }
        super.viewWillTransition(to: size, with: coordinator)
        
        
    }
    func setRemoveViewOffset() {
        print(#function)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            removeViewOffset = CGFloat((self.winFrm?.size.width)!/2) - 80
        } else {
            removeViewOffset = CGFloat((self.winFrm?.size.width)!/2) - 50
        }
    }
    @objc func testRotation() {
        print(#function)
//        if self.minBtnTouched == false {
//            return
//        }
        self.setRemoveViewOffset()
        if UIDevice.current.orientation.isLandscape {
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                self.isFullscreen = true
            } else {
                self.isFullscreen = true
            }
            print("Landscape")
        } else {
            if AppDelegate.getDelegate().isPartialViewLoaded == true{
                PartialRenderingView.instance.dismiss()
            }
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                self.isFullscreen = false
            } else {
                self.isFullscreen = false
            }
            self.warningLbl?.isHidden = true

            print("Portrait")
        }
        self.setPlayerToFullscreen(0)
        self.setScaleFactor()
    }
    func orientation() -> UIDeviceOrientation {
        print(#function)
        let fixedPoint = self.view.window?.screen.coordinateSpace.convert(CGPoint(x: CGFloat(0.0), y: CGFloat(0.0)), to: (view.window?.screen.fixedCoordinateSpace)!)
        if fixedPoint?.x == 0.0 {
            if fixedPoint?.y == 0.0 {
                print(".portrait")
                if self.fullScreenButton != nil {
                    if isFullscreen {
                        if productType.iPad {
                            self.fullScreenButton.setImage(UIImage(named: "unfullscreen"), for: UIControl.State())
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
                            self.fullScreenButton.setImage(UIImage(named: "fullscreen"), for: UIControl.State())
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
                    } else {
                        self.fullScreenButton.setImage(UIImage(named: "fullscreen"), for: UIControl.State())
                        if self.minimizeButton != nil {
                            if appContants.appName == .gac {
                                if let yourBackImage = UIImage(named: "group_3988") {
                                    self.minimizeButton?.setImage(yourBackImage, for: .normal)
                                    self.minimizeButton?.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 3, right: 8)
                                }
                            } else {
                                self.minimizeButton.setImage(UIImage(named: "minimize"), for: UIControl.State())
                            }                        }
                    }
                }
                if UIDevice.current.hasNotch {
                    self.previewLblViewleading?.constant = 20
                }
                
                return .portrait
            }
            else {
                print(".landscapeRight")
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
                if UIDevice.current.hasNotch {
                    self.previewLblViewleading?.constant = 50
                }
                
                return .landscapeRight
            }
        }
        else {
            if fixedPoint?.y == 0.0 {
                print(".landscapeLeft")
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
                
                if UIDevice.current.hasNotch {
                    self.previewLblViewleading?.constant = 50
                }
                
                return .landscapeLeft
            }
            else {
                print(".portraitUpsideDown")
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
                if UIDevice.current.hasNotch {
                    self.previewLblViewleading?.constant = 20
                }
                return .portraitUpsideDown
            }
        }
    }
    func motionOrientation(completionHandler: @escaping (_ orientation: UIInterfaceOrientation.RawValue)->Void) {
        if rotateMM.isGyroAvailable {
            rotateMM.startAccelerometerUpdates( to: OperationQueue() ) { p, _ in
                if p != nil {
                    self.changeOrientationTo = (fabs( (p?.acceleration.y)! ) < fabs( (p?.acceleration.x)! ) ?   Double((p?.acceleration.x)!) > 0.0 ? UIInterfaceOrientation.landscapeLeft.rawValue  :   UIInterfaceOrientation.landscapeRight.rawValue :   Double((p?.acceleration.y)!) > 0.0 ? UIInterfaceOrientation.portraitUpsideDown.rawValue   :   UIInterfaceOrientation.portrait.rawValue )
                    print("self.changeOrientationTo: ", self.changeOrientationTo)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.rotateMM.stopAccelerometerUpdates()
                if self.changeOrientationTo != nil{
                    completionHandler(self.changeOrientationTo)
                }
                else{
                    completionHandler(-1)
                }
            })
        } else {
            completionHandler(4)
            return
        }
    }
}
