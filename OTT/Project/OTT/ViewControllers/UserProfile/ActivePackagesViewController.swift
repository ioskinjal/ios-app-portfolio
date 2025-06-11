//
//  ActivePackagesVC.swift
//  YuppFlix
//
//  Created by Ankoos on 07/10/16.
//  Copyright © 2016 Ankoos. All rights reserved.
//

import UIKit
import OTTSdk
//,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,CancelSubscriptionConfirmPopUpProtocol,CancelSubscriptionSuccessPopupProtocol
class ActivePackagesViewController: UIViewController {
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var activePckgsHeaderLbl1: UILabel!
    @IBOutlet weak var packageHeaderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var addOnLbl: UILabel!
    @IBOutlet weak var devicesLbl: UILabel!
    @IBOutlet weak var amountRenewDataLbl: UILabel!
    @IBOutlet weak var activePackagesTbl: UITableView!
    
    var activePackagesArr = [Package]()

    @IBAction func BackAction(_ sender: AnyObject) {
        //        AppDelegate.getDelegate().stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.activePckgsHeaderLbl1.text = "Active Plans".localized
//        self.startAnimating(allowInteraction: false)
        self.activePackagesTbl.delegate = self
        self.activePackagesTbl.dataSource = self
        
        self.activePckgsHeaderLbl1.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
//        self.packageHeaderLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.getActivePackages()
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
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
    }
    
    func getActivePackages() {
        OTTSdk.userManager.activePackages(onSuccess: { (packages) in
            self.stopAnimating()
            if packages.count == 0 {
                //TODO: "No active packages for your account" translation
                self.showAlertWithText(message: "There are no active subscriptions".localized)
                self.activePackagesArr = packages
                self.activePackagesTbl.reloadData()
            }
            else {
                self.activePackagesArr = packages
                self.activePackagesTbl.reloadData()
            }
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertWithText (_ header : String = String.getAppName(),  message : String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let messageAlertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.backToDetailPage()
        })
        alert.addAction(messageAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func backToDetailPage() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension ActivePackagesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activePackagesArr.count//self.titlesArray.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 283.0;
//        let activePackageDict = self.activePackagesArr[indexPath.row]
//        if activePackageDict.isRecurring && !activePackageDict.isUnSubscribed {
//            return 283.0;
//        }
//        else {
//            return 233.0;
//        }
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveplansCell") as? ActiveplansCell else { return UITableViewCell() }
        guard let package = activePackagesArr[indexPath.row] as? Package  else { return cell }
        cell.numberLbl.text = String(format: "%02d", indexPath.row + 1)
        cell.currentPlanLbl.isHidden = true
        if !cell.mainStackView.arrangedSubviews.contains(cell.activeView) {
            cell.mainStackView.insertArrangedSubview(cell.activeView, at: 0)
        }
        if package.isCurrentlyActivePlan == 1 {
            cell.currentPlanLbl.isHidden = false
            cell.mainStackView.removeArrangedSubview(cell.activeView)
            cell.activeView.removeFromSuperview()
        }
        cell.planLbl.text = package.name.localized
        cell.amountLbl.text = package.currencySymbol + String(format: " %.0f / ", package.packageAmount) + package.packageType.localized + "  |  Inclusive of all Taxes"
        cell.activeLbl.text = package.effectiveFrom
        cell.expireLbl.text = "Package expires on " + package.expiryDate.doubleValue.getDateStringFromTimeInterval()

//        if indexPath.row > 0 {
//
//        }
//        cell.expireLbl.text = package.message
//        cell.activeLbl.text = "Testing"
        
        //        let identifier:String = "activePackagesCell"
        
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        //configure your cell
        //        let contentSubview:UIView = (cell?.contentView.viewWithTag(100))!
        ////        contentSubview.cornerDesign()
        //        let activePackageDict = self.activePackagesArr[indexPath.row]
        //
        //        let packagenameView:UIView = contentSubview.viewWithTag(101)!
        //        let packageDetailsView:UIView = contentSubview.viewWithTag(102)!
        //
        //        let purchaseDateLbl:UILabel = packageDetailsView.viewWithTag(50)! as! UILabel
        //        let expiryDateLbl:UILabel = packageDetailsView.viewWithTag(100)! as! UILabel
        //        let packageTLbl:UILabel = packageDetailsView.viewWithTag(150)! as! UILabel
        //        let packagenameLbl:UILabel = packagenameView.viewWithTag(1011)! as! UILabel
        //        let purchaseLabel = packageDetailsView.viewWithTag(1021)! as! UILabel
        //        let expiryLabel = packageDetailsView.viewWithTag(1022)! as! UILabel
        //        let packageTypeLabel = packageDetailsView.viewWithTag(1023)! as! UILabel
        //
        //        for subView in packageDetailsView.subviews {
        //            if subView is UIButton {
        //                let cancelSubsBtn = subView as! UIButton
        //                cancelSubsBtn.cornerDesignWithBorder()
        //                cancelSubsBtn.tag = indexPath.row
        //                cancelSubsBtn.addTarget(self, action: #selector(self.cancelSubscription(_:)), for: .touchUpInside)
        //                if activePackageDict.isRecurring && !activePackageDict.isUnSubscribed {
        //                    cancelSubsBtn.isHidden = false
        //                }
        //                else {
        //                    cancelSubsBtn.isHidden = true
        //                }
        //                break
        //            }
        //        }
        //
        //        expiryDateLbl.text = "Expiry Date".localized
        //        purchaseDateLbl.text = "Purchase Date".localized
        //        packageTLbl.text = "Package Type".localized
        //
        //        packagenameLbl.text = String.init(format: "%@", activePackageDict.name.localized)
        //        purchaseLabel.text = Date().getFullDate("\(activePackageDict.purchaseDate)".localized)
        //        expiryLabel.text = Date().getFullDate("\(activePackageDict.expiryDate)")
        //        packageTypeLabel.text = String.init(format: "%@", activePackageDict.packageType.localized)
        
        //        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    /*@objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func cancelSubscription(_ sender: UIButton) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        
        let vc = CancelSubscriptionConfirmPopUp()
        vc.delegate = self
        vc.packageIndex = sender.tag
        self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
        })

    }
    
