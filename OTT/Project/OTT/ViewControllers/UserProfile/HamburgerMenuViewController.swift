//
//  HamburgerMenuViewController.swift
//  YUPPTV
//
//  Created by Ankoos on 19/09/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class HamburgerMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,iShowcaseDelegate {
    
    enum TitlesEnum : String {
/*       Viusasa
         case appLanguage = "app Language"
        case aboutUs = "About us"
        case languages = "Language"
        case help = "Help" */
        
        /* T-SAT */
        case myDownloads = "My Downloads"
        case favourites = "Favorites"
        case aboutUs = "About us"
        case videoQuality = "Video Quality"
        case help = "Help"
        case rateApp = "Rate App"
        case shareApp = "Share App"
        case feedback = "Feedback"
        case waysToWatch = "Ways to watch"
        case whyUs = "Why us"
        case faqs = "FAQ's"
        case contactUs = "Contact Us"
        case piracyPolicy = "Piracy policy"
        
    }
    enum Sections{
        case signInSignUp
        case menu
        case other
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var accountTable: UITableView!
    @IBOutlet weak var navigationView : UIView!
    var titlesArray = [TitlesEnum]()
    var userInfoDict = NSDictionary()
    var sections = [Sections]()
    var footer = UIView()
//    var safeAreaHeight: CGFloat {
//        if #available(iOS 11, *) {
//            return self.view.safeAreaInsets.top
//        }
//        return self.topLayoutGuide.length
//    }
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
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.getDelegate().taggedScreen = "Hamburger"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        setNeedsStatusBarAppearanceUpdate()
        self.accountTable.backgroundColor = .clear
//        self.accountTable.backgroundColor = UIColor.init(red: 28.0/255.0, green: 29.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = true
        self.doneButton.setTitle("Done".localized, for: UIControl.State.normal)
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
        updateUser()
//        Log(message: "\(safeAreaHeight)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if OTTSdk.preferenceManager.user != nil, appContants.appName != .tsat {
            
            self.footer = UIView.init(frame: CGRect(x: 0, y: 0, width: self.accountTable.frame.size.width, height: 90))
            
            let but = UIButton.init(frame: CGRect(x: 0, y: 50, width: 160.0, height: 54))
            but.setTitle("Sign Out".localized, for: UIControl.State.normal)
            but.center = footer.center
            but.setTitleColor(UIColor.white, for: UIControl.State.normal)
            but.addTarget(self, action: #selector(self.showLogoutPopup), for: UIControl.Event.touchUpInside)
            but.backgroundColor = UIColor.init(red: 48.0/255.0, green: 49.0/255.0, blue: 53.0/255.0, alpha: 1.0)
            but.cornerDesign()
            footer.addSubview(but)
            self.footer.isHidden = true
            accountTable.tableFooterView = footer
        }
    }

    @objc func showLogoutPopup() {
        self.showLogoutAlertWithText(message: "Are you sure you want to Log out?")
    }
    
    @objc func LogOutClicked() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: true)
        OTTSdk.userManager.signOut(onSuccess: { (result) in
            print(result)
            deleteUserConsentOnAgeAndDob()
            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                self.stopAnimating()
                if #available(iOS 11.0, *) {
                    //AppDelegate.getDelegate().deleteAllData()
                }
                GIDSignIn.sharedInstance().signOut()
//                let loginView : FBSDKLoginManager = FBSDKLoginManager()
//                loginView.logOut()
//                loginView.loginBehavior = FBSDKLoginBehavior.web
//                loginView.logOut()
                self.updateUser()
                self.accountTable.reloadData()
                self.accountTable.tableFooterView = nil
            })
            playerVC?.removeViews()
            playerVC = nil
        }) { (error) in
            self.stopAnimating()
            print(error.message)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.accountTable.reloadData()
    }
    // MARK: - Custom Methods

    func updateUI(){
        stopAnimating()
        doneButton.setTitle("Done".localized, for: .normal)
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
        
        self.startAnimating(allowInteraction: true)
        self.accountTable.isHidden = true
        OTTSdk.userManager.userInfo(onSuccess: { (response) in
            self.accountTable.isHidden = false
            print(response)
            self.stopAnimating()
            self.titlesArray = self.formTitleArray()
            self.accountTable.reloadData()
            self.viewDidLayoutSubviews()
            if OTTSdk.preferenceManager.user == nil {
                GIDSignIn.sharedInstance().signOut()
//                FBSDKLoginManager.init().logOut()
            }
            
        }) { (error) in
            self.accountTable.isHidden = false
            print(error.message)
            self.titlesArray = self.formTitleArray()
            if OTTSdk.preferenceManager.user == nil {
                self.accountTable.tableFooterView = nil
                GIDSignIn.sharedInstance().signOut()
//                FBSDKLoginManager.init().logOut()
            }
            self.accountTable.reloadData()
            self.stopAnimating()
        }
    }
    
    func formTitleArray() -> [TitlesEnum]{
        var titles = [TitlesEnum]()
        
        if OTTSdk.preferenceManager.user == nil, appContants.appName != .tsat {
            sections = [.signInSignUp, .other] //, .menu
        }
        else {
            sections = [.other]//.menu
        }
        titles.append(.myDownloads)
        titles.append(.favourites)
        titles.append(.aboutUs)
        titles.append(.videoQuality)
        titles.append(.contactUs)
        //        titles.append(.help)
        titles.append(.rateApp)
        titles.append(.shareApp)
        titles.append(.feedback)
        titles.append(.whyUs)
        titles.append(.faqs)
        titles.append(.piracyPolicy)
        titles.append(.waysToWatch)
        if appContants.appName == .aastha {
            titles.removeAll()
            titles.append(.favourites)
            titles.append(.aboutUs)
            titles.append(.help)
        }else if appContants.appName == .gac {
            titles.removeAll()
            titles.append(.favourites)
            titles.append(.aboutUs)
            titles.append(.help)
        }else if appContants.appName == .tsat {
            titles.removeAll()
            titles.append(.aboutUs)
            titles.append(.contactUs)
            titles.append(.rateApp)
        }
        return titles
    }
    
    func appLanguageChanged(sender: UISegmentedControl) {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), Action: false)
            return
        }
        let selectedLang = Constants.displayLanguages[sender.selectedSegmentIndex]
        startAnimating(allowInteraction: false)
        OTTSdk.userManager.sessionPreference(displayLangCode: selectedLang.code, onSuccess: { (response) in
            Localization.instance.updateLocalization()
            TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                self.updateUI()
            })
        }) { (error) in
            Localization.instance.updateLocalization()
            self.updateUI()
        }
        print(sender.selectedSegmentIndex)
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
        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Sign in")
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "SignInVC"
        let topVC = UIApplication.topVC()!
        topVC.navigationController?.pushViewController(storyBoardVC, animated: true)
    }

    
    @objc func signUpClicked() {
        LocalyticsEvent.tagEvent("\(AppDelegate.getDelegate().taggedScreen)>Register")
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
        TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
        })
    }
    
    @objc func editProfileClicked(_ sender: AnyObject) -> Void {
        let acStoryBoard  = UIStoryboard(name: "Account", bundle:nil)
        let detailsVc = acStoryBoard.instantiateViewController(withIdentifier: "AccountDetailsViewController") as! AccountDetailsViewController
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    
    func openUrl(title : String, url : String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
        view1.urlString = url
        view1.pageString = title
        view1.viewControllerName = "HamburgerMenuViewController"
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(view1, animated: true)
    }
   /*
    func updateAppLanguageUI(langSegment : UISegmentedControl) {
        langSegment.isHidden = false
        
        // Style the Segmented Control
        langSegment.layer.cornerRadius = 5.0  // Don't let background bleed
        langSegment.tintColor = UIColor(red: 227.0/255.0, green: 6.0/255.0, blue: 19.0/255.0, alpha: 1)
        langSegment.layer.borderColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1).cgColor
        langSegment.layer.borderWidth = 1.0
        langSegment.layer.masksToBounds = true
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        langSegment.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], for: UIControlState.selected)
        
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        langSegment.setTitleTextAttributes(attributes as [NSObject : AnyObject], for: UIControlState.normal)
        
        // Add target action method
        langSegment.addTarget(self, action: #selector(self.appLanguageChanged), for: UIControlEvents.valueChanged)
        langSegment.removeAllSegments()
        
        // switch to selected display language
        var selectedIndex = 0
        for  (index, lang) in Constants.displayLanguages.enumerated(){
            if lang.code == OTTSdk.preferenceManager.selectedDisplayLanguage{
                selectedIndex = index
            }
            langSegment.insertSegment(withTitle: lang.name, at: index, animated: false)
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
    } */
    
    // MARK: -  showAlertWithText popup
    func showAlertWithText (_ header : String = String.getAppName(), message : String,Action:Bool) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showLogoutAlertWithText (_ header : String = "Confirm".localized, message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
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

}
// MARK: - tableview
extension HamburgerMenuViewController
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .signInSignUp:
            return 2
        case .menu:
            return TabsViewController.instance.menus.count
        case .other:
            if appContants.appName == .aastha || appContants.appName == .gac || appContants.appName == .tsat {
                return titlesArray.count
            }
            return 6
        default:
            return 0
        }
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2" as String)
        
        //configure your cell
        
        let nameLabel = cell?.contentView.viewWithTag(2) as! UILabel
        nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        let subTitleLabel  = cell?.contentView.viewWithTag(3) as! UILabel
