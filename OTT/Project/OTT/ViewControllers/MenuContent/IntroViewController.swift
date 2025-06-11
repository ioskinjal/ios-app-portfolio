//
//  IntroViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 12/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class IntroViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var subHeaderLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subHeaderLbl: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    var skipPageTimer : Timer!
    
    @IBOutlet weak var pageContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signInBtnTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var onlySignInView: UIView!
    
    @IBOutlet weak var onlySignViewSignInBtn: UIButton!
    
    @IBOutlet weak var signUpBtnTrailingConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let imageUrl = productType.iPhone ? AppDelegate.getDelegate().configs?.landingPageImageMobileUrl : AppDelegate.getDelegate().configs?.landingPageImageTabUrl
        if imageUrl != nil{
            self.backgroundImgView.sd_setImage(with: URL.init(string: imageUrl!))
        }*/
        
        //self.getLandingPageContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.headerLbl.text = "".localized
        self.subHeaderLbl.text = "".localized
        skipPageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.skipPageTimerAction), userInfo: nil, repeats: true)
        
        self.signinBtn.setTitle("Sign-in".localized, for: .normal)
        self.onlySignViewSignInBtn.setTitle("SIGN IN".localized, for: .normal)
        self.signUpBtn.setTitle("Register".localized, for: .normal)
//        self.signUpBtn.withBorder()
        
        let scrollViewWidth:CGFloat = self.view.frame.width
        
        self.signinBtn.setTitleColor(UIColor.white, for: .normal)
        self.onlySignViewSignInBtn.setTitleColor(UIColor.white, for: .normal)

        let array:NSArray  =  [UIImageView.init(image: UIImage.init(named: "spalshScreen"))]
        let itemWidth:CGFloat = scrollViewWidth

        if self.pageControl != nil {
            self.pageControl.currentPageIndicatorTintColor = UIColor.init(red: 227.0/255.0, green: 6.0/255.0, blue: 19.0/255.0, alpha: 1.0)
            self.pageControl.pageIndicatorTintColor = UIColor.white
            var xx :CGFloat =  0
            
            for imgView in array {
                let view = imgView as! UIImageView
                view.frame.origin.x = xx
                view.frame.size.width = itemWidth
                view.contentMode = .scaleToFill
                xx += itemWidth
//                self.pageScroll.addSubview(view)
            }
            let count:CGFloat = CGFloat(array.count)
            
            
//            self.pageScroll.contentSize = CGSize(width: scrollViewWidth * count, height: self.pageScroll.frame.size.height)
            self.pageControl.numberOfPages = array.count
//            self.pageScroll.backgroundColor = UIColor.homeStatusBarColor()
//            self.pageScroll.delegate = self
            self.pageControl.currentPage = 0
            self.pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
            if array.count == 1 {
                self.pageControl.isHidden = true
            }
            else {
                self.pageControl.isHidden = false
            }
        }
        
        if productType.iPad {
            //headerLblTopConstraint.constant = 120.0
            //pageContainerViewTopConstraint.constant = 80.0
        }
        
        if !AppDelegate.getDelegate().iosAllowSignup {
            self.onlySignInView.isHidden = false
        }
        else {
            self.onlySignInView.isHidden = true
        }
        
        self.headerLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.subHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.7)
        self.signinBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        self.onlySignViewSignInBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        // Do any additional setup after loading the view.
    }
    
   /* func getLandingPageContent() {
        self.startAnimating(allowInteraction: false)
        let targetPath = AppDelegate.getDelegate().getStaticPagePathFrom(AppDelegate.getDelegate().configs, forStr: "Intro")
        OTTSdk.mediaCatalogManager.pageContent(path: targetPath, onSuccess: { (response) in
            self.stopAnimating()
            for pageData in response.data {
                if pageData.paneType == .content {
                    if let content = pageData.paneData as? Content {
                        for dataRow in content.dataRows {
                            for element in dataRow.elements {
                                if dataRow.rowNumber == 1 && element.contentCode == "landing_page_content" && element.elementType == .image {
                                    
                                    self.logoImgView.sd_setImage(with: URL.init(string: element.data), placeholderImage: UIImage.init(named: "IntroPageWelcomeIcon"))
                                } else if dataRow.rowNumber == 2 && element.contentCode == "landing_page_content" && element.elementType == .text {
                                    self.headerLbl.text = element.data
                                    self.headerLbl.sizeToFit()
                                    self.headerLblHeightConstraint.constant = self.headerLbl.frame.size.height + 20.0
                                } else if dataRow.rowNumber == 3 && element.contentCode == "landing_page_content" && element.elementType == .text {
                                    self.subHeaderLbl.text = element.data
                                    self.subHeaderLbl.sizeToFit()
                                    self.subHeaderLblHeightConstraint.constant = self.subHeaderLbl.frame.size.height + 20.0
                                } else if dataRow.rowNumber == 4 && element.contentCode == "landing_page_content" && element.elementType == .button && element.elementSubtype == "signin" {
                                    self.onlySignViewSignInBtn.setTitle(element.data.uppercased(), for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }) { (error) in
            self.stopAnimating()
        }
    }*/
    
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getDelegate().taggedScreen = "Intro Page"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = (productType.iPad ? true : false)
        if productType.iPhone {
            let value1 = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value1, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if skipPageTimer != nil {
            skipPageTimer.invalidate()
        }
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = (productType.iPad ? true : false)
        if productType.iPhone {
            let value1 = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value1, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        AppDelegate.getDelegate().sourceScreen = "Intro_Page"
    }
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if AppTheme.instance.currentTheme.isStatusBarWhiteColor == true {
            return UIStatusBarStyle.lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                return UIStatusBarStyle.darkContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        storyBoardVC.viewControllerName = "SignUpVC"
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Signin")
        /**/
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "SignInVC"
        let nav = UINavigationController.init(rootViewController: storyBoardVC)
        nav.isNavigationBarHidden = true
        AppDelegate.getDelegate().window?.rootViewController = nav
    }
    
    @objc func skipPageTimerAction(){
        return;
        exploreClicked("")
    }
    
    @IBAction func exploreClicked(_ sender: Any) {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>See more")
        if OTTSdk.preferenceManager.selectedLanguages == "all" {
            AppDelegate.getDelegate().loadContentLanguagePage()
        }
        else {
            AppDelegate.getDelegate().loadHomePage()
            if AppDelegate.getDelegate().fromLaunchApp && !(AppDelegate.getDelegate().deepLinkingString .isEmpty) {
                AppDelegate.getDelegate().fromLaunchApp = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadSharedVideo"), object: nil)
                }
            }
        }
    }
    
    
    @IBAction func helpBtnClicked(_ sender: Any) {
        AppDelegate.getDelegate().gotoHelpPage()
    }
    
    @objc func changePage(sender: AnyObject) -> () {
//        let x = CGFloat(pageControl.currentPage) * self.pageScroll.frame.size.width
//        self.pageScroll.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        skipPageTimer.invalidate()
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - touches delegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        skipPageTimer.invalidate()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