    func cancelYesClicked(packageIndex:Int) {
        if self.popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: true)
        
        let activePackageDict = self.activePackagesArr[packageIndex]
        
        OTTSdk.paymentsManager.cancelSubscription(package_id: activePackageDict.id, gateway: activePackageDict.gateway, onSuccess: { (response) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
                
                self.stopAnimating()
                let vc = CancelSubscriptionSuccessPopup()
                vc.delegate = self
                self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
                })
            }
        }) { (error) in
            self.stopAnimating()
            Log(message: error.message)
        }
    }
    
    func cancelNoClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
    }
    
    func okThanksClicked() {
        if popupViewController != nil {
            self.dismissPopupViewController(.fade)
        }
        self.startAnimating(allowInteraction: true)
        self.getActivePackages()
    }*/
}
class ActiveplansCell : UITableViewCell {
    @IBOutlet weak var numberLbl : UILabel!
    @IBOutlet weak var planLbl : UILabel!
    @IBOutlet weak var currentPlanLbl : UILabel!
    @IBOutlet weak var amountLbl : UILabel!
    @IBOutlet weak var expireLbl : UILabel!
    @IBOutlet weak var activeLbl : UILabel!
    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var mainStackView : UIStackView!
    @IBOutlet var expireView : UIView!
    @IBOutlet var activeView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        planLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        planLbl.font = UIFont.ottRegularFont(withSize: 16)
        amountLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        amountLbl.font = UIFont.ottRegularFont(withSize: 14)
        expireLbl.font = UIFont.ottRegularFont(withSize: 12)
        expireLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        activeLbl.font = UIFont.ottRegularFont(withSize: 12)
        activeLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        currentPlanLbl.text = "(Current Plan)"
        currentPlanLbl.font = UIFont.ottItalicFont(withSize: 12)
        currentPlanLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        numberLbl.font = UIFont.ottRegularFont(withSize: 10)
        numberLbl.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        numberLbl.changeBorder(color: AppTheme.instance.currentTheme.themeColor)
        backView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        backView.viewCornerDesign()
    }
}
