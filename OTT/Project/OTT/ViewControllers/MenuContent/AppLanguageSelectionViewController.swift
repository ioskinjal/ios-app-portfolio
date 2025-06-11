//
//  AppLanguageSelectionViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 21/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class AppLanguageSelectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIGestureRecognizerDelegate {

    var appLangArr = [Language]()
    var selectedAppLangArr = [String]()
    
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var cellSizes: CGSize = CGSize(width: 156.0, height: 48.0)
    var numColums: CGFloat = 2
    let interItemSpacing: CGFloat = 10
    let minLineSpacing: CGFloat = 20
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    
    @IBOutlet weak var selectAppLangLbl: UILabel!
    @IBOutlet weak var appLangCollectionView: UICollectionView!
    @IBOutlet weak var continueBtn: UIButton!
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    //MARK: - Life Cycle Methdos
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.selectedAppLangArr = Constants.defaultDisplayLanguage
        self.selectAppLangLbl.text = "Select your app Language".localized
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        appLangCollectionView.register(UINib.init(nibName: "AppLanguageCell", bundle: nil)  , forCellWithReuseIdentifier: "AppLanguageCell")
        setupViews()
        self.updateUIForLangCode(code: Constants.defaultDisplayLanguage.first!)
//        self.getAppLanguages()
    
        self.appLangArr = Constants.displayLanguages
        self.appLangCollectionView.reloadData()
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = false
        let value1 = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value1, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let appDelegate = AppDelegate.getDelegate()
        appDelegate.shouldRotate = false
        let value1 = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value1, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
//            self.calculateNumCols()
//            self.appLangCollectionView.collectionViewLayout.invalidateLayout()
//            self.appLangCollectionView.reloadData()
//        }) { (UIViewControllerTransitionCoordinatorContext) in
//        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Custom Methdos

    func updateUIForLangCode(code : String){
        //Change to temp display lang
        let previousLang = OTTSdk.preferenceManager.selectedDisplayLanguage
        OTTSdk.preferenceManager.selectedDisplayLanguage = code
        Localization.instance.updateLocalization()
        
        //Change strings
        self.continueBtn.setTitle("Continue".localized, for: .normal)
        self.selectAppLangLbl.text = "Select your app Language".localized

        //Reset to actual display lang
        OTTSdk.preferenceManager.selectedDisplayLanguage = previousLang
        Localization.instance.updateLocalization()
    }
    
    func calculateNumCols() {
        if productType.iPad {
            if currentOrientation().portrait {
                numColums = 5
            } else if currentOrientation().landscape {
                numColums = 6
            }
        } else {
            if currentOrientation().portrait {
                numColums = 2
            } else if currentOrientation().landscape {
                numColums = 3
            }
        }
        cCFL.numberOfColumns = numColums
        print("numColums: ", self.numColums)
    }


    func setupViews() {
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
        self.calculateNumCols()
        cCFL.setupLayout()
        appLangCollectionView.collectionViewLayout = cCFL
    }
    
    /* Dynamic display languages
    func getAppLanguages() {
        self.startAnimating(allowInteraction: false)
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        OTTSdk.appManager.configuration(onSuccess: { (response) in
            self.stopAnimating()
            self.appLangArr = response.displayLanguages
            self.appLangCollectionView.reloadData()
        }) { (error) in
            self.stopAnimating()
        }
    }*/
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        startAnimating(allowInteraction: true)
        if let code = self.selectedAppLangArr.first{
            OTTSdk.userManager.sessionPreference(displayLangCode: code, onSuccess: { (response) in
                Localization.instance.updateLocalization()
//                LocalyticsEvent.tagEvent("Launch>Display Language>\(code)")
                self.moveToNextScreen()
            }) { (error) in
                self.moveToNextScreen()
            }
        }
        else{
            self.moveToNextScreen()
        }
        
    }
    
    func moveToNextScreen(){
        self.stopAnimating()
        let yuppFLixUserDefaults = UserDefaults.standard
        yuppFLixUserDefaults.set(nil, forKey: "ShowIntroScreen")
        if yuppFLixUserDefaults.object(forKey: "ShowIntroScreen") == nil {
            yuppFLixUserDefaults.set(true, forKey: "ShowIntroScreen")
            let homeStoryboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = homeStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let nav = UINavigationController.init(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            AppDelegate.getDelegate().window?.rootViewController = nav
        } else {
            AppDelegate.getDelegate().loadHomePage()
        }
    }
    /*
    func languageSelected(_ sender: AnyObject?) -> Void {
        let btn = sender as! UIButton
        btn.isSelected = true
        
        btn.setImage(#imageLiteral(resourceName: "check_selected"), for: UIControl.State.selected)
    }*/
    
}

//MARK: - UICollectionView Methods
extension AppLanguageSelectionViewController {
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.appLangArr.count > 0 ? self.appLangArr.count : 0)
    }
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "AppLanguageCell" as String, for: indexPath)
        let appLang = appLangArr[indexPath.item]
        
        let langTitle = cell1.contentView.viewWithTag(1) as! UILabel
        let checkButton = cell1.contentView.viewWithTag(2) as! UIButton
        let blurLangTitle = cell1.contentView.viewWithTag(3) as! UILabel
        
        langTitle.text = appLang.name
        blurLangTitle.text = appLang.name
        checkButton.setImage(#imageLiteral(resourceName: "check_selected"), for: UIControl.State.selected)
        
        
        
        /***selected genres**/
        if selectedAppLangArr.contains(appLang.code) {
            checkButton.isSelected = true
        }else{
            checkButton.isSelected = false
        }
        cell1.cornerDesign()
//        let  i  = (indexPath.row as Int) % Int(categoriesColorArr.count)
//        cell1.backgroundColor = categoriesColorArr[i] as? UIColor
        /***selected genres***/
        return cell1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let checkButton = cell.contentView.viewWithTag(2) as! UIButton
        
        if checkButton.isSelected == true {
            checkButton.isSelected = false
        }else{
            checkButton.isSelected = true
        }
        let appLang = appLangArr[indexPath.item]
        self.selectedAppLangArr.removeAll()
        self.selectedAppLangArr.append(appLang.code)
        updateUIForLangCode(code: appLang.code)
        self.appLangCollectionView.reloadData()
    }
    
}
