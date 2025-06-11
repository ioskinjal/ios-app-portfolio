//
//  PreferencesVC.swift
//  YUPPTV
//
//  Created by Ankoos on 12/08/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk

class PreferencesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIGestureRecognizerDelegate {
    var languagesArray = [Language]()
    var selectedLanguagesArray:NSMutableArray!
    var fromPage:Bool!
    var Signup_Process:Bool!
    var viewControllerName = ""
    
    
    var cCFL: CustomFlowLayout!
    let secInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var cellSizes: CGSize = CGSize(width: 140, height: 60)
    var numColums: CGFloat = 2
    let interItemSpacing: CGFloat = 20
    let minLineSpacing: CGFloat = 20
    let scrollDir: UICollectionView.ScrollDirection = .vertical
    var actualCellSize: CGSize?
    var maxLanguagesSelection:Int = 0
    var isMultiSelectable:Bool = false

    @IBOutlet weak var langHeaderLbl: UILabel!
    @IBOutlet weak var langSubHeaderLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var languageHeaderLbl: UILabel!
    @IBOutlet weak var skiporclearButton: UIButton!
    @IBOutlet weak var saveornextBtn: UIButton!
    @IBOutlet weak var LanguageCollectionView: UICollectionView!
    
    @IBOutlet weak var langCVTopToNavConstraint: NSLayoutConstraint!
    @IBOutlet weak var langCVTopToStack: NSLayoutConstraint!
    @IBOutlet weak var buttonsBgViewBottomConstaraint: NSLayoutConstraint!
   
    func calculateNumCols() {
        //        let availableWidth = (UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - secInsets.left - secInsets.right)
        //        numColums = floor(availableWidth / cellSizes.width)
        //        cCFL.numberOfColumns = numColums
        //        print("numColums: ", self.numColums)
        //        return
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
        Log(message: "numColums: \(self.numColums)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.navigationBar.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationBar.cornerDesign()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        selectedLanguagesArray = NSMutableArray()
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success>Select Language")

        /*
        if self.viewControllerName == "Intro" {
            self.backBtn.isHidden = true
        }
        else {
            self.backBtn.isHidden = false
        }
         */
        LanguageCollectionView.register(UINib.init(nibName: LanguageCVC.nibname, bundle: nil)  , forCellWithReuseIdentifier: LanguageCVC.identifier)
        
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeBottomConstraint(notification:)), name: NSNotification.Name(rawValue: "ChangeBottomConstraint"), object: nil)

        
        if  OTTSdk.preferenceManager.selectedLanguages.isEmpty == false {
            
            let langStr = OTTSdk.preferenceManager.selectedLanguages
            self.printLog(log:langStr as AnyObject?)
            let arr = langStr.components(separatedBy: ",")
            for langArrStr in arr {
                if langArrStr != "" {
                    selectedLanguagesArray.add(langArrStr)
                }
            }
            self.printLog(log:selectedLanguagesArray)
        } else {
            for lang in languagesArray {
                selectedLanguagesArray.add(lang.code)
            }
        }
        
        if self.fromPage == true {
            if self.Signup_Process == true {
                self.skiporclearButton.setTitle("Skip".localized, for: UIControl.State.normal)
                self.saveornextBtn.setTitle("Next".localized, for: UIControl.State.normal)
            }
            else{
                self.skiporclearButton.setTitle("Clear".localized, for: UIControl.State.normal)
                self.saveornextBtn.setTitle("Ok".localized, for: UIControl.State.normal)
            }
          
        }else{
            self.skiporclearButton.setTitle("Clear".localized, for: UIControl.State.normal)
            self.saveornextBtn.setTitle("Save".localized, for: UIControl.State.normal)
        }
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        self.startAnimating(allowInteraction: false)
        
