//
//  AccountVC.swift
//  YUPPTV
//
//  Created by Ankoos on 19/09/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk

class AccountDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var accountHeaderLbl1: UILabel!
    @IBOutlet weak var AccountDetailsTable: UITableView!
    
    var titlesArray = [TitlesEnum]()
    enum TitlesEnum : String{
        case profile = "Profile"
        case activePackages = "Active Packages"
        case transactions = "Transactions History"
        case devices = "Devices" // No translation we have
    }
    
    
    // MARK: - View Methods
    
    override var prefersStatusBarHidden : Bool {
        return AppDelegate.getDelegate().statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
     }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.homeStatusBarColor(isButton: false)
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.titlesArray .append(contentsOf: [TitlesEnum.profile])//,TitlesEnum.activePackages,TitlesEnum.transactions, TitlesEnum.devices
        self.accountHeaderLbl1.text = "Account".localized
        self.accountHeaderLbl1.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        let qosClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qosClass)
        
        backgroundQueue.async(execute: {
            /*
            YuppTVSDK.userManager.accountDetails(onSuccess: { (response) in
                print(response)
                self.stopAnimating()
                let activePackagecount = response.activePackages.count
                self.subTitlesArray.append(contentsOf: ["\(response.mobile)","\(activePackagecount)","\(activePackagecount)","\(activePackagecount)"])
                
                self.AccountDetailsTable.reloadData()
            }) { (error) in
                Log(message: error.message)
                self.stopAnimating()
                self.AccountDetailsTable.reloadData()
            }*/
        });
        
        
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
    // MARK: - custom methods
    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - AccountDetailsVC Table Methods
extension AccountDetailsViewController
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountdetailsCell") else {return UITableViewCell()}
//        let identifier:String = "accountdetailsCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        let nameLabel:UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let subTitleLabel:UILabel = cell.contentView.viewWithTag(3) as! UILabel
        

        let titleEnum = titlesArray[indexPath.row]
        nameLabel.text = titleEnum.rawValue.localized
        
        if titleEnum == .profile{
            if let mobile = OTTSdk.preferenceManager.user?.phoneNumber{
                subTitleLabel.text = mobile
            }
        }
        cell.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        cell.contentView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        nameLabel.textColor = AppTheme.instance.currentTheme.cardTitleColor
        nameLabel.font = UIFont.ottRegularFont(withSize: 14)
        subTitleLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        subTitleLabel.font = UIFont.ottRegularFont(withSize: 12)
        cell.selectionStyle = .none
//        cell?.contentView.backgroundColor = UIColor.init(red: 28.0/255.0, green: 29.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accStoryBoard : UIStoryboard = UIStoryboard(name: "Account", bundle:nil)
        
        let titleEnum = titlesArray[indexPath.row]
        
        if titleEnum == .activePackages{
            let aboutVC = accStoryBoard.instantiateViewController(withIdentifier: "ActivePackagesViewController") as! ActivePackagesViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
        else if titleEnum == .profile {
            let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        else if titleEnum == .transactions {
            let userProfileVC = accStoryBoard.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(userProfileVC, animated: true)
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
}

