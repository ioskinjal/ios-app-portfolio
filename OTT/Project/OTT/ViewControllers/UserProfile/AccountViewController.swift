//
//  AccountViewController.swift
//  YUPPTV
//
//  Created by Ankoos on 19/09/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk

class AccountViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,iShowcaseDelegate,PlayerViewControllerDelegate,DefaultViewControllerDelegate {
    
    
    func didSelectedOfflineSuggestion(stream: Stream) {
        
    }
    
    enum TitlesEnum : String {
        case account = "Account"
        //case closedCaption = "Closed Caption (CC)"
        case activeStreams = "Active Screens"
        case myQuestions = "My Doubts/Questions"
        case watchlist = "My Watchlist"
        case setup = "Setup"
//        case help = "Help"
//        case logout = "Sign Out"
    }
    enum Sections{
        case signInSignUp
        case other
        case menu
    }
    @IBOutlet weak var navigationHeaderView: UIView!
    @IBOutlet weak var signoutViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountTable: UITableView!
    @IBOutlet weak var appLogoImageView: UIImageView!
    var versionLbl : UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameCircleLabel: UILabel!
    
    var menuOptionsArray = [[String : Any]]()
    var titlesArray = [TitlesEnum]()
    var userInfoDict = NSDictionary()
    var sections = [Sections]()
    var selectedMenuTargetPath = ""
   
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
      
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if OTTSdk.preferenceManager.user != nil {
            let userAttributes = OTTSdk.preferenceManager.user?.attributes
            if !(userAttributes?.timezone .isEmpty)! && (userAttributes?.timezone)! != "false"{
                NSTimeZone.default = NSTimeZone.init(name: (userAttributes?.timezone)!)! as TimeZone
            }
            //            print((userAttributes?.displayLanguage)!)
            //            if !(userAttributes?.displayLanguage .isEmpty)! {
            //                OTTSdk.preferenceManager.selectedDisplayLanguage = (userAttributes?.displayLanguage)!
            //                Localization.instance.updateLocalization()
            //            }
        }
        else{
            NSTimeZone.default = AppDelegate.getDelegate().userTimeZone
        }
        if let array = AppDelegate.getDelegate().configs?.megaMenuSections.convertToJson() as? [[String : Any]]{
            self.menuOptionsArray = array
        }
        

        self.doneButton.isHidden = true
        self.doneButtonWidthConstraint.constant = 0
        
        self.signoutButton.setTitle("Sign out", for: .normal)
        self.signoutButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
        self.signoutButton.setTitleColor(AppTheme.instance.currentTheme.cardSubtitleColor, for: .normal)
        self.signoutButton.buttonCornerDesignWithBorder(AppTheme.instance.currentTheme.cardSubtitleColor, borderWidth: 1.0)
        AppDelegate.getDelegate().taggedScreen = "Settings"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationController?.isNavigationBarHidden = true
 
        appLogoImageView.image = UIImage(named: "appLogo")!
        navigationHeaderView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        //self.navigationHeaderView.cornerDesign()
        self.updateUI()
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUser()
        //self.updateUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        versionLabel.numberOfLines = 2
        var serviceType = "" // Default for live
        if appContants.serviceType == .beta{
            serviceType = " Beta"
        }
        else if appContants.serviceType == .UAT{
            serviceType = " UAT"
        }
        versionLabel.text = "Version \(Bundle.applicationVersionNumber).\(Bundle.applicationBuildNumber),\(serviceType)\nDevice : \(UIDevice.modelName), \(UIDevice.current.systemVersion)"