        OTTSdk.appManager.configuration(onSuccess: { (response) in
            AppDelegate.getDelegate().configs = response.configs
            AppDelegate.getDelegate().setConfigResponce(response.configs)
            self.stopAnimating()
            self.languagesArray = response.contentLanguages
            //#warning hardcoded both self.isMultiSelectable and self.maxLanguagesSelection values
            //                self.isMultiSelectable = response.languageSelectionAttributes.isMultiSelectable
            //                self.maxLanguagesSelection = response.clientConfigs.contentLanguagesMaxLimit
            self.isMultiSelectable = true
            self.maxLanguagesSelection = 4
            if  OTTSdk.preferenceManager.selectedLanguages.isEmpty {
                for lang in self.languagesArray {
                    self.selectedLanguagesArray.add(lang.code)
                }
            }
            //
            //                for lang in self.languagesArray{
            //                    if !self.selectedLanguagesArray.contains(lang.code) {
            //                        self.selectedLanguagesArray.add(lang.code)
            //                    }else
            //                    {
            //                        self.selectedLanguagesArray.remove(lang.code)
            //                    }
            //                }
            DispatchQueue.main.async {
                if self.languagesArray.count == self.selectedLanguagesArray.count {
                    self.selectAllBtn.isUserInteractionEnabled = false
                    self.selectAllBtn.isEnabled = false
                    self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50, for: .normal)
                }else {
                    self.selectAllBtn.isUserInteractionEnabled = true
                    self.selectAllBtn.isEnabled = true
                    self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
                }
                self.stopAnimating()
                self.LanguageCollectionView .reloadData()
            }
        }, onFailure: { (error) in
            self.stopAnimating()
            self.showAlertWithText(header: String.getAppName(), message: error.message)
            Log(message: error.message)
        })
        
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
    @objc func changeBottomConstraint(notification: NSNotification) {
        if let status = notification.userInfo?["status"] as? Bool {
            if status {
                self.buttonsBgViewBottomConstaraint.constant = 85
            }
            else {
                self.buttonsBgViewBottomConstaraint.constant = 0.0
            }
        }
    }
    func showGDPRPrivacyPopUp() {
        let popOverVC = UIStoryboard(name: "Tabs", bundle: nil).instantiateViewController(withIdentifier: "GDPRPrivacyPopupVC") as! GDPRPrivacyPopupVC
        popOverVC.type = "Cookie"
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    func calculateActualSize(cellSizes: CGSize, numColums: CGFloat, interItemSpacing: CGFloat, secInsets: UIEdgeInsets) -> CGSize {
        let newW = (UIScreen.main.bounds.size.width - ((numColums-1) * interItemSpacing) - secInsets.left - secInsets.right) / numColums
        let imageSize = cellSizes
        let returnHeight = (newW / imageSize.width) * imageSize.height
        return CGSize(width: newW, height: returnHeight)
    }
    func setupViews() {
        var tmpCellsize = cellSizes
        tmpCellsize.height = tmpCellsize.height - secInsets.top - secInsets.bottom
        cellSizes = tmpCellsize
        if viewControllerName == "Intro" {
            self.skiporclearButton.isHidden = true
            self.navigationBar.isHidden = true
            self.langHeaderLbl.isHidden = false
            self.langSubHeaderLbl.isHidden = false
            self.langCVTopToStack.isActive = true
            self.langCVTopToNavConstraint.isActive = false
        }else {
            self.navigationBar.isHidden = false
            self.skiporclearButton.isHidden = false
            self.langHeaderLbl.isHidden = true
            self.langSubHeaderLbl.isHidden = true
            self.langCVTopToStack.isActive = false
            self.langCVTopToNavConstraint.isActive = true
        }
        self.saveornextBtn.backgroundColor = AppTheme.instance.currentTheme.themeColor
        cCFL = CustomFlowLayout()
        cCFL.secInset = secInsets
        cCFL.cellSize = cellSizes
        cCFL.interItemSpacing = interItemSpacing
        cCFL.minLineSpacing = minLineSpacing
        cCFL.numberOfColumns = numColums
        cCFL.scrollDir = scrollDir
         self.calculateNumCols()
        cCFL.setupLayout()
        LanguageCollectionView.collectionViewLayout = cCFL
        self.actualCellSize = calculateActualSize(cellSizes: cellSizes, numColums: numColums, interItemSpacing: interItemSpacing, secInsets: secInsets)
        Log(message: "actualCellSize: \(actualCellSize!)")
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewControllerName == "Intro" {
            if(!AppDelegate.getDelegate().cookiesHasAlreadyLaunched){
                //set hasAlreadyLaunched to false
//                AppDelegate.getDelegate().sethasAlreadyLaunched()
                //display user agreement license
               
                if appContants.appName != .mobitel {
                    self.showGDPRPrivacyPopUp()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
       self.stopAnimating()
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success>Select Language>Signup Success")
        if self.Signup_Process == true || self.viewControllerName == "Intro" {
            AppDelegate.getDelegate().loadHomePage()
        }
        else if self.viewControllerName == "TabsVC" {
            self.dismiss(animated: true, completion: nil)
        }
        else{
              _ = self.navigationController?.popViewController(animated: true)
        }

    }
    // Show alert
    func showAlertWithText (header : String, message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    
    @IBAction func skipAction(_ sender: AnyObject) {
        self.selectedLanguagesArray.removeAllObjects()
        self.LanguageCollectionView.reloadData()
        self.selectAllBtn.isUserInteractionEnabled = true
        self.selectAllBtn.isEnabled = true
        self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
//        self.backAction(UIButton())
    }
    @IBAction func NextBtnAction(_ sender: AnyObject) {
        if selectedLanguagesArray.count > 0 {
            
            let tempLangAArrStr = NSMutableArray()
            for langObj in languagesArray {
                if selectedLanguagesArray.contains(langObj.code) {
                    tempLangAArrStr.add(langObj.code)
                }
            }
                        
                OTTSdk.preferenceManager.userPrefferedLanguages = tempLangAArrStr
//            LocalyticsEvent.tagEventWithAttributes("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success>Select Language", ["Languages":tempLangAArrStr.componentsJoined(by: ",")])
                if !Utilities.hasConnectivity() {
                    AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
                    return
                }
//            if OTTSdk.preferenceManager.user != nil{
//                self.startAnimating(allowInteraction: false)
                OTTSdk.userManager.updatePreference(selectedLanguageCodes: tempLangAArrStr.componentsJoined(by: ","), sendEmailNotification: true, onSuccess: { (response) in
                    print(response)
                    self.stopAnimating()
                    if self.viewControllerName == "Intro" {
//                        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register>Register Form>OTP verification>OTP Success>Select Language>Signup Success")
                        AppDelegate.getDelegate().loadHomePage()
                    }
                    else if self.viewControllerName == "PlayerVC" {
                        self.backAction(UIButton())
                    }
                    else {
//                        self.backAction(UIButton())
                        if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                                AppDelegate.getDelegate().loadHomePage()
                        })
                        }
                    }
                }, onFailure: { (error) in
                    Log(message: error.message)
                    self.stopAnimating()
                    self.showAlertWithText(header: String.getAppName(), message: error.message)
                })
//            }else
//            {
//                OTTSdk.preferenceManager.localLanguages = lang_pref
//                self.backAction(UIButton())
//            }
        } else {
            self.showAlertWithText(header: String.getAppName(), message: "Select atleast one Language".localized)
        }
    }
    
    @IBAction func selectAllClicked(_ sender: Any) {
        self.selectedLanguagesArray.removeAllObjects()
        for language in languagesArray {
            self.selectedLanguagesArray.add(language.code)
        }
        self.selectAllBtn.isUserInteractionEnabled = false
        self.selectAllBtn.isEnabled = false
        self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50, for: .normal)
        self.LanguageCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBarHidden = true
        
        if playerVC != nil {
            buttonsBgViewBottomConstaraint.constant = 85
        }
        else {
            buttonsBgViewBottomConstaraint.constant = 0
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.calculateNumCols()
            self.actualCellSize = self.calculateActualSize(cellSizes: self.cellSizes, numColums: self.numColums, interItemSpacing: self.interItemSpacing, secInsets: self.secInsets)
            self.LanguageCollectionView.collectionViewLayout.invalidateLayout()
            self.LanguageCollectionView.reloadData()
        }) { (UIViewControllerTransitionCoordinatorContext) in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
}
extension PreferencesViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.actualCellSize!
    }
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.languagesArray.count > 0 ? self.languagesArray.count : 0)
    }
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.stopAnimating()

        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: LanguageCVC.identifier as String, for: indexPath)
        let langDict = languagesArray[indexPath.item]
        
        let langTitleLabel = cell1.contentView.viewWithTag(1) as! UILabel
        let checkButton = cell1.contentView.viewWithTag(2) as? UIButton
        langTitleLabel.viewBorderWithOne(cornersRequired: true)
        langTitleLabel.text = langDict.name
        if checkButton != nil {
            //#imageLiteral(resourceName: "check_selected")
            checkButton?.setImage(UIImage(named: "check_selected"), for: UIControl.State.selected)
        }
       
        
        
        /***selected genres**/
        if selectedLanguagesArray.contains(langDict.code) {
            if checkButton != nil {
                checkButton?.isSelected = true
            }
            langTitleLabel.backgroundColor = AppTheme.instance.currentTheme.langSelBg
            langTitleLabel.changeBorder(color: AppTheme.instance.currentTheme.langSelBorder)
            langTitleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        }else{
            if checkButton != nil {
                checkButton?.isSelected = false
            }
            langTitleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
            langTitleLabel.backgroundColor = AppTheme.instance.currentTheme.langUnselBg
            langTitleLabel.changeBorder(color: AppTheme.instance.currentTheme.langUnselBorder)
        }
