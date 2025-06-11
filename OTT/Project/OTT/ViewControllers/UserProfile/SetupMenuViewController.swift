//
//  SetupMenuViewController.swift
//  OTT
//
//  Created by Srikanth on 6/20/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//
import UIKit
import OTTSdk

class SetupMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,iShowcaseDelegate {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var accountHeaderLbl1: UILabel!
    @IBOutlet weak var AccountDetailsTable: UITableView!
    
    var titlesArray = [TitlesEnum]()
    enum TitlesEnum : String{
        case profile = "Profile"
        case mobileNumber = "Mobile Number"
        case email = "Email"
        case password = "Password"
        case transactionHistory = "Transaction History"
        case myAccount = "My Account"
        case help = "Help & Support"
    }
    
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        //        self.titlesArray.append(.email)
        //self.titlesArray.append(.profile)
        //self.titlesArray.append(.mobileNumber)
        //        self.titlesArray.append(.email)
        //        self.titlesArray.append(.password)
        //        self.titlesArray.append(.transactionHistory)
        self.titlesArray.append(.myAccount)
        self.titlesArray.append(.help)
        self.accountHeaderLbl1.text = "Setup".localized
        self.accountHeaderLbl1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        
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
}
// MARK: - AccountDetailsVC Table Methods
extension SetupMenuViewController
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "accountdetailsCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        let nameLabel:UILabel = cell?.contentView.viewWithTag(2) as! UILabel
        let subTitleLabel:UILabel = cell?.contentView.viewWithTag(3) as! UILabel
        let imgView:UIImageView = cell?.contentView.viewWithTag(1) as! UIImageView
        
        let separatorView:UIView = (cell?.contentView.viewWithTag(4)!)!
        separatorView.backgroundColor = UIColor.cellSeperatorBlackColor()
        
        let titleEnum = titlesArray[indexPath.row]
        nameLabel.text = titleEnum.rawValue.localized
        nameLabel.font = UIFont.ottRegularFont(withSize: 16)
        nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        subTitleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subTitleLabel.font = UIFont.ottRegularFont(withSize: 12)
        imgView.isHidden = false
        
        if titleEnum == .email{
            imgView.isHidden = true
            if let email = OTTSdk.preferenceManager.user?.email{
                subTitleLabel.text = email
            }
        }
        /*if titleEnum == .mobileNumber{
            imgView.isHidden = true
            if let phoneNumber = OTTSdk.preferenceManager.user?.phoneNumber{
                subTitleLabel.text = phoneNumber
            }
        }*/
        else if titleEnum == .password{
            imgView.isHidden = false
            subTitleLabel.text = "********"
            let showcase = iShowcase()
            showcase.delegate = self
            showcase.setupShowcaseForView((cell?.contentView)!)
            showcase.titleLabel.text = "Update or Change your password".localized
            showcase.type = iShowcase.TYPE(rawValue: 1)
//            showcase.show()

        }
        else if titleEnum == .transactionHistory{
        }
        else if titleEnum == .myAccount{ 
        }
        else if titleEnum == .help{
        }
        
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        
        let titleEnum = titlesArray[indexPath.row]
        
        if titleEnum == .password{
            let verifyMobileView = accStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(verifyMobileView, animated: true)
        }
        else if titleEnum == .profile {
            let userProfileVC = TargetPage.userProfileViewController()
            userProfileVC.isFromAccountPage = true
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        else if titleEnum == .transactionHistory {
            let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        else if titleEnum == .myAccount {
            let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(userProfileVC, animated: true)
            
        }
        else if titleEnum == .help {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
            let view1 = storyBoard.instantiateViewController(withIdentifier: "ExtWebLinksViewController") as! ExtWebLinksViewController
            view1.urlString = AppDelegate.getDelegate().configs?.helpPageUrl
            view1.pageString = "Help" as String
            view1.viewControllerName = "SetupViewController"
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(view1, animated: true)
        }
        /*
         if (indexPath as NSIndexPath).row == 0 {
         //profile
         
         let devicesView = accStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(devicesView, animated: true)
         
         }else if (indexPath as NSIndexPath).row == 2 {
         //2 Transactions
         
         let aboutVC = accStoryBoard.instantiateViewController(withIdentifier: "TransactionsVC") as! TransactionsVC
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(aboutVC, animated: true)
         
         
         }
         else if (indexPath as NSIndexPath).row == 3 {
         //3 devices
         let devicesView = accStoryBoard.instantiateViewController(withIdentifier: "UserDevicesVC") as! UserDevicesVC
         self.navigationController?.isNavigationBarHidden = true
         self.navigationController?.pushViewController(devicesView, animated: true)
         
         }
         else
         {
         return
         }*/
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (productType.iPad ? 100 : 80)
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

