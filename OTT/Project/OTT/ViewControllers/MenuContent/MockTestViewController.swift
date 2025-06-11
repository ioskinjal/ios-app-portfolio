//
//  MockTestViewController.swift
//  OTT
//
//  Created by Srikanth on 3/3/21.
//  Copyright © 2021 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleCast

class MockTestViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,GCKSessionManagerListener ,GCKRemoteMediaClientListener,GCKRequestDelegate,GCKUIMediaControllerDelegate,GCKUIMiniMediaControlsViewControllerDelegate  {
  
    @IBOutlet weak var mockTestCollectionView: UICollectionView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var navigationBarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonWidthConstraint: NSLayoutConstraint!
    
    var mockListDataArray = [MockTestList]()
    var sectionTitle = ""
    var secInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 5.0, right: 5.0)
    var numColums: CGFloat = 3
    let interItemSpacing: CGFloat = 0
    let minLineSpacing: CGFloat = 13
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var cCFL: CustomFlowLayout!
    
    var miniMediaControlsViewController = GCKUIMiniMediaControlsViewController()
       var miniMediaControlsViewEnabled = true
       let kCastControlBarsAnimationDuration = 0.20
    @IBOutlet weak var chromeButtonView: UIView!
    @IBOutlet weak var _miniMediaControlsContainerView : UIView!
    @IBOutlet weak var _miniMediaControlsHeightConstraint : NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if TabsViewController.shouldHideSearchButton == true {
            self.searchButton.isHidden = true
            self.searchButtonWidthConstraint.constant = 0
        }
        else{
            self.searchButton.isHidden = false
            self.searchButtonWidthConstraint.constant = 52
        }
    }
    
    func setResponseData() {
        if mockListDataArray.count > 0 {
            self.errorView.isHidden = true
            self.mockTestCollectionView.reloadData()
        }
        else {
            self.errorView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if productType.iPad {
            secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        }
        self.navigationBarView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.navigationBarView.cornerDesign()
        self.sectionLabel.text = sectionTitle
        self.collectionViewTopConstraint.constant = 0.0
        self.navigationBarView.isHidden = false
        mockTestCollectionView.register(UINib(nibName: MockTestCell.nibname, bundle: nil), forCellWithReuseIdentifier: MockTestCell.identifier)
        
        cCFL = CustomFlowLayout()
        cCFL.interItemSpacing = interItemSpacing
        cCFL.secInset = secInsets
        cCFL.minLineSpacing = minLineSpacing
        self.calculateNumCols()
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        cCFL.setupLayout()
        mockTestCollectionView.collectionViewLayout = cCFL
        
        self.setResponseData()
        
        if productType.iPad {
            secInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        }
        //Google cast
        let customButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: CGFloat(40), height: CGFloat(40)))
        customButton.tintColor = .white
        self.chromeButtonView.addSubview(customButton)
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        let castContext = GCKCastContext.sharedInstance()
    
        if appContants.isChromeCastEnabled && AppDelegate.getDelegate().supportChromecast {
            self.chromeButtonView.isHidden = false
        }
        else {
            self.chromeButtonView.isHidden = true
        }
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.addChild(miniMediaControlsViewController)
        self.miniMediaControlsViewController.view.frame = _miniMediaControlsContainerView.bounds
        _miniMediaControlsContainerView.addSubview(miniMediaControlsViewController.view)
        miniMediaControlsViewController.didMove(toParent: self)
        self.updateControlBarsVisibility()
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    override var prefersStatusBarHidden : Bool {
        return false
    }

    func calculateNumCols() {
        if productType.iPad {
            numColums = (currentOrientation().portrait ? 4 : 5)
        } else {
            numColums = 2
        }
        cCFL.numberOfColumns = numColums
        print("numColums: ", self.numColums)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       
    //MARK: - CollectionView data source methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.mockListDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let mockTestObj = self.mockListDataArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MockTestCell.identifier, for: indexPath) as! MockTestCell
    
        cell.imageView.sd_setImage(with: URL(string: mockTestObj.imageUrl), placeholderImage: #imageLiteral(resourceName: "portrait-default"))
        cell.name.text = mockTestObj.title
        cell.desc.text = mockTestObj.subTitle
        
        cell.imageView.layer.cornerRadius = 5.0
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if productType.iPad {
            return CGSize(width: 229, height: 182)
        }
        else {
            return CGSize(width: 179, height: 132)
        }
    }
    //cv delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mockTestObj = self.mockListDataArray[indexPath.item]
        if mockTestObj.isInternal == true {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = mockTestObj.redirectionUrl
            view1.pageString = mockTestObj.title
            view1.viewControllerName = "HelpOptionsViewController"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
        else {
            let popupTitle = mockTestObj.popupTitle
            let popupMessage = mockTestObj.popupMessage
            
            let alert = UIAlertController(title: popupTitle, message: popupMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                let urlStr = mockTestObj.redirectionUrl
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: urlStr)!, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    
                } else {
                    UIApplication.shared.openURL(URL(string: urlStr)!)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calculateNumCols()
        mockTestCollectionView.collectionViewLayout.invalidateLayout()
        mockTestCollectionView.reloadData()
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchBtnClicked(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Content", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: false)
    }

    func showAlert (_ header : String = String.getAppName(), message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        let resumeAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(resumeAlertAction)
        //        alert.view.tintColor = UIColor.redColor()
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func castDeviceDidChange(_ notification: Notification) {
        /*if GCKCastContext.sharedInstance().castState == .noDevicesAvailable {
         self.chromeButtonView.isHidden = true
         }
         else{*/
        if appContants.isChromeCastEnabled && AppDelegate.getDelegate().supportChromecast {
            self.chromeButtonView.isHidden = false
        }
        else {
            self.chromeButtonView.isHidden = true
        }
        // }
    }
    // MARK: - Chrome Cast Device Scanner Delegates -
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && miniMediaControlsViewController.active {
            self._miniMediaControlsHeightConstraint.constant = 80
            self.view.bringSubviewToFront(_miniMediaControlsContainerView)
            if playerVC != nil {
                playerVC?.showHidePlayerView(true)
            }
        }
        else {
            self._miniMediaControlsHeightConstraint.constant = 0
                        if playerVC != nil {
                            playerVC?.showHidePlayerView(false)
            //                playerVC?.player.stop()
                        }
        }
        self.view.setNeedsLayout()
    }
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController, shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
    
}