//        let langSegment  = cell?.contentView.viewWithTag(4) as! UISegmentedControl
        subTitleLabel.isHidden = true
//        langSegment.isHidden = true
        let lineView = cell?.contentView.viewWithTag(5) as! UIView
        lineView.isHidden = false
        let section = sections[indexPath.section]
        if section == .signInSignUp{
            // Sign in - sign up
            self.removeViewIfAlreadyExistsIn(cell!)
            if indexPath.row == 0 {
                lineView.isHidden = true
                let signInBtn = UIButton.normalButtonWithFrame(withXposition: nameLabel.frame.origin.x, withYposition: 5.0, withWidth: ((cell?.frame.size.width)! - (2 * nameLabel.frame.origin.x)), withHeight: 40.0, withTitle: "Sign-in".localized, withSize: 15.3, isRowBtnType: false)
                signInBtn.tag = indexPath.row
                nameLabel.isHidden = true
                signInBtn.addTarget(self, action: #selector(self.signInClicked), for: UIControl.Event.touchUpInside)
                signInBtn.viewCornerDesign()
                cell?.contentView.addSubview(signInBtn)
            }
            else if indexPath.row == 1 {
                let signUpBtn = UIButton.normalButtonWithFrame(withXposition: nameLabel.frame.origin.x, withYposition: 5.0, withWidth: ((cell?.frame.size.width)! - (2 * nameLabel.frame.origin.x)), withHeight: 40.0, withTitle: "Register".localized, withSize: 15.3, isRowBtnType: true)
                nameLabel.isHidden = true
                signUpBtn.tag = indexPath.row
                signUpBtn.viewCornerDesign()
                signUpBtn.addTarget(self, action: #selector(self.signUpClicked), for: UIControl.Event.touchUpInside)
                cell?.contentView.addSubview(signUpBtn)
            }
            cell?.accessoryType = .none
        }
        else if section == .menu{
            // Tabs
            let tab = TabsViewController.instance.menus[indexPath.row]
            nameLabel.text = tab.displayText
            cell?.accessoryType = .none

        }
        else if section == .other{
            // Others
            let titleEnum = self.titlesArray[indexPath.row]
            /*
            if titleEnum == .appVersion{
                let version = Bundle.applicationVersionNumber
                subTitleLabel.text = "\(version) (\(Bundle.applicationBuildNumber))"
                subTitleLabel.isHidden = false
            }
            else*/
//            if titleEnum == .languages{
//                if OTTSdk.preferenceManager.selectedLanguages != "all"{
//                    subTitleLabel.text = OTTSdk.preferenceManager.selectedLanguages
//                    subTitleLabel.isHidden = false
//                }
//            }
//            if titleEnum == .appLanguage{
//                self.updateAppLanguageUI(langSegment: langSegment)
//            }
            
            nameLabel.text = titleEnum.rawValue.localized
            nameLabel.isHidden = false
            self.removeViewIfAlreadyExistsIn(cell!)
//            cell?.accessoryType = .disclosureIndicator
            cell?.accessoryType = .none
        }
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        cell?.contentView.backgroundColor = .clear
        return cell!
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height : CGFloat = 50
        /*
        let section = sections[indexPath.section]
        if section == .other{
            let titleEnum = self.titlesArray[indexPath.row]

//            if titleEnum == .languages{
//                if OTTSdk.preferenceManager.user?.languages != nil{
//                    if (OTTSdk.preferenceManager.user?.languages.characters.count)! > 0{
//                        height = 68
//                    }
//                }
//            }
            if titleEnum == .appLanguage{
                height = 90
            }
        }
       */
        return height
        
    }
    @objc(tableView:heightForHeaderInSection:) func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if OTTSdk.preferenceManager.user != nil, appContants.appName != .tsat{
                return 100;
            }
        }
        return 0;
    }
    
    @objc(tableView: viewForHeaderInSection:)  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 || (OTTSdk.preferenceManager.user == nil){
            return nil;
        }
        if OTTSdk.preferenceManager.user == nil
        {
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return headerView
        }
        else
        {
            let rect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100)
            let headerView = UIView.init(frame: rect)

            let roundLabel = UILabel.init(frame: CGRect(x: 19, y: 20, width: 63, height: 63))
            let editBut:UIButton = UIButton.init(frame: rect)
            
            let emailLabel =  UILabel.init(frame: CGRect(x: 97, y: 34, width: tableView.bounds.size.width - 147, height: 16))
            //edit icon
            editBut.addTarget(self, action: #selector(HamburgerMenuViewController.editProfileClicked(_:)), for: UIControl.Event.touchUpInside)
            emailLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
            emailLabel.font = UIFont.ottRegularFont(withSize: 15.3)
            emailLabel.font = UIFont.systemFont(ofSize: 15.3)
            
            let nameLabel = UILabel(frame: CGRect(x: 97, y: 55, width: 175, height: 18))
            nameLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
            nameLabel.font = UIFont.ottRegularFont(withSize: 12.0)
            headerView.addSubview(nameLabel)
            headerView.addSubview(emailLabel)
            headerView.addSubview(roundLabel)
            headerView.addSubview(editBut)
            /*
            if !(OTTSdk.preferenceManager.user?.email .isEmpty)! {
                nameLabel.text =  OTTSdk.preferenceManager.user?.email
            }*/
            roundLabel.textColor = UIColor.black
            if #available(iOS 8.2, *) {
                roundLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
            } else {
                roundLabel.font = UIFont.systemFont(ofSize: 17)
            }
            roundLabel.layer.cornerRadius = roundLabel.frame.width/2
            roundLabel.layer.borderWidth = 1
            roundLabel.layer.masksToBounds = true
            roundLabel.layer.borderColor = UIColor.black.cgColor
            roundLabel.backgroundColor = UIColor.init(red: 158.0/255.0, green: 162.0/255.0, blue: 172.0/255.0, alpha: 1.0)
            /*
            if !(OTTSdk.preferenceManager.user?.name .isEmpty)! {
                emailLabel.text = OTTSdk.preferenceManager.user?.name
            }*/
            headerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
            let borderView = UIView.init(frame: CGRect(x: 0, y: headerView.frame.size.height - 1, width: headerView.frame.size.width, height: 1))
            borderView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            headerView.addSubview(borderView)
            
            emailLabel.text = ""
            nameLabel.text =  ""
            var valuesArray = [String]()
            if OTTSdk.preferenceManager.user != nil{
                if (OTTSdk.preferenceManager.user?.name.count)! > 0{
                    valuesArray.append((OTTSdk.preferenceManager.user?.name)!)
                }
                if (OTTSdk.preferenceManager.user?.email.count)! > 0{
                    valuesArray.append(( OTTSdk.preferenceManager.user?.email)!)
                }
                if (OTTSdk.preferenceManager.user?.phoneNumber.count)! > 0{
                    valuesArray.append((OTTSdk.preferenceManager.user?.phoneNumber)!)
                }
            }
            
            if valuesArray.count > 1{
                emailLabel.text = valuesArray.first
                nameLabel.text =  valuesArray[1]
            }
            else if valuesArray.count == 1{
                emailLabel.text = valuesArray.first
                emailLabel.center = CGPoint(x: emailLabel.center.x, y: roundLabel.center.y)
            }
            
            if valuesArray.count > 0{
                let nameChars  = valuesArray.first?.replacingOccurrences(of: " ", with: ",")
                let charsArry = nameChars?.components(separatedBy: ",")
                var arr = String()
                for char in charsArry! {
                    let splittedStr = char.first
                    arr.append(splittedStr!)
                }
                roundLabel.textAlignment = .center
                roundLabel.text = arr.uppercased()
            }
            
            let showcase = iShowcase()
            showcase.delegate = self
            showcase.setupShowcaseForView(headerView)
            showcase.titleLabel.text = "Manage account settings. View active packages, and transaction history"
            showcase.type = iShowcase.TYPE(rawValue: 1)
