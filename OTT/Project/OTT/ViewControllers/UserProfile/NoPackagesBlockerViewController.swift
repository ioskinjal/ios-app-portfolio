//
//  NoPackagesBlockerViewController.swift
//  OTT
//
//  Created by Chandoo on 14/03/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk

class NoPackagesBlockerViewController: UIViewController {

    
    @IBOutlet weak var oopsImageView: UIImageView!
    @IBOutlet weak var headerLbl1: UILabel!
    @IBOutlet weak var headerLbl2: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailInfo: UILabel!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        self.switchLabel.text = "You want to try with another account ?"
        self.switchLabel.textColor = AppTheme.instance.currentTheme.cardSubtitleColor
        self.headerLbl1.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.headerLbl2.textColor = AppTheme.instance.currentTheme.cardTitleColor
        self.detailInfo.textColor = AppTheme.instance.currentTheme.blockerInfoLabelColor
        detailsView.viewCornerRediusWithTen(color: AppTheme.instance.currentTheme.blockerInfoLabelColor)
    }
    
    @IBAction func backbuttonClicked(_ sender: Any) {
        
    }

    @IBAction func switchAction(_ sender: Any) {
        self.showLogoutAlertWithText(message: "Are you sure you want to Sign out?")
    }
    
    func showAlertWithText (_ header : String = String.getAppName(), message : String,Action:Bool) {
        errorAlert(forTitle: header, message: message, needAction: false) { (flag) in }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                deleteUserConsentOnAgeAndDob()
                if AppDelegate.getDelegate().recordingCardsArr.count > 0{
                    AppDelegate.getDelegate().recordingCardsArr.removeAll()
                }
                OTTSdk.appManager.configuration(onSuccess: { (response) in
                    AppDelegate.getDelegate().configs = response.configs
                    AppDelegate.getDelegate().setConfigResponce(response.configs)

                    let storyBoard = UIStoryboard(name: "Account", bundle: nil)
                    let storyBoardVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    storyBoardVC.viewControllerName = "SignInVC"
                    let nav = UINavigationController.init(rootViewController: storyBoardVC)
                    nav.isNavigationBarHidden = true
                    AppDelegate.getDelegate().window?.rootViewController = nav
    //                TabsViewController.instance.selectedMenuRow = 0
                    if TabsViewController.instance.menus.count > 0 && TabsViewController.instance.menus[TabsViewController.instance.selectedMenuRow].targetPath != "guide"{
                        TabsViewController.instance.getMenuDetails(isFinished: { (isFinished) in
                            self.stopAnimating()
                            self.updateUser()
                            AppDelegate.getDelegate().taggedScreen = "NoPackagesBlocker"
                            LocalyticsEvent.tagScreen(AppDelegate.getDelegate().taggedScreen)
                        })
                    }
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

    func updateUser(){
        if !Utilities.hasConnectivity() {
            self.stopAnimating()
            self.showAlertWithText(message: AppDelegate.getDelegate().genericAlertStr.getInternetMsgStr(), Action: false)
            return
        }
        self.startAnimating(allowInteraction: false)
        OTTSdk.userManager.userInfo(onSuccess: { (response) in
            print(response)
            self.stopAnimating()
            
        }) { (error) in
            Log(message: error.message)
            self.stopAnimating()
        }
    }

}
