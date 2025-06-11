//
//  UserProfileViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 24/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class UserProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,iShowcaseDelegate {
    @IBOutlet weak var topEditButton : UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var accountHeaderLbl1: UILabel!
    @IBOutlet weak var AccountDetailsTable: UITableView!
    var topTitleType = TitlesEnum.password
    var titlesArray = [TitlesEnum]()
    enum TitlesEnum : String{
        case profile = "Profile Information"
        case activePlans = "Active Plans"
        case mobileNumber = "Mobile Number"
        case email = "Email"
        case password = "Password"
        case transactionHistory = "Transaction History"
        case fullname = "Full Name"
        case dob = "DOB"
        case gender = "Gender"
        case parental_control = "Parental Control"
    }
    var activePackagesArr = [Package]()
    
    // MARK: - View Methods
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getActivePackages()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
//        self.titlesArray.append(.email)
        //self.titlesArray.append(.profile)
        //
        if appContants.appName == .aastha || appContants.appName == .gac {
            topEditButton.setTitleColor(AppTheme.instance.currentTheme.buttonsAndHeaderLblColor, for: .normal)
        }else {
            topEditButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        }
        topEditButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 14)
        self.accountHeaderLbl1.text = "My Account".localized
        self.accountHeaderLbl1.textColor = AppTheme.instance.currentTheme.navigationBarTextColor
        accountHeaderLbl1.font = UIFont.ottRegularFont(withSize: 16)
        topEditButton.isHidden = true
        if topTitleType == .profile {
            titlesArray.removeAll()
            topEditButton.isHidden = false
            self.titlesArray.append(.fullname)
            self.titlesArray.append(.dob)
            self.titlesArray.append(.gender)
            self.accountHeaderLbl1.text = topTitleType.rawValue.localized
        }else {
            if appContants.appName != .mobitel {
                self.titlesArray.append(.email)
            }
            self.titlesArray.append(.password)
            if appContants.appName != .supposetv && appContants.appName != .gac {
                self.titlesArray.append(.mobileNumber)
            }
            if appContants.appName != .tsat && appContants.appName != .aastha && appContants.appName != .gotv && appContants.appName != .yvs && appContants.appName != .supposetv && appContants.appName != .mobitel && appContants.appName != .pbns && appContants.appName != .airtelSL  && appContants.appName != .gac {
                titlesArray.append(.activePlans)
                self.titlesArray.append(.transactionHistory)
                self.titlesArray.append(.parental_control)
            }
            else if appContants.appName == .mobitel {
                titlesArray.append(.activePlans)
            }
        }
        // Do any additional setup after loading the view.
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getActivePackages() {
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.activePackages(onSuccess: { (packages) in
            self.stopAnimating()
            self.activePackagesArr = packages
            self.AccountDetailsTable.reloadData()
        }) { (error) in
            self.stopAnimating()
            self.AccountDetailsTable.reloadData()
        }
    }
    func LogOutClicked() {
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }

        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.signOut(onSuccess: { (result) in
            print(result)
            deleteUserConsentOnAgeAndDob()
            self.stopAnimating()
            self.navigationController?.popToRootViewController(animated: true)
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message)
            Log(message: error.message)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(1000)) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClosePlayer"), object: nil)
        }
    }
    // MARK: - custom methods
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func topEditButtonAction(_ sender : Any) {
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileUpdateVC") as! UserProfileUpdateVC
        editProfile.delegate = self
        navigationController?.pushViewController(editProfile, animated: true)
    }
}
// MARK: - AccountDetailsVC Table Methods
extension UserProfileViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as? UserProfileCell else { return UITableViewCell() }
        cell.rightArrowImageView.isHidden = true
        cell.editButton.isHidden = false
        cell.mainTitleLbl.text = titlesArray[indexPath.row].rawValue
        cell.subTitleLbl.text = ""
        cell.editButton.tag = indexPath.row
        cell.mainTitleTopConstraint.constant = 16
        cell.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        if topTitleType == .profile {
            cell.editButton.isHidden = true
        }
        switch titlesArray[indexPath.row] {
        case .fullname:
            if let firstname = OTTSdk.preferenceManager.user?.firstName, let lastname = OTTSdk.preferenceManager.user?.lastName, firstname.count > 0, lastname.count > 0 {
                cell.subTitleLbl.text = firstname + " " + lastname
            }else if let name = OTTSdk.preferenceManager.user?.name, name.count > 0 {
                cell.subTitleLbl.text = name
            }else {
                cell.subTitleLbl.text = "--"
            }
        case .dob:
            guard let dob = OTTSdk.preferenceManager.user?.dob, dob.doubleValue > 0 else {
                cell.subTitleLbl.text = "--"
                return cell }
            cell.subTitleLbl.text = dob.doubleValue.getDateOfBirth()
        case .gender :
            guard let g = OTTSdk.preferenceManager.user?.gender, g.count > 0 else {
            cell.subTitleLbl.text = "--"
            return cell }
            cell.subTitleLbl.text = getGender(g)
        case .email:
            guard let email = OTTSdk.preferenceManager.user?.email, email.count > 0 else { return cell
            }
            cell.subTitleLbl.text = email
        case .password:
            cell.subTitleLbl.text = "********"
        case .mobileNumber:
            guard let number = OTTSdk.preferenceManager.user?.phoneNumber, number.count > 0 else {
                cell.mainTitleTopConstraint.constant = 30
                return cell
            }
            cell.subTitleLbl.text = number
        case .activePlans:
            if activePackagesArr.count > 0 {
                let packageItem = activePackagesArr[0]
                cell.subTitleLbl.text = ("\(packageItem.name) - \(packageItem.message)")
                cell.rightArrowImageView.isHidden = false
                
                /*if packageItem.additionalInfo.specialOfferMessage != "" {
                 cell.offerTitleLabel.text = packageItem.additionalInfo.specialOfferMessage
                 cell.offerTitleLabel.isHidden = false
                 }
                 else {
                 cell.offerTitleLabel.isHidden = true
                 }*/
            }
            else {
                cell.subTitleLbl.text = "There are no Active Subscriptions"
                cell.rightArrowImageView.isHidden = true
            }
            cell.editButton.isHidden = true
        case .transactionHistory:
            if activePackagesArr.count > 0 {
                let packageItem = activePackagesArr[0]
                let startDateText = "\(Date().getFullDate("\(packageItem.purchaseDate)", inFormat: "dd MMM, YYYY"))"
                cell.subTitleLbl.text = ("Last Transaction \(startDateText)")
            }
            else {
                cell.subTitleLbl.text = ""
            }
            cell.rightArrowImageView.isHidden = false
            cell.editButton.isHidden = true
//            guard let objects = OTTSdk.preferenceManager.user?.packages, objects.count > 0 else {
//                cell.mainTitleTopConstraint.constant = 30
//                return cell
//            }
//            guard let package = objects.first as? [String : Any] else {
//                cell.mainTitleTopConstraint.constant = 30
//                return cell
//            }
//            if let pName = package["name"] as? String, pName.count > 0, let expiry = package["expiryDate"] as? Double, expiry > 0 {
//                cell.subTitleLbl.text = "Last Transaction "  + expiry.getDateStringFromTimeIntervalWithMonth()
//            }
        case .parental_control:
            cell.rightArrowImageView.isHidden = false
            cell.editButton.isHidden = true
            cell.mainTitleTopConstraint.constant = 30
        default:
            cell.mainTitleTopConstraint.constant = 30
            cell.rightArrowImageView.isHidden = false
            cell.editButton.isHidden = true
            break
        }
        return cell
    }
    private func getGender(_ gender : String) -> String {
        switch gender {
        case "M":
            return "Male"
        case "F":
            return "Female"
        case "O":
            return "Other"
        default:
            return ""
        }
    }
    @objc func editButtonAction(_ sender : UIButton) {
        var vc : UIViewController!
        switch titlesArray[sender.tag] {
        case .password:
            let password = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            vc = password
        case .email:
            let changeMobileVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ChangeMobileNumberVC") as! ChangeMobileNumberVC
            changeMobileVC.typeView = .email
            vc = changeMobileVC
        case .mobileNumber:
            let changeMobileVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ChangeMobileNumberVC") as! ChangeMobileNumberVC
            changeMobileVC.typeView = .mobileNumber
            vc = changeMobileVC
        default:
            break
        }
        guard let v = vc else { return }
        navigationController?.pushViewController(v, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 2 {
            var vc : UIViewController!
            switch titlesArray[indexPath.row] {
            case .transactionHistory:
                let th = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
                vc = th
            case .parental_control:
                let extWeb = UIStoryboard(name: "Account", bundle:nil).instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
                extWeb.urlString = "\(AppDelegate.getDelegate().siteURL)settings?ui=" + Data("bi=\(PreferenceManager.boxId)&si=\(PreferenceManager.sessionId)&&ci=\(PreferenceManager.deviceType)".utf8).base64EncodedString()
                extWeb.isFromParentalControl = true
                extWeb.pageString = titlesArray[indexPath.row].rawValue
                extWeb.viewControllerName = ""
                self.navigationController?.pushViewController(extWeb, animated: true)
            default:
                let plans = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ActivePackagesViewController") as! ActivePackagesViewController
                vc = plans
            }
            guard let v = vc else { return  }
            navigationController?.pushViewController(v, animated: true)
        }
        else {
            switch titlesArray[indexPath.row] {
            case .activePlans:
                var vc : UIViewController!
                let plans = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ActivePackagesViewController") as! ActivePackagesViewController
                vc = plans
                guard let v = vc else { return  }
                navigationController?.pushViewController(v, animated: true)
            default:
                break
            }
        }
    }
    
    func GotoResetView(messageStr:String,emailStr:String?,mobileStr:String?) {
        errorAlert(forTitle: String.getAppName(), message: messageStr, needAction: true) { (flag) in
            if flag {
                let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                resetVC.email = emailStr
                resetVC.mobile = mobileStr
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(resetVC, animated: true)
            }
        }
    }

    func showAlertWithText (_ header : String = String.getAppName(),  message : String) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
}
extension UserProfileViewController : UserProfileUpdateDelegate {
    func updateUserDetails() {
        AccountDetailsTable.reloadData()
    }
}
class UserProfileCell : UITableViewCell {
    @IBOutlet weak var mainTitleLbl : UILabel!
    @IBOutlet weak var subTitleLbl : UILabel!
    @IBOutlet weak var rightArrowImageView : UIImageView!
    @IBOutlet weak var editButton : UIButton!
    @IBOutlet weak var mainTitleTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var lineLbl : UILabel!
    override func awakeFromNib() {
        selectionStyle = .none
        mainTitleLbl.font = UIFont.ottRegularFont(withSize: 14)
        mainTitleLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        subTitleLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subTitleLbl.font = UIFont.ottRegularFont(withSize: 12)
        editButton.setTitleColor(AppTheme.instance.currentTheme.themeColor, for: .normal)
        editButton.titleLabel?.font = UIFont.ottRegularFont(withSize: 12)
        self.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.contentView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        lineLbl.backgroundColor = AppTheme.instance.currentTheme.cardTitleColor.withAlphaComponent(0.1)
        rightArrowImageView.image = #imageLiteral(resourceName: "lang_arrow_right").withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = AppTheme.instance.currentTheme.cardTitleColor
    }
}
