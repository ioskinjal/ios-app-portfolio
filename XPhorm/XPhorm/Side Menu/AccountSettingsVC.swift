//
//  AccountSettingsVC.swift
//  XPhorm
//
//  Created by admin on 5/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AccountSettingsVC: BaseViewController {
    
    static var storyboardInstance:AccountSettingsVC? {
        return StoryBoard.sidemenu.instantiateViewController(withIdentifier: AccountSettingsVC.identifier) as? AccountSettingsVC
    }
    @IBOutlet weak var btnEmail: UIButton!
    
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    
    @IBOutlet weak var btnChangePwd: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation(vc: self, isBackButton: true, btnTitle: "", navigationTitle: "Account Settings".localized, action: #selector(onClickMenu(_:)))
       
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        btnChangePwd.setTitle("Change Password".localized, for: .normal)
        btnPaypal.setTitle("Paypal Preferences".localized, for: .normal)
        btnLanguage.setTitle("Language".localized, for: .normal)
        btnEmail.setTitle("Email Notification Settings".localized, for: .normal)
    }
    
    @objc func onClickMenu(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickImage(_ sender:UIButton){
        
    }
    @IBAction func onClickLanguage(_ sender: UIButton) {
        self.navigationController?.pushViewController(LanguageVC.storyboardInstance!, animated: true)
    }
    
    @IBAction func onClickChangePassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(ChangePasswordVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickPaypal(_ sender: UIButton) {
        self.navigationController?.pushViewController(PaypalPreferencesVC.storyboardInstance!, animated: true)
    }
    @IBAction func onClickEmailNotification(_ sender: UIButton) {
        self.navigationController?.pushViewController(NotificationsVC.storyboardInstance!, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
