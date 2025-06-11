//
//  NewRegisterController.swift
//  OTT
//
//  Created by Pramodkumar on 03/09/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import SafariServices
class NewAccountController: UIViewController {
    
    
    @IBOutlet weak var navigationView : UIView!
    @IBOutlet weak var signOutButton : UIButton!
    @IBOutlet weak var registerTableView : UITableView!
    @IBOutlet weak var signOutHeightConstriant : NSLayoutConstraint!
    @IBOutlet weak var mainStackview : UIStackView!
    @IBOutlet var withOutSignInView : UIView!
    @IBOutlet var withSignInView : UIView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var shortNameLbl : UILabel!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var myAccountButton : UIButton!
    @IBOutlet weak var myAccountButtonWidthConstriant : NSLayoutConstraint!
    @IBOutlet weak var signInSignUpLbl : UILabel!
    @IBOutlet weak var arrowIcon : UIImageView!
    @IBOutlet weak var userAvatarIcon : UIImageView?
    private var isBottomScroll = false
    enum Items : String {
        case languages = "Languages"
        case pricing = "Pricing"
        case help = "Help & Support"
        case peotvhelp = "PEOTVGO Help Center"
        case watchlist = "My Watchlist"
        case myfavourites = "My Favorites"
        case purchasedItems = "Purchased Items"
        case account = "My Account"
        case profile = "Profile Information"
        case changePlan = "Change Plan"
        case mydownloads = "My Downloads"
        case videoquality = "Video Quality"
        case favourites = "Favorites"
        case aboutUs = "About us"
        case terms = "Terms of Use"
        case privacy = "Privacy Policy"
        case cookies = "Cookies"
        case appLanguages = "App Languages"
        case contentRedressal = "Grievance Redressal Mechanism"
        case complianceReport = "Compliance Report"
    }
    var listItems = [Items]()
    var safariVC: SFSafariViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
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
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
        signOutButton.setTitleColor(AppTheme.instance.currentTheme.navigationBarTextColor, for: .normal)
        if appContants.appName == .gac {
            signOutButton.backgroundColor = AppTheme.instance.currentTheme.langSelBorder
        }
        else {
            signOutButton.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }
        signOutButton.buttonCornerDesignWithBorder(appContants.appName == .aastha ? .clear : AppTheme.instance.currentTheme.cardSubtitleColor, borderWidth: 1.0)
        signOutButton.buttonCornerDesignWithBorder(appContants.appName == .gac ? .clear : AppTheme.instance.currentTheme.cardSubtitleColor, borderWidth: 1.0)
        AppDelegate.getDelegate().taggedScreen = "Settings"
        LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
        navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        updateUI()
        signInSignUpLbl.text = AppDelegate.getDelegate().iosAllowSignup ? "Sign in / Sign up" : "Sign in"
    }
    private func updateUI(){
        //        stopAnimating()
        userNameLbl.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        userNameLbl.font = UIFont.ottRegularFont(withSize: 14)
        shortNameLbl.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        shortNameLbl.font = UIFont.ottRegularFont(withSize: 14)
        shortNameLbl.changeBorder(color: shortNameLblBorderColor())
        shortNameLbl.backgroundColor = shortNameLblBGColor()
        
        mainStackview.removeArrangedSubview(withSignInView)
        mainStackview.removeArrangedSubview(withOutSignInView)
        withOutSignInView.removeFromSuperview()
        withSignInView.removeFromSuperview()
        listItems.removeAll()
        listItems.append(.languages)
        if OTTSdk.preferenceManager.user != nil {
            mainStackview.addArrangedSubview(withSignInView)
            if appContants.appName == .reeldrama {
                listItems.insert(.watchlist, at: 0)
                listItems.insert(.purchasedItems, at: 1)
                listItems.insert(.mydownloads, at: 2)
                listItems.insert(.account, at: 3)
                listItems.insert(.videoquality, at: 4)
                listItems.append(.profile)
                myAccountButton.isHidden = true
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .firstshows {
                listItems.insert(.purchasedItems, at: 0)
//                listItems.insert(.videoquality, at: 1)
                myAccountButton.isHidden = false
                arrowIcon.isHidden = false
                myAccountButtonWidthConstriant.constant = self.view.frame.size.width
            }
            else if appContants.appName == .tsat {
                listItems.insert(.mydownloads, at: 0)
                listItems.insert(.videoquality, at: 1)
                listItems.insert(.account, at: 2)
                listItems.append(.profile)
                myAccountButton.isHidden = true
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .aastha  {
                listItems.insert(.mydownloads, at: 0)
                listItems.insert(.videoquality, at: 1)
                listItems.insert(.account, at: 2)
                listItems.append(.profile)
                myAccountButton.isHidden = true
                arrowIcon.isHidden = true
                listItems.append(.aboutUs)
            }else if appContants.appName == .gotv {
                listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 1)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .yvs {
                listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 1)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .supposetv {
                listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 1)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .mobitel {
                //listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 0)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .pbns {
                listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 1)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .airtelSL {
                listItems.insert(.videoquality, at: 0)
                listItems.insert(.account, at: 1)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            else if appContants.appName == .gac {
                listItems.insert(.myfavourites, at: 0)
                listItems.append(.videoquality)
                listItems.append(.account)
                listItems.append(.profile)
                listItems = listItems.filter({$0 != .languages})
                listItems.append(.aboutUs)
                arrowIcon.isHidden = true
            }
            if (OTTSdk.preferenceManager.user?.firstName.count)! > 0 {
                let tempStr = ((OTTSdk.preferenceManager.user?.firstName)!) + " " + ((OTTSdk.preferenceManager.user?.lastName)!)
                userNameLbl.text = tempStr
            }else if (OTTSdk.preferenceManager.user?.name.count)! > 0{
                userNameLbl.text = (OTTSdk.preferenceManager.user?.name)!
            }
            else{
                userNameLbl.text = OTTSdk.preferenceManager.user?.email ?? ""
            }
            
            let nameChars  = userNameLbl.text?.replacingOccurrences(of: " ", with: ",")
            let charsArry = nameChars?.components(separatedBy: ",")
            var arr = String()
            for char in charsArry! {
                if char.count > 0 {
                    let splittedStr = char.first
                    arr.append(splittedStr!)
                }
            }
            shortNameLbl.text = arr.uppercased()
            signOutButton.isHidden = false
            signOutHeightConstriant.constant = 44
        }else {
            if appContants.appName == .tsat {
                listItems.insert(.mydownloads, at: 0)
                listItems.insert(.videoquality, at: 1)
                myAccountButton.isHidden = false
                arrowIcon.isHidden = false
                myAccountButtonWidthConstriant.constant = self.view.frame.size.width
            }else if appContants.appName == .aastha || appContants.appName == .gac {
                listItems.insert(.videoquality, at: 0)
                listItems.append(.aboutUs)
            }else if appContants.appName == .gotv {
                listItems = listItems.filter({$0 != .languages})
            }else if appContants.appName == .yvs {
                listItems = listItems.filter({$0 != .languages})
            }else if appContants.appName == .supposetv {
                listItems = listItems.filter({$0 != .languages})
            }else if appContants.appName == .mobitel {
                listItems = listItems.filter({$0 != .languages})
            }else if appContants.appName == .pbns {
                listItems = listItems.filter({$0 != .languages})
            }else if appContants.appName == .airtelSL {
                listItems = listItems.filter({$0 != .languages})
            }
            signOutButton.isHidden = true
            signOutHeightConstriant.constant = 0
            mainStackview.addArrangedSubview(withOutSignInView)
//            listItems.append(.pricing)
        }
        if appContants.appName == .aastha || appContants.appName == .tsat || appContants.appName == .gac {
            listItems = listItems.filter({$0 != .languages})
        }
        
        
        if appContants.appName == .mobitel {
            listItems.append(.peotvhelp)
        }
        else {
            listItems.append(.help)
        }
        
        if appContants.appName == .reeldrama {
            listItems.append(.terms)
            listItems.append(.privacy)
            listItems.append(.cookies)
            listItems.append(.contentRedressal)
            listItems.append(.complianceReport)
        }
        
        //        listItems = Array(Set(listItems))
        registerTableView.reloadData()
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
    }
    private func shortNameLblBorderColor() -> UIColor {
        switch appContants.appName {
        case .supposetv:
            return AppTheme.instance.currentTheme.themeColor
        case .yvs:
            return AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50
        default:
            return AppTheme.instance.currentTheme.buttonsAndHeaderLblColorWhite50
        }
    }
    
    private func shortNameLblBGColor() -> UIColor {
        switch appContants.appName {
        case .supposetv:
            return AppTheme.instance.currentTheme.shortNameBackgroundColor
        case .yvs:
            return AppTheme.instance.currentTheme.navigationViewBarColor
        default:
            return AppTheme.instance.currentTheme.navigationViewBarColor
        }
    }
    
    private func updateTable() {
        if UIScreen.main.bounds.size.height <= 568.0 && ((UserDefaults.standard.value(forKey: "SCROLL_TOP") as? String) == nil || (UserDefaults.standard.value(forKey: "SCROLL_TOP") as? String) == "false"){
            self.registerTableView.scrollToRow(at: IndexPath(row: self.listItems.count - 1, section: 0), at: .bottom, animated: true)
            UserDefaults.standard.set("true", forKey: "SCROLL_TOP")
            UserDefaults.standard.synchronize()
            self.perform(#selector(scrollTop), with: nil, afterDelay: 0.5)
        }
    }
    @objc private func scrollTop() {
        self.registerTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    private func updateUser(){
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            updateUI()
            errorAlert(forTitle: String.getAppName(), message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), needAction: false) { (flag) in }
            return
        }
        self.startAnimating(allowInteraction: false)
        let group = DispatchGroup()
        group.enter()
        getMyUserDetails()
        group.leave()
        group.notify(queue: .main) {
            self.stopAnimating()
        }
    }
    private func getMyUserDetails() {
        OTTSdk.userManager.userInfo(onSuccess: { (response) in
            self.stopAnimating()
            self.updateUI()
            if !self.isBottomScroll {
                self.isBottomScroll = true
                self.updateTable()
            }
        }) { (error) in
            self.updateUI()
            if !self.isBottomScroll {
                self.isBottomScroll = true
                self.updateTable()
            }
            self.stopAnimating()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUser()
        if #available(iOS 11.0, *) {
            AppDelegate.getDelegate().deleteContentAfterExpiryTimeReached()
        }
        if appContants.appName == .gac {
            UIApplication.shared.statusBarView?.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.getDelegate().removeStatusBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
        AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: true)
    }
    @IBAction func backAction(_ sender : Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func MyAccountButtonClicked(_ sender : Any) {
        if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gotv || appContants.appName == .yvs || appContants.appName == .supposetv || appContants.appName == .pbns || appContants.appName == .airtelSL {
            let userProfileVC = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        else{
            let extWeb = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            extWeb.urlString = "\(AppDelegate.getDelegate().siteURL)settings?ut=" + Data("bi===\(PreferenceManager.boxId)&&&si===\(PreferenceManager.sessionId)&&&ci===\(PreferenceManager.deviceType)".utf8).base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            extWeb.isFromParentalControl = true
            extWeb.pageString = Items.account.rawValue
            extWeb.viewControllerName = ""
            self.navigationController?.pushViewController(extWeb, animated: true)
        }
    }
    @IBAction func signInSignOutAction(_ sender : Any) {
        let storyBoard = UIStoryboard(name: "Account", bundle: nil)
        let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        storyBoardVC.viewControllerName = "SignInVC"
        navigationController?.pushViewController(storyBoardVC, animated: true)
    }
    @IBAction func SignoutButtonClicked(_ sender: Any) {
        var messageText = "Are you sure you want to Sign out?"
        if appContants.appName == .tsat || appContants.appName == .aastha {
            messageText = "All downloaded content will be deleted on signing out \n\n Are you sure you want to Sign out?"
        }
        showLogoutAlertWithText(message: messageText)
    }
    private func showLogoutAlertWithText (_ header : String = "Confirm".localized, message : String) {
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
    private func LogOutClicked() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            errorAlert(forTitle: String.getAppName(), message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), needAction: false) { (flag) in }
            return
        }
        self.startAnimating(allowInteraction: false)
        NSTimeZone.default = AppDelegate.getDelegate().userTimeZone
        AppDelegate.getDelegate().userStateChanged = true
        OTTSdk.userManager.signOut(onSuccess: { (result) in
            AppAnalytics.shared.updateUser()
            
            deleteUserConsentOnAgeAndDob()
            let switchUserDefaults = UserDefaults.standard
            switchUserDefaults.set(true, forKey: "ccStatus")
            switchUserDefaults.synchronize()
            
            if appContants.appName == .tsat || appContants.appName == .aastha || appContants.appName == .gac {
                if #available(iOS 11.0, *) {
                    AppDelegate.getDelegate().deleteAllData()
                }
            }
            if AppDelegate.getDelegate().countriesInfoArray.count > 0 {
                AppDelegate.getDelegate().countriesInfoArray.removeAll()
                AppDelegate.getDelegate().countryCode = ""
            }
            if AppDelegate.getDelegate().recordingCardsArr.count > 0{
                AppDelegate.getDelegate().recordingCardsArr.removeAll()
            }
            OTTSdk.appManager.configuration(onSuccess: { (response) in
                AppDelegate.getDelegate().configs = response.configs
                AppDelegate.getDelegate().setConfigResponce(response.configs)
                
               
                AppDelegate.getDelegate().loadHomePage(toFristViewController: true)
                self.stopAnimating()
                self.updateUser()
                AppDelegate.getDelegate().taggedScreen = "Settings"
                LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                playerVC?.removeViews()
                playerVC = nil
            }) { (error) in
                print(error.message)
                self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
                self.stopAnimating()
            }
        }) { (error) in
            self.stopAnimating()
            self.errorAlert(forTitle: String.getAppName(), message: error.message, needAction: false) { (flag) in }
        }
    }
}
extension NewAccountController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as? RegisterCell else { return UITableViewCell() }
        cell.registerTitleLbl.text = listItems[indexPath.row].rawValue.localized
        cell.accountStackView.removeArrangedSubview(cell.segmentControlView)
        cell.segmentControlView.removeFromSuperview()
        cell.arrowImageView.isHidden = false
        if listItems[indexPath.row] == .appLanguages {
            cell.segmentControl.removeAllSegments()
            cell.accountStackView.addArrangedSubview(cell.segmentControlView)
            cell.arrowImageView.isHidden = true
            var selectedIndex = 0
            for  (index, lang) in Constants.displayLanguages.enumerated(){
                if lang.code == OTTSdk.preferenceManager.selectedDisplayLanguage{
                    selectedIndex = index
                }
                cell.segmentControl.insertSegment(withTitle: lang.name.localized, at: index, animated: false)
            }
            if Constants.displayLanguages.count > 0{
                cell.segmentControl.selectedSegmentIndex = selectedIndex
            }
            cell.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        }
        cell.arrowImageView.image = cell.arrowImageView.image?.withRenderingMode(.alwaysTemplate)
        cell.arrowImageView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
        return cell
    }
    @objc private func segmentControlValueChanged(_ sender : UISegmentedControl) {
            if !Utilities.hasConnectivity() {
                self.stopAnimating()
                self.errorAlert(forTitle: String.getAppName(), message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), needAction: false) { (flag) in }
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
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listItems[indexPath.row] {
        case .watchlist,.favourites,.myfavourites:
            goToCurrentPage(json: ["displayname" : "Favourites", "targetPath" : ((AppDelegate.getDelegate().favouritesTargetPath).count > 0 ? AppDelegate.getDelegate().favouritesTargetPath : "favourites")])
        case .purchasedItems:
            goToCurrentPage(json: ["displayname" : listItems[indexPath.row].rawValue, "targetPath" : AppDelegate.getDelegate().myPurchasesTargetPath])
        case .account:
            self.MyAccountButtonClicked(self)
        case .profile:
            let userProfileVC = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            if listItems[indexPath.row] == .profile {
                userProfileVC.topTitleType = .profile
            }
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        case .languages:
            let languagesVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
            languagesVC.fromPage = false
            languagesVC.Signup_Process = false
            languagesVC.viewControllerName = "AccountViewController"
            navigationController?.pushViewController(languagesVC, animated: true)
        case .mydownloads:
            if OTTSdk.preferenceManager.user != nil {
                let listVC = TargetPage.moviesViewController()
                listVC.isToViewMore = true
                listVC.sectionTitle = "My Downloads"
                listVC.isMyDownloadsSection = true
                self.navigationController?.pushViewController(listVC, animated: true)
            }
            else {
                errorAlert(forTitle: String.getAppName(), message: "Please sign in to view your Downloads", needAction: false) { value in}
            }
        case .videoquality:
            let storyBoard = UIStoryboard(name: "Account", bundle: nil)
            let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "VideoQualityViewController") as! VideoQualityViewController
            self.navigationController?.pushViewController(storyBoardVC, animated: true)
        case .aboutUs:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = Constants.OTTUrls.aboutUsUrl
            view1.pageString = "About us".localized
            view1.viewControllerName = "AccountViewController"
            self.navigationController?.pushViewController(view1, animated: true)
        case .privacy:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = Constants.OTTUrls.privacyPolicyUrl
            view1.pageString = listItems[indexPath.row].rawValue
            view1.viewControllerName = "AccountViewController"
            self.navigationController?.pushViewController(view1, animated: true)
        case .terms:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = Constants.OTTUrls.termsUrl
            view1.pageString = listItems[indexPath.row].rawValue
            view1.viewControllerName = "AccountViewController"
            self.navigationController?.pushViewController(view1, animated: true)
        case .cookies:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = Constants.OTTUrls.cookiesPageUrl
            view1.pageString = listItems[indexPath.row].rawValue
            view1.viewControllerName = "AccountViewController"
            self.navigationController?.pushViewController(view1, animated: true)
        case .contentRedressal:
            let view1 = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = AppDelegate.getDelegate().configs?.grievanceRedressalUrl
            view1.pageString = listItems[indexPath.row].rawValue
            view1.viewControllerName = "AccountViewController"
            navigationController?.pushViewController(view1, animated: true)
        case .complianceReport:
            let view1 = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = AppDelegate.getDelegate().configs?.complianceReport
            view1.pageString = listItems[indexPath.row].rawValue
            view1.viewControllerName = "AccountViewController"
            navigationController?.pushViewController(view1, animated: true)
        default:
            let view1 = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = AppDelegate.getDelegate().configs?.helpPageUrl
            view1.pageString = "Help" as String
            view1.viewControllerName = "SetupViewController"
            navigationController?.pushViewController(view1, animated: true)
        }
    }
    private func goToCurrentPage(json : [String : String]) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        startAnimating(allowInteraction: false)
        TargetPage.getTargetPageObject(path:json["targetPath"] ?? "") { (viewController, pageType) in
            //            if let vc = viewController as? ContentViewController{
            //                //self.pageContentResponse = vc.pageContentResponse
            //                vc.isToViewMore = true
            //                vc.targetedMenu = json["targetPath"] ?? ""
            //                vc.sectionTitle = json["displayname"] ?? ""
            //                self.navigationController?.pushViewController(vc, animated: true)
            //
            //            }
            //            else if let vc = viewController as? PlayerViewController{
            //                vc.delegate = self
            //                AppDelegate.getDelegate().window?.addSubview(vc.view)
            //            }
            //            else if let vc = viewController as? DetailsViewController {
            //                vc.navigationTitlteTxt = json["displayname"] ?? ""
            ////                let topVC = UIApplication.topVC()!
            //                self.navigationController?.pushViewController(vc, animated: true)
            //
            //            }
            //            else if (viewController is DefaultViewController){
            //                let defaultViewController = viewController as! DefaultViewController
            //                defaultViewController.delegate = self
            //                let topVC = UIApplication.topVC()!
            //                topVC.navigationController?.pushViewController(viewController, animated: true)
            //
            //            }
            //            else{
            if let vc = viewController as? ListViewController{
                vc.isToViewMore = true
                vc.sectionTitle = json["displayname"] ?? ""
                //                    let topVC = UIApplication.topVC()!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else if let vc = viewController as? ContentViewController{
                //self.pageContentResponse = vc.pageContentResponse
                vc.isToViewMore = true
                vc.targetedMenu = json["targetPath"] ?? ""
                vc.sectionTitle = json["displayname"] ?? ""
                self.navigationController?.pushViewController(vc, animated: true)

            }
            else if let _ = viewController as? DefaultViewController{
                let topVC = UIApplication.topVC()!
                topVC.navigationController?.pushViewController(viewController, animated: true)

            }
            //                else {
            //                    let topVC = UIApplication.topVC()!
            //                    topVC.navigationController?.pushViewController(viewController, animated: true)
            //                }
            //            }
            self.stopAnimating()
        }
    }
}
extension NewAccountController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("Pramod")
    }
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
}
class RegisterCell: UITableViewCell {
    @IBOutlet weak var registerTitleLbl : UILabel!
    @IBOutlet weak var lineLbl : UILabel!
    @IBOutlet weak var arrowImageView : UIImageView!
    @IBOutlet weak var accountStackView : UIStackView!
    @IBOutlet var segmentControlView : UIView!
    @IBOutlet weak var segmentControl : UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        registerTitleLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        registerTitleLbl.font = UIFont.ottRegularFont(withSize: 14)
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = AppTheme.instance.currentTheme.themeColor
        } else {
            segmentControl.tintColor = AppTheme.instance.currentTheme.themeColor
        }
        // selected option color
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppTheme.instance.currentTheme.buttonsAndHeaderLblColor as Any], for: .selected)
        
        // color of other options
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppTheme.instance.currentTheme.cardTitleColor as Any], for: .normal)
        selectionStyle = .none
        lineLbl.backgroundColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.15)
    }
}