//            showcase.show()
            return headerView
        }
        
        
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = sections[indexPath.section]
        
        if section == .other{
            let titleEnum = self.titlesArray[indexPath.row]
            
            switch titleEnum {
                
            case .aboutUs:
                self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.aboutUsUrl ?? "")
                break
            case .favourites:
                if OTTSdk.preferenceManager.user != nil {
                    FavouritesListViewController.instance.getUserFavoritesList(isFinished: { (result) in
                        self.navigationController?.pushViewController(FavouritesListViewController.instance, animated: true)
                    })
                }
                else {
                    self.showAlertWithText(message: "Please sign in to view your favorite videos", Action: true)
                }
                break
            case .myDownloads:
                if OTTSdk.preferenceManager.user != nil {
                    let listVC = TargetPage.moviesViewController()
                    listVC.isToViewMore = true
                    listVC.sectionTitle = "My Downloads"
                    listVC.isMyDownloadsSection = true
                    self.navigationController?.pushViewController(listVC, animated: true)
                }
                else {
                    self.showAlertWithText(message: "Please sign in to view your Downloads", Action: true)
                }
                break
            case .help:
                let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "HelpOptionsViewController") as! HelpOptionsViewController
                self.navigationController?.pushViewController(storyBoardVC, animated: true)
                break
                
            case .shareApp:
                let objectsToShare = ["Let me recommend you this application\n",Constants.OTTUrls.appStoreLink] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.stopAnimating()
                if productType.iPad {
                    activityVC.popoverPresentationController?.sourceView = self.view
                    activityVC.popoverPresentationController?.sourceRect = tableView.cellForRow(at: indexPath)!.frame
                    
                    self.present(activityVC, animated: true, completion: nil)
                }
                else {
                    self.present(activityVC, animated: true, completion: nil)
                }
                break
            case .rateApp:
                self.goToAppStoreApp()
                break
            case .feedback:
                self.goToAppStoreApp()
                break
            case .contactUs:
                self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.contactUsUrl ?? "")
                
                break
                /*
                 case .waysToWatch:
                 self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.waysToWatchLink)
                 break
                 case .whyUs:
                 self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.whyusLink)
                 
                 break
                 case .faqs:
                 self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.faqsLink)
                 
                 break
                 case .piracyPolicy:
                 self.openUrl(title: titleEnum.rawValue, url: Constants.OTTUrls.piracyPolicyLink)
                 
                 break*/
                
                
                /*
                 case .languages:
                 let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                 let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
                 storyBoardVC.fromPage = false
                 storyBoardVC.Signup_Process = false
                 storyBoardVC.viewControllerName = "HamburgerMenuViewController"
                 self.navigationController?.pushViewController(storyBoardVC, animated: true)
                 break
                 */
                
            default:
                break
            }
        }
        else if section == .menu{
            let scrollIndex = IndexPath(row: indexPath.row, section: 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                TabsViewController.instance.HomeToolBarCollection.selectItem(at: scrollIndex, animated: false, scrollPosition: UICollectionView.ScrollPosition.right)
            }
            
            let menu = TabsViewController.instance.menus[indexPath.row]
            TabsViewController.instance.showComponent(menu: menu)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                self.footer.isHidden = false
            }
        }
    }
    
    func goToAppStoreApp()  {
        let urlStr = Constants.OTTUrls.appStoreLink
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
    }
    
   
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
