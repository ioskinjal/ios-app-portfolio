//
//  GDPRPrivacyPopupVC.swift
//  OTT
//
//  Created by Rajesh Nekkanti on 04/02/20.
//  Copyright © 2020 Chandra Sekhar. All rights reserved.
//

import UIKit
import OTTSdk


class GDPRPrivacyPopupVC: UIViewController {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var subStack: UIStackView!
    @IBOutlet weak var okBtnWidthConstrnt: NSLayoutConstraint!
    @IBOutlet weak var popupView : UIView!
    
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        popupView.backgroundColor = AppTheme.instance.currentTheme.applicationBGColor
        messageLbl.textColor = AppTheme.instance.currentTheme.cardTitleColor
        okBtn.backgroundColor = UIColor.getButtonsBackgroundColor()
        radioBtn.setTitleColor(AppTheme.instance.currentTheme.cardTitleColor, for: .normal) 
        if type != nil {
            subStack.isHidden = true
            messageLbl.text = "By interacting with this application, you agree to our Cookie policy"
            messageLbl.textAlignment = .center
            okBtn.setTitle("Ok", for: .normal)
            okBtnWidthConstrnt.constant = 150
        }else {
            subStack.isHidden = false
            messageLbl.text = "We have updated our Privacy policy and Cookie policy. Please agree to the terms to continue watching"
            messageLbl.textAlignment = .left
            okBtn.setTitle("Continue Watching", for: .normal)
            okBtnWidthConstrnt.constant = 250
        }
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        if type != nil {
            UserDefaults.standard.set(true, forKey: "cookiesHasAlreadyLaunched")
            UserDefaults.standard.synchronize()
            AppDelegate.getDelegate().cookiesHasAlreadyLaunched = true
            self.removeAnimate()
        }else {
            self.iAgree()
        }
    }
    
    func iAgree() {
        switch radioBtn.isSelected {
        case true:
            OTTSdk.userManager.userConsentRequest(userId: OTTSdk.preferenceManager.user!.userId, onSuccess: { (responce) in
                Log(message: "Responce ......\(responce)")
                self.removeAnimate()
            }) { (err) in
                Log(message: "Error ......\(err)")
                self.showAlertWithText(String.getAppName(), message: err.message)
            }
        default:
            self.showAlertWithText(String.getAppName(), message: "accept check the box")
        }
    }
    
    
    @IBAction func radioBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            radioBtn.setImage(#imageLiteral(resourceName: "user_profile_checkbox_selected"), for: .selected)
        } else{
            radioBtn.setImage(#imageLiteral(resourceName: "user_profile_checkbox_normal"), for: .normal)
        }
    }
    
    // MARK: - Show alert
    func showAlertWithText (_ header : String = String.getAppName(), message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