//        cell1.langCornerDesign()
        /***selected genres***/
        return cell1
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return secInsets
    }
    func languageSelected(_ sender: AnyObject?) -> Void {
        let btn = sender as! UIButton
        btn.isSelected = true
        
        btn.setImage(UIImage(named: "check_selected"), for: UIControl.State.selected)
    }
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let checkButton = cell.contentView.viewWithTag(2) as! UIButton
        let dict = languagesArray[indexPath.item]

        if checkButton.isSelected == true {
            checkButton.isSelected = false
            self.selectedLanguagesArray.remove(dict.code)
        }else{
            checkButton.isSelected = true
//            if self.selectedLanguagesArray.count < 4 {
            self.selectedLanguagesArray.add(dict.code)
//            }
//            else {
//                self.showAlertWithText(header: String.getAppName(), message: "You can select only max 4".localized)
//            }
        }
        if self.languagesArray.count == self.selectedLanguagesArray.count {
            self.selectAllBtn.isUserInteractionEnabled = false
            self.selectAllBtn.isEnabled = false
            self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50, for: .normal)
        }else {
            self.selectAllBtn.isUserInteractionEnabled = true
            self.selectAllBtn.isEnabled = true
            self.selectAllBtn.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        }
//        self.selectedLanguagesArray.removeAllObjects()
        self.LanguageCollectionView.reloadData()
//        self.startAnimating(allowInteraction: false)
//        self.NextBtnAction(self.saveornextBtn)
    }

}
class LanguageCVC: UICollectionViewCell {
     static let nibname:String = "LanguageCVC"
     static let identifier:String = "LanguageCVC"
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}