         versionLabel.textAlignment = .center
        versionLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.5)
        versionLabel.font = UIFont.ottMediumFont(withSize: 13)
        self.signoutViewHeightConstraint.constant = 60
        self.signOutView.isHidden = false
        
    }
    
    func LogOutClicked() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), Action: false)
            return
        }
        self.startAnimating(allowInteraction: false)
        NSTimeZone.default = AppDelegate.getDelegate().userTimeZone
        AppDelegate.getDelegate().userStateChanged = true
        OTTSdk.userManager.signOut(onSuccess: { (result) in
            print(result)
            AppAnalytics.shared.updateUser()
            deleteUserConsentOnAgeAndDob()
            if AppDelegate.getDelegate().recordingCardsArr.count > 0{
                AppDelegate.getDelegate().recordingCardsArr.removeAll()
            }
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                AppDelegate.getDelegate().configs = response.configs
                AppDelegate.getDelegate().setConfigResponce(response.configs)

                /*if TabsViewController.instance.titlearray.count > 0 && TabsViewController.instance.titlearray[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                 TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                 self.stopAnimating()
                 self.updateUser()
                 self.accountTable.reloadData()
                 AppDelegate.getDelegate().taggedScreen = "Hamburger"
                 LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                 self.signoutViewHeightConstraint.constant = 0
                 self.signOutView.isHidden = true
                 })
                 }
                 else {
                 if TabsViewController.instance.titlearray[TabsViewController.instance.selectedMenuRow].targetPath == "guide" {
                 self.stopAnimating()
                 self.updateUser()
                 self.accountTable.reloadData()
                 AppDelegate.getDelegate().taggedScreen = "Hamburger"
                 LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                 self.signoutViewHeightConstraint.constant = 0
                 self.signOutView.isHidden = true
                 }
                 else {
                 TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                 self.stopAnimating()
                 self.updateUser()
                 self.accountTable.reloadData()
                 AppDelegate.getDelegate().taggedScreen = "Hamburger"
                 LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                 self.signoutViewHeightConstraint.constant = 0
                 self.signOutView.isHidden = true
                 })
                 }
                 }*/
                //                if TabsViewController.instance.titlearray[TabsViewController.instance.selectedMenuRow].targetPath == "guide" {
                //                    TabsViewController.instance.tabsControllersRefreshStatus[TabsViewController.instance.titlearray[TabsViewController.instance.selectedMenuRow].targetPath] = false
                //                }
               
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                storyBoardVC.viewControllerName = "SignInVC"
//                let nav = UINavigationController.init(rootViewController: storyBoardVC)
//                nav.isNavigationBarHidden = true
                self.navigationController?.pushViewController(storyBoardVC, animated: true)
                
                
                
////                TabsViewController.instance.selectedMenuRow = 0
//                if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide"{
                   // TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                        self.stopAnimating()
                        self.updateUser()
                        self.accountTable.reloadData()
                        AppDelegate.getDelegate().taggedScreen = "Settings"
                        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                        self.signoutViewHeightConstraint.constant = 0
                        self.signOutView.isHidden = true
                
                
                    //})
//            }
                playerVC?.removeViews()
                playerVC = nil
            }) { (error) in
                Log(message: error.message)
                self.showAlertWithText(message: error.message, Action: true)
                self.stopAnimating()
            }
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message, Action: true)
            Log(message: error.message)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.accountTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().sourceScreen = "Settings_Page"
    }
    
    // MARK: - Custom Methods
    
    func updateUI(){
        //        stopAnimating()
        self.nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.nameLabel.font = UIFont.ottRegularFont(withSize: 14)
        self.nameCircleLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.nameCircleLabel.font = UIFont.ottRegularFont(withSize: 14)
        
        nameCircleLabel.viewBorderWidthWithTwo(color: AppTheme.instance.currentTheme.cardSubtitleColor, isWidthOne: true)
        nameCircleLabel.asCircle()
        
        if OTTSdk.preferenceManager.user != nil{
            if (OTTSdk.preferenceManager.user?.firstName.count)! > 0 {
                let tempStr = ((OTTSdk.preferenceManager.user?.firstName)!) + " " + ((OTTSdk.preferenceManager.user?.lastName)!)
                self.nameLabel.text = tempStr
            }
            else if (OTTSdk.preferenceManager.user?.name.count)! > 0{
                self.nameLabel.text = (OTTSdk.preferenceManager.user?.name)!
            }
            else{
                self.nameLabel.text = OTTSdk.preferenceManager.user?.email ?? ""
            }
            
            let nameChars  = self.nameLabel.text?.replacingOccurrences(of: " ", with: ",")
            let charsArry = nameChars?.components(separatedBy: ",")
            var arr = String()
            for char in charsArry! {
                if char.count > 0 {
                    let splittedStr = char.first
                    arr.append(splittedStr!)
                }
            }
            nameCircleLabel.textAlignment = .center
            nameCircleLabel.text = arr.uppercased()
            self.signOutView.isHidden = false
            self.signoutViewHeightConstraint.constant = 60.0
        }
        else {
            nameCircleLabel.isHidden = true
            nameLabel.isHidden = true
            self.signOutView.isHidden = true
            self.signoutViewHeightConstraint.constant = 0.0
            self.signoutButton.isHidden = true
        }
        
        self.accountTable.reloadData()
    }
    
    func updateUser(){
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.titlesArray = self.formTitleArray()
            self.accountTable.reloadData()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), Action: false)
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.userInfo(onSuccess: { (response) in
            print(response)
            self.stopAnimating()
            self.titlesArray = self.formTitleArray()
            self.accountTable.reloadData()
            
        }) { (error) in
            Log(message: error.message)
            self.titlesArray = self.formTitleArray()
            self.accountTable.reloadData()
            self.stopAnimating()
        }
    }
    
    func formTitleArray() -> [TitlesEnum]{
        var titles = [TitlesEnum]()
        
        if OTTSdk.preferenceManager.user == nil {
            sections = [.signInSignUp, .other]
        }
        else {
            titles.append(.watchlist)
            titles.append(.setup)
            sections = [.other]
        }
        //titles.append(.account)
        //titles.append(.closedCaption)
        //titles.append(.activeStreams)
        //titles.append(.myQuestions)
        //titles.append(.help)
        if OTTSdk.preferenceManager.user != nil {
           // titles.append(.logout)
        }
        return titles
    }
    
    @objc func appLanguageChanged(sender: UISegmentedControl) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), Action: false)
            return
        }
        let selectedLang = Constants.displayLanguages[sender.selectedSegmentIndex]
        startAnimating(allowInteraction: false)
        OTTSdk.userManager.sessionPreference(displayLangCode: selectedLang.code, onSuccess: { (response) in
            Localization.instance.updateLocalization()
            // config nill to get menu in selected language
            ConfigResponse.StoredConfig.lastUpdated = nil
            ConfigResponse.StoredConfig.response = nil
            
            if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                    self.updateUI()
                })
            }
            else {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                    self.updateUI()
                })
            }
        }) { (error) in
            self.showAlertWithText(message: error.message, Action: true)
            var selectedIndex = 0
            for  (index, lang) in Constants.displayLanguages.enumerated(){
                if lang.code == OTTSdk.preferenceManager.selectedDisplayLanguage{
                    selectedIndex = index
                }
            }
            if Constants.displayLanguages.count > 0{
                sender.selectedSegmentIndex = selectedIndex
            }
            Localization.instance.updateLocalization()
            if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                    self.updateUI()
                })
            }
            else {
                TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                    self.updateUI()
                })
            }
        }
        Log(message: "\(sender.selectedSegmentIndex)")
    }
    /* Dynamic display languages
     func appLanguageChanged(sender: UISegmentedControl) {
     OTTSdk.appManager.configuration(onSuccess: { (config) in
     let selectedLang = config.displayLanguages[sender.selectedSegmentIndex]
     OTTSdk.preferenceManager.selectedDisplayLanguage = selectedLang.code
     Localization.instance.updateLocalization()
     self.updateUI()
     }) { (error) in
     
     }
     print(sender.selectedSegmentIndex)
     }
     */
    
    @objc func signInClicked() {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Sign in")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "SignInVC"
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    
    
    @objc func signUpClicked() {
//        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        storyBoardVC.viewControllerName = "SignUpVC"
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    
    func removeViewIfAlreadyExistsIn(_ view:UITableViewCell) {
        for subView in view.contentView.subviews {
            if subView is UIButton {
                subView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Custom Actions
    @IBAction func DoneClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateUI"), object: nil)
        /* if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide" {
//            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
//
//            })
        }*/
    }
    @IBAction func SignoutButtonClicked(_ sender: Any) {
        self.showLogoutAlertWithText(message: "Are you sure you want to Sign out?")
    }
    
    @objc func editProfileClicked(_ sender: AnyObject) -> Void {
        let acStoryBoard  = UIStoryboard(name: "Account", bundle:nil)
        let detailsVc = acStoryBoard.instantiateViewController(withIdentifier: "AccountDetailsViewController") as! AccountDetailsViewController
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    func GotoBrowserUrl(urlstring : String,PageString:String) -> Void {
        /*
         let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
         let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
         view1.urlString = urlstring
         view1.pageString = PageString as String
         view1.viewControllerName = "AccountViewController"
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(view1, animated: true)
         */
    }
    
    func updateAppLanguageUI(langSegment : UISegmentedControl) {
        langSegment.isHidden = false
        langSegment.viewBorderWidthWithTwo(color: UIColor.init(hexString: "3C3C3C"), isWidthOne: true)
        langSegment.tintColor = AppTheme.instance.currentTheme.navigationViewBarColor
        let segAttributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        langSegment.setTitleTextAttributes((segAttributes as! [NSAttributedString.Key : Any]), for: UIControl.State.selected)
        
        let attributes: NSDictionary = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        langSegment.setTitleTextAttributes((attributes as! [NSAttributedString.Key : Any]), for: UIControl.State.selected)
        
        // Add target action method
        langSegment.addTarget(self, action: #selector(self.appLanguageChanged), for: UIControl.Event.valueChanged)
        langSegment.removeAllSegments()
        
        // switch to selected display language
        var selectedIndex = 0
        for  (index, lang) in Constants.displayLanguages.enumerated(){
            if lang.code == OTTSdk.preferenceManager.selectedDisplayLanguage{
                selectedIndex = index
            }
            langSegment.insertSegment(withTitle: lang.name.localized, at: index, animated: false)
        }
        if Constants.displayLanguages.count > 0{
            langSegment.selectedSegmentIndex = selectedIndex
        }
        /* Dynamic display languages - switch to selected display language
         
         OTTSdk.appManager.configuration(onSuccess: { (config) in
         langSegment.removeAllSegments()
         var selectedIndex = 0
         for  (index, lang) in config.displayLanguages.enumerated(){
         if lang.code == OTTSdk.preferenceManager.selectedDisplayLanguage{
         selectedIndex = index
         }
         langSegment.insertSegment(withTitle: lang.name, at: index, animated: false)
         }
         if config.displayLanguages.count > 0{
         langSegment.selectedSegmentIndex = selectedIndex
         }
         
         }) { (error) in
         langSegment.isHidden = true
         }
         */
    }
    
    @IBAction func ccSwitchClicked(_ sender: UISwitch) {
        let switchUserDefaults = UserDefaults.standard
        if sender.isOn {
            switchUserDefaults.set(true, forKey: "ccStatus")
        } else {
            switchUserDefaults.set(false, forKey: "ccStatus")
        }
        switchUserDefaults.synchronize()
    }
    
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String,Action:Bool) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
}


// MARK: - tableview
extension AccountViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.count > 0{
            if section < sections.count {
                switch sections[section] {
                case .signInSignUp:
                    return AppDelegate.getDelegate().iosAllowSignup ? 2 : 1
                case .other:
                    return titlesArray.count
                default:
                    return 0
                }
            }
            else {
                if self.menuOptionsArray.count > 0 {
                    let indexVal = section - sections.count
                    let menuData = self.menuOptionsArray[indexVal]
                    if self.selectedMenuTargetPath == menuData["menuTargetPath"] as? String {
                        if let subMenus = menuData["subMenus"] as? [[String:Any]] {
                            return subMenus.count
                        }
                        else {
                            return 0
                        }
                    }
                    else {
                        return 0
                    }
                }
                else{
                    return 0
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2" as String)
        
        //configure your cell
        
        let nameLabel = cell?.contentView.viewWithTag(2) as! UILabel
        nameLabel.textColor = UIColor.init(hexString: "444444")
        let ccToggle  = cell?.contentView.viewWithTag(5) as! UISwitch
        let rightArrowIcon  = cell?.contentView.viewWithTag(6) as! UIImageView
        
        nameLabel.font = UIFont.ottMediumFont(withSize: (productType.iPad ? 16 : 16 ))
        let separatorView:UIView = (cell?.contentView.viewWithTag(8)!)!
        separatorView.backgroundColor = UIColor.cellSeperatorBlackColor()
        
        ccToggle.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        let switchUserDefaults = UserDefaults.standard
        if let ccStatus = switchUserDefaults.value(forKey: "ccStatus") as? Bool {
            if ccStatus {
                ccToggle.isOn = true
            } else {
                ccToggle.isOn = false
            }
        } else {
            ccToggle.isOn = false
        }
        ccToggle.isHidden = true
        
        if indexPath.section < sections.count {
            let section = sections[indexPath.section]
            if section == .signInSignUp {
                // Sign in - sign up
                
                self.removeViewIfAlreadyExistsIn(cell!)
                if indexPath.row == 0 {
                    let tempWW = (productType.iPad ? 400 : (AppDelegate.getDelegate().window?.frame.size.width)!)
                    let signInBtn = UIButton.normalButtonWithFrame(withXposition: nameLabel.frame.origin.x, withYposition: 5.0, withWidth: (tempWW - (2 * nameLabel.frame.origin.x)), withHeight: 40.0, withTitle: "Sign-in".localized, withSize: 15.3, isRowBtnType: false)
                    signInBtn.tag = indexPath.row
                    nameLabel.isHidden = true
                    signInBtn.addTarget(self, action: #selector(self.signInClicked), for: UIControl.Event.touchUpInside)
                    signInBtn.cornerDesignWithBorder()
                    cell?.contentView.addSubview(signInBtn)
                }
                else if indexPath.row == 1 {
                    let tempWW = (productType.iPad ? 400 : (AppDelegate.getDelegate().window?.frame.size.width)!)
                    let signUpBtn = UIButton.normalButtonWithFrame(withXposition: nameLabel.frame.origin.x, withYposition: 5.0, withWidth: (tempWW - (2 * nameLabel.frame.origin.x)), withHeight: 40.0, withTitle: "Register".localized, withSize: 15.3, isRowBtnType: true)
                    nameLabel.isHidden = true
                    signUpBtn.tag = indexPath.row
                    signUpBtn.titleLabel?.textColor = UIColor.init(hexString: "4d4d4d")
                    signUpBtn.cornerDesignWithBorder()
                    signUpBtn.addTarget(self, action: #selector(self.signUpClicked), for: UIControl.Event.touchUpInside)
                    cell?.contentView.addSubview(signUpBtn)
                }
            }
            else if section == .other{
                // Others
                let titleEnum = self.titlesArray[indexPath.row]
                /*
                 if titleEnum == .appVersion{
                 let version = Bundle.applicationVersionNumber
                 subTitleLabel.text = "\(version) (\(Bundle.applicationBuildNumber))"
                 subTitleLabel.isHidden = false
                 }*/
                /*if titleEnum == .closedCaption{
                 ccToggle.isHidden = false
                 rightArrowIcon.isHidden = true
                 }*/
                
                /*if titleEnum == .logout {
                 rightArrowIcon.isHidden = true
                 }
                 else {*/
                ccToggle.isHidden = true
                rightArrowIcon.isHidden = false
                //}
                
                nameLabel.text = titleEnum.rawValue.localized
                nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                nameLabel.isHidden = false
                self.removeViewIfAlreadyExistsIn(cell!)
            }
        }
        else {
            // Tabs
            let indexVal = indexPath.section - sections.count
            
            let menuData = self.menuOptionsArray[indexVal]
            if let subMenus = menuData["subMenus"] as? [[String:Any]] {
                let subMenuItem = subMenus[indexPath.row]
                if let title = subMenuItem["displayname"] as? String  {
                    if productType.iPad {
                        nameLabel.text = "          \(title)"
                    }
                    else {
                        nameLabel.text = "      \(title)"
                    }
                    nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                   
                    nameLabel.isHidden = false
                    rightArrowIcon.alpha = 1.0
                    if let isClickable =  subMenuItem["isClickable"] as? Bool{
                        if isClickable == false {
                            nameLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
                            rightArrowIcon.alpha = 0.5
                        }
                    }
                    self.removeViewIfAlreadyExistsIn(cell!)
                }
            }
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height : CGFloat = (productType.iPad ? 80 : 60)
        
        //        let section = sections[indexPath.section]
        //        if section == .other{
        //            let titleEnum = self.titlesArray[indexPath.row]
        //
        ////            if titleEnum == .languages{
        ////                if OTTSdk.preferenceManager.user?.languages != nil{
        ////                    if (OTTSdk.preferenceManager.user?.languages.count)! > 0{
        ////                        height = 50
        ////                    }
        ////                }
        ////            }
        ////            if titleEnum == .appLanguage{
        ////                height = 90
        ////            }
        //        }
        
        return height
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections.count > 0 {
            if section < sections.count {
                let section = sections[section]
                if section == .signInSignUp {
                    if OTTSdk.preferenceManager.user != nil{
                        return 0;
                    }
                }
                else if section == .other {
                    return 0
                }
            }
            else {
                return (productType.iPad ? 80 : 60)
            }
        }
        
        return 0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        if sections.count > 0 {
            if section < sections.count {
                return headerView
            }
            else {
                headerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
                headerView.isUserInteractionEnabled = true
                let indexVal = section - sections.count
                let menuData = self.menuOptionsArray[indexVal]
                headerView.frame.size.height = (productType.iPad ? 80 : 60)
                let sectionLabel =  UILabel.init(frame: CGRect.init(x: 14, y: 0, width: headerView.frame.size.width, height: headerView.frame.size.height))
                sectionLabel.backgroundColor = .clear
                sectionLabel.font = UIFont.ottMediumFont(withSize: (productType.iPad ? 16 : 16 ))
                sectionLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
                if let title = menuData["menuDisplayName"] as? String {
                    sectionLabel.text = title
                }
                else{
                    sectionLabel.text = ""
                }
                
                let arrowImageView = UIImageView.init()
                arrowImageView.contentMode = .scaleAspectFit
                if let menuTargetPath = menuData["menuTargetPath"] as? String {
                    if self.selectedMenuTargetPath == menuTargetPath {
                        arrowImageView.image = UIImage.init(named: "arrow_down")
                        arrowImageView.frame = CGRect.init(x: (headerView.frame.size.width - 32), y: (headerView.frame.size.height - 12) / 2, width: 10, height: 18.5)
                    }
                    else {
                        arrowImageView.image = UIImage.init(named: "right_arrow")
                        arrowImageView.frame = CGRect.init(x: (headerView.frame.size.width - 32), y: (headerView.frame.size.height - 19) / 2, width: 6, height: 11.5)
                    }
                }
                else {
                    arrowImageView.image = UIImage.init(named: "right_arrow")
                    arrowImageView.frame = CGRect.init(x: (headerView.frame.size.width - 32), y: (headerView.frame.size.height - 12) / 2, width: 6, height: 11.5)

                }
                arrowImageView.backgroundColor = .clear

                let bgView = UIView.init()
                bgView.frame = CGRect.init(x: 14, y: (headerView.frame.size.height - 1), width: headerView.frame.size.width - 28, height: 1)
                bgView.backgroundColor = UIColor.cellSeperatorBlackColor()
                headerView.addSubview(bgView)
                headerView.addSubview(arrowImageView)
                headerView.addSubview(sectionLabel)
                let tapGestureRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(headerTapped(_:))
                )
                
                headerView.tag = indexVal
                headerView.addGestureRecognizer(tapGestureRecognizer)
                return headerView
            }
        }
        else {
            return headerView
        }
    }
    @objc func headerTapped(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }
        let menuData = self.menuOptionsArray[section]

        if let menuTargetPath = menuData["menuTargetPath"] as? String {
            if self.selectedMenuTargetPath == menuTargetPath {
                self.selectedMenuTargetPath = ""
                self.accountTable.reloadData()
            }
            else {
                self.selectedMenuTargetPath = menuTargetPath
                self.accountTable.reloadData()
                let indexPath = IndexPath.init(row: 0, section: section + self.sections.count)
                self.accountTable.scrollToRow(at: indexPath, at: .none, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sections.count {
            let section = sections[indexPath.section]
            if section == .other{
                let titleEnum = self.titlesArray[indexPath.row]
                LocalyticsEvent.tagEventWithAttributes("Settings_Page", ["Menu_Name" : titleEnum.rawValue])
                
                switch titleEnum {
                case .watchlist:
                    var menu = [String:Any]()
                    menu["displayname"] = "Favorites"
                    menu["targetPath"] = AppDelegate.getDelegate().favouritesTargetPath
                    self.showHardcodedMenuPage(selectedItem: menu)
                    break;
                case .setup:
                    let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
                    let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "SetupMenuViewController") as! SetupMenuViewController
                    self.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(userProfileVC, animated: true)
                    
                    break;
                case .account:
                    break;
                case .activeStreams:
                    break;
                case .myQuestions:
                    break;
                }
            }
        }
        else {
            let indexVal = indexPath.section - sections.count
            
            let menuData = self.menuOptionsArray[indexVal]
            if let subMenus = menuData["subMenus"] as? [[String:Any]] {
                let subMenuItem = subMenus[indexPath.row]
                if let isClickable =  subMenuItem["isClickable"] as? Bool{
                    if isClickable == true {
                        self.showHardcodedMenuPage(selectedItem: subMenuItem)
                    }
                }
            }
        }
    }
    
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let section = sections[indexPath.section]
     if section == .other{
     
     let titleEnum = self.titlesArray[indexPath.row]
     LocalyticsEvent.tagEventWithAttributes("Settings_Page", ["Menu_Name" : titleEnum.rawValue])
     
     switch titleEnum {
     case .watchlist:
     var menu = [String:Any]()
     menu["menuDisplayName"] = "Favourites"
     menu["menuTargetPath"] = "favourites"
     menu["menucode"] = "favourites"
     self.dismiss(animated: false) {
     TabsViewController.instance.showHardcodedMenuPage(selectedItem: menu)
     }
     break;
     case .setup:
     let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "SetupMenuViewController") as! SetupMenuViewController
     self.navigationController?.isNavigationBarHidden = true
     self.navigationController?.pushViewController(userProfileVC, animated: true)
     
     break;
     case .activeStreams:
     /*let storyBoard = UIStoryboard(name: "Account", bundle: nil)
     let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "UserProfileInfoViewController") as! UserProfileInfoViewController
     let topVC = UIApplication.topVC()!
     topVC.navigationController?.pushViewController(storyBoardVC, animated: true)*/
     
     let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
     let obj = storyBoard.instantiateViewController(withIdentifier: "ActiveStreamsDevicesViewCotroller") as! ActiveStreamsDevicesViewCotroller
     obj.isComingFromPlayerPage = false
     let topVC = UIApplication.topVC()!
     topVC.navigationController?.pushViewController(obj, animated: true)
     
     break;
     case .myQuestions:
     
     let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
     let obj = storyBoard.instantiateViewController(withIdentifier: "MyQuestionsViewController") as! MyQuestionsViewController
     let topVC = UIApplication.topVC()!
     topVC.navigationController?.pushViewController(obj, animated: true)
     
     break;
     
     /*case .help:
     AppDelegate.getDelegate().gotoHelpPage()
     break*/
     //            case .aboutUs:
     //
     //
     //                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     //                let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
     //                if appContants.isBrazilClient {
     //                    view1.urlString = "\(Constants.OTTUrls.aboutUsUrl)?lang_type=\(OTTSdk.preferenceManager.selectedDisplayLanguage!.uppercased())&tenant_code=\(OTTSdk.preferenceManager.tenantCode)"
     //                } else {
     //                    view1.urlString = Constants.OTTUrls.aboutUsUrl
     //                }
     //
     //                view1.pageString = "About us".localized
     //                view1.viewControllerName = "AccountViewController"
     //                self.navigationController?.isNavigationBarHidden = true
     //                self.navigationController?.pushViewController(view1, animated: true)
     //
     //                break
     //
     //            case .languages:
     //                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
     //                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
     //                storyBoardVC.fromPage = false
     //                storyBoardVC.Signup_Process = false
     //                storyBoardVC.viewControllerName = "AccountViewController"
     //                self.navigationController?.pushViewController(storyBoardVC, animated: true)
     //                break
     //            case .privacyPolicy:
     //                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     //                let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
     //                if appContants.isBrazilClient {
     //                    view1.urlString = "\(Constants.OTTUrls.privacyPolicyUrl)?lang_type=\(OTTSdk.preferenceManager.selectedDisplayLanguage!.uppercased())&tenant_code=\(OTTSdk.preferenceManager.tenantCode)"
     //                } else {
     //                    view1.urlString = Constants.OTTUrls.privacyPolicyUrl
     //                }
     //
     //                view1.pageString = "Privacy Policy".localized
     //                view1.viewControllerName = "AccountViewController"
     //                self.navigationController?.isNavigationBarHidden = true
     //                self.navigationController?.pushViewController(view1, animated: true)
     //                break
     //
     //            case .terms:
     //                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     //                let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
     //                if appContants.isBrazilClient {
     //                    view1.urlString = "\(Constants.OTTUrls.termsUrl)?lang_type=\(OTTSdk.preferenceManager.selectedDisplayLanguage!.uppercased())&tenant_code=\(OTTSdk.preferenceManager.tenantCode)"
     //                } else {
     //                    view1.urlString = Constants.OTTUrls.termsUrl
     //                }
     //
     //                view1.pageString = "Terms & Conditions".localized
     //                view1.viewControllerName = "AccountViewController"
     //                self.navigationController?.isNavigationBarHidden = true
     //                self.navigationController?.pushViewController(view1, animated: true)
     //                break
     //            case .faqs:
     //                let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
     //                let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
     //                if appContants.isBrazilClient {
     //                    view1.urlString = "\(Constants.OTTUrls.faqsUrl)?lang_type=\(OTTSdk.preferenceManager.selectedDisplayLanguage!.uppercased())&tenant_code=\(OTTSdk.preferenceManager.tenantCode)"
     //                } else {
     //                    view1.urlString = Constants.OTTUrls.faqsUrl
     //                }
     //
     //                view1.pageString = "FAQ's".localized
     //                view1.viewControllerName = "AccountViewController"
     //                self.navigationController?.isNavigationBarHidden = true
     //                self.navigationController?.pushViewController(view1, animated: true)
     //                break
     //            case .favorites:
     //                if OTTSdk.preferenceManager.user == nil {
     //                    let defaultVC = TargetPage.defaultViewController()
     //                    defaultVC.isFavView = true
     //                    defaultVC.isMyLibraryView = false
     //                    self.navigationController?.isNavigationBarHidden = true
     //                    self.navigationController?.pushViewController(defaultVC, animated: true)
     //                } else {
     //                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (result) in
     //                        self.navigationController?.pushViewController(FavouritesListViewController.instance, animated: true)
     //                    })
     //
     //                }
     //
     //                break
     //            case .logout:
     //                self.showLogoutAlertWithText(message: "Are you sure you want to Log out?")
     //                break
     
     
     
     default:
     break
     }
     }
     else if section == .menu{
     /*let scrollIndex = IndexPath(row: indexPath.row, section: 0)
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
     TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
     }
     
     let menu = TabsViewController.instance.menus[indexPath.row]
     TabsViewController.instance.showComponent(menu: menu)*/
     
     let menu = self.menuOptionsArray[indexPath.row]
     if let isClickable =  menu["isClickable"] as? Bool{
     if isClickable == true {
     self.showHardcodedMenuPage(selectedItem: menu)
     }
     }
     }
     }
     */
}
extension AccountViewController {
    func showHardcodedMenuPage(selectedItem: [String:Any]) {
        var displayText = ""
        var targetPath = ""
        //        var code = ""
        if let _displayText = selectedItem["displayname"] as? String {
            displayText = _displayText
        }
        if let _targetPath = selectedItem["targetPath"] as? String {
            targetPath = _targetPath
        }
        
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path:selectedItem["targetPath"] as! String) { (viewController, pageType) in
            if let vc = viewController as? ContentViewController{
                //self.pageContentResponse = vc.pageContentResponse
                vc.isToViewMore = true
                vc.targetedMenu = targetPath
                vc.sectionTitle = displayText
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if let vc = viewController as? PlayerViewController{
                vc.delegate = self
                AppDelegate.getDelegate().window?.addSubview(vc.view)
            }
            else if let vc = viewController as? DetailsViewController {
                vc.navigationTitlteTxt = displayText
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(vc, animated: true)
                 
            }
            else if (viewController is DefaultViewController){
                let defaultViewController = viewController as! DefaultViewController
                defaultViewController.delegate = self
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)
                 
            }
            else{
                if let vc = viewController as? ListViewController{
                    vc.isToViewMore = true
                    vc.sectionTitle = displayText
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(vc, animated: true)
                     
                }
                else {
                    let topVC = UIApplication.topVC()!
                    topVC.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            self.stopAnimating()
        }
    }
    func showLogoutAlertWithText (_ header : String = "Confirm".localized, message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let resumeAlertAction = UIAlertAction(title: "No".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        let startOverAlertAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.LogOutClicked()
        })
        alert.addAction(resumeAlertAction)
        alert.addAction(startOverAlertAction)
        //        alert.view.tintColor = UIColor.redColor()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - PlayerViewControllerDelegate Methods
    func record(confirm : Bool, content : Any?){
        if confirm{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: TVGuideCollectionCollectionViewController.reloadNotificationName), object: nil)
        }
    }
    func didSelectedSuggestion(card: Card) {
        
    }
    func didSelected(card: Card?, content: Any?, templateElement: TemplateElement?) {
        
    }
    // MARK: - DefaultViewControllerDelegate
    func retryTap(){
        
    }
}
