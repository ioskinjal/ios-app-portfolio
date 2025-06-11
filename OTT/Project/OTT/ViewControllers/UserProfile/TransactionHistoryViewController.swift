//
//  TransactionHistoryViewController.swift
//  OTT
//
//  Created by Chandra Sekhar on 24/07/17.
//  Copyright © 2017 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk
class TransactionHistoryViewController: UIViewController,UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource,TransctionDetailsDelegate {
    
    func didClosesPopup() {
        if popupViewController != nil {
            self.dismissPopupViewController(.bottomBottom)
        }
    }
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var activePckgsHeaderLbl1: UILabel!
    @IBOutlet weak var packageHeaderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var addOnLbl: UILabel!
    @IBOutlet weak var devicesLbl: UILabel!
    @IBOutlet weak var amountRenewDataLbl: UILabel!
    @IBOutlet weak var activePackagesTbl: UITableView!
    
    var activePackagesArr = [Transaction]()
    var transactionPageNum = 0
    var isDataAvailable:Bool = true
    
    @IBAction func BackAction(_ sender: AnyObject) {
        //        AppDelegate.getDelegate().stopAnimating()
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         AppDelegate.getDelegate().handleSupportButton(isHidden: false, isFromTabVC: false)
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        activePckgsHeaderLbl1.text = "Transaction History".localized
        self.navigationView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        self.navigationView.cornerDesign()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.activePckgsHeaderLbl1.textColor = AppTheme.instance.currentTheme.buttonsAndHeaderLblColor
        activePckgsHeaderLbl1.font = UIFont.ottRegularFont(withSize: 16)
        self.activePackagesTbl.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: AppDelegate.getDelegate().window!.bounds.width, height: 80.0))
        self.getTransactionHistory(isLoadingNextData: false)
    }
    override var prefersHomeIndicatorAutoHidden: Bool{
        if playerVC != nil {
            return true
        }
        return false
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
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func getTransactionHistory(isLoadingNextData:Bool) {
        if !Utilities.hasConnectivity() {
            AppDelegate.getDelegate().showAlertWithTextAfterWindowPresented(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr())
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.transactionHistory(page: transactionPageNum, count: nil, onSuccess: { (response) in
            self.stopAnimating()
            if response.count == 0 {
                if !isLoadingNextData {
                    self.showAlertWithText(message: "No Transaction History for your account".localized)
                }
                self.activePackagesArr.append(contentsOf: response)
                self.activePackagesTbl.reloadData()
                self.isDataAvailable = false
            }
            else {
                self.activePackagesArr.append(contentsOf: response)
                self.activePackagesTbl.reloadData()
                self.isDataAvailable = true
            }
        }) { (error) in
            self.stopAnimating()
            self.showAlertWithText(message: error.message)
        }
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
extension TransactionHistoryViewController
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activePackagesArr.count
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3//self.titlesArray.count
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = "activePackagesCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier as String)
        
        //configure your cell
        let contentSubview:UIView = (cell?.contentView.viewWithTag(100))!
//        contentSubview.cornerDesign()
        contentSubview.viewCornerDesign()
        let transactionDict = self.activePackagesArr[indexPath.row]
        let con = "cellWidthConstraint"
        let packageDetailsView:UIView = contentSubview.viewWithTag(102)!
        packageDetailsView.viewCornerDesign()
        let filteredConstraints = contentSubview.constraints.filter { $0.identifier == con }
        if let yourConstraint = filteredConstraints.first {
            // DO YOUR LOGIC HERE
            yourConstraint.constant = (productType.iPad ? 400 : (DeviceType.IS_IPHONE_5 ? 310: 350))
        }  
        let orderIDLabel = packageDetailsView.viewWithTag(1020)! as! UILabel
        let purchaseLabel = packageDetailsView.viewWithTag(1021)! as! UILabel
        let expiryLabel = packageDetailsView.viewWithTag(1022)! as! UILabel
        let packageTypeLabel = packageDetailsView.viewWithTag(1023)! as! UILabel
        let amountLabel = packageDetailsView.viewWithTag(1024)! as! UILabel
        let statusLabel = packageDetailsView.viewWithTag(1026)! as! UILabel
        orderIDLabel.text = String.init(format: "%@", transactionDict.orderId)
        purchaseLabel.text = transactionDict.packageName
        
        orderIDLabel.font = UIFont.ottRegularFont(withSize: 12)
        purchaseLabel.font = UIFont.ottRegularFont(withSize: 12)
        expiryLabel.font = UIFont.ottRegularFont(withSize: 12)
        packageTypeLabel.font = UIFont.ottRegularFont(withSize: 12)
        amountLabel.font = UIFont.ottRegularFont(withSize: 12)
        statusLabel.font = UIFont.ottMediumFont(withSize: 12)
//        expiryLabel.text = "\(Date().getFullDate("\(transactionDict.purchaseTime)", inFormat: "MM/dd/YYYY")) to \(Date().getFullDate("\(transactionDict.expiryTime)", inFormat: "MM/dd/YYYY"))"
        
        expiryLabel.text = transactionDict.purchaseTime.doubleValue.getDateStringFromTimeIntervalWithMonth()
//        expiryLabel.text = "\(Date().getFullDate("\(transactionDict.purchaseTime)")) to \(Date().getFullDate("\(transactionDict.expiryTime)"))"
        packageTypeLabel.text = String.init(format: "%@", transactionDict.gateway)
        //amountLabel.text = ("₹ \(transactionDict.amount)")
        amountLabel.text = ("\(transactionDict.amount) \(transactionDict.currency)")
//        let attributedString = NSMutableAttributedString(string: ("\(transactionDict.amount) \(transactionDict.currency)"), attributes: nil)
//        let attributedString = NSMutableAttributedString(string: ("₹ \(transactionDict.amount)"), attributes: nil)
//        let linkRange = NSRange(location: 0, length: amountLabel.text!.count) // for the word "link" in the string above
//
//        let linkAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "40a1ff"),
//            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
//        ]
//        attributedString.setAttributes(linkAttributes, range: linkRange)
//
//        // Assign attributedText to UILabel
//        amountLabel.attributedText = attributedString
//
//        amountLabel.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
//
//        tapGesture.view?.tag = indexPath.row
//        amountLabel.addGestureRecognizer(tapGesture)
        statusLabel.text = transactionDict.message
        if transactionDict.status.lowercased() == "s" {
            statusLabel.textColor = AppTheme.instance.currentTheme.transactionSuccessColor
        }
        else{
            statusLabel.textColor = AppTheme.instance.currentTheme.transactionFailedtextColor
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.backgroundColor = UIColor.clear
        if indexPath.row + 1 == self.activePackagesArr.count {
            if self.isDataAvailable {
                self.transactionPageNum = self.transactionPageNum + 1
//                self.getTransactionHistory(isLoadingNextData: true)
            }
        }
        contentSubview.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        packageDetailsView.backgroundColor = AppTheme.instance.currentTheme.navigationViewBarColor
        return cell!
    }
    
    @objc func handleLabelTap(_ sender:UITapGestureRecognizer) {
        
        let lbl: UILabel? = (sender.view as? UILabel)
        let cell: UITableViewCell? = (lbl?.superview?.superview?.superview?.superview as? UITableViewCell)
        if let indexPath: IndexPath = activePackagesTbl.indexPath(for: cell!) {
            let vc = TransactionDetailsViewController()
            vc.transactionObj = self.activePackagesArr[indexPath.row]
            vc.delegate = self
            self.presentpopupViewController(vc, animationType: .topBottom, completion: { () -> Void in
            })
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }
}
